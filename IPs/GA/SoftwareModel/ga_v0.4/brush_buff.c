/****************************************************

   brush pattern buffer and etc

   file name : brush_buff.c
   created by gtlee
   data : 2006.10.11

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __BRUSH_BUFF__
#define  __BRUSH_BUFF__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"
#include "gpu.h"
#include "pcache.h"

#include "brush_buff.h"


//====================================================
// brush buffer
//   max 32x32bit
uint  brush[32];







//====================================================
// send read command
void fill_brush_buff(uint baddr,int h_max, int v_max)
// baddr : bass address of the brush pattern
// h_max : horizontal size of passtern
// v_max : vertical size of passtern
{
	int    size;

	// 만일 32bit align을 유지한다면, 무조건 32x32bit를 읽어 
	// 버퍼에 저장하면 된다.

	size = h_max * v_max;
	if((size & 7) != 0) size = (size >> 3) + 1;

	if(size >= (4*32)) size = 32 * 4;

	// memory operation command를 전송.
	if( set_rd_cache(PCC_DRW_PAT, baddr, size, (uchar *)brush, 0) == FAIL) {
		printf("\n ERROR : no end of a getting brush pattern.");
		exit(0);
	}
	
} // fill_brush_buff







//---------------------------------------------------
// check end of the memory operation
int chk_get_brush(void)
// return : true/false. true : operating. false : not operating
{
	return chk_cache_op(PCC_DRW_PAT);

} // chk_get_brush







//---------------------------------------------------
// get brush pattern
//    read 1 pattern
//    destination의 pixel에 대응하는 pattern을 search
int get_brush_pat(int hoff, int voff, int h_max, int v_max)
// hoff : horizontal offset of destination pixel than top position
// voff : vertical offset of destination pixel than top position
// h_max : horizontal size of pattern
// v_max : vertical size of pattern
{
	int  h_size, v_size;
	int  h_pos, v_pos;
	int  pattern;

	h_size = h_max + 1;
	v_size = v_max + 1;

	if(h_size > 32 && h_size < 0) {
		printf("\n ERROR : horizontal brush pattern size error.");
	}
	if(v_size > 32 && v_size < 0) {
		printf("\n ERROR : vertical brush pattern size error.");
	}

	h_pos = hoff % h_size; // pattern size가 2^n이면 bit AND로 계산가능.
	v_pos = voff % v_size; // pattern size가 2^n이면 bit AND로 계산가능.

	// 음수이면 max size를 더해서 뒤에서부터 count
	if(h_pos < 0) h_pos += h_max;
	if(v_pos < 0) v_pos += v_max;

	pattern = 1 & (brush[v_pos] >> h_pos);
	
	return pattern;

} // get_brush_pat
