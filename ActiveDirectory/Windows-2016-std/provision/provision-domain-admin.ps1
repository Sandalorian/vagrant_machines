param(
    $givenName, $sn, $username, $password
)

if (!$givenName) { 
    Write-Host "domain admin cannot be created as givenName not specified. Exiting..." 
    exit
}

if (!$sn) { 
    Write-Host "domain admin cannot be created as sn not specified. Exiting..." 
    exit
}

if (!$username) { 
    Write-Host "domain admin cannot be created as username not specified. Exiting..." 
    exit
}

if (!$password) {
    Write-Host "domain admin cannot be created as password not specified. Exiting..." 
    Write-Host "Password: " $password
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

$displayName = $username

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

Add-AdGroupMember -Identity "Domain Admins" -Members $username
Add-AdGroupMember -Identity "Enterprise Admins" -Members $username