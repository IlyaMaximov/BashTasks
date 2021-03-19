#!/bin/bash

map () {
	IFS=" "
	for word in $1;
	do
		echo $word " 1" >> "map_file_tmp.log_$2"
	done 
}


if [[ $# < 5 || $2 != "--stat" || $4 != "--reducer_cnt" ]]; then
	echo "Incorrect format or count of arguments"
	exit 1
fi

file_name=$1
column_name=$3
reducer_cnt=$5

# Вычисляю номер колонки по которой запустить MapReruce
class_num=$(head -1 $file_name | awk -v column_name="$column_name" 'BEGIN {FS=","} {for (i = 1; i < NF + 1; ++i) {if ($i == column_name) {print(i)}}}')

# Получаю данные из этой колонки и подготавливаю их (в i-ой строке данные для i-го маппера)
IFS=''
prepared_data=$(cat $file_name | awk -v class_num="$class_num" -v reducer_cnt="$reducer_cnt" -v str_cnt=$(cat $file_name | wc -l) -f prepare_data.awk)

# Запускаю parallel mapping
i=0
while read line; do
	map $line $i &
	i=$(( i+1 ))
done <<< $prepared_data

wait 

# Объединяю файлы полученные после mapping в один
unset IFS
for i in $(seq 0 $(( $reducer_cnt-1 ))); do
	cat "map_file_tmp.log_$i" >> "map_file_tmp.txt"
done

# Shuffling
sort -o "map_file_tmp.txt" "map_file_tmp.txt"

# Теперь посплитим наш файл
line_cnt=$(( ($(cat $file_name | wc -l) + $reducer_cnt - 1) / $reducer_cnt))
split map_file_tmp.txt reduce_file_tmp.log_ -a 1 -d -l $line_cnt

# Запускаю parallel reducing на каждом файле
for i in $(seq 0 $(( $reducer_cnt-1 )) )
do
	awk -v file_name="reduce_file_tmp.log_$i" -f reduce.awk reduce_file_tmp.log_$i &
done
wait

# Объединяю файлы полученные после reducing в один
unset IFS
for i in $(seq 0 $(( $reducer_cnt-1 ))); do
	cat "reduce_file_tmp.log_$i" >> "reduce_file_tmp.txt"
done

# Запускаю на нём окончательный reduce и вывожу ответ
awk -v file_name="reduce_file_tmp.txt" -f reduce.awk reduce_file_tmp.txt
cat reduce_file_tmp.txt

unset IFS
rm "map_file_tmp.txt"
rm "reduce_file_tmp.txt"
for i in $(seq 0 $(( $reducer_cnt-1 )) )
do
	rm "map_file_tmp.log_$i"
	rm "reduce_file_tmp.log_$i"
done
