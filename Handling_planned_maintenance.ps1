Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Maintenance information is returned only if there is maintenance planned
Get-AzVM -ResourceGroupName tw-rg01 -Name tw-winsrv -Status

#Example output
  MaintenanceRedeployStatus             : 
  IsCustomerInitiatedMaintenanceAllowed : True
  PreMaintenanceWindowStartTime         : 5/14/2020 12:30:00 PM
  PreMaintenanceWindowEndTime           : 5/19/2020 12:30:00 PM
  MaintenanceWindowStartTime            : 5/21/2020 4:30:00 PM
  MaintenanceWindowEndTime              : 6/4/2020 4:30
  LastOperationResultCode               : None

#The following example takes your subscription ID and returns a list of 
#VMs that are scheduled for maintenance.

function MaintenanceIterator
{
    Select-AzSubscription -SubscriptionId $args[0]

    $rgList= Get-AzResourceGroup 

    for ($rgIdx=0; $rgIdx -lt $rgList.Length ; $rgIdx++)
    {
        $rg = $rgList[$rgIdx]        
	$vmList = Get-AzVM -ResourceGroupName $rg.ResourceGroupName 
        for ($vmIdx=0; $vmIdx -lt $vmList.Length ; $vmIdx++)
        {
            $vm = $vmList[$vmIdx]
            $vmDetails = Get-AzVM -ResourceGroupName $rg.ResourceGroupName -Name $vm.Name -Status
              if ($vmDetails.MaintenanceRedeployStatus )
            {
                Write-Output "VM: $($vmDetails.Name)  IsCustomerInitiatedMaintenanceAllowed: $($vmDetails.MaintenanceRedeployStatus.IsCustomerInitiatedMaintenanceAllowed) $($vmDetails.MaintenanceRedeployStatus.LastOperationMessage)"               
            }
          }
    }
}

#Using information from the function in the previous section, the following starts maintenance 
#on a VM if IsCustomerInitiatedMaintenanceAllowed is set to true
Restart-AzVM -PerformMaintenance -Name $vm.Name -ResourceGroupName $rg.ResourceGroupName