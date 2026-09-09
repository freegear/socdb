#include <syscall.h>
#include <unistd.h>
#include <errno.h>

inline static
_syscall5(int,_llseek,int,fd,off_t,hoff,off_t,loff,loff_t*,res,int,whence);

loff_t llseek (int fd, loff_t offset, int whence)
{
  int ret;
  loff_t result;

  ret = _llseek (fd, (off_t) (offset >> 32),
	(off_t) (offset & 0xffffffff), &result, whence);

  return ret ? (loff_t) ret : result;
}
