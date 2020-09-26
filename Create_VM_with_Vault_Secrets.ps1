Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Basic variables
$location = "westeurope"
$resourceGroup = "myResourceGroup"
$vmName = "myVM"

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "Visual Studio Enterprise-Abonnement" | Select-AzSubscription
Get-AzContext

#Create a resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

#Create a Key Vault
New-AzKeyVault -Name 'tw-vault2020' -ResourceGroupName $resourceGroup -Location $location

#(Optional)Give your user account permissions to manage secrets in Key Vault
Set-AzKeyVaultAccessPolicy -VaultName tw-vault2020 -UserPrincipalName 'user@domain.com' -PermissionsToSecrets get,set,delete

#Adding a secret to Key Vault
$secretvalue = ConvertTo-SecureString 'hVFkk965BuUv' -AsPlainText -Force

$secret = Set-AzKeyVaultSecret -VaultName tw-vault2020 -Name 'SysadminSecret' -SecretValue $secretvalue

Get-AzKeyVaultSecret -VaultName 'tw-vault2020' -Name 'SysadminSecret' | Get-Member

(Get-AzKeyVaultSecret -VaultName 'tw-vault2020' -Name 'SysadminSecret').SecretValueText

#Retreive sysadmin password from KeyVault
$pass = (Get-AzKeyVaultSecret -VaultName tw-vault2020 -Name SysadminSecret).SecretValue

#Build creds for local sysadmin
$u = 'sysadmin'
$cred = New-Object System.Management.Automation.PSCredential ($u, $pass)

#Create a virtual machine
$vmParams = @{
  ResourceGroupName = $resourceGroup
  Location = $location
  Name = $vmName
  ImageName = 'Win2016Datacenter'
  VirtualNetworkName = 'myVnet'
  SubnetName = 'mySubnet'
  PublicIpAddressName = 'myPublicIp'
  SecurityGroupName = "$VMName-SG"
  OpenPorts = 80
  Credential = $cred
}

New-AzVM @vmParams

#Clean Up
Remove-AzResourceGroup -Name $resourceGroup -Force