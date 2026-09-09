/****************************************************
  
   source picture mask pattern buffer

   file name : src_pat_buff.c
   created by gtlee
   data : 2006.10.18

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __SRC_PAT_BUFF__
#define  __SRC_PAT_BUFF__
#endif   // __SRC_PAT_BUFF__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"
#include "pcache.h"


#include "src_pat_buff.h"





//----------------------------------
// source picture mask pattern buffer
//
int    sp_small_vline = 0;   // 현재 small vertical number의 pixel이 저장되어 있는 buffer
uint   buff_addr[2]; // buffer에 저장된 pattern data가 저장되어 있던 memory의 주소.
uint   src_pat_buff[2][SRCP_BUFF_WLEGTH]; // 2. dual buffer.  8byte * 2line
int    full_fg[2]; // 각 buffer가 fill되어 있는지 나타냄.


int    mem_op;






//==================================================================
// check the buffer full
int chk_src_pat_full(int index)
// index : buffer line number
// return : full flag
{
	return full_fg[index & 1];
} // chk_src_pat_full




//-------------------------------------
// check memory operation that read source picture mask pattern
//  memory read 중이거나 read가 완료되어 buffer로 데이터가 전송되기 전까지는
//  항상 operation으로 표시
int chk_src_pat_rd(void)
// return : OPMEM/NOMEM
{
	if(chk_cache_op(PCC_SRC_PAT) == TRUE)
		return OPMEM;
	
	return NOMEM;

} // chk_src_pat_rd






//-----------------------------------------------------------
// send read command for source pattern
void read_src_pat(uint pat_addr, int lowb)
// pat_addr : target address of pattern
// lowb : if low vertical number, 0
{
	int    bytes;
	int    buff_num;

	bytes = SRCP_BUFF_WLEGTH * 4; // read bytes

	if(lowb == 0) buff_num = sp_small_vline;
	else buff_num = 1 & (~sp_small_vline);

	// insert that send read command
	// memory operation command를 전송.

	set_rd_cache(PCC_SRC_PAT, pat_addr, bytes,
				 (uchar *)src_pat_buff[buff_num], 0);
	
	mem_op = lowb;

} // read_dst_pat








//=====================================================
// read buffer management
//    if the requested pixel data is not had in buffer,
//    clear buffers and send read command to the memory interface block


// check that a source mask pattern is existed in buffer
int chk_src_pat(uint addr, int lowb)
// addr : address of a source pattern
// lowb : if low vertical number, 0
// return : hit/miss
{
	int     i;
	int     buff_hit[2];
	

	// search source buffer
	for(i=0;i<2;i++) {
		if(full_fg[i] != 0 && 
		   (addr>>SRCP_BUFF_INDEX) == (buff_addr[i]>>SRCP_BUFF_INDEX))
			buff_hit[i] = 1;
		else buff_hit[i] = 0;
	} // for

	if(buff_hit[0] != 0) {
		/////////////////////////////////////////
		//   sp_small_vline   buff[0]    lowb
		//        0         small    large=1 
		//        1         large    small=0
		//   result : if diff, change
		if(lowb != sp_small_vline)	sp_small_vline = lowb;
		return HIT;
	}
	else if(buff_hit[1] != 0) { // hit
		/////////////////////////////////////////
		//   sp_small_vline   buff[1]    lowb
		//        0         large    small=0
		//        1         small    large=1
		//   result : if same, change
		if(lowb == sp_small_vline)	sp_small_vline = (lowb == 0)? 1 : 0;
		return HIT;
	}
	else return MISS;

} // chk_src_pat







//---------------------------------------------------
// read source pattern
//   color type : mono
int rd_src_pat(int hpos, int lowb)
// hpos : horizontal position of pixel
// lowb : if low vertical number, 0
// return : pattern value
{
	uint   pixel;
	int    off_at_buff; // byte position
	int    buff_line_num;
	
	// generate the offset in the buffer
	// clac. buffer shift count
	off_at_buff = hpos & 0x1F; // bit position
	
	// buffer line number
	if(lowb == 0)
		buff_line_num = sp_small_vline;
	else buff_line_num = (sp_small_vline)? 0 : 1;

	// word
	pixel = src_pat_buff[buff_line_num][(hpos>>5) & 1] >> off_at_buff;
	
	pixel &= 1;
	
	return   pixel;
} // rd_src_pat










//================================================================
// 두개의 address를 읽어 결과를 return
int rd_src_pat_two(uint addr0, uint addr1, uint hpos,
				   uint *pixel0, uint *pixel1)
// addr0 : address of the lower vertical number pixel
// addr1 : address of the highter vertical number pixel
// hpos : horizontal position
// pixel0 : pixel color
// pixel1 : pixel color
// return : RUN/WAIT
{
	int      hit[2];


	if(chk_src_pat_rd() == NOMEM) return WAIT;

	hit[0] = chk_src_pat_buff(addr0);
	if(addr0 == addr1) hit[1] = hit[0];
	else hit[1] = chk_src_pat_buff(addr1);	

	// change low vertical line
	if(hit[0] >= 0) { // if low hit
		if(hit[0] == 0) sp_small_vline = 0;
		else sp_small_vline = 1;
	} // if
	else if(hit[1] >= 0) { // only high hit
		if(hit[1] == 0) sp_small_vline = 1;
		else sp_small_vline = 0;
	} // else if
	
	
	// pixel of lower vertical position 
	if(hit[0] < 0) { // if miss
		read_src_pat(addr0, 0);
		full_fg[sp_small_vline] = 1; // 미리 set
		return WAIT;
	} // if miss

	
	// pixel of higher vertical position 
	if(addr0 != addr1) { //  if not same two pixel
		if(hit[1] < 0) { // if miss
			read_src_pat(addr1, 1);
			full_fg[1&(~sp_small_vline)] = 1;
			return WAIT;
		} // if miss
	} // if not same two pixel


	// really read source pixel buffer
	*pixel0 = rd_src_pat(hpos, 0);

	if(addr0 != addr1) {
		*pixel1 = rd_src_pat(hpos, 1);
	}
	else *pixel1 = *pixel0;
	
	return RUN;
} // rd_src_pat_two




//-------------------------------------------------
// check only hit/miss
int chk_src_pat_buff(uint addr)
// addr : address of a source pattern
// return : hit(line num)/miss
{
	int     i;

	// search source buffer
	for(i=0;i<2;i++) {
		if(full_fg[i] != 0 && 
		   (addr>>SRCP_BUFF_INDEX) == (buff_addr[i]>>SRCP_BUFF_INDEX)) {
			return i;
		}
	} // for

	return -1;
} // chk_src_pat_buff
