#!/bin/sh

read -p "Enter a string to hash: " input
echo -n $input | md5sum
