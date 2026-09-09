#include <errno.h>

#define __check_errno(__res)    ((__res) >= 0)

#include <asm/unistd.h>
#include <sys/syscall.h>
