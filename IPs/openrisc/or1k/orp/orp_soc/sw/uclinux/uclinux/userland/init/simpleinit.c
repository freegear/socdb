#include <stdlib.h>
#include <errno.h>

int main(void)
{
	int pid;
	int status;
	char *argv[3];
	char *envp[3];

	argv[0] = "/bin/sh";
	argv[1] = "/etc/rc";
	argv[2] = NULL;

        envp[0] = "HOME=/";
        envp[1] = "TERM=linux";
        envp[2] =  NULL;

        printf("Executing shell ... \n");
	if (!(pid = vfork())) {
                execve("/bin/sh", argv, envp);
        }

        for (;;) {
                pid = wait4(pid, &status, 0, 0);
                if ((pid < 0) && (errno == EINTR))
                        continue;
		if (pid < 0)
			break;
        }

	_exit(0);
        return 0;
}

