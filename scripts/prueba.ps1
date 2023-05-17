#Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Dejavu75/WebScripts/main/scripts/funciones.ps1" |  Invoke-Expression 


$oG=Get-LocalGroup -Sid S-1-5-32-545

Write-Host $oG
