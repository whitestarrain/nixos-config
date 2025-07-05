// Copyright (c) 2025 wsain. All Rights Reserved.

#ifndef TOOLKITS_H
#define TOOLKITS_H 1

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#define MAX_LINE_LEN 256
#define MAX_CORE_NUM 1 + 16 // the first line is total status
#define skip_update_status(buf, buf_size, fp)                                  \
  do {                                                                         \
    strncpy(buf, "--", buf_size);                                              \
    if (fp) {                                                                  \
      fclose(fp);                                                              \
    }                                                                          \
  } while (0)

void get_cpu_usage(char *buf, int buf_size) {
  // total and idel time
  static unsigned long core_last_sum_idle[MAX_CORE_NUM][2] = {0};
  unsigned long core_sum_idle[MAX_CORE_NUM][3] = {0};
  double cpu_usage[MAX_CORE_NUM] = {0};
  double total = 0, max = 0;
  const char token_delim[2] = " ";
  char line[MAX_LINE_LEN], *token = NULL, *token_ptr;
  int token_index = 0, core_id = 0;

  FILE *fp = fopen("/proc/stat", "r");
  if (fp == NULL) {
    skip_update_status(buf, buf_size, fp);
    return;
  }

  while (fgets(line, sizeof(line), fp) && core_id < MAX_CORE_NUM) {
    if (memcmp(line, "cpu", 3) != 0) {
      break;
    }

    // skip first token
    token = strtok_r(line, token_delim, &token_ptr);
    token_index = 0;
    token = strtok_r(NULL, token_delim, &token_ptr);
    token_index++;

    while (token != NULL) {
      core_sum_idle[core_id][0] += strtoul(token, NULL, 10);
      if (token_index == 4) {
        core_sum_idle[core_id][1] += strtoul(token, NULL, 10);
      }

      token = strtok_r(NULL, token_delim, &token_ptr);
      token_index++;
    }

    cpu_usage[core_id] =
        100 - (core_sum_idle[core_id][1] - core_last_sum_idle[core_id][1]) *
                  100.0 /
                  (core_sum_idle[core_id][0] - core_last_sum_idle[core_id][0]);

    core_last_sum_idle[core_id][0] = core_sum_idle[core_id][0];
    core_last_sum_idle[core_id][1] = core_sum_idle[core_id][1];

    core_id++;
  }
  core_id--;

  // close
  fclose(fp);

  // get max cpu usage
  for (short i = 1; i <= core_id; i++) {
    if (cpu_usage[i] > max) {
      max = cpu_usage[i];
    }
  }
  total = cpu_usage[0];

  snprintf(buf, buf_size, "(%-4.1f|%4.1f)", max, total);
}

// *******************************************************

#include <time.h>

#define MAX_NET_CARD_NUM 8
#define MAX_INTERFACE_NAME_LEN 16

static int format_speed(double speed, char *buf, int buf_size) {
  const char *units[] = {"B/s", "K/s", "M/s", "G/s", "T/s"};
  int unit_index = 0;

  while (speed >= 1024 && unit_index < 3) {
    speed /= 1024;
    unit_index++;
  }

  if (speed > 100) {
    speed /= 1024;
    unit_index++;
  }

  return snprintf(buf, buf_size, "%-4.1f%s", speed, units[unit_index]);
}

void get_net_speed(char *buf, int buf_size) {
  static unsigned long last_net_rxtx[MAX_NET_CARD_NUM][2] = {0};
  static struct timespec prev_time;
  struct timespec curr_time;
  char line[MAX_LINE_LEN], ifname[MAX_INTERFACE_NAME_LEN];
  unsigned long last_rx_bytes, rx_bytes, tx_bytes, rx_speed = 0, tx_speed = 0,
                                                   tmp_speed = 0;
  short net_card_index = 0;

  FILE *fp = fopen("/proc/net/dev", "r");
  if (fp == NULL) {
    skip_update_status(buf, buf_size, fp);
    return;
  }

  // skip the first two lines
  for (int i = 0; i < 2; i++) {
    if (!fgets(line, sizeof(line), fp)) {
      skip_update_status(buf, buf_size, fp);
      return;
    }
  }

  clock_gettime(CLOCK_MONOTONIC, &curr_time);

  double time_diff = (curr_time.tv_sec - prev_time.tv_sec) +
                     (curr_time.tv_nsec - prev_time.tv_nsec) / 1e9;
  if (time_diff <= 0)
    time_diff = 1.0; // Prevent division by zero

  // parse net card rx,tx data, get max speed
  while (fgets(line, sizeof(line), fp)) {
    // parse data
    if (sscanf(line, " %[^:]: %llu %*u %*u %*u %*u %*u %*u %*u %lu", ifname,
               &rx_bytes, &tx_bytes) != 3) {
      continue;
    }

    // drop ':'
    ifname[strcspn(ifname, ":")] = '\0';

    // skip "lo"
    if (strcmp(ifname, "lo") == 0) {
      continue;
    }

    tmp_speed = (rx_bytes - last_net_rxtx[net_card_index][0]) / time_diff;
    rx_speed = tmp_speed > rx_speed ? tmp_speed : rx_speed;
    tmp_speed = (tx_bytes - last_net_rxtx[net_card_index][1]) / time_diff;
    tx_speed = tmp_speed > tx_speed ? tmp_speed : tx_speed;

    last_net_rxtx[net_card_index][0] = rx_bytes;
    last_net_rxtx[net_card_index][1] = tx_bytes;

    net_card_index++;
  }

  // first execute, record prev_time
  if (prev_time.tv_sec == 0) {
    prev_time = curr_time;
    skip_update_status(buf, buf_size, fp);
    return;
  }
  prev_time = curr_time;

  short rx_str_len = format_speed(rx_speed, buf, buf_size);
  buf[rx_str_len] = ' ';
  format_speed(tx_speed, buf + rx_str_len + 1, buf_size - rx_str_len - 1);

  fclose(fp);
}

// *******************************************************

#ifdef CPU_TERMPERATURE_FILE_PATH

static int cpu_file_exist_flag = 1;
void get_cpu_temperature(char *buf, int buf_size) {
  if (!cpu_file_exist_flag) {
    skip_update_status(buf, buf_size, NULL);
    return;
  }
  char *file_path = TOSTRING(CPU_TERMPERATURE_FILE_PATH);
  FILE *fp = fopen(file_path, "r");
  if (fp == NULL) {
    cpu_file_exist_flag = 0;
    skip_update_status(buf, buf_size, fp);
    return;
  }
  char line[MAX_LINE_LEN];
  if (!fgets(line, sizeof(line), fp)) {
    skip_update_status(buf, buf_size, fp);
    return;
  }
  int temperature = atoi(line) / 1000;
  fclose(fp);
  snprintf(buf, buf_size, "%d°C", temperature);
}

#endif

#endif /* ifndef TOOLKITS_H */
