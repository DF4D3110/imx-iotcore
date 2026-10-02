#!/bin/bash
export HOME=/root
F=/opt/fw/MSRSec/TAs/optee_ta/fTPM/reference/include/VendorString.h
cp $F $F.bak
python3 - "$F" <<'EOF'
import sys, re
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
s = s.replace('// #define    MANUFACTURER          "1234"',
              '#define    MANUFACTURER          "MSFT"')
s = s.replace('// #define       VENDOR_STRING_1    "1234"',
              '#define       VENDOR_STRING_1    "xCG "')
s = s.replace('// #define       VENDOR_STRING_2    "1234"',
              '#define       VENDOR_STRING_2    "fTPM"')
open(p, 'w', encoding='utf-8').write(s)
print("PATCHED")
EOF
echo "=== 验证 ==="
grep -n "define.*MANUFACTURER\|define.*VENDOR_STRING" $F
