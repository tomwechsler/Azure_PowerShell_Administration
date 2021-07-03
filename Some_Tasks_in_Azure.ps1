Set-Location c:\
Clear-Host

#Install the latest version of the PowerShellGet module
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module -Name PowerShellGet -Force -SkipPublisherCheck

#Install the latest version of the Az PowerShell module
Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Check DNS availability
$location = 'westeurope'
Test-AzDnsAvailability -Location $location -DomainNameLabel aaddsadatum

#Register the Microsoft.Compute resource provider
Register-AzResourceProvider -ProviderNamespace 'Microsoft.Compute'

#Verify the registration status
Get-AzResourceProvider -ListAvailable | Where-Object {$_.ProviderNamespace -eq 'Microsoft.Compute'}

#Identify the current usage of vCPUs and the corresponding limits for the StandardDSv3Family and StandardBSFamily
$location = 'westeurope'
Get-AzVMUsage -Location $location | Where-Object {$_.Name.Value -eq 'StandardDSv3Family'}
Get-AzVMUsage -Location $location | Where-Object {$_.Name.Value -eq 'StandardBSFamily'}