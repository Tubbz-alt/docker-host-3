#!/bin/bash

# $1 = CONTROLLERS
# $2 = PROTOCOL
# $3 = CTRL_INTERFACE
# $4 = BR0_IP
# $5 = BR1_IP
# $6 = BR2_IP
# $7 = NIC1
# $8 = NIC2
# $9 = NIC3
# $10 = NIC4

# delete bridge

sudo ovs-vsctl del-br br0 2> /dev/null
sudo ovs-vsctl del-br br1 2> /dev/null
sudo ovs-vsctl del-br br2 2> /dev/null

# create bridge

sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-br br1
sudo ovs-vsctl add-br br2

# set controller

CONTROLLERS=$(echo $1 | sed 's/,/ /g')
sudo ovs-vsctl set-controller br0 $CONTROLLERS
sudo ovs-vsctl set-controller br1 $CONTROLLERS
sudo ovs-vsctl set-controller br2 $CONTROLLERS

# set operation mode

sudo ovs-vsctl set-fail-mode br0 secure
sudo ovs-vsctl set-fail-mode br1 secure
sudo ovs-vsctl set-fail-mode br2 secure

# set OpenFlow version

sudo ovs-vsctl -- set bridge br0 protocols=$2
sudo ovs-vsctl -- set bridge br1 protocols=$2
sudo ovs-vsctl -- set bridge br2 protocols=$2

#sudo ovs-vsctl -- set bridge br0 other-config:datapath-id=0000000000000001
#sudo ovs-vsctl -- set bridge br1 other-config:datapath-id=0000000000000002
#sudo ovs-vsctl -- set bridge br2 other-config:datapath-id=0000000000000003

# add NICs

sudo ifconfig $3:0 $4 up
sudo ifconfig $3:1 $5 up
sudo ifconfig $3:2 $6 up

sudo ovs-vsctl add-port br0 $3:0
sudo ovs-vsctl add-port br1 $3:1
sudo ovs-vsctl add-port br2 $3:2

if [ ! -z $7 ]; then
sudo ovs-vsctl add-port br0 $7
fi
if [ ! -z $8 ]; then
sudo ovs-vsctl add-port br0 $8
fi
if [ ! -z $9 ]; then
sudo ovs-vsctl add-port br0 $9
fi
if [ ! -z $10 ]; then
sudo ovs-vsctl add-port br0 $10
fi

echo $(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')": Created Open vSwitch"
