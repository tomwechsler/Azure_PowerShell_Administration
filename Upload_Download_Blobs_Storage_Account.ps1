Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

Get-AzLocation | select Location
$location = "westeurope"

$resourceGroup = "myResourceGroup"
New-AzResourceGroup -Name $resourceGroup -Location $location

#Create a storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name "tw75mystorageaccount" `
  -SkuName Standard_LRS `
  -Location $location `

$ctx = $storageAccount.Context

#Create a container
$containerName = "quickstartblobs"
New-AzStorageContainer -Name $containerName -Context $ctx -Permission blob

#Upload blobs to the container
#Upload a file
Set-AzStorageBlobContent -File "C:\Users\admin\Desktop\Bilder\IMG_0498.jpg" `
  -Container $containerName `
  -Blob "IMG_0498.jpg" `
  -Context $ctx 

#Upload another file
Set-AzStorageBlobContent -File "C:\Users\admin\Desktop\Bilder\IMG_0406.jpg" `
  -Container $containerName `
  -Blob "IMG_0406.jpg" `
  -Context $ctx

#List the blobs in a container
Get-AzStorageBlob -Container $ContainerName -Context $ctx | select Name

#Download blobs
# download first blob
Get-AzStorageBlobContent -Blob "IMG_0498.jpg" `
  -Container $containerName `
  -Destination "C:\Users\admin\Desktop\Bilder\Downloads\" `
  -Context $ctx 

#Download another blob
Get-AzStorageBlobContent -Blob "IMG_0406.jpg" `
  -Container $containerName `
  -Destination "C:\Users\admin\Desktop\Bilder\Downloads\" `
  -Context $ctx