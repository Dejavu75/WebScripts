
$KeyT="HKLM:\SOFTWARE\Prueba"
$acl = Get-Acl -Path $KeyT
$rule = New-Object System.Security.AccessControl.RegistryAccessRule (".\Usuarios","FullControl",@("ObjectInherit","ContainerInherit"),"None","Allow")
$acl.SetAccessRule($rule)
Set-Acl -Path $KeyT -AclObject $acl
write-host "Finalizado"

#$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Prueba",[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)
#$acl = $key.GetAccessControl()

#$acl.SetAccessRule($rule)
#$key.SetAccessControl($acl)
