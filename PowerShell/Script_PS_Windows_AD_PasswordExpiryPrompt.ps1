Add-Type -AssemblyName System.DirectoryServices.AccountManagement

function Get-User
{
    [CmdletBinding()]
    [OutputType([System.DirectoryServices.AccountManagement.UserPrincipal])]
    param(
        [ValidateLength(1,20)]
        [string]$UserName 
    )
    
    $ctx = New-Object 'DirectoryServices.AccountManagement.PrincipalContext' ([DirectoryServices.AccountManagement.ContextType]::Domain)
    if( $Username )
    {
        $user = [DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity( $ctx, $Username )
        if( -not $user )
        {
            try
            {
                Write-Error ('Local user ''{0}'' not found.' -f $Username) -ErrorAction:$ErrorActionPreference
                return
            }
            finally
            {
                $ctx.Dispose()
            }
        }
        return $user
    }
    else
    {
        $query = New-Object 'DirectoryServices.AccountManagement.UserPrincipal' $ctx
        $searcher = New-Object 'DirectoryServices.AccountManagement.PrincipalSearcher' $query
        try
        {
            $searcher.FindAll() 
        }
        finally
        {
            $searcher.Dispose()
            $query.Dispose()
        }
    }
}

function Get-DomainMaxPwdAge ()
{
    $D = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    $Domain = [ADSI]"LDAP://$D"
    $MPA = $Domain.maxPwdAge.Value
    $lngMaxPwdAge = $Domain.ConvertLargeIntegerToInt64($MPA)
    $MaxPwdAge = -$lngMaxPwdAge/(600000000 * 1440)
    return $MaxPwdAge
}

$Date = Get-Date
$MaxPassAge = Get-DomainMaxPwdAge
$UserInfo = Get-User -UserName $env:USERNAME
$PassChangeDate = $(([datetime]$UserInfo.LastPasswordSet).AddDays($MaxPassAge))
Write-Host "Change password before $PassChangeDate"

if ($UserInfo.PasswordNeverExpires -eq $true){exit}
elseif ($Date -ge $PassChangeDate.AddDays(-5))
{
    $MsgBox = [System.Windows.MessageBox]::Show("Votre mot de passe va expirer le $PassChangeDate`nVoulez-vous le changer maintenant ?",'Expiration de votre mot de passe','YesNo','Exclamation')

    if ($MsgBox -eq 6)
    {
        Start-Process -FilePath $env:SystemRoot\explorer.exe -ArgumentList {"shell:::{2559a1f2-21d7-11d4-bdaf-00c04f60b9f0}"}
    }
    else{exit}
}
else{exit}