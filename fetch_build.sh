#!/bin/bash
set -e

URL=$1

if [ -z "$URL" ]
then
    echo "Usage:"
    echo "./fetch_build.sh DOWNLOAD_URL"
    exit 1
fi

cd /var/www/html/game

FILENAME=$(basename "$URL")

echo "Downloading build..."

sudo apt install unzip unrar p7zip-full -y
aria2c --continue=true -x 16 -s 16 "$URL"

echo "Detecting archive type..."

if [[ $FILENAME == *.rar ]]
then
    echo "RAR detected"
    
    sudo apt install unrar -y
    unrar x "$FILENAME"

elif [[ $FILENAME == *.zip ]]
then

    echo "ZIP detected"

    sudo apt install unzip -y
    unzip "$FILENAME"

elif [[ $FILENAME == *.7z ]]
then

    echo "7Z detected"

    sudo apt install p7zip-full -y
    7z x "$FILENAME"

else

    echo "Unknown format"
    exit 1

fi

echo "Cleaning archive..."

rm "$FILENAME"

echo "Generating manifest..."

python3 generate_manifest.py

SERVER_IP=$(curl -s ifconfig.me)

echo ""
echo "Build ready!"
echo "Distribution URL:"
echo "http://$SERVER_IP/game/"
echo ""
