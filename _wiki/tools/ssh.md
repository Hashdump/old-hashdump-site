---
title: SSH
---

SSH or Secure SHell is a tool that allows a user remote access to a machine. It uses [[Encryption:PublicKeyCryptography|Public Key Cryptography]]
to ensure a secure connection between the server and the client. Some of the cool features of SSH are:

* Remote terminal access
* Connection proxies
* Connection forwarding
* X11 forwarding (almost like remote desktop)


## Client

### Basic Usage

The basic usage of ssh is to run:

``` bash
ssh [options] user@host.domain
```

Where 'user' is the username on the remote machine and 'host.domain' is the machine's name or IP address

``` bash
[xunil@orion ~]$ ssh campbell@pea.cs.colostate.edu
campbell@pea.cs.colostate.edu's password:
Last login: Mon Sep 10 11:16:55 2012 from cucumber.cs.colostate.edu
```

---- SNIP ----

``` bash
Welcome to the machine  pea
pea:~$ uname -a
Linux pea 3.4.6-1.fc16.x86_64 #1 SMP Fri Jul 20 12:58:04 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
pea:~$
```

### Common Flags

* -p &lt;port #&gt;  The port to connect to
* -D &lt;Listen Port&gt;  Will create a local SOCKS 5 proxy listening on &lt;Listen Port&gt;
* -i &lt;identity file&gt;  Use the given &lt;identity file&gt; for identifying with the server
* -v[vvv] Verbosity level (more v's mean more verbosity)

### Local Configs

SSH uses a local configuration file to pull in options. This can be very useful for easily accessing servers

Consider the following local configuration:

~/.ssh/config

``` bash
Host csu
User bob
HostName beast.cs.colostate.edu

Host pea
Hostname pea.cs.colostate.edu
User bob
IdentityFile /home/xunil/.ssh/id_rsa

Host home
Hostname deadbeef.dyndns.org
Port 666
IdentityFile /home/bob/.ssh/home_rsa
User deadbeef
```

This will allow the user to simply run:

``` bash
[laptop ~]$ ssh csu
bob@beast.cs.colostate.edu's password:
beast:~$ whoami
bob
beast:~$ _
```
or

``` bash
[laptop ~]$ ssh home
Enter passphrase for key '/home/bob/.ssh/home_rsa':
[home ~]# whoami
deadbeef
[home ~]#
```


This makes ssh much more managable because you are no longer having to specify

``` bash
[laptop ~]$ ssh -i ~/.ssh/home_rsa -p 666 deadbeef@deadbeef.dyndns.org
```


### Using SSH As a Proxy

SSH has the ability to be a SOCKS 5 proxy. It will listen locally and forward all connection requests
from the remote ssh server.

#### Start the proxy

``` bash
$ ssh -D 5555 campbell@cucumber.cs.colostate.edu
```

#### Configure your browser

##### Firefox

* Open up firefox preferences: Edit-&gt;Preferences
* Goto the 'Advanced' tab
* Select the 'Network' sub-tab and click on 'Settings'
  * Select 'Manual proxy configuration'
  * Leave 'HTTP/SSL/FTP' proxy options blank
  * Set the 'SOCKS Host:' field to '127.0.0.1'
  * Set the 'Port:' filed to the port used previousally (5555 in our case)
  * Click ok
* Close

Now Firefox should be configured to use the SSH tunnel as a proxy!

To test this, point the browser to 'www.whatismyip.com' and you should see the IP of the remote host.

##### Issues

If everything above is working correctly then Firefox will be sending all web traffic through the encrypted SSH tunnel.
This protects the web content from potentially mallicious hackers between you and the remote host. But there is one
crutial element that is NOT being sent through this tunnel. The [[Services:DNS|DNS queries]] are still being sent outside
of the SSH tunnel. To fix this problem:

* Type &quot;about:config&quot; into your URL bar
* Promise that you will be careful
* Seach for 'dns'
* Doubble click 'network.proxy.socks_remote_dns' to toggle it to 'true'

That's it! Firefox will now send all of the DNS queries through the SSH tunnel as well.

## Server
Setting up an SSH server is in general, trivial. However, there are several security issues that can exist with just a basic SSH server configuration.

### Setup
For the following configurations I will be using Ubuntu 12.04 however the configuration file should work for nearly all OpenSSH servers. This section is more or less
a generalization of the manual located at https://help.ubuntu.com/community/SSH

#### Install

``` bash
$ sudo apt-get install openssh-client openssh-server
```

### Configuration

Make a backup of the current configuration

``` bash
$ sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original &amp;&amp; chmod 400 /etc/ssh/sshd_config.original
```

Some of the default configurable paramaters:

``` bash
Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```

The Default port is 22, it is reccomended that you change this since there are many automated port scanners that will attempt to brute force your server
with default accounts and passwords. The ListenAddress options exist in case you want to have the SSH server to listen on a specific network card or IP address.

``` bash
# The default requires explicit activation of protocol 1
Protocol 2
```

You should ALWAYS set this to protocol 2 as protocol 1 has been broken and can reveal all traffic in clear text. See the vulnerabilities section for more details

### Securing sshd

``` bash
# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#RhostsRSAAuthentication no
# similar for protocol version 2
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# RhostsRSAAuthentication and HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes
```

## Upgrading to More Secure Keys

This is a work in progress, more info to come.

``` bash
 mv ~/.ssh/id_rsa ~/.ssh/id_rsa.old
 openssl pkcs8 -topk8 -v2 aes-256-cbc -in ~/.ssh/id_rsa.old -out ~/.ssh/id_rsa
 chmod 600 ~/.ssh/id_rsa
```

## Tunneling SSH Through SSL

Under some circumstances SSH might be blocked at the firewall level, luckily a way around this is to use stunnel to tunnel your SSH connection through SSL. All the firewall should detect is something similar to encrypted web traffic. In order to set this up you must have '''stunnel''' installed on the server.

### Server Setup
Create a file called stunnel.config

``` bash
 #stunnel.config
 cert=/path/to/stunnel.pem
 pid=/tmp/stunnel.pid
 [ssh]
 accept = &lt;serverip&gt;:443
 connect = 127.0.0.1:22
```

Then we need to create a self signed certificate

    openssl genrsa 1024 &gt; stunnel.key

Now for the actual generation of the cert. Just hit enter for all of these options since we are not connecting it to any trust database.

    openssl req -new -key stunnel.key -x509 -days 1000 -out stunnel.crt

Now we generate the PEM file which contains the cert and key

    cat stunne.crt stunnel.key &gt; stunnel.pem

Then start the tunnel:

    stunnel4 stunnel.config

If you want to verify if it is running run:

    netstat -tanp

### Client Setup

Create a configuration file called stunnelclient.config and add the following:

``` bash
 cert=/home/ghetrick/stunnel/stunnel.pem
 pid=/tmp/stunnel.pid
 client=yes
 [ssh]
 accept=2200
 ;protocol=connect
 ;protocolHost=&lt;ip:port&gt;
 ;protocolUsername=&lt;username&gt;
 ;protocolPassword=&lt;pass&gt;
 connect=&lt;ip: port&gt;
```

If you need to go through a proxy you can uncomment the &quot;protocol&quot; lines and fill out the information accordingly. Where protocolHost is the server you want to connect to, and connect becomes the IP and port of the proxy device. If there is no proxy present the connect line is the IP and port of the remote host to connect to. Otherwise start stunnel:

``` bash
stunnel4 stunnelclient.config
```

and then ssh to the port added to accept like so:

``` bash
ssh -p 2200 localhost
```

## SCP

SCP is a file transfer program that operates on top of SSH. The command structure is

``` bash
$ scp [options] [user@source_host:]file_path [user@destination_host:]file_path
```

Where the items in []'s are optional

Examples:

This will copy the local file 'Homework1.pdf' to Homework/cs356/hw1/Homework1.pdf on the host pea.cs.colostate.edu

``` bash
$ scp Homework1.pdf  campbell@pea.cs.colostate.edu:Homework/cs356/hw1
campbell@pea.cs.colostate.edu's password:
Homework1.pdf                                              100% 1280 0.9KB/s 00:01
```


This will copy the remote file 'Homework/cs457/notes/scp.txt' living on pea.cs.colostate.edu to the local directory 'school/cs457/scp.txt'

```
$ scp campbell@pea.cs.colostate.edu:Homework/cs457/notes/scp.txt school/cs457
campbell@pea.cs.colostate.edu's password:
scp.txt                                                    100% 743 0.5KB/s 00:00
```

### Common Options

* -P &lt;port&gt; The remote server's port (note: P not p)
* -o ssh_option
  * -oPort=666
  * -oIdentityFile=~/.ssh/id_rsa
