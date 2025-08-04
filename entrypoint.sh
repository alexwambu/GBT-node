#!/bin/bash

# Generate new wallet if it doesn't exist
if [ ! -f /app/keystore/address.txt ]; then
  echo "⛏️  Creating new wallet..."
  mkdir -p /app/keystore
  geth --datadir /app/data account new --password pass.txt > /app/keystore/account_output.txt

  # Extract address
  ADDRESS=$(cat /app/keystore/account_output.txt | grep -oP '(?<=0x)[a-fA-F0-9]{40}')
  echo "0x$ADDRESS" > /app/keystore/address.txt

  # Update genesis.json with new address
  echo "🔧 Inserting address 0x$ADDRESS into genesis.json..."
  sed "s/0xF7F965b65E735Fb1C22266BdcE7A23CF5026AF1E/0x$ADDRESS/g" genesis.json > /app/genesis_final.json
else
  ADDRESS=$(cat /app/keystore/address.txt | tr -d '\n')
  cp genesis.json /app/genesis_final.json
fi

# Initialize chain
geth --datadir /app/data init /app/genesis_final.json

# Launch geth node with mining and RPC
geth \
  --datadir /app/data \
  --networkid 999 \
  --http \
  --http.addr "0.0.0.0" \
  --http.port 8545 \
  --http.api "eth,net,web3,personal,miner" \
  --allow-insecure-unlock \
  --unlock "$ADDRESS" \
  --password pass.txt \
  --mine \
  --miner.threads=1 \
  --http.corsdomain "*" \
  --nodiscover \
  --verbosity 3 \
  console
