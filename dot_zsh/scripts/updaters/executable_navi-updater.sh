#!/bin/bash
CHEATS_PATH=$(navi info cheats-path)

cd $CHEATS_PATH

for REPO_PATH in $(ls -d *); do
    echo "Get changes from $REPO_PATH"
    cd $REPO_PATH
    if [ -d ".git" ]; then
        DEFAULT_BRANCH=$(git branch -r | grep -Po 'HEAD -> \K.*$' | cut -d'/' -f2)
        echo $DEFAULT_BRANCH
        git pull -q origin $DEFAULT_BRANCH
    else
        repo_details=($(echo $REPO_PATH | sed  's/__/ /g'))
        repo_user=${repo_details[0]}
        repo_name=$(echo ${repo_details[1]} | cut -d'/' -f1)
        rm *
        git clone "https://github.com/${repo_user}/${repo_name}" .
    fi
    cd ..
done