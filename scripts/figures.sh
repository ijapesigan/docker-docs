#!/bin/bash

# Fonts and figure tools for the style guides (rProject spec
# 2026-11-05-docs-image.md): fonts that match the papers (Latin Modern)
# and the Penn State slides (Roboto, Roboto Slab); GIF and video tools.

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

# fonts, so R figures use the documents' fonts
apt_install           \
    fonts-lmodern     \
    fonts-roboto      \
    fonts-roboto-slab
fc-cache -f

# GIF and video: gifsicle shrinks GIFs, ffmpeg writes MP4 (R av)
apt_install           \
    gifsicle          \
    ffmpeg            \
    libavfilter-dev

install2.r --error --skipmissing --skipinstalled -n -1 \
    av                \
    gifski

echo -e "\nInstall fonts and figure tools, done!"
