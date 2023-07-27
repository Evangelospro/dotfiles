#!/bin/bash
# DESC: Download aur packages from file, build packages, enable in pacman.conf

# Set repo directory
base_dir=$PWD
repo_name="aur_repo_x86_64"
repo_dir="$base_dir/AUR_BUILDER/$repo_name"
iso_name="archiso"
iso_dir="$base_dir/$iso_name"

cp "$iso_dir/all_packages.x86_64" ./AUR_BUILDER/git.links

# filter out comments and remove the aur prefix and copy to packages.x86_64
grep -v '^#' ./AUR_BUILDER/git.links | sed 's/aur\///g' > ./AUR_BUILDER/packages.x86_64

cd ./AUR_BUILDER
./git_build_packages.sh $repo_name
packages="$repo_dir/*.pkg.tar.zst"
echo "Build Packages: $packages"

for package in $packages; do
    echo "Adding $package to repo"
    repo-add "$repo_dir/$repo_name.db.tar.gz" "$package"
done

cd $base_dir
mkdir -p "$iso_dir/$repo_name"
cp $repo_dir/* "$iso_dir/$repo_name"

# Add packages and pacman.conf
cd $base_dir

# Configure Pacman
cp "$iso_dir/pacman.conf.bak" "$iso_dir/pacman.conf"
echo -ne "\n\n[$repo_name]" >> "$iso_dir/pacman.conf"
echo -ne "\nSigLevel = Optional TrustAll" >> "$iso_dir/pacman.conf"
echo -ne "\nServer = file://"$repo_dir >> "$iso_dir/pacman.conf"