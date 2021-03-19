{
	key_cnt[$1] += $2
}
END {
	for (key_name in key_cnt) {
		{print key_name, key_cnt[key_name] > file_name}
	}
}
