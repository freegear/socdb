/****************************************************

   Calc. source picture info. for drawing engine

   file name : src_pic.c
   created by gtlee
   data : 2006.9.27

   note : 
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __SRC_PIC__
#define  __SRC_PIC__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"

#include "src_pic.h"



// 점 SP --> float로 표현.




//===============================================================
// BLT에서.
// source picture에서의 position 계산을 위한 기본 값과 변화량 계산.
void src_base_pos_blt(int va, int vb, int vc, int vd, 
					  int now_vpos, int hda, int hcb,
					  pos sa, pos sb, pos sc, pos sd,
					  float *h_ratio, float *v_ratio, 
					  fpos *src_pos)
// va : left line edge의 vertical position
// vb : right line edge의 vertical position
// vc : right line edge의 vertical position
// vd : left line edge의 vertical position
// now_vpos : 현재의 vertical position
// hda : horizontal start position
// hcb : horizontal end position
// sa : source picture의 left line edge
// sb : source picture의 right line edge
// sc : source picture의 right line edge
// sd : source picture의 left line edge
// h_ratio : pixel별 horizontal 변화량.
// v_ratio : pixel별 vertical 변화량.
// src_pos : 현재 vertical line에 해당하는 source pixel position 
{
	fpos      sda;
	fpos      scb;


	// left position
	calc_base_pos_blt(va, vd, now_vpos, sa, sd, &sda);
	
	// right position
	calc_base_pos_blt(vb, vc, now_vpos, sb, sc, &scb);
	
	
	// horizontal 변화량.
	*h_ratio = (sda.h - scb.h)/(hcb - hda);
	
	// vertical 변화량.
	*v_ratio = (sda.v - scb.v)/(hcb - hda);		 
	
	// position of the source first pixel
	src_pos->v = sda.v;
	src_pos->h = sda.h;
	
} // src_base_pos_blt








//------------------------------------------
// source의 base position을 계산.
// calc. (h_Sd, v_Sd), (h_Sb, v_Sb)
void calc_base_pos_blt(int va, int vd, int now_vpos,
				   pos sa, pos sd, fpos *sda)
// va : start vertical position
// vd : end vertical position
// now_vpos : 현재의 vertical position
// sa : source position of point A
// sd : source position of point D
// sda : source position of point d(interpolated between A and D)
{
	float     d_ratio;
	
	d_ratio = (now_vpos - va)/(vd - va);
	sda->h = (sd.h-sa.h)*d_ratio + sa.h;
	sda->h = (sd.v-sa.v)*d_ratio + sa.v;
} // calc_base_pos_blt







//============================================
// Rotate에서.
// source picture에서의 position 계산을 위한 기본 값과 변화량 계산.
void src_base_pos_rot(int dzp_v, int now_vpos,
					  int sin_fix, int cos_fix,
					  float *h_ratio, float *v_ratio, 
					  fpos *src_pos )
// dzp_v : vertical position of the destination zero point
// now_vpos : 현재의 vertical position
// sin_fix : integer형 sin value. fixed point value
// cos_fix : integer형 cos value. fixed point value
// h_ratio : pixel별 horizontal 변화량.
// v_ratio : pixel별 vertical 변화량.
// src_pos : 현재 vertical line에 해당하는 source pixel position
{
	if(sin_fix == 0x07FFF) // if 1,
		*v_ratio = 1;
	else 
		*v_ratio = 0 - sin_fix / pow(2,15);  // fixed -> float

	src_pos->h = (now_vpos - dzp_v)*(0-*v_ratio);
	
	if(cos_fix == 0x07FFF) // if 1,
		*h_ratio = 1;
	else 
		*h_ratio = cos_fix / pow(2,15);  // fixed -> float

	src_pos->v = (now_vpos - dzp_v)*(*h_ratio);

} // src_base_pos_rot








//============================================
// 매 pixel의 source position을 계산.
// offset을 더해서 next pixel의 위치를 계산.
void calc_src_pos(float *h_ratio, float *v_ratio, 
				  fpos *src_pos)
// h_ratio : pixel별 horizontal 변화량.
// v_ratio : pixel별 vertical 변화량.
// src_pos : source pixel position
{

	src_pos->h += *h_ratio;
	src_pos->v += *v_ratio;

} // calc_src_pos








//======================================================
// source pixel interpolation. 2006.1.20
//   4개의 인접한 pixel을 interpolation한다.
uint interp_src_pixel(uint src_color[4], fpos *src_pos)
// src_color : src_pos에 인접한 4점의 color
// src_pos : 현재 destination pixel에 대응하는 source pixel의 position
// return : interpolated color
{
	int     i, j;
	pos     pos_i;	// range : 0 ~ 1.
	uint    scolor[4];
	uint    rcolor;
	uint    color;

	pos_i.v = 16 * (src_pos->v - ((int)src_pos->v) + (float)1/32); // 소수점 이하 추출.

	pos_i.h = 16 * (src_pos->h - ((int)src_pos->h) + (float)1/32); // 소수점 이하 추출.
	
	color = 0;
	for(i=0;i<4;i++) {
		for(j=0;j<4;j++) scolor[j] = src_color[j]>>(i*8);
		rcolor = interp_color(scolor,&pos_i);
		color = rcolor << (i*8);
	} // for

	return color;
} // interp_src_pixel






//---------------------------------------------
// 단일 color의 interpolation
uint interp_color(uint color[4], pos *pos_i)
// color : 인접한 color값(single color, r,g,b,a중 하나만.)
// pos : pixel position
// return : interpolated color 
{
	uint   v_intp[2];
	uint   h_intp;
	
	// vertical inerpolation
	v_intp[0] = (color[3] - color[0]) * pos_i->v / 16 + color[0];
	v_intp[1] = (color[2] - color[1]) * pos_i->v / 16 + color[1];

	// horizontal interpolation
	h_intp = (v_intp[1] - v_intp[0]) * pos_i->h / 16 + v_intp[0];

	return     h_intp;
} // interp_color






//=========================================================
// interpolate source picture mask pattern
uint interp_src_pat(uint pat[4], fpos *src_pos)
// pat : patterns
// src_pos : 현재 destination pixel에 대응하는 source pixel의 position
// return : interpolated pattern
{
	int       posh, posv;

	// select a pattern
	posh = 1 & ((int)(src_pos->h * 2)); // 첫번째 소수점 추출.
	posv = 1 & ((int)(src_pos->v * 2)); // 첫번째 소수점 추출.
	
	if(posv == 1) posh = 1 & (~posh);

	return pat[posv*2+posh];

} // interp_src_pat
