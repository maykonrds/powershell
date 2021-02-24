<#
.AUTOR: Maykon
.DESCRIPTION Power Shell Script to logff users
1.	Log off a specific Account, i.e., Administrator 
2.	Log off all logged in users 
3.	Log off for Terminal Server Users with idle session for x minutes 
#>


$Menu = [ordered]@{

      1 = 'Log off a specific Account, i.e., Administrator '
      2 = 'Log off all logged in users '
      3 = 'Log off for Terminal Server Users with idle session for x minutes'

}    

$Result = $Menu | Out-GridView -PassThru  -Title 'Make a  selection'

Switch ($Result) {

      { $Result.Name -eq 1 } {    
            $userSession = Get-RDUserSession | Out-GridView -PassThru -Title "RDS Logoff"
            ForEach ($item in $userSession) {
                  Invoke-RDUserLogoff $item.HostServer $item.UnifiedSessionId -Force
            }    

      }

      { $Result.Name -eq 2 } {
            # I can't Logoff the current user.
            $userCurrentSessionID = (Get-Process -PID $pid).SessionId
            $usersSession = Get-RDUserSession | Where-Object { $_.UnifiedSessionId -ne $userCurrentSessionID }

            ForEach ($item in $usersSession) {            
                  Invoke-RDUserLogoff $item.HostServer $item.UnifiedSessionId -Force      
            }  
      }

      { $Result.Name -eq 3 } {
            $inputValue = 0
            do {
                  $inputValid = [int]::TryParse((Read-Host 'Log off for RDS with idle session for x minutes'), [ref]$inputValue)
                  if (-not $inputValid) {
            
                  }
            } while (-not $inputValid)
            Write-host $inputValue
            # Convert Value to milliseconds
            [int]$inputSecounds = $inputValue * 60
            [int]$milliSecounds = $inputSecounds * 1000
            $userCurrentSessionID = (Get-Process -PID $pid).SessionId
  
            $usersSessionIdle = Get-RDUserSession | Where-Object { $_.IdleTime -ge $milliSecounds -and $_.UnifiedSessionId -ne $userCurrentSessionID }
            ForEach ($item in $usersSessionIdle) {            
                  Invoke-RDUserLogoff $item.HostServer $item.UnifiedSessionId -Force      
            }         

      }    

} 
