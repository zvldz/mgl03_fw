# Updating mgl03 gateway firmware from telnet
Telnet must be opened on the gateway (via custom component from [@AlexxIT](https://github.com/AlexxIT/XiaomiGateway3/) or php-miio/python-miio).
You need telnet client like putty or other.
You can find out IP of the gateway in MiHome or on your router.
Login - "admin", no password.

<img src="../media/screenshot_telnet1.png" width="400">

<img src="../media/screenshot_telnet2.png" width="400">

# The easy way
Go to telnet session on gateway and run commands:
#### main command
```sh
curl -s -k -L -o /tmp/update.sh https://github.com/zvldz/mgl03_fw/raw/master/firmware/mgl03_update.sh && sh /tmp/update.sh
```

If there is no curl in firmware, command will run with error:
```
-sh: curl: not found
```
To download curl, run following commands:
```sh
wget -O /tmp/wget http://pkg.musl.cc/wget/mipsel-linux-musln32/bin/wget && chmod +x /tmp/wget
/tmp/wget -O /tmp/curl http://mipsel.vacuumz.info/files/curl && chmod +x /tmp/curl && rm -rf /tmp/wget
export PATH="$PATH:/tmp"
```
The 'pkg.musl.cc' site may not work.
Then there will be an error:
```
Resolving pkg.musl.cc (pkg.musl.cc)... 104.232.42.245
Connecting to pkg.musl.cc (pkg.musl.cc)|104.232.42.245|:80... failed: Connection refused.
```
In this case, try command:
```
printf 'GET /files/curl HTTP/1.1\r\nHost: mipsel-ssl.vacuumz.info\r\nUser-Agent: Wget/1.20.3\r\nConnection: close\r\n\r\n' | openssl s_client -quiet -tls1_1 -connect mipsel-ssl.vacuumz.info:443 -servername mipsel-ssl.vacuumz.info | sed '/alt-svc.*/d' | tail -n +19 > /tmp/curl && chmod +x /tmp/curl
export PATH="$PATH:/tmp"
```
or
```
wget http://pkg.simple-ha.ru/mipsel/curl -O /tmp/curl && chmod +x /tmp/curl
export PATH="$PATH:/tmp"
```
[Then run first command again.](#main-command)


You will need to select firmware version.

If you are using the [XiaomiGateway3](https://github.com/AlexxIT/XiaomiGateway3) component.
For recommended firmware, see [https://github.com/AlexxIT/XiaomiGateway3/wiki](https://github.com/AlexxIT/XiaomiGateway3/wiki).

<img src="../media/screenshot_telnet_script.png" width="768">

If you see something like in screenshot, all is ok - you have updated gateway.
If you used putty, window will close after rebooting gateway. Make sure there are no errors.

In case of major changes between versions of updated firmware, you will most likely need to reset gateway.

You don't need to read any more.

# The hard way (way of the warrior)

## Turning on ftp
### Via custom_component from [@AlexxIT](https://github.com/AlexxIT/XiaomiGateway3/)
Go to "Developer Tools/SERVICES" in Home Assistant.

And run service:
```
Service: remote.send_command
Entity: remote.0x680ae2fffe266ed5_pair (for example)

Service Data (YAML, optional):
entity_id: remote.0x680ae2fffe266ed5_pair
command: ftp
```
<img src="../media/screenshot_ha.png" width="400">

### Manual mode
To start the ftp-server you need to log into gateway via telnet and execute the commands:
```sh
curl -k -o /data/busybox https://busybox.net/downloads/binaries/1.21.1/busybox-mipsel && chmod +x /data/busybox
/data/busybox tcpsvd -vE 0.0.0.0 21 /data/busybox ftpd -w &
```

<img src="../media/screenshot_telnet3.png" width="758">

## Copying files via ftp to gateway
Download modified firmware from [firmware folder](https://github.com/serrj-sv/lumi.gateway.mgl03/tree/main/firmware/custom).

If you are using the [XiaomiGateway3](https://github.com/AlexxIT/XiaomiGateway3) component.
For recommended firmware, see [https://github.com/AlexxIT/XiaomiGateway3/wiki](https://github.com/AlexxIT/XiaomiGateway3/wiki).

For example [mgl03_1.4.7_0065_mod20201211.zip](https://github.com/serrj-sv/lumi.gateway.mgl03/blob/main/firmware/custom/mgl03_1.4.7_0065_mod20201211/mgl03_1.4.7_0065_mod20201211.zip).

Unzip archive mgl03_1.4.7_0065_mod20201211.zip.

You need ftp client like "FileZilla/WinSCP/Total Commander" etc.

Copy files linux_1.4.7_0065.bin and root_1.4.7_0065_mod20201211.bin to gateway folder /tmp.

Copy file full_ble_1.4.7_0065.gbl with filename full.gbl to /data/firmware (directory /data/firmware needs to be created).
In firmware 1.4.6 use /data path.

## Starting update
Go back to telnet session on gateway and run commands:
```sh
fw_update /tmp/linux_1.4.7_0065.bin
fw_update /tmp/root_1.4.7_0065_mod20201211.bin
reboot
```

<img src="../media/screenshot_telnet4.png" width="677">

After first reboot, gateway will reboot again to update ble firmware.
If you want to make sure if ble firmware has been updated, check for /data/firmware/full.gbl file, it should not exist.
If not, you can update the BLE firmware manually.
```sh
run_ble_dfu.sh /dev/ttyS1 /data/firmware/full.gbl 123 1
```

All copied files will be deleted automatically.

In case of major changes between versions of updated firmware, you will most likely need to reset gateway.

