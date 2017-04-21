$LogFile = "E:\2016-11-07\WIFI_" + (get-date -Format 'yyyy-MM-dd') + ".log"
$TargetSSID = "AT_Guest"

$HostsFile_InternalIP = "C:\Windows\System32\drivers\etc\hosts_internalIP"
$HostsFile_NoInternalIP = "C:\Windows\System32\drivers\etc\hosts_NointernalIP"
$HostsFile = "C:\Windows\System32\drivers\etc\hosts"

"***** Triggered by WIFI connection/disconnection events *****" | Out-File -Append $LogFile
(get-date -Format 'yyyy-MM-dd HH:mm:ss').ToString() | Out-File -Append $LogFile

try
{
    $match = netsh wlan show interfaces | Select-String '\sSSID'
    if($match -eq $null)  #Disconnected from WIFI
    {
        #TO DO: copy hosts_NointernalIP to host
        "no wifi connection detected" | Out-File -Append $LogFile
        Copy-Item -Path $HostsFile_NoInternalIP -Destination $HostsFile -Force
        "copied " + $HostsFile_NoInternalIP + " --> " + $HostsFile | Out-File -Append $LogFile
    }
    else #Connected to WIFI
    {
        #extract the SSID
        $wifi = $match.ToString()
        $indexOfColon = $wifi.IndexOf(':')
        $SSID = $wifi.Substring($indexOfColon + 1).Trim()
        
        "Connected to " + $SSID | Out-File -Append $LogFile
        If ($SSID -eq $TargetSSID)
        {
            #TO DO: copy hosts_InternalIP to host            
            Copy-Item -Path $HostsFile_InternalIP -Destination $HostsFile -Force
            "copied " + $HostsFile_InternalIP + " --> " + $HostsFile | Out-File -Append $LogFile
        }
        else
        {
            "no changes made to the hosts file" | Out-File -Append $LogFile
        }
    }
    exit 0
}
catch [Exception]
{
    $_.Exception.Massage | Out-File -Append $LogFile
    exit 1
}




