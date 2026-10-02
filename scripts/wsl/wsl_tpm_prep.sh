#!/bin/bash
export HOME=/root
echo "=== 补 README 哨兵 ==="
touch /opt/fw/MSRSec/external/ms-tpm-20-ref/TPMCmd/README.md
ls -la /opt/fw/MSRSec/external/ms-tpm-20-ref/TPMCmd/README.md
echo "=== TPM_ROOT 定义 ==="
grep -rn "TPM_ROOT" /opt/fw/MSRSec/TAs/optee_ta/fTPM/Makefile /opt/fw/MSRSec/TAs/optee_ta/fTPM/*.mk 2>/dev/null | head
echo "=== tpm/src 存在性 ==="
ls /opt/fw/MSRSec/external/ms-tpm-20-ref/TPMCmd/tpm/src/command 2>/dev/null | head -5
echo "=== tpm/include ==="
ls /opt/fw/MSRSec/external/ms-tpm-20-ref/TPMCmd/tpm/include 2>/dev/null | head -5
echo "=== tpm/include/wolf ==="
ls /opt/fw/MSRSec/external/ms-tpm-20-ref/TPMCmd/tpm/include/wolf 2>/dev/null | head -5
