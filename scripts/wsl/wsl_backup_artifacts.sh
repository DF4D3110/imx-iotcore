#!/bin/bash
export HOME=/root
DEST=/mnt/d/firmware_build/artifacts
mkdir -p $DEST/BootLoader $DEST/BootFirmware
echo "=== 备份关键产物 ==="
cp /opt/fw/imx-mkimage/iMX8M/flash.bin $DEST/BootLoader/flash.bin && echo "flash.bin OK: $(stat -c%s $DEST/BootLoader/flash.bin) bytes"
cp /opt/fw/u-boot/u-boot.bin $DEST/u-boot.bin && echo "u-boot.bin OK: $(stat -c%s $DEST/u-boot.bin) bytes"
cp /opt/fw/u-boot/spl/u-boot-spl.bin $DEST/u-boot-spl.bin && echo "u-boot-spl.bin OK"
cp /opt/fw/imx-atf/build/imx8mq/release/bl31.bin $DEST/bl31.bin && echo "bl31.bin OK: $(stat -c%s $DEST/bl31.bin) bytes"
cp /opt/fw/optee_os/out/arm-plat-imx/tee.bin $DEST/tee.bin && echo "tee.bin OK: $(stat -c%s $DEST/tee.bin) bytes"
echo "=== 文件清单 ==="
ls -la $DEST
