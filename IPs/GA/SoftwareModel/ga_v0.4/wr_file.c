/****************************************************

   write a picture to a file

   file name : wr_file.c
   created by gtlee
   data : 2006.7.3

   note :
         
   history :

****************************************************/

#define __DEBUG__

#ifndef  __WR_FILE__
#define  __WR_FILE__
#endif


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"
#include "axi_if.h"
#include "ld_file.h"

#include "wr_file.h"



//================================================
// write a picture to a file
int wr_pic_list(char *fname)
// fname : write file list
// return : write file number
{
	FILE   *wrlf = NULL;
	int     wrfnum; // write file count
	int     pic_num;
	int     align; // BMP Horizontal alignment flag
	char    wrfname[104];
	
	wrlf = fopen(fname,"r");
	if(wrlf == NULL) {
		printf("\n ERROR : cannot open a write list file for a picture : %s",fname);
		return 0;
	} // if

	wrfnum = 0;
	while(fscanf(wrlf,"%d %d %100s",&pic_num,&align,wrfname) != EOF) {
#ifdef __DEBUG__
		printf("\n Write file : %s",wrfname);
#endif
		if(pic_num >= 16) continue;
		if(picture[pic_num].addr == 0) continue;

		if(wr_pic(pic_num, align, wrfname) == 0) {
			break;
		} // if
		wrfnum++;
	} // while

	fclose(wrlf);
	return  wrfnum;

} // wr_pic_list()







uint wr_pic(int pic_num, int align, char *fname)
// pic_num : picture number
// align : BMP alignment flag
// fname : write file name
// return : pixel count
{
	FILE     *wrfile=NULL;
	uint      bytes; // write byte count
	uint      pic_size; // picture size. bytes
	int       pixelx, pixely;
	uint      pcolor;  // pixel color
	uint      nth_pixel;
	int       r,g,b;
	uchar    *pic_base;

	wrfile = fopen(fname, "wb");
	if(wrfile == NULL) {
		printf("\n ERROR : Cannot open a file for writing a picture : %s",fname);
		return 0;
	} // if

#ifdef __DEBUG__
	printf("\n Picture write : %s",fname);
	printf("\n size : %d, %d",picture[pic_num].maxx,
		   picture[pic_num].maxy);
	printf("\n type : %d", picture[pic_num].type);
	printf("\n memory address : %x\n",picture[pic_num].addr);
#endif

	pic_base = (uchar *)picture[pic_num].addr;
	
	for(pixely=0;pixely<picture[pic_num].maxy;pixely++) {
		for(pixelx=0;pixelx<picture[pic_num].maxx;pixelx++) {
			// read one pixel and change 24bpp
			//     pixel number.
			nth_pixel = (pixely * picture[pic_num].maxx) + pixelx; 

			switch(picture[pic_num].type) {
			case MONO : // mono
				pcolor = *(pic_base + (nth_pixel>>3));
				pcolor >>= (nth_pixel & 0x07);
				pcolor &= 0x01;
				pcolor = (pcolor == 0)? 0 : 0x00ffffff;
				break;
			case C8BPP : // 8bpp
				pcolor = *(pic_base + nth_pixel);
				pcolor &= 0x0ff;
				pcolor = pcolor << 16 | pcolor << 8 | pcolor;
				break;
			case C16BPP : // 16bpp. 565
			case CA16BPP : // 16bpp with A
				pcolor = *(pic_base + (nth_pixel * 2) + 1) & 0x0ff;
				pcolor = pcolor<<8 + *(pic_base + (nth_pixel * 2)) & 0x0ff;
				b = pcolor & 0x01f;
				b = b << 3;
				b |= (b == 0) ? 0 : 0x07;

				if(picture[pic_num].type == C16BPP) {
					g = (pcolor>>5) & 0x03f;
					g = g << 2;
					g |= (g == 0)? 0 : 0x03;
				} // if
				else {
					g = (pcolor>>5) & 0x01f;
					g = g << 3;
					g |= (g == 0)? 0 : 0x07;
				} // else

				r = (pcolor >> 11) & 0x01f;
				r = r << 3;
				r |= (r == 0)? 0 : 0x07;

				pcolor = r << 16 | g << 8 | b;
				break;
			case C24BPP : // 24bpp
				pcolor =  *(pic_base + (nth_pixel * 3) + 2) & 0x0ff;
				pcolor <<= 8;
				pcolor |= *(pic_base + (nth_pixel * 3) + 1) & 0x0ff;
				pcolor <<= 8;
				pcolor |= *(pic_base + (nth_pixel * 3) + 0) & 0x0ff;
				break;
			case C32BPP : // 32bpp
			case CA32BPP :
			default : 
				pcolor =  *(pic_base + (nth_pixel * 4) + 2) & 0x0ff;
				pcolor <<= 8;
				pcolor |= *(pic_base + (nth_pixel * 4) + 1) & 0x0ff;
				pcolor <<= 8;
				pcolor |= *(pic_base + (nth_pixel * 4) + 0) & 0x0ff;
				break;
			} // switch

			// write to the file
			//    output one pixel.
			fwrite(&pcolor,1,3,wrfile);

		}// for pixelx
		// the dummy for the alignment
		if(align != 0) {
			bytes = pixelx*3;
			pcolor = 0;
			while((bytes & 0x03) != 0) {
				fwrite(&pcolor, 1, 1, wrfile);
				bytes ++;
			} // while
		}// if align
	}// for pixely
	
	fclose(wrfile);

	return (pixelx * pixely);
} // wr_pic
