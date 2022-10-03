#!/bin/sh

# Usage: savehash.sh <IP>

curl http://$1 | grep alt | cut -d " " -f 11 | cut -c 4- | tr -d "=\"" >> hashes.txt
