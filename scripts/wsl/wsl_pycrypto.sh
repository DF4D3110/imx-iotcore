#!/bin/bash
export HOME=/root
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-pycryptodome 2>&1 | tail -1
python3 -c "from Crypto.PublicKey import RSA; print('Crypto OK')"
