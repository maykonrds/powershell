#Desativa e move contas com mais de 168 dias sem acesso à rede.
import-module activedirectory
$OU_Origem="OU=Usuarios,DC=contoso,DC=local"
$OU_Destino="OU=Desligados/Desativados,DC=contoso,DC=local"
$Log="C:\LogDisable\LogDisableUsers.txt"
$data = ((Get-Date).AddDays(-168)).Date
# Limpando o Conteúdo do Arquivo.
Clear-Content $Log

# Desabilitando as Contas, ignora as unidades organizacionais que contém "SemSistema","Domains Admins" e verifica a data da criação da conta, caso tenha sido criada com menos de 168 dias não desabilita a conta.

Search-ADAccount -AccountInactive -TimeSpan 168.00:00:00 -SearchBase $OU_Origem | Get-ADUser -Properties DistinguishedName,whenCreated,distinguishedName |
Where-Object {($_.DistinguishedName -notlike "*OU=E-mail*" -and $_.DistinguishedName -notlike "*OU=SemSistema*") -and ($_.whenCreated -lt $data) -and $_.DistinguishedName -notlike "*OU=Domain Admins*"} |
ForEach-Object {
Write-host "Conta desativada: " $_.name  "Criada em: " $_.whenCreated "Origem do Objeto" $_.DistinguishedName
$_.DistinguishedName | Disable-ADAccount
$_.UserPrincipalName
Write-Output "Conta desativada: " $_.name  "Criada em: " $_.whenCreated "Origem do Objeto: " $_.DistinguishedName  "Movido para: " $OU_Destino | Out-File -Append $Log
$_.DistinguishedName | Move-ADObject -TargetPath $OU_Destino  
}
#Envia e-mail
Send-MailMessage -from data@contoso.local -to infra@contoso.local -smtpserver mail.contoso.local -Subject "Contas Desativas" -Body "Log com as contas que foram desativadas por nao estarem em uso" -Attachments "C:\LogDisable\LogDisableUsers.txt" 
