# Corridor

Writeup for [Corridor](https://tryhackme.com/room/corridor) room at [Tryhackme](https://tryhackme.com/).
Corridor room can be found here: https://tryhackme.com/room/corridor

Table of Contents
=================
* [Webpage](#Webpage)
* [Hash Identification](#Hash-Identification)
* [Hash Cracking](#Hash-Cracking)
* [IDOR Vulnerability](#IDOR-Vulnerability)

# Webpage

The website shows white corridor with multiple doors.

![Main page](/Corridor/images/Main_page.png)

Clicking on a door opens a picture of a white room and the URL of this picture contains a hash.

![Open door](/Corridor/images/Open_door.png)

# Hash Identification

Downloading websites' source code with `curl` shows multiple hashes of same length.

![Found hashes](/Corridor/images/Found_hashes.png)

Now I'll save all these hashes to a file and check their type with `hash-identifier`.

![Saved hashes](/Corridor/images/Saved_hashes.png)

![Hash types](/Corridor/images/Hash_types.png)

All hashes were identified as `MD5`.

# Hash Cracking

To crack hashes, `John the Ripper` tool will be used.

![Cracked hashes](/Corridor/images/Cracked_hashes.png)

Turns out, all hashed URL endpoints are numbers from 1 to 13.

# IDOR Vulnerability

To exploit an IDOR vulnerability, let's choose a number that is different from what's already found. I'll start with 14.

I've created MD5 hash for number 14 with command `echo -n 14 | md5sum`.

![14 endpoint](/Corridor/images/14_endpoint.png)

Such page is not found. Let's create a hash for number 0.

Ading this hash to the URL gives the flag for this room!

![0 endpoint](/Corridor/images/0_endpoint.png)
