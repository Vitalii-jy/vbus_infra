#!/bin/bash

IPTABLES=/sbin/iptables
IP6TABLES=/sbin/ip6tables


/sbin/depmod -a

/sbin/modprobe ip_tables
/sbin/modprobe ip_conntrack
/sbin/modprobe iptable_filter
/sbin/modprobe iptable_mangle
/sbin/modprobe iptable_nat
#/sbin/modprobe ipt_LOG
/sbin/modprobe ipt_state
#/sbin/modprobe ipt_hashlimit

#Flush policy
$IP6TABLES -F INPUT

$IPTABLES -F INPUT
$IPTABLES -F OUTPUT
$IPTABLES -F FORWARD

$IPTABLES -t nat -F
$IPTABLES -t mangle -F
#

#Default policy
$IP6TABLES -P INPUT DROP

$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT
#

# Create Stateful
$IPTABLES -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#

# From localhost
$IPTABLES -A INPUT -p tcp -i lo -j ACCEPT
$IPTABLES -A INPUT -p udp -i lo -j ACCEPT
#

# Some ICMP
$IPTABLES -A INPUT -p icmp --icmp-type 3 -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type 8 -j ACCEPT   # Echo request
$IPTABLES -A INPUT -p icmp --icmp-type 12 -j ACCEPT
#

# SSH allow access exclude deny networks
$IPTABLES -A INPUT -p tcp --dport 22 -m set --match-set DENY_NETWORKS src -j DROP
$IPTABLES -A INPUT -p tcp --dport 22 -j ACCEPT


if dpkg -l |grep -q docker; then
    systemctl restart docker
fi

