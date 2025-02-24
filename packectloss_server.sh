#!/bin/bash

# Define the target IP and packet loss percentage
TARGET_IP="142.250.195.142"  # Change this to the target server
PACKET_LOSS="70%"  # Percentage of packets to drop

echo "Introducing $PACKET_LOSS packet loss for traffic to $TARGET_IP..."

# Add a traffic control queue
sudo tc qdisc add dev eth0 root handle 1: prio

# Create a rule to drop packets for the specific IP
sudo tc qdisc add dev eth0 parent 1:3 handle 30: netem loss $PACKET_LOSS
sudo iptables -t mangle -A PREROUTING -d $TARGET_IP -j MARK --set-mark 30
sudo tc filter add dev eth0 protocol ip parent 1:0 prio 1 handle 30 fw flowid 1:3

echo "Packet loss applied! Traffic to $TARGET_IP is now affected."
