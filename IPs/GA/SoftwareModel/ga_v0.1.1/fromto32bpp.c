/*************************************************************************

   color type conversion from/to 32bpp

   file name : fromto32bpp.c

   created by gtlee

   data : 2006.6.26

   note :
          
   history :

************************************************************************/


#ifndef  __FROMTO32BPP__
#define  __FROMTO32BPP__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "pcache.h"

#include "fromto32bpp.h"


//=================================================
// cachable operation만 처리.
void to32bpp(uchar *pbuffer, uint addr, int pnum, int type, 
			 int kind, int prerd)
// pbuffer : pixel buffer
// addr : read address
// num : pixel number
// type : pixel type
// kind : picture kind. source or destination or pattern
// prerd : pre read enable
{
	uchar    buffer[LINE_SIZE];
	int      len; // read byte size
	int      i, j;
	uint     pdata;  // pixel data

	
	// cached read
	
	if(pnum > 8) {
		printf("\n Error : pixel number is large too. to32bpp");
		exit(0);
	}
	
// pixel cache로 부터 8pixel을 읽기 위한 byte 수로 변환하여 call
	// calc. byte count
	switch(type) {
	case MONO : // mono
		len = pnum / 8;
		len += (pnum % 8)?1:0;
		break;
	case C8BPP : // 8bpp
		len = pnum;
		break;
	case C16BPP : // 16bpp
	case CA16BPP : // 16bpp with A
		len = pnum * 2;
		break;
	case C24BPP : // 24bpp
		len = pnum * 3;
		break;
	case C32BPP : // 32bpp
	case CA32BPP :
	default : 
		len = pnum * 4;
		break;
	} // switch
	
	// read pixel cache
	rd_pcache(buffer,addr,len, kind, prerd);
	
// 읽은 pixel color를 32bpp로 변환한다.
	switch(type) {
	case MONO : // mono
		// 8bpp나 mono는 bit 반복을 한다.
		for(i=0;i<pnum;i++) {
			pdata = (buffer[0] >> i) & 1;
			
			if(pdata == 0)
				for(j=0;j<3;j++) *(pbuffer + i*4 + j) = 0;
			else 
				for(j=0;j<3;j++) *(pbuffer + i*4 + j) = 0x0ff;
			// Alpha
			*(pbuffer + i*4 + 3) = 0;
		} // for i
		break;
	case C8BPP : // 8bpp. repeat byte
		// 8bpp나 mono는 bit 반복을 한다.
		for(i=0;i<pnum;i++) {
			*(pbuffer+i*4+3) = 0xff; // alpha
			for(j=0;j<3;j++) *(pbuffer+i*4+j) = buffer[i];
		} // for i
		break;
	case C16BPP : // 16bpp. 565
		for(i=0;i<pnum;i++) {
			pdata = (*(buffer + i*2 + 1)<<8) | (*(buffer + i*2));
			pdata &= 0x0ffff;
			
			// Blue. 5bit
			*(pbuffer + i*4) = (pdata & 0x01f) << 3; 
			if(*(pbuffer + i*4) != 0) *(pbuffer + i*4) |= 0x7;
			pdata >>= 5;
			
			// Green. 6bit
			*(pbuffer + i*4 + 1) = (pdata & 0x03f) << 2;
			if(*(pbuffer + i*4 + 1) != 0) *(pbuffer + i*4 + 1) |= 0x3;
			pdata >>= 6;
			
			// Red. 5bit
			*(pbuffer + i*4 + 2) = (pdata & 0x01f) << 3;
			if(*(pbuffer + i*4 + 2) != 0) *(pbuffer + i*4 + 2) |= 0x7;
			
			// Alpha
			*(pbuffer + i*4 + 3) = 0;
		} // for i
		break;
	case CA16BPP : // 16bpp with A. 555
		for(i=0;i<pnum;i++) {
			pdata = (*(buffer + i*2 + 1)<<8) | (*(buffer + i*2));
			pdata &= 0x0ffff;
			
			// Blue. 5bit
			*(pbuffer + i*4) = (pdata & 0x01f) << 3; 
			if(*(pbuffer + i*4) != 0) *(pbuffer + i*4) |= 0x7;
			pdata >>= 5;
			
			// Green. 5bit
			*(pbuffer + i*4 + 1) = (pdata & 0x01f) << 3;
			if(*(pbuffer + i*4 + 1) != 0) *(pbuffer + i*4 + 1) |= 0x7;
			pdata >>= 5;
			
			// Red. 5bit
			*(pbuffer + i*4 + 2) = (pdata & 0x01f) << 3;
			if(*(pbuffer + i*4 + 2) != 0) *(pbuffer + i*4 + 2) |= 0x7;
			pdata >>= 5;
			
			// Alpha
			if((pdata&1) == 0)
				*(pbuffer + i*4 + 3) = 0;
			else *(pbuffer + i*4 + 3) = 0xff;
		} // for i
		break;
	case C24BPP : // 24bpp
		for(i=0;i<pnum;i++) {
			for(j=0;j<3;j++) 
				*(pbuffer + i*4 + j) = *(buffer + i*3 + j);
			
			// Alpha
			*(pbuffer + i*4 + 3) = 0;
		} // for i
		break;
	case C32BPP :
	case CA32BPP :
	default : // 32bpp
		for(i=0;i<pnum;i++) {
			for(j=0;j<4;j++) 
				*(pbuffer + i*4 + j) = *(buffer + i*4 + j);
		} // for i
		break;
	} // switch

	return;

} // to32bpp




