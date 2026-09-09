/* This is exception test for OpenRISC 1200 */

#include "spr_defs.h"
#include "support.h"
#include "int.h"

#define BUSERR_ADDR 0x06000000

typedef (*func_ptr)(void);

int main (void)
{
  func_ptr illegal_addr_func = (func_ptr)BUSERR_ADDR;

  illegal_addr_func();

  // if bus error exception occured correctly, program ended in the excepction vector, never reach this
  report (0xdead0000);
  exit (0);
 
  return 0;
}

