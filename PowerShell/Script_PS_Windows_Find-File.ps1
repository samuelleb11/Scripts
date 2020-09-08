function Find-File ($SearchString, $ExcludedDriveLetters, $SearchPath, [Switch]$LocalDisksOnly, [ValidateSet("Text",“CSV”,”HTML”,”XML”)]$ExportTo, [ValidateSet("TB","GB”,”MB”,”KB”)]$RoundSizeTo = "MB", $SizeDecimals = 2)
{
    if ([string]::IsNullOrEmpty($SearchPath)){$PSDriveList = Get-WmiObject -Class Win32_logicaldisk}

    $Result = @()

    foreach ($PSDrive in $PSDriveList)
    {
        $Excluded = $false
        
        foreach ($ExcludedDriveLetter in $ExcludedDriveLetters)
        {
            if ($PSDrive.DeviceID -like $ExcludedDriveLetter)
            {
                $Excluded = $true
            }
        }

        if ($Excluded){continue}

        if ($LocalDisksOnly)
        {
            if ($PSDrive.DriveType -ne "3")
            {continue}
        }

        if (![string]::IsNullOrEmpty($SearchPath))
        {
            $Result += Get-ChildItem -Path $SearchPath -Filter $SearchString -Recurse -Force -ErrorAction SilentlyContinue
        }
        else{$Result += Get-ChildItem -Path $($PSDrive.DeviceID + "\") -Filter $SearchString -Recurse -Force -ErrorAction SilentlyContinue}
    }

    $Result = $Result | select Name, @{Name="Path";Expression={$_.FullName}}, @{Name="Size ($RoundSizeTo)";Expression={[math]::round($_.Length/$("1$RoundSizeTo"), $SizeDecimals)}}, CreationTime, LastWriteTime

    if (![string]::IsNullOrEmpty($ExportTo))
    {
        $ExportPath = Read-Host -Prompt "Please enter the file name (.txt, .html, .csv, .xml)"

        if ($ExportTo -eq "Text")
        {
            $Result | Out-File -FilePath $ExportPath
        }
        if ($ExportTo -eq "CSV")
        {
            $Result | Export-Csv -Path $ExportPath -NoTypeInformation
        }
        if ($ExportTo -eq "HTML")
        {
            $Result | ConvertTo-Html | Out-File -FilePath $ExportPath
        }
        if ($ExportTo -eq "XML")
        {
            $Result | Export-Clixml -Path $ExportPath
        }
    }
    else{return $Result | ft}
}

Find-File -SearchString "*.pst" -ExcludedDriveLetters 'C:' -RoundSizeTo MB