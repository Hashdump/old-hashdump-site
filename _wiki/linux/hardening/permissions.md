---
title: Linux Hardening Permissions
---
# Permissions
Permissions are often overlooked, but improper handeling of permissions can cause cascading compromise and/or priveledge escalation.
## Finding Bad Permissions
### World Writeable
In order to find world writeable files and directories you can review those files with:

``` bash
$ find / -perm -2 ! -type l -ls
```

To find just files:

``` bash
$ find / -perm -0002 -type f -print
```

To find just directories:

``` bash
$ find / -perm -0002 -type d -print
```

### Un-owned Files
If a user account is deleted and their files become unowned a new user that gets generated could have the same UID as the old user and thus inherit permissions to the old users files. To check for this:

``` bash
$ find / -nouser -ls
```

### Un-grouped Files
Same as with unowned files, but with groups.

``` bash
$ find / -nogroup -print
```

### SUID Files
SUID files are very much valid, but it is important to make sure that you identify and review those files.

``` bash
$ find / -type f -perm -4000 -print
```

### SGID Files
SGID files are very much valid, but it is important to make sure that you identify and review those files.

``` bash
$ find / -type f -perm -2000 -print
```
### Broken Symlinks
# Important Files
A small list of important files that permissions are worth checking. Depending on what services the server is running you should check the specific services configs. Please feel free to add more

File               | Perm. Bits | Owner | Group
-------------------|------------|-------|------
/etc/crontab       | 600        | root  | root
/etc/cron.hourly   | 600        | root  | root
/etc/cron.daily    | 600        | root  | root
/etc/cron.weekly   | 600        | root  | root
/etc/cron.monthly  | 600        | root  | root
/etc/cron.d        | 600        | root  | root
/etc/passwd        | 644        | root  | root
/etc/shadow        | *00        | root  | root
/etc/group         | 644        | root  | root
/etc/ssh/sshd.conf | 600        | root  | root
/boot              | 600        | root  | root
...                | ...        | ...   | ...
