#!/bin/bash

set -e

BUILD_DIR="/var/www/html/game/build"
RELEASE_DIR="/var/www/html/game/release"

URL=$1

if [ -z "$URL" ]
then
    echo "Usage:"
    echo "./fetch_build.sh DOWNLOAD_URL"
    exit 1
fi

mkdir -p $BUILD_DIR
mkdir -p $RELEASE_DIR

cd $BUILD_DIR

echo "Downloading build..."

FILENAME=$(basename "$URL")
FILENAME=${FILENAME%%\?*}

aria2c --continue=true -x 16 -s 16 -o "$FILENAME" "$URL"

echo "Detecting archive type..."

if [[ $FILENAME == *.rar ]]
then

    echo "RAR detected"

    unrar x "$FILENAME" "$RELEASE_DIR"

elif [[ $FILENAME == *.zip ]]
then

    echo "ZIP detected"

    unzip "$FILENAME" -d "$RELEASE_DIR"

elif [[ $FILENAME == *.7z ]]
then

    echo "7Z detected"

    7z x "$FILENAME" -o"$RELEASE_DIR"

else

    echo "Unknown archive format"
    exit 1

fi

echo "Cleaning archive..."

rm "$FILENAME"

echo "Moving to release folder..."

cd $RELEASE_DIR

echo "Generating manifest..."

python3 /opt/fastdl-game-launcher/server/generate_manifest.py

SERVER_IP=$(curl -s ifconfig.me)

echo ""
echo "Build ready!"
echo "Distribution URL:"
echo "http://$SERVER_IP/game/release"
echo ""
