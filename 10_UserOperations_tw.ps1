Clear-Host
Set-Location c:\

#Log into Azure
Connect-AzureAD

$domain = "wechsler.onmicrosoft.com"
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "agxsFX72xwsSAi"

#Find an existing user
Get-AzureADUser -SearchString "FR"

Get-AzureADUser -Filter "State eq 'SO'"

#Creating a new user
$user = @{
    City = "Oberbuchsiten"
    Country = "Switzerland"
    Department = "Information Technology"
    DisplayName = "Fred Prefect"
    GivenName = "Fred"
    JobTitle = "Azure Administrator"
    UserPrincipalName = "frPrefect@$domain"
    PasswordProfile = $PasswordProfile
    PostalCode = "4625"
    State = "SO"
    StreetAddress = "Hiltonstrasse"
    Surname = "Prefect"
    TelephoneNumber = "455-233-22"
    MailNickname = "FrPrefect"
    AccountEnabled = $true
    UsageLocation = "CH"
}

$newUser = New-AzureADUser @user

$newUser | Format-List
