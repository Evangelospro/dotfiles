#!/bin/bash

cd /root/iso
ls -lasih

# Build ISO and rename to match BUILD_DATE
bash aur.sh enable
bash build-no-cache.sh
ISO_PATH=$(find ./isoOUT -type f -name "*.iso")
ISO_NAME=$(basename $ISO_PATH)
ISO_PKGS=$(find ./isoOUT -type f -name "*.txt")

mkdir -p isoOUT
cd isoOUT

# # split the iso if larger than 2GB
split -b 1950M $ISO_PATH "${ISO_NAME%.*}.part"
\ls -lasih .
for part in $(\ls *.part*); do sha256sum $part > "${part}.sha256"; done
\ls -lasih .

# echo "packages" > packages.txt
# echo "part" > test.part1
# echo "hash" > test.part1.sha256

# /bin/bash