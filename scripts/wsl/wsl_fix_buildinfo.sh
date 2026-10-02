#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
printf '#define MKIMAGE_COMMIT 0x4d14f98a\n' > ${FW_ROOT}/imx-mkimage/src/build_info.h
cat ${FW_ROOT}/imx-mkimage/src/build_info.h
