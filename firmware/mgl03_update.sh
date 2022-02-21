#!/bin/sh

clean_exit () {
    if [ -f /data/update.zip ]; then
        echo
        echo "* Cleaning temporary files"
        rm -vrf /data/update.zip
        exit
    fi
}

trap clean_exit EXIT SIGTERM SIGHUP SIGQUIT SIGILL SIGTRAP

echo "* Getting firmware list"

FW_URI_LIST=$(curl -s -k -o- "https://api.github.com/repos/zvldz/mgl03_fw/git/trees/main?recursive=1" | grep custom | grep mod | grep zip | sort | cut -f4 -d'"')
FW_URI_LIST_STOCK=$(curl -s -k -o- "https://api.github.com/repos/zvldz/mgl03_fw/git/trees/main?recursive=1" | grep stock | grep zip | sort | cut -f4 -d'"')
FW_URI_LIST="$FW_URI_LIST $FW_URI_LIST_STOCK"

if [ -z "$FW_URI_LIST" ]; then
    echo "! Cannot detect uri for firmware"
    exit 2
fi

echo
echo "For recommended firmware, see https://github.com/AlexxIT/XiaomiGateway3#supported-firmwares"

while : ; do
    COUNT=0
    STOCK=0

    echo
    echo "Available firmware:"
    echo "[0] Exit"

    echo "---------------- MOD ----------------"
    for FW_URI in $FW_URI_LIST; do
        if [ -z "${FW_URI##*stock*}" -a $STOCK -eq 0 ]; then
            STOCK=1
            echo "--------------- STOCK ---------------"
        fi

        COUNT=$(expr $COUNT + 1)

        if [ $COUNT -lt 10 ]; then
            echo -n "[${COUNT}]  "
        else
            echo -n "[${COUNT}] "
        fi

        echo $FW_URI | cut -d'/' -f4
    done

    echo
    echo -n "Please choose firmware: "
    read CHOICE

    expr 0 + $CHOICE > /dev/null 2>&1

    if [ $? -gt 1 ]; then
        echo "! Wrong choice"
        continue
    fi

    if [ $CHOICE -eq 0 ]; then
        echo "Exit !!!"
        exit 1
    fi

    for NUM in $(seq 1 $COUNT); do
        if [ $CHOICE -eq $NUM ]; then
            break 2
        fi
    done

    echo "! Wrong choice"
done

echo
echo
echo "* Trying to free up space in /data"
mkdir -p /data/firmware
FW_LOCKED=0

if [ -x /data/busybox ]; then
    LOCK_FW=$(/data/busybox lsattr /data/firmware.bin 2>/dev/null | grep "\-i-")
    if [ -n "$LOCK_FW" ]; then
        FW_LOCKED=1
    else
        LOCK_FW=$(/data/busybox lsattr /data/firmware/firmware_ota.bin 2>/dev/null | grep "\-i-")
        if [ -n "$LOCK_FW" ]; then
            FW_LOCKED=1
        fi
    fi

    if [ $FW_LOCKED -eq 1 ]; then
        /data/busybox chattr -i /data/firmware.bin /data/firmware/firmware_ota.bin > /dev/null 2>&1
    fi
fi

rm -f /data/firmware.bin /data/firmware/firmware_ota.bin > /dev/null 2>&1
touch /data/firmware.bin /data/firmware/firmware_ota.bin > /dev/null 2>&1
rm -f /data/root.bin /data/linux.bin /data/firmware/root.bin /data/firmware/linux.bin

if [ $FW_LOCKED -eq 1 ]; then
    /data/busybox chattr +i /data/firmware.bin /data/firmware/firmware_ota.bin > /dev/null 2>&1
fi

FW_URI=$(echo $FW_URI_LIST | cut -d' ' -f$CHOICE)

FW_URL="https://raw.githubusercontent.com/zvldz/mgl03_fw/main/${FW_URI}"

CONTENT_LENGTH=$(curl -s -I -L -k $FW_URL | grep Content-Length | cut -f2 -d' ' | tr -d "\n\r")

if [ -z "$CONTENT_LENGTH" ] || [ $CONTENT_LENGTH -lt 1024 ]; then
    echo "! Cannot get Content-Length for firmware file"
    echo "! Check network connection"
    exit 3
fi

echo
echo "* Downloading ..."
curl -L -k -o /data/update.zip $FW_URL

FW_SIZE=$(wc -c /data/update.zip | cut -f1 -d' ')

echo
echo "* Content-Length: $CONTENT_LENGTH"
echo "* Firmware size: $FW_SIZE"

if [ "$CONTENT_LENGTH" != "$FW_SIZE" ]; then
    echo "! Incorrect firmware size"
    echo "! Check free space in /data"
    exit 4
fi

echo "* Firmware size is correct"
echo "* Unpacking ..."
rm -rf /tmp/*.bin /tmp/*.gbl
unzip -o /data/update.zip -d /tmp/

if [ $? -ne 0 ]; then
    echo "! Error when unpacking firmware"
    exit 5
fi

echo
echo "* Flashing BLE firmware"
BLE_VER=$(grep -oe '1\.[234]\..' /tmp/full*gbl | sed 's/\.//g')
if [ -z $BLE_VER ]; then
    echo "! BLE firmware version is not detected. Use 125."
    BLE_VER=123
fi
killall -q -9 gw3
run_ble_dfu.sh /dev/ttyS1 /tmp/full*gbl $BLE_VER 1

echo
echo "* Flashing kernel"
fw_update /tmp/linux_*

echo
echo "* Flashing root"
fw_update /tmp/root_*

echo
echo "*** Congratulations ***"
echo "Gateway will restart in 10 seconds"
sleep 10

rm -vrf /data/update.zip
reboot
