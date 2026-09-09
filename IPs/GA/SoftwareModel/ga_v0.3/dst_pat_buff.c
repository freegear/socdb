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
b
#include <sys/stat.h>
#include "ga.h"


#include "dst_pat_buff.h"




//----------------------------------
// destination picture mask pattern buffer
//
int    used_fg = 0; // 현재 사용중인 버퍼의 번호를 저장.
uint   buff_addr[2]; // buffer에 저장된 pattern data가 저장되어 있던 memory의 주소.
uint   dst_pat_buff[2][2]; // dual buffer.  8byte * 2line
int    full_fg[2]; // 각 buffer가 fill되어 있는지 나타냄.








//==================================================================
// return the buffer full
int chk_dst_pat_full(int index)
// index : buffer line number
// return : full flag
{
	return full_fg[index & 1];
}







//--------------------------------------------------------
// check memory operation that read destination mask pattern
//  memory read 중이거나 read가 완료되어 buffer로 데이터가 전송되기 전까지는
//  항상 operation으로 표시
int chk_dst_pat_rd(void)
// return : OPMEM/NOPMEM
{




} // chk_dst_pat_rd






//---------------------------------------------------
// destination mask pattern이 memory에서 읽혀졌는지 확인하고,
// 그 결과를 destination pattern buffer에 저장한다.
int get_dst_pat(void)
// return : SUCC/FAIL
{
	// read operation이 완료 돼는지 확인.

	
	// 데이터를 destination pattern buffer에 복사.

} // get_dst_pat







//-----------------------------------------------------------
// send read command for destination pattern
void read_dst_pat(uint pat_addr)
// dst_addr : target address of pattern
{


} // read_dst_pat







//---------------------------------------------------
// destination mask pattern이 memory에서 읽혀졌는지 확인하고,
// 그 결과를 destination pattern buffer에 저장한다.
int get_dst_pat(void)
// return : SUCC/FAIL
{
	// read operation이 완료 돼는지 확인.

	
	// 데이터를 destination pattern buffer에 복사.

} // get_dst_pat







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
	if(buff_hit[used_fg&1] == 0) // if miss
		full_fg[i] = 0;

	// set actived buffer number
	if(buff_hit[1] != 0) used_fg = 1;
	else  used_fg = 0;

	if(buff_hit[0] != 0 || buff_hit[1] != 0) // hit
		return HIT;
	else return MISS;

} // chk_dst_pat






//---------------------------------------------------
// read destination pattern
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
	pixel = dst_pat_buff[used_fg&1][(hpos>>5) & 1] >> off_at_buff;
	
	pixel &= 1;
	
	return   pixel;
} // rd_dst_pixel






//================================================================
// 두개의 address를 읽어 결과를 return
int rd_src_pat_two(uint addr0, uint addr1, uint hpos,
				   uint *pat0, uint *pat1)
// addr0 : address of the lower vertical number pixel
// addr1 : address of the highter vertical number pixel
// hpos : horizontal position
// pat0 : pattern
// pat1 : pattern
// return : RUN/NOP
{
	int      hit[2];


	if(chk_src_rd() == NOMEM) return NOP;

	hit[0] = chk_src_pat_buff(addr0);
	if(addr0 == addr1) hit[1] = hit[0];
	else hit[1] = chk_src_pat_buff(addr1);	

	// change low vertical line
	if(hit[0] >= 0) {
		if(hit[0] == 0) small_vline = 0;
		else small_vline = 1;
	}
	else if(hit[1] >= 0) {
		if(hit[1] == 0) small_vline = 1;
		else small_vline = 0;
	} // else if
	// else, no change
	
	// pixel of lower vertical position 
	if(hit[0] < 0) { // if miss
		read_src(addr0, 0);
		return NOP;
	} // if miss
	
	// pixel of higher vertical position 
	if(addr0 != addr1) {
		if(hit[1] < 0) { // if miss
			read_src(addr1, 1);
			return NOP;
		} // if miss
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






//--------------------------------------------------------------
// check only hit/miss
int chk_src_pat_buff(uint addr)
// addr : address of a source pixel
// return : hit(line num)/miss
{
	int     i;
	int     buff_hit[2];
	

	// search source buffer
	for(i=0;i<2;i++) {
		if(full_fg[i] != 0 && 
		   (addr>>SRC_BUFF_INDEX) == (buff_addr[i]>>SRC_BUFF_INDEX)) {
			return i;
		}
	} // for

	return -1;
} // chk_src_src_buff
