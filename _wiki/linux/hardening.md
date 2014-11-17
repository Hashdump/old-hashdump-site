---
title: Linux Hardening Guide
---
This is a general hardening guide for Linux. Think of it as more of a cheat sheet or reference than a definitive checklist. Do NOT use all of these in production, use your standard operating procedure. This guide assumes escalated priveledges, if something does not work escalate priveledges.

# Auditing
# Boot
{{ site.baseurl }}/wiki/linux/hardening-boot.html
# Backups
# cron
# Disk Encryption
# Firewall
## iptables
## ufw
# IPv6
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
