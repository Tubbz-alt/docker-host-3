#!/bin/bash

DOCKER_HOME=~/docker-host-3/setup

# clean up all old containers 

$DOCKER_HOME/docker-clean.sh

# create new containers

NUM_OF_DOCKERS=32

$DOCKER_HOME/script/1_run_docker.sh $NUM_OF_DOCKERS

# create a new Open vSwitch bridge

# Controller IP and port
CONTROLLERS="tcp:192.168.0.21:6633,tcp:192.168.0.22:6633,tcp:192.168.0.23:6633"

# OpenFlow10 / OpenFlow13
PROTOCOL=OpenFlow10

# Interface connected to the control plane
CTRL=eth1

# Each OVS IP address
BR0_IP=192.168.0.101
BR1_IP=192.168.0.102
BR2_IP=192.168.0.103

# Nothing / Target NICs
NIC1=eth2
NIC2=
NIC3=
NIC4=

$DOCKER_HOME/script/2_create_ovs.sh $CONTROLLERS $PROTOCOL $CTRL $BR0_IP $BR1_IP $BR2_IP $NIC1 $NIC2 $NIC3 $NIC4

# link all containers to the bridge

# NETWORK(X.X.X).DOCKER($START_IP ~ $END_IP)
NETWORK=172.16.10
START_IP=2
END_IP=`expr $START_IP + $NUM_OF_DOCKERS - 1`
MID_IP=`expr $END_IP / 2`
CIDR=24
GATEWAY=172.16.10.1

$DOCKER_HOME/script/3_connect_docker_to_ovs.sh $NETWORK $START_IP $MID_IP $END_IP $CIDR $GATEWAY

# link bridges together

$DOCKER_HOME/script/4_connect_ovs.sh
