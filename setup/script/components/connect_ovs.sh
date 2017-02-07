#!/bin/bash

var1=$1
var2=$2
var3=$3
var4=$4

if [ $# -ne 4 ]; then
	echo "./connect_ovs.sh [bridge1] [bridge2] [patch1-2] [patch2-1]"
else
	sudo ip tuntap del dev $var3
	sudo ip tuntap del dev $var4

	sudo ip tuntap add dev $var3 mode tap
	sudo ip tuntap add dev $var4 mode tap

	sudo ovs-vsctl add-port $var1 $var3
	sudo ovs-vsctl add-port $var2 $var4

	sudo ovs-vsctl set interface $var3 type=patch
	sudo ovs-vsctl set interface $var3 options:peer=$var4

	sudo ovs-vsctl set interface $var4 type=patch
	sudo ovs-vsctl set interface $var4 options:peer=$var3
fi
