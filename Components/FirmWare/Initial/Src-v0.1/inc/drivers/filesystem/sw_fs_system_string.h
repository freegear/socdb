#ifndef __SYSTEM_STRING_H__
#define	__SYSTEM_STRING_H__

#include <stdarg.h>
#include <string.h>

#if 0
#if  !defined(linux) && !defined(__arm)


int snprintf(char *buf, size_t size, const char *fmt, ...);
int vsnprintf(char *buf, int size, const char *fmt, va_list ap);
int fdprintf(int fd, const char *fmt, ...);

int strncasecmp(const char *s1, const char *s2, size_t n);

#endif

#if  !defined(linux)
int strcasecmp(const char *s1, const char *s2);
#endif
#endif

#endif
