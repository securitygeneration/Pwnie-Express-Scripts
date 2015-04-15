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

Pwn Plug Command Execution Using USB Sticks
===

http://www.securitygeneration.com/security/pwn-plug-command-execution-using-usb-sticks/

These files are to be used in conjunction with the tutorial found at the URL above. They allow you to run commands on the Pwnie Express PwnPlug by simply inserting a pre-configured USB stick.

## Instructions

1. Format a USB stick with an ext3 filesystem. Note: format the entire device (sda, sdb) and not just a partition (sda1, sdb1):

  ```shell
  mkfs.ext3 /dev/sda (change this to your correct device)
  ```
2. On your PwnPlug, install udev and autofs:

  ```shell
  apt-get update && apt-get install udev autofs
  ```
3. Edit /etc/auto.master and append the following line:

  ```shell
  /var/autofs/removable /etc/auto.removable --timeout=2
  ```
4. Create /etc/auto.removable and copy in the following line:

  ```shell
  cmdusb -fstype=ext3 :/dev/cmdusb
  ```
5. Create /etc/udev/rules.d/custom.rules and add the following line:

  ```shell
  KERNEL=="sd?", SUBYSTEM=="usb", ATTRS{model}=="*", SYMLINK+="cmdusb%n", RUN+="/bin/sh /usr/local/bin/cmdusb.sh"
  ```

  *Side note: If you want to only allow one specific USB drive to be used to run commands, enter your USB device’s model into the ATTRS{model} value above (instead of the wildcard). You can obtain your USB stick’s ID by running the following command (it’ll look something like: ATTRS{model}==”Flash Disk“), make sure your correct device is used (sda or sdb):
  ```shell
  udevadm info -a -p /sys/block/sda | grep model
  ```
6. Copy the [cmdusb.sh](cmdusb.sh) script to /usr/local/bin/cmdusb.sh, and edit it to set a custom long secret value (if required). Setting a secret will require that secret value to be present in a file called ‘secret’ in the root of the USB drive, otherwise commands will not be executed.

7. Set correct permissions on cmdusb.sh:

```shell
chmod a+x /usr/local/bin/cmdusb.sh
```
8. Restart autofs and udev:

```shell
/etc/init.d/autofs restart && /etc/init.d/udev restart
```

## Setting up the USB stick
Commands to be executed must be placed in a bash file called ‘command.sh’ in the root of the USB drive. Make sure that command.sh begins with “#!/bin/sh”, and then place one command on each line (also best to end each line with a semicolon). You must use the full path to executables and files in command.sh, so for ifconfig you would have to enter '/sbin/ifconfig'. You may need to ‘chmod a+x command.sh’ as well.

If you set a secret in cmdusb.sh above (“changeme” by default), then you will need to place the same value in a file called ‘secret’ in the root of the USB drive.

Once you’re all set, just plug the USB stick in, wait 10 seconds or so (plus however long you expect your commands to take), then unplug it. Any output from the command(s) will be piped into a file called ‘log.txt’, which you can read by plugging it into your computer. Note your computer will need to be able to read the ext3 filesystem to mount the USB drive, so use Linux or install OSXFuse and fuse-ext2 on Mac OS X.

Changelog -

- 0.1: Initial release.

