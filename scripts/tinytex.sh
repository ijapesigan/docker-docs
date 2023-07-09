#!/bin/bash

set -e

# uninstall tinytex
R -e "                                       \
    tinytex::uninstall_tinytex(force = TRUE) \
"

# install tinytex package
R -e "tinytex::install_tinytex( \
    bundle = 'TinyTeX-2',       \
    force = TRUE,               \
    dir =  '/opt/TinyTeX'       \
)"

# Check tinytex
echo -e "Check tinytex...\n"
R -e "tinytex::is_tinytex()"
echo -e "\nInstall tinytex, done!"
