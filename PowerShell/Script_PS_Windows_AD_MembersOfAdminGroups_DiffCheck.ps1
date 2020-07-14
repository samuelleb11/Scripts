# Variables
$SIDIDs = @('DomainSID-512','DomainSID-518','DomainSID-519','S-1-5-32-544')
$RegPath = "HKLM:\Software\MicroAge Quebec\Monitoring"
$RegNewData = "AD_MembersOfAdminGroups_Last"
$RegOldData = "AD_MembersOfAdminGroups_Old"
$RegDate = "AD_MembersOfAdminGroups_Date"
$CurrentDate = Get-Date

# Functions
Function Check-Paths ()
{
    $result = $false

    if ((Test-Path -Path $RegPath) -ne $true)
    {
        New-Item -Path $RegPath -Value $null -Force
        $result = $true
    }
    if ((Get-ItemProperty -Path $RegPath -Name $RegNewData -ErrorAction SilentlyContinue).$RegNewData -eq $null)
    {
        New-ItemProperty -Path $RegPath -Name $RegNewData -PropertyType MultiString -Value $null -Force
        $result = $true
    }
    if ((Get-ItemProperty -Path $RegPath -Name $RegOldData -ErrorAction SilentlyContinue).$RegOldData -eq $null)
    {
        New-ItemProperty -Path $RegPath -Name $RegOldData -PropertyType MultiString -Value $null -Force
        $result = $true
    }
    if ((Get-ItemProperty -Path $RegPath -Name $RegDate -ErrorAction SilentlyContinue).$RegDate -eq $null)
    {
        New-ItemProperty -Path $RegPath -Name $RegDate -PropertyType String -Value $null -Force
        $result = $true
    }
    if ([string]::IsNullOrEmpty((Get-ItemProperty -Path $RegPath -Name $RegDate -ErrorAction SilentlyContinue).$RegDate))
    {
        $result = $true
    }
    return $result
}

Function Get-AdminGroupsMembers ()
{
    $DOMSID = (Get-ADDomain).DomainSID.value
    $GroupsList = @()
    $result = ""

    foreach ($SIDID in $SIDIDs)
    {
        # Check if $SIDID is complete or not
        if ($SIDID.startswith("S"))
        {
            $SID = $SIDID
        }
        elseif ($SIDID.startswith("DomainSID"))
        {
            $SID = $SIDID.Replace("DomainSID",$DOMSID)
        }

        # Query group informations
        $Group = Get-ADGroup -Identity $SID

        # Query group members informations
        $GroupMembers = Get-ADGroupMember -Identity $SID

        # Create group object
        $GroupObject = New-Object -TypeName psobject
        $GroupObject | Add-Member -MemberType NoteProperty -Name GroupName -Value $Group.SamAccountName
        $GroupObject | Add-Member -MemberType NoteProperty -Name GroupDN -Value $Group.distinguishedName
        $GroupObject | Add-Member -MemberType NoteProperty -Name GroupSID -Value $Group.SID.Value

        $GroupMembersList = @()

        # For each loop that iterates through $GroupMembers PSObjects
        foreach ($GroupMember in $GroupMembers)
        {
            # Create member object
            $GroupMemberObject = New-Object -TypeName psobject
            $GroupMemberObject | Add-Member -MemberType NoteProperty -Name MemberAccountName -Value $GroupMember.SamAccountName
            $GroupMemberObject | Add-Member -MemberType NoteProperty -Name MemberFullName -Value $GroupMember.name
            $GroupMemberObject | Add-Member -MemberType NoteProperty -Name MemberDN -Value $GroupMember.distinguishedName
            $GroupMemberObject | Add-Member -MemberType NoteProperty -Name MemberSID -Value $GroupMember.SID.Value

            # Add member object to the $GroupsList array
            $GroupMembersList += $GroupMemberObject
        }
        #Write-Host $GroupMembersList 
        $GroupObject | Add-Member -MemberType NoteProperty -Name GroupMembers -Value $GroupMembersList

        # Add object to the $GroupsList array
        $GroupsList += $GroupObject
    }
    $result = $GroupsList | ConvertTo-Json -Depth 4
    return $result
}

Function Check-JsonDiff ($Old, $New)
{
    $Old = $Old | Out-String
    $New = $New | Out-String
    $OldData = ConvertFrom-Json -InputObject $Old
    $NewData = ConvertFrom-Json -InputObject $New

    $i = 0
    $endresult = ""
    foreach ($Group in $SIDIDs)
    {
        $NewList = $NewData[$i].GroupMembers
        $OldList = $OldData[$i].GroupMembers
        $CombinedList = $NewList + $OldList

        $Results = Compare-Object -ReferenceObject $OldList -DifferenceObject $NewList -Property "MemberSID"
    
        foreach ($Result in $Results)
        {
            if ($Result.SideIndicator -eq "=>")
            {
                $endresult = $endresult + "User $(($CombinedList | where {$_.MemberSID -eq $result.MemberSID} | Select *).MemberAccountName) has been added to group $($OldData[$i].GroupName)"
            }
            if ($Result.SideIndicator -eq "<=")
            {
                $endresult = $endresult + "User $(($CombinedList | where {$_.MemberSID -eq $result.MemberSID} | Select *).MemberAccountName) has been removed from group $($OldData[$i].GroupName)"
            }
            $endresult = $endresult + "`r`n"
        }
        $i++
    }
    Return $endresult
}

# Logic

if (Check-Paths -eq $true)
{
    Set-ItemProperty -Path $RegPath -Name $RegDate -Value $CurrentDate
    Set-ItemProperty -Path $RegPath -Name $RegNewData -Value $(Get-AdminGroupsMembers)
    $TXTOutput = ""
    return $TXTOutput
}
else
{
    Set-ItemProperty -Path $RegPath -Name $RegDate -Value $CurrentDate
    Set-ItemProperty -Path $RegPath -Name $RegOldData -Value $(Get-ItemProperty -Path $RegPath -Name $RegNewData).$RegNewData
    Set-ItemProperty -Path $RegPath -Name $RegNewData -Value $null
    Set-ItemProperty -Path $RegPath -Name $RegNewData -Value $(Get-AdminGroupsMembers)

    $TXTOutput = Check-JsonDiff -Old $(Get-ItemProperty -Path $RegPath -Name $RegOldData).$RegOldData -New $(Get-ItemProperty -Path $RegPath -Name $RegNewData).$RegNewData
    return $TXTOutput
}

$TXTOutput