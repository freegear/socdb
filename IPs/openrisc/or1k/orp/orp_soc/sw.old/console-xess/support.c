/* Support */

#include <stdarg.h>

#if OR1K

void __dummy() {} /* to fix RTL simulator bug */
void reset_support()
{	
	main();
	exit(0);
}

void printf(const char *fmt, ...)
{
        va_list args;
        va_start(args, fmt);
        asm("l.addi\tr3,%0,0": :"r" (fmt));
        asm("l.addi\tr4,%0,0": :"r" (args));
        asm("l.sys 202");
} 

void exit(int x)
{
  asm("l.sys 203");
}

void report(unsigned long value)
{
	unsigned long spr = 0x1234;
	asm("l.mtspr\t\t%0,%1,0x0" : : "r" (spr), "r" (value));
	return;
}

void __main()
{
}

void bcopy(const void *srcvoid, void * dstvoid, int length)
{
  char *dst = dstvoid;
  const char *src = srcvoid;

  while (length--)
	  *dst++ = *src++;
}

#else
void report(unsigned long value)
{
	unsigned long spr = 0x1234;
	printf("l.mtspr %x,%x\n", spr, value);
	return;
}
#endif
