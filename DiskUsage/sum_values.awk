BEGIN {sum_values=0}	
{sum_values+=$1}
END {print sum_values}
