# Modified version of this script : https://gallery.technet.microsoft.com/scriptcenter/Check-the-AD-replication-ada017fb

Function Check-ADReplicationHealth ([switch]$Forest, [switch]$SupressOutput)
{
    $array = @()

    if ($Forest)
    {
        $myForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest() 
        $dclist = $myforest.Sites | % { $_.Servers }
    }
    else{$dclist = $env:COMPUTERNAME}
 
    foreach ($dcname in $dclist){
        if($Forest){$source_dc_fqdn = ($dcname.Name).tolower()}else{$source_dc_fqdn = $env:COMPUTERNAME}
        $ad_partition_list = repadmin /showrepl $source_dc_fqdn | select-string "dc="
        foreach ($ad_partition in $ad_partition_list) { 
            [Array]$NewArray=$NULL 
            $result = repadmin /showrepl $source_dc_fqdn $ad_partition 
            $result = $result | where { ([string]::IsNullOrEmpty(($result[$_]))) } 
            $index_array_dst = 0..($result.Count - 1) | Where { $result[$_] -like "*via RPC" } 
            foreach ($index in $index_array_dst){
                $dst_dc = (($result[$index]).trim())
                $next_index = [array]::IndexOf($index_array_dst,$index) + 1 
                $next_index_msg = $index_array_dst[$next_index] 
                $status = ""
                $GUID = ""
                if ($index -lt $index_array_dst[-1]){ 
                    $last_index = $index_array_dst[$next_index] 
                } 
                else { 
                    $last_index = $result.Count 
                } 
            
                for ($i=$index+1;$i -lt $last_index; $i++){ 
                    if (($GUID -eq "") -and ($result[$i])) { 
                        $GUID += ($result[$i]).trim()
                        $status += ""
                    } 
                    else { 
                        $status += ($result[$i]).trim() 
                    } 
                } 
                $Properties = @{Source=$source_dc_fqdn;Partition=$ad_partition;Destination=$dst_dc;Status=$status;objGUID=$GUID}
                $Newobject = New-Object PSObject -Property $Properties
                $array +=$newobject
            } 
        } 
    }
    if (!$SupressOutput)
    {
        if ($array | where {$_.status -notlike "*successful*"})
        {
            Write-Host "Replication is not OK" -ForegroundColor Red
        }
        else{Write-Host "Replication is OK" -ForegroundColor Green}
        return $array | select partition,objGUID,status,source,destination | ft
    }
    else{return $array | select partition,objGUID,status,source,destination}
}

Check-ADReplicationHealth -Forest