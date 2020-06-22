Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzContext
Get-AzSubscription -SubscriptionName "Nutzungsbasierte Bezahlung" | Select-AzSubscription

Get-AzConsumptionUsageDetail | ft

Get-AzConsumptionUsageDetail -InstanceName "wvd-dc01" | Out-GridView

Get-AzConsumptionUsageDetail -BillingPeriodName 202005 | Out-GridView

Get-AzConsumptionUsageDetail -StartDate 2020-05-01 -EndDate 2020-05-31

Get-AzConsumptionUsageDetail -BillingPeriodName 202005 | Select-Object InstanceName, Currency, PretaxCost, IsEstimated | Out-GridView

Get-AzConsumptionUsageDetail -Expand MeterDetails -Top 10

Get-AzConsumptionUsageDetail -Expand MeterDetails -Top 10 | Where-Object {$_.InstanceName -eq "wvd-dc01"} | Select-Object UsageStart, UsageEnd, InstanceName, BillingPeriod, UsageQuantity | ft *

Get-AzBillingPeriod

Get-AzBillingPeriod -Name 202006-1

Get-AzBillingPeriod -MaxCount 2

Get-AzBillingInvoice

Get-AzBillingInvoice -Latest

Get-AzBillingInvoice -Name 202006-220061190788342

Get-AzBillingInvoice -GenerateDownloadUrl -MaxCount 10