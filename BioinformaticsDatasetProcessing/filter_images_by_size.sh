#!/bin/bash

if [[ $# < 8 || $1 != "--file_path" || $3 != "--dest_dir" || $5 != "--command" || ($7 != "--str_cnt" && $7 != "--quality_bound") ]]; then
	echo "Incorrect format or count of arguments"
	exit 1
fi

if [[  $7 != "--str_cnt" && $5 != "--command" ]]; then
	echo "Incorrect format or count of arguments"
	exit 1
fi

file_path=$2
dest_dir=$4 

if [[ $6 == "save_head" ]]; then

	str_cnt=$8
	mkdir -m 777 -p $dest_dir
	dest_file_path=$dest_dir/data_head$str_cnt
	touch $dest_file_path.fastq
	rm $dest_file_path.tar.gz 2>/dev/null
	
	string_num=0
	while IFS= read -r line; do
		if [[ $string_num == 0 ]]; then
			cat <<< $line | grep -o -e "@.*" >> $dest_file_path.fastq
			string_num=1
		else
			cat <<< $line >> $dest_file_path.fastq
		fi
	done <<< $(zcat $file_path | head -$str_cnt)

	tar -czvf $dest_file_path.tar.gz $dest_file_path.fastq
	rm $dest_file_path.fastq

elif [[ $6 == "nucleotides_filter" ]]; then
	
	quality_bound=$8

	tar xvzf archive.tar.gz
fi

