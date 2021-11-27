# Inclusion

Writeup for Scripting room on [Tryhackme.com](https://tryhackme.com)

URL for this room is https://tryhackme.com/room/scripting

Table of Contents
=================
* [Base64](#Base64)
* [Gotta Catch em All](#Gotta-Catch-em-All)
* [Encrypted Server Chit Chat](#Encrypted-Server-Chit-Chat)

# Base64

The given file has been base64 encoded 50 times. The task is to decode the string and retrieve the flag. The script is as follows:

```
#!/usr/bin/env python3

import base64

name = "b64.txt"
file = open(name)

payload = file.read()

for i in range(50):
    # Decode the string and pass it to the payload for next iteration
    result = base64.b64decode(payload)
    payload = result

file.close()
print(result)
```

The script file is located [here](/Scripting/scripts/base64_decode.py).

# Gotta Catch em All

# Encrypted Server Chit Chat
