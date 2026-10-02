#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
cd ${FW_ROOT}
rm -rf firmware-imx-8.1
echo "--- yes 确认执行 ---"
yes | bash ${FW_ROOT}/firmware-imx-8.1.bin > /tmp/fw3.log 2>&1
echo "RC=$?"
echo "--- 日志尾部 ---"
tail -5 /tmp/fw3.log
echo "--- 关键文件 ---"
ls ${FW_ROOT}/firmware-imx-8.1/firmware/ddr/synopsys/ 2>/dev/null
ls ${FW_ROOT}/firmware-imx-8.1/firmware/hdmi/cadence/ 2>/dev/null
