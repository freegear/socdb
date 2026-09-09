/****************************************************
  
   Read Palette of a source picture

   file name : src_pal_buff.c
   created by gtlee
   data : 2006.10.19

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __SRC_PAL_BUFF__
#define  __SRC_PAL_BUFF__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"
#include "pcache.h"


#include "src_pal_buff.h"



//----------------------------------
// source palette read buffer
//
uint   buff_addr; // buffer에 저장된 palette data가 저장되어 있던 memory의 주소.
uint   src_pal_buff[SRCPL_BUFF_WLEGTH]; // 16byte
int    full_fg; // 각 buffer가 fill되어 있는지 나타냄.




//======================================================
// check the buffer full
int chk_src_pal_full(void)
// return : full flag
{
	return full_fg;
} // chk_src_pal_full





//---------------------------------------
// update full flag
void set_pal_full(void)
{
	full_fg = 1;

} // set_pal_full






//-------------------------------------
// check memory operation that read source palette
// memory read 중이거나 read가 완료되어 buffer로 데이터가 전송되기전까지는 
// 항상 operation으로 표시.
int chk_src_pal_rd(void)
// return : OPMEM/NOMEM
{
	if(chk_cache_op(PCC_PALLETE) == TRUE)
		return OPMEM;
	
	return NOMEM;

} // chk_src_pal







//--------------------------------------------------
// send read command
void read_src_pal(uint addr)
// addr : target address of source palette
{
	int    bytes;

	bytes = 4*SRCPL_BUFF_WLEGTH;

	buff_addr = addr & (~SRCPL_BUFF_IDX_MSK);
	full_fg = 0;

	// memory operation command를 전송.
	// ToDo
	set_rd_cache(PCC_PALLETE, addr, bytes, (uchar *)src_pal_buff, 0);

} // read_src_pal








//=====================================================
// read buffer관리.
//    요청한 address가 현재 buffer에 없을 경우에는 현재 buffer를
//    clear하고, memory interface에 read command를 전송한다.

// check that a source palette is existed in buffer
int chk_src_pal(uint addr)
// addr : address of a source palette
// return : hit/miss
{
	int    i;

	int    buff_hit; // palette buffer에 원하는 pixel이 있을 경우.
	
	// search destination buffer
	if(full_fg != 0 && 
	   (addr>>SRCPL_BUFF_INDEX ) == (buff_addr>>SRCPL_BUFF_INDEX ))
		buff_hit = 1;
	else buff_hit = 0;


	// buffer line을 다 사용하면 full flag를 clear
	if(buff_hit == 0) // if miss
		full_fg = 0;

	if(buff_hit != 0) // hit
		return HIT;
	else return MISS;
} // chk_src_pal






//----------------------------------------------------------
// read source palette

uint rd_src_pal(uint addr)
// addr : address of a palette
// return : palette
{
	int    i;
	uint   pal;
	int    off_at_buff; // byte단위 position
	
	// generate the offset in the buffer
	off_at_buff = addr & SRCPL_BUFF_IDX_MSK; // 유효자리는 2bit --> 0x0c
	off_at_buff >>= 2;

	pal = src_pal_buff[off_at_buff];
	
	return pal;
} // rd_src_pal
