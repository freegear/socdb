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


#include "src_pat_buff.h"





//----------------------------------
// source picture mask pattern buffer
//
int    small_vline = 0;   // 현재 small vertical number의 pixel이 저장되어 있는 buffer
uint   buff_addr[2]; // buffer에 저장된 pattern data가 저장되어 있던 memory의 주소.
uint   src_pat_buff[2][2]; // dual buffer.  8byte * 2line
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
// return : OPMEM/NOPMEM
{




} // chk_src_pat_rd






//-----------------------------------------------------------
// send read command for source pattern
void read_src_pat(uint pat_addr, int lowb)
// pat_addr : target address of pattern
// lowb : if low vertical number, 0
{
	uint   target_addr;


	target_addr = pat_addr;
	

	// insert that send read command



	
	mem_op = lowb;


} // read_dst_pat






//---------------------------------------------------
// source mask pattern이 cache에서 읽혀졌는지 확인하고,
// 그 결과를 source pattern buffer에 저장한다.
int get_src_pat(void)
// return : SUCC/FAIL
{
	int    buff_sel;
	
	// low vertical line 표시 flag를 설정.
	if(mem_op == 0) // low(small) vertical number 
		buff_sel = small_vline;
	else buff_sel = (small_vline)? 0 : 1;






	return SUCC;
} // get_src_pat







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
		//   small_vline   buff[0]    lowb
		//        0         small    large=1 
		//        1         large    small=0
		//   result : if diff, change
		if(lowb != small_vline)	small_vline = lowb;
		return HIT;
	}
	else if(buff_hit[1] != 0) { // hit
		/////////////////////////////////////////
		//   small_vline   buff[1]    lowb
		//        0         large    small=0
		//        1         small    large=1
		//   result : if same, change
		if(lowb == small_vline)	small_vline = (lowb == 0)? 1 : 0;
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
		buff_line_num = small_vline;
	else buff_line_num = (small_vline)? 0 : 1;

	// word
	pixel = src_pat_buff[buff_line_num][(hpos>>5) & 1] >> off_at_buff;
	
	pixel &= 1;
	
	return   pixel;
} // rd_src_pixel
