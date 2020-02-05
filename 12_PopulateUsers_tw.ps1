Clear-Host
Set-Location c:\

#Install AzureAD if doesn't exist
if(-not (Get-Module AzureAD)){
    Install-Module -Name AzureAD -Force
}

#Log into Azure
Connect-AzureAD
cd D:\Scripts


$data = import-csv -Path .\Fake_User_data.csv
$domain = "wechsler.onmicrosoft.com"
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "agxsFX72xwsSAi"

foreach($item in $data){
    $user = @{
        City = $item.City
        Country = $item.Country
        Department = $item.Department
        DisplayName = "$($item.GivenName) $($item.Surname)"
        GivenName = $item.GivenName
        JobTitle = $item.Occupation
        UserPrincipalName = "$($item.Username)@$domain"
        PasswordProfile = $PasswordProfile
        PostalCode = $item.ZipCode
        State = $item.State
        StreetAddress = $item.StreetAddress
        Surname = $item.Surname
        TelephoneNumber = $item.TelephoneNumber
        MailNickname = $item.Username
        AccountEnabled = $true
    }

    New-AzureADUser @user
}


