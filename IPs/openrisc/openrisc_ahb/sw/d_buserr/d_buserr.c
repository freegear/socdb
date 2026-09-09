/* This is exception test for OpenRISC 1200 */

#include "spr_defs.h"
#include "support.h"
#include "int.h"

#define BUSERR_ADDR 0x06000000

int main (void)
{
  int i;
  char *illegal_addr = (char *)BUSERR_ADDR;

  i = *illegal_addr;
  // if bus error exception occured correctly, program ended in the excepction vector, never reach this
  report (0xdead0000 + i);
  exit (0);
 
  return 0;
}

