param(
    $hostname, $password
)

if (!$hostname) { 
    Write-Host "Keytab cannot be created as ACS server name not specified. Exiting..." 
    exit
}

if (!$password) {
    Write-Host "Keytab cannot be created as Kerberos password not specified. Exiting..." 
    exit
}

while ($true) {
    try {
        Get-ADDomain | Out-Null
        break
    } catch {
        Start-Sleep -Seconds 10
    }
}

$adDomain = Get-ADDomain
$domain = $adDomain.DNSRoot
$domainDn = $adDomain.DistinguishedName

$password = ConvertTo-SecureString -AsPlainText $password -Force

# Note that the Users object in AD is NOT an OU.
# If you change this to a different loction that is an OU,
# Make sure you change $usersOUDn accordingly (CN to OU)
$usersOU = "Users"
$usersOUDn = "CN=$usersOU,$domainDn"

$outputLocation = "c:\tmp\"

# add Kerberos Principle
$name = 'http' + $hostname
New-ADUser `
    -Path $usersOUDn `
    -Name $name `
    -UserPrincipalName "$name@$domain" `
    -GivenName 'http' `
    -Surname 'acs1' `
    -DisplayName 'httpacs1' `
    -AccountPassword $password `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -ChangePasswordAtLogon $false `
     -PassThru `
    | Set-ADAccountControl -DoesNotRequirePreAuth $true -TrustedForDelegation $true

# create keytab file

# $cmd = "ktpass -out " + $srv + "_keytab -pass C0mplic4ted_p@ss -princ HOST/" + $srv + ".bom.gov.au@BOM.GOV.AU -mapuser host_" + $srv + " -ptype KRB5_NT_PRINCIPAL /crypto AES256-SHA1"
# 	iex $cmd

$cmd = "ktpass -princ HTTP/" + $hostname + "." + $domain + "@" + $domain.ToUpper() + `
        " -pass " + $password + `
        " -mapuser " + $adDomain.NetBIOSName + "\" + $name + `
        " -crypto all" + `
        " -ptype KRB5_NT_PRINCIPAL" + `
        " -out " + $outputLocation + $name + "." + "keytab" + `
        " -kvno 0"

Write-Output $cmd

iex $cmd 2>&1 | %{ "$_" }