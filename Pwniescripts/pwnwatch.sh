#!/bin/bash
# This script displays established IPv4 connections from Pwnie Express
# --------------------------------------------------------------------------
# Copyright (c) 2011 Security Generation <http://www.securitygeneration.com>
# This script is licensed under GNU GPL version 2.0
# --------------------------------------------------------------------------
# This script is part of PwnieScripts shell script collection
# Visit http://www.securitygeneration.com/security/pwniescripts-for-pwnie-express/
# for more information.
# --------------------------------------------------------------------------

if [ "$1" == "-h" ]; then
	echo "pwnwatch monitors for incoming connections from Pwnie Express."
	exit 0
fi

watch -d "netstat -lntup4 | grep 'pwn' | grep 333"
