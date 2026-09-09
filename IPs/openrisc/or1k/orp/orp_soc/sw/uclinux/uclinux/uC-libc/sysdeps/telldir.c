#define lseek __normal_lseek
#include <unistd.h>
#include <syscall.h>
#include <errno.h>
#undef lseek

#include "dirstream.h"

static inline
_syscall3(off_t,lseek,int,fildes,off_t,offset,int,origin)

off_t
telldir(DIR * dir)
{
  off_t offset;

  if (!dir) {
    errno = EBADF;
    return -1;
  }

  switch (dir->dd_getdents)
  {
  case no_getdents:
    /* We are running the old kernel. This is the starting offset
       of the next readdir(). */
    offset = lseek(dir->dd_fd, 0, SEEK_CUR);
    break;

  case unknown:
    /* readdir () is not called yet. but seekdir () may be called. */
  case have_getdents:
    /* The next entry. */
    offset = dir->dd_nextoff;
    break;

  default:
    errno = EBADF;
    offset = -1;
  }

  return offset;
}
