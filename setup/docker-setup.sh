#!/bin/bash

DOCKER_HOME=~/docker-host-3/setup

# clean up all old containers 

$DOCKER_HOME/docker-clean.sh

# create new containers

NUM_OF_DOCKERS=63

$DOCKER_HOME/script/1_run_docker.sh $NUM_OF_DOCKERS

# create a new Open vSwitch bridge

# Controller IP and port
CONTROLLERS="tcp:192.168.0.11:6633,tcp:192.168.0.12:6633,tcp:192.168.0.13:6633"

# OpenFlow10 / OpenFlow13
PROTOCOL=OpenFlow10

# Interface connected to the control plane
CTRL=eth0

# Each OVS IP address
BR0_IP=192.168.0.11
BR1_IP=192.168.0.12
BR2_IP=192.168.0.13

# Nothing / Target NICs
NIC1=eth1
NIC2=eth2
NIC3=eth3
NIC4=eth4

$DOCKER_HOME/script/2_create_ovs.sh $CONTROLLERS $PROTOCOL $CTRL $BR0_IP $BR1_IP $BR2_IP $NIC1 $NIC2 $NIC3 $NIC4

# link all containers to the bridge

# NETWORK(X.X.X).DOCKER($START_IP ~ $END_IP)
NETWORK=172.16.0
START_IP=2
MID_IP=32
END_IP=64
CIDR=24
GATEWAY=172.16.0.1

$DOCKER_HOME/script/3_connect_docker_to_ovs.sh $NETWORK $START_IP $MID_IP $END_IP $CIDR $GATEWAY

# link bridges together

$DOCKER_HOME/script/4_connect_ovs.sh
