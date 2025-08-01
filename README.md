ijapesigan/docs
================
Ivan Jacob Agaloos Pesigan
2025-08-02

<!-- README.md is generated from .setup/readme/README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Make
Project](https://github.com/ijapesigan/docker-docs/actions/workflows/make.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/make.yml)
[![Docker Build and Push \[amd64/arm64\] (Daily at
22:00:00)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-daily-docs.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-daily-docs.yml)
[![Docker Build and Push
\[amd64/arm64\]](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-amd64-arm64.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-amd64-arm64.yml)
[![Docker and Apptainer Build
\[amd64\]](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-apptainer-build-amd64.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-apptainer-build-amd64.yml)
[![Docker Build and Push Docs \[amd64\]
(Daily)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-daily-amd64-docs.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/docker-build-push-daily-amd64-docs.yml)
[![Shell
Check](https://github.com/ijapesigan/docker-docs/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/ijapesigan/docker-docs/actions/workflows/shellcheck.yml)
<!-- badges: end -->

## Description

A Docker container for `R` projects based on the [Rocker
Project](https://rocker-project.org/) with document processing programs.

## Docker Container

To launch `Rstudio Server`, run the following.

``` bash
docker run --rm -ti -e PASSWORD=yourpassword -p 127.0.0.1:8787:8787 ijapesigan/docs
```

Open `http://localhost:8787` on your web browser to launch
`Rstudio Server`.

- username: rstudio
- password: yourpassword

## Apptainer Container

To build the Singularity Image File (SIF), run the following.

``` bash
apptainer pull docs.sif docker://ijapesigan/docs:latest
```
