#!/bin/sh
# This script executes commands on a USB stick and outputs the results to a logfile.
# --------------------------------------------------------------------------
# Copyright (c) 2015 Security Generation <http://www.securitygeneration.com>
# This script is licensed under GNU GPL version 2.0
# --------------------------------------------------------------------------
# Visit http://www.securitygeneration.com/security/pwn-plug-command-execution-using-usb-sticks
# for more information.
# --------------------------------------------------------------------------

# Enter a secret or leave blank (ie. "").
secret="changeme";

# first wait for drive to be automounted
/bin/sleep 3;

# add separator to log
/bin/echo "--------- $(date) ---------" >> /var/autofs/removable/cmdusb/log.txt; 

# is a secret required?
if [ "$secret" != "" ]; then
        # check secret file exists on drive
        if [ -f /var/autofs/removable/cmdusb/secret ]; then
                # check secret in file matches secret above
                if [ "$secret" = $(/usr/bin/head -n 1 /var/autofs/removable/cmdusb/secret) ]; then
                        /bin/sh /var/autofs/removable/cmdusb/command.sh >> /var/autofs/removable/cmdusb/log.txt;
                else
                        /bin/echo "Incorrect secret!" >> /var/autofs/removable/cmdusb/log.txt;
                fi
        else
                /bin/echo "Missing secret file!" >> /var/autofs/removable/cmdusb/log.txt;
        fi
else

# no secret
/bin/sh /var/autofs/removable/cmdusb/command.sh >> /var/autofs/removable/cmdusb/log.txt;

fi