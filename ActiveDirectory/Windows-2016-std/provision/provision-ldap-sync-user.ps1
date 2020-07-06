param(
    $username, $password
)

if (!$username) { 
    Write-Host "ldap user cannot be created as ACS username not specified. Exiting..." 
    exit
}

if (!$password) {
    Write-Host "ldap user cannot be created as password not specified. Exiting..." 
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


# add user
$givenName = "alfresco"
$sn = "ldap"
$displayName = "alfresco ldap"

New-ADUser `
    -Path $usersOUDn `
    -Name $username `
    -UserPrincipalName "$username@$domain" `
    -EmailAddress "$username@$domain" `
    -GivenName $givenName `
    -Surname $sn `
    -DisplayName $displayName `
    -AccountPassword $password `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -ChangePasswordAtLogon $false 
