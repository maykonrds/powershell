# First remove any existing installation
$configPath = "C:\Program Files\OpenTelemetry Collector\config.yaml"
$tempFolder = "$env:SystemRoot\temp\"

if ($configPath = "C:\Program Files\OpenTelemetry Collector\config.yaml"){
    Copy-Item -Path $configPath -Destination $tempFolder -Force
}

$otel = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*OpenTelemetry*" }
if ($otel) {
    Write-Host "Uninstalling existing OpenTelemetry Collector..."
    Start-Process msiexec.exe -ArgumentList "/x $($otel.IdentifyingNumber) /qn" -Wait
    Write-Host "Uninstallation completed."
} else {
    Write-Host "No existing installation found."
}

# Install the latest Opentelemetry agent
$repo = "open-telemetry/opentelemetry-collector-releases"
$apiUrl = "https://api.github.com/repos/$repo/releases/latest"
$response = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "PowerShell" }
$latestTag = $response.tag_name
$asset = $response.assets | Where-Object { $_.name -like "*windows_x64.msi" } | Select-Object -First 1
if (-not $asset) {
    Write-Error "No Windows MSI asset found for version $latestTag."
    exit 1
}
$downloadUrl = $asset.browser_download_url
$outFile = $asset.name
$output = "$env:USERPROFILE\Downloads\$outFile"
Invoke-WebRequest -Uri $downloadUrl -OutFile $output

Start-Process msiexec.exe -ArgumentList "/i `"$output`" /qn" -NoNewWindow -Wait
# Copy Backup file to config location
Copy-Item -Path $tempFolder\config.yaml -Destination $configPath -Force
#Edit the file IF necessary
#notepad.exe "C:\Program Files\OpenTelemetry Collector\config.yaml"
restart-service otelcol-contrib