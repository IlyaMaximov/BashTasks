BEGIN {FS=","}
{
	if (NR == 1) { print $0 > train_file; print $0 > val_file }
	else {
		if (all_word[$class_num] == "") {
			all_word[$class_num] = 1;
			train_word[$class_num] = 1;
			print $0 > train_file;
		} else if (train_word[$class_num] / all_word[$class_num] < train_ratio) {
			all_word[$class_num] += 1;
			train_word[$class_num] += 1;
			print $0 > train_file;
		} else {
			all_word[$class_num] += 1;
			print $0 > val_file;
		}
	}
}
