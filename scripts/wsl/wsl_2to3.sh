#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd ${FW_ROOT}/optee_os/scripts
echo "=== 2to3 可用性 ==="
HAS_2TO3=0
if which 2to3 >/dev/null 2>&1 || python3 -m lib2to3 --help >/dev/null 2>&1; then
  HAS_2TO3=1
  echo "lib2to3 available"
else
  echo "lib2to3 NOT available (Debian Python 3.13), fallback to repo-fixed py3 files"
fi
echo "=== 转换 ==="
if [ "$HAS_2TO3" = "1" ]; then
  cp gen_ld_sects.py gen_ld_sects.py.bak
  cp ta_bin_to_c.py ta_bin_to_c.py.bak
  if which 2to3 >/dev/null 2>&1; then
    2to3 -w gen_ld_sects.py ta_bin_to_c.py 2>&1 | tail -3
  else
    python3 -m lib2to3 -w gen_ld_sects.py ta_bin_to_c.py 2>&1 | tail -3
  fi
else
  cp "${SCRIPT_DIR}/gen_ld_sects.py" ./gen_ld_sects.py
  cp "${SCRIPT_DIR}/ta_bin_to_c.py" ./ta_bin_to_c.py
  echo "overwritten with repo py3 fixed versions"
fi
echo "=== py3 验证 ==="
python3 -m py_compile gen_ld_sects.py && echo "gen_ld_sects OK"
python3 -m py_compile ta_bin_to_c.py && echo "ta_bin_to_c OK"
