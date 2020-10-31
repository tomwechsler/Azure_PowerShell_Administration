Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Variables
$location = "westeurope"
$rgname = "twstoragedemo"

#A file we use later
$today = Get-Date
New-Item -ItemType file -Path C:\Temp\test.txt -Force -value $today

#Create a Resource Group
New-AzResourceGroup -Name $rgname -Location $location

#Create a Storage Account
New-AzStorageAccount -Location $location -ResourceGroupName $rgname -Name twstorage75 -SkuName Standard_LRS

#We need at least one Storage Account Key
$keys = Get-AzStorageAccountKey -Name twstorage75 -ResourceGroupName $rgname

#Now we need to create Storage context
$context = New-AzStorageContext -StorageAccountName twstorage75 -StorageAccountKey $keys[0].Value

#Once we have it, let’s create a storage container
New-AzStorageContainer -Context $context -Name bilder

#Now we have required pre-requisites to create an SAS
$token = New-AzStorageContainerSASToken -Context $context -Name bilder -Permission rwd

#Now we need to create Storage Container context
$containercontext = New-AzStorageContext -SasToken $token -StorageAccountName twstorage75

#Let's upload a file to the Storage Container
Set-AzStorageBlobContent -Context $containercontext -Container bilder -File C:\Temp\test.txt

#List the blobs in the container
Get-AzStorageBlob -Container bilder -Context $context | select Name, Blobtype, LastModified

#Clean Up
Remove-AzResourceGroup -Name $rgname -Force