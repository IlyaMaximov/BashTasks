#!/bin/bash

if [[ $# < 5 ]]; then
	echo "Incorrect format or count of arguments"
	exit
fi

links="tmp_links.txt"

while [ $# -gt 0 ]; do
	case "$1" in
		--dest_dir)
			dest_dir=$2
			shift 2
			;;
		--worker_cnt)
			worker_cnt=$2
			shift 2
			;;
		*)
			echo $1 >> $links
			shift
	esac
done

# $links = https://drive.google.com/uc?export=download&id=1EfRc2RLVdwWlXWz3nDIBEv_EvvOMd9ip
parallel -a $links -d '\n' -j $worker_cnt wget -P $dest_dir {}

rm $links 2>/dev/null 
