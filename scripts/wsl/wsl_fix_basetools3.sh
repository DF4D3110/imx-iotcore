#!/bin/bash
export HOME=/root
F=/opt/fw/mu_platform_nxp/MU_BASECORE/BaseTools/Source/C/Makefiles/header.makefile
cp $F $F.bak3
sed -i 's/-Wno-array-bounds -nostdlib/-Wno-array-bounds -Wno-dangling-pointer -Wno-stringop-overread -Wno-overflow -nostdlib/g' $F
grep -n "BUILD_CFLAGS =" $F | head -2
