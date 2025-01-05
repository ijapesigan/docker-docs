arch=$(uname -m)

if [[ "$arch" == "x86_64" ]]; then
    bash texlive-amd64.sh
else
    bash texlive-aarch64.sh
fi
