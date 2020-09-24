$LocalUserList = Get-LocalUser | Where {$_.Enabled -eq $true}

foreach ($LocalUser in $LocalUserList)
{
    $LocalUser.Name
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $obj = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('machine', $($env:COMPUTERNAME))
    $obj.ValidateCredentials($LocalUser.Name, $($null)) 
}