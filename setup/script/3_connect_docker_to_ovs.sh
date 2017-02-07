#!/bin/bash

# $1 = NETWORK
# $2 = START_IP
# $3 = MID_IP
# $4 = END_IP
# $5 = CIDR
# $6 = GATEWAY

DOCKER_HOME=~/docker-host-3/setup
NEXT_IP=`expr $3 + 1`

sudo rm -rf /var/run/netns 2> /dev/null
sudo mkdir -p /var/run/netns

IDX=1
for i in {1..2}
do
	if [ $i -eq 1 ]; then
		for j in $(seq $2 $3)
		do
			$DOCKER_HOME/script/components/docker_to_ovs.sh host-$IDX br$i veth-$IDX $1.$j $5 $6
			IDX=`expr $IDX + 1`
		done
	else
		for j in $(seq $NEXT_IP $4)
		do
			$DOCKER_HOME/script/components/docker_to_ovs.sh host-$IDX br$i veth-$IDX $1.$j $5 $6
			IDX=`expr $IDX + 1`
		done
	fi
done

echo $(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')": Connected containers to Open vSwitch"
