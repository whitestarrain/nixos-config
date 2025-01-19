#include "toolkits.h"

//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{" ", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	 NULL, 1,		0},
	{" ", "date '+%b %d (%a) %I:%M%p'",			NULL, 30,		0},
	{" ", NULL,	 get_cpu_usage, 1,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;

