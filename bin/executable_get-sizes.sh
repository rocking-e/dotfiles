#!/usr/bin/env bash

# Do "du -s" on all files in directory where executed.

/bin/ls -a | sed -e '/^\.\.*$/d' | while read i; do
    if [[ ! -d "$i" ]]; then continue; fi
    du -s "$i"
done | sort -n
