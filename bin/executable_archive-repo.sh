#!/usr/bin/env bash

# A script to tar up a git repository directory and store it in an
# "archive" directory.

: ${ArchiveDir:=~/OneDrive\ -\ Expedia\ Group/Archives}
: ${TAR:=gtar}

if [[ $# == 0 ]]; then
    # if current directory is a git repo, archive this dir
    if [[ -f .git/config ]]; then
	repo_name=$(basename $PWD)
	repo_dir=$(PWD)
    fi
else
    if [[ ! -f $1/.git/config ]]; then
	echo "Given name does not appear to be git repo: $1"
	exit 3
    fi
    repo_dir="$1"
    repo_name=$(basename $repo_dir)
 fi
TS=$(/bin/date -u "+%Y%m%d-%H%M")
${TAR} -C ${repo_dir} -zf "${ArchiveDir}/${repo_name}-${TS}.tgz" -c .
