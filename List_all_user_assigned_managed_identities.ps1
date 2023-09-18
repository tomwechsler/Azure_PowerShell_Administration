#Install the module if needed
Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Output the number and names of user-assigned managed identities.
Write-Host "There are $($UserAssignedIdentities.Count) user-assigned managed identities in your subscription:"
foreach ($UserAssignedIdentity in $UserAssignedIdentities) {
    Write-Host "- $($UserAssignedIdentity.Name)"
}

#Get the permissions for each identity
foreach ($UserAssignedIdentity in $UserAssignedIdentities) {
    Write-Host "Permissions for $($UserAssignedIdentity.Name):"
    
    # Get the role assignments for the identity.
    $RoleAssignments = Get-AzRoleAssignment -ObjectId $UserAssignedIdentity.PrincipalId
    
    foreach ($RoleAssignment in $RoleAssignments) {
        # Get the role assigned to the assignment
        $RoleDefinition = Get-AzRoleDefinition -Id $RoleAssignment.RoleDefinitionId
        
        Write-Host "- $($RoleDefinition.Name)"
    }
}
