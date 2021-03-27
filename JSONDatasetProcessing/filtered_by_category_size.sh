#!/bin/bash

if [[ $# < 4 || $1 != "--file_path" || $3 != "--max_doc_cnt" ]]; then
	echo "Incorrect format or count of arguments"
	exit 1
fi

# max_doc_cnt - это максимальное допустимое количество документов в определённой категории (если больше то все изображения данной категории отбрасываем)
file_path=$2
max_doc_cnt_in_category=$4

jq -r ".annotations | group_by(.category_id)[] | select(length < $max_doc_cnt_in_category)[] | .image_id" $2 | uniq -u
