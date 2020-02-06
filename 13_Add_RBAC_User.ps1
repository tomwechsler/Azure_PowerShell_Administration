Set-Location C:\
Clear-Host

Install-Module -Name Az -AllowClobber -Scope AllUsers


# Connect to Azure with a browser sign in token
Connect-AzAccount

Get-AzRoleDefinition | FT Name, Description

Get-AzRoleDefinition "Owner"

Get-AzRoleDefinition "Owner" | ConvertTo-Json

Get-AzRoleDefinition "Contributor" | FL Actions, NotActions

(Get-AzRoleDefinition "Virtual Machine Contributor").Actions

Get-AzRoleAssignment

Get-AzRoleAssignment -SignInName tom@tomwechsler.ch | FL DisplayName, RoleDefinitionName, Scope

Get-AzRoleAssignment -SignInName tom@tomwechsler.ch -ExpandPrincipalGroups | FL DisplayName, RoleDefinitionName, Scope

Get-AzRoleAssignment -ResourceGroupName tw-web-rg | FL DisplayName, RoleDefinitionName, Scope

Get-AzSubscription

Get-AzRoleAssignment -Scope /subscriptions/b7491397-4f98-462b-8a2f-9942f9ea9ef7

Get-AzRoleAssignment -IncludeClassicAdministrators

Get-AzADUser -StartsWith 'tom'

New-AzRoleAssignment -SignInName tom@tomwechsler.ch -RoleDefinitionName "Virtual Machine Contributor" -ResourceGroupName tw-web-rg

Get-AzRoleAssignment -SignInName tom@tomwechsler.ch | FL DisplayName, RoleDefinitionName, Scope

Remove-AzRoleAssignment -SignInName tom@tomwechsler.ch -RoleDefinitionName "Virtual Machine Contributor" -ResourceGroupName tw-web-rg