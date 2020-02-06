Clear-Host
Set-Location c:\

Connect-AzAccount

Get-AzSubscription

Get-AzRoleDefinition | ft
 
$customrole = Get-AzRoleDefinition "Virtual Machine Contributor"
$customrole.Id = $null
$customrole.Name = "Virtual Machine Starter"
$customrole.Description = "Provides the ability to start a virtual machine."
$customrole.Actions.Clear()
$customrole.Actions.Add("Microsoft.Storage/*/read")
$customrole.Actions.Add("Microsoft.Network/*/read")
$customrole.Actions.Add("Microsoft.Compute/*/read")
$customrole.Actions.Add("Microsoft.Compute/virtualMachines/start/action")
$customrole.Actions.Add("Microsoft.Authorization/*/read")
$customrole.Actions.Add("Microsoft.Resources/subscriptions/resourceGroups/read")
$customrole.Actions.Add("Microsoft.Insights/alertRules/*")
$customrole.AssignableScopes.Clear()
$customrole.AssignableScopes.Add("/subscriptions/b8e8ea82-7d28-4438-b50e-fbcf18d04346")
 
New-AzRoleDefinition -Role $customrole 
