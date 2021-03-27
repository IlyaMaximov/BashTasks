#!/bin/bash

if [[ $# < 6 || $1 != "--file_path" || $3 != "--max_width" || $5 != "--max_height" ]]; then
	echo "Incorrect format or count of arguments"
	exit 1
fi

file_path=$2
max_width=$4
max_height=$6

jq -r ".images[] | select(.width<$max_width and .height<$max_height) | .id" $2

