/*************************************************************************

   Set Line information and parameter

   file name : line_param.c
   created by gtlee
   data : 2006.9.5

   note :

   history :

************************************************************************/


#ifndef    __LINE_PARAM__
#define    __LINE_PARAM__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "gbus.h"
#include "cmd_buff.h"
#include "gpu.h"
#include "hrange.h"
#include "line.h"

#include "line_param.h"





//-----------------------------
// at no pattern
void set_no_pattern(void)
{
	if(sort_edge[3].v == sort_edge[0].v &&
	   sort_edge[3].h == sort_edge[0].h) { // tri-angle

		if(sort_edge[1].v == sort_edge[2].v &&
		   sort_edge[1].h == sort_edge[2].h)
		   goto horizontal_line;
		else {
			if(sort_edge[0].v == sort_edge[1].v) {
				// 윗 직선이 수평인 삼각형.

				// left beeline
				bline_i[0].en = 1;
				bline_i[0].update = 1;
				bline_i[0].st_pos.v = sort_edge[3].v;
				bline_i[0].st_pos.h = sort_edge[3].h;
				bline_i[0].sp_pos.v = sort_edge[2].v;
				bline_i[0].sp_pos.h = sort_edge[2].h;
				bline_i[0].ed_pos.v = bline_i[0].sp_pos.v;
				bline_i[0].ed_pos.h = bline_i[0].sp_pos.h;

				bline_i[0].dv = bline_i[0].sp_pos.v - bline_i[0].st_pos.v;
				bline_i[0].dh = bline_i[0].sp_pos.h - bline_i[0].st_pos.h;

				// right beeline
				bline_i[1].en = 1;
				bline_i[1].update = 1;
				bline_i[1].st_pos.v = sort_edge[1].v;
				bline_i[1].st_pos.h = sort_edge[1].h;
				bline_i[1].sp_pos.v = sort_edge[2].v;
				bline_i[1].sp_pos.h = sort_edge[2].h;
				bline_i[1].ed_pos.v = bline_i[1].sp_pos.v;
				bline_i[1].ed_pos.h = bline_i[1].sp_pos.h;

				bline_i[1].dv = bline_i[1].sp_pos.v - bline_i[1].st_pos.v;
				bline_i[1].dh = bline_i[1].sp_pos.h - bline_i[1].st_pos.h;
			}
			else {
				// 일반적인 삼각형.

				// left beeline
				bline_i[0].en = 1;
				bline_i[0].update = 1;
				bline_i[0].st_pos.v = sort_edge[3].v;
				bline_i[0].st_pos.h = sort_edge[3].h;
				bline_i[0].sp_pos.v = sort_edge[2].v;
				bline_i[0].sp_pos.h = sort_edge[2].h;
				bline_i[0].ed_pos.v = bline_i[0].sp_pos.v;
				bline_i[0].ed_pos.h = bline_i[0].sp_pos.h;

				bline_i[0].dv = bline_i[0].sp_pos.v - bline_i[0].st_pos.v;
				bline_i[0].dh = bline_i[0].sp_pos.h - bline_i[0].st_pos.h;

				// right beeline
				bline_i[1].en = 1;
				bline_i[1].update = 1;
				bline_i[1].st_pos.v = sort_edge[0].v;
				bline_i[1].st_pos.h = sort_edge[0].h;
				bline_i[1].sp_pos.v = sort_edge[1].v;
				bline_i[1].sp_pos.h = sort_edge[1].h;
				bline_i[1].ed_pos.v = bline_i[1].sp_pos.v;
				bline_i[1].ed_pos.h = bline_i[1].sp_pos.h;

				bline_i[1].dv = bline_i[1].sp_pos.v - bline_i[1].st_pos.v;
				bline_i[1].dh = bline_i[1].sp_pos.h - bline_i[1].st_pos.h;
			}
		}
	}
	else { // rectangle
		if(sort_edge[0].v == sort_edge[1].v) {
		  horizontal_line :
			// 수평, 수직선.
			
			// left beeline
			bline_i[0].en = 1;
			bline_i[0].update = 1;
			bline_i[0].st_pos.v = sort_edge[0].v;
			bline_i[0].st_pos.h = sort_edge[0].h;
			bline_i[0].sp_pos.v = sort_edge[3].v;
			bline_i[0].sp_pos.h = sort_edge[3].h;
			bline_i[0].ed_pos.v = bline_i[0].sp_pos.v;
			bline_i[0].ed_pos.h = bline_i[0].sp_pos.h;
			
			bline_i[0].dv = bline_i[0].sp_pos.v - bline_i[0].st_pos.v;
			bline_i[0].dh = bline_i[0].sp_pos.h - bline_i[0].st_pos.h;
			
			// right beeline
			bline_i[1].en = 1;
			bline_i[1].update = 1;
			bline_i[1].st_pos.v = sort_edge[1].v;
			bline_i[1].st_pos.h = sort_edge[1].h;
			bline_i[1].sp_pos.v = sort_edge[2].v;
			bline_i[1].sp_pos.h = sort_edge[2].h;
			bline_i[1].ed_pos.v = bline_i[1].sp_pos.v;
			bline_i[1].ed_pos.h = bline_i[1].sp_pos.h;
			
			bline_i[1].dv = bline_i[1].sp_pos.v - bline_i[1].st_pos.v;
			bline_i[1].dh = bline_i[1].sp_pos.h - bline_i[1].st_pos.h;
		}
		else {
			// 일반적인 사각형.
			// left beeline
			bline_i[0].en = 1;
			bline_i[0].update = 1;
			bline_i[0].st_pos.v = sort_edge[0].v;
			bline_i[0].st_pos.h = sort_edge[0].h;
			bline_i[0].sp_pos.v = sort_edge[3].v;
			bline_i[0].sp_pos.h = sort_edge[3].h;
			bline_i[0].ed_pos.v = bline_i[0].sp_pos.v;
			bline_i[0].ed_pos.h = bline_i[0].sp_pos.h;
			
			bline_i[0].dv = bline_i[0].sp_pos.v - bline_i[0].st_pos.v;
			bline_i[0].dh = bline_i[0].sp_pos.h - bline_i[0].st_pos.h;
			
			// right beeline
			bline_i[1].en = 1;
			bline_i[1].update = 1;
			bline_i[1].st_pos.v = sort_edge[0].v;
			bline_i[1].st_pos.h = sort_edge[0].h;
			bline_i[1].sp_pos.v = sort_edge[1].v;
			bline_i[1].sp_pos.h = sort_edge[1].h;
			bline_i[1].ed_pos.v = bline_i[1].sp_pos.v;
			bline_i[1].ed_pos.h = bline_i[1].sp_pos.h;
			
			bline_i[1].dv = bline_i[1].sp_pos.v - bline_i[1].st_pos.v;
			bline_i[1].dh = bline_i[1].sp_pos.h - bline_i[1].st_pos.h;
		}
	}
} // set_no_pattern







