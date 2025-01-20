# Gallery

Writeup for [Lo-Fi](https://tryhackme.com/r/room/lofi) room at [TryHackMe.com](https://tryhackme.com/)
URL for Gallery room is: https://tryhackme.com/r/room/lofi

Table of Contents
=================
* [Webpage](#Webpage)
* [Local_File_Inclusion](#Local-File-Inclusion)
* [Conclusion](#Conclusion)

# Webpage

The website shows a Youtube video of the LoFi girl

![Webpage](/LoFi/images/Webpage.png)

If a page from the discography menu is selected, an URL parameter called "page" can be seen

![Relax](/LoFi/images/Relax.png)

# Local File Inclusion

Firstly, let's test for a simple LFI (as per [OWASP LFI testing guide](https://owasp.org/www-project-web-security-testing-guide/v42/4-Web_Application_Security_Testing/07-Input_Validation_Testing/11.1-Testing_for_Local_File_Inclusion)) and try to read `/etc/passwd` file:

![LFI](/LoFi/images/LFI.png)

The screenshot above shows that LFI, in fact, works.

Now let's try to access `flag.txt` the same way.

![Flag](/LoFi/images/Flag.png)

Success!

# Conclusion

In this room, we have tested for a simple Local File Inclusion by including local files in an URL parameter
