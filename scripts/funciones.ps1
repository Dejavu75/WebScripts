

function SumarUno($numero) {
    $numero + 1
}
function Mostrar_terminado {
    write-host -back Black -fore Black .
    write-host -back Black -fore Green Script terminado... 
    write-host -back Black -fore Black .
    write-host -back Black -fore Green Presione una tecla para cerrar el PowerShell 
}
function UsuarioTodos($usuario) {
    write-host -fore Green Intentando con $usuario


    New-SmbShare -Name "GES$" -Path $systemPath -FullAccess $usuario -ErrorAction SilentlyContinue  | Out-Null


    if (!$?) {
        $usuario = "Todos"
        write-host -fore Red Dio error, pasando a $usuario
        New-SmbShare -Name "GES$" -Path $systemPath -FullAccess $usuario | Out-Null
    }
    


}