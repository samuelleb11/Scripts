$arch = Get-WMIObject -Class Win32_Processor -ComputerName LocalHost | Select-Object AddressWidth

Write-Host "1. Stopping Windows Update Services..."
Stop-Service -Name BITS
Stop-Service -Name wuauserv
Stop-Service -Name appidsvc
Stop-Service -Name cryptsvc

Write-Host "2. Remove QMGR Data file..."
Remove-Item "$env:allusersprofile\Application Data\Microsoft\Network\Downloader\qmgr*.dat" -ErrorAction SilentlyContinue

Write-Host "3. Renaming the Software Distribution and CatRoot Folder..."
Rename-Item $env:systemroot\SoftwareDistribution SoftwareDistribution.bak -ErrorAction SilentlyContinue
Rename-Item $env:systemroot\System32\Catroot2 catroot2.bak -ErrorAction SilentlyContinue

Write-Host "4. Removing old Windows Update log..."
Remove-Item $env:systemroot\WindowsUpdate.log -ErrorAction SilentlyContinue

Write-Host "5. Resetting the Windows Update Services to defualt settings..."
"sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)"
"sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)"

Set-Location $env:systemroot\system32

Write-Host "6. Registering some DLLs..."
regsvr32 c:\windows\system32\vbscript.dll /s
regsvr32 c:\windows\system32\mshtml.dll /s
regsvr32 c:\windows\system32\msjava.dll /s
regsvr32 c:\windows\system32\jscript.dll /s
regsvr32 c:\windows\system32\msxml.dll /s
regsvr32 c:\windows\system32\actxprxy.dll /s
regsvr32 c:\windows\system32\shdocvw.dll /s
regsvr32 wuapi.dll /s
regsvr32 wuaueng1.dll /s
regsvr32 wuaueng.dll /s
regsvr32 wucltui.dll /s
regsvr32 wups2.dll /s
regsvr32 wups.dll /s
regsvr32 wuweb.dll /s
regsvr32 Softpub.dll /s
regsvr32 Mssip32.dll /s
regsvr32 Initpki.dll /s
regsvr32 softpub.dll /s
regsvr32 wintrust.dll /s
regsvr32 initpki.dll /s
regsvr32 dssenh.dll /s
regsvr32 rsaenh.dll /s
regsvr32 gpkcsp.dll /s
regsvr32 sccbase.dll /s
regsvr32 slbcsp.dll /s
regsvr32 cryptdlg.dll /s
regsvr32 Urlmon.dll /s
regsvr32 Shdocvw.dll /s
regsvr32 Msjava.dll /s
regsvr32 Actxprxy.dll /s
regsvr32 Oleaut32.dll /s
regsvr32 Mshtml.dll /s
regsvr32 msxml.dll /s
regsvr32 msxml2.dll /s
regsvr32 msxml3.dll /s
regsvr32 Browseui.dll /s
regsvr32 shell32.dll /s
regsvr32 wuapi.dll /s
regsvr32 wuaueng.dll /s
regsvr32 wuaueng1.dll /s
regsvr32 wucltui.dll /s
regsvr32 wups.dll /s
regsvr32 wuweb.dll /s
regsvr32 jscript.dll /s
regsvr32 atl.dll /s
regsvr32 Mssip32.dll /s

Write-Host "7) Removing WSUS client settings..."
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v AccountDomainSid /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v PingID /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientId /f

Write-Host "8) Resetting the WinSock..."
netsh winsock reset
netsh winhttp reset proxy

Write-Host "9) Delete all BITS jobs..."
Get-BitsTransfer | Remove-BitsTransfer

Write-Host "10) Attempting to install the Windows Update Agent..."
if($arch -eq 64){
    wusa Windows8-RT-KB2937636-x64 /quiet
}
else{
    wusa Windows8-RT-KB2937636-x86 /quiet
}

Write-Host "11) Starting Windows Update Services..."
Start-Service -Name BITS
Start-Service -Name wuauserv
Start-Service -Name appidsvc
Start-Service -Name cryptsvc

Write-Host "12) Forcing discovery..."
wuauclt /resetauthorization /detectnow

Write-Host "Process complete. Please reboot your computer."