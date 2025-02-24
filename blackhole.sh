#!/bin/bash

# Define the IP addresses of the two servers and the port to block
SERVER1="10.0.0.12"
PORT="22"  # Change this to the port you want to block
BLOCK_TIME=120  # 5 minutes

echo "Blocking traffic between $SERVER1 and on port $PORT for $BLOCK_TIME sec..."

# Block TCP and UDP traffic on the specified port
#iptables -A INPUT -s $SERVER2 -p tcp --dport $PORT -j DROP
#iptables -A OUTPUT -d $SERVER2 -p tcp --sport $PORT -j DROP
#iptables -A INPUT -s $SERVER2 -p udp --dport $PORT -j DROP
#iptables -A OUTPUT -d $SERVER2 -p udp --sport $PORT -j DROP

iptables -A INPUT -s $SERVER1 -p tcp --dport $PORT -j DROP
iptables -A OUTPUT -d $SERVER1 -p tcp --sport $PORT -j DROP
iptables -A INPUT -s $SERVER1 -p udp --dport $PORT -j DROP
iptables -A OUTPUT -d $SERVER1 -p udp --sport $PORT -j DROP

# Wait for 5 minutes
sleep $BLOCK_TIME

echo "Unblocking traffic on port $PORT..."

# Unblock TCP and UDP traffic on the specified port
#iptables -D INPUT -s $SERVER2 -p tcp --dport $PORT -j DROP
#iptables -D OUTPUT -d $SERVER2 -p tcp --sport $PORT -j DROP
#iptables -D INPUT -s $SERVER2 -p udp --dport $PORT -j DROP
#iptables -D OUTPUT -d $SERVER2 -p udp --sport $PORT -j DROP

iptables -D INPUT -s $SERVER1 -p tcp --dport $PORT -j DROP
iptables -D OUTPUT -d $SERVER1 -p tcp --sport $PORT -j DROP
iptables -D INPUT -s $SERVER1 -p udp --dport $PORT -j DROP
iptables -D OUTPUT -d $SERVER1 -p udp --sport $PORT -j DROP

echo "Traffic between $SERVER1 on port $PORT is now unblocked."
