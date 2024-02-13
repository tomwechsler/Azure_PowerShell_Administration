#Declare variables
$adminUsername = "domadmin"
$adminPassword = ConvertTo-SecureString "your" -AsPlainText -Force
$resourceGroupName = "tw-prod-rg"
$location = "West Europe"
$vnetName = "tw-prod-vnet"
$subnetName = "Production"
$vmName = "dc01"

#Create a credential object
$cred = New-Object System.Management.Automation.PSCredential($adminUsername, $adminPassword)

#Get the image publisher
$imagePublisher = Get-AzVMImagePublisher -Location $location | Where-Object { $_.PublisherName -eq "MicrosoftWindowsServer" }

#Get the image offer
$imageOffer = Get-AzVMImageOffer -Location $location -PublisherName $imagePublisher.PublisherName | Where-Object { $_.Offer -eq "WindowsServer" }

#Get the image SKU
$imageSku = Get-AzVMImageSku -Location $location -PublisherName $imagePublisher.PublisherName -Offer $imageOffer.Offer | Where-Object { $_.Skus -eq "2022-Datacenter" }

#Get the latest version of the image
$imageVersion = (Get-AzVMImage -Location $location -PublisherName $imagePublisher.PublisherName -Offer $imageOffer.Offer -Skus $imageSku.Skus | Sort-Object Version -Descending)[0].Version

#Create a new VM config
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_B2ms"

#Set the source image
$vmConfig = Set-AzVMSourceImage -VM $vmConfig -PublisherName $imagePublisher.PublisherName -Offer $imageOffer.Offer -Skus $imageSku.Skus -Version $imageVersion

#Set the operating system
$vmConfig = Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate

#Get the virtual network
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName

#Get the subnet
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

#Set the network interface
$nic = New-AzNetworkInterface -Name "$vmName-NIC" -ResourceGroupName $resourceGroupName -Location $location -SubnetId $subnet.Id
$vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id

#Create a new VM
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

#Run the PowerShell script Setup_DC.ps1 via an Azure VM Extension
Set-AzVMExtension -ExtensionName "Setup_DC" -ResourceGroupName $resourceGroupName -VMName $vmName -Publisher "Microsoft.Compute" -ExtensionType "CustomScriptExtension" -TypeHandlerVersion 1.9 -SettingString "{'fileUris':['https://twsta1045.blob.core.windows.net/scripts/Setup_DC.ps1'],'commandToExecute':'powershell -ExecutionPolicy Unrestricted -File Setup_DC.ps1'}" -Location $location