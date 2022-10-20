#!/bin/bash
if [ -z "$1" ]
  then
    echo 'Usage: liquidcfg [quiet|balanced|extreme] [percentage]'
    echo 'Example: liquidcfg quiet 100'
     exit 1
fi
liquidctl --match gigabyte initialize --verbose
liquidctl --match gigabyte set sync color fixed $3 --verbose
liquidctl --match corsair initialize --pump-mode $1 --verbose
liquidctl --match corsair set led color fixed $3 --verbose
liquidctl --match corsair set fan speed $2

