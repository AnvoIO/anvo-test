#!/bin/bash

cd /app/node/ && ./stop.sh

ARCH=$(uname -m)
if [ "${ARCH}" = "x86_64" ]; then
   FAKETIME_LIB=/usr/lib/x86_64-linux-gnu/faketime/libfaketime.so.1
else
   FAKETIME_LIB=/usr/lib/aarch64-linux-gnu/faketime/libfaketime.so.1
fi

export LD_PRELOAD=$FAKETIME_LIB FAKETIME_NO_CACHE=1
export FAKETIME=$1

cd /app/node/ && ./restart.sh
