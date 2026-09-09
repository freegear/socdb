/*************************************************************************

   Pixel cache

   file name : pcache.c

   created by gtlee

   data : 2006.6.22

   note :
       cache spec.
          total size : 2kbyte
          4 way
          64line (16line at each way)
          
          
   history :

************************************************************************/

#ifndef  __PCACHE__
#define  __PCACHE__
#endif
   
#define __DEBUG__


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "gbus.h"
#include "axi_if.h"

#include "pcache.h"








//---------------------------------------------------------
// cache request source
//  src picture
//  src masking pattern
//  drawing pattern
//  palette

typ_mem_cmd   cache_cmd[PCC_KIND] = {0};

int           nc_channel = 0;






//---------------------------------------------------------

uchar          *cache_way[WAY_NUM]={0};  // 512 byte
uint           *cache_tag[WAY_NUM]={0};  // tag memory 
s_cache_flag   *cache_flag[WAY_NUM]={0};
uint            cache_old[WAY_LINE_NUM]={0}; // line별, 좀더 오래된 way의 번호.








//===========================================================
// allocate pixel cache memorys
//   memory allocation and flag clear
void init_pcache(void)
{
	int     i;

	// Data memory
	cache_way[0] = (uchar *)malloc(PCACHE_SIZE);
	if(cache_way[0] == NULL) {
		printf("\n ERROR : Memory allocation error for Pcache data");
		exit(0);
	}
	for(i=1;i<WAY_NUM;i++)
		cache_way[i] = cache_way[i-1] + (PCACHE_SIZE/WAY_NUM);
	
	// Tag memory
	cache_tag[0] = (uint *)malloc(LINE_NUM*sizeof(uint));
	if(cache_tag[0] == NULL) {
		printf("\n ERROR : Memory allocation error for Pcache tag");
		exit(0);
	}
	for(i=1;i<WAY_NUM;i++)
		cache_tag[i] = cache_tag[i-1] + WAY_LINE_NUM;

	// flag memory
	cache_flag[0] = (s_cache_flag *)malloc(LINE_NUM*sizeof(s_cache_flag));
	if(cache_flag[0] == NULL) {
		printf("\n ERROR : Memory allocation error for Pcache flag");
		exit(0);
	}
	for(i=1;i<WAY_NUM;i++)
		cache_flag[i] = cache_flag[i-1] + WAY_LINE_NUM;

	// clear flags
	memset(cache_flag[0],1,LINE_NUM*sizeof(s_cache_flag));

} // init_pcache









//-------------------------------------------------------
// free pixel cache memorys
void close_pcache(void)
{
	// free memory
	if(cache_way[0] != NULL) free(cache_way[0]);
	cache_way[0] = 0;
	if(cache_tag[0] != NULL) free(cache_tag[0]);
	cache_tag[0] = 0;
	if(cache_flag[0] != NULL) free(cache_flag[0]);
	cache_flag[0] = 0;
} // close_pcache









//==================================================
// check cache operation
int chk_cache_op(int kind)
// kind : command channel
// return : true/false
{
	if((cache_cmd[kind].endb) & 1 == 0) 
		return FALSE; // end of operation
	else
		return TRUE;
} // chk_cache_op








//----------------------------------------------
// set read command to cache
int set_rd_cache(int kind, uint addr, int bytes, 
				 uchar *buffer, int prerd)
// kind : picture or command kind
// addr : target address
// bytes : pixels count number
// buffer : buffer pointer
// prerd : pre-read
// return : SUCC/FAIL
{
	if(buffer == NULL) {
		printf("\n ERROR : Buffer address error at cache read.");
		exit(0);
	} // if

	if(kind < 0 || kind >= PCC_KIND) {
		printf("\n ERROR : Over cache read operation channel number.");
		exit(0);
	} // if

	if(cache_cmd[kind].endb != 0) 
		return FAIL; // previous operation is not completed.
	
	// set parameters
	cache_cmd[kind].cmd = PCC_RD;
	cache_cmd[kind].addr = addr;
	cache_cmd[kind].bytes = bytes;
	cache_cmd[kind].buffer = buffer;
	cache_cmd[kind].prerd = prerd;

	cache_cmd[kind].endb = 1; // operation

	return SUCC;

} // set_rd_cache









