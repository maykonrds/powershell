<#PSScriptInfo
.VERSION 1.1
.AUTHOR Maykon Rodrigues dos Santos
.DATA Abril 2018
#>

<#
    .SYNOPSIS
    Take and Delete VMCheckpoint
    .DESCRIPTION
    Take and Delete VMCheckpoint   
    .EXAMPLE
     .\VMCheckpoint 
     
#>

#Specify the value, anything greater than this value will be deleted ( checkpoint )
$Days=0
#Time in sec. Sleep for 10 seconds then delete checkpoint.
$Time=10

function VMCheckpoint {
    $VMs= get-vm
     foreach($VM in $VMs){
        Write-Host "Virtual Machine: " $VM
        Write-Host "Checkpoint..."
        Checkpoint-VM $VM
        $Checkpoint = Get-VMSnapshot $VM
            foreach($Check in $Checkpoint){
            Write-Host "CheckPoint:" $Check
                if ($Check.CreationTime.AddDays($Days) -lt (get-date)){
                write-Host "Sleeping..."
                Start-Sleep $Time
                Write-Host "Removing..."
                Remove-VMSnapshot $Check
                
                }
            }
      }

}
VMCheckpoint
