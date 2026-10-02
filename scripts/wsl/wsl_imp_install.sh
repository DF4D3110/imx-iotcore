#!/bin/bash
export HOME=/root
cp /mnt/d/firmware_build/imp_shim.py /usr/local/lib/python3.13/dist-packages/imp.py
python3 -c "import imp; print('imp PY_SOURCE =', imp.PY_SOURCE)"
