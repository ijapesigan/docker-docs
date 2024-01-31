#!/bin/bash

set -e

wget https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_rstudio.sh
bash install_rstudio.sh
rm -rf install_rstudio.sh
wget https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_pandoc.sh
bash install_pandoc.sh
rm -rf install_pandoc.sh
wget https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_quarto.sh
bash install_quarto.sh
rm -rf install_quarto.sh

bash rproject.sh
bash tinytex.sh
bash custom.sh
bash post.sh
