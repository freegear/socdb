#define close __normal_close
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#undef _POSIX_PTHREADS
#include <syscall.h>
#include "dirstream.h"

#undef close
static inline
_syscall1(int,close,int,fd)

int
closedir(DIR * dir)
{
  int fd;

  if (!dir) {
    errno = EBADF;
    return -1;
  }

  /* We need to check dd_fd. */
  if (dir->dd_fd == -1)
  {
    errno = EBADF;
    return -1;
  }
  fd = dir->dd_fd;
  dir->dd_fd = -1;
  free(dir->dd_buf);
  free(dir);
  return close(fd);
}