//-------------------------------------------------------
// rest pattern이 남아 있을 경우 
void set_rest_pat(void)
{
	if(pat_attr == 0) { // if invisible pattern
		if(bline_sslop < 0) { // slope is minus
			// right beeline
			bline_i[1].en = 0;
			bline_i[1].update = 0;
			bline_i[1].st_pos.v = sort_edge[0].v;
			bline_i[1].st_pos.h = sort_edge[0].h;
			bline_i[1].sp_pos.v = sort_edge[1].v;
			bline_i[1].sp_pos.h = sort_edge[1].h;
			//bline_i[1].ed_pos.v = bline_i[1].sp_pos.v;
			//bline_i[1].ed_pos.h = bline_i[1].sp_pos.h;
			bline_i[1].dv = bline_i[1].sp_pos.v - bline_i[1].st_pos.v;
			bline_i[1].dh = bline_i[1].sp_pos.h - bline_i[1].st_pos.h;
		} // if bline_sslop < 0
		else if(bline_dv == 0) { // 수평선
			next_st_pos.en = 0;
			next_st_pos.update = 0;
			next_st_pos.st_pos.v = sort_edge[0].v;
			next_st_pos.st_pos.h = sort_edge[0].h;
			next_st_pos.sp_pos.v = next_st_pos.st_pos.v;
			next_st_pos.sp_pos.h = next_st_pos.st_pos.h + rest_pat_px;
			next_st_pos.ed_pos.v = sort_edge[1].v;
			next_st_pos.ed_pos.h = sort_edge[1].h;
			
			if(next_st_pos.sp_pos.h > next_st_pos.ed_pos.h)
				next_st_pos.sp_pos.h = sort_edge[1].h + 1;
		} // else if 수평선 
		else if(bline_dh == 0) { // 수직선
			// left beeline
			bline_i[0].en = 0;
			bline_i[0].update = 0;
			bline_i[0].st_pos.v = sort_edge[0].v;
			bline_i[0].st_pos.h = sort_edge[0].h;
			bline_i[0].sp_pos.v = sort_edge[0].v;
			bline_i[0].sp_pos.h = sort_edge[0].h;
			//bline_i[0].ed_pos.v = bline_i[0].sp_pos.v;
			//bline_i[0].ed_pos.h = bline_i[0].sp_pos.h;
			bline_i[0].dv = 1;
			bline_i[0].dh = 0;

			// right beeline
			bline_i[1].en = 0;
			bline_i[1].update = 0;
			bline_i[1].st_pos.v = sort_edge[1].v;
			bline_i[1].st_pos.h = sort_edge[1].h;
			bline_i[1].sp_pos.v = sort_edge[1].v; // <== init
			bline_i[1].sp_pos.h = sort_edge[1].h; // <== init
			//bline_i[1].ed_pos.v = bline_i[1].sp_pos.v;
			//bline_i[1].ed_pos.h = bline_i[1].sp_pos.h;
			bline_i[1].dv = 1;
			bline_i[1].dh = 0;
		} // else if 수직선
		else { // slope plus
			// left beeline
			bline_i[0].en = 0;
			bline_i[0].update = 0;
			bline_i[0].st_pos.v = sort_edge[0].v;
			bline_i[0].st_pos.h = sort_edge[0].h;
			bline_i[0].sp_pos.v = sort_edge[3].v;
			bline_i[0].sp_pos.h = sort_edge[3].h;
			//bline_i[0].ed_pos.v = bline_i[0].sp_pos.v;
			//bline_i[0].ed_pos.h = bline_i[0].sp_pos.h;
			bline_i[0].dv = bline_i[0].sp_pos.v - bline_i[0].st_pos.v;
			bline_i[0].dh = bline_i[0].sp_pos.h - bline_i[0].st_pos.h;
		} // else
	} // if pat_attr == 0
} // set_rest_pat





//-------------------------------------------------------
// First drawing with line pattern
void set_first_draw(void)
{
	if(bline_sslop < 0) { // slope is minus
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = sort_edge[0].v;
		bline_i[0].st_pos.h = sort_edge[0].h;
		bline_i[0].ed_pos.v = sort_edge[3].v;
		bline_i[0].ed_pos.h = sort_edge[3].h;
		bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
		bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;

		bline_i[0].sp_pos.v = bline_i[0].st_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].st_pos.h;
		mv_stop_pos(&bline_i[0], pat_len);

		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = sort_edge[0].v;
		bline_i[1].st_pos.h = sort_edge[0].h;
		bline_i[1].ed_pos.v = sort_edge[1].v;
		bline_i[1].ed_pos.h = sort_edge[1].h;
		bline_i[1].dv = bline_i[1].ed_pos.v - bline_i[1].st_pos.v;
		bline_i[1].dh = bline_i[1].ed_pos.h - bline_i[1].st_pos.h;

		bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
	} // if bline_sslop < 0
	else if(bline_dv == 0) { // 수평선
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = sort_edge[0].v;
		bline_i[0].st_pos.h = sort_edge[0].h;
		bline_i[0].ed_pos.v = sort_edge[3].v;
		bline_i[0].ed_pos.h = sort_edge[3].h;
		bline_i[0].dv = 1;
		bline_i[0].dh = 0;

		bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;

		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = bline_i[0].st_pos.v;
		bline_i[1].st_pos.h = bline_i[0].st_pos.h + pat_len;
		bline_i[1].ed_pos.v = sort_edge[2].v;
		bline_i[1].ed_pos.h = sort_edge[2].h;
		bline_i[1].dv = 1;
		bline_i[1].dh = 0;

		bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].st_pos.h;

		// Next Line parameter
		next_st_pos.en = 1;
		next_st_pos.update = 1;
		next_st_pos.st_pos.v = bline_i[0].st_pos.v;
		next_st_pos.st_pos.h = bline_i[0].st_pos.h;
		next_st_pos.ed_pos.v = sort_edge[1].v;
		next_st_pos.ed_pos.h = sort_edge[1].h;
		next_st_pos.sp_pos.v = bline_i[1].st_pos.v;
		next_st_pos.sp_pos.h = bline_i[1].st_pos.h;
	} // else if 수평선 
	else if(bline_dh == 0) { // 수직선
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = sort_edge[0].v;
		bline_i[0].st_pos.h = sort_edge[0].h;
		bline_i[0].ed_pos.v = sort_edge[3].v;
		bline_i[0].ed_pos.h = sort_edge[3].h;
		bline_i[0].dv = 1;
		bline_i[0].dh = 0;

		bline_i[0].sp_pos.v = bline_i[0].st_pos.v + pat_len;
		bline_i[0].sp_pos.h = bline_i[0].st_pos.h;

		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = sort_edge[1].v;
		bline_i[1].st_pos.h = sort_edge[1].h;
		bline_i[1].ed_pos.v = sort_edge[2].v;
		bline_i[1].ed_pos.h = sort_edge[2].h;
		bline_i[1].dv = 1;
		bline_i[1].dh = 0;

		bline_i[1].sp_pos.v = bline_i[1].st_pos.v + pat_len;
		bline_i[1].sp_pos.h = bline_i[1].st_pos.h;
	} // else if 수직선
	else { // slope plus
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = sort_edge[0].v;
		bline_i[0].st_pos.h = sort_edge[0].h;
		bline_i[0].ed_pos.v = sort_edge[3].v;
		bline_i[0].ed_pos.h = sort_edge[3].h;
		bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
		bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;

		bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;

		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = sort_edge[0].v;
		bline_i[1].st_pos.h = sort_edge[0].h;
		bline_i[1].ed_pos.v = sort_edge[1].v;
		bline_i[1].ed_pos.h = sort_edge[1].h;
		bline_i[1].dv = bline_i[1].ed_pos.v - bline_i[1].st_pos.v;
		bline_i[1].dh = bline_i[1].ed_pos.h - bline_i[1].st_pos.h;

		bline_i[1].sp_pos.v = bline_i[1].st_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].st_pos.h;
		mv_stop_pos(&bline_i[1], pat_len);
	} // else
} // set_first_draw






