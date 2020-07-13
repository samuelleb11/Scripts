$Date = (Get-Date -Hour 00 -Minute 00 -Second 00).AddDays(-1)
$global:BackupSoftware = ""
$global:VeeamEventList = @()
$global:AltaroEventList = @()
if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Veeam Endpoint Backup")
{
    $global:BackupSoftware = "Veeam"
    $global:VeeamEventList = Get-EventLog -LogName 'Veeam Endpoint Backup' -After $Date
}
elseif (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Veeam Endpoint Backup")
{
    $global:BackupSoftware = "Veeam"
    $global:VeeamEventList = Get-EventLog -LogName 'Veeam Backup' -After $Date
}
elseif (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\Altaro VM Backup")
{
    $global:BackupSoftware = "Altaro"
    $global:AltaroEventList = Get-EventLog -LogName 'Application' -Source "Altaro VM Backup" -After $Date
}

$OffsiteBackupState = 0
$LocalBackupState = 0
$LocalBackupMessages = ""
$OffsiteBackupMessages = ""

if ($global:BackupSoftware -eq "Veeam")
{
    foreach ($Event in $global:VeeamEventList)
    {
        if ($LocalBackupState -eq 0)
        {
            if ($Event.InstanceID -eq 190 -and $Event.EntryType -eq "Warning")
            {
                $LocalBackupMessages = $Event.Message
                $LocalBackupState = 1
            }
        }
        if ($LocalBackupState -le 1)
        {
            if ($Event.InstanceID -eq 190 -and $Event.EntryType -eq "Error")
            {
                $LocalBackupMessages = $Event.Message
                $LocalBackupState = 2
            }
        }
        if ($OffsiteBackupState -eq 0)
        {
            if ($Event.InstanceID -eq 490 -and $Event.EntryType -eq "Warning")
            {
                $OffsiteBackupMessages = $Event.Message
                $OffsiteBackupState = 1
            }
        }
        if ($OffsiteBackupState -le 1)
        {
            if ($Event.InstanceID -eq 490 -and $Event.EntryType -eq "Error")
            {
                $OffsiteBackupMessages = $Event.Message
                $OffsiteBackupState = 2
            }
        }
    }
}
if ($global:BackupSoftware -eq "Altaro")
{
    foreach ($Event in $global:AltaroEventList)
    {
    if ($LocalBackupState -eq 0)
    {
        if ($Event.InstanceID -eq 5001 -and $Event.EntryType -eq "Warning")
        {
            $LocalBackupMessages = $Event.Message
            $LocalBackupState = 1
        }
    }
    if ($LocalBackupState -le 1)
    {
        if ($Event.InstanceID -eq 5002 -and $Event.EntryType -eq "Error")
        {
            $LocalBackupMessages = $Event.Message
            $LocalBackupState = 2
        }
    }
    if ($OffsiteBackupState -le 1)
    {
        if ($Event.InstanceID -eq 5007 -and $Event.EntryType -eq "Error")
        {
            $OffsiteBackupMessages = $Event.Message
            $OffsiteBackupState = 2
        }
    }
}
}
# Begin output to N-Central
$LocalBackupMessages
$LocalBackupState
$OffsiteBackupState
$OffsiteBackupMessages