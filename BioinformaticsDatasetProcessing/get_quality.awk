{
	is_correct=1	
	split($0, chars, "")
	for (i=1; i <= length($0); i++) {
		if (chars[i] < quality_bound) {
			is_correct=0
		}
  	}
	print(is_correct)
}
