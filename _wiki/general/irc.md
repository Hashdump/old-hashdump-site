---
title: IRC
---

IRC (Internet Relay Chat) is a simple chatting system that also allows for chat rooms (channels), private messaging, file transfering, and more. IRC is a typical client-server protocol with many clients and servers floating around the internet.

## Hashdump IRC Info

Server: `irc.freenode.net`

Channel `#hashdump`

We also provide a link in the navigation bar to a web based IRC client.

## Freenode Tips and Tricks

freenode runs a couple of services that help users keep their nicks and to help provide marginal privacy. Below are a couple of things we suggest to do when connecting to freenode.

For more details see [freenode FAQ](https://freenode.net/faq.shtml).

### SSL

freenode provides SSL client access on all of its servers. This will ensure that your data to the server will be encrypted. It should be noted that anyone in a channel can still be logging or could be using an insecure connection exposing the chatter on their end. You should always verify the SSL certificates (see each different clients manuals for instructions). The following ports are used by freenode:

* 6697
* 7000
* 7070

Users connected over SSL should have the user mode +Z and WHOIS should respond with 'is using a secure connection'.

### User Registration

freenode also provides a way for you to register your nick, allowing you to essentially own the name. This is also a way for the freenode services to identify you as an OP in a registered chan as well as for other services.

Register your nick by sending a private message to the NickServ bot (make sure to choose a unique password as it is possible to send this in plaintext):

```
/msg NickServ REGISTER <password> <email@example.com>
```

You will get an email telling you to run a verification command, follow those instructions.

Then you may want to also hide your registration email, just run:

```
/msg NickServ SET HIDEMAIL ON
```

### Identification

Once you log off IRC and log back on you will have to re-identify yourself with the server. This is very simple:

```
/msg NickServ IDENTIFY <user> <password>
```

## Clients

There are many different IRC clients out there, many with their own positives and negatives, below is a list of clients and a quick list of features on each.

### Console

* IRSSI - Open Source, Unix, Console, curses interface, pluggin system
* WeeChat - Same as IRSSI with a different feel
* Telnet - I'm not kidding

### GUI

* Xchat - Open Source (Must compile it yourself on windows), easy to use, pluggin system
* Hexchat - Precompiled Xchat
* Colloquy - OSX/Mobile, somewhat open source

### Other
* Web based IRC - For the new/lazy
