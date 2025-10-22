$VMNamesXP = "winxp-halina","winxp-anton","winxp-kasia","WINXP-AGNIESZKA","WINXP-GOSIAM","WINXP-GRZESIEK","WINXP-KUBA","WINXP-LUKASZ","WINXP-MARTA","WINXP-MONIKA","WINXP-ZBYSZEK"

foreach ($VMNameXP in $VMNamesXP)
{
echo $VMNameXP
New-PSSession -ComputerName $VMNameXP
}
Get-PSSession

Invoke-Command -Session $vmnamesXP  -ScriptBlock{Get-Culture}

Invoke-Command -ComputerName $VMNamesXP -ScriptBlock{ps kameleon}

Invoke-Command -ComputerName $VMNamesXP -ScriptBlock{ps FIRMA}

Invoke-Command -ComputerName $xphosts -ScriptBlock{ps FIRMA}

Invoke-Command -ComputerName $VMNamesXP -ScriptBlock{kill -processname kameleon -force}

Invoke-Command -ComputerName $VMNamesXP -ScriptBlock{Stop-Computer}

Get-ADComputer -Filter 'objectclass -eq "Computer"' | Select -expand Name
    
$takohosts = Get-ADComputer -Filter 'objectclass -eq "Computer"' | Select -expand Name    
    
echo $takohosts
    
Invoke-Command -ComputerName $takohosts -ScriptBlock{ps explorer}    
    
    
Get-ADComputer -Filter { OperatingSystem -Like 'Windows XP*' } -Properties OperatingSystem | 
 Select Name, OperatingSystem | 
 Format-Table -AutoSize

 Get-ADComputer -Filter { OperatingSystem -Like 'Windows XP*' } -Properties OperatingSystem | 
 Select Name, OperatingSystem | 
 Format-Table -HideTableHeaders



 Get-ADComputer -Filter { OperatingSystem -Like 'Windows XP*' } -Properties OperatingSystem | 
 Select Name | Format-Table -HideTableHeaders

 #Wyświetlenie wszystkich komputerów w domenie z system Windows XP po nawie hosta, dzięki "foreach {$_.Name}" nadaje się do wpisania do zmiennej w przeciwieństwie 
 # do Format-Table - hideTableHeaders
 Get-ADComputer -Filter { OperatingSystem -Like 'Windows XP*' } -Properties OperatingSystem | 
 foreach {$_.Name}

Get-ADComputer -Filter{ name -like 'winxp-*'} | foreach {$_.Name}  > F:\skrypty-ps\hostyXP.txt

$xphosts = Get-ADComputer -Filter{ name -like 'win7-*'} | foreach {$_.Name}

echo $xphosts


