#!/bin/bash
export HOME=/root
export PIP_BREAK_SYSTEM_PACKAGES=1
TARGET_STEP="$1"
cd /opt/fw/imx-iotcore/build/firmware
TC=/opt/fw/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
echo "=== make $TARGET_STEP @ $(date) ==="
make -f imx8.mk IMX8_TARGET=NXPEVK_iMX8M_4GB CROSS_COMPILE=$TC HOSTCFLAGS=-fcommon "$TARGET_STEP" 2>&1 | tee /tmp/build_${TARGET_STEP}.log
echo "=== RC=$? @ $(date) ==="
