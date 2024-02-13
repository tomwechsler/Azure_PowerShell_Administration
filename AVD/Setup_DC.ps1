#Declare variables
$domainName = "master.pri"
$dsrmPassword = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force

#Install the AD Domain Services role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

#Import the ServerManager module
Import-Module ServerManager

#Install the AD Domain Services
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName $domainName `
-DomainNetbiosName (Get-NetBIOSName $domainName) `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$true `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true `
-SafeModeAdministratorPassword $dsrmPassword

#Function to get NetBIOS name
function Get-NetBIOSName {
    param($dnsName)
    $nbName = $dnsName.split(".")[0]
    return $nbName
}