#!/bin/bash

if [[ $# < 3 || $2 != "--stat" ]]; then
	exit 0
fi

#далее предполагаю, что идёт работа с файлом train.csv(или с файлом похожего формата столбцов)

hist_data=""
if [[ $3 == "Survived" || $3 == "survival" ]]; then 
	IFS=$(echo -e '\n')
	hist_data=$(awk '{FS=","; if (NR > 1) {print $2}}' $1)
elif [[ $3 == "Pclass" || $3 == "pclass" ]]; then
	IFS=$(echo -e '\n')
	hist_data=$(awk '{FS=","; if (NR > 1) {print $3}}' $1)
elif [[ $3 == "Age" || $3 == "age" ]]; then
	IFS=$(echo -e '\n')
	hist_data=$(awk '{FS=","; if (NR > 1) {print $7}}' $1)
elif [[ $3 == "Embarked" || $3 == "embarked" ]]; then
	IFS=$(echo -e '\n')
	hist_data=$(awk '{FS=","; if (NR > 1) {print $13}}' $1)
else 
	echo "Incorrect database field argument"
fi

hist=$(echo $hist_data | awk -f statistic.awk)
echo $hist
