# Pickle Rick Writeup

A writeup for Pickle Rick CTF on [TryHackMe.com](https://tryhackme.com)

URL for Pickle Rick CTF room is: https://tryhackme.com/room/picklerick

Table of Contents
=================
* [Pickle Rick Writeup](#Pickle-Rick-Writeup)
* [Directory Enumeration](#Directory-Enumeration)
* [Login Credentials](#Login-Credentials)
* [First Ingredient](#First-Ingredient)
* [Second Ingredient](#Second-Ingredient)
* [Third Ingredient](#Third-Ingredient)
* [Extra](#Extra)

# Directory Enumeration

Firstly I have conducted a `gobuster` scan against the target with `directory-list-2.3-medium` provided to it.

![Gobuster scan](/Pickle_Rick/images/Gobuster_scan.png)

The scan found an accessible `/assets` directory (status code 301).

![Assets directory](/Pickle_Rick/images/Assets_directory.png)

Then I used `nikto` tool to scan the webserver.

![Nikto scan](/Pickle_Rick/images/Nikto_scan.png)

The scan found Admin login page at `/login.php`. Also, robots.txt does not contain any disallow entries.

![Login page](/Pickle_Rick/images/Login_page.png)

The login page has a broken CSS, but login procedure works.

# Login Credentials

Inspecting the source code of the page reveals the username to login with.

![Login Username](/Pickle_Rick/images/Login_username.png)

I have tried to guess the password by entering some common values to the password field, but no luck there.

Next I decided to check the `robots.txt` file. This file contains a single string - a reference to Rick and Morty show and also the ***password*** for the previously found user.

![Robots file](/Pickle_Rick/images/Robots_file.png)

These credentials give access to `Rick Portal`.

![Rick portal](/Pickle_Rick/images/Rick_portal.png)

# First Ingredient

As of now, only Command Panel section can be accessed. This panel accepts shell commands.

Issuing `ls` command shows `Sup3rS3cretPickl3Ingred.txt` file, which gives the first ingredient.

![First ingredient](/Pickle_Rick/images/First_ingredient.png)

Note: When entering `cat` command to the Command Panel,`Command disabled` error is shown. ***Less*** command does the trick though.

There is also `clue.txt` file that tells to look around the file system for the other ingredient.

![Ingredient clue](/Pickle_Rick/images/Ingredient_clue.png)

# Second Ingredient

Looking at `/home/rick` directory a `second ingredients` file is found.

![Second ingredient](/Pickle_Rick/images/Second_ingredient.png)

Opening this file with `less` command gives the second ingredient.

![Second flag](/Pickle_Rick/images/Second_flag.png)

# Third ingredient

Lastly, it is neccessary to find the third ingredient for Rick.
One interesting directory to look at is the `/root` directory. One problem - this folder is only accessible by the root user.
For that purpose I have checked what commands the current user can run as root with `sudo -l`.

![Run permissions](/Pickle_Rick/images/Run_permissions.png)

Turns out that the current user can run ***any*** commands as root ***without*** password!

![Root listing](/Pickle_Rick/images/Root_listing.png)

Listing contents of /root shows `3rd.txt` file.

Viewing the 3rd.txt with `less` command gives the third flag.

![Third ingredient](/Pickle_Rick/images/Third_ingredient.png)

Challenge solved!

# Extra

The source code of this panel has a Base64 encoded string which, when decoded for several times, gives a two-word phrase, which I have not used in solving this CTF, but thought it was a fun thing to add.

![Rick source](/Pickle_Rick/images/Rick_source.png)
