#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
cd ${FW_ROOT}/MSRSec/external/ms-tpm-20-ref/TPMCmd/tpm/include
echo "=== 建 wolf 链接 ==="
ln -sfn Wolf wolf
ls -la wolf
echo "=== wolfssl README 哨兵 ==="
ls ${FW_ROOT}/MSRSec/external/wolfssl/README 2>&1
echo "=== wolfssl 顶层 ==="
ls ${FW_ROOT}/MSRSec/external/wolfssl/ | head -8
