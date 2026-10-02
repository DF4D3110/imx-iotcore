#!/bin/bash
export HOME=/root
F=/opt/fw/mu_platform_nxp/MU_BASECORE/BaseTools/Source/C/Makefiles/header.makefile
cp $F $F.bak
sed -i 's/-Wno-unused-result -nostdlib/-Wno-unused-result -Wno-vla-parameter -nostdlib/g' $F
echo "=== 验证 ==="
grep -n "BUILD_CFLAGS" $F
