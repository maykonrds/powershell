$Stt = New-ScheduledTaskTrigger -Weekly -WeeksInterval 2 -DaysOfWeek Sunday -At 9am

Set-ScheduledTask -TaskName "Mytask" -Trigger $Stt
