#!/usr/bin/env bash
# shellcheck disable=SC2223,SC2034

# A script that must be "sourced" and not executed. Why? Because it needs to
# define 2 functions in the calling shell. One function is the command that will
# set the environment variables AWS_PROFILE and AWS_REGION for AWS
# authentication. The other function is the bash command completion function for
# the be-aws function.

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

if [[ ! -f ~/.aws/credentials ]]; then
    echo "File not found: ~/.aws/credentials"
    echo "Things may not work properly without that file"
fi

be-aws () {
    if [[ "$#" = 0 ]]; then
        echo $AWS_PROFILE - $AWS_REGION
        return 0
    fi
    if [[ "$#" != 2 ]]; then
        echo "Incorrect number of arguments, 2 required."
        echo "usage: $(basename $0) AWS_PROFILE AWS_REGION"
        return 3
    fi

    profile="$1"
    region="$2"

    # Validate profile
    if ! grep --quiet "^\[${profile}\]" ~/.aws/credentials; then
        echo "Danger Will Robinson!"
        echo "Could not find given profile in ~/.aws/credentials"
        echo "Using profile: ${profile}, but things may not work as expected"
    fi

    # Validate region
    case $region in
        us-east-1|us-west-2|ap-southeast-1|eu-west-1|ap-southeast-2)
            :
            ;;
        east)
            region=us-east-1
            ;;
        west)
            region=us-west-2
            ;;
        ap)
            region=ap-southeast-1
            ;;
        eu)
            region=eu-west-1
            ;;
        *)
            echo "Region not recognized"
            return 5
            ;;
    esac

    export AWS_PROFILE="${profile}"
    export AWS_REGION="${region}"
}

_be-aws-completions() {
    local profiles regions
    profiles=$(echo $(grep '^\[' ~/.aws/credentials | tr -d '[]'))
    regions="us-east-1 us-west-2 ap-southeast-1 eu-west-1 east west ap eu"

    case $COMP_CWORD in
        1)
            COMPREPLY=( $(compgen -W "${profiles}" -- "${COMP_WORDS[COMP_CWORD]}") )
            ;;
        2)
            COMPREPLY=( $(compgen -W "${regions}" -- "${COMP_WORDS[COMP_CWORD]}") )
            ;;
    esac
    return 0
} &&
    complete -F _be-aws-completions be-aws
