#!/bin/bash
mkdir -p iso
cd iso
curl --silent "https://api.github.com/repos/evangelospro/dotfiles/releases/latest" | grep "browser_download_url" | cut -d : -f 2,3 | tr -d \" | wget -qi -
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
