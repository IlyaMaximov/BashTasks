BEGIN {
	FS=","; 
	elem_in_reducer=(str_cnt-1)/reducer_cnt; 
	elem_in_reducer_tmp=0;
}
{
	if (NR > 1) {
		{printf "%s ", $class_num};
		++elem_in_reducer_tmp;
	} 
	if (elem_in_reducer <= elem_in_reducer_tmp) {
		{printf "\n"};
		elem_in_reducer_tmp=0;
	} 
}