//-------------------------------------------------------
// setup at new beeline area
void set_new_bline_area(void)
{
	if(bline_sslop < 0) { // slope is minus
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;

		bline_i[0].st_pos.v = next_st_pos.sp_pos.v;
		bline_i[0].st_pos.h = next_st_pos.sp_pos.h;
		mv_start_pos(&bline_i[0], 1);
		
		bline_i[0].ed_pos.v = next_st_pos.ed_pos.v; // equal edge[3]
		bline_i[0].ed_pos.h = next_st_pos.ed_pos.h;
		bline_i[0].dv = next_st_pos.dv;
		bline_i[0].dh = next_st_pos.dh;

		bline_i[0].sp_pos.v = bline_i[0].st_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].st_pos.h;
		mv_stop_pos(&bline_i[0], pat_len);

		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = bline_i[0].st_pos.v;
		bline_i[1].st_pos.h = bline_i[0].st_pos.h;

		// stop position + 1
		mv_stop_pos(&bline_i[1], 1);

		bline_i[1].ed_pos.v = bline_i[1].sp_pos.v;
		bline_i[1].ed_pos.h = bline_i[1].sp_pos.h;

		inv_slope(&bline_i[1].dv, &bline_i[1].dh);
	} // if bline_sslop < 0
	else if(bline_dv == 0) { // 수평선
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = next_st_pos.sp_pos.v;
		bline_i[0].st_pos.h = next_st_pos.sp_pos.h + 1;
		//bline_i[0].ed_pos.v = sort_edge[3].v;
		bline_i[0].ed_pos.h = bline_i[0].st_pos.h;

		bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;

		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = bline_i[0].st_pos.v;
		bline_i[1].st_pos.h = bline_i[0].st_pos.h + pat_len;
		//bline_i[1].ed_pos.v = sort_edge[2].v;
		//bline_i[1].ed_pos.h = sort_edge[2].v;

		bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].st_pos.h;

		// Next Line parameter
		next_st_pos.en = 1;
		next_st_pos.update = 1;
		next_st_pos.st_pos.v = bline_i[0].st_pos.v;
		next_st_pos.st_pos.h = bline_i[0].st_pos.h;
		next_st_pos.ed_pos.v = sort_edge[1].v;
		next_st_pos.ed_pos.h = sort_edge[1].h;
		next_st_pos.sp_pos.v = bline_i[1].st_pos.v;
		next_st_pos.sp_pos.h = bline_i[1].st_pos.h;
	} // else if 수평선 
	else if(bline_dh == 0) { // 수직선
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = bline_i[0].sp_pos.v + 1;
		bline_i[0].st_pos.h = bline_i[0].sp_pos.h;
		//bline_i[0].ed_pos.v = sort_edge[3].v;
		//bline_i[0].ed_pos.h = sort_edge[3].h;

		bline_i[0].sp_pos.v = bline_i[0].st_pos.v + pat_len;
		bline_i[0].sp_pos.h = bline_i[0].st_pos.h;

		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = bline_i[1].sp_pos.v + 1;
		bline_i[1].st_pos.h = bline_i[1].sp_pos.h;
		//bline_i[1].ed_pos.v = sort_edge[2].v;
		//bline_i[1].ed_pos.h = sort_edge[2].h;

		bline_i[1].sp_pos.v = bline_i[1].st_pos.v + pat_len;
		bline_i[1].sp_pos.h = bline_i[1].st_pos.h;
	} // else if 수직선
	else { // slope plus
		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = next_st_pos.st_pos.v;
		bline_i[1].st_pos.h = next_st_pos.st_pos.h;
		bline_i[1].ed_pos.v = next_st_pos.ed_pos.v;
		bline_i[1].ed_pos.h = next_st_pos.ed_pos.h;
		bline_i[1].dv = next_st_pos.dv;
		bline_i[1].dh = next_st_pos.dh;

		bline_i[1].sp_pos.v = bline_i[1].st_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].st_pos.h;
		mv_stop_pos(&bline_i[1], pat_len);

		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = bline_i[1].st_pos.v;
		bline_i[0].st_pos.h = bline_i[1].st_pos.h;

		// stop position + 1
		mv_stop_pos(&bline_i[0], 1);

		bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
		bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;

		bline_i[0].ed_pos.v = bline_i[0].sp_pos.v;
		bline_i[0].ed_pos.h = bline_i[0].sp_pos.h;

		inv_slope(&bline_i[0].dv, &bline_i[0].dh);
	} // else. slope plus
} // set_new_bline_area






//============================================================
// circle parameter 설정.

// first & no pattern at circle
void set_first_np_circle(void)
{
	switch(circle_case) {
	case 0 :
		fnp_case0();
		break;
	case 1 :
		fnp_case1();
		break;
	case 2 :
		fnp_case2();
		break;
	case 3 :
		fnp_case3();
		break;
	default : // error. unknown circle case
		printf("\n Error : unkown circle case at first circle.");
	} // switch
}





