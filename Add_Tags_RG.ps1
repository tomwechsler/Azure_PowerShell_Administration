Set-Location C:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

#Tags
(Get-AzResourceGroup -Name tw-rg01).Tags

(Get-AzResource -ResourceName tw-winsrv -ResourceGroupName tw-rg01).Tags

Set-AzResourceGroup -Name tw-rg01 -Tag @{ costcenter="1987"; ManagedBy="Bob" }

$tags = (Get-AzResourceGroup -Name tw-rg01).Tags
$tags.Add("Status", "Approved")
Set-AzResourceGroup -Tag $tags -Name tw-rg01

$r = Get-AzResource -ResourceName tw-winsrv -ResourceGroupName tw-rg01
Set-AzResource -Tag @{ Dept="IT"; Environment="Test" } -ResourceId $r.ResourceId -Force

$r = Get-AzResource -ResourceName tw-winsrv -ResourceGroupName tw-rg01
$r.Tags.Add("Status", "Approved")
Set-AzResource -Tag $r.Tags -ResourceId $r.ResourceId -Force