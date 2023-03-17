#!/bin/bash

set -o nounset

BASE=$(dirname $0)
OUTFILE=$TEXTFILE_DIR/ipmitool.prom

while true; do
    /usr/bin/ipmitool sensor | awk -f $BASE/ipmitool-textfile.awk > $OUTFILE
    sleep 60
done
