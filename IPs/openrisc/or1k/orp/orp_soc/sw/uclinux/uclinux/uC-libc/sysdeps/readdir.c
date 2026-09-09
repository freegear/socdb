#include <dirent.h>
#include <errno.h>
#include <syscall.h>

#include "dirstream.h"

static inline
_syscall3(int, getdents, int, __fildes, struct dirent *, __buf, size_t, __nbyte);

struct dirent *
readdir (DIR *dir)
{
  int result;
  struct dirent *de;

  if (!dir)
    {
      errno = EBADF;
      return NULL; 
    }

  if (dir->dd_size <= dir->dd_nextloc)
    {
      /* read dir->dd_max bytes of directory entries. */
      result = getdents(dir->dd_fd, dir->dd_buf, dir->dd_max);
/*      __asm__ ("movel %2,%/d1\n\t"
	       "movel %3,%/d2\n\t"
	       "movel %4,%/d3\n\t"
	       "movel %1,%/d0\n\t"
	       "trap  #0\n\t"
	       "movel %/d0,%0"
	       : "=g" (result)
	       : "i" (SYS_getdents), "g" (dir->dd_fd), "g" (dir->dd_buf),
		 "g" (dir->dd_max)
	       : "%d0", "%d1", "%d2", "%d3");
*/
      /* We must have getdents (). */
      dir->dd_getdents = have_getdents;
      if (result <= 0)
	{
	  errno = -result;
	  return NULL;
	}

      dir->dd_size = result;
      dir->dd_nextloc = 0;
    }

  de = (struct dirent *) ((char *) dir->dd_buf + dir->dd_nextloc);

  /* Am I right? H.J. */
  dir->dd_nextloc += de->d_reclen;

  /* We have to save the next offset here. */
  dir->dd_nextoff = de->d_off;

  return de;
}
