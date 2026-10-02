#!/bin/bash
export HOME=/root
echo "=== 1. 工具链文件确认 ==="
ls -la /mnt/d/firmware_src/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz
stat -c %s /mnt/d/firmware_src/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz
echo "=== 2. 解压工具链 ==="
cd /opt/fw/toolchain
if [ ! -d gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu ]; then
  tar xf /mnt/d/firmware_src/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz -C /opt/fw/toolchain
  echo "TAR_RC=$?"
fi
ls -d /opt/fw/toolchain/gcc-linaro-* 2>/dev/null
/opt/fw/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc --version 2>&1 | head -1
echo "=== 3. NXP firmware ==="
ls /opt/fw/firmware-imx-8.1/firmware/ddr/synopsys/ 2>/dev/null | head -5
ls /opt/fw/firmware-imx-8.1/firmware/hdmi/cadence/ 2>/dev/null | head -5
echo "=== 4. 源码解压状态 ==="
for d in u-boot optee_os imx-atf imx-mkimage mu_platform_nxp MSRSec; do
  n=$(ls /opt/fw/$d 2>/dev/null | wc -l)
  echo "$d: $n items"
done
echo "--- mu_platform_nxp 子模块 ---"
ls -d /opt/fw/mu_platform_nxp/MU_* 2>/dev/null
echo "--- .gitmodules ---"
cat /opt/fw/mu_platform_nxp/.gitmodules 2>/dev/null | head -40
