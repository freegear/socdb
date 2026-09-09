/****************************************************
  
   Destination write buffer

   file name : dst_wr_buff.c
   created by gtlee
   data : 2006.10.24

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __DRAWING__
#define  __DRAWING__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"

#include "dst_wr_buff.h"


//--------------------------------------------------
// Write buffer
//  address가 변경되면 buffer의 내용을 memory로 write한다.
int    used_fg = 0; // 현재 사용중인 버퍼의 번호를 저장.
uint   buff_addr[2]; // buffer에 저장된 pixel data가 저장되어 있던 memory의 주소.
uint   dst_rd_buff[2][8]; // dual buffer.  32byte * 2line
int    full_fg[2]; // 각 buffer가 full되어 있는지 나타냄.
int    sel_empty; // selected buffer is empty.




//=================================================
// pixel write
//   buffer line에 걸치는 경우에는 윗단에서 분리하여 처리.
int pwrite(uint addr, uint bytes, int bit_pos, uint color)
// addr : pixel address
// bytes : write할 bytes
//         byte이상일 경우에는 해당길이를 byres로 나나냄
// bit_pos : bit position. mono에서 byte내에서의 bit position
// color : pixel color
// return : write ok / buffer full
{
	uint    trg_baddr; // target base address

	if(full_fg[0] != 0 && full_fg[1] != 0) // if buffer full,
		return WR_BUFF_FULL;
	
	trg_baddr = addr >> WR_BUFF_INDEX;
	if(trg_baddr != buff_addr[used_fg] && sel_empty == 1) { // end used buffer. store used buffer.
		// store buffer임을 나타내기만 함.
		full_fg[used_fg & 1] = 1;

		// 다른 버퍼가 비어있는지 검사.
		if(full_fg[1 & (~used_fg)] == 1) { // no emptied buffer
			return WR_BUFF_FULL;
		}

		// change used buffer
		used_fg = 1 & (~used_fg);
		sel_empty = 0;
	} // if

	if(sel_empty == 0) buff_addr[used_fg] = trg_baddr;

	// store a pixel to a write buffer
	wr2buff(addr, bytes, bit_pos, color);

	sel_empty = 1; // 현재 buffer에 data update

	return WR_BUFF_OK;

} // pwrite





//-----------------------------------------------
// write a pixel to a write buffer
void wr2buff(uint addr, uint bytes, int bit_pos, uint color)
// addr : pixel address
// bytes : write할 bytes. 1bit:0, 1byte:1, 16bit:2, 24bit:3, 32bit:4
// bit_pos : bit position. not Mono, must set 0.
// color : pixel color
{
	int    wd_num;
	int    byte_pos; // word내에서 byte단위의 position
	uint   wd_data;
	uint   wd_mask;

	// buffer내에서의 byte position 계산.
	byte_pos = addr & WR_BUFF_IDX_MSK;

	// word number
	wd_num = byte_pos >> 2;

	// word내에서 byte position
	byte_pos &= 3;

	// Generate a bit mask
	switch(bytes) {
	case 0 : wd_mask = 1; break;
	case 1 : wd_mask = 0x0ff; break;
	case 2 : wd_mask = 0x0ffff; break;
	case 3 : wd_mask = 0x0ffffff; break;
	case 4 : wd_mask = 0x0ffffffff; break;
	default : 
		printf("\n ERROR : unkown write size of write buffer.");
	} // switch

	wd_mask = wd_mask << (8*byte_pos + bit_pos);
	
	// low word write
	wd_data = color << (8*byte_pos + bit_pos);

	//유효 데이터 추출.
	wd_data &= wd_mask;

	dst_rd_buff[used_fg][wd_num] &= (~wd_mask);
	
	dst_rd_buff[used_fg][wd_num] |= wd_data;

} // wr2buff








//-----------------------------------------------
// store write buffer to memory
//   사용이 끝난 버퍼의 데이터를 memory에 write한다.
//   여러 clock이 소모됨.
//   pixel을 buffer에 write하는 것과 별개로 동작한다.
int wrbuff2mem(void)
// return : SUCC/FAIL
{
	int     buff_num;

	buff_num = 1&(~used_fg);

	if(full_fg[buff_num] == 1) { // dump할 data가 있을 경우 
		if( /* memory operation 가능 */) {




			full_fg[buff_num] = 0; // write end를 나타냄.
		}
		else return FAIL;
	} // if
	else return SUCC; // dump할 data가 없을 경우 
} // wrbuff2mem








//========================================================
// Write buffer State Machine


int sm_stage;


int sm_wr_buff(uint addr, uint bytes, int bit_pos, uint color, 
			   int wr, int fw, int stage)
// addr : pixel address
// bytes : write할 bytes
//         byte이상일 경우에는 해당길이를 byres로 나나냄
// bit_pos : bit position. mono에서 byte내에서의 bit position
// color : pixel color
// wr : exist a write pixel
// fw : force write
// stage : next stage from upper block
// return : next stage
//
// NOP일 경우에는 wr과 fw를 0으로 set한뒤 function 호출.
{
	if(sm_stage != stage) {
		printf("\n ERROR : Stage is not equal at write buffer");
		exit(0);
	} // if error

	// write to memory
	wrbuff2mem();


	switch(sm_stage) {
	case ST_IDLE :
		sm_stage ++;
	case ST_UD_BUFF :
		if(wr == 1){
			if(pwrite(addr, bytes, bit_pos, color) != WR_BUFF_OK)
				break;
		}

		if(fw == 0) { // no force writing
			sm_stage = 0;
			break;
		} // if
		sm_stage ++;
	case ST_DM_BUFF : // dump the now buffer to memory
		full_fg[used_fg] = 1;
		if(full_fg[1&(~used_fg)] == 1) break;
		used_fg = 1 & (~used_fg);
		sel_empty = 0; // 현재 버퍼가 비어 있음을 알림.
		sm_stage = 0;
		break;
	default :
		printf("\n ERROR : Unknown stage at write buffer state machine.");
		exit(0);
		sm_stage = 0;
	} // switch

	return sm_stage;
} // sm_wr_buff
