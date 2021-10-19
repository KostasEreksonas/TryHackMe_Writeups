# IDE
This writeup is intended for IDE room in [TryHackMe](https://tryhackme.com).

Table of Contents
=================
* [URL](#URL)
* [Introduction](#Introduction)
	* [Port scan](#Port-scan)
	* [Further port scan](#Further-port-scan)
* [FTP login](#FTP-login)
* [Password cracking](#Password-cracking)
* [HTTP login](#HTTP-login)
* [Exploiting HTTP server](#Exploiting-HTTP-server)

# URL
URL to the IDE room is: https://tryhackme.com/room/ide

# Introduction
IDE is an easy difficulty box intended for further developing enumeration skills.
The task is to gain shell access on the box and escalate privilleges.

## Port scan
I started this room with simple port scan using `nmap`. The command I have used was `sudo nmap -vv -sS -oN -p- initial_scan.txt IP`. Explanation of the used flags is presented below:
```
sudo - gives nmap root privilleges.
-vv - verbosity. Prints out more information about what the nmap scan is doing.
-sS - SYN (stealth) scan. Checks the status of ports by initiating TCP connections but never completing them.
-p- - specify ports to be scanned. Hyphen (-) indicates to scan all 65535 ports.
-oN - normal output is redirected to a given filename (in this case - initial_scan.txt).
IP - IP address of the target machine.
```
Finished scan found ***4*** open TCP ports. These ports are: ***21***, ***22***, ***80*** and ***62337***.

## Further port scan
Now let's do a more throughout scan of these ports with the command `nmap -vv -A -p 21,22,80,62337 -oN open_ports.txt IP`. Expanation for this command is presented below:
```
-vv - verbosity. Prints out more information about what the nmap scan is doing.
-A - aggresive scan options. Enables OS edection (-O), version scanning (-sV), script scanning (-sC) and traceroute (--traceroute) flags.
-p - specify ports to scan.
-oN - normal output is redirected to a given filename (in this case - open_ports.txt).
IP - IP address of the target machine.
```
This scan gave more information about the ports open and services running on top of them. Let's take a look at the newly found information:
1. Port `21` is running FTP service and it's version `vsftpd 3.0.3`.
	a. ftp-anon script scan results indicates that Anonymous FTP login is allowed.
2. Port `22` is running SSH service.
3. Port `80` is running Apache HTTP service.
4. Port `62337` is running another HTTP service.
	a. http-title of this server is Codiad 2.8.4. This specific version of Codiad has a vulnerability which allows Remote Code Execution (RCE) attacks and is a possible attack vector for privillege escalation on this system.

# FTP login
Next I will try anonymous login to the FTP service. The command for connecting to the FTP server is `ftp IP`, where `IP` is IP address of the target machine. When prompted for Username, type `anonymous` and leave the Password field empty.
When I had logged in to the FTP server, strangely I found no files in here. So I have used the `ls -lah` command for more information and found ***three*** directories here:
1. `.` and `..` are standard directories on UNIX-like operating systems.
2. `...` is ***not*** a standard directory.
I went to this directory with `cd` command and found a `-` file, which I have downloaded to host machine with FTP's `GET` command.
Then I have changed the name of the file from `-` to a `file` and gave it a `.txt` extension.
After that I have opened the file with a text editor and found a message in here:
```
Hey john,
I have reset the password as you have asked. Please use the default password to login.
Also, please take care of the image file ;)
- drac.
```
This gives us the name of the user `john`. Also, it says that the password for user `john` has been reset and is set to default. Likely, this is the user of the webserver at port `62337`. Well, if the user has default password, it should not be hard to crack it.

# Password cracking.
For this I have used the tool `hydra`. The full command for this task was `hydra -t 4 -l john -P /usr/share/wordlists/rockyou.txt -vV IP http -s PORT`. A throughout explanation is presented below:
```
-t - number of concurrent connections (in this case - 4).
-l - username for which we want to crack the password.
-P - specify location of the wordlist we want to use for cracking the password.
-vV - verbosity level. Printing out every attempt of username and password matching.
IP - IP address of the target.
http - specify type of the service that the target user is using (in this case - http).
-s - specify port of this service (if it is not standard).
```
The scan finished quickly and the password for the user `john` is, well, just `password`.

# HTTP login
So I have logged into the server via `Firefox` browser with the username `john` and password `password` and it opens an web-based ***Codiad 2.8.4*** administration panel with some python scripts. Based on the scripts, this server is used for controlling IP cameras and is the one we need to gain shell access to.

# Exploiting HTTP server
The specific Codiad version used in this box has a well described remote shell upload vulnerability. That is the exploit I will be using to gain shell access to the box.
