$Days = 30
$UninstallStrings = @()
$Updates = Get-Hotfix | where {$_.InstalledOn -gt $((Get-Date).AddDays(-$Days))} | select HotFixID
foreach ($Update in $Updates)
{
    $UninstallStrings += " /uninstall /kb:$(($Update.HotFixID).Replace('KB','')) /quiet /norestart"
}

$UninstallStrings

foreach ($UninstallString in $UninstallStrings)
{
    Start-Process wusa.exe -ArgumentList $UninstallString -Wait
}