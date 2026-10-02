#!/bin/bash
export HOME=/root
F=/opt/fw/optee_os/scripts/gen_hashed_bin.py
cp $F $F.bak
python3 - "$F" <<'EOF'
import sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
old = "hash_size          = paged_input_size / (4 * 1024) * \\"
new = "hash_size          = paged_input_size // (4 * 1024) * \\"
if old in s:
    s = s.replace(old, new)
    open(p, 'w', encoding='utf-8').write(s)
    print("FIXED: // 整数除法")
else:
    print("PATTERN NOT FOUND")
EOF
python3 -m py_compile $F && echo "COMPILE OK"
