#Create some space in the terminal
Set-Location c:\
Clear-Host

#Install the Az module
Install-Module -Name Az -Force -AllowClobber -Verbose

#Connect to Azure
Connect-AzAccount

#List the available subscriptions
Get-AzSubscription

#Declare variables
$resourceGroupName = "tw-prod-rg"
$location = "West Europe"
$vnetName = "tw-prod-vnet"
$subnetName0 = "AzureBastionSubnet"
$subnetName1 = "AzureFirewallSubnet"
$subnetName3 = "Production"

#Create a new resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

#Create a new subnet configuration
$subnetConfig0 = New-AzVirtualNetworkSubnetConfig -Name $subnetName0 -AddressPrefix 10.10.0.0/26
$subnetConfig1 = New-AzVirtualNetworkSubnetConfig -Name $subnetName1 -AddressPrefix 10.10.1.0/26
$subnetConfig3 = New-AzVirtualNetworkSubnetConfig -Name $subnetName3 -AddressPrefix 10.10.3.0/24

#Create a new virtual network
New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix 10.10.0.0/16 -Subnet $subnetConfig0, $subnetConfig1, $subnetConfig3

#Get the virtual network
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName

#Set the DNS server
$vnet.DhcpOptions.DnsServers = "10.10.3.4"

#Update the virtual network
Set-AzVirtualNetwork -VirtualNetwork $vnet