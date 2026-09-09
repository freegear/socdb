/****************************************************

   Destination picture mask pattern Read Buffer

   file name : dst_pat_buff.c
   created by gtlee
   data : 2006.10.14

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __DST_PAT_BUFF__
#define  __DST_PAT_BUFF__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"
#include "gbus.h"


#include "dst_pat_buff.h"




//----------------------------------
// destination picture mask pattern buffer
//
int    dp_used_fg = 0; // 현재 사용중인 버퍼의 번호를 저장.
uint   buff_addr[2]; // length is 2. buffer에 저장된 pattern data가 저장되어 있던 memory의 주소.
uint   dst_pat_buff[2][DSTP_BUFF_WLEGTH]; // dual buffer.  8byte * 2line
int    full_fg[2]; // 각 buffer가 fill되어 있는지 나타냄.






//==================================================================
// return the buffer full
int chk_dst_pat_full(int index)
// index : buffer line number
// return : full flag
{
	return full_fg[index & 1];
}







//---------------------------------------
// update full flag
void set_dst_pat_full(int index)
// index : buffer line number
{
	full_fg[index & 1] = 0;
	
} // set_dst_full







//--------------------------------------------------------
// check memory operation that read destination mask pattern
//  memory read 중이거나 read가 완료되어 buffer로 데이터가 전송되기 전까지는
//  항상 operation으로 표시
int chk_dst_pat_rd(void)
// return : OPMEM/NOMEM
{
	if(chk_op(MEM_DST_PAT) == TRUE)
		return OPMEM;
	else return NOMEM;
	
} // chk_dst_pat_rd









//-------------------------------------------------
// get used flag
int get_dst_pat_used_fg(void)
{
	return dp_used_fg;

} // get_dst_pat_used_fg








//-----------------------------------------------------------
// send read command for destination pattern
void read_dst_pat(uint pat_addr)
// dst_addr : target address of pattern
{


	// memory operation command를 전송.
	// ToDo
	if( set_rd_mem(MEM_DST_PAT, pat_addr, 4*DSTP_BUFF_WLEGTH, 
				   (uchar *)dst_pat_buff, 0) == FAIL) {
		printf("\n ERROR : cannot send memory operation at a destination pattern.");
		exit(0);
	} // if

} // read_dst_pat








//=====================================================
// read buffer management
//    if the requested pixel data is not had in buffer,
//    clear buffers and send read command to the memory interface block


// check that a destination mask pattern is existed in buffer
int chk_dst_pat(uint addr)
// addr : address of a destination pattern
// return : hit/miss
{
	int     i;
	int     buff_hit[2];
	

	// search destination buffer
	for(i=0;i<2;i++) {
		if(full_fg[i] != 0 && 
		   (addr>>DSTP_BUFF_INDEX) == (buff_addr[i]>>DSTP_BUFF_INDEX))
			buff_hit[i] = 1;
		else buff_hit[i] = 0;
	} // for

	// if all pixels of the buffer line, then clear full flag.
	if(buff_hit[dp_used_fg&1] == 0) // if miss
		full_fg[i] = 0;

	// set actived buffer number
	if(buff_hit[1] != 0) dp_used_fg = 1;
	else  dp_used_fg = 0;

	if(buff_hit[0] != 0 || buff_hit[1] != 0) // hit
		return HIT;
	else return MISS;

} // chk_dst_pat






//---------------------------------------------------
// read destination pattern in buffer
//   color type : mono
int rd_dst_pat(int hpos)
// hpos : horizontal position of pixel
// return : pattern value
{
	uint   pixel;
	int    off_at_buff; // byte position
	
	// generate the offset in the buffer
	// clac. buffer shift count
	off_at_buff = hpos & 0x1F; // bit position
	
	// word
	pixel = dst_pat_buff[dp_used_fg&1][(hpos>>5) & 1] >> off_at_buff;
	
	pixel &= 1;
	
	return   pixel;
} // rd_dst_pixel



