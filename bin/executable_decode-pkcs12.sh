#!/usr/bin/env bash

# Script to decode a pkcs12 file into its .crt and .key files.
#
# pkcs file is given as argument

pkcs_file="$1"
if [[ -z $pkcs_file ]]; then
    echo "usage: $(basename $0) name.pkcs"
    exit 9
fi

: ${out_pass:='ChangeIt!123'}

if [[ ! -f $pkcs_file ]]; then
    echo "File not found: $pkcs_file"
    exit 8
fi

name=${pkcs_file%%.pfx}
key_file=${name}.key
crt_file=${name}.crt
chain_file=${name}.chain

tmp_cert=$(mktemp)
trap "rm $tmp_cert" EXIT

read -ers -p "Passphrase for $pkcs_file: " pkcs_pw
echo ""

openssl pkcs12 -in "$pkcs_file" -passin pass:$pkcs_pw -nocerts -passout pass:$out_pass -out $tmp_cert || exit $?
openssl rsa -passin pass:$out_pass -in $tmp_cert -out "$key_file"
openssl pkcs12 -in "$pkcs_file" -passin pass:"$pkcs_pw" -clcerts -nokeys -out "$crt_file"
openssl pkcs12 -in "$pkcs_file" -passin pass:"$pkcs_pw" -cacerts -nokeys -out "$chain_file"
