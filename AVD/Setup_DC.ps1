#Declare variables
$domainName = "master.pri"
$dsrmPassword = ConvertTo-SecureString "yourpassword" -AsPlainText -Force
$NetbiosName = "MASTER"

#Install the AD Domain Services role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -IncludeAllSubFeature

#Import the ServerManager module
Import-Module ServerManager

#Install the AD Domain Services
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName $domainName `
-DomainNetbiosName $NetbiosName `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$true `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true `
-SafeModeAdministratorPassword $dsrmPassword