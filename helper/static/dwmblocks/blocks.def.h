void hello_nix(char* status_buf, int len){
	strncpy(status_buf, "hello nix ", len);
}

//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/	/*C function*/	/*Update Interval*/	/*Update Signal*/
	{"Mem:", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g", NULL,	30,		0},
	{"", "date '+%b %d (%a) %I:%M%p'",		NULL,			5,		0},
	{"", NULL,		hello_nix,			0,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
