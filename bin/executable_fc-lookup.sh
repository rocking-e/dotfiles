#!/usr/bin/env bash

# Do simple 'grep' on a file that should be the list of all the
# accounts in FlightCenter. That file will have to be extracted via
# either the FlightCenter webUI or its API.

: ${FC_ALL:=${HOME}/OneDrive/Documents/FC-all-accounts.csv}

if [[ ! -f "${FC_ALL}" ]]; then
    echo "FlightCenter account file not found."
    echo "File is ${FC_ALL}"
    exit 9
fi

grep "$1" ${FC_ALL}
