#!/bin/bash
export HOME=/root
cd /opt/fw/mu_platform_nxp/MU_BASECORE/BaseTools/Source/Python
echo "=== 所有 fromstring 位置 ==="
grep -rn "\.fromstring(" . 2>/dev/null | grep -v ".bak" | head -20
echo "=== 替换 ==="
for f in $(grep -rln "\.fromstring(" . 2>/dev/null | grep -v ".bak"); do
  cp $f $f.bak2
  sed -i 's/\.fromstring(/.frombytes(/g' $f
  echo "已替换: $f"
done
echo "=== 剩余 fromstring ==="
grep -rn "\.fromstring(" . 2>/dev/null | grep -v ".bak" | head
