#!/bin/bash
export HOME=/root
set -e
cd /opt/fw/mu_platform_nxp
for d in MU_BASECORE Common/MU Common/MU_TIANO Common/MU_OEM_SAMPLE Silicon/ARM/MU_TIANO Silicon/ARM/NXP; do
  (cd "$d" && echo "snapshot" >> .git_snapshot_marker 2>/dev/null || true; git add -A -f . 2>/dev/null; git commit -q -m "snapshot2" 2>&1 | head -1 || true)
  echo "extra commit: $d"
done
echo "=== 根 git diff 检查（应为非空）==="
git diff | head -8
echo "DIFF_LINES=$(git diff | wc -l)"
