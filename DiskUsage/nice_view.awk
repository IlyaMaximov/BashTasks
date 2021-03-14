{
	if ($1 > 1024^3) {
		ans=$1/(1024^3)
		print(ans"G")
	} else if ($1 > 1024^2) {
		ans=$1/(1024^2)
		print(ans"M")
	} else {
		ans=$1/1024
		print(ans"K")
	}
}
