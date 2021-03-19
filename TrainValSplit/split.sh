#!/bin/bash

if [[ $# < 7 || $1 != "--input" || $3 != "--train_ratio" || $5 != "--stratisfied" || $6 != "--y_column" ]]; then
	echo "Incorrect format or order of arguments"	
	exit 0
fi

file_name=$2
train_ratio=$4
class_column=$7
class_num=$(head -1 $file_name | awk -v class_column="$class_column" 'BEGIN {FS=","} {for (i = 1; i < NF + 1; ++i) {if ($i == class_column) {print(i)}}}')

# Теперь удаляем страрые файлы куда будем писать ответ, если они есть
rm "script_train.csv" 2>/dev/null
rm "script_val.csv" 2>/dev/null

IFS=$(echo -e '\n')
cat $file_name | awk -v class_num="$class_num" -v train_ratio="$train_ratio" -v train_file="script_train.csv" -v val_file="script_val.csv" -f print_train_val.awk
