#
# Shutdown VMs and change Azure SQL Database Tier.
#
Connect-AzAccount

Function Get-VmStatus{
$VMStatus=Get-AzVm | Get-AzVm -Status | select ResourceGroupName, Name, @{n="Status"; e={$_.Statuses[1].DisplayStatus}}
}

Function Stop-Vm{

try{ 
#region Loop
Foreach($Status in $VMStatus){
    
    If ($Status.Status -like "*running*"){
        Write-Host "Vm is running!!:" $Status.Name
        Write-Host "Stopping...."
        Stop-Azvm -Name $Status.Name -ResourceGroupName $Status.ResourceGroupName
        Write-Host "Done...." -ForegroundColor Red
    }
    else {
        Write-Host "Vm is not running!!:"  $Status.Name -ForegroundColor Red
    }     
}
#endregion Loop 
} #End Try
    catch {
    Write-Host $_.Exception.Message -ForegroundColor Green
    } # End catch
} # End Function


Function SQL-Tier{

$SQLServer=Get-AzResourceGroup | Get-AzSqlServer | Select-Object servername,ResourceGroupName
    Foreach($SQL in $SQLServer){
    $Resou= $SQL.ResourceGroupName
    [string]$SQlServ = $SQL.servername
    get-AzSqlDatabase -ServerName $SQlServ -ResourceGroupName $Resou | Set-AzSqlDatabase -Edition Basic 
    }

}

Get-VmStatus
Stop-Vm
SQL-Tier
