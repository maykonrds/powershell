$spn_applicationid_subscription = "yourspn_application_ID"
$spn_tenantId_subscription = "your_tenant-ID"
$tenantid_subscription = $spn_tenantId_subscription

$local="C:\temp\spn"

$credfile_spn_applicationid = $local + "\" + "$spn_applicationid_subscription.txt"
			

$cred_azure_subscription = Get-Credential -cred $spn_applicationid_subscription		
$cred_azure_subscription.Password | ConvertFrom-SecureString | Out-File $credfile_spn_applicationid
$pass = Get-Content $credfile_spn_applicationid | ConvertTo-SecureString
				
	
$cred_azure_subscription= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $spn_applicationid_subscription, (Get-Content $credfile_spn_applicationid | ConvertTo-SecureString)
Add-AzAccount -ServicePrincipal -Tenant $spn_tenantId_subscription -Credential $cred_azure_subscription

# List Vault
Get-AzKeyVault -VaultName "yourVault"
Get-AzKeyVaultSecret -VaultName ""

$q = Get-AzKeyVaultSecret -VaultName "yourVault"
$q.foreach{ Get-AzKeyVaultSecret -VaultName $_.VaultName -Name $_.Name }.SecretValueText

$pass=Get-AzKeyVaultSecret -VaultName "yourVault" -name "yoursecret" | Where-Object { $_.Name -like "*user-name-pass*"}

$pass=Get-AzKeyVaultSecret -VaultName "yourVault" -name "yoursecret"  | Where-Object { $_.Name -eq "user-pass"}
($pass).SecretValueText


