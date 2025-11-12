#!/usr/bin/env bash

p=".ssh/private"
old="${p}/davide-rsa ${p}/new-davide"
keys="${p}/davide_4096 .ssh/techops-ssh-key .ssh/hci-sysops-cts"
keys="${p}/davide_4096 .ssh/hci-sysops-cts"
keys="${p}/davide_4096 .ssh/hci-sysops-cts ${p}/tec-management"

cd ~
for key in ${keys}; do
    ssh-add $key
done

ssh-add -l
