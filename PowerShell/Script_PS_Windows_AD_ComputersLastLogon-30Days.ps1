$ListeOrdinateur = Get-ADComputer -Filter * -Properties OperatingSystem, LastlogonDate | Where { $_.LastLogonDate -GT (Get-Date).AddDays(-30) }
$ListeOrdinateur.count