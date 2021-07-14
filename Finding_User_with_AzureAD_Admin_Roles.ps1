Set-Location c:\
Clear-Host

#We need the cmdlets
Install-Module -Name AzureAD -AllowClobber -Force -Verbose

#Sometimes the module must be imported
Import-Module AzureAD

#Let's connect
Connect-AzureAD

#To explore the available cmdlets in the Azure AD module
Get-Command -Module AzureAD | Measure-Object

#Fetch list of all directory roles with object ID
Get-AzureADDirectoryRole

#Fetch a specific directory role by ID
$role = Get-AzureADDirectoryRole -ObjectId "6fd5c3ac-2e62-4fca-84fe-9e32ae5282f2"

#Fetch role membership for a role
Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Get-AzureADUser

#Lets create some variables
$roleUsers = @() 
$roles=Get-AzureADDirectoryRole

#We use a loop  
ForEach($role in $roles) {
  $users=Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId
  ForEach($user in $users) {
    write-host $role.DisplayName,$user.DisplayName,$user.UsageLocation
    $obj = New-Object PSCustomObject
    $obj | Add-Member -type NoteProperty -name RoleName -value ""
    $obj | Add-Member -type NoteProperty -name UserDisplayName -value ""
    $obj | Add-Member -type NoteProperty -name UsageLocation -value ""
    $obj.RoleName=$role.DisplayName
    $obj.UserDisplayName=$user.DisplayName
    $obj.UsageLocation=$user.UsageLocation
    $roleUsers+=$obj
  }
}

#We have a result
$roleUsers

#A bit more readable
$roleUsers | Sort-Object Userdisplayname | select Userdisplayname, RoleName

#Remove the session
Disconnect-AzureAD