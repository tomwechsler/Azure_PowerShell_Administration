Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Azure Recovery Service provider
Register-AzResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"

#the resource group is myResourceGroup, the VM is myVM and they exist already

#create a recovery service vault
New-AzRecoveryServicesVault `
    -ResourceGroupName "myResourceGroup" `
    -Name "myRecoveryServicesVault" `
-Location "WestEurope"

#Set the vault context
Get-AzRecoveryServicesVault `
    -Name "myRecoveryServicesVault" | Set-AzRecoveryServicesVaultContext

#Change the storage redundancy configuration (LRS/GRS)
Get-AzRecoveryServicesVault `
    -Name "myRecoveryServicesVault" | Set-AzRecoveryServicesBackupProperty -BackupStorageRedundancy GeoRedundant
#Storage Redundancy can be modified only if there are no backup items protected to the vault

#Enable backup for an Azure VM
#First, set the default policy
$policy = Get-AzRecoveryServicesBackupProtectionPolicy -Name "DefaultPolicy"

#Enable VM backup
Enable-AzRecoveryServicesBackupProtection `
    -ResourceGroupName "myResourceGroup" `
    -Name "myVM" `
    -Policy $policy

#Start a backup job
#Backups run according to the schedule specified in the backup policy.

#The first initial backup job creates a full recovery point.
#After the initial backup, each backup job creates incremental recovery points.
#Incremental recovery points are storage and time-efficient, as they only transfer changes made since the last backup.

#Specify the container, obtain VM information, and run the backup
$backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName "myVM"

$item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"

Backup-AzRecoveryServicesBackupItem -Item $item

#You might need to wait up to 20 minutes, since the first backup job creates a full recovery point. Monitor the job as described in the next procedure
Get-AzRecoveryservicesBackupJob

#Clean up the deployment 
Disable-AzRecoveryServicesBackupProtection -Item $item -RemoveRecoveryPoints
#Disable Softdelte in the Portal
#Undelete the VM Backup
#Delete the Backup Data
$vault = Get-AzRecoveryServicesVault -Name "myRecoveryServicesVault"
Remove-AzRecoveryServicesVault -Vault $vault
Remove-AzResourceGroup -Name "myResourceGroup"