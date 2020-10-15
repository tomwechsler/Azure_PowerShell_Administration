Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "Nutzungsbasierte Bezahlung" | Select-AzSubscription
Get-AzContext

Get-AzADServicePrincipal

Get-AzADServicePrincipal | Select-Object DisplayName | Measure-Object

Get-AzADServicePrincipal | Get-Member

Get-AzADServicePrincipal -First 10 | Select-Object ApplicationId, DisplayName, ID, ServicePrincipalNames

Get-AzADServicePrincipal -ServicePrincipalName 461e8683-5575-4561-ac7f-899cc907d62a

Get-AzADServicePrincipal -SearchString "tw"

Get-AzADApplication

Get-AzADApplication -ObjectId ca7be324-f503-4539-babd-784ace1f0711 | Get-AzADServicePrincipal

Get-AzADAppCredential -ObjectId ca7be324-f503-4539-babd-784ace1f0711


#Remove a service principal by object id
Remove-AzADServicePrincipal -ObjectId 61b5d8ea-fdc6-40a2-8d5b-ad447c678d45

#Remove a service principal by application id
Remove-AzADServicePrincipal -ApplicationId 9263469e-d328-4321-8646-3e3e75d20e76

