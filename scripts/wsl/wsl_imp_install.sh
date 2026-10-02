#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
cp $(dirname "$0")/imp_shim.py /usr/local/lib/python3.13/dist-packages/imp.py
python3 -c "import imp; print('imp PY_SOURCE =', imp.PY_SOURCE)"
