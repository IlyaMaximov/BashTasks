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
dest_file_path=""
mkdir -m 777 -p $dest_dir

if [[ $6 == "save_head" ]]; then

	str_cnt=$8
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

elif [[ $6 == "nucleotides_filter" ]]; then
	
	quality_bound=$8
	dest_file_path=$dest_dir/data_quality_selection$quality_bound
	touch $dest_file_path.fastq
	rm $dest_file_path.tar.gz 2>/dev/null

	string_num=0
	line0=""
	line1=""
	line2=""
	line3=""
	while IFS= read -r line; do

		if [[ $string_num == 0 ]]; then
			line=$(echo $line | grep -o -e "@.*")
		fi

		line_num=$(( $string_num % 4 ))
		line_name=line$line_num
		IFS= read -r -d '' "$line_name" <<< $line

		if [[ $line_num == 3 ]]; then
			if [[ $(echo $line3 | awk -v quality_bound="$quality_bound" -f get_quality.awk) == 1 ]]; then
				cat <<< $line0$line1$line2$line3 >> $dest_file_path.fastq
			fi
		fi
		(( string_num++ ))

	done <<< $(zcat $file_path)

fi

tar -czvf $dest_file_path.tar.gz $dest_file_path.fastq
rm $dest_file_path.fastq


