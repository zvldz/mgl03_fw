# Updating zigbee firmware of mgl03 gateway via telnet for Zigbee2MQTT
Telnet must be opened on the gateway (via custom component from [@AlexxIT](https://github.com/AlexxIT/XiaomiGateway3/) or [php-miio](https://github.com/skysilver-lab/php-miio)/[python-miio](https://github.com/rytilahti/python-miio)).
You need telnet client like putty or other.
You can find out IP of the gateway in MiHome or on your router.
Login - "admin", no password.

<img src="../media/screenshot_telnet1.png" width="400">

<img src="../media/screenshot_telnet2.png" width="400">

# The easy way
If you are using [Home Assistant](https://www.home-assistant.io/). You need to enable ZHA mode in the [XiaomiGateway3](https://github.com/AlexxIT/XiaomiGateway3) component.

<img src="../media/screenshot_zigbee_z2m.png" width="400">

Go to telnet session on gateway and run commands:
```sh
wget -O /tmp/curl "http://master.dl.sourceforge.net/project/mgl03/bin/curl?viasf=1" && chmod +x /tmp/curl
export PATH="$PATH:/tmp"
curl -k -o /tmp/zigbee_flash_mgl03.zip https://raw.githubusercontent.com/zvldz/mgl03_fw/main/zigbee/zigbee_flash.zip && unzip -o /tmp/zigbee_flash_mgl03.zip -d /tmp && cd /tmp && sh /tmp/mgl3_zigbee_flash.sh
```
You will need to select firmware version:
  * ncp-uart-sw_mgl03_6_7_8_z2m.gbl for Zigbee2MQTT
  * ncp-uart-sw_mgl03_6_6_2_stock.gbl for return to stock firmware

<img src="../media/screenshot_telnet_zigbee_fw.png" width="768">

If you see something like in screenshot, all is ok - you have updated zigbee firmware and you can configure Zigbee2MQTT.


Script author @CODeRUS

Made firmware for Zigbee2MQTT by Alexander Faronov
