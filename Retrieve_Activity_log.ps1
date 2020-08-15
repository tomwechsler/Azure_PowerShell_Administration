Set-Location c:\
Clear-Host

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

Get-Date

#Get log entries from this time/date to present:
Get-AzLog -StartTime 2020-08-14T10:30

#Get log entries between a time/date range:
Get-AzLog -StartTime 2020-08-14T10:30 -EndTime 2020-08-14T11:30

#Get log entries from a specific resource group:
Get-AzLog -ResourceGroup 'tw-rg01'

#Get log entries from a specific resource provider between a time/date range:
Get-AzLog -ResourceProvider 'Microsoft.Web' -StartTime 2020-08-14T10:30 -EndTime 2020-08-14T11:30

#Get all log entries with a specific caller:
Get-AzLog -Caller 'tom@tomwechsler.ch' -MaxRecord 10

#The following command retrieves the last 10 events from the activity log:
Get-AzLog -MaxRecord 10

#To view all alert events, you can query the Azure Resource Manager logs using the following examples
Get-AzLog -Caller "Microsoft.Insights/alertRules" -DetailedOutput -StartTime 2020-08-01

#Retrieve all alerts on a resource group:
Get-AzAlertRule -ResourceGroup "tw-rg01" -DetailedOutput