// first & no pattern case 0
void fnp_case0(void)
{
	int est_pat_len; // estimated pattern length. 외각 사각형의 변의길이.

	if(sort_edge[0].v == sort_edge[1].v &&
	   sort_edge[0].h == sort_edge[1].h) { // if same
		// line width is 1
		// disable beelines
		bline_i[0].en = 0;
		bline_i[0].update = 0;
		bline_i[1].en = 0;
		bline_i[1].update = 0;

		// set left circle informations
		circle_i[0].en = 1;
		circle_i[0].update = 1;
		circle_i[0].ccase = circle_case;
		circle_i[0].st_pos.v = sort_edge[0].v;
		circle_i[0].st_pos.h = sort_edge[0].h;
		circle_i[0].ed_pos.v = sort_edge[3].v;
		circle_i[0].ed_pos.h = sort_edge[3].h;
		circle_i[0].r = circle_i[0].ed_pos.v - circle_i[0].st_pos.v;

		// set right circle information
		circle_i[1].en = 1;
		circle_i[1].update = 1;
		circle_i[1].ccase = circle_case;
		circle_i[1].st_pos.v = sort_edge[1].v;
		circle_i[1].st_pos.h = sort_edge[1].h;
		circle_i[1].ed_pos.v = sort_edge[2].v;
		circle_i[1].ed_pos.h = sort_edge[2].h;
		circle_i[1].r = circle_i[1].ed_pos.v - circle_i[1].st_pos.v;
	} // if same
	else { // else. not same
		// disable left beeline
		bline_i[0].en = 0;
		bline_i[0].update = 0;		
		
		// set right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = sort_edge[0].v;
		bline_i[1].st_pos.h = sort_edge[0].h;
		bline_i[1].ed_pos.v = sort_edge[1].v;
		bline_i[1].ed_pos.h = sort_edge[1].h;
		bline_i[1].dv = 1; // 수직선
		bline_i[1].dh = 0;
		bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;		
		
		// set left circle informations
		circle_i[0].en = 1;
		circle_i[0].update = 1;
		circle_i[0].ccase = circle_case;
		circle_i[0].st_pos.v = sort_edge[0].v;
		circle_i[0].st_pos.h = sort_edge[0].h;
		circle_i[0].ed_pos.v = sort_edge[3].v;
		circle_i[0].ed_pos.h = sort_edge[3].h;
		circle_i[0].r = circle_i[0].ed_pos.v - circle_i[0].st_pos.v;

		// set right circle information
		circle_i[1].en = 0;
		circle_i[1].update = 0;
		circle_i[1].ccase = circle_case;
		circle_i[1].st_pos.v = sort_edge[1].v;
		circle_i[1].st_pos.h = sort_edge[1].h;
		circle_i[1].ed_pos.v = sort_edge[2].v;
		circle_i[1].ed_pos.h = sort_edge[2].h;
		circle_i[1].r = circle_i[1].ed_pos.v - circle_i[1].st_pos.v;

	} // else. not same

	if(line_pattern != 0xffffffff) { // with pattern
		// 남은 line pattern length를 계산.
		est_pat_len = est_circle_len(line_len);

		// top edge와 같은 vertical line상에 있는지 검사.
		if(est_pat_len >= circle_i[0].r) { // yes
			// 수평선에 estimated point가 위치할 경우.
			// left beeline
			bline_i[0].en = 1;
			bline_i[0].update = 1;
			bline_i[0].st_pos.v = sort_edge[0].v;
			bline_i[0].st_pos.h = sort_edge[3].h - circle_i[0].r + est_pat_len;
			bline_i[0].ed_pos.v = sort_edge[3].v; // 원점
			bline_i[0].ed_pos.h = sort_edge[0].h; // 원점
			bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
			bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;
			bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
			bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
		} // if yes
		else { // no
			// 수직선에 estimated point가 위치할 경우.
			// left beeline
			bline_i[0].en = 1;
			bline_i[0].update = 1;
			bline_i[0].st_pos.v = sort_edge[0].v; // 원점의 대각 위치
			bline_i[0].st_pos.h = sort_edge[3].h; // 원점의 대각 위치
			bline_i[0].ed_pos.v = sort_edge[3].v; // 원점
			bline_i[0].ed_pos.h = sort_edge[0].h; // 원점
			bline_i[0].dv = 1; // 수직선.
			bline_i[0].dh = 0;
			bline_i[0].sp_pos.v = sort_edge[3].v - est_pat_len;
			bline_i[0].sp_pos.h = sort_edge[3].h;
		} // else no
	} // if with pattern
} // fnp_case0






