#!/bin/bash
# Script to perform Pwnie Express setup steps on BackTrack 5
# --------------------------------------------------------------------------
# Copyright (c) 2011 Security Generation <http://www.securitygeneration.com>
# This script is licensed under GNU GPL version 2.0
# --------------------------------------------------------------------------
# This script is part of PwnieScripts shell script collection
# Visit http://www.securitygeneration.com/security/pwniescripts-for-pwnie-express/
# for more information.
# --------------------------------------------------------------------------

if [ "$1" == "-h" ]; then
	echo "pwnsetup starts SSHD, creates a 'pwnplug' user, installs HTTPTunnel, generates an SSL certificate and configures stunnel, and sets up DNS2TCP."
	exit 0
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "[+] Starting SSHD..."
/etc/init.d/ssh start

files=$(ls /etc/ssh/*_key 2> /dev/null | wc -l)
if [ "$files" != "0" ]; then
	echo "[-] SSH keys appear to exist. Skipping generation..."
else
	echo "[+] Generating SSHD keys..."
	sshd-generate
fi

cut -d: -f1 /etc/passwd | grep "pwnplug" > /dev/null
OUT=$?
if [ $OUT -eq 0 ];then
	echo "[-] User 'pwnplug' already exists. Skipping."
else
	echo "[+] Adding 'pwnplug' user account..."
	useradd -m pwnplug
fi

if [ ! -d "/home/pwnplug/.ssh" ]; then
	mkdir /home/pwnplug/.ssh
fi

# install httptunnel
echo "[+] Making sure HTTPTunnel is installed..."
apt-get --force-yes --yes -qq install httptunnel

# set up stunnel
if [ -d "/root/stunnel/" ]; then	
	echo "[-] stunnel appears to already be configured. Remove directory /root/stunnel/ and re-run pwnsetup.sh to reconfigure. Skipping..."
else
	echo "[+] Setting up (SSL) stunnel..."
	echo "[+] Generating SSL certificate (press enter for all prompts)..."
	#DIR='pwd'
	mkdir /root/stunnel/ && cd /root/stunnel/
	openssl genrsa -out pwn_key.pem 2048
	openssl req -new -key pwn_key.pem -out pwn.csr
	openssl x509 -req -in pwn.csr -out pwn_cert.pem -signkey pwn_key.pem -days 1825
	cat pwn_cert.pem >> pwn_key.pem
	#cd $DIR
	echo "[+] SSL certificate created. Configuring stunnel..."
	echo -e "cert = /root/stunnel/pwn_key.pem\nchroot = /var/tmp/stunnel\npid = /stunnel.pid\nsetuid = root\nsetgid = root\nclient = no\n[22]\naccept = 443\nconnect = 22" >> /root/stunnel/stunnel.conf
	mkdir /var/tmp/stunnel
fi

if [ -e /root/dns2tcpdrc ]; then
	echo "[-] DNS2TCP appears to already be configured. Remove /root/dns2tcpdrc and re-run pwnsetup.sh to reconfigure. Skipping..."
else
	echo "[+] Setting up DNS2TCP..."
	echo -e "listen = 0.0.0.0\nport = 53\nuser = nobody\nchroot = /var/empty/dns2tcp/\ndomain = rssfeeds.com\nresources = ssh:127.0.0.1:22" >> /root/dns2tcpdrc
	mkdir -p /var/empty/dns2tcp/
fi

echo ""
echo "[+] Remember to add the SSH Key from the Pwnie web interface to '/home/pwnplug/.ssh/authorized_keys'."
echo "[!] Setup Complete. Run ./pwnstart.sh to start the listeners."
