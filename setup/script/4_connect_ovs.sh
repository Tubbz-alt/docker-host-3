#!/bin/bash

DOCKER_HOME=~/docker-host-3/setup

$DOCKER_HOME/script/components/connect_ovs.sh br0 br1 patch0-1 patch1-0 2> /dev/null
$DOCKER_HOME/script/components/connect_ovs.sh br0 br2 patch0-2 patch2-0 2> /dev/null

echo $(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')": Connected Open vSwitches themselves"
