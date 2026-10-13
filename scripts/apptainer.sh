#!/bin/bash

set -e
set -o pipefail

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install  \
    rpm2cpio \
    cpio

# unprivileged Apptainer in /opt/apptainer: the latest-release redirect gives
# the version (no GitHub API call), and the installer comes from that release
APPTAINER_URL=$(curl -fsSLo /dev/null -w '%{url_effective}' "https://github.com/apptainer/apptainer/releases/latest")
APPTAINER_TAG="${APPTAINER_URL##*/tag/}"
if [ -z "$APPTAINER_TAG" ] || [ "$APPTAINER_TAG" = "$APPTAINER_URL" ]; then
    echo "Apptainer: cannot find the latest release ($APPTAINER_URL)" >&2
    exit 1
fi
curl -fsSLo install-unprivileged.sh "https://raw.githubusercontent.com/apptainer/apptainer/${APPTAINER_TAG}/tools/install-unprivileged.sh"
bash install-unprivileged.sh -v "${APPTAINER_TAG#v}" /opt/apptainer
rm -f install-unprivileged.sh

# on PATH
ln -sf /opt/apptainer/bin/apptainer /usr/local/bin/apptainer
ln -sf /opt/apptainer/bin/singularity /usr/local/bin/singularity
apptainer --version
