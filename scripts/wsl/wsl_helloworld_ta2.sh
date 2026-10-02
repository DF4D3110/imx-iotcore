#!/bin/bash
REPO_ROOT=$(cd "$(dirname "$0")/../.." && pwd)
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
set -e
echo "=== 解压 optee_examples ==="
rm -rf ${FW_ROOT}/optee_examples
cd ${FW_ROOT}
z=$(ls $REPO_ROOT/vendor/optee_examples*.zip | head -1)
unzip -q "$z"
mv optee_examples-3.3.0 optee_examples
echo "=== 编译 hello_world TA (CROSS_COMPILE_ta_arm64) ==="
cd ${FW_ROOT}/optee_examples/hello_world/ta
make TA_DEV_KIT_DIR=${FW_ROOT}/optee_os/out/arm-plat-imx/export-ta_arm64 \
     CROSS_COMPILE_ta_arm64=${FW_ROOT}/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu- 2>&1 | tail -12
RC=${PIPESTATUS[0]}
echo "make RC=$RC"
[ "$RC" -eq 0 ] || { echo "HelloWorld TA build FAILED"; exit 1; }
TA=$(find ${FW_ROOT}/optee_examples -name '*.ta' | head -1)
echo "=== 产物: $TA ==="
[ -n "$TA" ] || { echo "no .ta produced"; exit 1; }
echo "=== 归位到 OpteeClientPkg Bin ==="
DEST=${FW_ROOT}/mu_platform_nxp/Microsoft/OpteeClientPkg/Bin/HelloWorldTa/Arm64/Test
mkdir -p "$DEST"
cp "$TA" "$DEST/"
ls -la "$DEST"
