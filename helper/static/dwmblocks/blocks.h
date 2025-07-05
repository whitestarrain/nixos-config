#include "toolkits.h"

// warn: preprocessing doesn't retain line breaks
#define STR(s) #s

//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*C function*/	/*Update Interval*/	/*Update Signal*/

	{
		"",
		STR(
			if [[ $BUTTON -eq  1 ]]; then
				st-float impala;
			fi;
			printf '[\x0b󰖩 \x0b'
		),
		NULL, 0, 11
	},
	{
		"",
		STR(
			if [[ $BUTTON -eq  1 ]]; then
				st-float bluetuith;
			fi;
			printf '\x0c󰂯\x0c]'
		),
		NULL, 0, 12
	},
	{"  󰯎 ", NULL, get_net_speed, 1,		0},
	{
		"  ",
		STR(
			if [[ $BUTTON -eq  1 ]]; then
				st-float pulsemixer;
			fi;
			volume_percent="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)";
			volume="$(echo "$volume_percent * 100 / 1" | bc)";
			printf "\x0d \x0d${volume}"
		),
		NULL, 0, 13
	},
	{"   ", NULL,	 get_cpu_usage, 1,		0},

#ifdef CPU_TERMPERATURE_FILE_PATH
	{"   ", NULL, get_cpu_temperature, 1,		0},
#endif

	{"   ", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	 NULL, 2,		0},
	{"  󰂄 ", "if [ -f /sys/class/power_supply/*/capacity ]; then cat /sys/class/power_supply/*/capacity; else echo '--'; fi",	 NULL, 10,		0},
	{"  ", "date '+󰃭 %b %d (%a) 󰅐 %I:%M%p'",			NULL, 30,		0},
	{"", "echo ' '",			NULL, 0,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = "";
static unsigned int delimLen = 5;

