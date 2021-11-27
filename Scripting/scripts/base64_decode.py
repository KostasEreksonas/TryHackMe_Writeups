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
