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

# check
rg --version | head -n 1
jq --version
fd --version
gh --version | head -n 1
node --version
npm --version
bwrap --version
shellcheck --version | head -n 2

echo -e "\nInstall agent tools, done!"
