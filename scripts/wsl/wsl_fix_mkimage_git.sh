#!/bin/bash
export HOME=/root
F=/opt/fw/imx-mkimage/Makefile
cp $F $F.bak
# 替换 git rev-parse 行为固定版本字符串（zip 无 .git）
sed -i 's|@git rev-parse --short=8 HEAD >> src/build_info.h|@echo -n '"'"'4d14f98a'"'"' >> src/build_info.h|' $F
echo "=== 修改后 40-44 行 ==="
sed -n '40,44p' $F
