/* veriuser.c for ModelGen Model Manager (Verilog-XL).
 *
 * Copyright (C) ARM Ltd, 1995-1999
 * All rights reserved.
 */

#include <stdlib.h>
#include "veriuser.h"
#include "vxl_veriuser.h"

extern int mm_call();
extern int mm_misc();

char *
#ifdef MG_WINNT
__declspec(dllexport)
#endif
veriuser_version_str = "";

int 
#ifdef MG_WINNT
__declspec(dllexport)
#endif
(*endofcompile_routines[TF_MAXARRAY])() = { 0 };

bool 
#ifdef MG_WINNT
__declspec(dllexport)
#endif
err_intercept(level, facility, code)
int level;
char *facility;
char *code;
{
  return true;
}

s_tfcell 
#ifdef MG_WINNT
__declspec(dllexport)
#endif
veriusertfs[TF_MAXARRAY] = 
{
  { usertask, 0, NULL, NULL, mm_call, mm_misc, "$mm", 1 },
  { 0 }
};
