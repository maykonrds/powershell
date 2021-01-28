# Script to follow a Sharepoint WebSite.

#region Connection
$ApplicationID = "XXXXXXXXXXXXXXXXXX"
$TenatDomainName = "maykonrds.onmicrosoft.com"
$AccessSecret = "XXXXXXXXXXXXXXXXXXXX"

$Body = @{    
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = $ApplicationID
    Client_Secret = $AccessSecret
} 

$ConnectGraph = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenatDomainName/oauth2/v2.0/token" -Method POST -Body $Body
$token = $ConnectGraph.access_token
#endregion Connection


# List the root WebSite
#https://graph.microsoft.com/v1.0/sites/root
$responseRoot = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/sites/root' -ContentType "application/json" -Headers @{Authorization = "Bearer $token" } -Method Get

# Get a List of WebSites
$responseListSite = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/sites/' -ContentType "application/json" -Headers @{Authorization = "Bearer $token" } -Method Get

# We need to know the name and the ID for the WebSite.
$sharepointSiteTest = $responseListSite.value | Where-Object { $_.webUrl -like "*Test*" }


# Get User Information ( All Users )
$responseUser1 = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/users' -ContentType "application/json" -Headers @{Authorization = "Bearer $token" } -Method Get
$userTest = $responseUser1.value | Where-Object { $_.mail -eq "maykonr@maykonrds.onmicrosoft.com" }

$responseUser1.PsObject.Properties.Value.mail

# This is the ID of the Sharepoint Site that I want to follow
$Json = @'
{
    "value":
    [
        {
            "id": "maykonrds.sharepoint.com,68546233-098e-4783-908e-e05155329a96,b39f4629-572f-4013-9306-3d0697ece701"
        }
    ] 
}
'@

$Header = @{
    "authorization" = "Bearer $token"
} 
# This is for all users
try { 
    foreach ($item in $responseUser1.PsObject.Properties.Value.id) {
        Write-Host "This is the ID" $item -ForegroundColor Red
        $Parameters = @{
        Method      = "POST"
        Uri         = "https://graph.microsoft.com/v1.0/users/$item/followedSites/add"
        Body        = $json
        ContentType = "application/json"    
        Headers     = $Header
    }
    Invoke-RestMethod @Parameters    }
 }
catch {
  Write-Host "An error occurred:"
  Write-Host $_
  Write-Host $item 
}


# This is For one user only
$Header = @{
    "authorization" = "Bearer $token"
} 
$Parameters = @{
    Method      = "POST"
    Uri         = "https://graph.microsoft.com/v1.0/users/c4fa66c0-8631-4ae8-8e7c-fd0cb99a036d/followedSites/add"
    Body        = $json_ret
    ContentType = "application/json"    
    Headers     = $Header
}
Invoke-RestMethod @Parameters




