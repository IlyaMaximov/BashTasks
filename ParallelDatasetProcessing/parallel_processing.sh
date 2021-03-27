#!/bin/bash

if [[ $# < 6 || $1 != "--worker_cnt" || $3 != "--data_link" || $5 != "--dest_dir" ]]; then
	echo "Incorrect format or count of arguments"
	exit
fi

worker_cnt=$2
links=$4
dest_dir=$6

# $links = https://drive.google.com/uc?export=download&id=1EfRc2RLVdwWlXWz3nDIBEv_EvvOMd9ip
parallel -a $links -d '\n' -j $worker_cnt wget -P $dest_dir {}
