#!/bin/sh

if test -f "./snapshot-node/genesis.json"; then
    sed -i "s/ANVO_PUB_KEY/$ANVO_PUB_KEY/g" ./snapshot-node/genesis.json
fi

# Build ANVO snapshot
export SYSTEM_TOKEN_SYMBOL="ANVO"
./create_snapshot.sh

tail -f /dev/null
exec "$@"
