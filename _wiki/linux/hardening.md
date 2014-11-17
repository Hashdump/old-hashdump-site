---
title: Linux Hardening Guide
---
This is a general hardening guide for Linux. Think of it as more of a cheat sheet or reference than a definitive checklist. Do NOT use all of these in production, use your standard operating procedure. This guide assumes escalated priveledges, if something does not work escalate priveledges.

# Auditing
# Backups
# Boot
## Ownership
Check ownership on the grub configuration (this assumes grub is used).

``` bash
stat -c "%u%g" /boot/grub/grub.cfg
```

If the above prints '00' you are fine and it means root owns the file. If it prints anything else run:

``` bash
chown root:root /boot/grub/grub.conf
```

If the ownership of the grub configuration file is another user that user can arbitrarily change boot parameters that could lead to escalation. For example, if the attacker used `init=/bin/bash` in the config they would boot into essentially single user mode with escalated priveledge. They could also arbitrarily change boot parameters in general. For example they could disable stack protections or SELinux.
## Permissions
Check permissions on the grub configuration.

``` bash
stat -L -c "%a" /boot/grub/grub.cfg | cut -c 2-
```

If the above prints '00' you are good. Or else the permissions are wrong as no one other than root should have access to the boot partition.

``` bash
chmod og-rwx /boot/grub/grub.cfg
```

## Bootloader Password
By setting a password in grub it forces a password to be entered before command line boot options can be set. This prevents an attacker with physical access or access to virtual console from arbitrarily setting bootloader arguments. To check if this option is set run:

``` bash
grep "^set superusers" /boot/grub/grub.cfg
grep "^password" /boot/grub/grub.cfg
```

If neither of those print anything you can set a password with:

``` bash
grub-mkpasswd-pbdkf2
Enter password: $PASSWORD
Reenter password: $PASSWORD
Your PBDKF2 is $ENC_PASSWORD
```

Then add `$ENC_PASSWORD` to /etc/grub.d/00_header as follows:

``` bash
set superusers="$USERNAME,$USERNAME2,$USERNAMEN"
password_pbdkf2 $USERNAME $ENC_PASSWORD
```

## /boot Size
A note that /boot should be in a seperate partition to control its size so that an attacker could cause an issue in generating the initrd that causes system failure.
# cron
# Disk Encryption
# Firewall
## iptables
## ufw
# IPv6
As with all services and programs, if you are not going to use it in production you should not have it installed or responding. If you are running IPv6 on the server then go to the `Disable Portions` section or if you do not want IPv6 at all you should see `Completely Disable`
## Disable Portions
### IPv6 Router Advertisements
If this is allowed an attacker may be able to trick a machine into routing traffic to a place they did not intend. Run the follwing:

``` bash
# sysctl net.ipv6.conf.all.accept_ra

```

## Completely Disable
# Kernel
## Modules
## Randomize Virtual Address Space
# Logs
# Malware
# Network Services
# Networking
## ICMP
## PXE
## SSH
# Network Encryption
## ssh -L
## spiped
# Packages
Keeping things up to date is obviously important.
## Sync Mirrors
Debian/Ubuntu:
```bash
apt-get update
```
RHEL/Fedora/CentOS:
yum cannot sync the package database seperately from updating.

## Update Packages
To list available updates:
Debian/Ubuntu:
```bash
apt-get --just-print upgrade
```
RHEL/Fedora/CentOS:
```bash
yum list updates
```
To actually update:
Debian/Ubuntu:
```bash
apt-get upgrade
```
RHEL/Fedora/CentOS:
```bash
yum update
```
## Remove Unnecessary Packages
Minimizing the packages installed helps reduce the attack surface. Removing unnecessary packages is generally a manual process to prevent removing packages that are dependencies.

Debain/Ubuntu:
```bash
dpkg --list
dpkg --info $PACKAGE
apt-get remove $PACKAGE
```

RHEL/Fedora/CentOS:
```bash
yum list installed
yum list $PACKAGE
yum remove $PACKAGE
```
## Automatically Update Packages
While not recommended for all types of systems, for most creating automatic updates for packages is very useful.

# Partitions
noexec, nodev, nosuid
## Filesystem

# Passwords
## PAM
# Permissions
## Default umask
# Proxying
# Services
## Remove Legacy Services/Packages
## Potentially Dangerous Services
# User Management
# USB
# Misc.
## NX/XD
# Advanced
See Grsecurity in the wiki
