#Use Windows PowerShell ISE or Azure Cloud Shell

#Install AzureAD
Install-Module -Name AzureAD -AllowClobber -Verbose -Force

#Parameters
$SourceAccount = "AdeleV@63k57q.onmicrosoft.com"
$TargetAccount = "LeeG@63k57q.onmicrosoft.com"
 
#Connect to Azure AD
Connect-AzureAD
 
#Get the source and target users
$SourceUser = Get-AzureADUser -Filter "UserPrincipalName eq '$SourceAccount'"
$TargetUser = Get-AzureADUser -Filter "UserPrincipalName eq '$TargetAccount'"
 
#Check if source and target users are valid
If($SourceUser -ne $Null -and $TargetUser -ne $Null)
{
    #Get all memberships of the source user
    $SourceMemberships = Get-AzureADUserMembership -ObjectId $SourceUser.ObjectId | Where-object { $_.ObjectType -eq "Group" }
 
    #Loop through each group
    ForEach($Membership in $SourceMemberships)
    {
        #Check if the user is not part of the group
        $GroupMembers = (Get-AzureADGroupMember -ObjectId $Membership.Objectid).UserPrincipalName
        If ($GroupMembers -notcontains $TargetAccount)
        {
            #Add target user to the source user's group
            Add-AzureADGroupMember -ObjectId $Membership.ObjectId -RefObjectId $TargetUser.ObjectId
            Write-host "User added to the group:" $Membership.DisplayName
        }
    }
}
Else
{
    Write-host "Invalid source or target user!" -f Yellow
}
