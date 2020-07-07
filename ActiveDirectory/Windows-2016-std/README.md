# Vagrant Machine: Active Directory: Windows Server 2016 Standard

This machine was designed to quickly setup AD/ LADP or Kerberos when troubleshooting Alfresco Content Service issues. 

This automates the following processes:
1. Deploys a Windows Server 2016 Vagrant VM on either Virtual Box or Hyper-v
2. Installs AD-Domain-Services, RSAT-AD-AdminCenter and RSAT-ADDS-Tools
3. Installs [ADDSDeployment](https://docs.microsoft.com/en-us/powershell/module/addsdeployment/?view=win10-ps) Powershell module
4. Installs and configures an AD forest / domain
5. Creates two OU's: Alfresco-Users and Alfresco-Groups
6. Creates test user's in Alfresco-Users OU
7. Creates a Kerberos delegated account and associated keytab file
8. Creates a user account that can be used for ldap synchronisation 
9. Creates a user that is a member of Domain Admins and Enterprise Admins

## Geting Started

Make sure you check out the [requirements](https://github.com/sirReeall/vagrant_machines#requirements) before hand.

Start the machine using [`vagrant up`](https://www.vagrantup.com/docs/cli/up.html). On the first run this will download the Vagrant box used for the deployment. For more information on Vagrant review [Vagrant's Documentation](https://www.vagrantup.com/docs/index).

Excluding the time taken to download the box (which is about 8GB in size), this takes about 30 minutes complete the deployment (This is obviously dependent on your machines hardware). After which you will have a fully functioning MS AD domain controller :) 

You will probably want to customise the [Vagrantfile](Vagrantfile). The following tables show important settings that can be changed. These parameters are passed as Powershell arguments and therefore cannot be left as empty strings.

### Server and Domain Configurations

Parameter | Default | Remarks
--- | --- | ---
`HOSTNAME` | "dc01" | Hostname applied to the VM, vagrant, and the OS
`DOMAIN` | "example.com" | AD Domain that will be created

### Domain Admin User Configurations

A user account that is a member of the domain admin / enterprise admin group can be provisioned automatically using the following parameters:

Parameter | Default | Remarks
--- | --- | ---
`CREATE_DOMAIN_ADMIN`| true | You can disable automatic creation of a domain admin user by setting this to false
`DOMAIN_ADMIN_GIVENNAME` | "yoda" | The value assigned to attribute givenName
`DOMAIN_ADMIN_SN` | " " | The value assigned to attribute sn
`DOMAIN_ADMIN_USERNAME` | "yoda" | This is the username that the domain admin will have. Attributes sAMAccountName, userPrincipalName, displayName and email are also set using this value
`DOMAIN_ADMIN_PASSWORD` | "UseTheF0rce" | This is the password that the domain admin will have

The above creates a user with the following attributes:
Username | Password | MemberOf
--- | --- | ---
yoda | UseTheF0rce | Domain Admin + Enterprise Admin

### Ldap User Configurations

The user account is created with the following attributes:
```
    givenName:    alfresco
    sn:           ldap
    displayName:  alfresco ldap
```

Parameter | Default | Remarks
--- | --- | ---
`CREATE_LDAP_USER` | true | Enables or disabled ldap user creation
`LDAP_USER_USERNAME` | "alfresco.ldap" | This is the username that the ldap user will have. Attributes sAMAccountName, userPrincipalName, and email are also set using this value
`LDAP_USER_PASSWORD` | "C0mplexPassword" | This is the password that the ldap user will have

### Kerberos and Keytab Configurations

Parameter | Default | Remarks
--- | --- | ---
`CREATE_KEY_TAB` | true | Enables or disables keytab creation
`ACS_HOSTNAME` | acs1 | The hostname of the server that a keytab is being created for 
`ACS_KEYTAB_PASSWORD` | ComplexPassw0rd | The password that is set on the Kerberos enabled AD account

`ACS_HOSTNAME` and `ACS_KEYTAB_PASSWORD` requires `CREATE_KEY_TAB=true`.

### Other Parameters
Parameter | Default | Remarks
--- | --- | ---
`SSH_FORWARD_PORT` | "52225" | SSH port to avoid any conflicts with multiple VM's setup on the same host
`PRIVATE_NETWORK_IP` | "192.168.100.25" | Static IP address assigned to private network

## Default Users

The Vagrant box is preconfigured with a **local** vagrant user. You can access the machine using this **local** user after deployment:

Username | Password | Role
--- | --- | ---
vagrant | vagrant | administrator

(As this user is **local** you will need to prefix the username with the NetBIOS name followed by a '\'. For example: dc01\vagrant)

You can also login using the automatically provisioned [domain admin](#Domain-Admin-User-Configurations) user account.

The following users are created as part of the [provisioning script](provision/provision-users-and-groups.ps1):

Username | Password | MemberOf
--- | --- | ---
john.doe | ComplexPassw0rd | Domain User
jane.doe | ComplexPassw0rd | Domain User
joe.bloggs | ComplexPassw0rd | Domain User

## Acknowledgements

This Vagrant machine is based on [this](https://github.com/rgl/windows-domain-controller-vagrant) repository
