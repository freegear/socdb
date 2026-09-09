/*************************************************************************

   Graphic Bus. Read bus and Write Bus.

   file name : gbus.c
   created by gtlee
   data : 2006.6.27

   note :
          
   history :

************************************************************************/


#ifndef    __GBUS__
#define    __GBUS__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "fromto32bpp.h"

#include "gbus.h"



// mem request source
//  command buffer
//  src picture
//  src masking pattern
//  dst picture
//  dst masking pattern
//  drawing pattern
//  pallete

typ_mem_cmd  mem_cmd[NUM_KIND] = {0};

int  next_channel = 0; // 다음에 처리해야할 memory request channel

//----------------------------------------------
// check memory operation
//    memory operation이 완료됐는지 check
int chk_op(int kind)
// kind : picture or command kind
{

	return mem_cmd[kind].endb;
	
} // chk_op


//----------------------------------------------
// Set Read command
int set_rd_pxl(int kind, int posx, int posy, int pnum, 
				   uchar *buffer, int prerd)
// kind : picture or command kind
// posx : pixel horizontal position
// posy : pixel vertical position
// pnum : pixels count number
// buffer : buffer pointer
// prerd : pre-read
// return : SUCC/FAIL
{
	if(kind >= NUM_KIND) {
		printf("\n ERROR : Memory request number is too large at read at the pixel read.");
		exit(0);
	}
	
	if(kind == CMD_STR) {
		printf("\n ERROR : Cannot read the command structure at the pixel read.");
		exit(0);
	}

	if(kind == PALLETE) {
		printf("\n ERROR : Cannot read Pallete at the pixel read.");
		exit(0);
	}
	if(buffer == NULL) {
		printf("\n ERROR : Buffer address error at read at the pixel read");
		exit(0);
	}
	
	if(mem_cmd[kind].endb != 0) 
		return FAIL; // previous operation is not completed.

	// set struture
	mem_cmd[kind].cmd = CMD_MEM_RD;
	mem_cmd[kind].posx = posx;
	mem_cmd[kind].posy = posy;
	mem_cmd[kind].pnum = pnum;
//	mem_cmd[kind].kind = kind;
	mem_cmd[kind].buffer = buffer;
	mem_cmd[kind].prerd = prerd;

	mem_cmd[kind].addr = 0;
	mem_cmd[kind].endb = 1;

	return SUCC;

} // set_rd_mem


//----------------------------------------------
// Set command structure and pallete read 
int set_rd_cmd_pal(int kind, uint addr,int off, int num, 
				   uchar *buffer, int prerd)
// kind : picture kind
// addr : address of the command struture
//        no used at the pallete
// off  : base address에서 offset
// num : Command word number or pallete word number
// buffer : buffer pointer
// prerd : pre-read at the pallete. 
//         no used at the command structure
// return : SUCC/FAIL
{
	if(kind >= NUM_KIND) {
		printf("\n ERROR : Memory request number is too large at read.");
		exit(0);
	}
	
	if(kind != CMD_STR && kind != PALLETE) {
		printf("\n ERROR : Cannot read command structure.");
		exit(0);
	}

	if(buffer == NULL) {
		printf("\n ERROR : Buffer address error at read");
		exit(0);
	}
	
	if(mem_cmd[kind].endb != 0) 
		return FAIL; // previous operation is not completed.

	// set struture
	mem_cmd[kind].cmd = CMD_MEM_RD;
	mem_cmd[kind].posx = off; // no used at the command structure
	mem_cmd[kind].posy = 0;
	mem_cmd[kind].pnum = num;
	//mem_cmd[kind].kind = kind;
	mem_cmd[kind].buffer = buffer;
	mem_cmd[kind].prerd = prerd;

	mem_cmd[kind].addr = addr; // use at the command structure
	mem_cmd[kind].endb = 1;

	return SUCC;

} // set_rd_cmd_str

//-----------------------------------------------------
// Set Pixel write command

int set_wr_pxl(int kind, int posx, int posy, 
				   int pnum, uchar *buffer)
// kind : picture kind
// posx : pixel horizontal position
// posy : pixel vertical position
// pnum : pixel number
// buffer : buffer pointer
// return : SUCC/FAIL
{
	if(kind >= NUM_KIND) {
		printf("\n ERROR : Memory request number is too large at write.");
		exit(0);
	}
	
	if(kind != DST_PIC) {
		printf("\n ERROR : Write Memory request is requested from read buffer.");
		exit(0);
	}
	
	if(buffer == NULL) {
		printf("\n ERROR : Buffer address error at write.");
		exit(0);
	}
	
	if(mem_cmd[kind].endb != 0) 
		return FAIL; // previous operation is not completed.

	// set struture
	mem_cmd[kind].cmd = CMD_MEM_WR;
	mem_cmd[kind].posx = posx;
	mem_cmd[kind].posy = posy;
	mem_cmd[kind].pnum = pnum;
	//mem_cmd[kind].kind = DST_PIC;
	mem_cmd[kind].buffer = buffer;

	mem_cmd[kind].addr = 0;
	mem_cmd[kind].prerd = 0;
	mem_cmd[kind].endb = 1;

	return SUCC;

} // set_wr_mem


