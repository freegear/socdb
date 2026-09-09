/****************************************************

   Destination Read Buffer

   file name : dst_rd_buff.c
   created by gtlee
   data : 2006.10.12

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __DST_RD_BUFF__
#define  __DST_RD_BUFF__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"


#include "dst_rd_buff.h"


//----------------------------------
// destination picture read buffer
//
int    used_fg = 0; // 현재 사용중인 버퍼의 번호를 저장.
uint   buff_addr[2]; // buffer에 저장된 pixel data가 저장되어 있던 memory의 주소.
uint   dst_rd_buff[2][8]; // dual buffer.  32byte * 2line
int    full_fg[2]; // 각 buffer가 fill되어 있는지 나타냄.
int    dummy_wr_fg[2]; // modify하지 않을 pixel을 미리 write buffer로 전송했는지 나타내는 flag
                       // word당 1bit씩 할당하여 전송하지 않은 dummy word가 1으로 표시.
                       // dummy가 없는 word는 0로 표시. 
                       // read block에서 flag생성.
                       // 모든 word의 flag가 0이면 dummy전송 완료.





//======================================================
// check the buffer full
int chk_dst_full(int index)
// index : buffer line number
// return : full flag
{
	return full_fg[index & 1];
} // chk_dst_full






//-------------------------------------
// check memory operation that read destination pixel
// memory read 중이거나 read가 완료되어 buffer로 데이터가 전송되기전까지는 
// 항상 operation으로 표시.
int chk_dst_rd(void)
// return : OPMEM/NOPMEM
{



} // chk_dst_rd







//--------------------------------------------------
// send read command
void read_dst(uint dst_addr)
// dst_addr : target address of destination pixels
{


} // read_dst







//---------------------------------------------------
// destination pixel이 memory에서 읽혀졌는지 확인하고,
// 그 결과를 destination read buffer에 저장한다.
int get_dst(void)
// return : SUCC/FAIL
{




} // get_dst





//=====================================================
// read buffer관리.
//    요청한 address가 현재 buffer에 없을 경우에는 현재 buffer를
//    모두 clear하고, memory interface에 read command를 전송한다.

// check that a destination pixel is existed in buffer
int chk_dst_pixel(uint addr)
// addr : address of a destination pixel
// return : hit/miss
{
	int    i;

	int    buff_hit[2]; // destination buffer에 원하는 pixel이 있을 경우.
	
	// search destination buffer
	for(i=0;i<2;i++) {
		if(full_fg[i] != 0 && 
		   (addr>>DST_BUFF_INDEX ) == (buff_addr[i]>>DST_BUFF_INDEX ))
			buff_hit[i] = 1;
		else buff_hit[i] = 0;
	} // for

	// buffer line을 다 사용하면 full flag를 clear
	if(buff_hit[used_fg&1] == 0) // if miss
		full_fg[i] = 0;


	// 유효한 buffer의 번호를 나타내는 flag 변경.
	if(buff_hit[1] != 0) used_fg = 1;
	else  used_fg = 0;

	if(buff_hit[0] != 0 || buff_hit[1] != 0) // hit
		return HIT;
	else return MISS;
} // chk_dst_pixel










//---------------------------------------------------
// 다음 stage로 dummy word 전송.
int sd_dummy_wd(uint *word, uint *addr)
// word : pixel data for send
// addr : destination address
// return : bypass or not
{
	int    i;
	int    mask; // for bit masking
	
	// dummy 전송.
	if((dummy_wr_fg[used_fg&1] & 0x0FF) != 0) {
		for(i=0;i<DST_BUFF_WLEGTH;i++) {
			if(((dummy_wr_fg[used_fg&1]>>i) & 1) == 0) { // remain a data that will be sent
				*word = dst_rd_buff[used_fg&1][i];
				// set target address
				*addr = buff_addr[used_fg&1] & (~DST_BUFF_IDX_MSK); // clear offset in buffer
				*addr |=  (i << 2);
				
				mask = 1 << i;
				dummy_wr_fg[used_fg&1] &= ~mask; // 해당 bit을 clear
				return BYPASS;
			} // if
		} // for
	} // if.
	
	return RUN;
	
} // sd_dummy_wd









//------------------------------------------
// update dummy flag of start position pixel
void update_dummy_fg(int ctype, int st_addr, int ed_addr, int buff_num)
// ctype : color type
// st_addr : memory address of start position
// ed_addr : memory address of end position
// buff_num : target buffer number of destination pixel buffer
{
	int      i;
	int      word;

	uint     buff_line; // buffer의 시작 주소.
	uint     st_line; // start position이 포함되는 memory line의 주소
	uint     ed_line; // start position이 포함되는 memory line의 주소
	

	buff_line = buff_addr[buff_num] >> DST_BUFF_INDEX; // 32byte이므로 5
	st_line = st_addr >> DST_BUFF_INDEX; // 32byte이므로 5
	ed_line = ed_addr >> DST_BUFF_INDEX; // 32byte이므로 5
	
	dummy_wr_fg[buff_num&1] = 0;
	
	// dummy flag before start position pixel
	if(st_line == buff_line) { // start pixel이 포함되어 있을 경우.
		word = st_addr & DST_BUFF_IDX_MSK; // line내의 address. 32byte이므로 1F
		word >>= 2; // word 번호로 변환.
		if(i=0;i<=word;i++) {    // 0 ~ 7
			dummy_wr_fg[buff_num&1] |= 1 << i;
		} // for
	} // if start line
	
	// dummy flag before end position pixel
	if(ed_line == buff_line) { // start pixel이 포함되어 있을 경우.
		word = ed_addr & DST_BUFF_IDX_MSK; // line내의 address. 32byte이므로 1F
		word >>= 2; // word 번호로 변환.
		if(i=word;i<DST_BUFF_WLEGTH;i++) {  // 0 ~ 7
			dummy_wr_fg[buff_num&1] |= 1 << i;
		} // for
	} // if start line

} // update_dummy_fg_spos








//---------------------------------------------------
// functions that read pixel color



// check that wait the load of other buffer at 24bpp
int chk_ld_dst(uint adddr, int ctype, int hpos)
// return : RUN/WAIT
{
	int    		off_at_buff;

	off_at_buff = hpos * 3;
	
	if(ctype == C24BPP && (off_at_buff >> 1) == 0x0F) { // 두개의 버퍼에 걸쳐서 존재하는지 검사.
		if(full_fg[(~used_fg)&1] == 0) return WAIT;
		return RUN;
	} // if exist upper word
	else return RUN; 
} // chk_ld_buff


// 2006.10.17
// write buffer에서 24bpp 두버퍼에 걸치는 경우 dummy masking기능 추가.
//



//----------------------------------------------------------
// read destination pixel
// hpos에 의해서 버퍼내에서 첫번째 byte의 위치를 계산하고,
// 첫번째 위치로부터 1word를 읽어낸다.
// 다른 버퍼와 걸쳐 있을 경우(24bpp에서만 가능)에는 두번째 버퍼도 read될
// 될때까지 대기한다.

uint rd_dst_pixel(int ctype, int hpos)
// ctype : color type
// hpos : horizontal position of pixel
// return : pixel color
{
	int    i;
	uint   pixel;
	int    off_at_buff; // byte단위 position
	

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
		printf("\n ERROR : invalide color type at reading destination buffer.");
		exit(0);
	}// switch
	
	off_at_buff &= DST_BUFF_IDX_MSK; // 유효자리는 5bit --> 0x01F
	
	// 상위 word에서 추출 at 24bpp.
	//    1. 두개의 버퍼에 걸쳐 있을 경우.
	//    2. 한 버퍼내에서 상위 워드와 하위 워드에 분산 되어 있을 경우.
	if(ctype == C24BPP) {
		if((off_at_buff >> 1) == 0x0F) // 두개의 버퍼에 걸쳐서 존재하는지 검사.
			pixel = dst_rd_buff[(~used_fg) & 1][0];
		else if((off_at_buff & 0x03) != 0 && (off_at_buff>>2) != 0x07) // exist upper word
			pixel = dst_rd_buff[used_fg&1][(off_at_buff>>2) + 1];
		else pixel = 0;
	} // if exist upper word
	else pixel = 0;

	// 하위 word
	pixel <<= (off_at_buff & 0x03) << 3; // byte단위 이동.
	i = -1; // set all bit 1.
	i <<= (off_at_buff & 0x03) << 3;
	pixel &= i; // clear low bytes
	
	i = ~i; // bit inverse
	pixel |= i & (dst_rd_buff[used_fg&1][off_at_buff>>2] >> 
				  ((off_at_buff & 0x03) << 3));

	// MONO일때.
	if(ctype == MONO) {
		pixel >>= hpos & 3; // byte내에서 bit위치 보정.
		pixel &= 1;
	}

	return pixel;
} // rd_dst_pixel




