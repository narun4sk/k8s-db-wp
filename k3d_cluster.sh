#! /bin/bash --
set -eu

# Cluster name
NAME=${1:?## Err: Please specify cluster name}
# Number of the MySQL servers
REPLICAS=2

# Create MySQL data dirs
for x in $(seq 0 $(($REPLICAS -1))); do
  mkdir -vp "$(pwd)/mysql-data/data-$x"
done

# Create the cluster
k3d cluster create\
 --servers=1\
 --agents=$(($REPLICAS +1))\
 --k3s-node-label "role=db@agent:0,1"\
 --k3s-node-label "role=app@agent:2"\
 -v "$(pwd)/mysql-data:/mysql-data@agent:0,1"\
 -p "8081:80@loadbalancer"\
 "${NAME}"
