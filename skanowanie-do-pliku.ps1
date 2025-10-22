#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force
rm C:\SCAN\*.*
$deviceManager = new-object -ComObject WIA.DeviceManager
$device = $deviceManager.DeviceInfos.Item(1).Connect()    

$wiaFormatPNG = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}"
foreach ($item in $device.Items) { 
    $image = $item.Transfer($wiaFormatPNG) 
}    

if($image.FormatID -ne $wiaFormatPNG)
{
    $imageProcess = new-object -ComObject WIA.ImageProcess
    $imageProcess.Filters.Add($imageProcess.FilterInfos.Item("Convert").FilterID)
    $imageProcess.Filters.Item(1).Properties.Item("FormatID").Value = $wiaFormatPNG
    $image = $imageProcess.Apply($image)
}
$fileScaned = "C:\SCAN\test.png"
$image.SaveFile("C:/SCAN/test.png")
Start-Process  C:\windows\system32\mspaint.exe -Arg '/p "C:\SCAN\test.png" /pt "Samsung"' 
Start-Sleep -s 1
if (Test-Path -Path C:\WINDOWS\System32\spool\PRINTERS\*.*)
{
rm $fileScaned
}
else
{
Start-Sleep -s 1
}

Get-Item -Path C:\WINDOWS\System32\spool\PRINTERS\*.*

#$fileScaned | Out-Printer -Name "Samsung"


