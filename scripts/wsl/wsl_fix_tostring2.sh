#!/bin/bash
export HOME=/root
cd /opt/fw/mu_platform_nxp/MU_BASECORE/BaseTools/Source/Python
for f in GenFds/GenFdsGlobalVariable.py Eot/EotMain.py; do
  cp $f $f.bak
  sed -i 's/\.tostring()/.tobytes()/g' $f
  echo "$f 已替换: $(grep -c '\.tobytes()' $f) 处"
done
echo "=== 全局剩余 tostring ==="
grep -rn "\.tostring()" . 2>/dev/null | grep -v ".bak" | head
