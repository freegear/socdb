#include <errno.h>
#include <syscall.h>
#include <sys/time.h>

#define __NR__select SYS_select

static inline
_syscall5(int, _select,
	int, __width, 
	fd_set *, __readfds, 
	fd_set *, __writefds, 
	fd_set *, __exceptfds, 
	struct timeval *, __timeout);

int
select(int nd, fd_set * in, fd_set * out, fd_set * ex,
	struct timeval * tv)
{
	long __res;
/*	register long d0 asm ("%d0");

	__asm__ volatile ("movel %2,%/d1\n\t"
			  "trap  #0\n\t"
		: "=g" (d0)
		: "0" (SYS_select),"g" ((long) &nd) : "%d0", "%d1");
	__res = d0;
*/
	__res = _select(nd, in, out, ex, tv);
	if (__res >= 0)
		return (int) __res;
	errno = -__res;
	return -1;
}
