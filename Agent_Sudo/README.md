# Agent Sudo

Writeup for [Agent Sudo](https://tryhackme.com/room/agentsudoctf) room at [TryHackMe.com](https://tryhackme.com/)
URL for Agent Sudo room is: https://tryhackme.com/room/agentsudoctf

Table of Contents
=================
* [Port Scan](#Port-Scan)
* [Webpage](#Webpage)
* [FTP Enumeration](#FTP-Enumeration)

# Port Scan

Port scan using `nmap` tool revealed ***3*** open ports.

```

```

Conducting a more in-depth scan on the open ports revealed the following information.

```

```

# Webpage

Following the given IP address gives a webpage with the following message:

![Webpage](/Agent_Sudo/images/Webpage.png)

It tells that we should use our own codename to access the site. Since this message is from the Agent ***R***, codenames should be just aplhabet letters. Let's try R first.

![Wrong Agent](/Agent_Sudo/images/Wrong_Agent.png)

We can not access the system as agent R... If we try agent C though:

![Agent Name](/Agent_Sudo/images/Agent_Name.png)

We have full name of our agent. Also, the password is weak, so it might be possible to brute-force it.

# FTP Enumeration

As we found out earlier, ftp port is open on the system. Using `hydra` I was able to 

![FTP Password](/Agent_Sudo/images/FTP_Password.png)
