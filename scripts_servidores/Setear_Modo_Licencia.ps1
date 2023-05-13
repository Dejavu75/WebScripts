$obj = gwmi -namespace "Root/CIMV2/TerminalServices" Win32_TerminalServiceSetting
$obj.ChangeMode(4)
$obj.SetSpecifiedLicenseServerList("Server")