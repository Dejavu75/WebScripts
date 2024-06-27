# Define la URL base para las versiones de PowerShell
$repoUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"

# Descargar la información de la última versión
$response = Invoke-RestMethod -Uri $repoUrl

# Filtrar el asset que corresponde a la versión de PowerShell para Windows
$asset = $response.assets | Where-Object { $_.name -match "win-x64.msi" }

# Definir la ruta donde se descargará el instalador
$installerPath = "$env:TEMP\PowerShell-latest.msi"

# Descargar el instalador
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installerPath

# Instalar PowerShell
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", $installerPath, "/quiet", "/norestart" -Wait

# Eliminar el instalador después de la instalación
Remove-Item -Path $installerPath

Write-Output "La última versión de PowerShell se ha instalado correctamente."
