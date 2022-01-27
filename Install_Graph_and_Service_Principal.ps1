Set-Location C:\
Clear-Host

#https://docs.microsoft.com/en-us/graph/powershell/installation

#For a list of available Microsoft Graph modules 
Find-Module Microsoft.Graph*

#Install the module
Install-Module Microsoft.Graph -Verbose -AllowClobber -Force


#Look at all the service principals
#region ServicePrincipals

#Connect
#Each API in graph has a certain permission scope required

#https://docs.microsoft.com/en-us/graph/permissions-reference
#Application.Read.All to read the service principals
Connect-MgGraph -Scopes "Application.Read.All"

#Switch to beta profile to light up features
Select-MgProfile -Name "beta"

#View my scope
Get-MgContext #note my TenantId
(Get-MgContext).Scopes

#Environments, i.e. various clouds
Get-MgEnvironment

#View a regular app registration and its service principal
Get-MgApplication -Filter  "DisplayName eq 'twwebapp2021'"

Get-MgServicePrincipal -Filter "DisplayName eq 'twwebapp2021'" |
    Format-Table DisplayName, Id, AppId, SignInAudience, AppOwnerOrganizationId

#Same for an enterprise application that is enabled in my tenant
Get-MgServicePrincipal -Filter "DisplayName eq 'AWS Single-Account Access' or DisplayName eq 'Microsoft Teams'" |
    Format-Table DisplayName, Id, AppId, SignInAudience, AppOwnerOrganizationId

#View all managed identities. Note the different types of resource
Get-MgServicePrincipal -Filter "ServicePrincipalType eq 'ManagedIdentity'" |
    Format-Table DisplayName, Id, AlternativeNames -AutoSize