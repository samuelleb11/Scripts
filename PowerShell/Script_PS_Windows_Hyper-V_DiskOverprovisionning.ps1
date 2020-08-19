function Check-VMOverprovisionning
{
    $PSDriveList = Get-WmiObject -Class Win32_logicaldisk
    $VMList = Get-VM
    $VMDiskList = $VMList | Get-VMHardDiskDrive

    foreach ($PSDrive in $PSDriveList)
    {
        Write-Host -ForegroundColor Yellow "Checking drive"$PSDrive.DeviceID
        $PSDriveLetter = $PSDrive.DeviceID -replace ":", ""
        $PSDriveSize = $PSDrive.Size
        $PSDriveFreeSpace = $PSDrive.FreeSpace
        $VMDiskSizesList = $VMDiskList | Get-VHD | Where-Object {$_.Path -like $($PSDriveLetter + ":\*")}
        $VMDiskTotalSize = 0
        $VMDiskTotalFileSize = 0
        $VMDiskTotalMaximumSize = 0

        Write-Host -ForegroundColor Cyan "Total drive size :" $([math]::round($PSDriveSize/1GB, 3))"GB"
        Write-Host -ForegroundColor Cyan "Free space :" $([math]::round($PSDriveFreeSpace/1GB, 3))"GB"

        if ($VMDiskSizesList -eq $null)
        {
            Write-Host ""
            Write-Host "No VHDs on drive"$PSDrive.DeviceID"are attached ... Skipping"
        }
        else
        {
            foreach ($i in $VMDiskSizesList)
            {
                $VMDiskTotalSize = $VMDiskTotalSize + $i.Size
                $VMDiskTotalFileSize = $VMDiskTotalFileSize + $i.FileSize
                $VMDiskTotalMaximumSize = $VMDiskTotalMaximumSize + $i.MaximumSize
            }

            $PossibleVHDsGrowth = $VMDiskTotalSize - $VMDiskTotalFileSize

            Write-Host ""
            Write-Host -ForegroundColor Yellow "VHD list : "

            $VMDiskSizesList | select ComputerName, Path, VhdFormat, VhdType, @{Name="FileSize (GB)";Expression={[math]::round($_.FileSize/1GB, 3)}}, @{Name="Size (GB)";Expression={[math]::round($_.Size/1GB, 3)}}, @{Name="MinimumSize (GB)";Expression={[math]::round($_.MinimumSize/1GB, 3)}}, LogicalSectorSize, PhysicalSectorSize, BlockSize | ft

            if ($PossibleVHDsGrowth -gt $PSDriveFreeSpace)
            {
                $i = [math]::round($($PossibleVHDsGrowth - $PSDriveFreeSpace) /1GB, 3)
                Write-Host -ForegroundColor Red "Overprovisioned by" $i "GB"
            }
            else
            {
                $i = [math]::round($($PSDriveFreeSpace - $PossibleVHDsGrowth) /1GB, 3)
                Write-Host -ForegroundColor Green "Remaining real free space : " $i "GB"
            }
        }
        Write-Host ""
    }
}

Check-VMOverprovisionning