// first & no pattern case 1
void fnp_case1(void)
{
	int est_pat_len; // estimated pattern length. 외각 사각형의 변의길이.

	if(sort_edge[0].v == sort_edge[3].v &&
	   sort_edge[0].h == sort_edge[3].h) { // if same
		// 호 drawing

		// disable left circle.
		circle_i[0].en = 0;
		circle_i[0].update = 0;
		
		// set right circle information
		circle_i[1].en = 1;
		circle_i[1].update = 1;
		circle_i[1].ccase = circle_case;
		circle_i[1].st_pos.v = sort_edge[1].v;
		circle_i[1].st_pos.h = sort_edge[1].h;
		circle_i[1].ed_pos.v = sort_edge[2].v;
		circle_i[1].ed_pos.h = sort_edge[2].h;
		circle_i[1].r = circle_i[1].ed_pos.v - circle_i[1].st_pos.v;

		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = sort_edge[3].v; // 원점
		bline_i[0].st_pos.h = sort_edge[3].h; // 원점
		bline_i[0].ed_pos.v = sort_edge[2].v;
		bline_i[0].ed_pos.h = sort_edge[2].h;
		bline_i[0].dv = 1; // 수직선.
		bline_i[0].dh = 0;
		bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;

		// right beeline
		bline_i[1].en = 0;
		bline_i[1].update = 0;
	} // yes
	else { // no
		// 호가 아닐경우.
		// set left circle informations
		circle_i[0].en = 1;
		circle_i[0].update = 1;
		circle_i[0].ccase = circle_case;
		circle_i[0].st_pos.v = sort_edge[0].v;
		circle_i[0].st_pos.h = sort_edge[0].h;
		circle_i[0].ed_pos.v = sort_edge[3].v;
		circle_i[0].ed_pos.h = sort_edge[3].h;
		circle_i[0].r = circle_i[0].ed_pos.v - circle_i[0].st_pos.v;

		// set right circle information
		circle_i[1].en = 1;
		circle_i[1].update = 1;
		circle_i[1].ccase = circle_case;
		circle_i[1].st_pos.v = sort_edge[1].v;
		circle_i[1].st_pos.h = sort_edge[1].h;
		circle_i[1].ed_pos.v = sort_edge[2].v;
		circle_i[1].ed_pos.h = sort_edge[2].h;
		circle_i[1].r = circle_i[1].ed_pos.v - circle_i[1].st_pos.v;
		
		// left beeline
		bline_i[0].en = 0;
		bline_i[0].update = 0;

		// right beeline
		bline_i[1].en = 0;
		bline_i[1].update = 0;
	} // else no

	if(line_pattern != 0xffffffff) { // with pattern
		// line pattern length를 계산.
		est_pat_len = est_circle_len(line_len);
		
		if(est_pat_len >= circle_i[0].r) { // 수직선에 있을 경우.
			// right beeline
			bline_i[0].en = 1;
			bline_i[0].update = 1;
			bline_i[0].st_pos.v = sort_edge[1].v; // 원점
			bline_i[0].st_pos.h = sort_edge[2].h; // 원점
			bline_i[0].ed_pos.v = sort_edge[2].v + circle_i[0].r - est_pat_len;
			bline_i[0].ed_pos.h = sort_edge[1].h;
			bline_i[0].dv = 1; // 수직선.
			bline_i[0].dh = 0;
			bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
			bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
		} // 수직선에 있을 경우.
		else { // 수평선에 있을 경우.
			// right beeline
			bline_i[0].en = 1;
			bline_i[0].update = 1;
			bline_i[0].st_pos.v = sort_edge[1].v; // 원점
			bline_i[0].st_pos.h = sort_edge[2].h; // 원점
			bline_i[0].ed_pos.v = sort_edge[2].v;
			bline_i[0].ed_pos.h = sort_edge[2].h + est_pat_len;
			bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
			bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;
			bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
			bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
		} // 수평선에 있을 경우.
	} // if. with pattern
} // fnp_case1





// first & no pattern case 2
void fnp_case2(void)
{
	int est_pat_len; // estimated pattern length. 외각 사각형의 변의길이.

	if(sort_edge[0].v == sort_edge[3].v &&
	   sort_edge[0].h == sort_edge[3].h) { // if same
		// line width is 1
		// disable beelines
		bline_i[0].en = 0;
		bline_i[0].update = 0;
		bline_i[1].en = 0;
		bline_i[1].update = 0;

		// set left circle informations
		circle_i[0].en = 1;
		circle_i[0].update = 1;
		circle_i[0].ccase = circle_case;
		circle_i[0].st_pos.v = sort_edge[3].v;
		circle_i[0].st_pos.h = sort_edge[3].h;
		circle_i[0].ed_pos.v = sort_edge[2].v;
		circle_i[0].ed_pos.h = sort_edge[2].h;
		circle_i[0].r = circle_i[0].ed_pos.v - circle_i[0].st_pos.v;

		// set right circle information
		circle_i[1].en = 1;
		circle_i[1].update = 1;
		circle_i[1].ccase = circle_case;
		circle_i[1].st_pos.v = sort_edge[0].v;
		circle_i[1].st_pos.h = sort_edge[0].h;
		circle_i[1].ed_pos.v = sort_edge[1].v;
		circle_i[1].ed_pos.h = sort_edge[1].h;
		circle_i[1].r = circle_i[1].ed_pos.v - circle_i[1].st_pos.v;
	} // if same
	else { // else. not same
		// set left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = sort_edge[0].v;
		bline_i[0].st_pos.h = sort_edge[0].h;
		bline_i[0].ed_pos.v = sort_edge[3].v;
		bline_i[0].ed_pos.h = sort_edge[3].h;
		bline_i[0].dv = 1; // 수직선
		bline_i[0].dh = 0;
		bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;		
		
		// disable right beeline
		bline_i[1].en = 0;
		bline_i[1].update = 0;		

		// set left circle informations
		circle_i[0].en = 0;
		circle_i[0].update = 0;
		circle_i[0].ccase = circle_case;
		circle_i[0].st_pos.v = sort_edge[3].v;
		circle_i[0].st_pos.h = sort_edge[3].h;
		circle_i[0].ed_pos.v = sort_edge[2].v;
		circle_i[0].ed_pos.h = sort_edge[2].h;
		circle_i[0].r = circle_i[0].ed_pos.v - circle_i[0].st_pos.v;

		// set right circle information
		circle_i[1].en = 1;
		circle_i[1].update = 1;
		circle_i[1].ccase = circle_case;
		circle_i[1].st_pos.v = sort_edge[0].v;
		circle_i[1].st_pos.h = sort_edge[0].h;
		circle_i[1].ed_pos.v = sort_edge[1].v;
		circle_i[1].ed_pos.h = sort_edge[1].h;
		circle_i[1].r = circle_i[1].ed_pos.v - circle_i[1].st_pos.v;
	} // else. not same

	if(line_pattern != 0xffffffff) { // with pattern
		// line pattern length를 계산.
		est_pat_len = est_circle_len(line_len);

		// top edge와 같은 vertical line상에 있는지 검사.
		if(est_pat_len >= circle_i[1].r) { // yes
			// 수평선에 estimated point가 위치할 경우.
			// left beeline
			bline_i[0].en = 1;
			bline_i[0].update = 1;
			bline_i[0].st_pos.v = sort_edge[0].v;
			bline_i[0].st_pos.h = sort_edge[1].h + circle_i[1].r - est_pat_len;
			bline_i[0].ed_pos.v = sort_edge[1].v; // 원점
			bline_i[0].ed_pos.h = sort_edge[0].h; // 원점
			bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
			bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;
			bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
			bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
		} // if yes
		else { // no
			// 수직선에 estimated point가 위치할 경우.
			// left beeline
			bline_i[0].en = 1;
			bline_i[0].update = 1;
			bline_i[0].st_pos.v = sort_edge[0].v; // 원점의 대각 위치
			bline_i[0].st_pos.h = sort_edge[1].h; // 원점의 대각 위치
			bline_i[0].ed_pos.v = sort_edge[1].v; // 원점
			bline_i[0].ed_pos.h = sort_edge[0].h; // 원점
			bline_i[0].dv = 1; // 수직선.
			bline_i[0].dh = 0;
			bline_i[0].sp_pos.v = sort_edge[1].v - est_pat_len;
			bline_i[0].sp_pos.h = sort_edge[1].h;
		} // else no
	} // if with pattern
} // fnp_case2





