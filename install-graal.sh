#!/usr/bin/env bash

# control OS by setting environment variable OS_NAME before invoking this script

GRAAL_OS="$OS_NAME"
if [[ "$GRAAL_OS" == "" ]]; then
  echo '$OS_NAME is not set. Using default $OS_NAME=linux'
  GRAAL_OS=linux
  #GRAAL_OS=darwin
  #GRAAL_OS=windows
fi

GRAAL_VERSION=19.2.1
CACHE_DIR=~/.m2/caches/info.picocli.graal

DOWNLOAD_URL=https://github.com/oracle/graal/releases/download/vm-${GRAAL_VERSION}/
FILE_EXTENSION=tar.gz
if [[ "$GRAAL_OS" == "windows" ]]; then FILE_EXTENSION=zip ; fi
GRAAL_FILE=graalvm-ce-${GRAAL_OS}-amd64-${GRAAL_VERSION}.${FILE_EXTENSION}

if ! [[ -d "$CACHE_DIR/graalvm-ce-$GRAAL_VERSION" ]]; then
  echo "Creating GraalVM download/cache dir $CACHE_DIR..."
  mkdir --parents "$CACHE_DIR"
  pushd "$CACHE_DIR"
  echo "Downloading GraalVM... (this may take a while)"
  curl --progress-bar --remote-name --location "$DOWNLOAD_URL/$GRAAL_FILE"
  echo "Uncompressing $GRAAL_FILE..."
  tar xzf "$GRAAL_FILE"
  popd
else
  echo "Found existing GraalVM download/cache dir: $CACHE_DIR"
fi

echo "Using JAVA_HOME=$CACHE_DIR/graalvm-ce-$GRAAL_VERSION"
JAVA_HOME="$CACHE_DIR/graalvm-ce-$GRAAL_VERSION"
"${JAVA_HOME}/bin/java" -version

echo "You can now run the build with: ./mvnw -DbuildArgs=--no-server clean verify"

#./mvnw clean verify