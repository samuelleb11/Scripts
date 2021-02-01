$logs = get-eventlog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-31);
$res = @(); ForEach ($log in $logs) {if($log.instanceid -eq 7001) {$type = "Logon"} Elseif ($log.instanceid -eq 7002){$type="Logoff"} Else {Continue} $res += New-Object PSObject -Property @{Time = $log.TimeWritten; "Event" = $type; User = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])}};
$res | Export-Csv -Path C:\temp\LogonLogs.csv -NoTypeInformation

#RDP
$LogName = 'Microsoft-Windows-TerminalServices-LocalSessionManager/Operational'
$Results = @()
$Events = Get-WinEvent -LogName $LogName
foreach ($Event in $Events) {
    $EventXml = [xml]$Event.ToXML()

    $ResultHash = @{
        Time        = $Event.TimeCreated.ToString()
        'Event ID'  = $Event.Id
        'Desc'      = ($Event.Message -split "`n")[0]
        Username    = $EventXml.Event.UserData.EventXML.User
        'Source IP' = $EventXml.Event.UserData.EventXML.Address
        'Details'   = $Event.Message
    }

    $Results += (New-Object PSObject -Property $ResultHash)
}

$Results | Export-Csv -Path C:\temp\RDPLogs.csv -NoTypeInformation