---
title: Linux Hardening: Packages
---
# Packages
Keeping things up to date is obviously important.
## Sync Mirrors
Debian/Ubuntu:

``` bash
$ apt-get update
```

RHEL/Fedora/CentOS:
yum cannot sync the package database seperately from updating.

## Update Packages
To list available updates:
Debian/Ubuntu:

``` bash
$ apt-get --just-print upgrade
```

RHEL/Fedora/CentOS:

``` bash
$ yum list updates
```

To actually update:
Debian/Ubuntu:

``` bash
$ apt-get upgrade
```

RHEL/Fedora/CentOS:

``` bash
$ yum update
```

## Remove Unnecessary Packages
Minimizing the packages installed helps reduce the attack surface. Removing unnecessary packages is generally a manual process to prevent removing packages that are dependencies.

Debain/Ubuntu:

``` bash
$ dpkg --list
$ dpkg --info $PACKAGE
$ apt-get remove $PACKAGE
```

RHEL/Fedora/CentOS:

``` bash
$ yum list installed
$ yum list $PACKAGE
$ yum remove $PACKAGE
```

## Automatically Update Packages
While not recommended for all types of systems, for most creating automatic updates for packages is very useful.


