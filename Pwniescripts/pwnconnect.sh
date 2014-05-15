#!/bin/bash
# Very simple script that finds first available reverse SSH connection from Pwnie Express 
# and executes an SSH connection.
# --------------------------------------------------------------------------
# Copyright (c) 2011 Security Generation <http://www.securitygeneration.com>
# This script is licensed under GNU GPL version 2.0
# --------------------------------------------------------------------------
# This script is part of PwnieScripts shell script collection
# Visit http://www.securitygeneration.com/security/pwniescripts-for-pwnie-express/
# for more information.
# --------------------------------------------------------------------------


if [ "$1" == "-h" ]; then
	echo "pwnconnect finds the first available reverse SSH connection from Pwnie Express and executes an SSH connection."
	exit 0
fi

netstat=$(netstat -lntup | grep 'pwn' | grep '127.0.0.1' | grep 333)

if [ "$netstat" == "" ]; then
	echo "[!] No reverse connections available. Use pwnwatch.sh to monitor incoming connections."
	exit 1
fi

if [ "$1" == "-t" ]; then
	netstat=$(netstat -lntup | grep 'pwn' | grep '127.0.0.1' | grep 3330)
	if [ "$netstat" != "" ]; then
        	echo "[+] Found: Reverse SSH over Tor. Connecting..."
        	ssh root@localhost -p 3330 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
        	exit 0
	else
		echo "[!] Reverse Tor connection not available. Use pwnwatch.sh to monitor incoming connections or re-run pwnconnect.sh without '-t' to try the standard connections."
		exit 0
	fi
fi


netstat=$(netstat -lntup | grep 'pwn' | grep '127.0.0.1' | grep 3333)

if [ "$netstat" != "" ]; then
	echo "[+] Found: Reverse SSH. Connecting..."
	ssh root@localhost -p 3333 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
	exit 0
fi

netstat=$(netstat -lntup | grep 'pwn' | grep '127.0.0.1' | grep 3336)

if [ "$netstat" != "" ]; then
        echo "[+] Found: Reverse SSH over SSL tunnel. Connecting..."
        ssh root@localhost -p 3336 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
	exit 0
fi

netstat=$(netstat -lntup | grep 'pwn' | grep '127.0.0.1' | grep 3338)

if [ "$netstat" != "" ]; then
        echo "[+] Found: Reverse SSH over HTTP tunnel. Connecting..."
        ssh root@localhost -p 3338 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
	exit 0
fi

netstat=$(netstat -lntup | grep 'pwn' | grep '127.0.0.1' | grep 3335)

if [ "$netstat" != "" ]; then
        echo "[+] Found: Reverse SSH over DNS tunnel. Connecting..."
        ssh root@localhost -p 3335 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
	exit 0
fi

netstat=$(netstat -lntup | grep 'pwn' | grep '127.0.0.1' | grep 3339)

if [ "$netstat" != "" ]; then
        echo "[+] Found: Reverse SSH over ICMP tunnel. Connecting..."
        ssh root@localhost -p 3339 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
	exit 0
fi

netstat=$(netstat -lntup | grep 'pwn' | grep '127.0.0.1' | grep 3330)
if [ "$netstat" != "" ]; then
	echo "[+] Found: Reverse SSH over Tor. Connecting..."
        ssh root@localhost -p 3330 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
        exit 0
if
