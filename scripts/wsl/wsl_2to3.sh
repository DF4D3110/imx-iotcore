#!/bin/bash
export HOME=/root
cd /opt/fw/optee_os/scripts
echo "=== 2to3 可用性 ==="
which 2to3 2>/dev/null || python3 -m lib2to3 --help 2>&1 | head -1
echo "=== 转换前大小 ==="
wc -l gen_ld_sects.py ta_bin_to_c.py
echo "=== 备份 + 转换 ==="
cp gen_ld_sects.py gen_ld_sects.py.bak
cp ta_bin_to_c.py ta_bin_to_c.py.bak
if which 2to3 >/dev/null 2>&1; then
  2to3 -w gen_ld_sects.py ta_bin_to_c.py 2>&1 | tail -5
else
  python3 -m lib2to3 -w gen_ld_sects.py ta_bin_to_c.py 2>&1 | tail -5
fi
echo "=== py3 验证 ==="
python3 -m py_compile gen_ld_sects.py && echo "gen_ld_sects OK"
python3 -m py_compile ta_bin_to_c.py && echo "ta_bin_to_c OK"
