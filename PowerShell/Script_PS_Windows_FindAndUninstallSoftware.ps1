$Global:Output = @()

$ApplicationName = '$env:SoftwareName'
$Selection = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | 
ForEach-Object { Get-ItemProperty $_.PSPath } |
Where-Object { $_.DisplayName -match "$ApplicationName" } |
Select-Object DisplayName,UninstallString

$Selection | ForEach-Object {
    $command = 'cmd.exe /C ' + '"' + $_.UninstallString + ' /qn"'
    $command = $command -replace "/I{", "/x{"
    Return $command
    Invoke-Expression -Command $command
}

$Selection2 = Get-ChildItem "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | 
ForEach-Object { Get-ItemProperty $_.PSPath } |
Where-Object { $_.DisplayName -match "$ApplicationName" } |
Select-Object DisplayName,UninstallString


$Selection2 | ForEach-Object {
    $command = 'cmd.exe /C ' + '"' + $_.UninstallString + ' /qn"'
    $command = $command -replace "/I{", "/x{"
    Return $command
    Invoke-Expression -Command $command
}