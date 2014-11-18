---
title: Linux Hardening Partitions
---

# Partitioning
Partitioning is an often overlooked but very important aspect of hardening a Linux machine. Properly partitioned machines allows for easier backups, no executable partitions, no special device partitions, no suid partitions, and protecting against attacks that fill disk space (restrict it to the size of the partition).

## Suggested Partitions
Here is a break down of a good partitioning scheme for a hardened server. For more information about the noexec, nodev, nosuid column see the Mounting Options section (these are highly suggested).

partition       | noexec | nodev | nosuid | location
----------------|--------|-------|--------|---------
/               | no     | no    | no     | /
/tmp            | yes    | yes   | yes    | /tmp
/var            | opt    | yes   | yes    | /var
/var/log        | opt    | yes   | yes    | /var/log
/var/log/audit  | opt    | yes   | yes    | /var/log/audit
/var/tmp        | yes    | yes   | yes    | /tmp
/home           | opt    | yes   | yes    | /home
/run/shm        | yes    | yes   | yes    | /run/shm
External Media  | yes    | yes   | yes    | /dev/*

A note, `/var/tmp` should be pointing to `/tmp`, this can be done by editing `/etc/fstab` to include:

```
/tmp /var/tmp none bind 0 0
```

# Mounting Options
When devices are mounted there are a certain set of mounting options that you will want to set in a hardened environment.
### noexec
The noexec option prevents files in the partition to be executed. This is obviously not suggested for development environments, but is very useful for a hardened environment. Simple add the noexec option to the 4th column in the `/etc/fstab` file:

```
UUID=$UUID /tmp ext4 rw,noexec 0 0
```

### nodev
The nodev option sets a partition so that it does not interpret character or block special devices on the file system. Add it to the 4th column in `/etc/fstab`:

```
UUID=$UUID /tmp ext4 rw,noexec,nodev 0 0
```

### nosuid

Do not allow set-user-identifier or set-group-identifier bits to take effect.

```
UUID=$UUID /tmp ext4 rw,noexec,nodev,nosuid 0 0
```
