# Overpass 3

Writeup for [Overpass 3](https://tryhackme.com/room/overpass3hosting) room on [TryHackMe.com](https://tryhackme.com/).
URL for Overpass room is: https://tryhackme.com/room/overpass3hosting

Table of Contents
=================
* [Port Scan](#Port-Scan)
* [Directory Enumeration](#Directory-Enumeration)
* [Web Application](#Web-Application)
* [Backup Analysis](#Backup-Analysis)
* [FTP Login](#FTP-Login)
* [Shell Normalization](#Shell-Normalization)
* [System Enumeration](#System-Enumeration)
* [NFS Exploit](#NFS-Exploit)
	* [SSH Port Forwarding](#SSH-Port-Forwarding)
	* [NFS Mount](#NFS-Mount)
* [Privillege Escalation](#Privillege-Escalation)

# Port Scan

Using `nmap` I was able to identify ports ***21***, ***22*** and ***80*** as open.

```
# Nmap 7.92 scan initiated Wed Jan 19 12:36:24 2022 as: nmap -vv -sS -oN Initial_scan.txt 10.10.69.92
Nmap scan report for 10.10.69.92
Host is up, received echo-reply ttl 63 (0.17s latency).
Scanned at 2022-01-19 12:36:25 EST for 12s
Not shown: 980 filtered tcp ports (no-response), 17 filtered tcp ports (admin-prohibited)
PORT   STATE SERVICE REASON
21/tcp open  ftp     syn-ack ttl 63
22/tcp open  ssh     syn-ack ttl 63
80/tcp open  http    syn-ack ttl 63

Read data files from: /usr/bin/../share/nmap
# Nmap done at Wed Jan 19 12:36:37 2022 -- 1 IP address (1 host up) scanned in 12.91 seconds
```

A detailed nmap scan revealed some more information about the target's open ports.

```
# Nmap 7.92 scan initiated Wed Jan 19 12:39:00 2022 as: nmap -vv -sS -sV -sC -O -oN open_ports.txt -p 21,22,80 10.10.69.92
Nmap scan report for 10.10.69.92
Host is up, received echo-reply ttl 63 (0.071s latency).
Scanned at 2022-01-19 12:39:00 EST for 16s

PORT   STATE SERVICE REASON         VERSION
21/tcp open  ftp     syn-ack ttl 63 vsftpd 3.0.3
22/tcp open  ssh     syn-ack ttl 63 OpenSSH 8.0 (protocol 2.0)
| ssh-hostkey: 
|   3072 de:5b:0e:b5:40:aa:43:4d:2a:83:31:14:20:77:9c:a1 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfSHQR3OtIeAUFx18phN/nfAIQ2uGHuJs0epoqF184E4Xr8fkjSFJHdA6GsVyGUjdlPqylT8Lpa+UhSSegb8sm1So8Nz42bthsftsOxMQVb/tpQzMUfjcxQOiyVmgxfEqs2Zzdv6GtxwgZWhKHt7T369ejxnVrZhn0m6jzQNfRhVoQe/jC20RKvBf8l8s6/SusbZR5SFfsg71KyrSKOXOxs12GhXkdbP32K3sXVEpWgfCfmIZAc2ZxNtL5uPCM4AOfjIFJHl1z9EX04ZjQ1rMzzOh9pD/b+W2mXt2nQGzRPnc8LyGDE0hFtw4+lBCoiH8zIt14S7dwbFFV1mWxbtZXVf7JhPiZDM2vBfqyowsDZ5oc2qyR+JEU4pqeVhRygs41isej/el19G8+ehz4W07KR97eM2omB25JehO7E4tpX1l8Imjs1XjqhhVuGE2tru/p62SRQOKzRZ19MCIFPxleSLorrHq/uuKdvd8j6rm0A9BrCsiB6gmPfal6Kr55vlU=
|   256 f4:b5:a6:60:f4:d1:bf:e2:85:2e:2e:7e:5f:4c:ce:38 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAPAji9Nkb2U9TeP47Pz7BEa943WGOeu5XrRrTV0+CS0eGfNQyZkK6ZICNdeov65c2NWFPFsZTFjO8Sg+e2n/lM=
|   256 29:e6:61:09:ed:8a:88:2b:55:74:f2:b7:33:ae:df:c8 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/U6Td7C0nC8tiqS0Eejd+gQ3rjSyQW2DvcN0eoMFLS
80/tcp open  http    syn-ack ttl 63 Apache httpd 2.4.37 ((centos))
|_http-server-header: Apache/2.4.37 (centos)
|_http-title: Overpass Hosting
| http-methods: 
|   Supported Methods: OPTIONS HEAD GET POST TRACE
|_  Potentially risky methods: TRACE
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Linux 3.10 - 3.13 (92%), Crestron XPanel control system (90%), ASUS RT-N56U WAP (Linux 3.4) (87%), Linux 3.1 (87%), Linux 3.16 (87%), Linux 3.2 (87%), HP P2000 G3 NAS device (87%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (87%), Linux 5.4 (86%), Linux 2.6.32 (86%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.92%E=4%D=1/19%OT=21%CT=%CU=%PV=Y%G=N%TM=61E84CC4%P=x86_64-pc-linux-gnu)
SEQ(SP=103%GCD=1%ISR=10E%TI=Z%II=I%TS=A)
SEQ(SP=103%GCD=1%ISR=10E%TI=Z%TS=A)
OPS(O1=M505ST11NW6%O2=M505ST11NW6%O3=M505NNT11NW6%O4=M505ST11NW6%O5=M505ST11NW6%O6=M505ST11)
WIN(W1=68DF%W2=68DF%W3=68DF%W4=68DF%W5=68DF%W6=68DF)
ECN(R=Y%DF=Y%TG=40%W=6903%O=M505NNSNW6%CC=Y%Q=)
T1(R=Y%DF=Y%TG=40%S=O%A=S+%F=AS%RD=0%Q=)
T2(R=N)
T3(R=N)
T4(R=Y%DF=Y%TG=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)
U1(R=N)
IE(R=Y%DFI=N%TG=40%CD=S)

Uptime guess: 18.691 days (since Fri Dec 31 20:04:05 2021)
TCP Sequence Prediction: Difficulty=259 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Unix

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Jan 19 12:39:16 2022 -- 1 IP address (1 host up) scanned in 16.16 seconds
```

# Directory Enumeration

Enumerating directories with `gobuster` showed some potentially interesting directories.

![Directory Enumeration](/Overpass3/images/Directory_Enumeration.png)

# Web Appliaction

Following the given IP address gives a homepage of Overpass hosting.

![Webpage Index](/Overpass3/images/Webpage_Index.png)

There also is a `backups` directory containing a zip file.

![Backups Directory](/Overpass3/images/Backups.png)

# Backup Analysis

The zip file contails encrypted `CustomerDetails.xlsx.gpg` file alongside with the private key for decryption.

![Zip Contents](/Overpass3/images/Zip_Contents.png)

I have imported the GPG private key with `gpg --import priv.key` command and then decrypted the spreadsheet file with GPG.

![Decrypted](/Overpass3/images/Decrypted.png)

This spreadsheet file contains ***3*** customers and their account details, including usernames and passwords.

![Spreadsheet](/Overpass3/images/Spreadsheet.png)

# FTP Login

Using one of the user's credentials I was able to log into the server via FTP. The FTP directory gave access to the files of Overpass webpage and the same backup.zip file that is already found.

![FTP Login](/Overpass3/images/FTP_Login.png)

From the directory listing it could be told that this webserver directory is writable by me. Which means that I can upload it there, execute it from the webpage and get a reverse shell running on my system.

First I set up a netcat listener.

![Netcat Listener](/Overpass3/images/Netcat_Listener.png)

Then I upload the PHP reverse shell to the webserver via FTP.

![Reverse Shell Upload](/Overpass3/images/Reverse_Shell_Upload.png)

Then I enter the full path to the reverse shell into the browser and get the connection to the target on my listener.

![Successful Access](/Overpass3/images/Successful_Access.png)

Using `find` command I was able to figure out that the ***web flag*** is in `/usr/share/httpd/web.flag` directory.

![Web Flag](/Overpass3/images/Web_Flag.png)

# Shell Normalization


# System Enumeration

`/home` directory listing shows that users `james` and `paradox` are on the system. Since I have the password for paradox, I tried to switch to paradox user and it was successful.

Using FTP, I put `Linpeas` to the target's webserver directory.

![Linpeas Upload](/Overpass3/images/Linpeas_Upload.png)

Copied Linpeas to `/tmp` directory and executed it.

Linpeas scan shows that the user `james` has an insecure NFS configuration.

```
[i] https://book.hacktricks.xyz/linux-unix/privilege-escalation/nfs-no_root_squash-misconfiguration-pe
/home/james *(rw,fsid=0,sync,no_root_squash,insecure)
```

The given link shows exploitation steps.

# NFS Exploit

Issuing `showmount` command on my local machine shows that I am unable to access the share on the target machine.

![NFS Mount](/Overpass3/images/NFS_Mount.png)

This means that the share can only be accessed locally as user `james`. For that ***SSH port forwarding*** will be used.

## SSH Port Forwarding

Firstly, I will create a SSH key on my local machine with `ssh-keygen`.

![SSH Key Creation](/Overpass3/images/SSH_Key_Creation.png)

Then I will copy the output of `paradox.pub` to the directory `authorized_keys` on  ***remote machine***

```
(remote machine)
echo <paradox.pub output here> >> /home/paradox/.ssh/authorized_keys
```

In the next step, open a new terminal and SSH into the remote system.

![SSH Login](/Overpass3/images/SSH_Login.png)

Then check which ports are used for listening to NFS connections with `rpcinfo -p` command.

![RPC Info](/Overpass3/images/RPC_Info.png)

Now it is time for actual port forwarding. By using the `-L` flag I will bind the NFS port to my SSH connection, so that all the traffic sent to the SSH daemon would be redirected to the NFS, enabling me to access the share.

![Port Forwarding](/Overpass3/images/Port_Forwarding.png)

## NFS Mount

Now I will open a new terminal on my ***local*** machine and create a folder to mount NFS share.

After the share is mounted, I will ***copy*** the `paradox.pub` file to the ***share's*** `.ssh/authorized_keys` folder and SSH into the target as james.


![Login As James](/Overpass3/images/Login_As_James.png)

After mounting the share, I can read the user flag.

![Login As James](/Overpass3/images/Login_As_James.png)

# Privillege Escalation

For privillege escalation, on the remote machine I will copy the `/bin/bash` executable to the james' home folder.

Then I will open a new terminal and on my local machine I will head to nfs directory and change both ownership and permissions of the bash executable.

![Bash Permissions](/Overpass3/images/Bash_Permissions.png)

Lastly, I will execute `./bash -p` on the remote machine as james. And it gives the root shell.

![Root Shell](/Overpass3/images/Root_Shell.png)

Now heading to `/root` directory and reading the `root.flag` file gives the root flag.

![Root Flag](/Overpass3/images/Root_Flag.png)

Done!