function killkame \{


# Pobiera nazwy wszystkich komputerów w domenie i wykonuje po kolei na każdym polecenie

# Pobranie wszytkich informacji o wszytkich komputerach w domenie, "foreach {$_.name}" wyrzuca nazwy hostów w odzdielnych wierszach bez formatowania
$alldomainHosts = Get-ADComputer -Filter * | foreach {$_.name}
# Wykonanie na każdym hoście po kolei poecenia ping
foreach ($domainhost in $alldomainHosts) {ping -n 1 $domainhost}


Invoke-Command -ComputerName $VMNamesXP -ScriptBlock{Copy-Item -Path \\w2008-ad435\deploy\zabbix -Destination c:\ -Force -Recurse}

Copy-Item -Path \\w2008-ad435\deploy\zabbix



# Port dla Zabbixa

$zabbixPort = {

$port = New-Object -ComObject HNetCfg.FWOpenPort 
$port.Port = 10050 
$port.Name = 'zabbix' 
$port.Enabled = $true 
$fwMgr = New-Object -ComObject HNetCfg.FwMgr
$profile = $fwMgr.LocalPolicy.CurrentProfile 
$profile.GloballyOpenPorts.Add($port)
}

foreach ($VMNameXP in $VMNamesXP) {

Invoke-Command -ComputerName $VMNameXP -ScriptBlock $zabbixPort }

#-----------------------#
# aktualizacja kameleon #
#-----------------------#


$VMNamesXP = Get-ADComputer -Filter{ name -like 'winxp-*'} | foreach {$_.Name}

Invoke-Command -ComputerName $VMNamesXP -ScriptBlock{kill -processname kameleon -force}

foreach ($VMNameXP in $VMNamesXP)
{
$source = '\\w2008-ad435\deploy\kameleon.exe'
$destination = "\\$VMNameXP\c$\Program Files\WilkSoft\Kameleon\"
Copy-Item -Path $source -Destination $destination
}


#-----------------------#
# skrót kameleon        #
#-----------------------#


$VMNamesXP = Get-ADComputer -Filter{ name -like 'winxp-*'} | foreach {$_.Name}

foreach ($VMNameXP in $VMNamesXP)
{
$source = '\\w2008-ad435\deploy\kameleon.lnk'
$destination = "\\$VMNameXP\C$\Documents and Settings\All Users\Pulpit"
Copy-Item -Path $source -Destination $destination
}

#-----------------------#
# zabbix                #
#-----------------------#


$VMNamesXP = Get-ADComputer -Filter{ name -like 'winxp-*'} | foreach {$_.Name}

foreach ($VMNameXP in $VMNamesXP)
{
$source = '\\w2008-ad435\deploy\zabbix\*'
$destination = "\\$VMNameXP\C$\"
Copy-Item -Path $source -Destination $destination -Recurse
}

#zmiana hosta w configu zabbix'a

function setConfig( $file, $key, $value ) {
    $content = Get-Content $file
    if ( $content -match "^$key\s*=" ) {
        $content -replace "^$key\s*=.*", "$key=$value" |
        Set-Content $file     
    } else {
        Add-Content $file "$key = $value"
    }
}

foreach ($VMNameXP in $VMNamesXP) 
{
setConfig \\$vmnamexp\C$\zabbix_agentd.conf Hostname $vmnamexp
}

###################################################################
#instalacja zabbixa jako uslugi

foreach ($VMNameXP in $VMNamesXP)
{
Invoke-Command -ComputerName $VMNameXP -ScriptBlock {C:\bin\win32\zabbix_agentd.exe -i}
}

######################################################################################
#  funkcja zmiany wartosci w plikach konfiguracyjnych, rozbudowana wersja powyzszego #
######################################################################################

Function Set-FileConfigurationValue()
{
    [CmdletBinding(PositionalBinding=$false)]   
    param(
        [Parameter(Mandatory)][string][ValidateScript({Test-Path $_})] $Path,
        [Parameter(Mandatory)][string][ValidateNotNullOrEmpty()] $Key,
        [Parameter(Mandatory)][string][ValidateNotNullOrEmpty()] $Value,
        [Switch] $ReplaceExistingValue,
        [Switch] $ReplaceOnly
    )

    $content = Get-Content -Path $Path
    $regreplace = $("(?<=$Key).*?=.*")
    $regValue = $("=" + $Value)
    if (([regex]::Match((Get-Content $Path),$regreplace)).success)
    {
        If ($ReplaceExistingValue)
        {
            Write-Verbose "Replacing configuration Key ""$Key"" in configuration file ""$Path"" with Value ""$Value"""
            (Get-Content -Path $Path) | Foreach-Object { [regex]::Replace($_,$regreplace,$regvalue) } | Set-Content $Path
        }
        else
        {
            Write-Warning "Key ""$Key"" found in configuration file ""$Path"". To replace this Value specify parameter ""ReplaceExistingValue"""
        }
    } 
    elseif (-not $ReplaceOnly) 
    {    
        Write-Verbose "Adding configuration Key ""$Key"" to configuration file ""$Path"" using Value ""$Value"""
        Add-Content -Path $Path -Value $("`n" + $Key + "=" + $Value)       
    }
    else
    {
        Write-Warning "Key ""$Key"" not found in configuration file ""$Path"" and parameter ""ReplaceOnly"" has been specified therefore no work done"
    }
}

#-------------------------------------#
# funkcja kopiowania z progress barem #
#-------------------------------------#


function Copy-File {
    param( [string]$from, [string]$to)
    $ffile = [io.file]::OpenRead($from)
    $tofile = [io.file]::OpenWrite($to)
    Write-Progress -Activity "Copying file" -status "$from -> $to" -PercentComplete 0
    try {
        [byte[]]$buff = new-object byte[] 4096
        [int]$total = [int]$count = 0
        do {
            $count = $ffile.Read($buff, 0, $buff.Length)
            $tofile.Write($buff, 0, $count)
            $total += $count
            if ($total % 1mb -eq 0) {
                Write-Progress -Activity "Copying file" -status "$from -> $to" `
                   -PercentComplete ([int]($total/$ffile.Length* 100))
            }
        } while ($count -gt 0)
    }
    finally {
        $ffile.Dispose()
        $tofile.Dispose()
    }
}

#-----------------------#
# czyszczenie TEMP w XP #
#-----------------------#


$VMNamesXP = Get-ADComputer -Filter{ name -like 'winxp-*'} | foreach {$_.Name}

foreach ($VMNameXP in $VMNamesXP)
{
$destination = "\\$VMNameXP\C$\Windows\TEMP\"
Remove-Item $destination -Recurse -Force
}

