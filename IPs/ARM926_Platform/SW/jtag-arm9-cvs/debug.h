
int debug_poll(int argc, char **argv);
int debug_halt(int argc, char **argv);
int debug_restart(int argc, char **argv);
int debug_exec(unsigned long * data, int type);

#define DEBUG_SPEED		0
#define SYSTEM_SPEED		1
#define DEBUG_SPEED_SHORT	2	
