Set-Location C:\
Clear-Host

Install-Module -Name Az -Verbose -AllowClobber -Force

#Connect as the managed identity
Connect-AzAccount -Identity

#note the account
Get-AzContext 

#The system assigned MI has read role on the VM object
$VMRG = "tw-rg01"
$VMName = "tw-winsrv"
$vmInfo = Get-AzVM -ResourceGroupName $VMRG -Name $VMName
$spID = $vmInfo.Identity.PrincipalId

Write-Output "The managed identity for Azure resources service principal ID is $spID"

#Look at storage
$storcontext = New-AzStorageContext -StorageAccountName 'twstg00001' -UseConnectedAccount

Get-AzStorageBlobContent -Container 'bilder' -Blob 'IMG_0498.jpg' `
    -Destination "C:\Temp\" -Context $storcontext