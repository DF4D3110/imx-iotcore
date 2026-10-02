#!/bin/bash
export HOME=/root
set -e
echo "=== 解压 optee_examples ==="
rm -rf /opt/fw/optee_examples
cd /opt/fw
unzip -q /mnt/d/firmware_src/optee_examples-3.3.0.zip
mv optee_examples-3.3.0 optee_examples
echo "=== hello_world/ta 结构 ==="
ls /opt/fw/optee_examples/hello_world/ta/
echo "=== 编译 hello_world TA ==="
cd /opt/fw/optee_examples/hello_world/ta
make TA_DEV_KIT_DIR=/opt/fw/optee_os/out/arm-plat-imx/export-ta_arm64 \
     TA_CROSS_COMPILE=/opt/fw/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu- 2>&1 | tail -10
echo "=== 产物 ==="
find /opt/fw/optee_examples -name "*.ta" 2>/dev/null
