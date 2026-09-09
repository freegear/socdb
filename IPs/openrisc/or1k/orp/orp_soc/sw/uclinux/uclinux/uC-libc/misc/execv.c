
#include <unistd.h>

extern char ** environ;

int execv(path, argv)
const char * path;
const char * argv[];
{
	return execve(path, argv, environ);
}
