#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
export PIP_BREAK_SYSTEM_PACKAGES=1
TARGET_STEP="$1"
cd ${FW_ROOT}/imx-iotcore/build/firmware
TC=${FW_ROOT}/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
echo "=== make $TARGET_STEP @ $(date) ==="
make -f imx8.mk IMX8_TARGET=NXPEVK_iMX8M_4GB CROSS_COMPILE=$TC HOSTCFLAGS=-fcommon "$TARGET_STEP" 2>&1 | tee /tmp/build_${TARGET_STEP}.log
RC=${PIPESTATUS[0]}
echo "=== RC=$RC @ $(date) ==="
exit $RC
