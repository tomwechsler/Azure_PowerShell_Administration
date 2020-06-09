Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Create a resource group
New-AzResourceGroup -Name myResourceGroup -Location WestEurope

#Create the VM
$vM = New-AzVm `
    -ResourceGroupName "myResourceGroup" `
    -Name "myVm" `
    -Location "WestEurope"

#If you don't already have a network watcher enabled in the West Europe region
$networkWatcher = New-AzNetworkWatcher `
  -Name "NetworkWatcher_westeurope" `
  -ResourceGroupName "NetworkWatcherRG" `
  -Location "WestEurope"

#Network watcher
$networkWatcher = Get-AzNetworkWatcher `
  -Name NetworkWatcher_westeurope `
  -ResourceGroupName NetworkWatcherRG

#Use IP flow verify
Test-AzNetworkWatcherIPFlow `
  -NetworkWatcher $networkWatcher `
  -TargetVirtualMachineId $vM.Id `
  -Direction Outbound `
  -Protocol TCP `
  -LocalIPAddress 192.168.1.4 `
  -LocalPort 60000 `
  -RemoteIPAddress 13.107.21.200 `
  -RemotePort 80

#After several seconds, the result returned informs you that access is allowed by a security rule named AllowInternetOutbound.

#Test outbound communication from the VM to 172.31.0.100
Test-AzNetworkWatcherIPFlow `
  -NetworkWatcher $networkWatcher `
  -TargetVirtualMachineId $vM.Id `
  -Direction Outbound `
  -Protocol TCP `
  -LocalIPAddress 192.168.1.4 `
  -LocalPort 60000 `
  -RemoteIPAddress 172.31.0.100 `
  -RemotePort 80

#The result returned informs you that access is denied by a security rule named DefaultOutboundDenyAll

#Test inbound communication to the VM from 172.31.0.100
Test-AzNetworkWatcherIPFlow `
  -NetworkWatcher $networkWatcher `
  -TargetVirtualMachineId $vM.Id `
  -Direction Inbound `
  -Protocol TCP `
  -LocalIPAddress 192.168.1.4 `
  -LocalPort 80 `
  -RemoteIPAddress 172.31.0.100 `
  -RemotePort 60000

#The result returned informs you that access is denied because of a security rule named DenyAllInBound

#View details of a security rule
Get-AzEffectiveNetworkSecurityGroup `
  -NetworkInterfaceName myVm `
  -ResourceGroupName myResourceGroup

#Clean up
Remove-AzResourceGroup -Name myResourceGroup -Force