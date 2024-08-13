#!/bin/bash

find "/home/${ISC_PACKAGE_MGRUSER}/irisbuild/projects" -maxdepth 2 -iname "iris.script" -print0 | 
while IFS= read -r -d '' irisscript; do
    directory=$(dirname "$irisscript")
    echo "Found project: $(basename "$directory")"
    if [ -f "$directory/prepare.sh" ]; then
        echo "Found prepare.sh script"
        cur_dir=$(pwd)
        cd "$directory"
        source "$directory/prepare.sh"
        cd "$cur_dir"
    fi
    iris session IRIS <<< $(cat $irisscript | sed "s|<#PROJECTDIR#>|$directory|g")
done

#rm -r /opt/irisbuild/projects

exit
