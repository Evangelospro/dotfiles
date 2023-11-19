# Maintenance is hard...
function update() {
    paru -Syu
    update-zsh
    $HOME/.config/hypr/update.sh
    # navi-update
    # Update burp pro if a Burp/Burp-Loader directory exists in the home directory
    if [ -d $HOME/.config/Burp/Burp-Loader ]; then
        update-burp
    fi
}

function update-zsh() {
    # Update zsh plugins
    zinit update --parallel 40
    # Update zinit
    zinit self-update
}

function update-burp() {
    current_burp_version=$(realpath $HOME/.config/Burp/Burp-Loader/burpsuite_pro.jar | grep -Po '(?<=/burpsuite_pro_v)[0-9]+\-[0-9]+\-[0-9]+\-[0-9]+')
    burp_releases_html=$(curl -s "https://portswigger.net/burp/releases")
    latest_burp_version=$(echo $burp_releases_html | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
    if [[ $current_burp_version != $latest_burp_version ]]; then
        burp_update_url="https://portswigger-cdn.net/burp/releases/download?product=pro&version=$(echo $latest_burp_version | sed 's/-/./g')&type=Jar"
        echo "Updating Burp Pro from $current_burp_version to $latest_burp_version from $burp_update_url"
        wget -q --show-progress $burp_update_url -O $HOME/.config/Burp/Burp-Loader/burpsuite_pro_v$latest_burp_version.jar
        echo "Removing old Burp Pro version"
        rm $HOME/.config/Burp/Burp-Loader/burpsuite_pro_v$current_burp_version.jar
        echo "Symlinking new Burp Pro version"
        ln -f -s $HOME/.config/Burp/Burp-Loader/burpsuite_pro_v$latest_burp_version.jar $HOME/.config/Burp/Burp-Loader/burpsuite_pro.jar
    else
        echo "Burp Pro is already up to (date current version: $current_burp_version == latest version: $latest_burp_version)"
    fi
}
