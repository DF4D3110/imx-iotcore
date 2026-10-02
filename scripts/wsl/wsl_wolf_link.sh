#!/bin/bash
export HOME=/root
cd /opt/fw/MSRSec/external/ms-tpm-20-ref/TPMCmd/tpm/include
echo "=== 建 wolf 链接 ==="
ln -sfn Wolf wolf
ls -la wolf
echo "=== wolfssl README 哨兵 ==="
ls /opt/fw/MSRSec/external/wolfssl/README 2>&1
echo "=== wolfssl 顶层 ==="
ls /opt/fw/MSRSec/external/wolfssl/ | head -8
