Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Prefix for resources
$prefix = "tw"

#Some variables
$Location = "westeurope"
$id = Get-Random -Minimum 1000 -Maximum 9999

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzContext
Get-AzSubscription
Get-AzSubscription -SubscriptionName "Pay-As-You-Go" | Select-AzSubscription

#Create a resource group
New-AzResourceGroup -Name "myResourceGroup" -Location $Location

#Create a virtual machine
$cred = Get-Credential
New-AzVM -Name MyVm -Credential $cred -ResourceGroupName MyResourceGroup -Image Canonical:UbuntuServer:18.04-LTS:latest -Size Standard_D2S_V3

#Create a Key Vault configured for encryption keys
$keyVaultParameters = @{
    Name = "$prefix-key-vault-$id"
    ResourceGroupName = "MyResourceGroup"
    Location = $location
    EnabledForDiskEncryption = $true
    EnabledForDeployment = $true
    Sku = "Standard"
}

$keyVault = New-AzKeyVault @keyVaultParameters

#Encrypt the virtual machine
$KeyVault = Get-AzKeyVault -VaultName "$prefix-key-vault-$id" -ResourceGroupName "MyResourceGroup"

Set-AzVMDiskEncryptionExtension -ResourceGroupName MyResourceGroup -VMName "MyVM" -DiskEncryptionKeyVaultUrl $KeyVault.VaultUri -DiskEncryptionKeyVaultId $KeyVault.ResourceId -SkipVmBackup -VolumeType All

#You can verify the encryption process
Get-AzVmDiskEncryptionStatus -VMName MyVM -ResourceGroupName MyResourceGroup

#Clean up resources
Remove-AzResourceGroup -Name "myResourceGroup" -Force