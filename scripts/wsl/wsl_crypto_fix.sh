#!/bin/bash
export FW_ROOT=${FW_ROOT:-/opt/fw}
export HOME=/root
ln -sfn /usr/lib/python3/dist-packages/Cryptodome /usr/lib/python3/dist-packages/Crypto
python3 -c "from Crypto.PublicKey import RSA; print('Crypto OK')"
