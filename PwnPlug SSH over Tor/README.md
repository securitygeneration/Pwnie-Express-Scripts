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


http://www.securitygeneration.com - @securitygen

Reverse SSH over Tor on the Pwnie Express
===

http://www.securitygeneration.com/security/reverse-ssh-over-tor-on-the-pwnie-express/

These files are to be used in conjunction with the tutorial found at the URL above. They enable the Pwnie Express PwnPlug to make reverse SSH connections over Tor. Simply move these files into place at their respective locations:

/var/pwnplug/plugui/app.rb  
/var/pwnplug/plugui/methods.rb
/var/pwnplug/plugui/views/script_form.erb
/var/pwnplug/plugui/views/system.erb
/var/pwnplug/script_configs/reverse_ssh_over_Tor_config.sh
/var/pwnplug/scripts/reverse_ssh_over_Tor.sh

You may need to 'chmod a+x' the two ".sh" scripts for them to run. Don't forget to reboot your Pwnie after moving these files into place.

Changelog -

- 0.1: Initial release.

