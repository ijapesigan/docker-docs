#!/bin/bash

set -e

# tinytex
install2.r --error --skipinstalled -n -1 \
    tinytex

# uninstall tinytex
R -e "                                       \
  try(                                       \
    tinytex::uninstall_tinytex(force = TRUE) \
  )                                          \
"

# install tinytex package
R -e "                        \
  try(                        \
    tinytex::install_tinytex( \
      bundle = 'TinyTeX-2',   \
      force = TRUE,           \
      dir =  '/opt/TinyTeX'   \
    )                         \
  )                           \
"

# Check tinytex
echo -e "Check tinytex...\n"
R -e "tinytex::is_tinytex()"
echo -e "\nInstall tinytex, done!"
