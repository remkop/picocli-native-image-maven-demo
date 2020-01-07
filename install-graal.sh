#!/usr/bin/env bash

function usage() {
  echo "Usage: install-graal.sh [-h] [-g=GRAAL_VERSION] [-j=JAVA_VERSION] [-o=OS]"
  echo "Options:"
  echo "  -g, --graal-version=GRAAL_VERSION"
  echo "               The target GraalVM version. Valid values: 19.3.0, 19.3.0.2."
  echo "                 Default: 19.3.0.2."
  echo "  -j, --java-version=JAVA_VERSION"
  echo "               The target Java version. Valid values: 8, 11. Default: 8."
  echo "  -o, --os=OS  The target OS. Valid values: linux, darwin, windows. Default: linux."
  echo "  -h, --help   Print this usage help message and exit."
}

JAVA_VERSION="8"
OS_NAME="linux"
GRAAL_VERSION="19.3.0.2"


while [[ "$#" -gt 0 ]]
do
key="$1"

case "$key" in
    -j|--java-version)
    JAVA_VERSION="$2"
    shift # past argument
    shift # past value
    ;;
    -j=*|--java-version=*)
    JAVA_VERSION="${key#*=}"
    shift # past argument=value
    ;;
    -o|--os)
    OS_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -o=*|--os=*)
    OS_NAME="${key#*=}"
    shift # past argument=value
    ;;
    -g|--graal-version)
    GRAAL_VERSION="$2"
    shift # past argument
    shift # past value
    ;;
    -g=*|--graal-version=*)
    GRAAL_VERSION="${key#*=}"
    shift # past argument=value
    ;;
    -h|--help)
    usage
    exit "0";
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# control OS by setting environment variable OS_NAME before invoking this script

GRAAL_OS="$OS_NAME"

echo "Using OS=$GRAAL_OS and Java version $JAVA_VERSION..."

CACHE_DIR=~/.m2/caches/info.picocli.graal

# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/graalvm-ce-java8-windows-amd64-19.3.0.2.zip
# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/graalvm-ce-java11-windows-amd64-19.3.0.2.zip

# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/graalvm-ce-java8-darwin-amd64-19.3.0.2.tar.gz
# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/native-image-installable-svm-java8-darwin-amd64-19.3.0.2.jar

# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/graalvm-ce-java11-darwin-amd64-19.3.0.2.tar.gz
# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/native-image-installable-svm-java11-darwin-amd64-19.3.0.2.jar

# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/graalvm-ce-java8-linux-amd64-19.3.0.2.tar.gz
# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/native-image-installable-svm-java8-linux-amd64-19.3.0.2.jar

# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/graalvm-ce-java11-linux-amd64-19.3.0.2.tar.gz
# https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0.2/native-image-installable-svm-java11-linux-amd64-19.3.0.2.jar

FILE_EXTENSION=tar.gz
if [[ "$GRAAL_OS" == "windows" ]]; then FILE_EXTENSION=zip ; fi
GRAAL_FILE=graalvm-ce-java${JAVA_VERSION}-${GRAAL_OS}-amd64-${GRAAL_VERSION}.${FILE_EXTENSION}
DOWNLOAD_URL=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VERSION}/${GRAAL_FILE}
JAVA_HOME="$CACHE_DIR/graalvm-ce-java${JAVA_VERSION}-${GRAAL_VERSION}"

if ! [[ -f "$CACHE_DIR/$GRAAL_FILE" ]]; then
  echo "Creating GraalVM download/cache dir $CACHE_DIR..."
  mkdir --parents "$CACHE_DIR"
  pushd "$CACHE_DIR"
  echo "Downloading $DOWNLOAD_URL... (this may take a while)"
  curl --progress-bar --remote-name --location "$DOWNLOAD_URL"
  popd
else
  echo "Found existing GraalVM archive download: $CACHE_DIR/$GRAAL_FILE"
fi
if ! [[ -d "$JAVA_HOME" ]]; then
  echo "Uncompressing $GRAAL_FILE..."
  pushd "$CACHE_DIR"
  tar xzf "$GRAAL_FILE"
  popd
fi

echo "Using JAVA_HOME=$JAVA_HOME"
"${JAVA_HOME}/bin/java" -version

echo "You can now run the build with: ./mvnw -DbuildArgs=--no-server clean verify"

#./mvnw clean verify