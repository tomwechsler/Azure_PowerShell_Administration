Set-Location c:\
Clear-Host

#We need the cmdlets
Install-Module -Name AzureAD -AllowClobber -Force -Verbose

#Sometimes the module must be imported
Import-Module AzureAD

#Let's connect
Connect-AzureAD

#To explore the available cmdlets in the Azure AD module
Get-Command -Module AzureAD

#Fetch list of all directory roles with object ID
Get-AzureADDirectoryRole

#Fetch a specific directory role by ID
$role = Get-AzureADDirectoryRole -ObjectId "6fd5c3ac-2e62-4fca-84fe-9e32ae5282f2"

#Fetch role membership for a role
Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Get-AzureADUser

#Query the licenses that your organization has subscribed
Get-AzureADSubscribedSku | Select Sku*,*Units

#A more detailed view 
Get-AzureADSubscribedSku | Select -Property Sku*,ConsumedUnits -ExpandProperty PrepaidUnits

$licenses = Get-AzureADSubscribedSku
 
$licenses[0].SkuPartNumber

$licenses[0].ServicePlans

$licenses[1].SkuPartNumber

Get-AzureADUser -ObjectId 158a6af5-1f64-4c61-86b8-e5b4bf8ac297 | Select -ExpandProperty AssignedLicenses

Get-AzureADSubscribedSku | Where {$_.SkuId -eq "6fd2c87f-b296-42f0-b197-1e91e994b900"}

Get-AzureADUser -ObjectId 158a6af5-1f64-4c61-86b8-e5b4bf8ac297 | Select -ExpandProperty AssignedPlans

#(Get-MsolUser -UserPrincipalName tom@tomrocks.ch).Licenses[0].ServiceStatus

#To view the list of all user accounts in your organization that have NOT been assigned any of your licensing plans
Get-AzureAdUser | ForEach{ $licensed=$False ; For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++) { If( [string]::IsNullOrEmpty(  $_.AssignedLicenses[$i].SkuId ) -ne $True) { $licensed=$true } } ; If( $licensed -eq $false) { Write-Host $_.UserPrincipalName} }

#To view the list of all user accounts in your organization that have been assigned any of your licensing plans
Get-AzureAdUser | ForEach { $licensed=$False ; For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++) { If( [string]::IsNullOrEmpty(  $_.AssignedLicenses[$i].SkuId ) -ne $True) { $licensed=$true } } ; If( $licensed -eq $true) { Write-Host $_.UserPrincipalName} }

#Get the SKU's
Get-AzureADSubscribedSku | Select Sku*

#Set the user
$User = Get-AzureADUser -ObjectId 157a6f3f-52f2-4fee-af64-dbca2db07926

#Check
$user

#Set the location
Set-AzureADUser -ObjectId $User.ObjectId -UsageLocation CH

#We build the variable
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

$License.SkuId = "06ebc4ee-1bb5-47dd-8120-11324bc54e06"

$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

$LicensesToAssign.AddLicenses = $License

#We assign the license to
Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $LicensesToAssign

#We check it
Get-AzureADUser -ObjectId $User.ObjectId | Select -ExpandProperty AssignedLicenses

Get-AzureADUser -ObjectId $User.ObjectId | Select -ExpandProperty AssignedPlans
 
#Removing Licenses Using PowerShell
$User = Get-AzureADUser -ObjectId 157a6f3f-52f2-4fee-af64-dbca2db07926 

#We build the variable
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

$License.SkuId = "06ebc4ee-1bb5-47dd-8120-11324bc54e06"

$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

$LicensesToAssign.AddLicenses = @()
$LicensesToAssign.RemoveLicenses = $License.SkuId

#Remove the license
Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $LicensesToAssign

#We check it
Get-AzureADUser -ObjectId $User.ObjectId | Select -ExpandProperty AssignedPlans