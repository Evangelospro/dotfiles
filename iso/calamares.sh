#!/bin/bash
# Set repo directory
enabled=$1
conserve_space=$2
base_dir=$(pwd)
repo_name="calamares_repo"
iso_name="archiso"
iso_dir="$base_dir/$iso_name"
repo_dir="$iso_dir/custom_repos/$repo_name"
makepkg_flags="-s --noextract --skipchecksums --skippgpcheck --skipinteg --noconfirm"

build() {
    PKG_PATH=$1
    echo "Building $PKG_PATH"
    (cd $PKG_PATH && makepkg $makepkg_flags && repo-add "$repo_dir/$repo_name.db.tar.gz" *.pkg.tar)
    sudo mv $PKG_PATH/*.pkg.tar $repo_dir
    if [ "$conserve_space" == "conserve_space" ]; then
        sudo rm -rf $PKG_PATH
    fi
}

echo "Enabling local calamares repo"
calamares_packages=$(\ls $iso_dir/custom_repos/calamares_repo/packages)
for package in $calamares_packages; do
    build "$iso_dir/custom_repos/calamares_repo/packages/$package"
done