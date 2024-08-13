#!/bin/bash

find "/home/${ISC_PACKAGE_MGRUSER}/irisbuild/projects" -maxdepth 2 -iname "iris.script" -print0 | 
while IFS= read -r -d '' irisscript; do
    directory=$(dirname "$irisscript")
    echo "Found project: $(basename "$directory")"
    if [ -f "$directory/pre.sh" ]; then
        echo "Found pre script"
        cur_dir=$(pwd)
        cd "$directory"
        source "$directory/pre.sh"
        cd "$cur_dir"
    fi

    iris session IRIS <<< $(cat $irisscript | sed "s|<#PROJECTDIR#>|$directory|g")
    
    if [ -f "$directory/post.sh" ]; then
        echo "Found post script"
        cur_dir=$(pwd)
        cd "$directory"
        source "$directory/post.sh"
        cd "$cur_dir"
    fi
done

exit
