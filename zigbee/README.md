# Updating zigbee firmware of mgl03 gateway via telnet for Zigbee2MQTT
Telnet must be opened on the gateway (via custom component from [@AlexxIT](https://github.com/AlexxIT/XiaomiGateway3/) or [php-miio](https://github.com/skysilver-lab/php-miio)/[python-miio](https://github.com/rytilahti/python-miio)).
You will need telnet client like putty or other.
You can find out IP of the gateway in MiHome or on your router.
Login - "admin", no password.

<img src="../media/screenshot_telnet1.png" width="400">

<img src="../media/screenshot_telnet2.png" width="400">

## The easy way
If you are using [Home Assistant](https://www.home-assistant.io/). You need to enable ZHA mode in the [XiaomiGateway3](https://github.com/AlexxIT/XiaomiGateway3) component and reboot gateway.

<img src="../media/screenshot_zigbee_z2m.png" width="400">

Open telnet session, connect to gateway and run commands:
```sh
wget -O /tmp/zigbee_flash_mgl03.zip "http://master.dl.sourceforge.net/project/mgl03/zigbee/zigbee_flash.zip?viasf=1" && unzip -o /tmp/zigbee_flash_mgl03.zip -d /tmp && cd /tmp && sh /tmp/mgl3_zigbee_flash.sh
```
You will need to select firmware version:
  * ncp-uart-sw_mgl03_6_7_8_z2m.gbl for Zigbee2MQTT
  * ncp-uart-sw_mgl03_6_6_2_stock.gbl for return to stock firmware

<img src="../media/screenshot_telnet_zigbee_fw.png" width="768">

If you see something like in screenshot, everything is ok - you have updated zigbee firmware and you can configure Zigbee2MQTT.

Example of part of the config for Zigbee2MQTT:
```yaml
serial:
    adapter: ezsp
    port: 'tcp://192.168.1.177:8888'
```
For addon, you need to configure adapter via UI.


Attention! Remember, once you've installed custom zigbee firmware, you will not be able to upgrade gateway via MiHome app. Only custom firmware upgrades are available in this case.


If you want to return to MiHome with gateway, you need to flash stock firmware (ncp-uart-sw_mgl03_6_6_2_stock.gbl) and turn off ZHA mode.


Script author **[@CODeRUS](https://github.com/CODeRUS)**

Firmware for Zigbee2MQTT complied by **Alexander Faronov**([@faronov](https://github.com/faronov))
