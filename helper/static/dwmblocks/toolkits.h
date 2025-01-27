#ifndef TOOLKITS_H
#define TOOLKITS_H 1

#define MAX_CORE_NUM 16
void get_cpu_usage(char *buf, int buf_size) {
	// total and idel time
	static long int core_last_sum_idle[MAX_CORE_NUM][2] = {0};
	long int core_sum_idle[MAX_CORE_NUM][2] = {0};
	long double cpu_usage[MAX_CORE_NUM] = {0};
	double avg=0, max=0;
	const char token_delim[2] = " ";
	char *line = NULL, *token = NULL;
	size_t len = 0;
	ssize_t read;
	int token_index = 0, core_id = 0;

	FILE *fp = fopen("/proc/stat", "r");
	if (fp == NULL) {
		strncpy(buf, "--", buf_size);
	}

	while ((read = getline(&line, &len, fp)) != -1 && core_id < MAX_CORE_NUM) {
		if (strlen(line) < 3 || memcmp(line, "cpu", 3) != 0){
			break;
		}
		token = strtok(line ,token_delim); token_index = 0;// skip first token
		token = strtok(NULL, token_delim); token_index ++;
		while(token != NULL) {
			core_sum_idle[core_id][0] += atoi(token);
			if (token_index == 4){
				core_sum_idle[core_id][1] += atoi(token);
			}

			token = strtok(NULL, token_delim);
			token_index ++;
		}

		cpu_usage[core_id] = 100 - (core_sum_idle[core_id][1] - core_last_sum_idle[core_id][1]) * 100.0 / (core_sum_idle[core_id][0] - core_last_sum_idle[core_id][0]);

		core_last_sum_idle[core_id][0] = core_sum_idle[core_id][0];
		core_last_sum_idle[core_id][1] = core_sum_idle[core_id][1];

		core_id++;
	}
  core_id--;

	// close and free
	fclose(fp);
	if (line){
		free(line);
	}

	// get avg and max cpu usage
	for (int i = 0; i <= core_id; i++) {
		if (cpu_usage[i] > max){
			max = cpu_usage[i];
		}
		avg += cpu_usage[i];
	}
	avg = avg / (core_id + 1);

	snprintf(buf, buf_size, "(%-4.1f|%4.1f)", max, avg);
}


#endif /* ifndef TOOLKITS_H */
