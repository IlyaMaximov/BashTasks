BEGIN {sum_bytes=0}	
{ if ($9 != "" ) {
	
	# Проверяем не является ли это регулярным файлом
	if ($1 !~ /d/) {
		sum_bytes+=$5;

	} else {
		file_path=path "/" $9;
		if ($9 == "..") {
		}
		else if ($9 == ".") {
			sum_bytes+=$5;
		} else {
			system("bash " script_name " " file_path);
		}
	}
}}
END {print sum_bytes}
