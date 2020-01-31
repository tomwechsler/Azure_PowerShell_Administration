Set-Location c:\
Clear-Host

Install-Module -Name Az -Verbose -AllowClobber

Connect-AzAccount

$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
$location = Read-Host -Prompt "Enter the location (i.e. centralus)"

New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri https://raw.githubusercontent.com/tomwechsler/arm_templates/master/base-azure.json


