Clear-Host
Set-Location c:\

#Install the AzureAD Module
Find-Module AzureAD

Install-Module -Name AzureAD

Import-Module -Name AzureAD
#Get credentials to connect
$AzureADCredentials = Get-Credential -Message "Credentials to connect to Azure AD"

#Connect to the Azure AD tenant
Connect-AzureAD -Credential $AzureADCredentials

#Get info about the current session
Get-AzureADCurrentSessionInfo

#Get Information about the tenant and domain
Get-AzureADTenantDetail

Get-AzureADDomain



