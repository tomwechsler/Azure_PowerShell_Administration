Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

Connect-AzAccount
Get-AzContext
Get-AzSubscription
Set-AzContext -Subscription 83bedf1c-859c-471d-831a-fae20a378f44
#Create a resource group
New-AzResourceGroup -Name myResourceGroup -Location WestEurope

#Create the virtual network
$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName myResourceGroup `
  -Location WestEurope `
  -Name myVirtualNetwork `
  -AddressPrefix 192.168.0.0/16

#Add a subnet
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name default `
  -AddressPrefix 192.168.0.0/24 `
  -VirtualNetwork $virtualNetwork

#Associate the subnet to the virtual network
$virtualNetwork | Set-AzVirtualNetwork

#Create virtual machines
New-AzVm `
    -ResourceGroupName "myResourceGroup" `
    -Location "WestEurope" `
    -VirtualNetworkName "myVirtualNetwork" `
    -SubnetName "default" `
    -Name "myVm1" `
    -AsJob

Get-Job

New-AzVm `
    -ResourceGroupName "myResourceGroup" `
    -Location "WestEurope" `
    -VirtualNetworkName "myVirtualNetwork" `
    -SubnetName "default" `
    -Name "myVm2"

#Connect to a VM from the internet
Get-AzPublicIpAddress `
  -Name myVm1 `
  -ResourceGroupName myResourceGroup `
  | Select IpAddress

Get-AzPublicIpAddress `
  -Name myVm2 `
  -ResourceGroupName myResourceGroup `
  | Select IpAddress

  
mstsc /v:13.95.209.251




Remove-AzResourceGroup -Name myResourceGroup -Force