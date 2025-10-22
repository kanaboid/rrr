 #----------------------------#
# kopiowanie do remote hosta #
#----------------------------#
 
 $date = Get-Date -Format dd-MM-yyyy
 New-PSDrive -Name "Backup" -PSProvider Filesystem -Root "\\192.168.4.5\media3\BACKUP-VM"
 $source = "F:\BackupVM-VEEAM\" #zrodlo
 $destination = "backup:\$date"
 $path = test-Path $destination
 
#Email Variables

 $smtp = "tako.net.pl"
 $from = "BACKUP-VM-COPY <radek.k@tako.net.pl>"
 $to = "RADEK K <radek.k@tako.net.pl>"
 $body = "Log z kopiowania backup'ow maszyn wirtualnych z dnia: $date"
 $subject = "Kopia backup'ow VM $date"
 
# Backup Process started

 if ($path -eq $true) {
    write-Host "Directory Already exists"
    Remove-PSDrive "Backup"  
    } elseif ($path -eq $false) {
            cd backup:\
            mkdir $date
            copy-Item  -Recurse $source -Destination $destination
            $backup_log = Dir -Recurse $destination | out-File "$destination\backup_log.txt"
            $attachment = "$destination\backup_log.txt"
#Send an Email to User 
            send-MailMessage -SmtpServer $smtp -From $from -To $to -Subject $subject -Attachments $attachment -Body $body -BodyAsHtml
            write-host "Backup Sucessfull"
            cd c:\
 
 Remove-PSDrive "Backup"  
 }