#!/bin/bash -x
# this makes the following content be interpreted by bash
# the -x means to debug, or -xv

#user can specify the directory where the certificate and key will be placed
# 1 means first positional argument, :-. means when the variable 1 is not defined, put a dot 
#(current directory)
 
DIRECTORY=${1:-.}

#create the directory
mkdir -p $DIRECTORY

#create the certificate and key and save them into that directory as a localhost.crt and 
#localhost.key
openssl req -x509 -out "${DIRECTORY}/localhost.crt" -keyout "${DIRECTORY}/localhost.key" \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")



