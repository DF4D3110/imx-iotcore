#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
export PIP_BREAK_SYSTEM_PACKAGES=1
python3 -m pip install "setuptools<81" 2>&1 | tail -3
echo "=== 验证 ==="
python3 -c "import pkg_resources; print('pkg_resources OK')" 2>&1 | tail -1
python3 -c "import setuptools; print('setuptools', setuptools.__version__)" 2>&1 | tail -1
