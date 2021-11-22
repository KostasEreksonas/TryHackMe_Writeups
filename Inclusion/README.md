# Inclusion

Writeup for Inclusion room on [Tryhackme.com](https://tryhackme.com)

URL for this room is https://tryhackme.com/room/inclusion

Table of Contents
=================
* [Inclusion](#Inclusion)
* [Port Scan](#Port-Scan)
* [Webpage](#Webpage)
* [Initial Exploitation](#Initial-Exploitation)
* [Privillege Escalation](#Privillege-Escalation)

# Port Scan

First I have conducted a SYN scan using `nmap` to discover open ports on the target machine. The results are as follows:

```
# Nmap 7.60 scan initiated Mon Nov 22 10:41:13 2021 as: nmap -vv -sS -oN port_scan.txt 10.10.249.101
Nmap scan report for ip-10-10-249-101.eu-west-1.compute.internal (10.10.249.101)
Host is up, received arp-response (0.00076s latency).
Scanned at 2021-11-22 10:41:13 GMT for 2s
Not shown: 998 closed ports
Reason: 998 resets
PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 64
80/tcp open  http    syn-ack ttl 64
MAC Address: 02:B9:D7:43:FA:2B (Unknown)

Read data files from: /usr/bin/../share/nmap
# Nmap done at Mon Nov 22 10:41:15 2021 -- 1 IP address (1 host up) scanned in 1.64 seconds
```

The scan detected ssh port ***22*** and http port ***80*** as being open.

# Webpage

Navigating to the specified IP address leads to a simple Bootstrap Hello World website.

![LFI webpage](/Inclusion/images/LFI_webpage.png)

Clicking on "View details" button below LFI-attack paragraph leads to an unformatted HTML page telling about LFI attack.
It also gives a `name` parameter that could be exploited with this attack.

![LFI parameter](/Inclusion/images/LFI_parameter.png)

# Initial Exploitation

There is a SSH service running on this specific webserver. So it is necessary to search for SSH login credentials.

Doing a Path Traversal to `/etc/passwd` file gives the username of `falconfeast` and it's password.

![Username path traversal](/Inclusion/images/Username_path_traversal.png)

With this information available it is possible to log in as the falconfeast user and get the user flag.

![User flag](/Inclusion/images/User_flag.png)

# Privillege Escalation

Executing `sudo -l` command shows what processes falconfeast can run with root privilleges.

![Run as root](/Inclusion/images/Run_as_root.png)

As it can be seen from the picture above, falconfeast can run `socat` command as root.
Now going to [GTFOBins](https://gtfobins.github.io) and searching for socat gives multiple exploitation methods of the command.
For this challenge I am using reverse shell method.
Firstly, on the attacking machine I am going to set up a netcat listener on port 1234 with `nc -lvnp 1234`.

![Netcat listener](/Inclusion/images/Netcat_listener.png)

Then I am setting up a reverse shell on a target machine.

![Reverse shell](/Inclusion/images/Reverse_shell.png)

And the connection is successful!

![Successful connection](/Inclusion/images/Successful_connection.png)

Now navigate to `/root` folder and get the root flag.

![Root flag](/Inclusion/images/Root_flag.png)

Room completed!
