#!/bin/bash

if [[ $# < 4 || $1 != "--file_path" || $3 != "--category_id" ]]; then
	echo "Incorrect format or count of arguments"
	exit 1
fi

file_path=$2
category_ids=$4

images_ids=$(jq -r ".annotations[] | select(.category_id==$category_ids) | .image_id" $2 | uniq -u)

if [[ $# > 4 && $5 == "--detail" ]]; then

while IFS= read -r image_id; do
    echo $(jq -r ".images[] | select(.id==$image_id) | .file_name" $2)
done <<< $images_ids

else
	IFS=$(echo '\n')
	echo $images_ids
fi
