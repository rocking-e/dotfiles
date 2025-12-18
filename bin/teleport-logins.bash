#!/usr/bin/env bash
# shellcheck disable=SC2223,SC2034

# A script that must be "sourced" and not executed. Why? Because it needs to
# define 2 functions in the calling shell. One function is the command that will
# invoke 'tsh login' with the correct cluster name. The other function
# is the bash command completion function for the teleport login
# function.

# This script also requires the path to the ssh config file that
# declares the various Teleport clusters. The section for each cluster
# must start with '#TP#'. The "Host" and "HostName" lines will be used
# for completion. By default the config file is
# ~/.ssh/teleport_config. That can be changed by setting the
# environment variable "TELEPORT_SSH_CONFIG"

# The username for the 'tsh login' can be specified via the
# TELEPORT_LOGIN environment variable.

# The teleport-login function 
# The be-aws function requires 2 arguments. The first is the name of a profile
# that is defined user's ~/.aws/credentials. The other is the region or the
# approved/coded region abbreviates. The script accepts "east" to mean
# us-east-1 and "west" to mean us-west-2. It also accepts "ap" to be
# ap-southeast-1 and "eu" to be eu-west-1.

(return 0 2>/dev/null) && sourced=1 || sourced=0
if [[ $sourced = 0 ]]; then
    echo >&2 "This script must not be executed. It must be 'sourced'"
    exit 99
fi

: ${TELEPORT_SSH_CONFIG:=${HOME}/.ssh/teleport_config}

if [[ ! -f ${TELEPORT_SSH_CONFIG} ]]; then
    echo "File not found: ${TELEPORT_SSH_CONFIG}"
    echo "That file must exist for this function to work properly"
    return 2
fi

teleport-login () {
    if [[ $# = 0 ]]; then
        echo "usage $0 teleport-cluster-host"
        return 1
    fi
    case "$1" in
    runtime-test-east)
        tp_host=teleport.us-east-1.runtime.test.exp-aws.net
        ;;
    runtime-test-west)
        tp_host=teleport.us-west-2.runtime.test.exp-aws.net
        ;;
    runtimects-test-east)
        tp_host=teleport.us-east-1.runtime.test-cts.exp-aws.net
        ;;
    runtimects-test-west)
        tp_host=teleport.us-west-2.runtime.test-cts.exp-aws.net
        ;;
    runtimects-prod-east)
        tp_host=teleport.us-east-1.runtime.prod-cts.exp-aws.net
        ;;
    runtimects-prod-west)
        tp_host=teleport.us-west-2.runtime.prod-cts.exp-aws.net
        ;;
    runtimects-prod-eu-west)
        tp_host=teleport.eu-west-1.runtime.prod-cts.exp-aws.net
        ;;
    runtimects-prod-ap-southeast)
        tp_host=teleport.ap-southeast-1.runtime.prod-cts.exp-aws.net
        ;;
    runtimecde-prod-east)
        tp_host=teleport.us-east-1.runtime.prod-cde.exp-aws.net
        ;;
    runtimecde-prod-west)
        tp_host=teleport.us-west-2.runtime.prod-cde.exp-aws.net
        ;;
    runtimecde-prod-eu-west)
        tp_host=teleport.eu-west-1.runtime.prod-cde.exp-aws.net
        ;;
    ecp|ecpcpcloudaccount)
        tp_host=teleport.us-east-1.ecpcpcloudaccount.test.exp-aws.net
        ;;
    hicore-sandbox)
        tp_host=teleport.us-west-2.hicore-sandbox.test.exp-aws.net
        ;;
    *)
        tp_host="$1"
        ;;
    esac
    if ! grep --quiet "HostName ${tp_host}" "${TELEPORT_SSH_CONFIG}"; then
        echo "Host ${tp_host} not found in config file"
        return 3
    fi

    tsh login --proxy="$tp_host"
}

_teleport-login-completions () {
    local tphosts
    tphosts=$(grep -A 10 '^#TP#' "${TELEPORT_SSH_CONFIG}" |
          awk '/HostName t/{print $2} /Host /{print $2}')
    tphosts="${tphosts} hicore-sandbox ecp ecpcpcloudaccount"
    COMPREPLY=($(compgen -W "$tphosts" -- "${COMP_WORDS[1]}"))
} &&
    complete -F _teleport-login-completions teleport-login

tl () {
    teleport-login "$@"
} && complete -F _teleport-login-completions tl

teleport-logout () {
    if [[ $# = 0 ]]; then
        echo "usage $0 teleport-cluster-host"
        return 1
    fi
     
    if ! grep --quiet "HostName ${tp_host}" "${TELEPORT_SSH_CONFIG}"; then
        echo "Host ${tp_host} not found in config file"
        return 3
    fi

    if [[ -z $TELEPORT_LOGIN ]]; then
        tp_user="$(id -un)@expediagroup.com"
    else
        tp_user="${TELEPORT_LOGIN}@expediagroup.com"
    fi
       
    tsh logout --user="${tp_user}"  --proxy="$1"
}

_teleport-logout-completions () {
    local tphosts
    tphosts=$(ssh-add -l | grep teleport: | cut -d' ' -f 3 |
          cut -d: -f2 | sort -u)
    COMPREPLY=($(compgen -W "$tphosts" -- "${COMP_WORDS[1]}"))
}
to () {
    teleport-logout "$@"
}
complete -F _teleport-logout-completions teleport-logout
complete -f _teleport-logout-completions to

tp () {
    if [[ -f ~/.tsh/current-profile ]]; then
        cat ~/.tsh/current-profile
    else
        echo "No current profile for Teleport"
    fi
}
