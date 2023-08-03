#!/bin/bash
# DESC: Download aur packages from file, build packages, enable in pacman.conf

AUR_URL="https://aur.archlinux.org/"

# Set repo directory
base_dir=$PWD
repo_name="aur_repo_x86_64"
iso_name="archiso"
iso_dir="$base_dir/$iso_name"
repo_dir="$iso_dir/$repo_name"

build() {
    CLONE_URL=$1
    PKG_PATH=$2
    # clone each package
    git clone $CLONE_URL $PKG_PATH
    echo "Building $PKG_PATH"
    (cd $PKG_PATH && makepkg -s --noconfirm && repo-add "$repo_dir/$repo_name.db.tar.gz" *.pkg.tar.zst)
    sudo mv $PKG_PATH/*.pkg.tar.zst $repo_dir
    sudo rm -rf $PKG_PATH
}

if [ "$1" == "enable" ]; then
    echo "AUR enabled"

    # Initialization
    mkdir -p $repo_dir
    cd $repo_dir

    while read repo; do
        if [ "$repo" == "" ]; then
            continue
        fi
        tokens=( $repo )
        # echo "token0: ${tokens[0]} token1: ${tokens[1]}"
        CLONE_URL=""
        PKG_PATH=""
        if [ ${tokens[0]} == "#" ]; then
            # echo "skipping commented $repo"
            continue
        elif [ ${tokens[0]} == "aur" ]; then
            PACKAGE_NAME=${tokens[1]}
            echo "Cloning $PACKAGE_NAME"
            CLONE_URL="$AUR_URL${tokens[1]}.git"
            PKG_PATH="${tokens[1]}"
        elif [ ${tokens[0]} == "url" ]; then
            CLONE_URL="${tokens[1]}"
            PKG_PATH="$(basename ${tokens[1]})"
        else
            # echo "unhandled url type"
            continue
        fi
        build $CLONE_URL $PKG_PATH
    done < "$iso_dir/all_packages.x86_64"

    cd $base_dir
    # cp $repo_dir/* "$iso_dir/$repo_name"

    # Configure Pacman
    cp "$iso_dir/pacman.conf.bak" "$iso_dir/pacman.conf"
    echo -ne "\n\n[$repo_name]" >> "$iso_dir/pacman.conf"
    echo -ne "\nSigLevel = Optional TrustAll" >> "$iso_dir/pacman.conf"
    echo -ne "\nServer = file://"$repo_dir >> "$iso_dir/pacman.conf"

    # Remove the aur prefix and copy to packages.x86_64
    cat "$iso_dir/all_packages.x86_64" | sed 's/aur //g' > "$iso_dir/packages.x86_64"
    echo "AUR packages downloaded and built"
    echo "Space remaining: $(df -h)"
else
    echo "AUR disabled"
    # Remove any aur packages from packages.x86_64 by removing any line that starts with aur
    cat "$iso_dir/all_packages.x86_64" | sed '/^aur/d' > "$iso_dir/packages.x86_64"
fi