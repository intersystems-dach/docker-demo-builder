#!/bin/bash

find "/opt/irisbuild/projects" -maxdepth 2 -iname "iris.script" -print0 | 
while IFS= read -r -d '' irisscript; do
    directory=$(dirname "$irisscript")
    echo "Found project: $(basename "$directory")"
    iris session IRIS <<< $(cat $irisscript | sed "s|<#PROJECTDIR#>|$directory|g")
done

rm -r /opt/irisbuild/projects

exit


