# Road Writeup

A writeup for [Road](https://tryhackme.com/room/road) room on [TryHackMe.com](https://tryhackme.com)

URL for Road room is: https://tryhackme.com/room/road

Table of Contents
=================
* [Port Scan](#Port-Scan)
* [Webpage](#Webpage)
* [Directory Enumeration](#Directory-Enumeration)
* [Admin Account](#Admin-Account)
* [Initial Foothold](#Initial-Foothold)
* [Privillege Escalation](#Privillege-Escalation)
* [Summary](#Summary)

# Port scan

For port scanning, I have used `nmap` tool and scanned 1000 most common TCP ports.

```
# Nmap 7.92 scan initiated Fri Dec 10 02:49:13 2021 as: nmap -vv -sS -oN port_scan.txt 10.10.80.118
Nmap scan report for 10.10.80.118
Host is up, received echo-reply ttl 63 (0.076s latency).
Scanned at 2021-12-10 02:49:14 EST for 2s
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 63
80/tcp open  http    syn-ack ttl 63

Read data files from: /usr/bin/../share/nmap
# Nmap done at Fri Dec 10 02:49:16 2021 -- 1 IP address (1 host up) scanned in 2.31 seconds
```

The scan identified ports 22 and 80 as open, indicating that the server has ***ssh*** and ***http*** services running.

A more throughout scan on these two ports gave the following results:

```
# Nmap 7.92 scan initiated Fri Dec 10 02:50:12 2021 as: nmap -vv -sS -A -oN open_ports.txt -p 22,80 10.10.80.118
Nmap scan report for 10.10.80.118
Host is up, received reset ttl 63 (0.068s latency).
Scanned at 2021-12-10 02:50:13 EST for 14s

PORT   STATE SERVICE REASON         VERSION
22/tcp open  ssh     syn-ack ttl 63 OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 e6:dc:88:69:de:a1:73:8e:84:5b:a1:3e:27:9f:07:24 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXhjztNjrxAn+QfSDb6ugzjCwso/WiGgq/BGXMrbqex9u5Nu1CKWtv7xiQpO84MsC2li6UkIAhWSMO0F//9odK1aRpPbH97e1ogBENN6YBP0s2z27aMwKh5UMyrzo5R42an3r6K+1x8lfrmW8VOOrvR4pZg9Mo+XNR/YU88P3XWq22DNPJqwtB3q4Sw6M/nxxUjd01kcbjwd1d9G+nuDNraYkA2T/OTHfp/xbhet9K6ccFHoi+A8r6aL0GV/qqW2pm4NdfgwKxM73VQzyolkG/+DFkZc+RCH73dYLEfVjMjTbZTA+19Zd2hlPJVtay+vOZr1qJ9ZUDawU7rEJgJ4hHDqlVjxX9Yv9SfFsw+Y0iwBfb9IMmevI3osNG6+2bChAtI2nUJv0g87I31fCbU5+NF8VkaGLz/sZrj5xFvyrjOpRnJW3djQKhk/Avfs2wkZ+GiyxBOZLetSDFvTAARmqaRqW9sjHl7w4w1+pkJ+dkeRsvSQlqw+AFX0MqFxzDF7M=
|   256 6b:ea:18:5d:8d:c7:9e:9a:01:2c:dd:50:c5:f8:c8:05 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNBLTibnpRB37eKji7C50xC9ujq7UyiFQSHondvOZOF7fZHPDn3L+wgNXEQ0wei6gzQfiZJmjQ5vQ88vEmCZzBI=
|   256 ef:06:d7:e4:b1:65:15:6e:94:62:cc:dd:f0:8a:1a:24 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPv3g1IqvC7ol2xMww1gHLeYkyUIe8iKtEBXznpO25Ja
80/tcp open  http    syn-ack ttl 63 Apache httpd 2.4.41 ((Ubuntu))
| http-methods: 
|_  Supported Methods: GET POST OPTIONS HEAD
|_http-favicon: Unknown favicon MD5: FB0AA7D49532DA9D0006BA5595806138
|_http-title: Sky Couriers
|_http-server-header: Apache/2.4.41 (Ubuntu)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Adtran 424RG FTTH gateway (92%), Linux 2.6.32 (92%), Linux 2.6.39 - 3.2 (92%), Linux 3.1 - 3.2 (92%), Linux 3.2 - 4.9 (92%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.92%E=4%D=12/10%OT=22%CT=%CU=41976%PV=Y%DS=2%DC=T%G=N%TM=61B306C3%P=x86_64-pc-linux-gnu)
SEQ(SP=105%GCD=1%ISR=109%TI=Z%CI=Z%II=I%TS=A)
SEQ(SP=105%GCD=1%ISR=109%TI=Z%CI=Z%TS=A)
OPS(O1=M505ST11NW7%O2=M505ST11NW7%O3=M505NNT11NW7%O4=M505ST11NW7%O5=M505ST11NW7%O6=M505ST11)
WIN(W1=F4B3%W2=F4B3%W3=F4B3%W4=F4B3%W5=F4B3%W6=F4B3)
ECN(R=Y%DF=Y%T=40%W=F507%O=M505NNSNW7%CC=Y%Q=)
T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)
T2(R=N)
T3(R=N)
T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)
IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 25.569 days (since Sun Nov 14 13:11:28 2021)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=261 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 443/tcp)
HOP RTT      ADDRESS
1   71.13 ms 10.9.0.1
2   71.78 ms 10.10.80.118

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Dec 10 02:50:27 2021 -- 1 IP address (1 host up) scanned in 15.81 seconds
```

# Directory Enumeration

Using `gobuster` tool I have enumerated the directories of the server.

![Directory Enumeration](/Road/images/Directory_Enumeration.png)

The scan found a couple of directories within the server. One shows files in the server, the other gives a login form.

# Webpage

Opening the webpage with Firefox, "Sky Couriers" webpage is shown.

![Webpage](/Road/images/Webpage.png)

Searching for some random string in "Track Order" field redirects to an URL Not Found error and shows a couple of SQL parameters within the URL that might be injectable.

![Order Tracking](/Road/images/Order_Tracking.png)

I have tried some Union-based SQLi payloads with no luck. So, I will leave that for a moment now and go to the login page.

![Login Page](/Road/images/Login_Page.png)

This login page is placed at the `admin` subdirectory, although the directory listing for it is disabled.

![Admin Listing](/Road/images/Admin_Listing.png)

Then there is a registration form. Entering some random data and a mobile number of exactly 10 digits, I have created an account.

![Registration Form](/Road/images/Registration_Form.png)

Logging in with the previously created credentials gave me a dashboard.

![Dashboard](/Road/images/Dashboard.png)

# Admin Account

Looking around my newly created ***profile*** page and searching for any clickable buttons, it is possible to find an admin email address.

![Profile Page](/Road/images/Profile_Page.png)

Next there is an user password reset page.

![Password Reset](/Road/images/Password_Reset.png)

The field for changing the username is greyed out, so it is not possible to input the admin email address into a password reset form and chamge it's password from the webpage itself. To bypass this, I will capture the password reset request with ***Burpsuite*** and change the username to `admin@sky.thm` before sending the request to the server.

![Burp Capture](/Road/images/Burp_Capture.png)

The server responds with a message that the password was changed!

![Burp Response](/Road/images/Burp_Response.png)

Now let's login to the page as admin.

![Admin Dashboard](/Road/images/Admin_Dashboard.png)

Success!

# Initial foothold

Admin user ***can*** upload image files to the server. This functionality could also be used to upload a reverse shell into the server.

Scrolling through the source code of the web application, the file upload directory can be found.

![Upload Location](/Road/images/Upload_Location.png)

I have taken the PHP reverse shell script from [Pentestmonkey Github page](https://github.com/pentestmonkey/php-reverse-shell) and changed the IP address for the reverse shell to connect to my Kali machine.

The webpage apparently has no extension filter as I successfully uploaded the `.php` file as is.

Then I set up a netcat listener.

![Netcat Listener](/Road/images/Netcat_Listener.png)

Then I opened the URL for the uploaded reverse shell.

![Captured Shell](/Road/images/Captured_Shell.png)

Now I have a shell access!

Going to the `/home/webdeveloper` directory and reading the `user.txt` file gives the user flag.

![User Flag](/Road/images/User_Flag.png)

# Privillege Escalation

Now it is known that the server has an user called `webdeveloper`.

I have tried to brute force the SSH password for this user with ***Hydra***, but after a few minutes of no results I have decided to stop that.

Next I have tried to look at what processes are running on the server with `ps -ef` command.

![Running Processes](/Road/images/Running_Processes.png)

The server has both `mongodb` and `mysql` database processes running.

Issuing `mongo` command starts an instance of MongoDB shell.

The are four databases, the one named ***backup*** has `collection` and `user` collections. Inside the user collection there are login credentials for the user `webdeveloper`.

![User Credentials](/Road/images/User_Credentials.png)

Now trying to SSH into the server with found credential gives a `webdeveloper` shell access to the system.

![Server SSH](/Road/images/Server_SSH.png)

Issuing `sudo -l` command shows that `sky_backup_utility` can be run as root without providing root password. Although this utility cannot be really used for privesc.

![Vulnerable Service](/Road/images/Vulnerable_Service.png)

Although checking of what groups the user `webdeveloper` is a member of shows that this user is in a `sudo` group, which means that another possible attack vector is `pkexec` command, which allows an authorized user to execute a specific program as another user.

![Webdeveloper Groups](/Road/images/Webdeveloper_Groups.png)

One problem is that pkexec has a bug that [makes it fail in a non-graphical environment](https://bugs.launchpad.net/ubuntu/+source/policykit-1/+bug/1821415)

![Pkexec Bug](/Road/images/Pkexec_Bug.png)

The solution is to open second terminal, SSH into webserver as the same `webdeveloper` user, pass the `pkttyagent` authentication process PID from first to the second terminal and, when authentication in the second terminal is complete, `root` shell spawns in the first terminal.

![Pkexec Workaround](/Road/images/Pkexec_Workaround.png)

Now it is possible to change the directory to `root` and cat the flag in `root.txt`.

![Root Flag](/Road/images/Root_Flag.png)

# Summary

1. Port scanning of the webserver identifies ports ***22*** and ***80*** as open.
2. Searching for order in search field at the homepage redirects to the URL with a couple of SQL parameters.
3. None of these parameters seems to be vulnerable to SQLi.
4. Directory enumeration showes the location for a login form.
5. Registering a new account and logging in with these credentials gives a webpage dashboard.
6. Going to the profile section shows an administrator emali address.
7. Capturing a password change request with Burpsuite and changing email address to admin@sky.thm allows to change admins password.
8. Logging in as Administrator allows to upload files to the webserver.
9. Source code analysis reveals location, where uploaded files are stored.
10. No file extension filter in place, as the `.php` file could be uploaded as is.
11. Setting up a netcat listener and going to the uploaded reverse shell allows to gain shell access to the server.
12. Reading `/home/webdeveloper/user.txt` file shows the first flag.
13. MongoDB service is running on the server. Searching for collections within mongodb reveals `webeveloper` user credentials for SSH.
14. Using `pkexec` command and working around the bug with two instances of terminals connected to webdeveloper user via SSH gives root shell.
15. Root flag is in the `/root` directory.

Done!
