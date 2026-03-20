#!/bin/sh
DATADIR="./logs/"$SYSTEM_TOKEN_SYMBOL
rm -fr $DATADIR/config $DATADIR/core_netd.log $DATADIR/data/logs $DATADIR/data/state
ls -al
