#folder1 

$source = "F:\skrypty-backup"
$destination = "F:\Dropbox\Dropbox\skrypty-backup"
Robocopy.exe $source $destination /E

#folder2 

$source = "f:\skrypty-ps"
$destination = "F:\Dropbox\Dropbox\skrypty-ps"
Robocopy.exe $source $destination /E