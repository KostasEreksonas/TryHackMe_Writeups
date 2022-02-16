# Bounty Hacker

Writeup for [Bounty Hacker](https://tryhackme.com/room/cowboyhacker) room at [TryHackMe](https://tryhackme.com/).
URL for this room is: https://tryhackme.com/room/cowboyhacker

Table of Contents
=================
* [Port Scan](#Port-Scan)
* [Webpage](#Webpage)
* [Directory Enumeration](#Directory-Enumeration)
* [FTP Login](#FTP-Login)
* [SSH Bruteforce](#SSH-Bruteforce)
* [Privillege Escalation](#Privillege-Escalation)
* [Conclusion](#Conclusion)

# Port Scan

Issuing port scan with `nmap` showed 3 open ports.

```
# Nmap 7.92 scan initiated Wed Feb 16 02:38:56 2022 as: nmap -vv -sS -oN enum.txt 10.10.108.167
Nmap scan report for 10.10.108.167
Host is up, received echo-reply ttl 63 (0.15s latency).
Scanned at 2022-02-16 02:38:56 EST for 17s
Not shown: 967 filtered tcp ports (no-response)
PORT      STATE  SERVICE         REASON
20/tcp    closed ftp-data        reset ttl 63
21/tcp    open   ftp             syn-ack ttl 63
22/tcp    open   ssh             syn-ack ttl 63
80/tcp    open   http            syn-ack ttl 63
990/tcp   closed ftps            reset ttl 63
40193/tcp closed unknown         reset ttl 63
40911/tcp closed unknown         reset ttl 63
41511/tcp closed unknown         reset ttl 63
42510/tcp closed caerpc          reset ttl 63
44176/tcp closed unknown         reset ttl 63
44442/tcp closed coldfusion-auth reset ttl 63
44443/tcp closed coldfusion-auth reset ttl 63
44501/tcp closed unknown         reset ttl 63
45100/tcp closed unknown         reset ttl 63
48080/tcp closed unknown         reset ttl 63
49152/tcp closed unknown         reset ttl 63
49153/tcp closed unknown         reset ttl 63
49154/tcp closed unknown         reset ttl 63
49155/tcp closed unknown         reset ttl 63
49156/tcp closed unknown         reset ttl 63
49157/tcp closed unknown         reset ttl 63
49158/tcp closed unknown         reset ttl 63
49159/tcp closed unknown         reset ttl 63
49160/tcp closed unknown         reset ttl 63
49161/tcp closed unknown         reset ttl 63
49163/tcp closed unknown         reset ttl 63
49165/tcp closed unknown         reset ttl 63
49167/tcp closed unknown         reset ttl 63
49175/tcp closed unknown         reset ttl 63
49176/tcp closed unknown         reset ttl 63
49400/tcp closed compaqdiag      reset ttl 63
49999/tcp closed unknown         reset ttl 63
50000/tcp closed ibm-db2         reset ttl 63

Read data files from: /usr/bin/../share/nmap
# Nmap done at Wed Feb 16 02:39:13 2022 -- 1 IP address (1 host up) scanned in 17.72 seconds
```

More information about these open ports are given by a more detailed nmap scan.

```
# Nmap 7.92 scan initiated Wed Feb 16 02:40:14 2022 as: nmap -vv -A -p 21,22,80 -oN open_ports.txt 10.10.108.167
Nmap scan report for 10.10.108.167
Host is up, received echo-reply ttl 63 (0.062s latency).
Scanned at 2022-02-16 02:40:15 EST for 43s

PORT   STATE SERVICE REASON         VERSION
21/tcp open  ftp     syn-ack ttl 63 vsftpd 3.0.3
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.9.9.47
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 1
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_Can't get directory listing: TIMEOUT
22/tcp open  ssh     syn-ack ttl 63 OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 dc:f8:df:a7:a6:00:6d:18:b0:70:2b:a5:aa:a6:14:3e (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgcwCtWTBLYfcPeyDkCNmq6mXb/qZExzWud7PuaWL38rUCUpDu6kvqKMLQRHX4H3vmnPE/YMkQIvmz4KUX4H/aXdw0sX5n9jrennTzkKb/zvqWNlT6zvJBWDDwjv5g9d34cMkE9fUlnn2gbczsmaK6Zo337F40ez1iwU0B39e5XOqhC37vJuqfej6c/C4o5FcYgRqktS/kdcbcm7FJ+fHH9xmUkiGIpvcJu+E4ZMtMQm4bFMTJ58bexLszN0rUn17d2K4+lHsITPVnIxdn9hSc3UomDrWWg+hWknWDcGpzXrQjCajO395PlZ0SBNDdN+B14E0m6lRY9GlyCD9hvwwB
|   256 ec:c0:f2:d9:1e:6f:48:7d:38:9a:e3:bb:08:c4:0c:c9 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMCu8L8U5da2RnlmmnGLtYtOy0Km3tMKLqm4dDG+CraYh7kgzgSVNdAjCOSfh3lIq9zdwajW+1q9kbbICVb07ZQ=
|   256 a4:1a:15:a5:d4:b1:cf:8f:16:50:3a:7d:d0:d8:13:c2 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqmJn+c7Fx6s0k8SCxAJAoJB7pS/RRtWjkaeDftreFw
80/tcp open  http    syn-ack ttl 63 Apache httpd 2.4.18 ((Ubuntu))
|_http-title: Site doesn't have a title (text/html).
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache/2.4.18 (Ubuntu)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Crestron XPanel control system (90%), ASUS RT-N56U WAP (Linux 3.4) (87%), Linux 3.1 (87%), Linux 3.16 (87%), Linux 3.2 (87%), HP P2000 G3 NAS device (87%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (87%), Adtran 424RG FTTH gateway (86%), Linux 2.6.32 (86%), Linux 2.6.32 - 3.1 (86%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.92%E=4%D=2/16%OT=21%CT=%CU=%PV=Y%DS=2%DC=T%G=N%TM=620CAA8A%P=x86_64-pc-linux-gnu)
SEQ(SP=104%GCD=1%ISR=107%TI=Z%II=I%TS=A)
OPS(O1=M505ST11NW6%O2=M505ST11NW6%O3=M505NNT11NW6%O4=M505ST11NW6%O5=M505ST11NW6%O6=M505ST11)
WIN(W1=F4B3%W2=F4B3%W3=F4B3%W4=F4B3%W5=F4B3%W6=F4B3)
ECN(R=Y%DF=Y%TG=40%W=F507%O=M505NNSNW6%CC=Y%Q=)
T1(R=Y%DF=Y%TG=40%S=O%A=S+%F=AS%RD=0%Q=)
T2(R=N)
T3(R=N)
T4(R=Y%DF=Y%TG=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
U1(R=N)
IE(R=Y%DFI=N%TG=40%CD=S)

Uptime guess: 10.737 days (since Sat Feb  5 08:59:33 2022)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=260 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 21/tcp)
HOP RTT      ADDRESS
1   60.31 ms 10.9.0.1
2   65.04 ms 10.10.108.167

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Feb 16 02:40:58 2022 -- 1 IP address (1 host up) scanned in 43.92 seconds
```

# Webpage

The webpage shows and image of anime characters and some hints about the hacking task.

![Webpage](/Bounty_Hacker/images/Webpage.png)

# Directory Enumeration

The directory scan had shown images directory, which basically holds the image seen in the main page.

![Directory Enumeration](/Bounty_Hacker/images/Directory_Enumeration.png)

# FTP Login

The ftp service running on the machine is allowing anonymous login.

![Anonymous Login](/Bounty_Hacker/images/Anonymous_Login.png)

This directory has two text files - `locks.txt` and `task.txt`.

![FTP Files](/Bounty_Hacker/images/FTP_Files.png)

The FTP server was occasionally entering Extended Passive Mode, but eventually I was able to download both files to my
local machine.

Reading the task.txt file shows the name of the list creator.

![Task List](/Bounty_Hacker/images/Task_List.png)

This name might be used to log into ssh. As for password, `locks.txt` file contains possible ssh password values.

# SSH Bruteforce

Knowing the username and having a password list I can brute force ssh login using `hydra`. The attempt was succesful.

![Hydra Scan](/Bounty_Hacker/images/Hydra_Scan.png)

Using the found credentials I logged into the system via ssh.

![SSH Login](/Bounty_Hacker/images/SSH_Login.png)

When logged in, user flag could be found.

![User Flag](/Bounty_Hacker/images/User_Flag.png)

# Privillege Escalation

Issuing `sudo -l` command shows that the user can run `/bin/tar` command as root.

![Root Command](/Bounty_Hacker/images/Root_Command.png)

Searching GTFOBins for tar exploits shows how to spawn an interactive system shell.

![GTFOBins Exploit](/Bounty_Hacker/images/GTFOBins_Exploit.png)

Since I can run tar as root, with this I could spawn a root shell.

![Root Shell](/Bounty_Hacker/images/Root_Shell.png)

Going to the `/root` directory and reading `root.txt` file gives root flag.

![Root Flag](/Bounty_Hacker/images/Root_Flag.png)

# Conclusion

1. Port scan showed that the target system has ftp, ssh and http services running.
2. FTP service allowed anonymous login.
3. Inside the FTP server, there was two text files - one file had an username for SSH. THe other file contained a password list.
4. Using Hydra and the found password list I brute forced the correct password for the user.
5. When connected as this found user, I read the user flag.
6. The user on the system could run `tar` binary as root.
7. Found GTFOBins exploit to spawn a root shell using tar binary.
8. Exploited tar and got root shell. Went to `/root` directory and read the root flag.

Done!
