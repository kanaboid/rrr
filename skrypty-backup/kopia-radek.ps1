# kopia marketing

$log = "\\192.168.4.5\media3\backup-radek\!marketing\log-z-kopiowania.txt"
$source = "\\192.168.4.5\media1\radek.k\!marketing"
$destination = "\\192.168.4.5\media3\backup-radek\!marketing"
Robocopy.exe $source $destination /E /log:$log


exit