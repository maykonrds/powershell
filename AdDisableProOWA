<#PSScriptInfo
.VERSION 1.0
.AUTHOR Maykon Rodrigues dos Santos
.DATA July 2018
#>

<#
    .SYNOPSIS
    Disable some AD properties and Exchgange OWA\ActiveSync\OWADevices and move the user to an OU.
    .DESCRIPTION
    Disable some AD properties and Exchgange OWA and move the user to an OU.
    You need to have the Active Directory Shell Instaled in your machine.
    https://www.microsoft.com/en-us/download/details.aspx?id=45520
    .EXAMPLE
     .\AdUser 
     
#>
# user Input
$User = Read-Host "Please enter the username"
# Source OU where you will looking for users.
$OuSource="OU=OUYourUser,DC=contoso,DC=local"
# Where user will be moved
$OuDisable="OU=Disable,DC=contoso,DC=local"
# URL exchange Server
$ExchangeServer="http://yourmailserver/PowerShell/"

# Create a Session with your Exchange Server. The user need to have permission
$Session=New-PsSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ExchangeServer -Authentication Kerberos 
# Import the Session
Import-PSSession $Session

# Create a function
function GetUser{

# Set Null Manager
Get-ADUser -Identity $User | Set-ADUser -Manager $null
# Set Null Company
Get-ADUser -Identity $User | Set-ADUser -Company $null
# Set Null Department
Get-ADUser -Identity $User | Set-ADUser -Department $null
# Set Null Job Title
Get-ADUser -Identity $User | Set-ADUser -title $null

    # Remove groups from the user   
    Get-ADUser -Identity $User -Properties MemberOf | ForEach-Object {
    $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
       }    
$UserMove= Get-ADUser -Identity $User -Properties DistinguishedName
# Move the user.
$UserMove | Move-ADObject -TargetPath $OuDisable  
}

# Create a function for exchange
function DisableOWA{
# Disable OWA
Set-CASMailbox $User -OWAEnabled $false
# Close the Session.
# Disable Active Sync
Set-CASMailbox $User -ActiveSyncEnabled $false
# Diable OWA for devices
Set-CASMailbox $User -OWAforDevicesEnabled $false
#Close Session
Get-PSSession | Remove-PSSession 
}
   
# Call the Function.
GetUser
DisableOWA
