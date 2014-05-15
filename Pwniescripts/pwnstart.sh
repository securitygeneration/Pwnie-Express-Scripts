#!/bin/bash
# This script starts HTTPtunnel, stunnel, DNS2TCP and ptunnel 
# to listen for Pwnie Express reverse SSH connections.
# --------------------------------------------------------------------------
# Copyright (c) 2011 Security Generation <http://www.securitygeneration.com>
# This script is licensed under GNU GPL version 2.0
# --------------------------------------------------------------------------
# This script is part of PwnieScripts shell script collection
# Visit http://www.securitygeneration.com/security/pwniescripts-for-pwnie-express/
# for more information.
# --------------------------------------------------------------------------

if [ "$1" == "-h" ]; then
	echo "pwnstart starts HTTPTunnel, stunnel, DNS2TCP and ptunnel listeners."
	exit 0
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "[*] Killing old listeners..."
killall ptunnel
killall stunnel
killall dns2tcpd
killall hts

echo "[+] Trying to start SSHD..."
/etc/init.d/ssh start

echo "[+] Trying to start HTTPtunnel listener..."
hts -F 0.0.0.0:22 80

echo "[+] Trying to start (SSL) stunnel listener..."
stunnel /root/stunnel/stunnel.conf

echo "[+] Trying to start DNS2TCP listener..."
/pentest/backdoors/dns2tcp/dns2tcpd -d 0 -f /root/dns2tcpdrc &

echo "[+] Trying to start (ICMP) ptunnel listener..."
/pentest/backdoors/ptunnel/ptunnel -daemon /tmp/ptunnel -f /tmp/ptunnel.log

echo "[*] Listeners created (check with: ps aux | grep \"hts\|dns2tcpd\|ptunnel\|stunnel\")"

# IP address parser by Vivek Gite (http://bash.cyberciti.biz/misc-shell/read-local-ip-address/)
OS=`uname`
IO="" # store IP
case $OS in
   Linux) IP=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`;;
   FreeBSD|OpenBSD) IP=`ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}'` ;;
   SunOS) IP=`ifconfig -a | grep inet | grep -v '127.0.0.1' | awk '{ print $2} '` ;;
   *) IP="Unknown";;
esac
echo "[!] This IP address is: $IP"
echo "[!] Use ./pwnwatch.sh to monitor incoming connections. Use ./pwnstop.sh to kill the listeners."
