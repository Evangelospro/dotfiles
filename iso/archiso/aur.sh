#!/bin/bash
# FILE: yes_build_aur.sh
# DESC: Download aur packages from file, build packages, enable in pacman.conf
#Set repo directory

# remove previous builder
rm -rf ./AUR_BUILDER

repo_dir=aur_repo_x86_64
base_dir=$PWD

#Fetch AUR builder
git clone https://github.com/Dogcatfee/AUR_BUILDER
cat ./aur_git.links | grep -v '^#' | grep h > ./AUR_BUILDER/git.links

cd ./AUR_BUILDER
./git_build_packages.sh ./$repo_dir
./init_custom_repo.sh ./$repo_dir
cd $base_dir
cp -r ./AUR_BUILDER/$repo_dir ./
cd ./AUR_BUILDER && ./clean.sh

# Add packages and pacman.conf
cd $base_dir
repo_dir=$PWD/aur_repo_x86_64
if [ "$1" != "" ]; then
    echo "Using custom repo at $1 : remember to use absalute paths."
    repo_dir=$1
else
    echo "Using default directory at $repo_dir"
fi

#Configure Pacman
echo "Last line in pacman.conf set. Server = file://"$repo_dir""
cp ./pacman.conf.bak ./pacman.conf
echo "[custom]" >> ./pacman.conf
echo "SigLevel = Optional TrustAll" >> ./pacman.conf
echo "Server = file://"$repo_dir >> pacman.conf

# Cut https://aur.archlinux.org/ and *.git to get package name
PACK=$(grep -v '^#' ./aur_git.links |  grep -Po '.*(?=\.)' | cut -c 27-100 )
echo -e "$PACK" >> packages.x86_64
printf "\nAdded to packagelist:\n--------------\n"
echo -e "$PACK"