// first & no pattern case 3
void fnp_case3(void)
{
	int est_pat_len; // estimated pattern length. 외각 사각형의 변의길이.

	if(sort_edge[1].v == sort_edge[2].v &&
	   sort_edge[1].h == sort_edge[2].h) { // if same
		// 호 drawing

		// disable left circle.
		circle_i[0].en = 0;
		circle_i[0].update = 0;
		circle_i[0].ccase = circle_case;
		circle_i[0].st_pos.v = sort_edge[0].v;
		circle_i[0].st_pos.h = sort_edge[0].h;
		circle_i[0].ed_pos.v = sort_edge[3].v;
		circle_i[0].ed_pos.h = sort_edge[3].h;
		circle_i[0].r = circle_i[0].ed_pos.v - circle_i[0].st_pos.v;
		
		// set right circle information
		circle_i[1].en = 0;
		circle_i[1].update = 0;

		// left beeline
		bline_i[0].en = 0;
		bline_i[0].update = 0;

		// Right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = sort_edge[2].v; // 원점
		bline_i[1].st_pos.h = sort_edge[2].h; // 원점
		bline_i[1].ed_pos.v = sort_edge[3].v;
		bline_i[1].ed_pos.h = sort_edge[3].h;
		bline_i[1].dv = 1; // 수직선.
		bline_i[1].dh = 0;
		bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
	} // yes
	else { // no
		// 호가 아닐경우.
		// set left circle informations
		circle_i[0].en = 1;
		circle_i[0].update = 1;
		circle_i[0].ccase = circle_case;
		circle_i[0].st_pos.v = sort_edge[0].v;
		circle_i[0].st_pos.h = sort_edge[0].h;
		circle_i[0].ed_pos.v = sort_edge[3].v;
		circle_i[0].ed_pos.h = sort_edge[3].h;
		circle_i[0].r = circle_i[0].ed_pos.v - circle_i[0].st_pos.v;

		// set right circle information
		circle_i[1].en = 1;
		circle_i[1].update = 1;
		circle_i[1].ccase = circle_case;
		circle_i[1].st_pos.v = sort_edge[1].v;
		circle_i[1].st_pos.h = sort_edge[1].h;
		circle_i[1].ed_pos.v = sort_edge[2].v;
		circle_i[1].ed_pos.h = sort_edge[2].h;
		circle_i[1].r = circle_i[1].ed_pos.v - circle_i[1].st_pos.v;
		
		// left beeline
		bline_i[0].en = 0;
		bline_i[0].update = 0;

		// right beeline
		bline_i[1].en = 0;
		bline_i[1].update = 0;
	} // else no

	if(line_pattern != 0xffffffff) { // with pattern
		// line pattern length를 계산.
		est_pat_len = est_circle_len(line_len);
		
		if(est_pat_len >= circle_i[1].r) { // 수직선에 있을 경우.
			// left beeline
			bline_i[1].en = 1;
			bline_i[1].update = 1;
			bline_i[1].st_pos.v = sort_edge[1].v; // 원점
			bline_i[1].st_pos.h = sort_edge[2].h; // 원점
			bline_i[1].ed_pos.v = sort_edge[3].v + circle_i[1].r - est_pat_len;
			bline_i[1].ed_pos.h = sort_edge[0].h;
			bline_i[1].dv = 1; // 수직선.
			bline_i[1].dh = 0;
			bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
			bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
		} // 수직선에 있을 경우.
		else { // 수평선에 있을 경우.
			// left beeline
			bline_i[1].en = 1;
			bline_i[1].update = 1;
			bline_i[1].st_pos.v = sort_edge[1].v; // 원점
			bline_i[1].st_pos.h = sort_edge[2].h; // 원점
			bline_i[1].ed_pos.v = sort_edge[3].v;
			bline_i[1].ed_pos.h = sort_edge[3].h - est_pat_len;
			bline_i[1].dv = bline_i[1].ed_pos.v - bline_i[1].st_pos.v;
			bline_i[1].dh = bline_i[1].ed_pos.h - bline_i[1].st_pos.h;
			bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
			bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
		} // 수평선에 있을 경우.
	} // if. with pattern
} // fnp_case3





//-------------------------------------------------------
// new area at a circle
void set_new_circle(void)
{
	switch(circle_case) {
	case 0 :
		snc_case0();
		break;
	case 1 :
		snc_case1();
		break;
	case 2 :
		snc_case2();
		break;
	case 3 :
		snc_case3();
		break;
	default : // error. unknown circle case
		printf("\n Error : unkown circle case at new circle area.");
	} // switch
} // set_new_circle





// new circle area drawing case 0
void snc_case0(void)
{
	int est_pat_len;
	int est_pat_len_v; // estimated pattern length pos

	// check line width 
	if(sort_edge[0].v == sort_edge[1].v &&
	   sort_edge[0].h == sort_edge[1].h) { // yes. width 1
		circle_i[0].en = 1;
		circle_i[1].en = 1;
	} // if. yes
	else { // no
		circle_i[0].en = 1;
		circle_i[1].en = 0;

		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = next_st_pos.st_pos.v;
		bline_i[1].st_pos.h = next_st_pos.st_pos.h;
		bline_i[1].ed_pos.v = next_st_pos.ed_pos.v; // 원점
		bline_i[1].ed_pos.h = next_st_pos.ed_pos.h; // 원점
		bline_i[1].dv = next_st_pos.dv;
		bline_i[1].dh = next_st_pos.dh;
		bline_i[1].sp_pos.v = pre_vpos; // 이전 drawing에서 right circle이 stopped position
		bline_i[1].sp_pos.h = beeline_pm[0].nposh; // 이전 drawing에서 left beeline의 stopped position
	} // else. no
	
	//  calc. vertical position of the estimated pattern point
	est_pat_len = est_circle_len(line_len);
	est_pat_len_v = sort_edge[3].v - est_pat_len;

	if(est_pat_len < circle_i[0].r &&
	   est_pat_len_v > now_vpos) { // yes
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = now_vpos;
		bline_i[0].st_pos.h = sort_edge[3].h;
		bline_i[0].ed_pos.v = sort_edge[3].v; // 원점
		bline_i[0].ed_pos.h = sort_edge[0].h; // 원점
		bline_i[0].dv = 1; // 수직선.
		bline_i[0].dh = 0;
		bline_i[0].sp_pos.v = est_pat_len_v;
		bline_i[0].sp_pos.h = sort_edge[3].h;
	} // if
	else { // no
		// left beeline
		// beeline을 현재 vertical line까지 진행했을 때의 값을 계산.
		// estimated pattern point가 수평선에 있을 경우와 수직선에 있을때를 구별하여 set
		if(est_pat_len < circle_i[0].r) { // 수직선에 있을 때
			bline_i[0].st_pos.v = est_pat_len_v;
			bline_i[0].st_pos.h = sort_edge[3].h;
		}
		else { // 수평선에 있을 때
			bline_i[0].st_pos.v = sort_edge[0].v;
			bline_i[0].st_pos.h = sort_edge[3].h - circle_i[0].r + est_pat_len;
		}
		// start position 이동.
		mv_start_pos(&bline_i[0], now_vpos - bline_i[0].st_pos.v);

		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].ed_pos.v = sort_edge[3].v; // 원점
		bline_i[0].ed_pos.h = sort_edge[0].h; // 원점
		bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
		bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;
		bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
	} // else
} // snc_case0




