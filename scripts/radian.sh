#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends python3-venv python3-pip
rm -rf /var/lib/apt/lists/*

# Create an isolated env for CLI tools
python3 -m venv /opt/py
/opt/py/bin/pip install --no-cache-dir -U pip radian

# Make radian available on PATH
ln -sf /opt/py/bin/radian /usr/local/bin/radian
