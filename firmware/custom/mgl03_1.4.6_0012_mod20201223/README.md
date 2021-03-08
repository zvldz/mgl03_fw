* Based on official 1.4.6_0012, modded by [@zvldz](https://github.com/zvldz)
* List of modifications:
  * enabled 'telnetd'
  * removes password if exists
  * mosquitto listens external interface (port openned)
  * run on startup '/data/run.sh'
  * added 'dropbear' (to start add in '/data/run.sh' line '/bin/dropbear -R -B')
  * replaced 'silabs_ncp_bt' with modified version (works without internet)
  * added 'sftp-server' for dropbear
  * added 'socat', 'ser2net', 'htop', 'tcpdump', 'ldd', 'strace', 'gdbserver'
  * created '/dev/tty' (some programs need it)
  * added '/usr/share/terminfo' (some programs need it)
  * added mod version to '/etc/rootfs_fw_info'
  * added greeting info (fw version, ip, mac, token and etc)
  * added '/data/bin' in $PATH and '/data/lib' in $LD_LIBRARY_PATH
  * created symlink '/.profile' to '/data/.profile (useful for alias and etc)