//---------------------------------------------------------------------
// Read from pixel cache.
// split cachable data or non cachable data

void mem_op(void)
{
	// Search memory operation channel
	if(mem_cmd[next_channel].endb == 1) {
		// Operation Start
		if(mem_cmd[next_channel].cmd == CMD_MEM_RD)
			mem_rd(next_channel);
		else mem_wr(next_channel);
	}

	next_channel = (next_channel >= (NUM_KIND-1))? 0 : next_channel+1;

} // mem_op


// need modify
void mem_rd(int channel)
{
	uint     trg_addr;
	int      pic_kind = channel;

	if(mem_cmd[channel].cmd != CMD_MEM_RD) {
		printf("\n ERROR : not read command.");
		exit(0);
	}
	
	// calc. target address
	if(channel <= NUM_PIC) { // if picture
		trg_addr = calc_trg_addr(mem_cmd[channel].posx, 
								 mem_cmd[channel].posy,
								 channel);
	}
	else {  // command structure and pallete
		trg_addr = pic_info[pic_kind].addr + mem_cmd[channel].posx;
	}


	if( channel == CMD_STR ) {
		// Non cache read
		// direct connect to AXI bus interfacer.
		// pnum is read bytes
		
		read_mem(trg_addr, mem_cmd[channel].buffer,
				 mem_cmd[channel].pnum);
	}
	else {
		// cachable read
		to32bpp(mem_cmd[channel].buffer, trg_addr,
				mem_cmd[channel].pnum, pic_info[channel].type,
				channel, mem_cmd[channel].prerd);
	}

	mem_cmd[channel].endb = 0;
} // mem_rd



// need modify
void mem_wr(int channel)
{
	uint   trg_addr;

	if(mem_cmd[channel].cmd != CMD_MEM_WR) {
		printf("\n ERROR : not write command.");
		exit(0);
	}

	trg_addr = calc_trg_addr(mem_cmd[channel].posx, 
							 mem_cmd[channel].posy,
							 channel);
	
	// cachable write
	from32bpp(mem_cmd[channel].buffer, trg_addr,
			  mem_cmd[channel].pnum, pic_info[channel].type,
			  channel);

	// Non cache write <-- no case
	// direct connect to AXI bus interfacer.
	// pnum is write bytes
	//write_mem(mem_cmd[channel].addr, mem_cmd[channel].buffer,
	//		  mem_cmd[channel].pnum);

	mem_cmd[channel].endb = 0;
} // mem_wr



//------------------------------------------------------
// calc. target address
//     no used at the command structure and pallete
uint calc_trg_addr(int posx, int posy, int pic_kind)
{
	uint   base_addr;
	int    p_size; // bit단위
	uint   offset;
	
	if(pic_kind >= (NUM_PIC+1)) {
		printf("\n ERROR : picture kind is too large at calc. target address.");
		exit(0);
	}

	// calc. base address
	if(pic_kind < NUM_PIC)
		base_addr = pic_info[pic_kind].addr;
	else {  // pallete or command
		printf("\n ERROR : wrong picture kind at calculation target address.");
		exit(0);
		//base_addr = pal_base_addr;
	}

	// pixel size
	switch(pic_info[pic_kind].type) {
	case MONO    :  p_size = 1; break;
	case C8BPP   :  p_size = 8; break;
	case C16BPP  :
	case CA16BPP :  p_size = 16; break;
	case C24BPP  :  p_size = 24; break;
	case C32BPP  :
	case CA32BPP :  p_size = 32; break;
	default : 
		printf("\n ERROR : undefined picture type at the calc. target address.");
		exit(0);
	} // switch
	
	// pixel number
	if(posx >= pic_info[pic_kind].maxx || posy >= pic_info[pic_kind].maxy) {
		printf("\n ERROR : out of the pixel position at the calc. target address");
		exit(0);
	}
	offset = posy*pic_info[pic_kind].maxy + posx;
	offset = offset * p_size;  // bit수.
	offset += (offset % 8 == 0)? 0 : 8 ; // 나머지 rounding
	offset /= 8; // byte 수.

	return (base_addr + offset);
} // calc_trg_addr
