# Access the Azure Ad and reset password from CSV file

$AzADInstall=Get-Module *AzureAD* -ListAvailable
$TenantID="XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

if(!$AzADInstall){
    Write-Host "The module is not installed" -ForegroundColor Red
    Write-Verbose "Installing"
    Install-Module -Name AzureAD -AllowClobber -Scope AllUsers
    Import-Module -Name AzureAD 
}
  
# connect to Azure AD
Connect-AzureAD -TenantId $TenantID 
# List all Users

# Password Profile
$newProfile = New-Object -TypeName Microsoft.Open.azureAD.Model.PasswordProfile 
$newProfile.ForceChangePasswordNextLogin = $False

# Import CSV file
$listOfRows=Import-Csv C:\CSV\finalFile.csv -Delimiter ';'

ForEach($Loop in $listOfRows){    
    $Password = ConvertTo-SecureString $Loop.Password -AsPlainText -Force    
    Get-AzureADUser -Filter "userPrincipalName eq '$($Loop.UPN)'" | Set-AzureADUserPassword -Password $Password
    Get-AzureADUser -Filter "userPrincipalName eq '$($Loop.UPN)'" | Set-AzureADUser -PasswordProfile $newProfile   
    Get-AzureADUser -Filter "userPrincipalName eq '$($Loop.UPN)'" | Set-AzureADUser -PasswordPolicies DisablePasswordExpiration 
}
