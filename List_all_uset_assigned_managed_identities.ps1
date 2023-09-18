Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription
Get-AzContext

#Get all user assigned managed identities in your subscription
$UserAssignedIdentities = Get-AzUserAssignedIdentity

#Output the number and names of the user assigned managed identities.
Write-Host "There are $($UserAssignedIdentities.Count) user assigned managed identities in your subscription:"
foreach ($UserAssignedIdentity in $UserAssignedIdentities) {
    Write-Host "- $($UserAssignedIdentity.Name)"
}
