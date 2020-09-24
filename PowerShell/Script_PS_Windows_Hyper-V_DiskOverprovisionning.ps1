function Check-VMOverprovisionning
{
    if((Get-WMIObject -Class MSCluster_ResourceGroup -ComputerName $env:COMPUTERNAME -Namespace root\mscluster -ErrorAction SilentlyContinue) -ne $null)
    {
        $CSVInfoList = @()
        $VMDiskList = @()
        $VMDiskInfoList = @()

        $CSVList = Get-ClusterSharedVolume
        foreach ($CSV in $CSVList)
        {
            $i = New-Object -TypeName psobject
            $i | Add-Member -MemberType NoteProperty -Name DeviceID -Value $(($CSV.SharedVolumeInfo).FriendlyVolumeName | Split-Path -Leaf)
            $i | Add-Member -MemberType NoteProperty -Name FreeSpace -Value ($CSV.SharedVolumeInfo).Partition.FreeSpace
            $i | Add-Member -MemberType NoteProperty -Name Size -Value ($CSV.SharedVolumeInfo).Partition.Size
            $i | Add-Member -MemberType NoteProperty -Name Volume -Value $CSV.Name
            $CSVInfoList += $i
        }

        # Get every cluster node for VM to check
        $ClusterVMList = Get-ClusterResource | Where {$_.ResourceType -eq "Virtual Machine"} | Get-VM
        $ClusterHostList = [System.Collections.ArrayList]@()
        foreach ($h in $ClusterVMList){If ($ClusterHostList -notcontains $($H.ComputerName)){$ClusterHostList.Add($($H.ComputerName))}}

        # Get VM list from cluster nodes
        foreach ($ClusterHost in $ClusterHostList)
        {
            $r = Get-VM -ComputerName $ClusterHost | Get-VMHardDiskDrive
            foreach ($g in $r)
            {
                $i = New-Object -TypeName psobject
                $i | Add-Member -MemberType NoteProperty -Name VMName -Value $g.VMName
                $i | Add-Member -MemberType NoteProperty -Name Path -Value $g.Path
                $i | Add-Member -MemberType NoteProperty -Name ClusterHost -Value $ClusterHost
                $VMDiskList += $i
            }
        }

        # Query cluster nodes for VHD infos
        foreach ($VMDisk in $VMDiskList)
        {
            $t = Get-VHD -ComputerName $VMDisk.ClusterHost -Path $VMDisk.Path
            $VMDiskInfoList += $t
        }

        # Main logic
        foreach ($CSVInfo in $CSVInfoList)
        {
            Write-Host -ForegroundColor Yellow "Checking cluster shared volume"$CSVInfo.DeviceID
            $CSVPath = $CSVInfo.DeviceID
            $CSVSize = $CSVInfo.Size
            $CSVFreeSpace = $CSVInfo.FreeSpace
            $VMDiskSizesList = $VMDiskInfoList | Where-Object {$_.Path -like $("*\$CSVPath\*")}
            $VMDiskTotalSize = 0
            $VMDiskTotalFileSize = 0
            $VMDiskTotalMaximumSize = 0

            Write-Host -ForegroundColor Cyan "Total drive size :" $([math]::round($CSVSize/1GB, 3))"GB"
            Write-Host -ForegroundColor Cyan "Free space :" $([math]::round($CSVFreeSpace/1GB, 3))"GB"

            if ($VMDiskSizesList -eq $null)
            {
                Write-Host ""
                Write-Host "No VHDs on drive"$CSVInfo.DeviceID"are attached ... Skipping"
            }
            else
            {
                foreach ($VMDisk in $VMDiskSizesList)
                {
                    $VMDiskTotalSize = $VMDiskTotalSize + $VMDisk.Size
                    $VMDiskTotalFileSize = $VMDiskTotalFileSize + $VMDisk.FileSize
                    $VMDiskTotalMaximumSize = $VMDiskTotalMaximumSize + $VMDisk.MaximumSize
                }

                $PossibleVHDsGrowth = $VMDiskTotalSize - $VMDiskTotalFileSize

                Write-Host ""
                Write-Host -ForegroundColor Yellow "VHD list : "

                $VMDiskSizesList | select ComputerName, Path, VhdFormat, VhdType, @{Name="FileSize (GB)";Expression={[math]::round($_.FileSize/1GB, 3)}}, @{Name="Size (GB)";Expression={[math]::round($_.Size/1GB, 3)}}, @{Name="MinimumSize (GB)";Expression={[math]::round($_.MinimumSize/1GB, 3)}}, LogicalSectorSize, PhysicalSectorSize, BlockSize | ft

                if ($PossibleVHDsGrowth -gt $CSVFreeSpace)
                {
                    $VMDisk = [math]::round($($PossibleVHDsGrowth - $CSVFreeSpace) /1GB, 3)
                    Write-Host -ForegroundColor Red "Overprovisioned by" $VMDisk "GB"
                }
                else
                {
                    $VMDisk = [math]::round($($CSVFreeSpace - $PossibleVHDsGrowth) /1GB, 3)
                    Write-Host -ForegroundColor Green "Remaining real free space : " $VMDisk "GB"
                }
            }
            Write-Host ""
        }
    }
    else
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
}

Check-VMOverprovisionning