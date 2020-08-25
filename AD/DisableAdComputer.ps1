# Desativa computadores com mais de 186 dias de inatividade.
import-module activedirectory
$DaysInactive = 186 
$time = (Get-Date).Adddays(-($DaysInactive))
$OU_Origem="OU=Estacoes,DC=contoso,DC=com"
$OU_Destino="OU=Estacoes Desativadas,DC=contoso,DC=com"
$Log="C:\LogDisable\LogDisableComputers.txt"
# Limpando o Conteúdo do Arquivo.
Clear-Content $Log

# Desabilitando as contas
Get-ADComputer -Filter { LastLogonTimeStamp  -lt $time}  -Properties LastLogonTimeStamp -SearchBase $OU_Origem |
ForEach-Object {
Write-host "Conta desativada: " $_.name "Origem do Objeto" $_.DistinguishedName
$_.DistinguishedName | Disable-ADAccount
Write-Output "Conta desativada:" $_.name "Origem do Objeto: " $_.DistinguishedName  "Movido para: " $OU_Destino | Out-File -Append $Log
Write-Output "------------------------------------------- " | Out-File -Append $Log
$_.DistinguishedName | Move-ADObject -TargetPath $OU_Destino  
}

# Envia e-mail.
Send-MailMessage -from data@contoso.com -to infra@contoso.com -smtpserver mail.contoso.com -Subject "Contas Desativas - Computadores" -Body "Log com as contas de computadores que foram desativadas por nao estarem em uso" -Attachments "C:\LogDisable\LogDisableComputers.txt" 
