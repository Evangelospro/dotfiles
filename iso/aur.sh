#!/bin/bash
# FILE: yes_build_aur.sh
# DESC: Download aur packages from file, build packages, enable in pacman.conf
# Set repo directory

repo_dir=aur_repo_x86_64
base_dir=$PWD
isodir=./archiso

cat "$isodir/aur_git.links" | grep -v '^#' > ./AUR_BUILDER/git.links

cd ./AUR_BUILDER
./git_build_packages.sh ./$repo_dir
./init_custom_repo.sh ./$repo_dir
cd $base_dir
rm -rf "$isodir/$repo_dir"
cp -r ./AUR_BUILDER/$repo_dir "$isodir/$repo_dir"

# Add packages and pacman.conf
cd $base_dir
repo_dir=$isodir/$repo_dir
if [ "$1" != "" ]; then
    echo "Using custom repo at $1 : remember to use absolute paths."
    repo_dir=$1
else
    echo "Using default directory at $repo_dir"
fi

# Configure Pacman
echo "Last line in pacman.conf set. Server = file://$repo_dir"
cp "$isodir/pacman.conf.bak" "$isodir/pacman.conf"
echo -ne "\n\n[custom]" >> "$isodir/pacman.conf"
echo -ne "\nSigLevel = Optional TrustAll" >> "$isodir/pacman.conf"
echo -ne "\nServer = file://"$repo_dir >> "$isodir/pacman.conf"

# cp "$isodir/packages.x86_64" "$isodir/packages.x86_64.bak"
# echo -e "\n# AUR packages" >> "$isodir/packages.x86_64"

# Cut https://aur.archlinux.org/ and *.git to get package name
PACK=$(grep -v '^#' "$isodir/aur_git.links" | cut -d ' ' -f2)
echo -e "$PACK" >> "$isodir/packages.x86_64"
printf "\nAdded to packagelist:\n--------------\n"
echo -e "$PACK"
