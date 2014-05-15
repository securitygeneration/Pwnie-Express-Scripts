#!/bin/bash
# This shell script kills all HTTPTunnel, stunnel, 
# DNS2TCP and ptunnel listener processes.
# --------------------------------------------------------------------------
# Copyright (c) 2011 Security Generation <http://www.securitygeneration.com>
# This script is licensed under GNU GPL version 2.0
# --------------------------------------------------------------------------
# This script is part of PwnieScripts shell script collection
# Visit http://www.securitygeneration.com/security/pwniescripts-for-pwnie-express/
# for more information.
# --------------------------------------------------------------------------

if [ "$1" == "-h" ]; then
	echo "pwnstop stops all HTTPTunnel, stunnel, DNS2TCP and ptunnel listeners."
	exit 0
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "[*] Killing old HTTPTunnel, stunnel, DNS2TCP and ptunnel listeners... (note: does not stop SSHD)"
killall ptunnel
killall stunnel
killall dns2tcpd
killall hts

