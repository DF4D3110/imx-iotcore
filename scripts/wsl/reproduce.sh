#!/bin/bash
# reproduce.sh - 一键复现：vendor 解压 -> 修补 -> 固件全链 -> 验证产物
# 用法: wsl -d Debian --user root -- bash scripts/wsl/reproduce.sh [FW_ROOT]
# 前置: 工具链已按 README 就位（wsl_toolchain_install.sh）；WSL 需 Debian、unzip、pip
export FW_ROOT=${1:-/opt/fw}
export HOME=/root
set -e
S=$(cd "$(dirname "$0")" && pwd)

echo "=== 1/6 解压 vendor 源码 ==="
bash "$S/setup_workspace.sh" "$FW_ROOT"

echo "=== 2/6 应用源码修补 ==="
for p in wsl_fix_hashdiv.sh wsl_2to3.sh wsl_crypto_fix.sh wsl_tpm_prep.sh \
         wsl_wolf_link.sh wsl_vendor_fix.sh wsl_fix_mkimage_git.sh \
         wsl_fix_buildinfo.sh wsl_fix_uboot.sh; do
  echo "-- $p"; bash "$S/$p" || { echo "$p FAILED"; exit 1; }
done

echo "=== 3/6 imx8_optee（生成 export-ta）==="
bash "$S/wsl_build_step.sh" imx8_optee || { echo "imx8_optee FAILED"; exit 1; }

echo "=== 4/6 HelloWorld TA 编译归位 ==="
bash "$S/wsl_helloworld_ta2.sh"

echo "=== 5/6 imx8_tas + imx8_mkimage ==="
for t in imx8_tas imx8_mkimage; do
  echo "-- $t"; bash "$S/wsl_build_step.sh" "$t" || { echo "$t FAILED"; exit 1; }
done

echo "=== 6/6 UEFI 环境修补 + git 骨架 + imx8_uefi ==="
for p in wsl_pip_setuptools.sh wsl_pycrypto.sh wsl_imp_install.sh \
         wsl_fix_basetools.sh wsl_fix_basetools2.sh wsl_fix_basetools3.sh \
         wsl_fix_ucs.sh wsl_fix_tostring.sh wsl_fix_tostring2.sh wsl_fix_fromstring.sh \
         wsl_git_init.sh wsl_git_init2.sh wsl_git_init3.sh; do
  echo "-- $p"; bash "$S/$p" || { echo "$p FAILED"; exit 1; }
done

echo "=== 7/6 imx8_uefi ==="
bash "$S/wsl_build_step.sh" imx8_uefi || { echo "imx8_uefi FAILED"; exit 1; }

echo "=== 8/6 验证产物 ==="
ls -la "$FW_ROOT/imx-mkimage/iMX8M/flash.bin"
ls -la "$FW_ROOT/mu_platform_nxp/Build/MCIMX8M_EVK_4GB/RELEASE_GCC5/FV/uefi.fit"
sha256sum "$FW_ROOT/imx-mkimage/iMX8M/flash.bin" \
          "$FW_ROOT/mu_platform_nxp/Build/MCIMX8M_EVK_4GB/RELEASE_GCC5/FV/uefi.fit"
echo "REPRODUCE DONE"
