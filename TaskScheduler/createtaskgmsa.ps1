# Get the DateTime of tomorrow at 9 AM.
$ScheduleRunTime = (Get-Date).AddDays(1).Date + "09:00:00"

# Set the Task to run Daily at 9 AM starting tomorrow.
$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 1 -At $ScheduleRunTime

# Define that I want to launch PowerShell and run my scripts.
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument 'C:\Scripts\myscript.ps1'

# Run only if the server is online, but wake the system to run if needed.
$Settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun

# Run the task with the sMSA AD account. You must have the "-LogonType Password" flag set for this to work!
# Also, note in the UserID that I added a '$' to the end of the username; this is a MUST for you too!
$Principal = New-ScheduledTaskPrincipal -UserID 'Contso\gmsaContoso$' -LogonType Password 

# Use all the variables we set up and register the new Scheduled Task.
Register-ScheduledTask -TaskName "UpdateSPLANumber" -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal
