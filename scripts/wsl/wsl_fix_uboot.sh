#!/bin/bash
# wsl_fix_uboot.sh - 应用 U-Boot 源码修补（mkimage FIT 签名 + dtc cpp include）
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
UB=${FW_ROOT}/u-boot
echo "=== 1) defconfig: FIT 签名 4 行 ==="
if grep -q "CONFIG_FIT_SIGNATURE=y" "$UB/configs/imx8mq_evk_nt_defconfig"; then
  echo "already applied"
else
  printf '\nCONFIG_FIT_SIGNATURE=y\nCONFIG_RSA=y\nCONFIG_RSA_VERIFY=y\n' >> "$UB/configs/imx8mq_evk_nt_defconfig"
  echo "appended"
fi
tail -5 "$UB/configs/imx8mq_evk_nt_defconfig"

echo "=== 2) Makefile.lib: dtc #include 走 cpp ==="
grep -n 'echo .\\#include' "$UB/scripts/Makefile.lib" || echo "pattern not found (check)"
sed -i "s|echo '\\\\#include|echo '#include|" "$UB/scripts/Makefile.lib"
grep -n 'echo #include' "$UB/scripts/Makefile.lib"

echo "=== 完成（HOSTCFLAGS=-fcommon 由 wsl_build_step.sh 传入）==="
