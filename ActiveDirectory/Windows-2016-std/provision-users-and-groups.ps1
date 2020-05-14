# wait until AD is available

while ($true) {
    try {
        Get-ADDomain | Out-Null
        break
    } catch {
        Start-Sleep -Seconds 10
    }
}


$password = ConvertTo-SecureString -AsPlainText 'HeyH0Password' -Force

$adDomain = Get-ADDomain
$domain = $adDomain.DNSRoot
$domainDn = $adDomain.DistinguishedName

$usersOU = "Alfresco Users"
$groupsOU = "Alfresco Groups"

$usersOUDn = "OU=$usersOU,$domainDn"
$groupsOUDn = "OU=$groupsOU,$domainDn"

# No groups are actually created, just and OU to hold the groups
New-ADOrganizationalUnit -Name $groupsOU -Path $domainDn

# Create user OU and user accounts
New-ADOrganizationalUnit -Name $usersOU -Path $domainDn

# add John Doe.
$name = 'john.doe'
New-ADUser `
    -Path $usersOUDn `
    -Name $name `
    -UserPrincipalName "$name@$domain" `
    -EmailAddress "$name@$domain" `
    -GivenName 'John' `
    -Surname 'Doe' `
    -DisplayName 'John Doe' `
    -AccountPassword $password `
    -Enabled $true `
    -PasswordNeverExpires $true

# add Jane Doe.
$name = 'jane.doe'
New-ADUser `
    -Path $usersOUDn `
    -Name $name `
    -UserPrincipalName "$name@$domain" `
    -EmailAddress "$name@$domain" `
    -GivenName 'Jane' `
    -Surname 'Doe' `
    -DisplayName 'Jane Doe' `
    -AccountPassword $password `
    -Enabled $true `
    -PasswordNeverExpires $true

# add Joe Bloggs.
$name = 'joe.bloggs'
New-ADUser `
    -Path $usersOUDn `
    -Name $name `
    -UserPrincipalName "$name@$domain" `
    -EmailAddress "$name@$domain" `
    -GivenName 'Joe' `
    -Surname 'Bloggs' `
    -DisplayName 'Joe Bloggs' `
    -AccountPassword $password `
    -Enabled $true `
    -PasswordNeverExpires $true

