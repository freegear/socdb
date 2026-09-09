/* Test l.mul, l.mac and l.macrc instructions */

#include "../support/support.h"

void buserr_except(){}
void dpf_except(){}
void ipf_except(){}
void lpint_except(){}
void align_except(){}
void illegal_except(){}
void hpint_except(){}
void dtlbmiss_except(){}
void itlbmiss_except(){}
void range_except(){}
void syscall_except(){}
void res1_except(){}
void trap_except(){}
void res2_except(){}

#define T1 0x5d9da965
#define T2 0xd644c789
#define T3 0xa703904d

#ifndef OR1K

#include <stdlib.h>
#define LONGEST long long

LONGEST acc = 0;
#define MAC(x,y) {\
  /*printf ("[%08x,%08x]\t", (unsigned long)(x), (unsigned long)(y));*/\
  acc += (LONGEST)(x) * (LONGEST)(y);\
  /*printf ("(%08x,%08x)\n", (unsigned long)(acc >> 32), (unsigned long)(acc & 0xffffffff));*/\
}
#define MACRC    (macrc())
static inline long macrc() {
  long result = acc >> 28;
  //printf ("<%08x>\n", (unsigned long)result);
  acc = 0;
  return result;
}
#else /* OR1K */

#define MAC(x,y) asm volatile ("l.mac\t%0,%1" : : "r" (x), "r" (y))
#define MACRC macrc()
static inline long macrc() {
  long x;
  asm volatile ("l.macrc\t%0" : "=r" (x));
  return x;
}

#endif /* SIM */

long test_mul (long a, long b) {
  long t;
  int i;
  for (i = 0; i < 10; i++) {
    t = a * b;
    t += 153;
    a = t - a * 17;
    b = t + b * 13333;    

    /*printf ("(%08x,%08x)", a, b);*/
  }
  return a;
}

long test_mac (long a, long b) {
  long t = 1234567;
  int i;
  for (i = 0; i < 10; i++) {
    MAC (a, b);
    if (i & 3) {
      a = t - a;
      b = t + a;
    } else {
      a = MACRC;
    }
    MAC (a, 3);
    MAC (a, 5);
    MAC (a, 7);
    //printf ("(%08x,%08x)", a, b);
  }
  return a;
}

long test_mul_mac (long a, long b) {
  long t = 1;
  int i;
  for (i = 0; i < 10; i++) {
    a = a * 119;
    MAC (a, b);
    MAC (b, 423490431);
    MAC (b, 113);
    MAC (a, 997);
    b = 87 * a * t;
    if (i & 3) {
      t = a * b;
      a = t - a;
      b = t + a;
    } else {
      a = MACRC;
    }
 //   printf ("(%08x,%08x)", a, b);
  }  
  return a;
}

int main () {
  unsigned t1 = test_mul (888888887, 0x87654321);
  unsigned t2 = test_mac (888888887, 0x87654321);
  unsigned t3 = test_mul_mac (888888887, 0x87654321);
  printf ("%08x, expected %08x\n", t1, T1);
  printf ("%08x, expected %08x\n", t2, T2);
  printf ("%08x, expected %08x\n", t3, T3);
  report (t1);
  report (t2);
  report (t3);
  report (t1 ^ t2 ^ t3 ^ T1 ^ T2 ^ T3 ^ 0xdeaddead);
  if (t1 != T1 || t2 != T2 || t3 != T3) {
    printf ("Test failed!\n");
    if (t1 != T1) exit (1);
    if (t2 != T2) exit (2);
    if (t3 != T3) exit (3);
  } else {
    printf ("Test succesful.\n");
    exit (t1 ^ t2 ^ t3 ^ T1 ^ T2 ^ T3 ^ 0xdeaddead);
  }
}

