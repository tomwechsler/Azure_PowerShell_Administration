

#Get all user assigned managed identities in your subscription
$UserAssignedIdentities = Get-AzUserAssignedIdentity

#Output the number and names of the user assigned managed identities.
Write-Host "There are $($UserAssignedIdentities.Count) user assigned managed identities in your subscription:"
foreach ($UserAssignedIdentity in $UserAssignedIdentities) {
    Write-Host "- $($UserAssignedIdentity.Name)"
}
