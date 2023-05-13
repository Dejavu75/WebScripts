# Obtener la dirección IP del equipo
$ip = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -like "*Ethernet*"} | Select-Object -ExpandProperty IPAddress

# Mostrar la dirección IP del equipo
Write-Host "La dirección IP del equipo es: $ip"

# Habilitar el escritorio remoto
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0

# Agregar una excepción de firewall para el escritorio remoto
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Enable-NetFirewallRule -DisplayGroup "Escritorio Remoto"

# Reiniciar el servicio de Escritorio remoto para aplicar los cambios
#Restart-Service -Name TermService -Force


