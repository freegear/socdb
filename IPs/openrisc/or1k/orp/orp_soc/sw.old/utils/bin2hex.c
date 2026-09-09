#include <stdio.h>

/* Number of bytes before line is broken
   For example if target flash is 8 bits wide,
   define BREAK as 1. If it is 16 bits wide,
   define it as 2 etc.
*/
#define BREAK 1
 
int main(int argc, char **argv)
{

	FILE  *fd;
	int c;
	int i = 0;

	if(argc < 2) {
		printf("no input file specified\n");
		exit(1);
	}
	
	fd = fopen( argv[1], "r" );
	
	while ((c = fgetc(fd)) != EOF) {
		printf("%.2lx", c);
		if (++i == BREAK) {
			printf("\n");
			i = 0;
		}
        }
	return 0;
}	
