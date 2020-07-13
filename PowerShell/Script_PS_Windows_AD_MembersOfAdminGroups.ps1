## Variables

# Get domain SID
$DOMSID = (Get-ADDomain).DomainSID.value

# List of groups to query
$SIDIDs = @('DomainSID-512','DomainSID-518','DomainSID-519','S-1-5-32-544')

# Export path for the CSV file
$ExportPath = "C:\temp\adgroupmembers.csv"

# Empty array to add final data through the logic loop
$GroupsList = @()

## Logic

# Test if the path specified in $ExportPath is valid
if ((Test-Path -Path $([System.IO.Path]::GetDirectoryName($ExportPath))) -ne $true)
{
    # Create directory and file if not exist
    New-Item -Path $([System.IO.Path]::GetDirectoryName($ExportPath)) -Name $([System.IO.Path]::GetFileName($ExportPath)) -ItemType "file" -Value "" -Force
}

# Main for each loop that iterates through the $SIDIDs array
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
    $GroupObject | Add-Member -MemberType NoteProperty -Name MemberName -Value ""
    $GroupObject | Add-Member -MemberType NoteProperty -Name MemberFullName -Value ""
    $GroupObject | Add-Member -MemberType NoteProperty -Name MemberDN -Value ""
    $GroupObject | Add-Member -MemberType NoteProperty -Name MemberSID -Value ""

    # Add object to the $GroupsList array
    $GroupsList += $GroupObject

    # For each loop that iterates through $GroupMembers PSObjects
    foreach ($GroupMember in $GroupMembers)
    {
        # Create member object
        $GroupMemberObject = New-Object -TypeName psobject
        $GroupMemberObject | Add-Member -MemberType NoteProperty -Name GroupName -Value $Group.SamAccountName
        $GroupMemberObject | Add-Member -MemberType NoteProperty -Name GroupDN -Value $Group.distinguishedName
        $GroupMemberObject | Add-Member -MemberType NoteProperty -Name GroupSID -Value $Group.SID.Value
        $GroupMemberObject | Add-Member -MemberType NoteProperty -Name MemberAccountName -Value $GroupMember.SamAccountName
        $GroupMemberObject | Add-Member -MemberType NoteProperty -Name MemberFullName -Value $GroupMember.name
        $GroupMemberObject | Add-Member -MemberType NoteProperty -Name MemberDN -Value $GroupMember.distinguishedName
        $GroupMemberObject | Add-Member -MemberType NoteProperty -Name MemberSID -Value $GroupMember.SID.Value

        # Add member object to the $GroupsList array
        $GroupsList += $GroupMemberObject
    }
}

# Export the $GroupsList array to CSV file at path specified in $ExportPath
$GroupsList | Export-Csv -Encoding UTF8 -Force -NoTypeInformation -Path $ExportPath

# Generate text ouput for N-Central
$TXTOutput = Get-Content -Path $ExportPath -Encoding UTF8 | Out-String