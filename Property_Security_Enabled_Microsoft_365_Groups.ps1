Set-Location c:\
Clear-Host

#If needed
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#Install the AzureAD
Install-Module -Name AzureAD -AllowClobber -Verbose -Force

#Connect
Connect-AzureAD

#Did it work?
Get-AzureADUser

#Create a dynamic group
New-AzureADMSGroup -DisplayName "Dynamic Group 01" -Description "Dynamic group created from PS" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(user.department -contains ""Marketing"")" -MembershipRuleProcessingState "On"

#Get the group
Get-AzureADMSGroup -SearchString "Dynamic Group 01"

#The value true comes back
(Get-AzureADMSGroup -SearchString "Dynamic Group 01").SecurityEnabled

#Get an existing group
Get-AzureADMSGroup -SearchString "Technik"

#Get the SecurityEnabled value
(Get-AzureADMSGroup -SearchString "Technik").SecurityEnabled

#Now let's have a look at the Azure Active Directory Portal
#Under Manage we do not find a license option!

#We change the SecurityEnabled property
Set-AzureADMSGroup -Id a8269c21-1059-4bb1-8937-7f2d6a6f6b92 -SecurityEnabled $True

#Let's check it out in Azure Active Directory!

#When you create a new Microsoft 365 group in the Microsoft 365 portal, you cannot work with group licensing 
#in Azure Active Directory because the group's SecurityEnabled property has the value false.

#If you create a new Microsoft 365 group in Azure Active Directory, you can work with group licensing in 
#Azure AD because the SecurityEnabled property has a value of true.