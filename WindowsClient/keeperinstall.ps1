# Find latest installed winget.exe
$wingetPath = Get-ChildItem "C:\Program Files\WindowsApps" -Recurse -Filter "winget.exe" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1 -ExpandProperty FullName

if (-not $wingetPath) {
    Write-Error "winget.exe not found on this system. Please ensure App Installer is installed."
    exit 1
}

# Check if Keeper is installed
$keeperInstalled = & $wingetPath list --name "Keeper" | Select-String "Keeper"

if ($keeperInstalled) {
    Write-Output "Keeper is already installed. Skipping installation."
}
else {
    Write-Output "Keeper not found. Installing..."
    & $wingetPath install 9N040SRQ0S8C --accept-package-agreements --accept-source-agreements --silent
}