// new circle area drawing case 1
void snc_case1(void)
{
	int   est_pat_len;

	// check line width 
	if(sort_edge[0].v == sort_edge[1].v &&
	   sort_edge[0].h == sort_edge[1].h) { // yes. width 1
		circle_i[0].en = 1;
		circle_i[1].en = 1;
	} // if. yes
	else { // no
		circle_i[0].en = 1;
		circle_i[1].en = 0;
		
		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = next_st_pos.st_pos.v;
		bline_i[1].st_pos.h = next_st_pos.st_pos.h;
		bline_i[1].ed_pos.v = next_st_pos.ed_pos.v; // 원점
		bline_i[1].ed_pos.h = next_st_pos.ed_pos.h; // 원점
		bline_i[1].dv = next_st_pos.dv;
		bline_i[1].dh = next_st_pos.dh;
		bline_i[1].sp_pos.v = pre_vpos; // 이전 drawing에서 right circle이 stopped position
		bline_i[1].sp_pos.h = beeline_pm[0].nposh; // 이전 drawing에서 left beeline의 stopped position
	} // else. no
	
	// left beeline
	est_pat_len = est_circle_len(line_len);
	
	if(est_pat_len >= circle_i[1].r) { // 수직선에 있을 경우.
		// right beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = sort_edge[1].v; // 원점
		bline_i[0].st_pos.h = sort_edge[2].h; // 원점
		bline_i[0].ed_pos.v = sort_edge[2].v + circle_i[0].r - est_pat_len;
		bline_i[0].ed_pos.h = sort_edge[1].h;
		bline_i[0].dv = 1; // 수직선.
		bline_i[0].dh = 0;
		bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
	} // 수직선에 있을 경우.
	else { // 수평선에 있을 경우.
		// right beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = sort_edge[1].v; // 원점
		bline_i[0].st_pos.h = sort_edge[2].h; // 원점
		bline_i[0].ed_pos.v = sort_edge[2].v;
		bline_i[0].ed_pos.h = sort_edge[2].h + est_pat_len;
		bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
		bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;
		bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
		bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
	} // 수평선에 있을 경우.
	// start point 이동
	mv_start_pos(&bline_i[0], now_vpos - bline_i[0].st_pos.v);

} // snc_case1






// new circle area drawing case 2
void snc_case2(void)
{
	int est_pat_len;
	int est_pat_len_v; // estimated pattern length pos

	// check line width 
	if(sort_edge[0].v == sort_edge[3].v &&
	   sort_edge[0].h == sort_edge[3].h) { // yes. width 1
		circle_i[0].en = 1;
		circle_i[1].en = 1;
	} // if. yes
	else { // no
		circle_i[0].en = 0;
		circle_i[1].en = 1;

		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = next_st_pos.st_pos.v;
		bline_i[0].st_pos.h = next_st_pos.st_pos.h;
		bline_i[0].ed_pos.v = next_st_pos.ed_pos.v; // 원점
		bline_i[0].ed_pos.h = next_st_pos.ed_pos.h; // 원점
		bline_i[0].dv = next_st_pos.dv;
		bline_i[0].dh = next_st_pos.dh;
		bline_i[0].sp_pos.v = pre_vpos; // 이전 drawing에서 right circle이 stopped position
		bline_i[0].sp_pos.h = beeline_pm[1].nposh; // 이전 drawing에서 right beeline의 stopped position
	} // else. no
	
	//  calc. vertical position of the estimated pattern point
	est_pat_len = est_circle_len(line_len);
	est_pat_len_v = sort_edge[1].v - est_pat_len;

	if(est_pat_len < circle_i[1].r &&
	   est_pat_len_v > now_vpos) { // yes
		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = now_vpos;
		bline_i[1].st_pos.h = sort_edge[1].h;
		bline_i[1].ed_pos.v = sort_edge[1].v; // 원점
		bline_i[1].ed_pos.h = sort_edge[0].h; // 원점
		bline_i[1].dv = 1; // 수직선.
		bline_i[1].dh = 0;
		bline_i[1].sp_pos.v = est_pat_len_v;
		bline_i[1].sp_pos.h = sort_edge[1].h;
	} // if
	else { // no
		// right beeline
		// beeline을 현재 vertical line까지 진행했을 때의 값을 계산.
		// estimated pattern point가 수평선에 있을 경우와 수직선에 있을때를 구별하여 set
		if(est_pat_len < circle_i[1].r) { // 수직선에 있을 때
			bline_i[1].st_pos.v = est_pat_len_v;
			bline_i[1].st_pos.h = sort_edge[1].h;
		}
		else { // 수평선에 있을 때
			bline_i[1].st_pos.v = sort_edge[0].v;
			bline_i[1].st_pos.h = sort_edge[1].h + circle_i[1].r - est_pat_len;
		}
		// start position 이동.
		mv_start_pos(&bline_i[1], now_vpos - bline_i[1].st_pos.v);

		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].ed_pos.v = sort_edge[1].v; // 원점
		bline_i[1].ed_pos.h = sort_edge[0].h; // 원점
		bline_i[1].dv = bline_i[1].ed_pos.v - bline_i[1].st_pos.v;
		bline_i[1].dh = bline_i[1].ed_pos.h - bline_i[1].st_pos.h;
		bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
	} // else
} // snc_case2





