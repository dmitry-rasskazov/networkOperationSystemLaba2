#!/usr/bin/env bash

export LANG=c

expectedDate="January 01"
currentDate=$(date +"%B %d")

if [[ "$expectedDate" = "$currentDate" ]]; then
	set $(who | grep -oE "tty[0-9]*|pts/[0-9]*" | grep -o "[0-9]*")
	for paramNumber; do cat Message.txt > "/dev/pts/$paramNumber"; done
fi
