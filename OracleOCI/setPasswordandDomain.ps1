#ps1_sysnative
########
# Variables for this script
# $DnsServer - this is the private IP address of the Primary Domain Controller
# $DnsServer2 - this is the private IP address of the Secondary Domain Controller
# $DomaintoJoin - this is the full name of the domain you want to join.
# $JoinCred - this will be the encrypted credential
#
Set-LocalUser -Name "opc" -PasswordNeverExpires 1 -Password (ConvertTo-SecureString -AsPlainText "MyPassword" -Force)

$DnsServer = '10.107.80.4'
$DnsServer2 = '10.107.80.17'
# Sets the DNS to the DC.
#######
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses ($DnsServer, $DnsServer2)

# Define credentials for a user with permission to join the domain
$Domain = "contoso.com"
$DomainUser = "Administrator@contoso.com"
$Password = ConvertTo-SecureString -String "Mypassword" -AsPlainText -Force
$Credential = New-Object -TypeName PSCredential -ArgumentList $DomainUser, $Password
# Perform the domain join operation
Add-Computer -DomainName $Domain -Credential $Credential

start-sleep -s 30
Restart-Computer -ComputerName "localhost" -Force
