#!/bin/bash

git clone git@github.com:ijapesigan/docker-docs.git
rm -rf "$PWD.git"
mv docker-docs/.git "$PWD"
rm -rf docker-docs
