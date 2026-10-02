#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
F=${FW_ROOT}/mu_platform_nxp/MU_BASECORE/BaseTools/Source/C/Makefiles/header.makefile
cp $F $F.bak
sed -i 's/-Wno-unused-result -nostdlib/-Wno-unused-result -Wno-vla-parameter -nostdlib/g' $F
echo "=== 验证 ==="
grep -n "BUILD_CFLAGS" $F
