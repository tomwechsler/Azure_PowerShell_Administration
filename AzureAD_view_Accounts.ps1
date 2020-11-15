Set-Location c:\
Clear-Host

Install-Module -Name AzureAD -AllowClobber -Force -Verbose

Import-Module AzureAD

#Username and PW for Login
$Credential = Get-Credential

Connect-AzureAD -Credential $Credential

#View all accounts
Get-AzureADUser

#View a specific account
Get-AzureADUser -ObjectID jane.ford@tomwechsler.xyz

#View additional property values for a specific account
Get-AzureADUser | Get-Member

Get-AzureADUser | Select DisplayName,Department,UsageLocation

#To see all the properties for a specific user account
Get-AzureADUser -ObjectID jane.ford@tomwechsler.xyz | Select *

#As another example, check the enabled status of a specific user account
Get-AzureADUser -ObjectID jane.ford@tomwechsler.xyz | Select DisplayName,UserPrincipalName,AccountEnabled

#View account synchronization status
Get-AzureADUser | Where {$_.DirSyncEnabled -eq $true}

#You can use it to find cloud-only accounts
Get-AzureADUser | Where {$_.DirSyncEnabled -ne $false}

#View accounts based on a common property
Get-AzureADUser | Where {$_.UsageLocation -eq $Null}

#List all accounts of users who live in London
Get-AzureADUser | Where {$_.City -eq "Oberbuchsiten"}