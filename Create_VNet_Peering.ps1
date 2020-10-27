Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzContext
Get-AzSubscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

#Create a resource group
New-AzResourceGroup -ResourceGroupName myResourceGroup -Location WestEurope

#Create a virtual network 
$virtualNetwork1 = New-AzVirtualNetwork `
  -ResourceGroupName myResourceGroup `
  -Location WestEurope `
  -Name myVirtualNetwork1 `
  -AddressPrefix 10.0.0.0/16

#Create a subnet configuration
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name Subnet1 `
  -AddressPrefix 10.0.0.0/24 `
  -VirtualNetwork $virtualNetwork1

#Write the subnet configuration to the virtual network
$virtualNetwork1 | Set-AzVirtualNetwork

#Create a virtual network with a 10.1.0.0/16
$virtualNetwork2 = New-AzVirtualNetwork `
  -ResourceGroupName myResourceGroup `
  -Location WestEurope `
  -Name myVirtualNetwork2 `
  -AddressPrefix 10.1.0.0/16

#Create the subnet configuration.
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name Subnet1 `
  -AddressPrefix 10.1.0.0/24 `
  -VirtualNetwork $virtualNetwork2

#Write the subnet configuration to the virtual network.
$virtualNetwork2 | Set-AzVirtualNetwork

#Create a peering, the following example peers myVirtualNetwork1 to myVirtualNetwork2
Add-AzVirtualNetworkPeering `
  -Name myVirtualNetwork1-myVirtualNetwork2 `
  -VirtualNetwork $virtualNetwork1 `
  -RemoteVirtualNetworkId $virtualNetwork2.Id

#Confirm that the peering state
Get-AzVirtualNetworkPeering `
  -ResourceGroupName myResourceGroup `
  -VirtualNetworkName myVirtualNetwork1 `
  | Select PeeringState

=> PeeringState is Initiated

#Create a peering, the following example peers myVirtualNetwork2 to myVirtualNetwork1
Add-AzVirtualNetworkPeering `
  -Name myVirtualNetwork2-myVirtualNetwork1 `
  -VirtualNetwork $virtualNetwork2 `
  -RemoteVirtualNetworkId $virtualNetwork1.Id

#Confirm that the peering state
Get-AzVirtualNetworkPeering `
  -ResourceGroupName myResourceGroup `
  -VirtualNetworkName myVirtualNetwork2 `
  | Select PeeringState

=> PeeringState is Connected

#Clean Up
Remove-AzResourceGroup -Name myResourceGroup -Force
