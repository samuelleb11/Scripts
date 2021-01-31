$Data = @()
$Times = 10
$Count = 0

$ping = New-Object System.Net.NetworkInformation.Ping

while($Count -le $Times)
{
    $data += $ping.Send('192.46.223.26')
    $Count ++
    Start-Sleep -Seconds 1
}
$Data