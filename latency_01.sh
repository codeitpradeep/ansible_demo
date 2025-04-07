#!/bin/bash

# Replace this with the target hostname or IP
TARGET="codeitpradeep.github.io"

# Network interface to apply latency on
INTERFACE="eth0"

# Latency in milliseconds
LATENCY_MS=200

# Duration in seconds (5 minutes)
DURATION=300

# Resolve the IP address of the host
IP=$(getent ahosts "$TARGET" | grep -m1 "STREAM" | awk '{print $1}')

if [ -z "$IP" ]; then
  echo "Failed to resolve IP address for $TARGET"
  exit 1
fi

echo "Applying ${LATENCY_MS}ms latency to/from $TARGET ($IP) on $INTERFACE for $DURATION seconds..."

# Add a root qdisc if not already added
tc qdisc add dev "$INTERFACE" root handle 1: prio 2>/dev/null

# Add netem delay to a child qdisc
tc qdisc add dev "$INTERFACE" parent 1:3 handle 30: netem delay ${LATENCY_MS}ms

# Apply filters for target IP (both inbound and outbound)
tc filter add dev "$INTERFACE" protocol ip parent 1:0 prio 3 u32 match ip dst "$IP"/32 flowid 1:3
tc filter add dev "$INTERFACE" protocol ip parent 1:0 prio 4 u32 match ip src "$IP"/32 flowid 1:3

# Hold for the specified duration
sleep "$DURATION"

echo "Removing latency rules..."

# Clean up
tc qdisc del dev "$INTERFACE" root

echo "Latency removed for $TARGET ($IP)."
