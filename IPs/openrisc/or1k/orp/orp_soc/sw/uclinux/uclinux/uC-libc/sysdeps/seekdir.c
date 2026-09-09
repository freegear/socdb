#define lseek __normal_lseek
#include <unistd.h>
#include <errno.h>
#undef _POSIX_PTHREADS
#include <syscall.h>
#undef lseek

#include "dirstream.h"

static inline
_syscall3(off_t,lseek,int,fildes,off_t,offset,int,origin)

void seekdir(DIR * dir, off_t offset)
{
  if (!dir) {
    errno = EBADF;
    return;
  }
  dir->dd_nextoff = lseek(dir->dd_fd, offset, SEEK_SET);
  dir->dd_size = dir->dd_nextloc = 0;
}
