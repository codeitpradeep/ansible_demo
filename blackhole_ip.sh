 #!/bin/bash

# Define the IP addresses of the two servers
SERVER1="180.253.136.245"

BLOCK_TIME=60  # 5 minutes

echo "Blocking all traffic between $SERVER1 and $SERVER2 for 5 minutes..."

# Block all traffic (TCP, UDP, ICMP, etc.)
iptables -A INPUT -s $SERVER1 -j DROP
iptables -A OUTPUT -d $SERVER1 -j DROP

# Wait for 5 minutes
sleep $BLOCK_TIME

echo "Unblocking traffic..."

# Unblock all traffic

iptables -D INPUT -s $SERVER1 -j DROP
iptables -D OUTPUT -d $SERVER1 -j DROP

echo "Traffic between $SERVER1 and $SERVER2 is now unblocked."

