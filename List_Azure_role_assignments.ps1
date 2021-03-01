Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Azure resources role-based access control (Azure RBAC)

#View Role Assignment
Get-AzRoleAssignment | Format-Table

#List role assignments for a subscription
Get-AzRoleAssignment -Scope /subscriptions/00000000-0000-0000-0000-000000000000

#List role assignments for a user
Get-AzRoleAssignment -SignInName jane.ford@tomwechsler.ch | FL DisplayName, RoleDefinitionName, Scope

#Another way
Get-AzRoleAssignment -SignInName jane.ford@tomwechsler.ch -ExpandPrincipalGroups | FL DisplayName, RoleDefinitionName, Scope

#List role assignments for a resource group
Get-AzRoleAssignment -ResourceGroupName TW-EXCHANGE-PROJECT-RG | FL DisplayName, RoleDefinitionName, Scope

#List role assignments for a management group
Get-AzRoleAssignment -Scope /providers/Microsoft.Management/managementGroups/marketing-group

#List role assignments for a resource
Get-AzRoleAssignment -Scope "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/storage-test-rg/providers/Microsoft.Storage/storageAccounts/storagetest0122"

#If you want to just list role assignments that are assigned directly on a resource
Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/storage-test-rg/providers/Microsoft.Storage/storageAccounts/storagetest0122"}

#List role assignments for classic service administrator and co-administrators
Get-AzRoleAssignment -IncludeClassicAdministrators

#Azure Actice Directory (AD) role-based access control (Azure RBAC)

#We install the Azure AD PowerShell module
Install-Module AzureADPreview -Verbose -Force -AllowClobber

#And import
Import-Module AzureADPreview

#To verify that the module is ready to use
Get-Module AzureADPreview

#We connect
Connect-AzureAD

#Fetch list of all directory roles with object ID
Get-AzureADDirectoryRole

#Fetch a specific directory role by ID
$role = Get-AzureADDirectoryRole -ObjectId "5b3fe201-fa8b-4144-b6f1-875829ff7543"

#Fetch role membership for a role
Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Get-AzureADUser