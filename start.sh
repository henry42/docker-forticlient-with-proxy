#!/bin/sh

if [ -z "$VPNADDR" -o -z "$VPNUSER" -o -z "$VPNPASS" ]; then
  echo "Variables VPNADDR, VPNUSER and VPNPASS must be set."; exit;
fi

export VPNTIMEOUT=${VPNTIMEOUT:-5}

# Setup masquerade, to allow using the container as a gateway
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
done

echo "------------ SS5 Starts -------------"
ss5 -t -u ss5 &

echo "------------ polipo Starts ---------"
/usr/bin/polipo -- socksParentProxy="127.0.0.1:1080" &

echo "------------ VPN Starts ------------"
/usr/bin/forticlient
echo "------------ VPN exited ------------"