// new circle area drawing case 3
void snc_case3(void)
{
	int   est_pat_len;

	// check line width 
	if(sort_edge[0].v == sort_edge[1].v &&
	   sort_edge[0].h == sort_edge[1].h) { // yes. width 1
		circle_i[0].en = 1;
		circle_i[1].en = 1;
	} // if. yes
	else { // no
		circle_i[0].en = 0;
		circle_i[1].en = 1;
		
		// left beeline
		bline_i[0].en = 1;
		bline_i[0].update = 1;
		bline_i[0].st_pos.v = next_st_pos.st_pos.v;
		bline_i[0].st_pos.h = next_st_pos.st_pos.h;
		bline_i[0].ed_pos.v = next_st_pos.ed_pos.v; // 원점
		bline_i[0].ed_pos.h = next_st_pos.ed_pos.h; // 원점
		bline_i[0].dv = next_st_pos.dv;
		bline_i[0].dh = next_st_pos.dh;
		bline_i[0].sp_pos.v = pre_vpos; // 이전 drawing에서 right circle이 stopped position
		bline_i[0].sp_pos.h = beeline_pm[1].nposh; // 이전 drawing에서 right beeline의 stopped position
	} // else. no
	
	// right beeline
	est_pat_len = est_circle_len(line_len);
	
	if(est_pat_len >= circle_i[1].r) { // 수직선에 있을 경우.
		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = sort_edge[1].v; // 원점
		bline_i[1].st_pos.h = sort_edge[2].h; // 원점
		bline_i[1].ed_pos.v = sort_edge[3].v + circle_i[1].r - est_pat_len;
		bline_i[1].ed_pos.h = sort_edge[0].h;
		bline_i[1].dv = 1; // 수직선.
		bline_i[1].dh = 0;
		bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
	} // 수직선에 있을 경우.
	else { // 수평선에 있을 경우.
		// right beeline
		bline_i[1].en = 1;
		bline_i[1].update = 1;
		bline_i[1].st_pos.v = sort_edge[1].v; // 원점
		bline_i[1].st_pos.h = sort_edge[2].h; // 원점
		bline_i[1].ed_pos.v = sort_edge[3].v;
		bline_i[1].ed_pos.h = sort_edge[3].h - est_pat_len;
		bline_i[1].dv = bline_i[1].ed_pos.v - bline_i[1].st_pos.v;
		bline_i[1].dh = bline_i[1].ed_pos.h - bline_i[1].st_pos.h;
		bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
		bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
	} // 수평선에 있을 경우.
	// start point 이동
	mv_start_pos(&bline_i[1], now_vpos - bline_i[1].st_pos.v);

} // snc_case3






// calc estimated circle length
int  est_circle_len(int len)
// len : circle length
// return : estimated circle length. 호의 외각 사각형에서의 변의 길이.
{
	int    est_len;

	est_len = 2 * 5 * len / 4;

	est_len = (est_len >> 1) + (est_len & 1); // rounding

	return est_len;
} // est_circle_len






//-----------------------------------------------------
// stop positioin을 기울기방향으로 이동.
void mv_stop_pos(bline_info *bline, int length)
// bline : 변경하려는 beeline의 구조체
// length : 이동할 pixel수
{
	float      less_d; // 기울기가 작은 쪽의 증가분.

	if(bline->dv > bline->dh) {
		bline->sp_pos.v += length;
		if(bline->dv == 0) {
			printf("\n ERROR : divider(dv) is zero.");
			exit(0);
		}
		less_d = length * bline->dh / bline->dv;
		less_d += 0.5; // rounding
		bline->sp_pos.h += (int)less_d;
	} // if
	else {
		bline->sp_pos.h += length;
		if(bline->dh == 0) {
			printf("\n ERROR : divider(dh) is zero.");
			exit(0);
		}
		less_d = length * bline->dv / bline->dh;
		less_d += 0.5; // rounding
		bline->sp_pos.v += (int)less_d;
	} // else
} // mv_stop_pos





// start positioin을 기울기방향으로 이동.
void mv_start_pos(bline_info *bline, int length)
// bline : 변경하려는 beeline의 구조체
// length : 이동할 pixel수
{
	float      less_d; // 기울기가 작은 쪽의 증가분.

	if(bline->dv > bline->dh) {
		bline->st_pos.v += length;
		if(bline->dv == 0) {
			printf("\n ERROR : divider(dv) is zero.");
			exit(0);
		}
		less_d = length * bline->dh / bline->dv;
		less_d += 0.5; // rounding
		bline->st_pos.h += (int)less_d;
	} // if
	else {
		bline->st_pos.h += length;
		if(bline->dh == 0) {
			printf("\n ERROR : divider(dh) is zero.");
			exit(0);
		}
		less_d = length * bline->dv / bline->dh;
		less_d += 0.5; // rounding
		bline->st_pos.v += (int)less_d;
	} // else
} // mv_start_pos





//=======================================================
// New line parameter set

// edge에 도착했을 경우
void set_bline_edge(int side, int edge_num)
// side : left/right
// edge_num : stopped edge number
{
	int    i;
	
	i = side &1;

	bline_i[i].en = 1;
	bline_i[i].update = 1;
	bline_i[i].st_pos.v = bline_i[i].sp_pos.v;
	bline_i[i].st_pos.h = bline_i[i].sp_pos.h;
	
	if(i == 0) { // left
		bline_i[i].ed_pos.v = sort_edge[edge_num-1].v;
		bline_i[i].ed_pos.h = sort_edge[edge_num-1].h;
	} // if
	else {
		bline_i[i].ed_pos.v = sort_edge[edge_num+1].v;
		bline_i[i].ed_pos.h = sort_edge[edge_num+1].h;
	} // else

	bline_i[i].sp_pos.v = bline_i[i].ed_pos.v;
	bline_i[i].sp_pos.h = bline_i[i].ed_pos.h;

	bline_i[i].dv = bline_i[i].ed_pos.v - bline_i[i].st_pos.v;	
	bline_i[i].dh = bline_i[i].ed_pos.h - bline_i[i].st_pos.h;	
} // set_bline_edge






//--------------------------------------------
void set_bline_pat(int side)
// side : left/right
{
	int    i;
	
	i = side &1;

	bline_i[i].en = 1;
	bline_i[i].update = 1;

	// slope inverse
	inv_slope(&bline_i[i].dv, &bline_i[i].dh);
	
	bline_i[i].st_pos.v = bline_i[i].sp_pos.v;
	bline_i[i].st_pos.h = bline_i[i].sp_pos.h;

	bline_i[i].sp_pos.v = bline_i[i].ed_pos.v;
	bline_i[i].sp_pos.h = bline_i[i].ed_pos.h;
} // set_bline_pat





//=======================================================
// inverse a slope
//    기울기의 역수를 만들어줌. dv는 항상 양수로.
//    부호는 반대로.
void   inv_slope(int *dv, int *dh)
// dv : delta vertical
// dh : delta horizontal
{
	int     tmp_d;

	tmp_d = *dv;
	if(*dh < 0) {
		*dv = 0- *dh;
		*dh = tmp_d;
	}
	else {
		*dv = *dh;
		*dh = 0 - tmp_d;
	}
} // inv_slope
