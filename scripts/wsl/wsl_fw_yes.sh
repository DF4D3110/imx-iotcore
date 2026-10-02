#!/bin/bash
export HOME=/root
cd /opt/fw
rm -rf firmware-imx-8.1
echo "--- yes 确认执行 ---"
yes | bash /opt/fw/firmware-imx-8.1.bin > /tmp/fw3.log 2>&1
echo "RC=$?"
echo "--- 日志尾部 ---"
tail -5 /tmp/fw3.log
echo "--- 关键文件 ---"
ls /opt/fw/firmware-imx-8.1/firmware/ddr/synopsys/ 2>/dev/null
ls /opt/fw/firmware-imx-8.1/firmware/hdmi/cadence/ 2>/dev/null
