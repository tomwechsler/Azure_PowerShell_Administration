Set-Location c:\
Clear-Host

# Install Powershell Modules
Install-Module Az -Verbose -Force -AllowClobber

# Connect to azure
Connect-AzAccount

Get-AzContext
Get-AzSubscription
Set-AzContext

# Are we connected?
Get-AzResourceGroup

# put resource group in a variable so you can use the same group name going forward,
# without hard-coding it repeatedly

Get-AzLocation | select Location

$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
$location = Read-Host -Prompt "Enter the location (i.e. centralus)"
$storageAccountName = Read-Host -Prompt "Enter the storage account name"

# Create the storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location $location `
  -SkuName "Standard_RAGRS" `
  -Kind StorageV2

# Retrieve the context
$ctx = $storageAccount.Context

Disconnect-AzAccount