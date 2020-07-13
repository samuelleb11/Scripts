#region VARIABLES
$Date = (Get-Date -Hour 00 -Minute 00 -Second 00).AddHours(-10)  #AddDays(-1)
$Global:var_Sys_DateFormat = "yyyy-MM-dd hh:mm:ss"
$Global:var_Sys_CurrentDate = Get-Date -Format $Global:var_Sys_DateFormat | Out-String
$Global:var_Sys_RegistryKeyName = "VeeamBackup"
$Global:var_Sys_RegistryRoot = "HKLM:\SOFTWARE\MicroAgeQC"
$Global:var_Sys_RegistryFullPath = Join-Path -Path $Global:var_Sys_RegistryRoot -ChildPath $Global:var_Sys_RegistryKeyName
$Global:var_Sys_VeeamEventList = @()
$Global:var_Sys_VeeamFilteredEventList = @()
$Global:var_Sys_Reg_KeyList = @("LastScanDate","ExcludeKeyword")
$Global:var_Sys_Reg_LastScanDate = ""
$Global:var_Sys_Reg_ExcludeKeyword = $null
$Global:var_Sys_List_ExcludeKeyword = @()
#endregion VARIABLES

#region FUNCTIONS
function Manage-Registry ($RegPath,$KeyName,$KeyValue,[switch]$Create,[switch]$Update)
{
    if ($Create)
    {
        New-ItemProperty -Path $RegPath -Name $KeyName -Value $KeyValue | Out-Null
    }
    if ($Update)
    {
        New-ItemProperty -Path $RegPath -Name $KeyName -Value $KeyValue -Force | Out-Null
    }
}

function Check-Keywords ($KeywordList,$ValueToCheck)
{
    $result = $null
    foreach ($Keyword in $KeywordList)
    {
        if ($Keyword -ne "")
        {
            if ($ValueToCheck -match $Keyword)
            {
                $result = $true
            }
            else
            {
                $result = $false
            }
        }
        else
        {
            $result = $false
        }
    }
    return $result
}
#endregion FUNCTIONS

#region PRE-RUNTIME
#CHECK IF THE RegistryKey FOR THE CURRENT SCRIPT EXIST AND CREATE IT
if (!(Test-Path -Path (Join-Path -Path $Global:var_Sys_RegistryRoot -ChildPath $Global:var_Sys_RegistryKeyName)))
{
    New-Item -Path $Global:var_Sys_RegistryRoot -Name $Global:var_Sys_RegistryKeyName -Force | Out-Null
    Manage-Registry -Create -RegPath $Global:var_Sys_RegistryFullPath -KeyName LastScanDate -KeyValue ""
    Manage-Registry -Create -RegPath $Global:var_Sys_RegistryFullPath -KeyName ExcludeKeywords -KeyValue ""
}

# CHECK IF ALL REGISTRY KEYS IN KeyList ARE EXISTING AND IMPORT THEM
foreach ($Key in $Global:var_Sys_Reg_KeyList)
{
    $prop = Get-ItemProperty -Path $Global:var_Sys_RegistryFullPath -Name $Key -ErrorAction SilentlyContinue
    if (-not $prop)
    {
        Manage-Registry -Create -RegPath $Global:var_Sys_RegistryFullPath -KeyName $Key -KeyValue ""
    }
    Set-Variable -Name var_Sys_Reg_$Key -Value ((Get-ItemProperty -Path $Global:var_Sys_RegistryFullPath).$Key)
}

# IMPORT ARRAY OF EXCLUDE KEYWORD
$KeyworkList = $Global:var_Sys_Reg_ExcludeKeyword.Split(";")
foreach ($Keyword in $KeyworkList)
{
    $Global:var_Sys_List_ExcludeKeyword += $Keyword
}

# GET THE VEEAM EVENT LIST AFTER THE LAST SCAN DATE EXCLUDING KEYWORD IN REGISTRY
$Global:var_Sys_VeeamEventList = Get-EventLog -LogName 'Veeam Backup' -After $Date
foreach ($VeeamEvent in $Global:var_Sys_VeeamEventList)
{
    if (!(Check-Keywords -KeywordList $Global:var_Sys_List_ExcludeKeyword -ValueToCheck $VeeamEvent.Message))
    {
        $Global:var_Sys_VeeamFilteredEventList += $VeeamEvent
    }
}
#endregion PRE-RUNTIME

#region RUNTIME
$OffsiteBackupState = 0
$LocalBackupState = 0
$LocalBackupMessages = ""
$OffsiteBackupMessages = ""
foreach ($Event in $Global:var_Sys_VeeamFilteredEventList)
{
    if ($LocalBackupState -eq 0)
    {
        if ($Event.InstanceID -eq 190 -and $Event.EntryType -eq "Warning")
        {
            $LocalBackupMessages = $Event.Message
            $LocalBackupState = 1
        }
        if ($Event.InstanceID -eq 190 -and $Event.EntryType -eq "Error")
        {
            $LocalBackupMessages = $Event.Message
            $LocalBackupState = 2
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
        if ($Event.InstanceID -eq 490 -and $Event.EntryType -eq "Error")
        {
            $OffsiteBackupMessages = $Event.Message
            $OffsiteBackupState = 2
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
$LastCheckTime = Get-Date
$ExcludeKeywords = $Global:var_Sys_Reg_ExcludeKeyword
$ExcludeKeywords
$LastCheckTime
$LocalBackupMessages
$LocalBackupState
$OffsiteBackupState
$OffsiteBackupMessages

#endregion RUNTIME

# SET THE LASTSCANDATE VALUE FOR NEXT SCAN
Manage-Registry -Update -RegPath $Global:var_Sys_RegistryFullPath -KeyName LastScanDate -KeyValue $Global:var_Sys_CurrentDate