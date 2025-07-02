#!/usr/bin/env bash

# This script can be used to setup my dotfiles on EG servers.

# Ensure we have our github token set as an environment variable
if [[ -z "${MY_GITHUB_TOKEN}" ]]; then
    echo "MY_GITHUB_TOKEN is not set. Please set it before running this script."
    exit 1
fi
GIT_USER="rocking-e"

# Create the age key file
cat >~/age.txt <<EOF
# created: 2024-05-14T11:03:38-07:00
# public key: age1xfq3p0hnj2qlvesp88xl3ccfwdp3ex4kc5ckuj9yyp35k2tazvrq4ukdyh
AGE-SECRET-KEY-1C9T2Z8J0SR549JMZAAL056JLWS6HR6PADZGKE295WHLPT458T64QTXXCKF

EOF

# Setup to download the chezmoi binary from the cincfiles server in each environment.
cincfiles="cincfiles.$(hostname -d)"
chezmoi_url="https://${cincfiles}/teleport-packages/chezmoi-linux"
chezmoi_bin=~/bin/chezmoi
mkdir ~/bin
curl -o ${chezmoi_bin} ${chezmoi_url}
chmod +x ${chezmoi_bin}

${chezmoi_bin} init --apply --branch from-eg "https://${GIT_USER}:${MY_GITHUB_TOKEN}@github.com/${GIT_USER}/dotfiles"

chmod 600 ~/age.txt
chmod 600 ~/.ssh/config.normal

cat <<EOF | crontab -
# This cronjob is intended to keep my username cached by sssd so
# logins don't have to fetch each time, which is sllloooowwwww.
*/30 * * * *	id | sed 's/,/\n/g'

EOF
