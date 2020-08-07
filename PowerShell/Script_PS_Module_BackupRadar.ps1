$ApiURL = "https://api.backupradar.com"
$ApiKey = "YourAPIKeyHere"
$ApiFunctionsName = @{
    'InactivePolicies' = 1
    'RetiredPolicies' = 2
    'Overview' = 3
    'PolicyDetails' = 4
    'Policies' = 5
}
$ApiFunctionsDefinition = @{
    1 = '/policies/inactive'
    2 = '/policies/retired'
    3 = '/policies/overview'
    4 = '/policies'
    5 = '/policies'
}
$ApiFunctionsText = @{
    1 = 'inactive policies'
    2 = 'retired policies'
    3 = 'account overview'
    4 = 'policy #$PolicyIDs details'
    5 = 'all policies from $Date'
}


function Get-BackupRadarInfo($FunctionName, $ApiKey=$ApiKey, $Date, $PolicyID, $SearchString, [ValidateSet('Success','Warning','Failure','No Result')]$Status, [Switch]$Raw, [Switch]$GridView)
{
    $APIFunctionID = $ApiFunctionsName[$FunctionName]
    $Endpoint = ""
    Invoke-Expression "Set-Variable -Name Endpoint -Value `"$ApiURL$($ApiFunctionsDefinition[$APIFunctionID])`""
    $Headers = @{'ApiKey'=$ApiKey}
    $Params = @{}
    if ($Date -ne $null)
    {
        $Params.Add('date',$Date)
    }
    if ($PolicyID -ne $null)
    {
         $Params.Add('policyIds',$PolicyID)
    }
    if ($SearchString -ne $null)
    {
         $Params.Add('searchString',$SearchString)
    }
    if ($Status -ne $null)
    {
         $Params.Add('statuses',$Status)
    }
    Invoke-Expression "Write-Host -ForegroundColor Green `"Getting $($ApiFunctionsText[$APIFunctionID])`""
    $Data = ((Invoke-WebRequest -UseBasicParsing -Uri $Endpoint -Headers $Headers -Body $Params).content) -join "`n" | ConvertFrom-Json
    if ($Raw){return $Data}
    $result = @()
    if ($FunctionName -ne "Overview")
    {
        foreach ($i in $Data)
        {
            $obj = New-Object -TypeName psobject
            if ($FunctionName -eq "Policies" -or $FunctionName -eq "PolicyDetails")
            {
                $obj | Add-Member -MemberType NoteProperty -Name "Date" -Value $i.date
                $obj | Add-Member -MemberType NoteProperty -Name "Company" -Value $i.ticketingCompany
                $obj | Add-Member -MemberType NoteProperty -Name "Status" -Value $i.status.name
                $obj | Add-Member -MemberType NoteProperty -Name "DaysSinceLastGoodResult" -Value $i.daysSinceLastGoodResult
                $obj | Add-Member -MemberType NoteProperty -Name "DaysInStatus" -Value $i.daysInStatus
                $obj | Add-Member -MemberType NoteProperty -Name "DaysSinceLastResult" -Value $i.daysSinceLastResult
            }
            if ($FunctionName -eq "InactivePolicies" -or $FunctionName -eq "RetiredPolicies")
            {
                $obj | Add-Member -MemberType NoteProperty -Name "Email" -Value $i.emailFrom
                $obj | Add-Member -MemberType NoteProperty -Name "LastReceived" -Value $i.lastReceived
            }
            if ($FunctionName -eq "RetiredPolicies")
            {
                $obj | Add-Member -MemberType NoteProperty -Name "Company" -Value $i.companyName
            }
            $obj | Add-Member -MemberType NoteProperty -Name "PolicyId" -Value $i.policyId
            $obj | Add-Member -MemberType NoteProperty -Name "DeviceName" -Value $i.deviceName
            $obj | Add-Member -MemberType NoteProperty -Name "PolicyName" -Value $i.policyName
            $obj | Add-Member -MemberType NoteProperty -Name "BackupSoftware" -Value $i.methodName
            $result += $obj
        }
    }
    else {$result = $Data}
    if ($GridView){return $result | Out-GridView}
    return $result
}

#Get-BackupRadarInfo -FunctionName "InactivePolicies"
#Get-BackupRadarInfo -FunctionName "RetiredPolicies"
#Get-BackupRadarInfo -FunctionName "Overview"
#Get-BackupRadarInfo -FunctionName "PolicyDetails" -PolicyID '1240815' -Date '2020-08-07'
#Get-BackupRadarInfo -FunctionName "Policies" -Date "2020-08-07"
#Get-BackupRadarInfo -FunctionName "Policies" -Date "2020-08-07" -SearchString "Something/CompanyName"
#Get-BackupRadarInfo -FunctionName "Policies" -Date "2020-08-06" -Status Warning -GridView