Set-Location C:\
Clear-Host

Install-Module -Name Az -AllowClobber -Scope AllUsers

# https://docs.microsoft.com/en-us/dotnet/framework/install/on-windows-10

Import-Module Az

# Connect to Azure with a browser sign in token
Connect-AzAccount

# Register the resource provider if it's not already registered
Register-AzResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights'

# Get a reference to the resource group that will be the scope of the assignment
$rg = Get-AzResourceGroup -Name 'tw-web-rg'

# Get a reference to the built-in policy definition that will be assigned
$definition = Get-AzPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq 'Audit VMs that do not use managed disks' }

# Create the policy assignment with the built-in definition against your resource group
New-AzPolicyAssignment -Name 'audit-vm-manageddisks' -DisplayName 'Audit VMs without managed disks Assignment' -Scope $rg.ResourceId -PolicyDefinition $definition

# Get the resources in your resource group that are non-compliant to the policy assignment
Get-AzPolicyState -ResourceGroupName $rg.ResourceGroupName -PolicyAssignmentName 'audit-vm-manageddisks' -Filter 'IsCompliant eq false'

Get-AzSubscription

# Removes the policy assignment
Remove-AzPolicyAssignment -Name 'audit-vm-manageddisks' -Scope '/subscriptions/<ihre Subscription ID>/resourceGroups/tw-web-rg'
