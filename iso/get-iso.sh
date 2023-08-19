#!/usr/bin/env bash
# ask the use if he wants the full or light version of the iso
iso_version=""
echo "Which version of the iso do you want to download?"
echo "1) Full"
echo "2) Light"
read -p "Enter your choice (1 or 2): " choice
# if the choice is 1, download the full iso
if [ $choice -eq 1 ]; then
    echo "Downloading the full iso..."
    iso_version="FULL"
elif [ $choice -eq 2 ]; then
    echo "Downloading the light iso..."
    iso_version="LIGHT"
else
    echo "Invalid choice. Please try again."
    exit 1
fi
mkdir -p isoOUT
cd isoOUT
# curl for the latest release of the chosen iso
curl --silent "https://api.github.com/repos/evangelospro/dotfiles/releases" | grep -B 1 $iso_version | grep -o 'browser_download_url.*' | cut -d : -f 2,3 | tr -d \" | wget --show-progress -qi -
# verify the checksums for each part
sha256sum --check *.part*.sha256
# if the checksums are correct, merge the parts
if [ $? -eq 0 ]; then
    iso_name=$(\ls | grep -E '^ELARCH-.*.iso.sha256$' | sed 's/.sha256//')
    cat `\ls | grep -E '^ELARCH-.*\.part[^.]*$'` > "$iso_name"
    # verify the checksum for the final iso
    sha256sum --check "$iso_name.sha256"
    # if the checksum is correct, delete the parts
    if [ $? -eq 0 ]; then
        rm -rf `\ls | grep -E '^ELARCH-.*\.part[^.]*$'`
        echo "$iso_name has been successfully downloaded and verified!"
    else
        echo "Checksum for the final iso is not correct. Something went wrong during the merging process."
    fi
else
    echo "Checksums for the parts are not correct. Please try downloading the parts again."
fi
