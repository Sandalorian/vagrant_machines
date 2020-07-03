param(
    $domain = 'example.com'
)

$ErrorActionPreference = "Stop"

Write-Host "Hostname:" $env:computername
Write-Host "Installing Active Directory"

$netbiosDomain = ($domain -split '\.')[0].ToUpperInvariant()

$safeModeAdminstratorPassword = ConvertTo-SecureString 'ComplexPassw0rd' -AsPlainText -Force

# make sure the Administrator has a password that meets the minimum Windows
# password complexity requirements (otherwise the AD will refuse to install).
Write-Host 'Resetting the Administrator account password and settings...'
Set-LocalUser `
    -Name Administrator `
    -AccountNeverExpires `
    -Password $safeModeAdminstratorPassword `
    -PasswordNeverExpires:$true `
    -UserMayChangePassword:$true

Write-Host 'Disabling the Administrator account (we only use the vagrant account)...'
Disable-LocalUser `
    -Name Administrator

Write-Host 'Installing the AD services and administration tools...'
Install-WindowsFeature AD-Domain-Services,RSAT-AD-AdminCenter,RSAT-ADDS-Tools

Write-Host 'Installing the AD forest (be patient, this will take more than 30m to install)...'
Import-Module ADDSDeployment
# NB ForestMode and DomainMode are set to WinThreshold (Windows Server 2016).
#    see https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/active-directory-functional-levels
Install-ADDSForest `
    -InstallDns `
    -CreateDnsDelegation:$false `
    -ForestMode 'WinThreshold' `
    -DomainMode 'WinThreshold' `
    -DomainName $domain `
    -DomainNetbiosName $netbiosDomain `
    -SafeModeAdministratorPassword $safeModeAdminstratorPassword `
    -NoRebootOnCompletion `
    -Force


Write-Host 'Completed installation of AD forest'
exit 0
