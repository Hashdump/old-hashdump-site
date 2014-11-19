---
title: Linux Hardening Services
---

# Services
By leaving services enabled the attack surface greatly increases and allows attackers to broaden their scope.

## Boot Services
To check for processes that are running at boot time you need to know your init system. There are 3 init systems; `upstart` which is used by Ubuntu, `SysVinit` used by Debian and many older systems, and `systemd` which is used by many distros.

The 3 styles of managing boot services is like:

`systemctl <COMMAND> <NAME>` - systemd
`service <NAME> <COMMAND>` - service
`/etc/init.d/<NAME> <COMMAND>` - SysV

For each of these you should comb through the list of startup applications and clear out any unnecessary services from boot.

### systemd
In order to view unit files:

``` bash
$ systemctl list-unit-files
```

To enable a service (ssh in this example):
``` bash
$ systemctl enable sshd
```

To disable a service (ssh):

``` bash
$ systemctl disable sshd
```

To list a service status:

``` bash
$ systemctl status sshd
```

To stop a service (until next boot if enabled):

``` bash
$ systemctl stop sshd
```

To start a service (until next boot if enabled):
``` bash
$ systemctl start sshd
```
### SysV Init
SysV is a little more dated and runs its files in from the `/etc/init.d` directory. A thing to note with SysV is that they are simply bash scripts, so their options and abilities are entirely by what is used in the script. This means that there may or may not be some functionality.

To list services run:

``` bash
$ ls /etc/init.d/
```

If `/etc/init.d/ssh` exists, then it is already slated to run at boot. To disable it simply remove the file (or backup and move the file).

To see the status:

``` bash
$ /etc/init.d/ssh status
```

To start a service:

``` bash
$ /etc/init.d/ssh start
```

To stop a service:

``` bash
$ /etc/init.d/ssh stop
```
### Upstart
TBD
## Running Processes
To kill running processes that are not services you can find processes with `ps` or with `top` for interactive and more processes information.

``` bash
$ ps -A
```
Then you can kill the processes with `kill` or `pkill`.
## Networking Services

To see which processes are running on the machine you can run `netstat` or `ss`.

To see listening processes:

``` bash
$ netstat -lnptue
$ ss -ltua
```

Then you need to make decisions about how to manage those services.
