# SheetID
$SheetId = 11111111
$Token = "XXXXXXX"
$value = "1000"
# Build new cell value
$newCell = @{
    columnId = 1111111
    value = $value
    strict = $false
}

# Build the row to update
# You need the ID row
$newRow = @{
    id = 11111111
    cells = @($newCell)
}

# Prepare the payload
$payload = @($newRow)

# Convert the payload to JSON
$jsonPayload = $payload | ConvertTo-Json

# Prepare headers
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

# Construct the URL for updating rows
$url = "https://api.smartsheet.com/2.0/sheets/$SheetId/rows"

# Perform the update rows request
$response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -Body $jsonPayload

$response  # Display the response if needed
