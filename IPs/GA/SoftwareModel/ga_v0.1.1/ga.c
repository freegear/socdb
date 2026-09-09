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

// Picture Info.
s_pic   pic_info[NUM_PIC];

s_pic   *src_pic = &pic_info[SRC_PIC]; // pic_info[0]
s_pic   *dst_pic = &pic_info[DST_PIC]; // pic_info[1]
s_pic   *src_pat = &pic_info[SRC_PAT]; // pic_info[2]
s_pic   *dst_pat = &pic_info[DST_PAT]; // pic_info[3]
s_pic   *drw_pat = &pic_info[DRW_PAT]; // pic_info[4]


