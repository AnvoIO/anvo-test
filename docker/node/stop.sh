#!/bin/sh
DATADIR="./logs/"$SYSTEM_TOKEN_SYMBOL

if [ -f $DATADIR"/core_netd.pid" ]; then
pid=$(cat $DATADIR"/core_netd.pid")
echo $pid
kill $pid
rm -r $DATADIR"/core_netd.pid"
echo -ne "Stoping Node"
while true; do
[ ! -d "/proc/$pid/fd" ] && break
echo -ne "."
sleep 1
done
echo -ne "\rNode Stopped. \n"
fi
