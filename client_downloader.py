import requests
import os
import hashlib
import sys
from concurrent.futures import ThreadPoolExecutor

if len(sys.argv)<2:
    print("Usage:")
    print("python client_downloader.py SERVER_URL")

    exit()

SERVER=sys.argv[1]
MANIFEST_URL=SERVER+"/manifest.json"
THREADS=6

print("Server:",SERVER)
print("Fetching manifest...")
r=requests.get(MANIFEST_URL)

if r.status_code!=200:
    print("Manifest failed")
    exit()

manifest=r.json()
files=manifest["files"]
total_size=sum(f["size"] for f in files)
downloaded_total=0

def sha256_file(path):
    h=hashlib.sha256()
    with open(path,'rb') as f:

        while True:
            chunk=f.read(1024*1024)
            if not chunk:
                break

            h.update(chunk)
    return h.hexdigest()

def download_file(file):
    global downloaded_total
    path=file["path"]
    size=file["size"]
    expected_hash=file["hash"]
    url=SERVER+"/"+path
    folder=os.path.dirname(path)
  
    if folder!="":
        os.makedirs(folder,exist_ok=True)
    if os.path.exists(path):
        local_size=os.path.getsize(path)
        if local_size==size:
            local_hash=sha256_file(path)
            if local_hash==expected_hash:
                print("Valid:",path)
                downloaded_total+=size
                return
            else:
                print("Repairing:",path)

    headers={}
    mode="wb"
    downloaded=0

    if os.path.exists(path):
        downloaded=os.path.getsize(path)
        headers={'Range': f'bytes={downloaded}-'}
        mode="ab"


    try:
        r=requests.get(url,headers=headers,stream=True)
        with open(path,mode) as f:
            for chunk in r.iter_content(1024*1024):

                if chunk:
                    f.write(chunk)
                    downloaded+=len(chunk)
                    downloaded_total+=len(chunk)
                    percent=(downloaded_total/total_size)*100
                    print(f"Total progress: {percent:.2f}%",end="\r")

    except:
        print("Retry:",path)
        download_file(file)
    print("Finished:",path)

with ThreadPoolExecutor(max_workers=THREADS) as executor:

    executor.map(download_file,files)

print("\nDownload complete")
