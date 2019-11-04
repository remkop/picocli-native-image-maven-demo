#!/usr/bin/env bash

GRAAL_OS=linux
#GRAAL_OS=darwin
#GRAAL_OS=windows

GRAAL_VERSION=19.2.1
CACHE_DIR=~/.m2/caches/info.picocli.graal
DOWNLOAD_URL=https://github.com/oracle/graal/releases/download/vm-${GRAAL_VERSION}/
FILE_EXTENSION=tar.gz
GRAAL_FILE=graalvm-ce-${GRAAL_OS}-amd64-${GRAAL_VERSION}.${FILE_EXTENSION}

if ! [ -d "$CACHE_DIR/graalvm-ce-$GRAAL_VERSION" ]; then
  #curl -O -v --progress-bar -sL "$DOWNLOAD_URL/$GRAAL_FILE"
  curl -O --progress-bar -L "$DOWNLOAD_URL/$GRAAL_FILE"
  tar xzf "$GRAAL_FILE"
fi
