$port = New-Object -ComObject HNetCfg.FWOpenPort 
$port.Port = 10050 
$port.Name = 'zabbix' 
$port.Enabled = $true 
$fwMgr = New-Object -ComObject HNetCfg.FwMgr
$profile = $fwMgr.LocalPolicy.CurrentProfile 
$profile.GloballyOpenPorts.Add($port)