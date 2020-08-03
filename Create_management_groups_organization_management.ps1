Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

#Create a management group
New-AzManagementGroup -GroupName 'Contoso'

#If you want the management group to show a different name within the Azure portal, add the DisplayName parameter
New-AzManagementGroup -GroupName 'TomRocks' -DisplayName 'TomRocks Group'

#To specify a different management group as the parent, use the ParentId parameter
$parentGroup = Get-AzManagementGroup -GroupName TomRocks
New-AzManagementGroup -GroupName 'TomRocksSubGroup' -ParentId $parentGroup.id

#Change the name
Update-AzManagementGroup -GroupName 'TomRocks' -DisplayName 'Wechsler Group'

#To delete management group
Remove-AzManagementGroup -GroupName 'TomRocks'

#To retrieve all groups
Get-AzManagementGroup

#For a single management group's information
Get-AzManagementGroup -GroupName 'Contoso'

#To return a specific management group and all the levels of the hierarchy under it
$response = Get-AzManagementGroup -GroupName TestGroupParent -Expand -Recurse
$response