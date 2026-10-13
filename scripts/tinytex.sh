#!/bin/bash

set -e

# tinytex
install2.r --error --skipinstalled -n -1 \
    tinytex

# TinyTeX in /opt/TinyTeX (TinyTeX-2 builds exist for x86_64 and arm64)
R -e "                        \
  tinytex::install_tinytex(   \
    bundle = 'TinyTeX-2',     \
    force = TRUE,             \
    dir = '/opt/TinyTeX'      \
  )                           \
"

# check: the Dockerfile adds /opt/TinyTeX/bin/<arch>-linux to PATH only
# after this step, so check that folder directly
TINYTEX_BIN="/opt/TinyTeX/bin/$(uname -m)-linux"
if [ ! -x "${TINYTEX_BIN}/tlmgr" ]; then
    echo "TinyTeX: ${TINYTEX_BIN}/tlmgr not found" >&2
    exit 1
fi
"${TINYTEX_BIN}/tlmgr" --version
PATH="${TINYTEX_BIN}:${PATH}" R -e "stopifnot(tinytex::is_tinytex())"

echo -e "\nInstall tinytex, done!"
