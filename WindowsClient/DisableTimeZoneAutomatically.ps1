$newValue = 4
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate"
$propertyName = "Start"

if (Test-Path $registryPath) {
	Set-ItemProperty -Path $registryPath -Name $propertyName -Value $newValue
	Write-Output "Successfully disabled 'Set time zone automatically'."
	} else {
	     Write-Output "Registry path not found: $registryPath"
	}