//==================================================
// Cache Read for each channel

void cache_op(void)
{
	int    opr; // operation result

	// Search memory operation channel
	if(cache_cmd[nc_channel].endb == 1) {
		// cache fill 동작이 완료되지 않으면 cache read를 수행할 수 없음.
		if(chk_op(MEM_PCACHE) == TRUE) return;
		
		// Operation Start
		opr = rd_pcache(cache_cmd[nc_channel].buffer, &cache_cmd[nc_channel].addr,
						&cache_cmd[nc_channel].bytes, nc_channel, 
						cache_cmd[nc_channel].prerd);

		if(opr == FAIL) return; // wait a end of filling a cache line.
		
	} // if
	
	nc_channel = (nc_channel >= (PCC_KIND-1))? 0 : nc_channel+1;

} // cache_op








//--------------------------------------------------
// Read Operation
//

int rd_pcache(uchar *buffer, uint *addr, int *num, int kind, int prerd)
// buffer : read buffer
// addr : pixel이 저장되어 있는 주소.
// num : 읽을 byte 개수.
// kind : 읽는 데이터의 종류(destination picture, source picture, pattern, etc)
// prerd : next read operand의 유효 여부.
//          active되어 있으면, 다음 pixel들을 read함.
//          prefetch는 별도의 함수로??
// return : SUCC/FAIL
{
	uchar  lbuffer[LINE_SIZE]; // line buffer
	int    i;
	int    rd_len;  // total read length
	int    cp_pos;  // copy position
	int    cp_len;  // copy length
	uint   rd_addr;
	int    hit;
	
	rd_len = 0; // read한 size
	rd_addr = *addr;
	while(rd_len < *num) {
		// get from cache 
		//      line 단위로만 read.
		hit = rdline(lbuffer, rd_addr);
		if(hit != PCC_HIT) {
			// 중간 address 및 남은 size를 backup
			*addr = rd_addr;
			*num -= rd_len;
			return FAIL;
		} // if
		
		// copy to read buffer
		cp_pos = (LINE_SIZE - 1) & rd_addr; // calc. a start offset
		cp_len = LINE_SIZE - cp_pos;
		
		memcpy((buffer+rd_len),(lbuffer+cp_pos),cp_len);

		// next address
		rd_addr += cp_len;
		rd_len += cp_len;
	} // while
	
	// pre read
	if(prerd != 0) {
		rd_addr = *addr + LINE_SIZE;
		rd_addr &= ~(LINE_SIZE-1); // clear low bits

		rdline(lbuffer, rd_addr);
	} // if
	
	return SUCC;
} // rd_pcache









//----------------------------------------------------------
// read 1 cache line
//    만일 cache에 data가 없으면, main memory에서 읽어옴.
int rdline(uchar *buffer,uint addr)
// buffer : for return. size is equal to line
// addr : start address for reading
// return : hit/miss
{
	int      line;
	uint     addr_tag;
	uint     t_addr; // target full address
	int      hit;
	int      way;
	

	// check tag
	hit = -1;
	line = (addr>>CHK_TAG_SFT) & CHK_TAG_MSK;
	addr_tag = addr>>CHK_TAG_ADR;
	for(way=0;way<WAY_NUM;way++) {
		if(*(cache_tag[way]+line) == addr_tag) break;
	} // for
	hit = way;
	
	if(hit < 0 && hit >= WAY_NUM) { 	// if miss
		// replace cache
		// search empty way
		for(way=0;way<WAY_NUM;way++) {
			if((cache_flag[way]+line)->emptyb == 0) break;
		}// for

		if(way >= WAY_NUM) { // no empty line
			way = cache_old[line];
			cache_old[line] = 1 & (~cache_old[line]); // old flag 전환.
		} // if

		// set memory read command
		set_rd_mem(MEM_PCACHE, addr_tag<<CHK_TAG_ADR, LINE_SIZE, 
				   cache_way[way]+line, 0);


		// set tag
		*(cache_tag[way]+line) = addr_tag;
		
		// set flags
		(cache_flag[way]+line)->emptyb = 1;
		
		return    PCC_MISS;
	}// if
	
	memcpy(buffer,cache_way[hit]+(LINE_SIZE*line),LINE_SIZE);
	
	return    PCC_HIT;
} // rdline







