#!/bin/bash
export HOME=/root
F=/opt/fw/mu_platform_nxp/MU_BASECORE/BaseTools/Source/Python/AutoGen/UniClassObject.py
echo "=== ucs-2/ucs-4 出现位置 ==="
grep -n "ucs-2\|ucs-4" $F
cp $F $F.bak
sed -i "s/codecs.lookup('ucs-2')/codecs.lookup('utf-16')/g; s/codecs.lookup('ucs-4')/codecs.lookup('utf-32')/g" $F
echo "=== 修改后 ==="
grep -n "utf-16\|utf-32" $F | head -5
