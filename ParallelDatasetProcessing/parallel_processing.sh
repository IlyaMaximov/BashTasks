#!/bin/bash

function download_database () {
	database_name=$(echo $1 | awk '{print $1;}')
	file_name=$(echo $1 | awk '{print $2;}')
	path=$2
	kaggle competitions download -p $path -c $database_name -f $file_name
}


if [[ $# < 6 || $1 != "--worker_cnt" || $3 != "--data_link" || $5 != "--dest_dir" ]]; then
	echo "Incorrect format or count of arguments"
	exit 1
fi

worker_cnt=$2
links=$4
dest_dir=$6

export -f download_database
parallel -a $links -d '\n' -j $worker_cnt -I ARGS download_database ARGS $dest_dir
