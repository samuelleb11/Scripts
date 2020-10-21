# Check if Exchange module is already imported
if (!$([bool](Get-Command "Get-Mailbox" -errorAction SilentlyContinue)))
{
    # Check if Exchange 2007
    if ($((GCM exsetup).Fileversioninfo.ProductVersion) -like "8.*")
    {
         Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
    }

    # Check if Exchange 2010
    if ($((GCM exsetup).Fileversioninfo.ProductVersion) -like "14.*")
    {
         Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
    }

    # Check if Exchange 2013-2019
    if ($((GCM exsetup).Fileversioninfo.ProductVersion) -gt "15.*" )
    {
         Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
    }
}

Get-Mailbox | Get-MailboxStatistics | Sort-Object -Property TotalItemSize -Descending | Select-Object DisplayName,ItemCount,TotalItemSize | Export-Csv -Path C:\temp\CAFECTION_MailboxStatistics.csv -NoTypeInformation