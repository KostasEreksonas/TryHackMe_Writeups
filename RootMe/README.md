# RootMe

Writeup for [RootMe](https://tryhackme.com/room/rrootme) room at [TryHackMe](https://tryhackme.com/).
URL for this room is: https://tryhackme.com/room/rrootme

Table of Contents
=================
* [Port Scan](#Port-Scan)
* [Directory Enumeration](#Directory-Enumeration)
* [Reverse Shell](#Reverse-Shell)
* [Privillege Escalation](#Privillege-Escalation)

# Port Scan

Firstly, I have scanned for open ports using `nmap` (searched for the most common 1000 ports). The scan identified two ports as open - port 22 (SSH) and port 80 (HTTP).

```
# Nmap 7.60 scan initiated Tue Nov 30 20:10:00 2021 as: nmap -vv -sS -oN port_scan.txt 10.10.37.116
Nmap scan report for ip-10-10-37-116.eu-west-1.compute.internal (10.10.37.116)
Host is up, received arp-response (0.0035s latency).
Scanned at 2021-11-30 20:10:00 GMT for 2s
Not shown: 998 closed ports
Reason: 998 resets
PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 64
80/tcp open  http    syn-ack ttl 64
MAC Address: 02:79:72:69:DD:05 (Unknown)

Read data files from: /usr/bin/../share/nmap
# Nmap done at Tue Nov 30 20:10:02 2021 -- 1 IP address (1 host up) scanned in 2.01 seconds
```

Running a more detailed nmap scan on the target machine revealed the Apache server version in http-server-header.

```
 Nmap 7.60 scan initiated Tue Nov 30 20:16:14 2021 as: nmap -vv -sS -A -p 22,80 -oN open_ports.txt 10.10.37.116
adjust_timeouts2: packet supposedly had rtt of -175552 microseconds.  Ignoring time.
adjust_timeouts2: packet supposedly had rtt of -175552 microseconds.  Ignoring time.
Nmap scan report for ip-10-10-37-116.eu-west-1.compute.internal (10.10.37.116)
Host is up, received arp-response (0.00064s latency).
Scanned at 2021-11-30 20:16:15 GMT for 12s

PORT   STATE SERVICE REASON         VERSION
22/tcp open  ssh     syn-ack ttl 64 OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 4a:b9:16:08:84:c2:54:48:ba:5c:fd:3f:22:5f:22:14 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9irIQxn1jiKNjwLFTFBitstKOcP7gYt7HQsk6kyRQJjlkhHYuIaLTtt1adsWWUhAlMGl+97TsNK93DijTFrjzz4iv1Zwpt2hhSPQG0GibavCBf5GVPb6TitSskqpgGmFAcvyEFv6fLBS7jUzbG50PDgXHPNIn2WUoa2tLPSr23Di3QO9miVT3+TqdvMiphYaz0RUAD/QMLdXipATI5DydoXhtymG7Nb11sVmgZ00DPK+XJ7WB++ndNdzLW9525v4wzkr1vsfUo9rTMo6D6ZeUF8MngQQx5u4pA230IIXMXoRMaWoUgCB6GENFUhzNrUfryL02/EMt5pgfj8G7ojx5
|   256 a9:a6:86:e8:ec:96:c3:f0:03:cd:16:d5:49:73:d0:82 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBERAcu0+Tsp5KwMXdhMWEbPcF5JrZzhDTVERXqFstm7WA/5+6JiNmLNSPrqTuMb2ZpJvtL9MPhhCEDu6KZ7q6rI=
|   256 22:f6:b5:a6:54:d9:78:7c:26:03:5a:95:f3:f9:df:cd (EdDSA)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4fnU3h1O9PseKBbB/6m5x8Bo3cwSPmnfmcWQAVN93J
80/tcp open  http    syn-ack ttl 64 Apache httpd 2.4.29 ((Ubuntu))
| http-cookie-flags:
|   /:
|     PHPSESSID:
|_      httponly flag not set
| http-methods:
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: HackIT - Home
MAC Address: 02:79:72:69:DD:05 (Unknown)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Linux 3.8 (95%), Linux 3.1 (94%), Linux 3.2 (94%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 2.6.32 (92%), Linux 2.6.39 - 3.2 (92%), Linux 3.1 - 3.2 (92%), Linux 3.2 - 4.8 (92%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.60%E=4%D=11/30%OT=22%CT=%CU=31334%PV=Y%DS=1%DC=D%G=N%M=027972%TM=61A6869B%P=x86_64-pc-linux-gnu)
SEQ(SP=104%GCD=1%ISR=10B%TI=Z%CI=Z%TS=A)
OPS(O1=M2301ST11NW7%O2=M2301ST11NW7%O3=M2301NNT11NW7%O4=M2301ST11NW7%O5=M2301ST11NW7%O6=M2301ST11)
WIN(W1=F4B3%W2=F4B3%W3=F4B3%W4=F4B3%W5=F4B3%W6=F4B3)
ECN(R=Y%DF=Y%T=40%W=F507%O=M2301NNSNW7%CC=Y%Q=)
1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)
T2(R=N)
T3(R=N)
T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)
IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 42.429 days (since Tue Oct 19 10:58:04 2021)
Network Distance: 1 hop
TCP Sequence Prediction: Difficulty=260 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE
HOP RTT     ADDRESS
1   0.64 ms ip-10-10-37-116.eu-west-1.compute.internal (10.10.37.116)

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Tue Nov 30 20:16:27 2021 -- 1 IP address (1 host up) scanned in 12.93 seconds
```

# Directory Enumeration

Next I had enumerated directories of the webserver with `gobuster` and it found a few interesting directories.

![Directory Enumeration](/RootMe/images/Directory_Enumeration.png)

# Webpage

Opened the homepage of the page on the given IP address and found a question "Can you root me?"

![Homepage](/RootMe/images/Homepage.png)

Going to one of the found directories, we can find a file upload form.

![File Upload](/RootMe/images/File_Upload.png)

Webserver did ***not*** accept `.php` files.

![Upload Fail](/RootMe/images/Upload_Fail.png)

On the other hand, the webserver ***did*** accept `.png` files.

![Upload Success](/RootMe/images/Upload_Success.png)

Now I had copied a PHP reverse shell from `/usr/share/webshells/php` on the `AttackBox` and changed it's extension to `.png`.

![Webshell Bypass](/RootMe/images/Webshell_Bypass.png)

Then I had opened the reverse shell on a text editor, found a `CHANGE THIS` comment and added the AttackBox IP address there.

The reverse shell uploaded successfully!

![Upload Success](/RootMe/images/Upload_Success.png)

# Reverse Shell

Now I did set up a `netcat` listener on port ***1234*** for the reverse shell.

![Netcat Listener](/RootMe/images/Netcat_Listener.png)

Then I had gone to the next interesting directory that I found earlier.

![Uploaded Files](/RootMe/images/Uploaded_Files.png)

The reverse shell with `.png` extension was interpreted as an image file, so it was necessary to find another file extension that would work.

![Broken Image](/RootMe/images/Broken_Image.png)

I found that `.phtml` file extension worked and gave us a reverse shell!

![Successful Connection](/RootMe/images/Successful_Connection.png)

Now using `find` command I had searched for ***user.txt*** file.

![Find Flag](/RootMe/images/Find_Flag.png)

Catting the `user.txt` file at found location gives the flag.

![User Flag](/RootMe/images/User_Flag.png)

# Privillege Escalation

For privillege escalation, I had searched for files with SUID permission, using find command.

![SUID Files](/RootMe/images/SUID_Files.png)

One of these files can be exploited.

Searching [GTFOBins](https://gtfobins.github.io/) for payloads for that specific file led to a command for exploiting this binary with SUID bit set. Using this command gave me a root shell.

![Root Shell](/RootMe/images/Root_Shell.png)

Now going to the `root` directory and catting `root.txt` file gave me the root flag.

![Root Flag](/RootMe/images/Root_Flag.png)

Done!
