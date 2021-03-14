{
	bin_cnt[$1]++
}
END {
	for (bin_name in bin_cnt) {
		{printf "%s: %s\n", bin_name, bin_cnt[bin_name] | "sort"}
	}
}
