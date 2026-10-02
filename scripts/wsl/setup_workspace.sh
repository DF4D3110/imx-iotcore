#!/bin/bash
# setup_workspace.sh - 从仓库 vendor/ 一键解压全部源码到 $FW_ROOT，准备可构建工作区
# 用法: wsl -d Debian --user root -- bash scripts/wsl/setup_workspace.sh [FW_ROOT]
# 环境: 需已安装 unzip；工具链若不在 $FW_ROOT/toolchain 会尝试链接 /opt/fw/toolchain 或提示
export FW_ROOT=${1:-/opt/fw}
export HOME=/root
set -e

# 仓库根 = scripts/wsl 的上级的上级
REPO_ROOT=$(cd "$(dirname "$0")/../.." && pwd)
VENDOR=$REPO_ROOT/vendor

echo "=== 准备构建工作区: $FW_ROOT ==="
mkdir -p "$FW_ROOT"

# 工具链
if [ ! -d "$FW_ROOT/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu" ]; then
  if [ -d /opt/fw/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu ]; then
    mkdir -p "$FW_ROOT/toolchain"
    ln -sfn /opt/fw/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu "$FW_ROOT/toolchain/"
    echo "toolchain: linked from /opt/fw/toolchain"
  else
    echo "!! 未找到工具链: 请按 README 解压 gcc-linaro-7.2.1 到 $FW_ROOT/toolchain/"
    echo "   (wsl_toolchain_install.sh 内含获取与校验步骤)"
  fi
else
  echo "toolchain: 已存在"
fi

# 主组件解压（zip 顶层同名目录 -> 规范名）
unzip_component() { # $1 zip glob, $2 dest name
  local z
  z=$(ls "$VENDOR"/$1 2>/dev/null | head -1)
  if [ -z "$z" ]; then echo "SKIP(no zip): $1"; return; fi
  rm -rf "$FW_ROOT/$2"
  mkdir -p "$FW_ROOT/$2"
  rm -rf /tmp/vendor_x && mkdir -p /tmp/vendor_x
  unzip -q -o "$z" -d /tmp/vendor_x
  cp -r /tmp/vendor_x/*/* "$FW_ROOT/$2/"
  rm -rf /tmp/vendor_x
  echo "unpacked: $2 <- $z"
}
unzip_component 'u-boot-imx*.zip' u-boot
unzip_component 'optee_os-imx*.zip' optee_os
unzip_component 'imx-atf-imx*.zip' imx-atf
unzip_component 'imx-mkimage-imx*.zip' imx-mkimage
unzip_component 'MU_PLATFORM_NXP*.zip' mu_platform_nxp
unzip_component 'MSRSec*.zip' MSRSec
unzip_component 'optee_examples*.zip' optee_examples

# imx-iotcore: 使用仓库内上游 build/firmware
mkdir -p "$FW_ROOT/imx-iotcore/build"
cp -r "$REPO_ROOT/build/firmware" "$FW_ROOT/imx-iotcore/build/firmware"
echo "imx-iotcore/build/firmware: copied from repo"

# firmware-imx-8.1 二进制（布局匹配 imx8.mk）
mkdir -p "$FW_ROOT/firmware-imx-8.1/firmware/ddr/synopsys"
mkdir -p "$FW_ROOT/firmware-imx-8.1/firmware/hdmi/cadence"
cp "$VENDOR/firmware-imx-8.1/lpddr4_pmu_train_1d_imem.bin" "$FW_ROOT/firmware-imx-8.1/firmware/ddr/synopsys/"
cp "$VENDOR/firmware-imx-8.1/lpddr4_pmu_train_1d_dmem.bin" "$FW_ROOT/firmware-imx-8.1/firmware/ddr/synopsys/"
cp "$VENDOR/firmware-imx-8.1/lpddr4_pmu_train_2d_imem.bin" "$FW_ROOT/firmware-imx-8.1/firmware/ddr/synopsys/"
cp "$VENDOR/firmware-imx-8.1/lpddr4_pmu_train_2d_dmem.bin" "$FW_ROOT/firmware-imx-8.1/firmware/ddr/synopsys/"
cp "$VENDOR/firmware-imx-8.1/signed_hdmi_imx8m.bin" "$FW_ROOT/firmware-imx-8.1/firmware/hdmi/cadence/"
cp "$VENDOR/firmware-imx-8.1/COPYING" "$FW_ROOT/firmware-imx-8.1/"
echo "firmware-imx-8.1: copied"

# MU 子模块归位（映射按 mu_platform_nxp/.gitmodules）
submodule_put() { # $1 submodule path, $2 zip glob
  local z subdir
  z=$(ls "$VENDOR"/$2 2>/dev/null | head -1)
  subdir="$FW_ROOT/mu_platform_nxp/$1"
  if [ -z "$z" ]; then echo "SKIP(no zip): $2"; return; fi
  rm -rf "$subdir"
  mkdir -p "$subdir"
  rm -rf /tmp/vendor_sm && mkdir -p /tmp/vendor_sm
  unzip -q -o "$z" -d /tmp/vendor_sm
  cp -r /tmp/vendor_sm/*/* "$subdir/"
  rm -rf /tmp/vendor_sm
  echo "submodule: $1 <- $z"
}
submodule_put 'Common/MU' 'mu_plus-*.zip'
submodule_put 'MU_BASECORE' 'mu_basecore-*.zip'
submodule_put 'Common/MU_TIANO' 'mu_tiano_plus-*.zip'
submodule_put 'Silicon/ARM/MU_TIANO' 'mu_silicon_arm_tiano-*.zip'
submodule_put 'Common/MU_OEM_SAMPLE' 'mu_oem_sample-*.zip'
submodule_put 'Silicon/ARM/NXP' 'MU_SILICON_NXP-*.zip'

# MSRSec external（ms-tpm-20-ref / wolfssl）
external_put() { # $1 external dir name, $2 zip glob
  local z exdir
  z=$(ls "$VENDOR"/$2 2>/dev/null | head -1)
  exdir="$FW_ROOT/MSRSec/external/$1"
  if [ -z "$z" ]; then echo "SKIP(no zip): $2"; return; fi
  rm -rf "$exdir"
  mkdir -p "$exdir"
  rm -rf /tmp/vendor_ext && mkdir -p /tmp/vendor_ext
  unzip -q -o "$z" -d /tmp/vendor_ext
  cp -r /tmp/vendor_ext/*/* "$exdir/"
  rm -rf /tmp/vendor_ext
  echo "external: $1 <- $z"
}
external_put 'ms-tpm-20-ref' 'ms-tpm-20-ref-*.zip'
external_put 'wolfssl' 'wolfssl-*.zip'

echo ""
echo "=== 工作区就绪: $FW_ROOT ==="
ls -d "$FW_ROOT"/*/ 2>/dev/null
