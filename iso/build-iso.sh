#!/bin/bash
base_dir="$(pwd)"
iso_dir="$base_dir/archiso"
buildFolder="$base_dir/isoBUILD"
outFolder="$base_dir/isoOUT"
archisoVersion=$(sudo pacman -Q archiso)

# if calamares_repo is not defined in pacman.conf then add it
if ! grep -q "calamares_repo" "$iso_dir/pacman.conf"; then
    echo -ne "\n\n[calamares_repo]" >> "$iso_dir/pacman.conf"
    echo -ne "\nSigLevel = Optional TrustAll" >> "$iso_dir/pacman.conf"
    echo -ne "\nServer = file://"$iso_dir"/custom_repos/calamares_repo" >> "$iso_dir/pacman.conf"
fi

echo "Archiso version installed              : "$archisoVersion
echo "Out folder                             : "$outFolder
echo "Build folder                           : "$buildFolder

if pacman -Qi archiso &> /dev/null; then
    echo "Archiso is already installed"
else
    if pacman -Qi paru &> /dev/null; then
        echo "Installing with paru"
        paru -S --noconfirm archiso
    elif pacman -Qi yay &> /dev/null; then
        echo "Installing with yay"
        yay -S --noconfirm $package
    fi

    if pacman -Qi archiso &> /dev/null; then
        echo "Archiso has been installed. Continuing ..."
    else
        echo "archiso could not be installed. Exiting ..."
        exit 1
    fi
fi

echo "- Deleting the build folder if one exists"
echo "- Copying the Archiso folder to build folder"

echo "Deleting the build folder if one exists - takes some time"
[ -d $buildFolder ] && sudo rm -rf $buildFolder
echo
echo "Copying the Archiso folder to build work"
echo
mkdir $buildFolder
cp -r $base_dir/archiso $buildFolder/archiso

echo
echo "- Building the iso - this can take a while - be patient"
echo

[ -d $outFolder ] || mkdir $outFolder
cd $buildFolder/archiso/
sudo mkarchiso -v -w $buildFolder -o $outFolder $buildFolder/archiso/

echo
echo "DONE!!!"
echo "- Check your out folder :"$outFolder
echo
