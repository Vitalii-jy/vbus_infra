#!/bin/bash

IPTABLES=/sbin/iptables
IP6TABLES=/sbin/ip6tables


/sbin/depmod -a

/sbin/modprobe ip_tables
/sbin/modprobe ip_conntrack
/sbin/modprobe iptable_filter
/sbin/modprobe iptable_mangle
/sbin/modprobe iptable_nat
/sbin/modprobe ipt_LOG
/sbin/modprobe ipt_state
#/sbin/modprobe ipt_hashlimit



#Flush policy
$IP6TABLES -F INPUT

$IPTABLES -F INPUT
$IPTABLES -F OUTPUT
$IPTABLES -F FORWARD

$IPTABLES -t nat -F
$IPTABLES -t mangle -F

#Default policy
$IP6TABLES -P INPUT ACCEPT

$IPTABLES -P INPUT ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT

