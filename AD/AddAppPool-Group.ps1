
$app=Get-IISAppPool | select-Object  name

foreach ($loop in $app)
{
$name=$loop.name
$aux="IIS AppPool\$name"
Write-Host $aux
Add-LocalGroupMember -Group "Performance Monitor Users" -Member $aux
$aux=""
}
