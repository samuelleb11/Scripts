# Source : https://forums.veeam.com/microsoft-hyper-v-f25/9-5-hyper-v-known-issues-t38927.html

function fStop-Services([string]$serviceToStop)
{
    #Get running dependencies
    $dependent_services = (get-service $ServiceToStop).dependentservices | get-service |Where-Object {$_.Status -eq "Running"}

    #stop dependent services
    foreach ($dependent_service in $dependent_services)
    {
        Write-Host "Stopping " $dependent_service
        stop-service $dependent_service
    }
    #stop service
    Write-Host "Stopping " $ServiceToStop
    stop-service $ServiceToStop

    return $dependent_services
}


function fStart-Services($serviceToStart)
{
    Write-Host "Starting " $serviceToStart
    start-service $serviceToStart

    foreach ($service in $services)
    {
        Write-Host "Starting " $service
        start-service $service
    }

}

$log="c:\scripts\log.txt"

"start" |out-file $log
$services = fStop-Services("eventsystem")


sleep -s 5

#restart VSS
Write-Host "Restarting VSS"
Restart-Service VSS

sleep -s 5

fStart-Services("eventsystem")

sleep -s 5

#restart SQL VSS
Write-Host "Restarting SQL VSS"
Restart-Service SQLWriter

sleep -s 5

"end" |out-file $log -append

exit 0