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
   
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "axi_if.h"

#include "pcache.h"


#define __DEBUG__


//---------------------------------------------------------

int            write_way; // randum 하게 선택되는 값을 결정.

uchar          *cache_way[WAY_NUM]={0};  // 512 byte
uint           *cache_tag[WAY_NUM]={0};  // tag memory 
s_cache_flag   *cache_flag[WAY_NUM]={0};




//===========================================================

void init_pcache(void)
{
// memory allocation and flag clear
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
	if(cache_flag[0] = NULL) {
		printf("\n ERROR : Memory allocation error for Pcache flag");
		exit(0);
	}
	for(i=1;i<WAY_NUM;i++)
		cache_flag[i] = cache_flag[i-1] + WAY_LINE_NUM;

// init flags
	// clear flags
	memset(cache_flag[0],0,LINE_NUM*sizeof(s_cache_flag));

}



void close_pcache(void)
{
// free memory
	if(cache_way[0] != NULL) free(cache_way[0]);
	cache_way[0] = 0;
	if(cache_tag[0] != NULL) free(cache_tag[0]);
	cache_tag[0] = 0;
	if(cache_flag[0] != NULL) free(cache_flag[0]);
	cache_flag[0] = 0;
}







//--------------------------------------------------
// Read Operation
//

int rd_pcache(uchar *buffer, uint addr, int num, int kind, int prerd)
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
	
	rd_len = 0;
	rd_addr = addr;
	while(rd_len < num) {
		// get from cache 
		rdline(lbuffer, rd_addr, kind);
		
		// copy to read buffer
		cp_pos = (LINE_SIZE - 1) & rd_addr;
		cp_len = LINE_SIZE - cp_pos;
		
		memcpy((buffer+rd_len),(lbuffer+cp_pos),cp_len);

		// next address
		rd_addr += cp_len;
		rd_len += cp_len;
	}
	
	// pre read
	if(prerd != 0) {
		rd_addr = addr + num + LINE_SIZE;
		rd_addr &= ~(LINE_SIZE-1); // clear low bits

		rdline(lbuffer, rd_addr, kind);
	}
	
	return SUCC;
}






void rdline(uchar *buffer,uint addr, int kind)
// buffer : for return. size is equal to line
// addr : start address for reading
// kind : 읽는 데이터의 종류(destination picture, source picture, pattern, etc)
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
			for(way=0;way<WAY_NUM;way++)
				if((cache_flag[way]+line)->kind == kind) break;
		} // if
		if(way >= WAY_NUM) { // no same picture
			way = write_way % WAY_NUM;
		} // if
		
		// if updated, write back
		if((cache_flag[way]+line)->update != 0) {
			t_addr = *(cache_tag[way]+line)<<CHK_TAG_ADR;
			t_addr += (line << CHK_TAG_SFT);

			// write command 
			write_mem( (uint)t_addr,cache_way[way]+line,LINE_SIZE);
		} // if
		// read command
		read_mem((uint)(addr_tag<<CHK_TAG_ADR),cache_way[way]+line,LINE_SIZE);
		
		// set tag
		*(cache_tag[way]+line) = addr_tag;
		
		// set flags
		(cache_flag[way]+line)->emptyb = 1;
		(cache_flag[way]+line)->update = 0;
		(cache_flag[way]+line)->kind = kind;
		
		hit = way;
	}// if
	
	memcpy(buffer,cache_way[hit]+(LINE_SIZE*line),LINE_SIZE);
}






//=====================================================================
// Write Operation 
//  to Pixel Cache

int wr_pcache(uchar *buffer, uint addr, int num)
// pbuffer : pixel buffer
// addr : pixel이 저장되어 있는 주소.
// num : Write할 byte 개수.
// return : SUCC
{
// 두 line을 걸쳐 있을 경우에는 둘로 나누어 wrline을 2번 호출해야 한다.
	int    size;
	int    t_addr;

	t_addr = addr & (LINE_SIZE-1); // offset in a line
	size = LINE_SIZE - t_addr;  // line에서 남은 크기.
	
	// first line
	wrline(buffer, addr, size);

	// second line
	if(size < num) {
		wrline(buffer+size, addr+size,num-size);
	}
	
	return SUCC;
}





//-----------------------------------------
// write to pixel cache
// Max 1 line.
// line을 걸칠 수 없음.

int wrline(uchar *buffer, uint addr, int num)
// buffer : for return. size is equal to line
// addr : start address for reading
// num : Write할 byte 개수.
// return : SUCC
{
	int      i;
	int      line;
	uint     addr_tag;
	uint     t_addr; // target full address
	int      hit;
	int      way;
	int      size; // write length
	uchar    wbuffer[LINE_SIZE];
	
	// check tag
	hit = -1;
	line = (addr>>CHK_TAG_SFT) & CHK_TAG_MSK;
	addr_tag = addr>>CHK_TAG_ADR;
	for(way=0;way<WAY_NUM;way++) {
		if(*(cache_tag[way]+line) == addr_tag) break;
	} // for
	hit = way;
	
	t_addr = addr & (LINE_SIZE-1); // offset in a line
	size = LINE_SIZE - t_addr;  // line에서 남은 크기.
	
	if( hit >= 0 && hit < WAY_NUM) { // in cache
		if(size > num) { // line의 일부만 채우게 됨-->no memory write. only cache update
			memcpy((cache_way[way]+LINE_SIZE*line+t_addr),
				   buffer,num);
			// end.
		} // if
		else {
			// write memory and cache flush

			// copy to write buffer from pixel buffer
			for(i=0;i<LINE_SIZE;i++) {
				wbuffer[i] = *(cache_way[way]+LINE_SIZE*line+i);
			}
			
			// copy to write buffer from buffer
			for(i=t_addr;i<LINE_SIZE;i++) {
				wbuffer[i] = *(buffer+i-t_addr);
			}

			// write to memory
			write_mem((uint)(addr&(~(LINE_SIZE-1))),wbuffer,LINE_SIZE);
		} // else 
	}
	else {
		// cache에 없을 경우.
		write_mem((uint)addr,wbuffer,size);
	}
	
	return SUCC;
}


