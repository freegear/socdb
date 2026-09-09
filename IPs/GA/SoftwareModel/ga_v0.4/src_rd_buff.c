/****************************************************

   Source Read Buffer

   file name : src_rd_buff.c
   created by gtlee
   data : 2006.10.16

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __SRC_RD_BUFF__
#define  __SRC_RD_BUFF__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"
#include "pcache.h"


#include "src_rd_buff.h"


//----------------------------------
// source picture read buffer
//    source의 vertical line에 따라 line이 별도로 관리됨.
//    두 line중 작은 vertical number의 pixel을 저장하고 있는 
//    버퍼번호를 sx_small_vline에 기록한다.
// 
int    sx_small_vline = 0;   // 현재 small vertical number의 pixel이 저장되어 있는 buffer
uint   buff_addr[2];      // buffer에 저장된 pixel data가 저장되어 있던 memory의 주소.
uint   src_rd_buff[2][SRC_BUFF_WLEGTH]; // 4. dual buffer.  16byte * 2line
int    full_fg[2];        // 각 buffer가 fill되어 있는지 나타냄.

int    mem_op;

// 24bpp에서 여러버퍼에 걸쳐 있을때 잠시 보관하는 버퍼.
// read buffer는 vertical line number가 따라 두개의 버퍼에 각각 저장 
// 되므로 여러 버퍼에 걸쳐서 pixel data가 존재하게 되면,
// 현재 버퍼에 있는 data를 백업하고, 다음 address의 pixel data를 
// 읽어서 나머지 pixel data를 읽어 조합한다.
uint   t_buff[2]; // used only 24bpp
int    split_24bpp[2]; // pixel정보가 두개의 src buffer에 나눠어져 있을 경우.





//======================================================
// check the buffer full
int chk_src_full(int index)
// index : buffer line number
// return : full flag
{
	return full_fg[index & 1];
} // chk_src_full







//-------------------------------------
// check memory operation that read source pixel
// cache read 중이거나 read가 완료되어 buffer로 데이터가 전송되기전까지는 
// 항상 operation으로 표시.
int chk_src_rd(void)
// return : OPMEM/NOMEM
{
	if(chk_cache_op(PCC_SRC_PIC) == TRUE)
		return OPMEM;
	
	return NOMEM;

} // chk_src_rd






//--------------------------------------------------
// send read command
void read_src(uint src_addr, int lowb)
// src_addr : target address of source pixels
// lowb : if low vertical number, 0
{
	int    bytes;
	int    buff_num;


	bytes = SRC_BUFF_WLEGTH * 4; // read bytes

	if(lowb == 0) buff_num = sx_small_vline;
	else buff_num = 1 & (~sx_small_vline);

	// memory operation command를 전송.
	// ToDo
	set_rd_cache(PCC_SRC_PIC, src_addr, bytes,
				 (uchar *)src_rd_buff[buff_num], 0);
	
	mem_op = lowb;

} // read_src







//=====================================================
// read buffer management

//    if the requested pixel data is not had in buffer,
//    clear buffers and send read command to the memory interface block

// check that a source pixel is existed in buffer
// 만일 access한 vertical position의 크고 작음이 hit한 버퍼의 
// 크고 작음과 다를 경우에는 buffer의 크고 작음을 바꾼다.
// 이때에 miss난 buffer는 버려지게 된다.
int chk_src_pixel(uint addr, int lowb)
// addr : address of a source pixel
// lowb : if low vertical number, 0
// return : hit/miss
{
	int     i;
	int     buff_hit[2];
	

	// search source buffer
	for(i=0;i<2;i++) {
		if(full_fg[i] != 0 && 
		   (addr>>SRC_BUFF_INDEX) == (buff_addr[i]>>SRC_BUFF_INDEX))
			buff_hit[i] = 1;
		else buff_hit[i] = 0;
	} // for


	if(buff_hit[0] != 0) {
		/////////////////////////////////////////
		//   sx_small_vline   buff[0]    lowb
		//        0         small    large=1 
		//        1         large    small=0
		//   result : if diff, change
		if(lowb != sx_small_vline)	sx_small_vline = lowb;
		return HIT;
	}
	else if(buff_hit[1] != 0) { // hit
		/////////////////////////////////////////
		//   sx_small_vline   buff[1]    lowb
		//        0         large    small=0
		//        1         small    large=1
		//   result : if same, change
		if(lowb == sx_small_vline)	sx_small_vline = (lowb == 0)? 1 : 0;
		return HIT;
	}
	else return MISS;

} // chk_src_pixel







// check that wait the load of other buffer at 24bpp
int chk_ld_src(int ctype, int hpos, int lowb)
// ctype : color type
// hpos : horizontal position
// lowb : vertical position. low, high
// return : SUCC/FAIL
{
	int         buff_sel;
	int    		off_at_buff;
	
	if(lowb == 0) // low(small) vertical number 
		buff_sel = sx_small_vline;
	else buff_sel = (~sx_small_vline) & 1;

	off_at_buff = hpos * 3;

	if(ctype == C24BPP && (off_at_buff >> 1) == 0x07) {

		if(full_fg[buff_sel] == 0) return WAIT;

		if(split_24bpp[lowb] == 0) {
			t_buff[lowb] = src_rd_buff[buff_sel][3&(off_at_buff>>2)];
			//t_buff >>= (3&off_at_buff) * 8; // no need byte select
			
			// 다음 데이터를 읽도록 control signal을 재 설정.
			split_24bpp[lowb] = 1;
			full_fg[buff_sel] = 0;
		
			return FAIL;
		}
		else return SUCC;
	}

	split_24bpp[lowb] = 0;

	return SUCC;
}








//---------------------------------------------------
// read pixel color

uint rd_src_pixel(int ctype, int hpos, int lowb)
// ctype : color type
// hpos  : horizontal position of pixel
// lowb  : low vertical position or high vertical position
// return : pixel color
{
	int    i;
	uint   pixel;
	int    off_at_buff; // byte단위 position
	int    buff_sel;
	
	// generate the offset in the buffer
	
	// clac. buffer shift count
	switch(ctype) { // color type
	case MONO : 
		off_at_buff = hpos >> 3;
		break;
	case C8BPP :
		off_at_buff = hpos;
		break;
	case C16BPP :
	case CA16BPP :
		off_at_buff = hpos * 2;
		break;
	case C24BPP :
		off_at_buff = hpos * 3;
		break;
	case C32BPP :
	case CA32BPP:
		off_at_buff = hpos * 4;
		break;
	default: // error
		printf("\n ERROR : invalide color type at reading source buffer.");
		exit(0);
	}// switch
	
	off_at_buff &= SRC_BUFF_IDX_MSK; // 유효자리는 4bit --> 0x0F
	

	if(lowb == 0) // low(small) vertical number 
		buff_sel = sx_small_vline;
	else buff_sel = (~sx_small_vline) & 1;

	
	// 상위 word에서 추출 at 24bpp.
	//    1. 두개의 버퍼에 걸쳐 있을 경우.
	//    2. 한 버퍼내에서 상위 워드와 하위 워드에 분산 되어 있을 경우.
	
	// 두개의 버퍼에 걸쳐서 존재하는지 검사.
	if(ctype == C24BPP  && (off_at_buff >> 1) == 0x07) { // 두개의 버퍼에 걸쳐서 존재하는지 검사.
		pixel = src_rd_buff[buff_sel][0]; // upper bytes
		i = -1;

		if(off_at_buff & 1 == 0) {
			pixel <<= 8 * 2;
			i <<= 8 * 2;
		} // if
		else {
			pixel <<= 8 * 1;
			i <<= 8 * 1;
		} // else
		pixel &= i; // clear low bytes

		// set low bytes
		i = ~i;
		pixel |= i & (t_buff[lowb] >> ((3&off_at_buff) * 8));
		
		return pixel;
	}
	else if((off_at_buff & 0x03) != 0 && (off_at_buff>>2) != 0x07) { // exist upper word
		pixel = src_rd_buff[buff_sel][(off_at_buff>>2) + 1];
	} // if exist upper word
	else pixel = 0;
		
	split_24bpp[lowb] = 0;

	// 하위 word
	pixel <<= (off_at_buff & 0x03) << 3; // byte단위 이동.
	i = -1; // set all bit 1.
	i <<= (off_at_buff & 0x03) << 3;
	pixel &= i; // clear low bytes
	
	i = ~i; // bit inverse
	pixel |= i & (src_rd_buff[buff_sel][off_at_buff>>2] >> 
				  ((off_at_buff & 0x03) << 3));

	// MONO일때.
	if(ctype == MONO) {
		pixel >>= hpos & 3; // byte내에서 bit위치 보정.
		pixel &= 1;
	}

	return pixel;
} // rd_src_pixel








//================================================================
// 두개의 address를 읽어 결과를 return
int rd_src_two(uint addr0, uint addr1, uint hpos,
			   int ctype,  uint *pixel0, uint *pixel1)
// addr0 : address of the lower vertical number pixel
// addr1 : address of the highter vertical number pixel
// hpos : horizontal position
// ctype : color type
// pixel0 : pixel color
// pixel1 : pixel color
// return : RUN/WAIT
{
	int      hit[2];


	if(chk_src_rd() == NOMEM) return WAIT;

	hit[0] = chk_src_buff(addr0);
	if(addr0 == addr1) hit[1] = hit[0];
	else hit[1] = chk_src_buff(addr1);	

	// change low vertical line
	if(split_24bpp[0] == 0 && split_24bpp[1] == 0) {
		if(hit[0] >= 0) {
			if(hit[0] == 0) sx_small_vline = 0;
			else sx_small_vline = 1;
		}
		else if(hit[1] >= 0) {
			if(hit[1] == 0) sx_small_vline = 1;
			else sx_small_vline = 0;
		} // else if
		// else, no change
	} // if
	
	// pixel of lower vertical position 
	if(hit[0] < 0) { // if miss
		read_src(addr0, 0);
		full_fg[sx_small_vline] = 1; // 미리 set
		return WAIT;
	} // if miss
	else if(split_24bpp[0] == 0) { // if hit and not split
		if(chk_ld_src(ctype,hpos,0) == FAIL) { // if split pixel
			full_fg[sx_small_vline] = 0; // clear buffer
			buff_addr[sx_small_vline] += SRC_BUFF_WLEGTH*4; // address update
			
			// send read command for getting a next pixel
			read_src(buff_addr[sx_small_vline], 0);
			full_fg[sx_small_vline] = 1; // 미리 set
			return WAIT;
		}
	} // hit
	// else

	
	// pixel of higher vertical position 
	if(addr0 != addr1) {
		if(hit[1] < 0) { // if miss
			read_src(addr1, 1);
			full_fg[1&(~sx_small_vline)] = 1;
			return WAIT;
		} // if miss
		else if(split_24bpp[1] == 0) { // if hit and not split
			if(chk_ld_src(ctype,hpos,1) == FAIL) { // if split pixel
				full_fg[sx_small_vline] = 0; // clear buffer
				buff_addr[sx_small_vline] += SRC_BUFF_WLEGTH*4; // address update
			
				// send read command for getting a next pixel
				read_src(buff_addr[sx_small_vline], 1);
				full_fg[1&(~sx_small_vline)] = 1;
				return WAIT;
			}
		} // hit
	} // if same  two pixel
	// else

	// really read source pixel buffer
	*pixel0 = rd_src_pixel(ctype, hpos, 0);

	if(addr0 != addr1) {
		*pixel1 = rd_src_pixel(ctype, hpos, 1);
	}
	else *pixel1 = *pixel0;
	
	return RUN;
} // rd_src_two




//-------------------------------------------------
// check only hit/miss
int chk_src_buff(uint addr)
// addr : address of a source pixel
// return : hit(line num)/miss
{
	int     i;

	// search source buffer
	for(i=0;i<2;i++) {
		if(full_fg[i] != 0 && 
		   (addr>>SRC_BUFF_INDEX) == (buff_addr[i]>>SRC_BUFF_INDEX)) {
			return i;
		}
	} // for

	return -1;
} // chk_src_buff