void from32bpp(uchar *pbuffer, uint addr, int pnum, int type, int kind)
// pbuffer : pixel buffer
// addr : read address
// num : pixel number
// type : picture type
{
	uchar    buffer[LINE_SIZE];
	int      len; // read byte size
	int      i, j;
	uint     pdata;  // pixel data

	// cached write
	
	if(pnum > 8) {
		printf("\n Error : pixel number is large too. from32bpp");
		exit(0);
	}
	
	
// pixel cache로 부터 8pixel을 읽기 위한 byte 수로 변환하여 call
	// calc. byte count
	switch(type) {
	case MONO : // mono
		len = pnum / 8;
		len += (pnum % 8)?1:0;
		break;
	case C8BPP : // 8bpp
		len = pnum;
		break;
	case C16BPP : // 16bpp
	case CA16BPP : // 16bpp with A
		len = pnum * 2;
		break;
	case C24BPP : // 24bpp
		len = pnum * 3;
		break;
	case C32BPP : // 32bpp
	case CA32BPP :
	default : 
		len = pnum * 4;
		break;
	} // switch
	
// Pixel data를 type에 맞도록 변환
	
	switch(type) {
	case MONO : // mono
		pdata = 0;
		for(i=pnum;i>=0;i--) {
			pdata <<= 1;
			if(*(pbuffer + i*4) != 0) // not black
				pdata |= 1;
			else pdata &= 0xfffE;
		} // for i
		buffer[0] = (uchar)pdata;
		break;
	case C8BPP : // 8bpp
		for(i=0;i<pnum;i++) {
			buffer[i] = *(pbuffer + i*4); // LSB만 사용.
		} // for i
		break;
	case C16BPP : // 16bpp  565
		for(i=0;i<pnum;i++) {
			pdata = 0;
			pdata = (*(pbuffer + i*4 + 2)>>3) & 0x001f;
			pdata <<= 6;
			pdata = (*(pbuffer + i*4 + 1)>>2) & 0x003f;
			pdata <<= 5;
			pdata = (*(pbuffer + i*4    )>>3) & 0x001f;
			
			buffer[i*2] = (uchar)pdata & 0x0ff;
			buffer[i*2+1] = (uchar)pdata>>8 & 0x0ff;
		}
		break;
	case CA16BPP : // 16bpp with A. 1555
		for(i=0;i<pnum;i++) {
			pdata = 0;
			pdata = (*(pbuffer + i*4 + 3) != 0)? 1 : 0;
			pdata <<= 5;
			pdata = (*(pbuffer + i*4 + 2)>>3) & 0x001f;
			pdata <<= 5;
			pdata = (*(pbuffer + i*4 + 1)>>3) & 0x001f;
			pdata <<= 5;
			pdata = (*(pbuffer + i*4    )>>3) & 0x001f;
			
			buffer[i*2] = (uchar)pdata & 0x0ff;
			buffer[i*2+1] = (uchar)pdata>>8 & 0x0ff;
		}
		break;
	case C24BPP : // 24bpp
		for(i=0;i<pnum;i++) {
			for(j=0;j<3;j++) {
				buffer[i*3+j] = *(pbuffer + i*4 + j);
			}
		}
		break;
	case C32BPP : // 32bpp
		for(i=0;i<pnum;i++) {
			for(j=0;j<3;j++) {
				buffer[i*4+j] = *(pbuffer + i*4 + j);
			}
			buffer[i*4 + 3] = 0;
		}
		break;
	case CA32BPP :
	default : 
		for(i=0;i<pnum*4;i++) {
			buffer[i] = *(pbuffer + i);
		}
		break;
	} // switch
	
	// write to pixel cache
	wr_pcache(buffer,addr,len);
	
	return ;
	
} // from32bpp
