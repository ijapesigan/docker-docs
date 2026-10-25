#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install python3-venv python3-pip

# Create an isolated env for CLI tools
python3 -m venv /opt/py
/opt/py/bin/pip install --no-cache-dir -U pip radian

# Make radian available on PATH
ln -sf /opt/py/bin/radian /usr/local/bin/radian
