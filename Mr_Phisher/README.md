# Mr. Phisher

Writeup for [Mr. Phisher](https://tryhackme.com/room/mrphisher) room at [TryHackMe.com](https://tryhackme.com/)
URL for Mr. Phisher room is: https://tryhackme.com/room/mrphisher

Table of Contents
=================
* [Malicious Document](#Malicious-Document)

# Malicious Document

A suspicous email with weird looking attachment was received. When opening the document, it asks to enable macros.

![Mr Phisher](/Mr_Phisher/images/Mr_Phisher.png)

The document shows this one image.

![Open Document](/Mr_Phisher/images/Open_Document.png)

Now, to view and edit macros using Libre Office, go to Tools menu, choose Macros > Organize Macros > Base. This opens a list of macros available in the currently open document.

![Macro List](/Mr_Phisher/images/Macro_List.png)

The malicious macro is located under MrPhisher.com > Projet > Modules > NewMacros

![Malicious Macro](/Mr_Phisher/images/Malicious_Macro.png)

When I tried tried running the macro, I got this error message, saying that for security reasons, I could not run the macro.

![Run Macro](/Mr_Phisher/images/Run_Macro.png)

This macro contains a Visual Basic script.

![Malicious Code](/Mr_Phisher/images/Malicious_Code.png)

The code can be viewed [here](/Mr_Phisher/code/VBScript.vbs) and down below.

```
Rem Attribute VBA_ModuleType=VBAModule
Option VBASupport 1

Sub Format()

Dim a()

Dim b As String

a = Array(102, 109, 99, 100, 127, 100, 53, 62, 105, 57, 61, 106, 62, 62, 55, 110, 113, 114, 118, 39, 36, 118, 47, 35, 32, 125, 34, 46, 46, 124, 43, 124, 25, 71, 26, 71, 21, 88)

For i = 0 To UBound(a)

b = b & Chr(a(i) Xor i)

Next

End Sub
```

Three things are done here:
1. XOR operation is done with a value and it's index in the array.
2. The result of this operation is converted to a character.
3. This character is appended to a string. The resulting string is a flag for this challenge.

I wrote a Python script to solve this challenge. The code can be found [here](/Mr_Phisher/code/xor.py) and down below.

```
#! /usr/bin/env python3

# Values array
a = [102, 109, 99, 100, 127, 100, 53, 62, 105, 57, 61, 106, 62, 62, 55, 110, 113, 114, 118, 39, 36, 118, 47, 35, 32, 125, 34, 46, 46, 124, 43, 124, 25, 71, 26, 71, 21, 88]

# Array to store letters
flag = []

# Do XOR operation with a value and it's index
for i in range(len(a)):
    flag.append(chr(a[i] ^ int(i)))

# Join letters to a word
print("".join(flag))
```

Done!
