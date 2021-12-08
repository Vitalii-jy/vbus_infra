#!/bin/sh

# AFRINIC - Африка
# APNIC - Азия, Океания и Австралия
# ARIN - Северная Америка
# LACNIC - Центральная и Южная Америка
# RIPE NCC - Европпа и Ближний Восток


# Define continents to ban. Separate with "|"
BAN_CONT='AFRINIC|APNIC|LACNIC|ARIN'

OUT_FILE="create_ipset.sh"

# Get IPv4 list
list=$(curl -s  http://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv \
| grep -E $BAN_CONT  \
| cut -d "," -f 1  \
| sed 's!/8!.0.0.0/8!g' )

{
    echo "#!/usr/bin/env bash"
    echo ""

    echo "IPSET=/sbin/ipset"
    echo ""

    echo "\$IPSET -N DENY_NETWORKS nethash"
    echo ""
} >./$OUT_FILE


for ip in $list; do
    echo "\$IPSET -A DENY_NETWORKS  $(echo "$ip" | sed 's/^0*//')" >>./$OUT_FILE
done

chmod u+x ./$OUT_FILE

