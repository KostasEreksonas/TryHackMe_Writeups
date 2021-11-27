# ToolsRus

Writeup for [ToolsRus](https://tryhackme.com/room/zeno) room at [TryHackMe](https://tryhackme.com/).
URL for this room is: https://tryhackme.com/room/toolsrus

Table of Contents
=================
* [Directory Scanning](#Directory-Scanning)
* [Webpage Number 1](#Webpage-Number-1)
* [Password Enumeration](#Password-Enumeration)
* [Port Scan](#Port-Scan)
* [Webpage Number 2](#Webpage-Number-2)
* [Directory Scanning 2](#Directory-Scanning-2)
* [Service Exploitation](#Service-Exploitation)

# Directory Scanning

For scanning directories I have used `gobuster` tool with `directory-list-2.3-medium` wordlist.

![Found directories](/ToolsRus/images/Found_directories.png)

The scan found ***three*** directories, one of them starts with a letter ***g***.

# Webpage Number 1

Going to the main page, it tells that the ToolsRUs is down for upgrades. Although other parts of the website are still functional...

![Main page](/ToolsRus/images/Main_page.png)

Going to the found directory that starts with a letter ***g*** gives us an ***username***.

![Directory with an username](/ToolsRus/images/Directory_with_an_username.png)

The user is asked if he updated that TomCat server.

One of the previously found directories has basic authentication. We have an username, now let's find the password for it.

# Password Enumeration

To figure out the password of the found user, `hydra` tool with ***rockyou*** wordlist and ***http-get*** form was used.

![User password](/ToolsRus/images/User_password.png)

Turns out that the protected service has moved to a different port.

![Moved service](/ToolsRus/images/Moved_service.png)

# Port Scan

To search for open ports, I have used `nmap` tool. I have scanned 1000 most popular ports and found these results:

```
# Nmap 7.60 scan initiated Sat Nov 27 16:36:03 2021 as: nmap -vv -sS -oN port_scan.txt 10.10.215.91
Nmap scan report for ip-10-10-215-91.eu-west-1.compute.internal (10.10.215.91)
Host is up, received arp-response (0.0014s latency).
Scanned at 2021-11-27 16:36:03 GMT for 1s
Not shown: 996 closed ports
Reason: 996 resets
PORT     STATE SERVICE REASON
22/tcp   open  ssh     syn-ack ttl 64
80/tcp   open  http    syn-ack ttl 64
1234/tcp open  hotline syn-ack ttl 64
8009/tcp open  ajp13   syn-ack ttl 64
MAC Address: 02:1C:BC:55:C3:95 (Unknown)

Read data files from: /usr/bin/../share/nmap
# Nmap done at Sat Nov 27 16:36:04 2021 -- 1 IP address (1 host up) scanned in 1.69 seconds
```

Two of these ports serves websites. One of them we have exploited, another one is the answer ;)

# Webpage Number 2

Going to the webpage at the correct port gives us a default page for this service.

![Second service](/ToolsRus/images/Second_service.png)

# Directory Scanning 2

For scanning the second website, `nikto` tool was used with previously found user credentials.

![Nikto scan](/ToolsRus/images/Nikto_scan.png)

The scan found a few documentation files. It also found the version of Apache-Coyote.

Repeating the same scan against port ***80*** gives the server version.

![Server version](/ToolsRus/images/Server_version.png)

# Service Exploitation

For this task, I will use ***Metasploit*** framework as there are some readily available exploits for Apache services.

To get a shell on the target system, I used ***tomcat_mgr_upload*** exploit.

I set `HttpPassword`, `HttpUsername`, `RHOSTS` and `RPORT` options with previously found user credentials and a corresponding service port number.

![Metasploit exploit](/ToolsRus/images/Metasploit_exploit.png)

Running this exploit leads to an uploaded meterpreter shell on the target system.

![Successful exploit](/ToolsRus/images/Successful_exploit.png)

Issuing `getuid` command gives us name of the user, whose shell we have got the access to.

![Shell user](/ToolsRus/images/Shell_user.png)

Catting the `/root/flag.txt` file gives us the final answer of this room.

![Root flag](/ToolsRus/images/Root_flag.png)

Done!
