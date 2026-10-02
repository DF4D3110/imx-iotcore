#!/bin/bash
export HOME=/root
ln -sfn /usr/lib/python3/dist-packages/Cryptodome /usr/lib/python3/dist-packages/Crypto
python3 -c "from Crypto.PublicKey import RSA; print('Crypto OK')"
