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

#define __DEBUG__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "axi_if.h"

#include "gbus.h"



// mem request source
//  pixel cache
//  command buffer
//  dst picture
//  dst masking pattern

typ_mem_cmd  mem_cmd[MEM_KIND] = {0};

int  next_channel = 0; // 다음에 처리해야할 memory request channel





//----------------------------------------------
// check memory operation
//    memory operation이 완료됐는지 check
int chk_op(int kind)
// kind : picture or command kind
// return : true/false
{
	int     flag;
	
	flag = mem_cmd[kind].endb & 1;
	if(flag == 0)
		return FALSE; // no operation
 
	return TRUE;  // doing operation
	
} // chk_op







//----------------------------------------------
// Set Read command
int set_rd_mem(int kind, uint addr, int bytes, 
			   uchar *buffer, int prerd)
// kind : picture or command kind
// addr : target address
// bytes : read size
// buffer : buffer pointer
// prerd : pre-read
// return : SUCC/FAIL
{
	if(buffer == NULL) {
		printf("\n ERROR : Buffer address error at write.");
		exit(0);
	} // if

	if(kind < 0 || kind >= MEM_RD_KIND) {
		printf("\n ERROR : Over memory read operation channel number.");
		exit(0);
	} // if

	if(mem_cmd[kind].endb != 0) 
		return FAIL; // previous operation is not completed.

	// set parameters
	mem_cmd[kind].cmd = MEM_RD_OP;
	mem_cmd[kind].addr = addr;
	mem_cmd[kind].bytes = bytes;
	mem_cmd[kind].buffer = buffer;
	mem_cmd[kind].prerd = prerd;

	mem_cmd[kind].endb = 1; // operation

#ifdef __DEBUG__
	printf("\n Set read memory operation : %d",kind);
#endif // __DEBUG__

	return SUCC;

} // set_rd_mem







//-----------------------------------------------------
// Set Pixel write command

int set_wr_mem(int kind, uint addr, int bytes, uchar *buffer)
// kind : picture kind
// addr : target address
// bytes : pixels count number
// buffer : buffer pointer
// return : SUCC/FAIL
{
	if(kind != MEM_DST_PIC) {
		printf("\n ERROR : Write Memory request is requested from write buffer.");
		exit(0);
	}
	
	if(buffer == NULL) {
		printf("\n ERROR : No buffer address at write.");
		exit(0);
	}
	
	if(mem_cmd[kind].endb != 0) 
		return FAIL; // previous operation is not completed.

	// set struture
	mem_cmd[kind].cmd = MEM_WR_OP;
	mem_cmd[kind].addr = addr;
	mem_cmd[kind].bytes = bytes;
	mem_cmd[kind].buffer = buffer;
	mem_cmd[kind].prerd = 0;
	mem_cmd[kind].endb = 1;

#ifdef __DEBUG__
	printf("\n Set write memory operation : %d",kind);
#endif // __DEBUG__

	return SUCC;

} // set_wr_mem









//================================================================
// Read from pixel cache.
// split cachable data or non cachable data

void mem_op(void)
{
	// Search memory operation channel
	if(mem_cmd[next_channel].endb == 1) {
		// Operation Start
		if(mem_cmd[next_channel].cmd == MEM_RD_OP)
			mem_rd(next_channel);
		else mem_wr(next_channel);
	}

	next_channel = (next_channel >= (MEM_KIND-1))? 0 : next_channel+1;

} // mem_op






//-------------------------------------------
// memory read from AXI
void mem_rd(int channel)
// channel : memory operation의 종류로 구분되는 채널.
{

	if(channel < 0 || channel >= MEM_RD_KIND) {
		printf("\n ERROR : over channel number at read memory.");
	} // if

	if(mem_cmd[channel].cmd != MEM_RD_OP) {
		printf("\n ERROR : not read command.");
		exit(0);
	} // if
	

	// Non cache read
	// direct connect to AXI bus interfacer.
	// byes is read bytes
	
	read_mem(mem_cmd[channel].addr, mem_cmd[channel].buffer,
			 mem_cmd[channel].bytes);

	mem_cmd[channel].endb = 0;

#ifdef __DEBUG__
	printf("\n Read memory operation : %d",channel);
#endif // __DEBUG__

} // mem_rd






//------------------------------------------------------
// memory write to AXI
void mem_wr(int channel)
{
	if(channel != MEM_WRITE) {
		printf("\n ERROR : Not write channel at write memory.");
	} // if

	if(mem_cmd[channel].cmd != MEM_WR_OP) {
		printf("\n ERROR : not write command.");
		exit(0);
	}

	// Non cache write <-- no case
	// direct connect to AXI bus interfacer.
	// byes is write bytes
	write_mem(mem_cmd[channel].addr, mem_cmd[channel].buffer,
			  mem_cmd[channel].bytes);

	mem_cmd[channel].endb = 0;

#ifdef __DEBUG__
	printf("\n Write memory operation : %d",channel);
#endif // __DEBUG__


} // mem_wr


