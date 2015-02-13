---
title: Linux Hardening IPv6
---
# IPv6
As with all services and programs, if you are not going to use it in production you should not have it installed or responding. If you are running IPv6 on the server then go to the `Disable Portions` section or if you do not want IPv6 at all you should see `Completely Disable`
## Disable Portions
### IPv6 Router Advertisements
If this is allowed an attacker may be able to trick a machine into routing traffic to a place they did not intend. Run the follwing:

``` bash
$ sysctl net.ipv6.conf.all.accept_ra
net.ipv6.conf.all.accept_ra = 1
$ sysctl net.ipv6.conf.default.accept_ra
net.ipv6.conf.default.accept_ra = 1
```

If those print anything but 0 then edit `/etc/sysctl.conf` or for systemd `/etc/sysctl.d/40-ipv6.conf` to this:

``` bash
net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.default.accept_ra=0
```

And for the active kernel you must change these settings and flush your routes:

``` bash
$ sysctl -w net.ipv6.conf.all.accept_redirects=0
$ sysctl -w net.ipv6.conf.default.accept_redirects=0
$ sysctl -w net.ipv6.route.flush=1
```
### IPv6 Redirect ICMP Acceptance
ICMP redirects could be used to trick victims into routing unwanted or malicious ICMP traffic. You can check this by running:

``` bash
$ sysctl net.ipv6.conf.all.accept_redirects
net.ipv4. net.ipv6.conf.all.accept_redirect = 0
$ sysctl net.ipv6.conf.default.accept_redirects
net.ipv4. net.ipv6.conf.default.accept_redirect = 0
```

If those print anything but 0 then edit `/etc/sysctl.conf` or for systemd `/etc/sysctl.d/40-ipv6.conf` to this:

``` bash
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0
```

And for the active kernel you must change these settings:

``` bash
$ sysctl -w net.ipv6.conf.all.accept_redirects=0
$ sysctl -w net.ipv6.conf.default.accept_redirects=0
$ sysctl -w net.ipv6.route.flush=1
```

## Completely Disable
If you are not using IPv6 it is best to disable it. This can be done by editing `/etc/sysctl.conf` or for systemd `/etc/sysctl.d/40-ipv6.conf` to contain the following:

```
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
```

and then run:

```bash
$ sysctl -p
```
