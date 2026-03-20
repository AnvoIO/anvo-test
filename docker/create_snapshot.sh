#!/bin/sh

cd /app/snapshot-node/ && ./start.sh
cd /app/
./scripts/wait-for-node.sh
./scripts/create_wallet.sh
if [ "$SYSTEM_TOKEN_SYMBOL" = "ANVO" ]; then
  echo "Deploy ANVO System Contracts..."
  ./scripts/deploy_system_contract_anvo.sh
else
  echo "No available system contracts for token symbol: " + $SYSTEM_TOKEN_SYMBOL
fi
sleep 1s
curl http://127.0.0.1:8888/v1/producer/create_snapshot | json_pp
cd /app/snapshot-node/ && ./stop.sh && ./clear.sh
