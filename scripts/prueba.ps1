# Descargar el script remoto utilizando Invoke-WebRequest
$scriptUrl = "https://raw.githubusercontent.com/Dejavu75/WebScripts/main/probar.ps1"
$scriptContent = Invoke-WebRequest $scriptUrl | Select-Object -ExpandProperty Content

# Ejecutar el script descargado utilizando Invoke-Expression
Invoke-Expression $scriptContent