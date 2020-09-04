Set-Location c:\
Clear-Host

Get-InstalledModule -Name "Az"

Install-Module -Name Az -Force -AllowClobber -Verbose

#Prefix for resources
$prefix = "tw"

#Basic variables
$location = "westeurope"
$id = Get-Random -Minimum 1000 -Maximum 9999
$storageaccountname = "$($prefix)sa$id"
$resourceGroup = "$prefix-rg-$id"

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Create a new resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

#Supported regions for your subscription
Get-AzLocation | select Location

#Create a general-purpose v2 storage account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageaccountname `
  -Location $location `
  -SkuName Standard_RAGRS `
  -Kind StorageV2

#Replication option	                                 SkuName parameter

#Locally redundant storage (LRS)	                 Standard_LRS
#Zone-redundant storage (ZRS)	                     Standard_ZRS
#Geo-redundant storage (GRS)	                     Standard_GRS
#Read-access geo-redundant storage (GRS)	         Standard_RAGRS
#Geo-zone-redundant storage (GZRS)	                 Standard_GZRS
#Read-access geo-zone-redundant storage (RA-GZRS)	 Standard_RAGZRS

#Clean Up
Remove-AzResourceGroup -Name $resourceGroup -Force
