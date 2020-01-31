Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

Connect-AzAccount
Get-AzSubscription
Set-AzContext -Subscription ID

#Create resource group
New-AzResourceGroup -Name myResourceGroupVM -Location "westeurope"

$cred = Get-Credential

#Create a VM
New-AzVm `
    -ResourceGroupName "myResourceGroupVM" `
    -Name "myVM" `
    -Location "WestEurope" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -Credential $cred

#Connect to VM
Get-AzPublicIpAddress `
   -ResourceGroupName "myResourceGroupVM"  | Select IpAddress

mstsc /v:<publicIpAddress>

#Understand marketplace images
Get-AzVMImagePublisher -Location "WestEurope"

Get-AzVMImageOffer `
   -Location "WestEurope" `
   -PublisherName "MicrosoftWindowsServer"

Get-AzVMImageSku `
   -Location "WestEurope" `
   -PublisherName "MicrosoftWindowsServer" `
   -Offer "WindowsServer"

New-AzVm `
    -ResourceGroupName "myResourceGroupVM" `
    -Name "myVM2" `
    -Location "WestEurope" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress2" `
    -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-with-Containers:latest" `
    -Credential $cred `
    -AsJob

#Understand VM sizes
Get-AzVMSize -Location "WestEurope"

#Resize a VM

Get-AzVM -ResourceGroupName "myResourceGroupVM"

$vm = Get-AzVM `
   -ResourceGroupName "myResourceGroupVM"  `
   -VMName "myVM"
$vm.HardwareProfile.VmSize = "Standard_DS3_v2"
Update-AzVM `
   -VM $vm `
   -ResourceGroupName "myResourceGroupVM"

#If the size you want isn't available on the current cluster, the VM needs to be deallocated before the resize operation can occur. 

Stop-AzVM `
   -ResourceGroupName "myResourceGroupVM" `
   -Name "myVM" -Force
$vm = Get-AzVM `
   -ResourceGroupName "myResourceGroupVM"  `
   -VMName "myVM"
$vm.HardwareProfile.VmSize = "Standard_E2s_v3"
Update-AzVM -VM $vm `
   -ResourceGroupName "myResourceGroupVM"
Start-AzVM `
   -ResourceGroupName "myResourceGroupVM"  `
   -Name $vm.name

#VM power states
Get-AzVM `
    -ResourceGroupName "myResourceGroupVM" `
    -Name "myVM" `
    -Status | Select @{n="Status"; e={$_.Statuses[1].Code}}

#Management tasks
Stop-AzVM `
   -ResourceGroupName "myResourceGroupVM" `
   -Name "myVM" -Force

Start-AzVM `
   -ResourceGroupName "myResourceGroupVM" `
   -Name "myVM"

Remove-AzResourceGroup `
   -Name "myResourceGroupVM" `
   -Force



#https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm