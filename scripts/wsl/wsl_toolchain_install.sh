#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
echo "=== 1. 工具链文件确认 ==="
ls -la ${TC_TAR:-/mnt/d/firmware_src/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz}
stat -c %s ${TC_TAR:-/mnt/d/firmware_src/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz}
echo "=== 2. 解压工具链 ==="
cd ${FW_ROOT}/toolchain
if [ ! -d gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu ]; then
  tar xf ${TC_TAR:-/mnt/d/firmware_src/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz} -C ${FW_ROOT}/toolchain
  echo "TAR_RC=$?"
fi
ls -d ${FW_ROOT}/toolchain/gcc-linaro-* 2>/dev/null
${FW_ROOT}/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc --version 2>&1 | head -1
echo "=== 3. NXP firmware ==="
ls ${FW_ROOT}/firmware-imx-8.1/firmware/ddr/synopsys/ 2>/dev/null | head -5
ls ${FW_ROOT}/firmware-imx-8.1/firmware/hdmi/cadence/ 2>/dev/null | head -5
echo "=== 4. 源码解压状态 ==="
for d in u-boot optee_os imx-atf imx-mkimage mu_platform_nxp MSRSec; do
  n=$(ls ${FW_ROOT}/$d 2>/dev/null | wc -l)
  echo "$d: $n items"
done
echo "--- mu_platform_nxp 子模块 ---"
ls -d ${FW_ROOT}/mu_platform_nxp/MU_* 2>/dev/null
echo "--- .gitmodules ---"
cat ${FW_ROOT}/mu_platform_nxp/.gitmodules 2>/dev/null | head -40
