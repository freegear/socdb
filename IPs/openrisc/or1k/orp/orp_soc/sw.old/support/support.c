/* Support */

#include <sys/time.h> 
#include "support.h"

#if OR1K

/* Start function, called by reset exception handler.  */
void reset ()
{
  int i = main();
  exit (i);  
}

/* return value by making a syscall */
void exit (int i)
{
  asm("l.add r3,r0,%0": : "r" (i));
  asm("l.nop 1");
}

/* activate printf support in simulator */
void printf(const char *fmt, ...)
{
  va_list args;
  va_start(args, fmt);
  asm("l.addi\tr3,%0,0": :"r" (fmt));
  asm("l.addi\tr4,%0,0": :"r" (args));
  asm("l.nop 3");
}

/* print long */
void report(unsigned long value)
{
  asm("l.nop 2");
  return;
}

/* just to satisfy linker */
void __main()
{
}

/* start_TIMER                    */
void start_timer(int x)
{
}

/* read_TIMER                    */
/*  Returns a value since started in uS */
unsigned int read_timer(int x)
{
  unsigned long count = 0;

  /* Read the Time Stamp Counter */
/*        asm("simrdtsc %0" :"=r" (count));
  asm("l.nop X"); */
  return count;
}

/* For writing into SPR. */
void mtspr(unsigned long spr, unsigned long value)
{	
  asm("l.mtspr\t\t%0,%1,0": : "r" (spr), "r" (value));
}

/* For reading SPR. */
unsigned long mfspr(unsigned long spr)
{	
  unsigned long value;
  asm("l.mfspr\t\t%0,%1,0" : "=r" (value) : "r" (spr));
  return value;
}

#else
void report(unsigned long value)
{
  return;
}

/* start_TIMER                    */
void start_timer(int tmrnum)
{
  return;
}

/* read_TIMER                    */
/*  Returns a value since started in uS */
unsigned int read_timer(int tmrnum)
{
  struct timeval tv;
  struct timezone tz;

  gettimeofday(&tv, &tz);
	
  return(tv.tv_sec*1000000+tv.tv_usec);
}

#endif

void *memcpy (void *__restrict dstvoid,
              __const void *__restrict srcvoid, size_t length)
{
  char *dst = dstvoid;
  const char *src = srcvoid;

  while (length--)
    *dst++ = *src++;
  return dst;
}
