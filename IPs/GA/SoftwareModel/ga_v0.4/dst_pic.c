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
#include "ga.h"

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
// horizontal bit size를 계산한다.
uint hbits_size(int pixel_type, int maxh)
// pixel_type : pixel type. select bpp
// maxh : horizontal max pixel count
// return : maximum horizontal bits
{
	int   pixel_size; // 1 pixel이 차지하는 bit수.
	uint  hbits; // horizontal bits

	switch(pixel_type) {
	case MONO :
		pixel_size = 1;
		break;
	case C8BPP :
		pixel_size = 8;
		break;
	case C16BPP :
	case CA16BPP :
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
	hbits = maxh * pixel_size;

	return hbits;
} // hpixel_size






//-------------------------------------------------
// destination and source pixel의 시작 memory 주소를 계산하는 함수.
uint calc_addr(uint baddr, int ctype, int maxh, int maxv, 
			   int now_vpos, int now_hpos, uint hbits)
// baddr : destination picture의 base address
// ctype : pixel type. select bpp
// maxh : horizontal max pixel count
// maxv : vertical max pixel
// now_vpos : target pixel의 vertical position
// now_hpos : target pixel의 horizontal position
// hbits; // horizontal bits
// return : target address
{
	int   pixel_size; // 1 pixel이 차지하는 bit수.
	//uint  h_bytes; // horizontal bytes
	uint  hwds; // horizontal words
	uint  trg_addr;

	switch(ctype) {
	case MONO :
		pixel_size = 1;
		break;
	case C8BPP :
		pixel_size = 8;
		break;
	case C16BPP :
	case CA16BPP :
		pixel_size = 16;
		break;
	case C24BPP :
		pixel_size = 24;
		break;
	default :
		pixel_size = 32;
		break;
	} // swtich(pixel_type)
	
	/*
	// clac. byte수.
	h_bytes = hbits>>3; // rounding
	
	// word로 rounding
	h_wds = h_bytes>>2; // rounding
	*/

	// 하나로 대치. 2006.11.10
	hwds = hbits >> 5 ; // rounding

	// address
	trg_addr = ((now_vpos * hwds)<<2) + ((now_hpos * pixel_size) >>3);
	
	trg_addr += baddr;

	return trg_addr;
} // calc_addr

