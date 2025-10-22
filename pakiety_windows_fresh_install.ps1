# Forcowanie poswiadczen
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force -WarningAction Continue
#Instalacja Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Potwierdzenie instalacji dla Choco
choco feature enable -n allowGlobalConfirmation
################################################
#Software basic
choco install googlechrome -force
choco install adguard-chrome
choco install firefox
choco install adblockplusfirefox
choco install opera
choco install adblockplusopera
choco install 7zip.install
choco install adobereader
choco install notepadplusplus.install
choco install totalcommander
choco install k-litecodecpackfull
choco install veeam-agent
choco install teamviewer
choco install zoom
choco install skype
choco install microsoft-teams
#################################################
#Software - office
choco install libreoffice-still
choco install thunderbird
#Biblioteki
choco install jre8
choco install vcredist2005
choco install vcredist2008
choco install vcredist2010
choco install vcredist2012
choco install vcredist2013
choco install vcredist2015
choco install vcredist2017
choco install vcredist140
choco install adobeair
choco install dotnetfx
choco install dotnet3.5
choco install directx
choco install dotnet-5.0-runtime
choco install dotnet-6.0-runtime
#################################################
#Software optional
#choco install microsoft-windows-terminal
#choco install chocolateygui
#choco install zabbix-agent
#choco install microsoft-teams.install
#################################################
#Software SERWSISOWE
#choco install ddu # Display Driver Uninstaller 18.0.4.8
#choco install sysinternals
#choco install msiafterburner
#choco install cpu-z
#choco install gpu-z
#choco install aida64-extreme.portable
#choco install ssd-z.portable
#choco install hwinfo.portable
#choco install crystaldiskinfo.install
#choco install heavyload.portable
#################################################
#Sterowniki
#choco install nvidia-display-driver
#choco install amd-ryzen-chipset
#################################################
#Security-trial
#choco install eset-nod32-antivirus
#choco install malwarebytes

