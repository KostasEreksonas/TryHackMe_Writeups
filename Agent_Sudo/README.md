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

# Port Scan

Port scan using `nmap` tool revealed a few open ports.

```

```

Conducting a more in-depth scan on the open ports revealed the following information.

```

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
