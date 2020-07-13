# $ExportPath = "C:\temp\adusers.csv"

if ((Test-Path -Path $([System.IO.Path]::GetDirectoryName($ExportPath))) -ne $true)
{
    New-Item -Path $([System.IO.Path]::GetDirectoryName($ExportPath)) -Name $([System.IO.Path]::GetFileName($ExportPath)) -ItemType "file" -Value "" -Force
}
Get-ADUser -Filter * -Properties * | select givenname,sn,emailaddress,userprincipalname | where {[string]::IsNullOrEmpty($_.givename) -ne $true -or [string]::IsNullOrEmpty($_.sn) -ne $true -and [string]::IsNullOrEmpty($_.emailaddress) -ne $true -and $_.sn -notlike "*MsExch*" -and $_.sn -notlike "*FederatedEmail*"} | Export-Csv $ExportPath -Encoding UTF8 -NoTypeInformation -Force
$TXTOutput = Get-Content -Path $ExportPath -Encoding UTF8 | Out-String