#!/usr/bin/env bash
echo "Building 2 Node QRL Devnet on Docker"
echo ""
echo "Staking addresses are:"
echo "Qb267740d8c322e15cb207e9bf64c9f40eaf5864bcd4540f91a6d3b3b45aff03632fb"
echo "Q929a0ae1295a27ac41f91dd3bb395ef2aa30322f5e81e83e841017804c3f624278a4"
echo ""

echo "Setting up node data directories..."
# Create local directory for devnet home
LOCAL_QRL_DIR_1=${HOME}/.qrl-devnet-1
LOCAL_QRL_DIR_2=${HOME}/.qrl-devnet-2

mkdir -p ${LOCAL_QRL_DIR_1}/wallet
mkdir -p ${LOCAL_QRL_DIR_2}/wallet

# Copy wallet mnemonics into wallet folder
cp -f ./devnet_files/mnemonic_1 $LOCAL_QRL_DIR_1/wallet/mnemonic
cp -f ./devnet_files/mnemonic_2 $LOCAL_QRL_DIR_2/wallet/mnemonic

# Create a devnet docker network
echo "Creating docker network 'qrl_devnet'..."
docker network create qrl_devnet

# Create container
echo "Building QRL container..."
mv ./Dockerfile_devnet ./Dockerfile
docker build -t qrl .
mv ./Dockerfile ./Dockerfile_devnet

# Start qrl_devnet containers
echo "Starting devnet containers..."

echo "Starting dev1"

docker run -dt \
    --name dev1 \
    --network qrl_devnet \
    -p 127.0.0.1:2001:12000 \
    -p 127.0.0.1:8081:18080 \
    -v ${LOCAL_QRL_DIR_1}:/root/.qrl \
    qrl

echo "Waiting for dev1 to become operational"
while true; do 
    DEV_1_ONLINE=`curl localhost:8081/api`
    if [ $? == 0 ]; then
        break;
    else
        sleep 2
    fi
done

echo "Starting dev2"

docker run -dt \
    --name dev2 \
    --network qrl_devnet \
    -p 127.0.0.1:2002:12000 \
    -p 127.0.0.1:8082:18080 \
    -v ${LOCAL_QRL_DIR_2}:/root/.qrl \
    qrl

echo "QRL Devnet is online!"
echo ""


