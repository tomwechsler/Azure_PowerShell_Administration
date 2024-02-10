#Install the Az.Billing module if you have not already done so
Install-Module -Name Az.Billing -AllowClobber -Verbose -Force

#Sign in to your Azure account
Connect-AzAccount

#List all subscriptions
Get-AzSubscription 

#Select your subscription
$subscriptionId = "your subscription id"
Select-AzSubscription -SubscriptionId $subscriptionId

#Define the period for which you want to retrieve the cost information
$startDate = (Get-Date).AddMonths(-1)
$endDate = Get-Date

#Retrieve the cost information
$costs = Get-AzConsumptionUsageDetail -StartDate $startDate -EndDate $endDate

#Sort the cost information by total cost and display the most expensive resources first
$sortedCosts = $costs | Sort-Object -Property PreTaxCost -Descending

#Output of the cost information
$sortedCosts | Format-Table -Property InstanceName, PreTaxCost

#A little more precise - The costs added up

#Calculate the sum of the PreTaxCost for each MeterId
$costSummary = $costs | Group-Object -Property MeterId | ForEach-Object {
    $totalCost = ($_.Group | Measure-Object -Property PreTaxCost -Sum).Sum
    [PSCustomObject]@{
        MeterId = $_.Name
        InstanceName = $_.Group[0].InstanceName
        TotalPreTaxCost = $totalCost
    }
}

#Sort the cost information by total cost and display the most expensive resources first
$sortedCostSummary = $costSummary | Sort-Object -Property TotalPreTaxCost -Descending

#Output of the cost information
$sortedCostSummary | Format-Table -Property MeterId, InstanceName, TotalPreTaxCost
