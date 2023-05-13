If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    if ($elevated) {
        write-host "Intenté elevar el proceso y no funcionó!!!" -ForegroundColor red 
	Exit
    }
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))    
	Exit
    }

}

$credential = Get-Credential
Write-Host Usuario $credential.UserName
Write-Host Clave $credential.Password

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Dejavu75/WebScripts/main/scripts_servidores/RDPTimeBomb.ps1" -OutFile "C:\windows\RDPTimeBomb.ps1" -UseBasicParsing
$Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File C:\windows\RDPTimeBomb.ps1'
$Trigger =  New-ScheduledTaskTrigger -Weekly  -WeeksInterval 4 -At 2:45am -DaysOfWeek Sunday
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Solinges\RDP Timebomb" -Description "Tarea programada generada por la consola." -User $credential.UserName -Password $credential.Password
