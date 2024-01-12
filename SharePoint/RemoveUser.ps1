# Remove user from Site Collection Administrator (Personal)
$AdminCenterURL = "https://maykonrds-admin.sharepoint.com/"
Connect-SPOService -url $AdminCenterURL 

# User to remove from Site Collection Administrators group
$userToRemove = "user@maykonrds.com"
$personal=Get-SPOSite -IncludePersonalSite $true -Limit all -Filter "Url -like '-my.sharepoint.com/personal/'" | Select -ExpandProperty Url

foreach($item in $personal){
Set-SPOUser -Site $item -LoginName $userToRemove -IsSiteCollectionAdmin $false
}
