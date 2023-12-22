#ps1_sysnative
########
# Version & Date: v1 31 Oct 2018
# Creator: john.s.parker@oracle.com
# Warning: This script is a representation of how to use PowerShell to create an Active Directory Domain controller
# and build the first DC in a new Active Directory Forest. This script creates and uses the domain administrator account
# there are potential for mistakes and destructive actions. USE AT YOUR OWN RISK!!
# This is the second script in the Active Directory Series that will establish the second
# Active Directory Domain Controller. This script will unlock the local administrator account.
#
# This script will install the required Windows features that are required for Active
# Directory. This script will install the prerequisites for Active Directory. This script will reboot the host after it has added the
# Windows features installed the Active Directory Services and promoted the domain controller.
#
# Variables for this script
# $password - this is the password necessary to unlock the administrator account
# - and is used in both runs of the AD build.
# $DomainName - this is the full name of the domain that you will be adding the DC
# $DomainUser - this account must have the Domain Admin role
# $EncryptedPass - the encrypted password
# $Credential - the encrypted domain
# $DnsServer - this is the private IP address of the Primary Domain Controller
Try {
Start-Transcript -Path "C:\DomainJoin\Stage3.txt" -Force
$Password="Password#!"
$DomainName="contoso.com"
$DomainUser="contoso\administrator"
$EncryptedPass = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainUser, $EncryptedPass
$DnsServer = '10.10.10.42'
#Set the Administrator Password and activate the Domain Admin Account
net user Administrator $Password /logonpasswordchg:no /active:yes
##################
# Create the Second Domain Controller
#
##################
Install-WindowsFeature NET-Framework-Core
Install-WindowsFeature AD-Domain-Services
Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature RSAT-DNS-Server
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $DnsServer
Install-ADDSDomainController -InstallDns -Credential $Credential -DomainName $DomainName -SafeModeAdministratorPassword $EncryptedPass -Force -NoRebootOnCompletion
} Catch {
Write-Host $_
} Finally {
Stop-Transcript
}
start-sleep -s 300
Restart-Computer -ComputerName "localhost" -Force
