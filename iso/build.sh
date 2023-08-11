#!/bin/bash

bash calamares.sh enable
bash aur.sh enable
bash build-iso.sh
cd isoOUT
ISO_PATH=$(find . -type f -name "*.iso")
ISO_NAME=$(basename $ISO_PATH)
ISO_PKGS=$(find . -type f -name "*.txt")

sha256sum $ISO_PATH > "${ISO_NAME}.sha256"
# split the iso if larger than 2GB
split -b 1950M $ISO_PATH "${ISO_NAME%.*}.part"
\ls -lasih .
for part in $(\ls *.part*); do
	sha256sum $part > "${part}.sha256"
done
\ls -lasih .
