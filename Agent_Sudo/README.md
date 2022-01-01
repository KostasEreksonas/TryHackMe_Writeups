# Agent Sudo

Writeup for [Agent Sudo](https://tryhackme.com/room/agentsudoctf) room at [TryHackMe.com](https://tryhackme.com/)
URL for Agent Sudo room is: https://tryhackme.com/room/agentsudoctf

Table of Contents
=================
* [Port Scan](#Port-Scan)
* [Webpage](#Webpage)
* [FTP Enumeration](#FTP-Enumeration)
* [Image File Steganography](#Image-File-Steganography)
* [SSH Access](#SSH-Access)
* [Privillege Escalation](#Privillege-Escalation)
* [Conclusion](#Conclusion)

# Port Scan

Port scan using `nmap` tool revealed a few open ports.

```
# Nmap 7.92 scan initiated Fri Dec 31 17:40:34 2021 as: nmap -vv -oN enum.txt 10.10.147.109
Increasing send delay for 10.10.147.109 from 0 to 5 due to 63 out of 208 dropped probes since last increase.
Increasing send delay for 10.10.147.109 from 5 to 10 due to 11 out of 24 dropped probes since last increase.
Nmap scan report for 10.10.147.109
Host is up, received echo-reply ttl 63 (0.13s latency).
Scanned at 2021-12-31 17:40:34 EST for 18s
Not shown: 997 closed tcp ports (reset)
PORT   STATE SERVICE REASON
21/tcp open  ftp     syn-ack ttl 63
22/tcp open  ssh     syn-ack ttl 63
80/tcp open  http    syn-ack ttl 63

Read data files from: /usr/bin/../share/nmap
# Nmap done at Fri Dec 31 17:40:52 2021 -- 1 IP address (1 host up) scanned in 18.44 seconds
```

Conducting a more in-depth scan on the open ports revealed the following information.

```
# Nmap 7.92 scan initiated Fri Dec 31 17:41:48 2021 as: nmap -vv -A -p 21,22,80 -oN port_scan.txt 10.10.147.109
Nmap scan report for 10.10.147.109
Host is up, received echo-reply ttl 63 (0.11s latency).
Scanned at 2021-12-31 17:41:48 EST for 20s

PORT   STATE SERVICE REASON         VERSION
21/tcp open  ftp     syn-ack ttl 63 vsftpd 3.0.3
22/tcp open  ssh     syn-ack ttl 63 OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 ef:1f:5d:04:d4:77:95:06:60:72:ec:f0:58:f2:cc:07 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5hdrxDB30IcSGobuBxhwKJ8g+DJcUO5xzoaZP/vJBtWoSf4nWDqaqlJdEF0Vu7Sw7i0R3aHRKGc5mKmjRuhSEtuKKjKdZqzL3xNTI2cItmyKsMgZz+lbMnc3DouIHqlh748nQknD/28+RXREsNtQZtd0VmBZcY1TD0U4XJXPiwleilnsbwWA7pg26cAv9B7CcaqvMgldjSTdkT1QNgrx51g4IFxtMIFGeJDh2oJkfPcX6KDcYo6c9W1l+SCSivAQsJ1dXgA2bLFkG/wPaJaBgCzb8IOZOfxQjnIqBdUNFQPlwshX/nq26BMhNGKMENXJUpvUTshoJ/rFGgZ9Nj31r
|   256 5e:02:d1:9a:c4:e7:43:06:62:c1:9e:25:84:8a:e7:ea (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHdSVnnzMMv6VBLmga/Wpb94C9M2nOXyu36FCwzHtLB4S4lGXa2LzB5jqnAQa0ihI6IDtQUimgvooZCLNl6ob68=
|   256 2d:00:5c:b9:fd:a8:c8:d8:80:e3:92:4f:8b:4f:18:e2 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOL3wRjJ5kmGs/hI4aXEwEndh81Pm/fvo8EvcpDHR5nt
80/tcp open  http    syn-ack ttl 63 Apache httpd 2.4.29 ((Ubuntu))
|_http-title: Annoucement
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache/2.4.29 (Ubuntu)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Linux 3.10 - 3.13 (95%), ASUS RT-N56U WAP (Linux 3.4) (95%), Linux 3.16 (95%), Linux 3.1 (93%), Linux 3.2 (93%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (92%), Linux 3.10 (92%), Linux 3.18 (92%), Linux 3.2 - 4.9 (92%), Linux 3.4 - 3.10 (92%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.92%E=4%D=12/31%OT=21%CT=%CU=37417%PV=Y%DS=2%DC=T%G=N%TM=61CF8740%P=x86_64-pc-linux-gnu)
SEQ(SP=FF%GCD=1%ISR=106%TI=Z%CI=I%II=I%TS=A)
SEQ(SP=FD%GCD=1%ISR=105%TI=Z%II=I%TS=A)
OPS(O1=M505ST11NW6%O2=M505ST11NW6%O3=M505NNT11NW6%O4=M505ST11NW6%O5=M505ST11NW6%O6=M505ST11)
WIN(W1=68DF%W2=68DF%W3=68DF%W4=68DF%W5=68DF%W6=68DF)
ECN(R=Y%DF=Y%T=40%W=6903%O=M505NNSNW6%CC=Y%Q=)
T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)
T2(R=N)
T3(R=N)
T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)
IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 22.197 days (since Thu Dec  9 12:58:10 2021)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=253 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 21/tcp)
HOP RTT       ADDRESS
1   71.54 ms  10.9.0.1
2   148.31 ms 10.10.147.109

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Dec 31 17:42:08 2021 -- 1 IP address (1 host up) scanned in 20.13 seconds
```

# Webpage

Following the given IP address gives a webpage with the following message:

![Webpage](/Agent_Sudo/images/Webpage.png)

It tells that I should use my own codename to access the site. Since this message is from the Agent ***R***, codenames should be just aplhabet letters. Let's try R first.

![Wrong Agent](/Agent_Sudo/images/Wrong_Agent.png)

I can not access the system as agent R... If we try agent C though:

![Agent Name](/Agent_Sudo/images/Agent_Name.png)

I have full name of our agent. Also, the password is weak, so it might be possible to brute-force it.

# FTP Enumeration

As I found out earlier, ftp port is open on the system. Using `hydra` I was able to brute-force the password of the found user.

![FTP Password](/Agent_Sudo/images/FTP_Password.png)

Connecting to the server via FTP with found credentials gives list of a couple of files.

![FTP Files](/Agent_Sudo/images/FTP_Files.png)

Using `get` command I downloaded the files to my local computer for further inspection.

# Image File Steganography

Using `zsteg` utility I analyzed `cutie.png` file and found out that there is a zip file inside the image.

![Zsteg Scan](/Agent_Sudo/images/Zsteg_Scan.png)

Using `binwalk` I was able to extract the zip file.

![Extracted Zip](/Agent_Sudo/images/Extracted_Zip.png)

The zip file is password-protected, so, using `zip2john` I prepared the file for cracking with `John the ripper`.

Using John with `rockyou` wordlist gave me the password for the zip file.

![Zip Password](/Agent_Sudo/images/Zip_Password.png)

Reading `To_agentR.txt` file shows this message:

![AgentR Message](/Agent_Sudo/images/AgentR_Message.png)

There is a base64 encoded string within the quotation marks. Decoding it gives a password to extract hidden contents within `cute-alien.jpg` picture file.

![Picture Pass](/Agent_Sudo/images/Picture_Pass.png)

Extracting this picture gives another message.

![Exctracted Picture](/Agent_Sudo/images/Extracted_Picture.png)

It gives the username and password combination for the second user.

![Second User](/Agent_Sudo/images/Second_User.png)

It is possible to use this combination to SSH into the system.

# SSH Access

When logged into the system using SSH, I found the user flag.

![User Flag](/Agent_Sudo/images/User_Flag.png)

Also there is an image file called `Alien_autopsy.jpg`.

Using `scp` I copied this file to my local machine and put it to Google image search.

![Alien Autopsy](/Agent_Sudo/images/Alien_Autopsy.png)

The first search page revealed the answer of the incident captured within the photo.

# Privillege Escalation

Getting back to the vulnerable system. Issuing a `sudo -l` command shows that the current user could run `(ALL, !root) /bin/bash` command on the machine.

Searching Google for this particular command gives the ***CVE*** number of this vulnerability.

Basically, if the user is "granted permission to execute programs as any users except root" and "has sudo privileges that allow them to run commands with an arbitrary user ID", it is possible to run `sudo -u#-1<command-goes-here>` and gain root shell on the system.

![Root Shell](/Agent_Sudo/images/Root_Shell.png)

By going to `/root` directory and reading `root.txt` file gives the root flag and the name of Agent R.

![Root Flag](/Agent_Sudo/images/Root_Flag.png)

# Conclusion

1. Port scanned the target machine.
2. Modified the user-agent to get FTP username.
3. Brute-forced password for this user with Hydra.
4. Logged-in with ftp, downloaded a couple of image files.
5. Found a zip archive file within one image.
6. Cracked the archive's password with John the Ripper.
7. Found message with a string encoded in base64.
8. Decoded the string - found password for extracting data from the second picture.
9. Within the second image file a message was found. It contained username and password of the second user.
10. I used these credentials to SSH into the system.
11. Got the user flag.
12. User could run `(ALL, !root) /bin/bash` command on the target system.
13. Found a CVE to exploit this command.
14. Using this exploit I got the root shell.
15. Obtained the root flag and the name of Agent R.

Done!
