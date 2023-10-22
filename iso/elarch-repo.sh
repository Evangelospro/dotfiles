#!/usr/bin/env bash
# Set repo directory
enabled=$1
conserve_space=$2
base_dir=$(pwd)
repo_name="elarch_repo"
iso_name="archiso"
iso_dir="$base_dir/$iso_name"
repo_dir="$iso_dir/custom_repos/$repo_name"
makepkg_flags="-s --skipchecksums --skippgpcheck --skipinteg --noconfirm"

build() {
    PKG_PATH=$1
    echo "Building $PKG_PATH"
    (cd $PKG_PATH && sudo -u nobody makepkg $makepkg_flags && repo-add "$repo_dir/$repo_name.db.tar.gz" *.pkg.tar)
    sudo mv $PKG_PATH/*.pkg.tar $repo_dir
    if [ "$conserve_space" == "conserve_space" ]; then
        sudo rm -rf $PKG_PATH
    fi
}

if [ "$1" == "enable" ]; then
    echo "Enabling local $repo_name repo"
    # ensure packages directory is writable by anybody
    sudo chmod -R 777 "$iso_dir/custom_repos/$repo_name/packages"
    # if repo is not defined in pacman.conf then add it
    if ! grep -q "$repo_name" "$iso_dir/pacman.conf"; then
        echo -ne "\n\n[$repo_name]\n" >> "$iso_dir/pacman.conf"
        echo -ne "SigLevel = Optional TrustAll\n" >> "$iso_dir/pacman.conf"
        echo -ne "Server = file://"$iso_dir"/custom_repos/$repo_name\n" >> "$iso_dir/pacman.conf"
    fi
    calamares_packages=$(\ls $iso_dir/custom_repos/$repo_name/packages)
    for package in $calamares_packages; do
        build "$iso_dir/custom_repos/$repo_name/packages/$package"
    done
else
    echo "Disabling local $repo_name repo"
    # if repo is defined in pacman.conf then remove it
    if grep -q "$repo_name" "$iso_dir/pacman.conf"; then
        sed -i "/\[$repo_name\]/,/Server = file:\/\/$iso_name\/custom_repos\/$repo_name/d" "$iso_dir/pacman.conf"
    fi
fi
