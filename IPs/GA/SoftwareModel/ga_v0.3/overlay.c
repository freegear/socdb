/****************************************************

   overlay pixels

   file name : overlay.c
   created by gtlee
   data : 2006.10.20

   note : 
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __OVERLAY__
#define  __OVERLAY__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"

#include "overlay.h"




// destination pattern : active된 곳만 drawing.
// source pattern : active된 source pixel만 destination으로 drawing
// brush pattern : active -> foreground color
//                 inactive -> background color
//





//======================================================
// Raster Operation
// color bit별 muxing. Alpha value is skipped.
uint rast_op(uint r_code, uint dst_color, uint dst_pat,
			 uint src_color, uint src_pat, 
			 uint brush_color)
// r_code : raster operation code
// dst_color : destination picture color
// dst_pat : destination pattern
// src_color : source picture color
// src_pat : source pattern
// brush_color : brush color
// return : overlayed color
{
	int       i;
	int       brs_bit; // brush pattern
	int       src_bit;
	int       dst_bit;
	int       mux_in;
	int       rst; // result bit
	uint      rst_color;

	rst_color = dst_color & 0xff000000; // copy alpha value

	for(i=0;i<24;i++) { // only color data
		brs_bit = 1 & (brush_color >> i);
		src_bit = 1 & (src_color >> i);
		dst_bit = 1 & (dst_color >> i);

		mux_in = (brs_bit << 2) | (src_bit << 1) | dst_bit;
		mux_in &= 0x07; // low 3bit만 유효.

		rst = 1 & (r_code >> mux_in);
		
		rst_color |= rst << i;
	} // for

	return rst_color;

} // rast_op







//======================================================
// Alpha Blending
uint alpha_blend(int const_alpha, int choose, uint dst_color,
				 uint src_color)
// const_alpha : constant alpha value. source picture 전체의 alpha value
// choose : constant alpha value의 사용 유무 결정.
// dst_color : destination color
// src_color : source color
// retern : result color
{
	
	int      single_color;
    int      calpha;
	int      tmp_color[4];
	int      i;
	uint     result;

	
	calpha = (choose == 0)? 0x0ff : const_alpha;

	// pre-calculation
	for(i=0;i<4;i++) {
		single_color = src_color>>(i*8) & 0x0ff;
		tmp_color[i] = pre_alpha(single_color,calpha);
	} // for

	result = 0;

	// calc. destination pixel color
	for(i=0;i<4;i++) {
		single_color = single_alpha(tmp_color[i],tmp_color[3],
							  dst_color>>(i*8));
		result |= single_color << (i*8);
	} // for

	return result;

} // alpha_blend






//--------------------------------------------
// Alpha blending pre calc.
// Temp.Red = Round((Src.Red * SourceConstantAlpha) / 255);
int pre_alpha(int color, int alpha)
// color : single pixel color. R or G or B or A
// alpha : alpha value
// return : pre calculated color
{
	int       result;
	
	//result = (floast)0.5 + (float)(color * alpha) / 255;
    result = (color * alpha) + 128;
    result = (result + (result >> 8)) >> 8;

	result = (result > 255)? 255 : result;

	return result;

} // pre_alpha






//----------------------------------------------
// Single color Alpha blending
// Dst.Red = Temp.Red + Round(((255 - Temp.Alpha) * Dst.Red) / 255);
int single_alpha(int src_color, int src_alpha, int dst_color)
// src_color : source pixel single color
// src_alpha : pixel alpha value
// dst_color : destination pixel singled 
// return : calculated color
{
	int     result;

	result = src_color + pre_alpha(dst_color, (255-src_alpha));

	result = (result > 255)? 255 : result;

	return result;

} // single_alpha



/*
The source bitmap has no per-pixel alpha (AC_SRC_ALPHA is not set), so the blend is applied to the pixel's color channels based on the constant source alpha value specified in SourceConstantAlpha as follows:
Dst.Red = Round(((Src.Red * SourceConstantAlpha) + 
    ((255 - SourceConstantAlpha) * Dst.Red)) / 255);
Dst.Green = Round(((Src.Green * SourceConstantAlpha) + 
    ((255 - SourceConstantAlpha) * Dst.Green)) / 255);
Dst.Blue = Round(((Src.Blue * SourceConstantAlpha) + 
    ((255 - SourceConstantAlpha) * Dst.Blue)) / 255);
// Do the next computation only if the destination bitmap has an alpha channel.
Dst.Alpha = Round(((Src.Alpha * SourceConstantAlpha) + 
    ((255 - SourceConstantAlpha) * Dst.Alpha)) / 255);


The source bitmap has per-pixel alpha values (AC_SRC_ALPHA is set), and SourceConstantAlpha is not used (it is set to 255). The blend is computed as follows:
Dst.Red = Src.Red + 
    Round(((255 - Src.Alpha) * Dst.Red) / 255);
Dst.Green = Src.Green + 
    Round(((255 - Src.Alpha) * Dst.Green) / 255);
Dst.Blue = Src.Blue + 
    Round(((255 - Src.Alpha) * Dst.Blue) / 255);
// Do the next computation only if the destination bitmap has an alpha channel.
Dst.Alpha = Src.Alpha + 
    Round(((255 - Src.Alpha) * Dst.Alpha) / 255);


The source bitmap has per-pixel alpha values (AC_SRC_ALPHA is set), and SourceConstantAlpha is used (it is not set to 255). The blend is computed as follows:
Temp.Red = Round((Src.Red * SourceConstantAlpha) / 255);
Temp.Green = Round((Src.Green * SourceConstantAlpha) / 255);
Temp.Blue = Round((Src.Blue * SourceConstantAlpha) / 255);
// The next computation must be done even if the destination bitmap does not have an alpha channel.
Temp.Alpha = Round((Src.Alpha * SourceConstantAlpha) / 255);
 
// Note that the following equations use the just-computed Temp.Alpha value:
Dst.Red = Temp.Red + 
    Round(((255 - Temp.Alpha) * Dst.Red) / 255);
Dst.Green = Temp.Green + 
    Round(((255 - Temp.Alpha) * Dst.Green) / 255);
Dst.Blue = Temp.Blue + 
    Round(((255 - Temp.Alpha) * Dst.Blue) / 255);
// Do the next computation only if the destination bitmap has an alpha channel.
Dst.Alpha = Temp.Alpha + 
    Round(((255 - Temp.Alpha) * Dst.Alpha) / 255);
*/









