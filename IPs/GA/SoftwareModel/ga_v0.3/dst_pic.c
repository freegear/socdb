/****************************************************

   calc. destination picture

   file name : dst_pic.c
   created by gtlee
   data : 2006.9.29

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __DST_PIC__
#define  __DST_PIC__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "dst_pic.h"



//================================================
//  다음 pixel의 horizontal position 계산.
//     before position + 1
void next_hpos(int *hpos_s1, int *hpos_s2)
// hpos_s1 : horizontal position of slop register 1
// hpos_s2 : horizontal position of slop register 2
{
	*hpos_s1 += 1;
	*hpos_s2 = *hpos_s1;
} // next_hpos






//-------------------------------------------------
// destination pixel의 시작  memory 주소를 계산하는 함수.
uint calc_addr(uint baddr, int pixel_type, int maxh, int maxv, 
			   int now_vpos, int now_hpos)
// baddr : destination picture의 base address
// pixel_type : pixel type. select bpp
// maxh : horizontal max pixel count
// maxv : vertical max pixel
// now_vpos : target pixel의 vertical position
// now_hpos : target pixel의 horizontal position
// return : target address
{
	int   pixel_size; // 1 pixel이 차지하는 bit수.
	uint  h_bits; // horizontal bits
	uint  h_bytes; // horizontal bytes
	uint  h_wds; // horizontal words
	uint  trg_addr;
	
	switch(pixel_type) {
	case MONO :
		pixel_size = 1;
		break;
	case C8BPP :
		pixel_size = 8;
		break;
	case C16BPP :
	case C16BPP :
		pixel_size = 16;
		break;
	case C24BPP :
		pixel_size = 24;
		break;
	default :
		pixel_size = 32;
		break;
	} // swtich(pixel_type)

	// horizontal line의 총 bit수 계산.
	h_bits = now_vpos * pixel_size;

	// clac. byte수.
	h_bytes = h_bits>>3 + ((h_hits&7)?1 : 0); // rounding
	
	// word로 rounding
	h_wds = h_bytes>>2 + ((h_bytes%3)?1 : 0); // rounding

	// address
	trg_addr = (now_vpos * h_wds) + ((now_hpos * pixel_size) >>3);
	
	trg_addr += baddr;

	return trg_addr;
} // calc_addr







