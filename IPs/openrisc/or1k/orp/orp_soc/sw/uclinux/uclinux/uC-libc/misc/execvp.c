
#include <unistd.h>

extern char ** environ;

int execvp(path, argv)
const char * path;
const char * argv[];
{
	return execvep(path, argv, environ);
}
