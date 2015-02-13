---
title: Linux Hardening Users
---

# Passwords in Linux
## PAM Configuration
## Empty Passwords
Check for empty passwords:

``` bash
$ cat /etc/shadow | awk -F: '($2 == "" ) { print $1 " does not have a password "}'
```
## Legacy Passwords
If a passwd entry has a + sign in it it means that the machine is trying to use resources from NIS, NIS+, or LDAP. This could lead to priveledge escalation and is considered legacy. You can check with:

``` bash
grep '^+:' /etc/passwd
grep '^+:' /etc/shadow
grep '^+:' /etc/group
```

# Users
## UID 0 Accounts
If an account has UID 0 they have access to almost everything that root has access too and should not ever exist.

``` bash
$ cat /etc/passwd | awk -F: '($3 == 0) { print $1 }'
root
```
If anything other than root you need to remove that entry.

## Duplicate UIDs
If there is a UID duplication the users can take over files of the other user.

``` bash
$ cut -f3 -d: /etc/passwd | sort -n | uniq -c | awk '!/ 1 / {print $2}'
```

If the above prints anything then the files for each user need to be reviewed and new accounts need to be generated.

## Duplicate Usernames
## Valid $HOME Directory
## Root $PATH Integrity
## User $HOME Directory Permissions
## .netrc
## .rhosts
## .forward
## .bash_history
# Groups
## Review Groups
## Duplicate GIDs
## Duplicate Group Names
## Shadow Group
