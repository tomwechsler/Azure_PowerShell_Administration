Set-Location C:\Temp
Clear-Host

#We need the necessary cmdlets
Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzContext
Get-AzSubscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

#First look
Get-AzProviderOperation "Microsoft.Support/*" | FT Operation, Description -AutoSize

#Checking the roles for the intended user 
Get-AzRoleAssignment -Scope "/subscriptions/cff58289-560f-42b2-9bb6-b532d52b928c" -SignInName tim.taylor@tomwechsler.xyz

#Powershell create custom role
$role = Get-AzRoleDefinition "Virtual Machine Contributor"
$role.Id = $null
$role.Name = "VM Reader"
$role.Description = "Can see VMs"
$role.Actions.Clear()
$role.Actions.Add("Microsoft.Storage/*/read")
$role.Actions.Add("Microsoft.Network/*/read")
$role.Actions.Add("Microsoft.Compute/*/read")
$role.AssignableScopes.clear()
$role.AssignableScopes.Add("/subscriptions/cff58289-560f-42b2-9bb6-b532d52b928c")

#Create the new role
New-AzRoleDefinition -Role $role

#Assign the new role
New-AzRoleAssignment -SignInName tim.taylor@tomwechsler.xyz -RoleDefinitionName "VM Reader" -Scope "/subscriptions/cff58289-560f-42b2-9bb6-b532d52b928c"

#Checking the roles for the intended user 
Get-AzRoleAssignment -Scope "/subscriptions/cff58289-560f-42b2-9bb6-b532d52b928c" -SignInName tim.taylor@tomwechsler.xyz