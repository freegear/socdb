/* Support file for or32 tests.  This file should is included
   in each test. It calls main() function and add support for
   basic functions */

#ifndef SUPPORT_H
#define SUPPORT_H

#include <stdarg.h>
#include <_ansi.h>
#include <stddef.h>
#include <limits.h>

#if OR1K
void printf(const char *fmt, ...);

/* For writing into SPR. */
void mtspr(unsigned long spr, unsigned long value);

/* For reading SPR. */
unsigned long mfspr(unsigned long spr);

#else /* OR1K */

#include <stdio.h>

#endif /* OR1K */

/* Function to be called at entry point - not defined here.  */
int main ();

/* Prints out a value */
void report(unsigned long value);

/* return value by making a syscall */
extern void exit (int i) __attribute__ ((__noreturn__));

/* memcpy clone */
extern void *memcpy (void *__restrict __dest,
                     __const void *__restrict __src, size_t __n);

/* Timer functions */
extern void start_timer(int);
extern unsigned int read_timer(int);

#endif
