Connect-MgGraph -Scopes "Directory.AccessAsUser.All"

Update-MgUser -UserId "lisam@domain.onmicrosoft.com" -PasswordProfile @{Password = "Pass2025!azz"; ForceChangePasswordNextSignIn = $true}
Update-MgUser -UserId "ChelseaR@domain.onmicrosoft.com" -PasswordProfile @{Password = "Pass2025!azz"; ForceChangePasswordNextSignIn = $true}
Update-MgUser -UserId  "customerservice@domain.onmicrosoft.com" -PasswordProfile @{Password = "Pass2025!azz"; ForceChangePasswordNextSignIn = $true}
Update-MgUser -UserId "irfanz@domain.onmicrosoft.com" -PasswordProfile @{Password = "Pass2025!azz"; ForceChangePasswordNextSignIn = $true}
Update-MgUser -UserId  "JohnV@domain.onmicrosoft.com" -PasswordProfile @{Password = "Pass2025!azz"; ForceChangePasswordNextSignIn = $true}