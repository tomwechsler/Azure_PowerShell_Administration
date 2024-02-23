#Declare variables
$adminUsername = "domadmin"
$adminPassword = ConvertTo-SecureString "yourpassword" -AsPlainText -Force
$resourceGroupName = "tw-prod-rg"
$location = "West Europe"
$vnetName = "tw-prod-vnet"
$subnetName = "Production"
$vmName = "dc01"
$privateIpAddress = "10.10.3.4"

#Create a credential object
$cred = New-Object System.Management.Automation.PSCredential($adminUsername, $adminPassword)

#Create a new VM config
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_B2ms" |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-Datacenter" -Version "latest" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate |
    Add-AzVMNetworkInterface -Id (New-AzNetworkInterface -Name "$vmName-NIC" -ResourceGroupName $resourceGroupName -Location $location -SubnetId (Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork (Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName)).Id).Id

#Create a new VM
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

#Set the private IP address to static
$nic = Get-AzNetworkInterface -Name "$vmName-NIC" -ResourceGroupName $resourceGroupName
$nic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$nic.IpConfigurations[0].PrivateIpAddress = $privateIpAddress
Set-AzNetworkInterface -NetworkInterface $nic