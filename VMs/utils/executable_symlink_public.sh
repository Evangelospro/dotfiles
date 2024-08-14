#!/usr/bin/env zsh
SRC="${HOME}/SeaDrive/My Libraries/HACKING"
DST="${HOME}/Public"
echo "SRC: ${SRC}"
echo "DST: ${DST}"
if [ -d "${SRC}" ] && [ "$(ls -A ${SRC})" ]; then
    echo "SRC folder exists and is not empty (creating symlink)"
    # symlink to DST
    ln -nsf ${SRC} ${DST}
else
    echo "SRC folder does not exist or is empty"
    # remove symlink if symlinked
    if [[ -L "${DST}" ]]; then
        echo "Removing symlink"
        rm ${DST}
        mkdir -p ${DST}
    fi
fi
