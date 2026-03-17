# DirectGameLauncher
simple solution for downloading large games without needing twice as much storage space.

# simple painpoint
The game is 10GB in a ZIP file; once extracted, it becomes 12GB. Typically, the client needs to have 22GB of free space (ZIP file plus extracted files). This solution moves the extraction process to the server. Modeling the simple logic of Steam (or similar platforms).

# how It Works

==+SERVER:+==

setup_vps.sh
     ↓
fetch_build.sh
     ↓
generate_manifest.sh
     ↓
FILES READY

==+CLIENT:+==

client_downloader.py
     ↓
DOWNLOAD GAME

1. The VPS server downloads the game’s ZIP file
2. The server extracts the ZIP file to the public folder
3. The server deletes the ZIP file (to save storage space)
4. The user runs the launcher to directly download the contents of the previously extracted file from the VPS
5. The game is ready to play (no need to extract on the client)

# components
- **Server Script**: Bash/Python for automated download and extraction(or just use aria2/wget and unzip/unrar)
- **Web Server**: Nginx to serve files
- **Client Launcher**: Script to download and verify files

1. run setup_vps.sh first
2. run fetch_build.sh
use example: ./fetch_build.sh "https://example.com/game.rar"
3. ./generate_manifest.sh

Next, on the client/user PC:

1. pip install requests
2. run script .py
use example: python client_downloader.py http://IP_VPS/game/GameFolder
