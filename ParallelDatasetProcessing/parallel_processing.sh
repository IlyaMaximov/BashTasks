#!/bin/bash

if [[ $# < 5 || $1 != "--worker_cnt" || $3 != "--dest_dir" ]]; then
	echo "Incorrect format or count of arguments"
	exit
fi

worker_cnt=$2
dest_dir=$4
links="tmp_links.txt"

while [ -n "$5" ]
do
echo $5 >> $links
shift
done

# $links = https://drive.google.com/uc?export=download&id=1EfRc2RLVdwWlXWz3nDIBEv_EvvOMd9ip
parallel -a $links -d '\n' -j $worker_cnt wget -P $dest_dir {}

rm $links 2>/dev/null 
