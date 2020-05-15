Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

#Select simple properties
Get-AzVM -Name tw-winsrv -ResourceGroupName tw-rg01 | Select-Object *

#Once you know the names of the properties that you're interested in, you can use those property names
Get-AzVM -Name tw-winsrv -ResourceGroupName tw-rg01 | Select-Object Name,VmId,ProvisioningState

#Select nested properties
Get-AzVM -ResourceGroupName tw-rg01 | `
    Select-Object Name,@{Name="OSType"; Expression={$_.StorageProfile.OSDisk.OSType}}

#Filter results
Get-AzVM -ResourceGroupName tw-rg01 | `
    Where-Object {$_.StorageProfile.OSDisk.OSType -eq "Linux"}

#You can pipe the results
Get-AzVM -ResourceGroupName tw-rg01 | `
    Where-Object {$_.StorageProfile.OsDisk.OsType -eq "Linux"} | `
    Select-Object Name,VmID,ProvisioningState

#Table output format
Get-AzVM

Get-AzVM -ResourceGroupName tw-rg01 | Format-Table Name,ResourceGroupName,Location

#List output format
Get-AzVM | Format-List

Get-AzVM | Format-List ResourceGroupName,Name,Location

#Wide output format
Get-AzVM | Format-Wide

Get-AzVM | Format-Wide ResourceGroupName

#Custom output format
Get-AzVM | Format-Custom

Get-AzVM | Format-Custom Name,ResourceGroupName,Location