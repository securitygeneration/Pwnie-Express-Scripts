```
 __                           _  _          
/ _\  ___   ___  _   _  _ __ (_)| |_  _   _ 
\ \  / _ \ / __|| | | || '__|| || __|| | | |
_\ \|  __/| (__ | |_| || |   | || |_ | |_| |
\__/ \___| \___| \__,_||_|   |_| \__| \__, |
                                      |___/ 

   ___                                _    _               
  / _ \ ___  _ __    ___  _ __  __ _ | |_ (_)  ___   _ __  
 / /_\// _ \| '_ \  / _ \| '__|/ _` || __|| | / _ \ | '_ \ 
/ /_\\|  __/| | | ||  __/| |  | (_| || |_ | || (_) || | | |
\____/ \___||_| |_| \___||_|   \__,_| \__||_| \___/ |_| |_|
```

http://www.securitygeneration.com - @securitygen

PwnieScripts
===

From: http://www.securitygeneration.com/security/pwniescripts-for-pwnie-express/

PwnieScripts is a collection of simple bash scripts intended to simplify/automate the setup and use of the Pwnie Express PwnPlugs (http://pwnieexpress.com). The scripts are intended for use with, and have been tested on BackTrack 5. These could also be made to work on BackTrack 4 and other distros with very few changes.

Here is a list of each script and the functions it performs, in order of use:

- pwnsetup.sh: Automates the PwnPlug setup process by enabling SSHD, generating SSH keys, creating a 'pwnplug' user, installing HTTPTunnel, generating an SSL certificate, configuring stunnel, and configuring DNS2TCP.

- pwnstart.sh: Kills any existing listeners, and then starts SSHD as well as new HTTPTunnel, stunnel (SSL tunnel), DNS2TCP (DNS tunnel) and ptunnel (ICMP tunnel) listeners.

- pwnwatch.sh: One-line script to monitor netstat for incoming connections from a PwnPlug.

- pwnconnect.sh: aka. the Lazy Script - initiates an SSH connection to the first available established connection from a PwnPlug, so you don't have to check which ones are active. It'll use the more secure/relible ones first (SSL, HTTP) where available. Use the -t flag to only connect over Tor (Note: for this option you'll need to have configured your PwnPlug to connect back over Tor, see: http://www.securitygeneration.com/security/reverse-ssh-over-tor-on-the-pwnie-express/).

- pwnstop.sh: Kills all existing HTTPTunnel, stunnel, DNS2TCP and ptunnel processses.

You may need to 'chmod a+x' these scripts for them to run.

Changelog -

- 0.1: Initial release.
- 0.2: Minor updates to coincide with PwnPlug software v1.1. pwnconnect.sh now disables StrictHostKeyChecking for SSH connections.
