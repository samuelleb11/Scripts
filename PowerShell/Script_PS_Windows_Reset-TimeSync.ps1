function Reset-TimeSync ([Switch]$DomainController, [Switch]$Client, [Switch]$IsVirtual, [Switch]$SyncToDomain, $NTPServerList = "0.ca.pool.ntp.org 1.ca.pool.ntp.org 2.ca.pool.ntp.org 3.ca.pool.ntp.org")
{
    if ($IsVirtual)
    {
        reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\VMICTimeProvider /v Enabled /t reg_dword /d 0   
    }

    if ($DomainController)
    {
        w32tm /config /manualpeerlist:"0.ca.pool.ntp.org 1.ca.pool.ntp.org 2.ca.pool.ntp.org 3.ca.pool.ntp.org" /syncfromflags:manual /reliable:yes /update
    }

    if ($Client)
    {
        if ($SyncToDomain){w32tm /config /syncfromflags:DOMHIER /update}
        else{w32tm /config /manualpeerlist:"0.ca.pool.ntp.org 1.ca.pool.ntp.org 2.ca.pool.ntp.org 3.ca.pool.ntp.org" /syncfromflags:manual /reliable:yes /update}
    }

    w32tm /resync /rediscover
    w32tm /query /source
    Restart-Service W32Time
    w32tm /query /source
}