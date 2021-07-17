Set-Location C:\
Clear-Host

#Install Microsoft Graph Module
Install-Module Microsoft.Graph -AllowClobber -Force

#Time range
$date = (Get-Date).AddDays(-60)

#A variable for later output
$properties = 'AccountEnabled', 'UserPrincipalName','Id','CreatedDateTime','LastPasswordChangeDateTime'

#Connect to the cloud (incl. necessary permissions)
Connect-Graph -Scopes User.Read.All, Directory.AccessAsUser.All, User.ReadBasic.All, User.ReadWrite.All, Directory.Read.All, Directory.ReadWrite.All

#We check the permissions
(Get-MgContext).Scopes

#List the users and store them in a variable
$mgUsers = Get-MgUser -All -Select $properties

#Let's look at the list
$mgUsers

#How many are there?
$mgUsers.count

#Get-Member to get the details
Get-MgUser | Get-Member

#Creation date and last password change
$InfoUsers = $mgUsers | Where-Object {
    $_.CreatedDateTime -lt $date -and
    $_.LastPasswordChangeDateTime -lt $date
}

#How many have we found (No longer the same number)?
$InfoUsers.count

#We'll take a look at it
$InfoUsers | Format-Table $properties

#Remove the session
Disconnect-Graph