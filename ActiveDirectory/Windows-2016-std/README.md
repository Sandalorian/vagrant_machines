# Vagrant Machine: Active Directory: Windows Server 2016 Standard

This machine was designed to quickly setup AD/ LADP or Kerberos when troubleshooting Alfresco Content Service issues. This is why you will find the OU's that are created have the names `Alfresco-Users` and `Alfresco-Groups`

Vagrant is used to provision AD and a few test users.

There will be some need to customise [Vagrantfile](Vagrantfile). The following table shows important settings that should be changed:

Value | Default | Remarks
--- | --- | ---
HOSTNAME | "dc01" | Hostname applied to the VM, vagrant, and the OS
SSH_FORWARD_PORT | "52225" | SSH port to avoid any conflicts with multiple VM's setup on the same host
DOMAIN | "example.com" | AD Domain that will be created
CREATE_KEY_TAB | true | Enables or disables keytab creation
ACS_HOSTNAME | acs1 | The hostname of the server that a keytab is being created for
ACS_KEYTAB_PASSWORD | ComplexPassw0rd | The password that is set on the Kerberos enabled AD account
PRIVATE_NETWORK_IP | "192.168.100.25" | Static IP address assigned to private network

## Default Users

The Vagrant box is preconfigured with a **local** vagrant user. You can access the machine using this **local** user after deployment:

Username | Password | Role
--- | --- | ---
vagrant | vagrant | administrator

(As this user is **local** you will need to prefix the username with the NetBIOS name followed by a '\'. For example: dc01\vagrant)

The following users are created as part of the [provisioning script](provision\provision-users-and-groups.ps1):

Username | Password | Role
--- | --- | ---
john.doe | HeyH0Password | Domain User
jane.doe | HeyH0Password | Domain User
joe.bloggs | HeyH0Password | Domain User


## Acknowledgements

This Vagrant machine is based on [this](https://github.com/rgl/windows-domain-controller-vagrant) repository
