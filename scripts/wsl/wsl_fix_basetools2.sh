#!/bin/bash
export HOME=/root
F=/opt/fw/mu_platform_nxp/MU_BASECORE/BaseTools/Source/C/Makefiles/header.makefile
cp $F $F.bak2
sed -i 's/-Wno-vla-parameter -nostdlib/-Wno-vla-parameter -Wno-use-after-free -Wno-maybe-uninitialized -Wno-array-bounds -nostdlib/g' $F
echo "=== 验证 ==="
grep -n "BUILD_CFLAGS =" $F | head -2
