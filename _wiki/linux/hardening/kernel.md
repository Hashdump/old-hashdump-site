---
title: Linux Hardening Kernel
---
# Kernel
When hardening machines many people tend to forget the kernel and kernel modules. Here is a quick run down of some potentially issue causing kernel modules and flags that can help you stay safe.

## Module Quick Guide
Some kernel modules are enabled by default but are not considered safe or recommended to leave enabled in a hardened environment. Here is a list of those kernel modules, suggested values, and reasoning.

``` bash
#Logs unroutable packets
net.ipv4.conf.all.log_martians=1
net.ipv4.conf.default.log_martians=1
#Ignore broadcast requests (smurfing)
net.ipv4.icmp_echo_ignore_broadcasts=1
#Prevent log flooding from ICMP
net.ipv4.icmp_ignore_bogus_error_responses=1
#If the return packet does not go out the same interface that the corresponding source packet came from, the packet is dropped. NOT ALWAYS RECOMMENDED
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
#Set max SYN backlog
net.ipv4.tcp_max_syn_backlog=4096
#SYN Cookies make a machine resistant to SYN Flooding
net.ipv4.tcp_syncookies=1
#Disable ICMP redirects
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
#Disable 'secure' ICMP redirects
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.default.secure_redirects=0
#Prevent users from specifying their own source route
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0
#Disable IP forwarding
net.ipv4.ip_forward=0
#Disable sending of ICMP redirect packets
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
#Disable IPv6 NOT ALWAYS RECOMMENDED
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
#Restrict access to dmesg
kernel.dmesg_restrict=1
#Restrict access to kernel pointers, an attacker could dynamically resolve addresses based on those pointers
kernel.kptr_restrict=1
#Packet filter JIT disabled. JIT is not good for your security
net.core.bpf_jit_enable=0
#Restrict ptrace
kernel.yama.ptrace_scope=1
#Prevent symlink-based time-of-check-time-of-use race
fs.protected_hardlinks=1
fs.protected_symlinks=1
#More strict address randomization
kernel.randomize_va_space=2
```

## USB
On servers disabling USB can be disabled by adding a boot parameter, in BIOS, or through modprobe.

For grub add `nousb` parameter to /boot/grub/grub.cfg:

```
 linux   /vmlinuz-<kernel> root=/dev/mapper/<name> ro nousb
```

For modprobe entery append the following to `/etc/modprobe.conf`:

```
install usb-storage :
```

BIOS is done on an individual basis and you should read the manual to see if it is possible.

## 32-Bit NX
A thing to note, if you MUST use 32 bit Linux (avoid at all costs) then make sure that you have a None Executable stack enabled. Check for support with:

``` bash
$ dmesg | grep NX
[    0.000000] NX (Execute Disable) protection: active
```
If this is not active then check BIOS settings and use a PAE supported kernel.

## Advanced
See the Grsecurity section in the wiki
