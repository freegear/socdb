/*************************************************************************
   Graphic Accelerator

   file name : ga.c
   created by gtlee
   data : 2006.6.30

   note :

   history :

************************************************************************/

#ifndef __GA__
#define __GA__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "ga.h"
#include "gpu.h"
#include "gbus.h"
#include "pcache.h"
#include "axi_if.h"




//==============================================================
// Graphic Accelerator Main Function
void ga(void)
{

	
	// Main Task
	while(1) {
		mem_op();
		cache_op();
		
		draw_pipe();
		draw_sm();

		if(gpu() == FAIL) break; // calc. horizontal range.

	} // while

}// ga
