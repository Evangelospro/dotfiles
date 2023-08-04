#!/bin/bash
echo
echo "################################################################## "
echo "Phase 1 : "
echo "- Setting General parameters"
echo "################################################################## "
echo

base_dir="$(pwd)"
archisoRequiredVersion="archiso 71-1"
buildFolder="$base_dir/isoBUILD"
outFolder="$base_dir/isoOUT"
archisoVersion=$(sudo pacman -Q archiso)

echo "################################################################## "
echo "Archiso version installed              : "$archisoVersion
echo "Out folder                             : "$outFolder
echo "Build folder                           : "$buildFolder
echo "################################################################## "

echo "################################################################## "
echo "Do you have the right archiso version? : "$archisoVersion
echo "What is the required archiso version?  : "$archisoRequiredVersion
echo "Build folder                           : "$buildFolder
echo "Out folder                             : "$outFolder
echo "################################################################## "

if [ "$archisoVersion" != "$archisoRequiredVersion" ]; then
    echo "###################################################################################################"
    echo "You need to install the correct version of Archiso"
    echo "Use 'sudo downgrade archiso' to do that"
    echo "or update your system"
    echo "If a new archiso package comes in and you want to test if you can still build"
    echo "the iso then change the version in line 37."
    echo "###################################################################################################"
    exit 1
fi

echo
echo "################################################################## "
echo "Phase 2 :"
echo "- Checking if archiso is installed"
echo "- Making mkarchiso verbose"
echo "################################################################## "
echo

package="archiso"

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then
    echo "Archiso is already installed"
else
    #checking which helper is installed
    if pacman -Qi paru &> /dev/null; then
        echo "################################################################"
        echo "######### Installing with paru"
        echo "################################################################"
        paru -S --noconfirm $package
    elif pacman -Qi yay &> /dev/null; then
        echo "################################################################"
        echo "######### Installing with yay"
        echo "################################################################"
        yay -S --noconfirm $package
    fi

    # Just checking if installation was successful
    if pacman -Qi $package &> /dev/null; then
        echo "################################################################"
        echo "#########  "$package" has been installed"
        echo "################################################################"
    else
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "!!!!!!!!!  "$package" has NOT been installed"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        exit 1
    fi
fi

echo
echo "Making mkarchiso verbose"
sudo sed -i 's/quiet="y"/quiet="n"/g' /usr/bin/mkarchiso

echo
echo "################################################################## "
echo "Phase 3 :"
echo "- Deleting the build folder if one exists"
echo "- Copying the Archiso folder to build folder"
echo "################################################################## "
echo

echo "Deleting the build folder if one exists - takes some time"
[ -d $buildFolder ] && sudo rm -rf $buildFolder
echo
echo "Copying the Archiso folder to build work"
echo
mkdir $buildFolder
cp -r archiso $buildFolder/archiso

echo
echo "################################################################## "
echo "Phase 6 :"
echo "- Cleaning the cache from /var/cache/pacman/pkg/"
echo "################################################################## "
echo

echo "Cleaning the cache from /var/cache/pacman/pkg/"
yes | sudo pacman -Scc

echo
echo "################################################################## "
echo "Phase 7 :"
echo "- Building the iso - this can take a while - be patient"
echo "################################################################## "
echo

[ -d $outFolder ] || mkdir -p $outFolder
cd $buildFolder/archiso/
sudo mkarchiso -v -w $buildFolder -o $outFolder $buildFolder/archiso/

echo
echo "##################################################################"
echo "Phase 9 :"
echo "- Making sure we start with a clean slate next time"
echo "################################################################## "
echo

# Uncomment the line below if you want to delete the build folder after the ISO creation.
# [ -d $buildFolder ] && sudo rm -rf $buildFolder

echo "Set permissions to the out folder"
sudo chmod 777 -R $outFolder

echo
echo "##################################################################"
echo "DONE"
echo "- Check your out folder :"$outFolder
echo "################################################################## "
echo
