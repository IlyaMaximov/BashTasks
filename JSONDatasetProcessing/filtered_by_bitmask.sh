#!/bin/bash

if [[ $# < 6 || $1 != "--file_path" || $3 != "--category_id" || $5 != "--min_bit_cnt_bound" ]]; then
	echo "Incorrect format or count of arguments"
	exit 1
fi

file_path=$2
category_id=$4
min_bit_cnt_bound=$6

images_in_category=$(jq -r ".annotations[] | select(.category_id==$category_id) | .image_id" $2)
good_size_ids=$(jq -r ".images[] | select(.width * .height > $min_bit_cnt_bound) | .id" $2)
all_ids="$images_in_category \n $good_size_ids"

IFS=$(echo '\n')
echo $all_ids | uniq -c | awk '{if ($1 >= 2) {print($2)}}'

