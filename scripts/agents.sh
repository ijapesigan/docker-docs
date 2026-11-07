#!/bin/bash

# Tools the coding agents (Claude Code, Codex, Gemini CLI, Copilot CLI)
# use when they run inside the image (rProject spec
# 2026-11-05-docs-image.md). The CLIs and their logins are not in the
# image: they stay in the user's home (~/.local/bin, installed by
# `make agents`), which this script puts on PATH.

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

# search, JSON, files, processes, shell checks, sandboxes
apt_install           \
    ca-certificates   \
    gnupg             \
    ripgrep           \
    jq                \
    fd-find           \
    tree              \
    file              \
    unzip             \
    procps            \
    shellcheck        \
    bubblewrap        \
    socat
# Ubuntu names the fd binary fdfind
ln -sf "$(command -v fdfind)" /usr/local/bin/fd

# gh, from GitHub's apt repository
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list

# Node.js 22 LTS (Gemini CLI, MCP servers started with npx), NodeSource
curl -fsSL https://deb.nodesource.com/setup_22.x -o /tmp/nodesource_setup.sh
bash /tmp/nodesource_setup.sh
rm -f /tmp/nodesource_setup.sh

apt-get update
apt-get install -y --no-install-recommends gh nodejs

# ~/.local/bin on PATH: Apptainer (an env file it sources at start) and
# login shells (Docker, the RStudio terminal)
mkdir -p /.singularity.d/env
cat > /.singularity.d/env/99-local-bin.sh <<'ENVEOF'
case ":${PATH}:" in
    *":${HOME}/.local/bin:"*) ;;
    *) export PATH="${HOME}/.local/bin:${PATH}" ;;
esac
ENVEOF
cp /.singularity.d/env/99-local-bin.sh /etc/profile.d/99-local-bin.sh
chmod 0755 /.singularity.d/env/99-local-bin.sh /etc/profile.d/99-local-bin.sh

# actionlint and hadolint are not in Ubuntu's lists: pinned release binaries
actionlint_version=1.7.12
hadolint_version=2.15.1
case "$(dpkg --print-architecture)" in
    amd64)
        actionlint_arch=amd64
        actionlint_sha256=8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8
        hadolint_arch=x86_64
        hadolint_sha256=c7187db94eeeeca956519a6af171adc31453941a1e777961f6e680f697c8c507
        ;;
    arm64)
        actionlint_arch=arm64
        actionlint_sha256=325e971b6ba9bfa504672e29be93c24981eeb1c07576d730e9f7c8805afff0c6
        hadolint_arch=arm64
        hadolint_sha256=f6198ef8090f404dbb771abfee086eb8c48ac177f30da7fd3510aca35b344b5d
        ;;
    *)
        echo "agents.sh: no actionlint or hadolint for this architecture" >&2
        exit 1
        ;;
esac
actionlint_tar="actionlint_${actionlint_version}_linux_${actionlint_arch}.tar.gz"
curl -fsSL "https://github.com/rhysd/actionlint/releases/download/v${actionlint_version}/${actionlint_tar}" \
    -o "/tmp/${actionlint_tar}"
echo "${actionlint_sha256}  /tmp/${actionlint_tar}" | sha256sum -c -
tar -xzf "/tmp/${actionlint_tar}" -C /usr/local/bin actionlint
chmod 0755 /usr/local/bin/actionlint
rm -f "/tmp/${actionlint_tar}"
curl -fsSL "https://github.com/hadolint/hadolint/releases/download/v${hadolint_version}/hadolint-linux-${hadolint_arch}" \
    -o /usr/local/bin/hadolint
echo "${hadolint_sha256}  /usr/local/bin/hadolint" | sha256sum -c -
chmod 0755 /usr/local/bin/hadolint

# ImageMagick 7 (apt.txt) may name its binary magick-im7.q16 only
if ! command -v magick >/dev/null 2>&1; then
    ln -sf "$(command -v magick-im7.q16)" /usr/local/bin/magick
fi

# Python modules for PDFs, HTML, images, and numerics, for the system
# python3. From pip, as pdfplumber needs a newer Pillow than Ubuntu's;
# pdfplumber brings pdfminer.six.
python3 -m pip install --break-system-packages \
    pypdf          \
    PyMuPDF        \
    Pillow         \
    beautifulsoup4 \
    scipy          \
    pdfplumber

# check
rg --version | head -n 1
jq --version
fd --version
gh --version | head -n 1
node --version
npm --version
bwrap --version
shellcheck --version | head -n 2
actionlint --version | head -n 1
hadolint --version
magick --version | head -n 1
shfmt --version
cloc --version
sqlite3 --version
python3 -c "import bs4, pdfminer, pdfplumber, PIL, pymupdf, pypdf, scipy"

echo -e "\nInstall agent tools, done!"
