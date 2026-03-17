#!/bin/bash

set -e

GAME_DIR="/var/www/html/game"

echo "Moving to game directory..."

cd $GAME_DIR

echo "Generating manifest..."

cd /var/www/html/game
wget -O generate_manifest.py https://gist.githubusercontent.com/Xelszy/3e8d21d23e587b08c0763abf292b10c8/raw/850a907aa030220436a4be993fa37a7ebb9276e8/generate_manifest.py
python3 generate_manifest.py

echo "Checking manifest..."

if [ -f "manifest.json" ]; then

    echo "Manifest created successfully"

else

    echo "Manifest failed"
    exit 1

fi

echo "Counting files..."

FILE_COUNT=$(find . -type f | wc -l)

echo "Total files:" $FILE_COUNT

echo "Calculating total size..."

TOTAL_SIZE=$(du -sh . | cut -f1)

echo "Total size:" $TOTAL_SIZE

SERVER_IP=$(curl -s ifconfig.me)

echo ""
echo "Manifest ready!"
echo "Distribution URL:"
echo "http://$SERVER_IP/game/"
echo ""
