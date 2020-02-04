Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

Connect-AzAccount

Get-AzLocation | select Location

# Create a resource group
New-AzResourceGroup `
    -Name tw-azfile-rg `
    -Location westeurope

# Create a storage account
$storageAcct = New-AzStorageAccount `
                  -ResourceGroupName "tw-azfile-rg" `
                  -Name "mystorageacct$(Get-Random)" `
                  -Location westeurope `
                  -SkuName Standard_LRS `
                  -Kind StorageV2

# Create an Azure file share
New-AzStorageShare `
   -Name myshare `
   -Context $storageAcct.Context

# Create directory
New-AzStorageDirectory `
   -Context $storageAcct.Context `
   -ShareName "myshare" `
   -Path "myDirectory"

# this expression will put the current date and time into a new file on your scratch drive
Get-Date | Out-File -FilePath "C:\Temp\SampleUpload.txt" -Force

# this expression will upload that newly created file to your Azure file share
Set-AzStorageFileContent `
   -Context $storageAcct.Context `
   -ShareName "myshare" `
   -Source "C:\Temp\SampleUpload.txt" `
   -Path "myDirectory\SampleUpload.txt"

Get-AzStorageFile -Context $storageAcct.Context -ShareName "myshare" -Path "myDirectory" | Get-AzStorageFile

# Delete an existing file by the same name as SampleDownload.txt, if it exists because you've run this example before
Remove-Item `
     -Path "C:\Temp\SampleUpload.txt" `
     -Force `
     -ErrorAction SilentlyContinue

Get-AzStorageFileContent `
    -Context $storageAcct.Context `
    -ShareName "myshare" `
    -Path "myDirectory\SampleUpload.txt" `
    -Destination "C:\Temp\SampleUpload.txt"

Get-ChildItem -Path "C:\Temp"

# Copy Files
New-AzStorageShare `
    -Name "myshare2" `
    -Context $storageAcct.Context
  
New-AzStorageDirectory `
   -Context $storageAcct.Context `
   -ShareName "myshare2" `
   -Path "myDirectory2"

Start-AzStorageFileCopy `
    -Context $storageAcct.Context `
    -SrcShareName "myshare" `
    -SrcFilePath "myDirectory\SampleUpload.txt" `
    -DestShareName "myshare2" `
    -DestFilePath "myDirectory2\SampleCopy.txt" `
    -DestContext $storageAcct.Context

Get-AzStorageFile -Context $storageAcct.Context -ShareName "myshare2" -Path "myDirectory2" | Get-AzStorageFile


Remove-AzureRmResourceGroup -Name tw-azfile-rg