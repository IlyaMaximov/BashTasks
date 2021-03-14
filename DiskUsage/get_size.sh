#!/bin/bash

# Смотрю за тем, чтобы пути к скрипту и исполняемой папке были глобальными
script_name=$0
if [[ $(echo $script_name | head -c 1) != "/" ]]; then
	script_name=$PWD/$0
fi


dir_name=$1
if [[ $(echo $dir_name | head -c 1) != "/" ]]; then
	dir_name=$PWD/$1
fi

# Получаю колонку из байт, обозначающую размер в директории и под директориях
IFS=$(echo -e '\n')
bytes_column=$(echo $(ls -la $dir_name) | awk -v path="$dir_name" -v script_name="$script_name" -f dir_size.awk)

# Суммирую значение в колонке и выдаю как ответ
IFS=$(echo -e '\n')
echo $(echo $bytes_column | awk -f sum_values.awk)
