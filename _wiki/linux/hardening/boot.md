---
title: Linux Hardening Boot
---
# Boot
## Grub
### Ownership
Check ownership on the grub configuration (this assumes grub is used).

``` bash
$ stat -c "%u%g" /boot/grub/grub.cfg
```

If the above prints '00' you are fine and it means root owns the file. If it prints anything else run:

``` bash
$ chown root:root /boot/grub/grub.conf
```

If the ownership of the grub configuration file is another user that user can arbitrarily change boot parameters that could lead to escalation. For example, if the attacker used `init=/bin/bash` in the config they would boot into essentially single user mode with escalated priveledge. They could also arbitrarily change boot parameters in general. For example they could disable stack protections or SELinux.
## Permissions
Check permissions on the grub configuration.

``` bash
$ stat -L -c "%a" /boot/grub/grub.cfg | cut -c 2-
```

If the above prints '00' you are good. Or else the permissions are wrong as no one other than root should have access to the boot partition.

``` bash
$ chmod og-rwx /boot/grub/grub.cfg
```

### Bootloader Password
By setting a password in grub it forces a password to be entered before command line boot options can be set. This prevents an attacker with physical access or access to virtual console from arbitrarily setting bootloader arguments. To check if this option is set run:

``` bash
$ grep "^set superusers" /boot/grub/grub.cfg
$ grep "^password" /boot/grub/grub.cfg
```

If neither of those print anything you can set a password with:

``` bash
$ grub-mkpasswd-pbdkf2
Enter password: $PASSWORD
Reenter password: $PASSWORD
Your PBDKF2 is $ENC_PASSWORD
```

Then add `$ENC_PASSWORD` to /etc/grub.d/00_header as follows:

```
set superusers="$USERNAME,$USERNAME2,$USERNAMEN"
password_pbdkf2 $USERNAME $ENC_PASSWORD
```

### /boot Size
A note that /boot should be in a seperate partition to control its size so that an attacker could cause an issue in generating the initrd that causes system failure or consume disk space. See the partition section for more info.

