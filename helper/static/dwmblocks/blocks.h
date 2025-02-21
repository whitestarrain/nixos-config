#include "toolkits.h"

//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*C function*/	/*Update Interval*/	/*Update Signal*/
	{"", "if [[ $BUTTON -eq  1 ]]; then st-float impala; fi; printf '[\\x0b󰖩 \\x0b'",         NULL,  0,		11},
	{"", "if [[ $BUTTON -eq  1 ]]; then st-float bluetuith; fi; printf '\\x0c󰂯\\x0c]'",         NULL,  0,		12},
	{"  ", "if [[ $BUTTON -eq  1 ]]; then st-float pulsemixer; fi; printf \"\\x0d \\x0d$(echo \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100 / 1\" | bc)\"",         NULL,  0,		13},
	{"   ", NULL,	 get_cpu_usage, 1,		0},
	{"   ", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	 NULL, 2,		0},
	{"  󰂄 ", "if [ -f /sys/class/power_supply/*/capacity ]; then cat /sys/class/power_supply/*/capacity; else echo '--'; fi",	 NULL, 65,		0},
	{"  ", "date '+󰃭 %b %d (%a) 󰅐 %I:%M%p'",			NULL, 30,		0},
	{"", "echo ' '",			NULL, 0,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = "";
static unsigned int delimLen = 5;

