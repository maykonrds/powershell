Import-Module ActiveDirectory
Get-ADUser -Filter * -SearchBase 'DC=contoso,DC=com' -Properties proxyaddresses |
Foreach {
Set-ADUser $_ -Add @{ProxyAddresses = "SMTP:$($_.UserPrincipalName)"}
}
