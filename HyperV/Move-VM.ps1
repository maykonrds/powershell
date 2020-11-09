<#PSScriptInfo
.VERSION 1.1

.AUTHOR Maykon Rodrigues dos Santos.

.DATA February 2018

#>

<#
    .SYNOPSIS
    Move Vms between Hyper-V hosts.

    .DESCRIPTION
    Move VMs and storage between Hyper-V hosts.
    This script will be Move VMs with Out-GridView.
      
    .EXAMPLE
     .\Move-Vm .
     .\Move-Vm -Source MYServerSour -Destination MYServerDest
#>

# Your server here.
Param(
    [Parameter(Mandatory=$true)]
    [string]$Source,
    [Parameter(Mandatory=$true)]
    [string]$Destination
    )
if(-not($Source)) { Throw "You must supply a value for -Source" }
if(-not($Destination)) { Throw "You must supply a value for -Destination" }

function GetVM
{

# Get All VMs and stores value in $Vms variable
$Vms= get-vm -ComputerName $Source | Select-Object Name,Path,State,Computername
   
    $Vms | OGV -title "Move VMs" -PassThru | % {
    $VmLoop= $_.name
    $VmsMove= Get-VM –VMname $_.name -Computername $Source | Select-Object CheckpointFileLocation,ConfigurationLocation,SmartPagingFilePath,SnapshotFileLocation
    $PathFile=Invoke-command -computername $Source {Get-vm -Name "$($args[0])" | Select-Object VMId | Get-VHD } -ArgumentList $VmLoop
    $File = ""
    $File = $PathFile | select Path
    $Disk = $File -replace "@{Path=" -replace ""
    $Disk = $Disk -replace "}" -replace ""
    
    $PathCheckpoint=$VmsMove.CheckpointFileLocation
    $PathConfiguration=$VmsMove.ConfigurationLocation
    $PathSmart=$VmsMove.SmartPagingFilePath
    $PathSnapshot=$VmsMove.SnapshotFileLocation 
           
        
        $Aux = $Disk | Measure-Object | Select-Object Count
        $Aux = $Aux -replace "@{Count=" -replace ""
        $Aux = $Aux -replace "}" -replace ""

        $Count = [int]$Aux
        # Count 1            

        if ( $Count -eq 1) {
        $Disk | % {
        $DiskA1 = $_
       
        } 
         Write-Host "Moving Virtual Machine"        
         
         move-vm -ComputerName $Source -DestinationHost $Destination -name $VmLoop -VirtualMachinePath $PathConfiguration -SnapshotFilePath $PathSnapshot -SmartPagingFilePath $PathSmart -VHDs @(@{"SourceFilePath" = "$DiskA1"; "DestinationFilePath" = "$DiskA1"})
         
                     }  #End IF 

        # Count 2
        if ( $Count -eq 2) {
            $Array = New-Object System.Collections.ArrayList
        $Disk | % {
        $D = $_              
        $Array.add($D)
        }
        
        $DiskA2 = $Array[0]
        $DiskB2 = $Array[1]         
        Write-Host "Moving Virtual Machine"       
        move-vm -ComputerName $Source -DestinationHost $Destination -name $VmLoop -VirtualMachinePath $PathConfiguration -SnapshotFilePath $PathSnapshot -SmartPagingFilePath $PathSmart -VHDs @(@{"SourceFilePath" = "$DiskA2"; "DestinationFilePath" = "$DiskA2"},@{"SourceFilePath" = "$DiskB2"; "DestinationFilePath" = "$DiskB2"})
            }  #End IF 
        
        # Count 3
        if ( $Count -eq 3) {
            $Array = New-Object System.Collections.ArrayList
        $Disk | % {
        $D = $_               
        $Array.add($D)        
        }        
        
        $DiskA3 = $Array[0]
        $DiskB3 = $Array[1]
        $DiskC3 = $Array[2]         
        Write-Host "Moving Virtual Machine"     
        move-vm -ComputerName $Source -DestinationHost $Destination -name $VmLoop -VirtualMachinePath $PathConfiguration -SnapshotFilePath $PathSnapshot -SmartPagingFilePath $PathSmart -VHDs @(@{"SourceFilePath" = "$DiskA3"; "DestinationFilePath" = "$DiskA3"},@{"SourceFilePath" = "$DiskB3"; "DestinationFilePath" = "$DiskB3"},@{"SourceFilePath" = "$DiskC3"; "DestinationFilePath" = "$DiskC3"})
            }  #End IF 
        
        # Count 4
        if ( $Count -eq 4) {
            $Array = New-Object System.Collections.ArrayList
        $Disk | % {
        $D = $_               
        $Array.add($D)
        }
        
        $DiskA4 = $Array[0]
        $DiskB4 = $Array[1]
        $DiskC4 = $Array[2]
        $DiskD4 = $Array[3]         
        Write-Host "Moving Virtual Machine"       
        move-vm -ComputerName $Source -DestinationHost $Destination -name $VmLoop -VirtualMachinePath $PathConfiguration -SnapshotFilePath $PathSnapshot -SmartPagingFilePath $PathSmart -VHDs @(@{"SourceFilePath" = "$DiskA4"; "DestinationFilePath" = "$DiskA4"},@{"SourceFilePath" = "$DiskB4"; "DestinationFilePath" = "$DiskB4"},@{"SourceFilePath" = "$DiskC4"; "DestinationFilePath" = "$DiskC4"},@{"SourceFilePath" = "$DiskD4"; "DestinationFilePath" = "$DiskD4"})
            }  #End IF 
        
          # Count 5
        if ( $Count -eq 5) {
            $Array = New-Object System.Collections.ArrayList
        $Disk | % {
        $D = $_               
        $Array.add($D)
        }
        
        $DiskA5 = $Array[0]
        $DiskB5 = $Array[1]
        $DiskC5 = $Array[2]
        $DiskD5 = $Array[3]         
        $DiskE5 = $Array[4]
        Write-Host "Moving Virtual Machine"       
        move-vm -ComputerName $Source -DestinationHost $Destination -name $VmLoop -VirtualMachinePath $PathConfiguration -SnapshotFilePath $PathSnapshot -SmartPagingFilePath $PathSmart -VHDs @(@{"SourceFilePath" = "$DiskA5"; "DestinationFilePath" = "$DiskA5"},@{"SourceFilePath" = "$DiskB5"; "DestinationFilePath" = "$DiskB5"},@{"SourceFilePath" = "$DiskC5"; "DestinationFilePath" = "$DiskC5"},@{"SourceFilePath" = "$DiskD5"; "DestinationFilePath" = "$DiskD5"},@{"SourceFilePath" = "$DiskE5"; "DestinationFilePath" = "$DiskE5"})
            }  #End IF 
        
          # Count 6
        if ( $Count -eq 6) {
            $Array = New-Object System.Collections.ArrayList
        $Disk | % {
        $D = $_               
        $Array.add($D)
        }
        
        $DiskA6 = $Array[0]
        $DiskB6 = $Array[1]
        $DiskC6 = $Array[2]
        $DiskD6 = $Array[3]         
        $DiskE6 = $Array[4]
        $DiskF6 = $Array[5]
        Write-Host "Moving Virtual Machine"       
        move-vm -ComputerName $Source -DestinationHost $Destination -name $VmLoop -VirtualMachinePath $PathConfiguration -SnapshotFilePath $PathSnapshot -SmartPagingFilePath $PathSmart -VHDs @(@{"SourceFilePath" = "$DiskA6"; "DestinationFilePath" = "$DiskA6"},@{"SourceFilePath" = "$DiskB6"; "DestinationFilePath" = "$DiskB6"},@{"SourceFilePath" = "$DiskC6"; "DestinationFilePath" = "$DiskC6"},@{"SourceFilePath" = "$DiskD6"; "DestinationFilePath" = "$DiskD6"},@{"SourceFilePath" = "$DiskE6"; "DestinationFilePath" = "$DiskE6"},@{"SourceFilePath" = "$DiskF6"; "DestinationFilePath" = "$DiskF6"})
            }  #End IF                   
                      
        } # End $Vms | OGV    

} # End Function

getVM
