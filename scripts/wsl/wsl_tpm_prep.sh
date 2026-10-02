#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
echo "=== TA 归位目录 ==="
mkdir -p ${FW_ROOT}/mu_platform_nxp/Microsoft/OpteeClientPkg/Bin/AuthvarsTa/Arm64/Test
mkdir -p ${FW_ROOT}/mu_platform_nxp/Microsoft/OpteeClientPkg/Bin/fTpmTa/Arm64/Test
mkdir -p ${FW_ROOT}/mu_platform_nxp/Microsoft/OpteeClientPkg/Bin/HelloWorldTa/Arm64/Test
echo "=== 补 README 哨兵 ==="
touch ${FW_ROOT}/MSRSec/external/ms-tpm-20-ref/TPMCmd/README.md
ls -la ${FW_ROOT}/MSRSec/external/ms-tpm-20-ref/TPMCmd/README.md
echo "=== TPM_ROOT 定义 ==="
grep -rn "TPM_ROOT" ${FW_ROOT}/MSRSec/TAs/optee_ta/fTPM/Makefile ${FW_ROOT}/MSRSec/TAs/optee_ta/fTPM/*.mk 2>/dev/null | head
echo "=== tpm/src 存在性 ==="
ls ${FW_ROOT}/MSRSec/external/ms-tpm-20-ref/TPMCmd/tpm/src/command 2>/dev/null | head -5
echo "=== tpm/include ==="
ls ${FW_ROOT}/MSRSec/external/ms-tpm-20-ref/TPMCmd/tpm/include 2>/dev/null | head -5
echo "=== tpm/include/wolf ==="
ls ${FW_ROOT}/MSRSec/external/ms-tpm-20-ref/TPMCmd/tpm/include/wolf 2>/dev/null | head -5
