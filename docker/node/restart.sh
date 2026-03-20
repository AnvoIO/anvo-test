#!/bin/sh
DATADIR="./logs/"$SYSTEM_TOKEN_SYMBOL

BPACCOUNT=eosio

if [ ! -d $DATADIR ]; then
  mkdir -p $DATADIR;
fi

ARCH=$(uname -m)

if [ "${ARCH}" = "x86_64" ]; then
   EOSVM=eos-vm-jit
else
   EOSVM=eos-vm
fi

core_netd \
--signature-provider $ANVO_PUB_KEY=KEY:$ANVO_PRV_KEY \
--plugin core_net::net_plugin \
--plugin core_net::net_api_plugin \
--plugin core_net::producer_plugin \
--plugin core_net::producer_api_plugin \
--plugin core_net::chain_plugin \
--plugin core_net::chain_api_plugin \
--plugin core_net::http_plugin \
--data-dir $DATADIR"/data" \
--blocks-dir $DATADIR"/blocks" \
--config-dir $DATADIR"/config" \
--producer-name $BPACCOUNT \
--http-server-address 0.0.0.0:8888 \
--p2p-listen-endpoint 0.0.0.0:9010 \
--access-control-allow-origin=* \
--contracts-console \
--http-validate-host=false \
--verbose-http-errors \
--enable-stale-production \
--trace-history \
--chain-state-history \
--max-transaction-time=2000 \
--abi-serializer-max-time-ms=60000 \
--http-max-response-time-ms=8000 \
--chain-state-db-size-mb 8192 \
--chain-state-db-guard-size-mb 1024 \
--wasm-runtime=$EOSVM \
>> $DATADIR"/core_netd.log" 2>&1 & \
echo $! > $DATADIR"/core_netd.pid"
