* Based on official firmware
* List of modifications:
  * enabled 'telnetd'
  * disabled gen password
  * removes password if exists
  * mosquitto (MQTT broker) listens external interface (port openned)
  * run on startup '/data/run.sh'
  * added 'curl'
  * added 'dropbear' (to start add in '/data/run.sh' line '/bin/dropbear -R -B')
  * added 'sftp-server' for dropbear
  * added 'socat', 'ser2net', 'htop', 'tcpdump', 'ldd', 'strace', 'gdbserver'
  * created '/dev/tty' (some programs need it)
  * added '/usr/share/terminfo' (some programs need it)
  * added mod version to '/etc/rootfs_fw_info'
  * added greeting info (fw version, ip, mac, token and etc)
  * added '/data/bin' in $PATH and '/data/lib' in $LD_LIBRARY_PATH
  * created symlink '/.profile' to '/data/.profile (useful for alias and etc)
* 20210127
  * homekitserver patched to downgrade firmware
* 20210305
  * added 'nano', 'minicom', 'sx', 'sz', 'rx', 'rz'
* 20210309
  * added 'file'
* 20230517
  * patch for mosquitto 2.0.15
