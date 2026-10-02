#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
cd ${FW_ROOT}/mu_platform_nxp/MU_BASECORE/BaseTools/Source/Python
echo "=== 所有 .tostring 出现位置 ==="
grep -rn "\.tostring()" Common/Misc.py | head -5
cp Common/Misc.py Common/Misc.py.bak
sed -i 's/\.tostring()/.tobytes()/g' Common/Misc.py
echo "=== 替换后 ==="
grep -rn "\.tobytes()" Common/Misc.py | head -5
echo "=== 其他文件残留 tostring ==="
grep -rln "\.tostring()" . 2>/dev/null | head
