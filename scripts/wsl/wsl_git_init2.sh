#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
set -e
cd ${FW_ROOT}/mu_platform_nxp
for d in MU_BASECORE Common/MU Common/MU_TIANO Common/MU_OEM_SAMPLE Silicon/ARM/MU_TIANO Silicon/ARM/NXP; do
  (cd "$d" && git config user.email "build@local" 2>/dev/null; git config user.name "build" 2>/dev/null; git add -A -f . 2>/dev/null | head -1; git commit -q -m "snapshot" 2>&1 | head -1 || true)
  echo "committed: $d"
done
echo "=== 根 add + commit ==="
git add -f . 2>&1 | grep -vE "^warning|^hint" | head -5 || true
git commit -q -m "source snapshot" 2>&1 | head -2 || true
echo "=== git diff 子模块检查（STEP 2a 用）==="
git diff MU_BASECORE | head -3
echo "DIFF_RC=$?"
echo "=== submodule sync ==="
git submodule sync 2>&1 | head -3
echo "SYNC_RC=$?"
