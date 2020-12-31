Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Some variables
$RgName = "tw-rg01" 
$vmName = "tw-win2019" 
$Location = "westeurope"

#Infos about the vm's
Get-AzVM

#Get VM status and add results to variable
$AllVMs = Get-AzVM -ResourceGroupName $RgName -Status | Select-Object ResourceGroupName,Name,Location, @{ label = "VMStatus"; Expression = { $_.PowerState } } 
 
#Or get VM status where server names match VM and add results to variable
$AllVMs = Get-AzVM -ResourceGroupName $RgName -Status | Where-Object {$_.name -match "tw"} | Select-Object ResourceGroupName,Name,Location, @{ label = "VMStatus"; Expression = { $_.PowerState } } 
 
#Display results in console
$AllVMs | Format-Table -Auto -Wrap
 
#Display results in new window
$AllVMs | Out-GridView -Title "Azure VMs"
 
#Display running VMs in console
$AllVMs | Where-Object {$_.VMStatus -eq "VM running"}

#We start just one vm
Start-AzVM -ResourceGroupName $RgName -Name $vmName

#Display running VMs in console
$AllVMs | Where-Object {$_.VMStatus -eq "VM running"}

#List VMs in a resource group
Get-AzVM -ResourceGroupName $RgName

#Get information about a VM
Get-AzVM -ResourceGroupName $RgName -Name $vmName

#Stop a VM
Stop-AzVM -ResourceGroupName $RgName -Name $vmName

#Display results in console
$AllVMs | Format-Table -Auto -Wrap

#Restart a running VM
Restart-AzVM -ResourceGroupName $RgName -Name $vmName

#Get all virtual machines in the location
Get-AzVM -Location $Location