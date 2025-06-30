#!/bin/bash

# Create network namespace
sudo ip netns add vpn2ns

# Creating a virtual veth interface (connection between the main space and namespace
sudo ip link add veth0 type veth peer name veth1

# Connecting veth1 to the namespace
sudo ip link set veth1 netns vpn2ns

# Assign IP addresses to the veth0 and veth1 interfaces
# Host (outside the namespace)
sudo ip addr add 10.200.200.1/24 dev veth0
sudo ip link set veth0 up

# Inside the namespace
sudo ip netns exec vpn2ns ip addr add 10.200.200.2/24 dev veth1
sudo ip netns exec vpn2ns ip link set veth1 up
sudo ip netns exec vpn2ns ip link set lo up

# Write the default route inside the namespace
sudo ip netns exec vpn2ns ip route add default via 10.200.200.1

# Enabling IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Setting up masquerading (NAT) for packages from namespace
sudo iptables -t nat -A POSTROUTING -s 10.200.200.0/24 -o tun0 -j MASQUERADE

# Creating resolv.conf for namespace to make vpn2ns use 8.8.8.8 as a DNS server
sudo mkdir -p /etc/netns/vpn2ns
echo "nameserver 8.8.8.8" | sudo tee /etc/netns/vpn2ns/resolv.conf

# Starting vpn2 in the background
sudo ip netns exec vpn2ns openvpn --config file.ovpn --daemon

# make shell to use commands instead of writing every time <sudo ip netns exec vpn2ns <command>>
sudo ip netns exec vpn2ns bash
