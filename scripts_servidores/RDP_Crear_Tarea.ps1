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

$KeyT="HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod"
$acl = Get-Acl -Path $KeyT
$rule = New-Object System.Security.AccessControl.RegistryAccessRule (".\Usuarios","FullControl",@("ObjectInherit","ContainerInherit"),"None","Allow")
$acl.SetAccessRule($rule)
Set-Acl -Path $KeyT -AclObject $acl

$Usuario = Read-Host "Usuario"
$Clave = Read-Host "Clave"


Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Dejavu75/WebScripts/main/scripts_servidores/RDPTimeBomb.ps1" -OutFile "C:\windows\RDPTimeBomb.ps1" -UseBasicParsing
$Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File C:\windows\RDPTimeBomb.ps1'
$Trigger =  New-ScheduledTaskTrigger -Weekly  -WeeksInterval 4 -At 2:45am -DaysOfWeek Sunday
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Solinges\RDP Timebomb" -Description "Tarea programada generada por la consola." -User $Usuario -Password $Clave

write-host "Recuerde convertir en propietario al usuario " + $Usuario
write-host "de la clave HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod"