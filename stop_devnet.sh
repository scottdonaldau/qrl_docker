#!/usr/bin/env bash

for ID in 1 2; do
  docker stop "dev${ID}"
  docker rm "dev${ID}"
  rm -rf $HOME/.qrl-devnet-$ID/data
  rm -rf $HOME/.qrl-devnet-$ID/wallet/wallet.dat
  rm -rf $HOME/.qrl-devnet-$ID/wallet/wallet.info
done
