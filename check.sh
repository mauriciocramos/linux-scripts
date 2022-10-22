#!/bin/bash
if [ -z "$1" ]
  then
    echo 'ERROR: inform string to search'
    exit 1
fi

grep --color=always -i $1 /var/log/syslog
dmesg | grep --color=always -i $1


