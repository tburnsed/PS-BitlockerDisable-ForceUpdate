#start logging
$name = hostname
$date = get-date -f yyyy-MM-dd----hh-mm_ss
$filename = $name + "--" +  $date +".txt"
$filepath = "\\192.168.80.20\it\UpgradeLogs\"+$filename
$filepath
New-Item $filepath


#Disable BL
write-host "current status:" | Add-Content -Path $filepath
$status = Get-BitLockerVolume -MountPoint 'C:' | Select-Object -ExpandProperty Protectionstatus | Add-Content -Path $filepath
write-host "Running unlock command...." | Add-Content -Path $filepath
manage-bde -protectors -disable C: | Add-Content -Path $filepath

#Check if disabled and run update
write-host "Re-checking lock status...." | Add-Content -Path $filepath
$status = Get-BitLockerVolume -MountPoint 'C:' | Select-Object -ExpandProperty Protectionstatus | Add-Content -Path $filepath


if ($status -eq "off")
        {write-host "protection off running update" | Add-Content -Path $filepath
        Invoke-WebRequest https://go.microsoft.com/fwlink/?LinkID=799445 -OutFile C:\Windows\Temp\Windows10Upgrade9252.exe | Add-Content -Path $filepath
        C:\Windows\Temp\Windows10Upgrade9252.exe /quietinstall /skipeula /auto upgrade  | Add-Content -Path $filepath
        
       }

else { write-host "Error. protection still on exiting" | Add-Content -Path $filepath
       exit 
       
       }

