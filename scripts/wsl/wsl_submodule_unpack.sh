#!/bin/bash
export HOME=/root
cd /tmp
echo "=== 解压 ms-tpm-20-ref ==="
rm -rf /tmp/tpm_x && mkdir -p /tmp/tpm_x
unzip -q /mnt/d/firmware_src/ms-tpm-20-ref-fc44e52e2640502ed64699c1cb631c6af69ba53f.zip -d /tmp/tpm_x && echo "unzip OK"
SRC_DIR=$(ls -d /tmp/tpm_x/*/)
echo "解压目录: $SRC_DIR"
rm -rf /opt/fw/MSRSec/external/ms-tpm-20-ref
mkdir -p /opt/fw/MSRSec/external/ms-tpm-20-ref
cp -r $SRC_DIR/. /opt/fw/MSRSec/external/ms-tpm-20-ref/
ls /opt/fw/MSRSec/external/ms-tpm-20-ref/TPMCmd/README.md && echo "TPMCmd README OK"

echo "=== 解压 wolfssl ==="
rm -rf /tmp/wolf_x && mkdir -p /tmp/wolf_x
unzip -q /mnt/d/firmware_src/wolfssl-74ebf510a3d73e98767eac26082eabdc84e19d31.zip -d /tmp/wolf_x && echo "unzip OK"
WSRC=$(ls -d /tmp/wolf_x/*/)
echo "解压目录: $WSRC"
rm -rf /opt/fw/MSRSec/external/wolfssl
mkdir -p /opt/fw/MSRSec/external/wolfssl
cp -r $WSRC/. /opt/fw/MSRSec/external/wolfssl/
ls /opt/fw/MSRSec/external/wolfssl/configure.ac && echo "wolfssl OK"
echo "=== 完成 ==="
