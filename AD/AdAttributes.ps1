<#PSScriptInfo
.VERSION 1.1
.AUTHOR Maykon Rodrigues dos Santos
.DATA September 2018
#>
# The location of your users
$Source='OU=Test,DC=contoso,DC=local'
# new UPN
$UPN='@contoso.com'
# old UPN
$UPNold='@contoso.local'

function UPN{
Get-ADUser -Filter * -SearchBase $Source -Properties UserPrincipalName |

Foreach {
$OldUPN = $_.UserPrincipalName
$User = $_.UserPrincipalName.Split('@')[0] 
$NewUPN = $User+$UPN
set-aduser -Identity $_.DistinguishedName -UserPrincipalName $NewUPN
}
}

function Proxy{
Get-ADUser -Filter * -SearchBase $Source -Properties proxyaddresses |
Foreach {
# clear proxy
Set-AdUser -Identity $_.DistinguishedName -Clear ProxyAddresses
#main email
Set-ADUser $_ -Add @{ProxyAddresses = "SMTP:$($_.UserPrincipalName)"}
#secondary e-mail if you don't want just comment the line below
Set-ADUser $_ -Add @{ProxyAddresses = "smtp:$($_.SamAccountName+"@contoso.net")"}  
# set mail attribute
Set-ADUser $_ -EmailAddress $_.UserPrincipalName  
}
}

UPN
Proxy
 

