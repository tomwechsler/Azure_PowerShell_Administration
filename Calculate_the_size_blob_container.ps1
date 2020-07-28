Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

# this script will show how to get the total size of the blobs in a container
# before running this, you need to create a storage account, create a container,
#    and upload some blobs into the container 


# these are for the storage account to be used
$resourceGroup = "tw-rg100"
$storageAccountName = "twstacc2020"
$containerName = "testblobs"

# get a reference to the storage account and the context
$storageAccount = Get-AzStorageAccount `
  -ResourceGroupName $resourceGroup `
  -Name $storageAccountName
$ctx = $storageAccount.Context 

# get a list of all of the blobs in the container 
$listOfBLobs = Get-AzStorageBlob -Container $ContainerName -Context $ctx 

# zero out our total
$length = 0

# this loops through the list of blobs and retrieves the length for each blob
#   and adds it to the total
$listOfBlobs | ForEach-Object {$length = $length + $_.Length}

# output the blobs and their sizes and the total 
Write-Host "List of Blobs and their size (length)"
Write-Host " " 
$listOfBlobs | select Name, Length
Write-Host " "
Write-Host "Total Length = " $length

#Clean Up
Remove-AzResourceGroup -Name $resourceGroup -Force