#!/usr/bin/env bash

# Do backups

: ${BackupDir:=/Volumes/DavidE_3/backups}
: ${HostDir:=$(hostname -s)}
: ${DestDir:=${BackupDir}/${HostDir}}
: ${FilesFrom:=${DestDir}.list}
: ${ExcludeFrom:=${DestDir}.excludes
: ${DEBUG:=""}

cd $HOME

rsync ${DEBUG} -va --exclude-from=${ExcludeFrom} . ${DestDir}/

