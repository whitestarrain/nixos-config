#include "toolkits.h"

//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"","/home/wsain/MyRepo/_temp/click_me.sh", NULL, 0,		1},
	{" ", NULL,	 get_cpu_usage, 1,		0},
	{" ", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	 NULL, 2,		0},
	{"󰂄 ", "if [ -f /sys/class/power_supply/*/capacity ]; then cat /sys/class/power_supply/*/capacity; else echo '--'; fi",	 NULL, 5,		0},
	{"󰅐 ", "date '+%b %d (%a) %I:%M%p'",			NULL, 30,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = "  ";
static unsigned int delimLen = 5;

