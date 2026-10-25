
<!-- README.md is generated from .setup/readme/README.Rmd, which rProject's
docker template writes. Edit .setup/readme/description.md, scripts/cran.txt,
scripts/github.txt, or .setup/scripts/project.R instead. -->

# ijapesigan/docs

<!-- badges: start -->

[![Docker Build and Push Docs \[multi\]
(Daily)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-daily-multi-docs.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-daily-multi-docs.yml)
[![Docker Build and Push
\[multi\]](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-multi.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-multi.yml)
[![Make
Project](https://github.com/ijapesigan/docker-docs/actions/workflows/make.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/make.yml)
[![Non-ASCII
Check](https://github.com/ijapesigan/docker-docs/actions/workflows/non-ascii-check.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/non-ascii-check.yml)
[![Shell
Check](https://github.com/ijapesigan/docker-docs/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/shellcheck.yml)
<!-- badges: end -->

## Description

The documentation image, the end of the daily chain: built on
`ijapesigan/dev`, with TinyTeX, Apptainer, radian, btop, and uv.
rProject builds every project with it (`docs.sif`).

Based on `ijapesigan/dev:latest`; built for linux/amd64 and linux/arm64.
Source: <https://github.com/ijapesigan/docker-docs>.

## Use

Docker (Docker Hub or the GitHub Container Registry):

``` bash
docker run -it ijapesigan/docs
docker run -it ghcr.io/ijapesigan/docs
```

Apptainer:

``` bash
apptainer pull docs.sif docker://ijapesigan/docs
apptainer shell docs.sif
```

## Builds

- Docker Build and Push Docs \[multi\] (Daily)
  (`docker-build-push-daily-multi-docs.yml`): when the base image is
  rebuilt
- Docker Build and Push \[multi\] (`docker-build-push-multi.yml`): after
  Make Project
- Make Project (`make.yml`): on push
- Non-ASCII Check (`non-ascii-check.yml`): after Make Project
- Shell Check (`shellcheck.yml`): after Make Project

The images are pushed to Docker Hub and the GitHub Container Registry as
`ijapesigan/docs:latest`.
