#!/usr/bin/env bash
# Download aur packages from file, build packages, enable in pacman.conf

AUR_URL="https://aur.archlinux.org/"

# Set repo directory
enabled=$1
conserve_space=$2
base_dir=$(pwd)
repo_name="aur_repo_x86_64"
iso_name="archiso"
iso_dir="$base_dir/$iso_name"
repo_dir="$iso_dir/custom_repos/$repo_name"
packages_dir="packages"
makepkg_flags="-s --skipchecksums --skippgpcheck --skipinteg --noconfirm"
failed_packages=("")

build() {
    CLONE_URL=$1
    PKG_PATH=$2
    PKG_NAME=$(basename $PKG_PATH)
    # clone each package without history to save space and time
    git clone --depth 1 $CLONE_URL $PKG_PATH
    # get the result of the above command if it failed with (fatal: destination path '...' already exists and is not an empty directory.)
    if [ $? -ne 0 ]; then
        echo "Package $PKG_PATH already exists, updating"
        # if there is no update, then skip the build
        (cd $PKG_PATH && git pull)
        if [ $? -ne 0 ]; then
            echo "No update for $PKG_NAME"
        else
            echo "Building $PKG_NAME as there is an update"
            (cd $PKG_PATH && makepkg $makepkg_flags && repo-add "$repo_dir/$repo_name.db.tar.gz" *.pkg.tar)
            mv $PKG_PATH/*.pkg.tar $repo_dir
            # check if the package was built successfully
            if [ $? -ne 0 ]; then
                echo "Package $PKG_NAME failed to build removing from packages.x86_64"
                failed_packages+=("$PKG_NAME")
            else
                echo "Package $PKG_NAME built successfully"
            fi
            if [ "$conserve_space" == "conserve_space" ]; then
                rm -rf $PKG_PATH
            fi
        fi
    else
        echo "Building $PKG_NAME as it is a new package"
        (cd $PKG_PATH && makepkg $makepkg_flags && repo-add "$repo_dir/$repo_name.db.tar.gz" *.pkg.tar)
        mv $PKG_PATH/*.pkg.tar $repo_dir
        # check if the package was built successfully
        if [ $? -ne 0 ]; then
            echo "Package $PKG_NAME failed to build removing from packages.x86_64"
            failed_packages+=("$PKG_NAME")
        else
            echo "Package $PKG_NAME built successfully"
        fi
        if [ "$conserve_space" == "conserve_space" ]; then
            rm -rf $PKG_PATH
        fi
    fi
}

if [ "$1" == "enable" ]; then
    echo "AUR enabled"

    # Initialization
    mkdir -p $repo_dir
    # ensure packages directory is writable by anybody
    chmod -R 777 $repo_dir
    cd $repo_dir

    echo "Enabling local $repo_name repo"
    # if repo is not defined in pacman.conf then add it
    $(if ! grep -q "$repo_name" "$iso_dir/pacman.conf"; then
        echo -ne "\n\n[$repo_name]\n" >>"$iso_dir/pacman.conf"
        echo -ne "SigLevel = Optional TrustAll\n" >>"$iso_dir/pacman.conf"
        echo -ne "Server = file://"$iso_dir"/custom_repos/$repo_name\n" >>"$iso_dir/pacman.conf"
    fi)

    while read repo; do
        if [ "$repo" == "" ]; then
            continue
        fi
        tokens=($repo)
        CLONE_URL=""
        PKG_PATH=$packages_dir
        if [ ${tokens[0]} == "#" ]; then
            # echo "skipping commented $repo"
            continue
        elif [ ${tokens[0]} == "aur" ]; then
            PACKAGE_NAME=${tokens[1]}
            echo "Cloning $PACKAGE_NAME"
            CLONE_URL="$AUR_URL${tokens[1]}.git"
            PKG_PATH="$PKG_PATH/${tokens[1]}"
        elif [ ${tokens[0]} == "url" ]; then
            CLONE_URL="${tokens[1]}"
            PKG_PATH="$PKG_PATH/$(basename ${tokens[1]})"
        else
            # echo "unhandled url type"
            continue
        fi
        build $CLONE_URL $PKG_PATH
    done <"$iso_dir/all_packages.x86_64"

    cd $base_dir
    # cp $repo_dir/* "$iso_dir/$repo_name"

    echo "Failed packages: ${failed_packages[@]}"
    echo "Removing failed packages from packages.x86_64"

    # Remove the aur prefix and copy to packages.x86_64
    cat "$iso_dir/all_packages.x86_64" | sed '/^aur/d' >"$iso_dir/packages.x86_64"
    # excluding failed packages one by one
    for i in "${failed_packages[@]}"; do
        echo "FAIL: Removing $i from packages.x86_64 because it failed to build"
        sed -i "/aur/$i/d" "$iso_dir/packages.x86_64"
    done
    echo "Final package list: "
    cat "$iso_dir/packages.x86_64"
    echo "AUR packages downloaded and built"
else
    echo "Disabling local $repo_name repo"
    # if repo is defined in pacman.conf then remove it
    if grep -q "$repo_name" "$iso_dir/pacman.conf"; then
        sed -i "/\[$repo_name\]/,/Server = file:\/\/$iso_name\/custom_repos\/$repo_name/d" "$iso_dir/pacman.conf"
    fi
    # Remove any aur packages from packages.x86_64 by removing any line that starts with aur
    cat "$iso_dir/all_packages.x86_64" | sed '/^aur//d' >"$iso_dir/packages.x86_64"
fi
