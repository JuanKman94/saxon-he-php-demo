#!/bin/sh

set -e

docker build . -t php8-saxon
docker run -v "$PWD":/code php8-saxon
