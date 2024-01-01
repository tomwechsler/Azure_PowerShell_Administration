#Sign in to your Azure account
Connect-AzAccount

#Set variables
$rgName = "ctt-prod-sta-rg"
$srcAccountName = "cttprodsta2025"
$destAccountName = "cttsta4625"
$srcContainerName1 = "source-container1"
$destContainerName1 = "dest-container1"
$srcContainerName2 = "source-container2"
$destContainerName2 = "dest-container2"

#Enable blob versioning and change feed on the source account
Update-AzStorageBlobServiceProperty -ResourceGroupName $rgName `
    -StorageAccountName $srcAccountName `
    -EnableChangeFeed $true `
    -IsVersioningEnabled $true

#Enable blob versioning on the destination account
Update-AzStorageBlobServiceProperty -ResourceGroupName $rgName `
    -StorageAccountName $destAccountName `
    -IsVersioningEnabled $true

#List the service properties for both accounts
Get-AzStorageBlobServiceProperty -ResourceGroupName $rgName `
    -StorageAccountName $srcAccountName
Get-AzStorageBlobServiceProperty -ResourceGroupName $rgName `
    -StorageAccountName $destAccountName

#Create containers in the source and destination accounts
Get-AzStorageAccount -ResourceGroupName $rgName -StorageAccountName $srcAccountName |
    New-AzStorageContainer $srcContainerName1
Get-AzStorageAccount -ResourceGroupName $rgName -StorageAccountName $destAccountName |
    New-AzStorageContainer $destContainerName1
Get-AzStorageAccount -ResourceGroupName $rgName -StorageAccountName $srcAccountName |
    New-AzStorageContainer $srcContainerName2
Get-AzStorageAccount -ResourceGroupName $rgName -StorageAccountName $destAccountName |
    New-AzStorageContainer $destContainerName2

#Define replication rules for each container
$rule1 = New-AzStorageObjectReplicationPolicyRule -SourceContainer $srcContainerName1 `
    -DestinationContainer $destContainerName1 `
    -PrefixMatch b
$rule2 = New-AzStorageObjectReplicationPolicyRule -SourceContainer $srcContainerName2 `
    -DestinationContainer $destContainerName2  `
    -PrefixMatch b,abc,dd

#Infos about the source storage account    
$srcAccountName = Get-AzStorageAccount -ResourceGroupName $rgName -AccountName $srcAccountName

#Create the replication policy on the destination account
$destPolicy = Set-AzStorageObjectReplicationPolicy -ResourceGroupName $rgName `
    -AccountName $destAccountName `
    -PolicyId default `
    -SourceAccount $srcAccountName.Id `
    -Rule $rule1,$rule2

#Create the same policy on the source account
$srcAccountName = "cttprodsta2025"
Set-AzStorageObjectReplicationPolicy -ResourceGroupName $rgName `
    -StorageAccountName $srcAccountName `
    -InputObject $destPolicy

#Check the Replication-Status
$ctxSrc = (Get-AzStorageAccount -ResourceGroupName $rgName `
    -StorageAccountName $srcAccountName).Context
$blobSrc = Get-AzStorageBlob -Container $srcContainerName1 `
    -Context $ctxSrc `
    -Blob "bdemoscript.ps1"
$blobSrc.BlobProperties.ObjectReplicationSourceProperties[0].Rules[0].ReplicationStatus