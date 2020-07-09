Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Create the resource group
New-AzResourceGroup -Name MyResourceGroup -Location "westeurope"

#Create a DNS zone
New-AzDnsZone -Name tomwechsler.xyz -ResourceGroupName MyResourceGroup

#Create a DNS record
New-AzDnsRecordSet -Name www -RecordType A -ZoneName tomwechsler.xyz -ResourceGroupName MyResourceGroup -Ttl 3600 -DnsRecords (New-AzDnsRecordConfig -IPv4Address "10.10.10.10")

#View records
Get-AzDnsRecordSet -ZoneName tomwechsler.xyz -ResourceGroupName MyResourceGroup

#Get the list of name servers for your zone
Get-AzDnsRecordSet -ZoneName tomwechsler.xyz -ResourceGroupName MyResourceGroup -RecordType ns

#Test the name resolution => Open a command prompt
nslookup www.tomwechsler.xyz ns1-03.azure-dns.com

#Delete all resources
Remove-AzResourceGroup -Name MyResourceGroup -Force