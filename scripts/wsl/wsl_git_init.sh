#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
set -e
cd ${FW_ROOT}/mu_platform_nxp
echo "=== 初始化根仓库 ==="
git init -q 2>&1 | head -2 || true
git config user.email "build@local" 2>/dev/null || true
git config user.name "build" 2>/dev/null || true
echo "=== 初始化 6 个子模块仓库 ==="
for d in MU_BASECORE Common/MU Common/MU_TIANO Common/MU_OEM_SAMPLE Silicon/ARM/MU_TIANO Silicon/ARM/NXP; do
  (cd "$d" && git init -q 2>&1 | head -1 || true)
  echo "init: $d"
done
echo "=== 登记 gitlink ==="
git add -f . 2>&1 | grep -v "^warning" | head -5 || true
git commit -q -m "source snapshot" 2>&1 | head -2 || true
echo "=== git submodule sync 测试 ==="
git submodule sync 2>&1 | head -3
echo "SYNC_RC=$?"
