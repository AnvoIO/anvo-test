#!/bin/bash

cd /app/

core-cli create account eosio core.token ${ANVO_PUB_KEY}

# Deploy token contract
until core-cli set contract core.token contracts/anvo core.token.wasm core.token.abi
do
  sleep 1s
done

# Create and issue the token
CREATE_CMD='core-cli push action core.token create '"'"'["eosio", "'$SYSTEM_TOKEN_SUPPLY'"]'"'"' -p core.token@active'
eval $CREATE_CMD
ISSUE_CMD='core-cli push action core.token issue '"'"'[ "eosio", "'$SYSTEM_TOKEN_SUPPLY'", "initial supply" ]'"'"' -p eosio@active'
eval $ISSUE_CMD
