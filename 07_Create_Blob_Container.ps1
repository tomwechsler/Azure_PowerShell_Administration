Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

Connect-AzAccount

# Are we connected?
Get-AzResourceGroup

Get-AzLocation | select Location
$location = "westeurope"

# Create a resource group
$resourceGroup = "myResourceGroup"
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create a storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name "twstorageazure" `
  -SkuName Standard_LRS `
  -Location $location

$ctx = $storageAccount.Context

# Create a container
$containerName = "quickstartblobs"
New-AzStorageContainer -Name $containerName -Context $ctx -Permission Blob

# Upload blobs to the container
# upload a file
Set-AzStorageBlobContent -File "C:\azure_bilder\Mustang_1.JPG" `
  -Container $containerName `
  -Blob "Mustang_1.JPG" `
  -Context $ctx 

# upload another file
Set-AzStorageBlobContent -File "C:\azure_bilder\Trackhawk_2.jpg" `
  -Container $containerName `
  -Blob "Trackhawk_2.jpg" `
  -Context $ctx

# List the blobs in a container
Get-AzStorageBlob -Container $ContainerName -Context $ctx | select Name

# Download blobs
# download first blob
Get-AzStorageBlobContent -Blob "Mustang_1.JPG" `
  -Container $containerName `
  -Destination "C:\azure_bilder\Downloads\" `
  -Context $ctx 

# download another blob
Get-AzStorageBlobContent -Blob "Trackhawk_2.jpg" `
  -Container $containerName `
  -Destination "C:\azure_bilder\Downloads\" `
  -Context $ctx
