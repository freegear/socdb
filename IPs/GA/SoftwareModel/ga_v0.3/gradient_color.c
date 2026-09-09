/****************************************************

   gradient color interpolation

   file name : gradient_color.c
   created by gtlee
   data : 2006.10.10

   note : 
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __GRADIENT__
#define  __GRADIENT__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"


#include "gradient_color.h"




//========================================================
// Base calc. of the Gradient interpolation
void gradient_base(uint t_color, uint r_color, uint b_color, uint l_color,
				   int *dst_vpos, int now_vpos, int st_hpos, int ed_hpos,
				   float *base_color, float *ratio)
// t_color : top left color
// r_color : top right color
// b_color : bottom right color
// l_color : bottom left color
// dst_vpos[4] : destination vertical position structure.
// now_vpos : now vertical position
// st_hpos : start horizontal position
// ed_hpos : end  horizontal position
// base_color[4] : start position color(R,G,B,A)
// ratio[4] : pixel간 color 변화량(R,G,B,A)
{
	float    color_left[4], color_right[4];
	float    inv_hdist; // inversed horizontal distance
	int      i;

	// left point
	if(now_vpos < dst_vpos[3]) // da
		all_color_interp(t_color,l_color, dst_vpos[0],dst_vpos[3], 
						 now_vpos, color_left);
	else // cd
		all_color_interp(l_color,b_color, dst_vpos[3],dst_vpos[2], 
						 now_vpos, color_left);

	for(i=0;i<4;i++) base_color[i] = color_left[i];
	

	// right point
	if(now_vpos < dst_vpos[1]) // ba
		all_color_interp(t_color,r_color, dst_vpos[0],dst_vpos[1], 
						 now_vpos, color_left);
	else if(now_vpos < dst_vpos[2]) // cb
		all_color_interp(r_color,b_color, dst_vpos[1],dst_vpos[2], 
						 now_vpos, color_left);
	else // dc
		all_color_interp(b_color,l_color, dst_vpos[2],dst_vpos[3], 
						 now_vpos, color_left);
	
	// clac. ratio
	inv_hdist = 1 / (ed_hpos - st_hpos);
	for(i=0;i<4;i++) 
		ratio[i] = (color_right[i] - color_left[i]) * inv_hdist;

} // gradient_base







//------------------------------------------------
// interpolate all color of pixel
void all_color_interp(uint color_s, uint color_l,
					  int pos_s, int pos_l,
					  int now_pos, float *color  )
// color_s : color of the small position
// color_l : color of the large position
// pos_s : the small position
// pos_l : the large position
// now_pos : now position
// color : return color value
{
	float     d_ratio;
	int       s_color_s, s_color_l; // splitted color
	int       i;

	d_ratio = (now_pos - pos_s) / (pos_l - pos_s);
	
	for(i=0;i<4;i++) {
		s_color_s = 0x0ff & (color_s >> (i*8));
		s_color_l = 0x0ff & (color_l >> (i*8));
		color[i] = color_interp(d_ratio, s_color_s, s_color_l);
	} // for
} // all_color_interp







//------------------------------------------------
// interpolate one color of pixel
//     color saturation은 뒷 연산에서 처리.
float  color_interp(float d_ratio,int color_s, int color_l)
// d_ratio : divide ratio.
// color_s : lower pixel color
// color_l : upper pixel color
// return : interpolated color
{
	float    color;

	color = (color_l - color_s)*d_ratio + color_s;

	return color;
} // color_interp



//==================================================
// 다음 pixel의 color값 계산.
// add 
void  next_color(float *color, float *ratio)
// color : next color for update
// ratio : pixel간 color변화량
{
	int    i;

	for(i=0;i<4;i++)
		color[i] = color[i] + ratio[i];

} // next_color




//---------------------------------------------
// color saturation
uint satr_color(float *fcolor)
// fcolor : float type color
// return : packed integer color
{
	int     i;
	uint    color;
	uint    icolor;

	icolor = 0;

	for(i=0;i<4;i++) {
		if(fcolor[i] > 255)    color = 255;
		else if(fcolor[i] < 0) color = 0;
		else color = (int)fcolor;
		
		color &= 0x0ff;
		color = color << (8*i);
		
		icolor |= color;
	}
	
	return icolor;
} // satr_color
