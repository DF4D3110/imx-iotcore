#!/bin/bash
export HOME=/root
printf '#define MKIMAGE_COMMIT 0x4d14f98a\n' > /opt/fw/imx-mkimage/src/build_info.h
cat /opt/fw/imx-mkimage/src/build_info.h
