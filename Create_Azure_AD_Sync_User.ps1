Set-Location c:\
Clear-Host

#We need the cmdlets
Install-Module -Name AzureAD -AllowClobber -Force -Verbose

#Sometimes the module must be imported
Import-Module AzureAD

#Username and PW for Login
$Credential = Get-Credential

#Lets connect to the Azure Active Directory
Connect-AzureAD -Credential $Credential

#View all accounts
Get-AzureADUser

#Some varibales
$userName = 'aadsyncuser'
$aadDomainName = ((Get-AzureAdTenantDetail).VerifiedDomains)[0].Name

#Create password profile
$passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$passwordProfile.Password = 'Pa55w.rd1234'
$passwordProfile.ForceChangePasswordNextLogin = $false

#Create the user
New-AzureADUser -AccountEnabled $true -DisplayName $userName -PasswordProfile $passwordProfile -MailNickName $userName -UserPrincipalName "$userName@$aadDomainName"

#Some more variables
$aadUser = Get-AzureADUser -ObjectId "$userName@$aadDomainName"
$aadRole = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Global administrator'} 

#Set the role
Add-AzureADDirectoryRoleMember -ObjectId $aadRole.ObjectId -RefObjectId $aadUser.ObjectId

#Identify the user principal name
(Get-AzureADUser -Filter "MailNickName eq '$userName'").UserPrincipalName
