/*************************************************************************

   Line Parameter

   file name : line.c
   created by gtlee
   data : 2006.7.24
   note :
          
   history :

************************************************************************/


#ifndef    __LINE__
#define    __LINE__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#incluce "gbus.h"
#include "cmd_buff.h"


//---------------------------------------------------
// claculate memory size of a horizontal line
int calc_hsize(int ctype, int maxx)
// ctype : color type
// maxx : Maximum horizontal width
// retern : aligned byte count
{
	int        byte;

	// calc bytes
	switch(ctype) {
	case MONO :
		byte = maxx/8;
		if(maxx % 8) byte ++; // 여분의 bit가 있으면 byte수 하나 증가.
		break;
	case C8BPP :
		byte = maxx;
		break;
	case C16BPP :
	case CA16BPP :
		byte = maxx * 2;
		break;
	case C24BPP :
		byte = maxx * 3;
		break;
	case C32BPP :
	case CA32BPP :
		byte = maxx * 4;
		break;
	default :
		printf("\n ERROR : invalie color type %x at calc_hsize.", ctype);
		exit(0);
	} // switch
	
	// alignment
	if((byte % 4) != 0) byte = (byte & ~0x03) + 4;

	//
	return byte;
} // calc_hsize


// point sort
// 위 아래를 검사하여 윗 점을 첫번째 array에 넣음.
void sort_edges(void)
{
	int      top;
	int      i;
	
	top = 0;
	if(cmd_kind == LINEDRW) {
		if(dst_edge[0].v == dst_edge[1].v) {
			if(dst_edge[0].h > dst_edge[1].h) {
				top = 1;
			}
		} // if
		else if(dst_edge[0].v < dst_edge[1].v)
			top = 1;
		
		if(top == 0) {
			//sort_edge[0] = dst_edge[0];
			//sort_edge[1] = dst_edge[1];
			memcpy(&sort_edge[0], &dst_edge[0], sizeof(pos));
			memcpy(&sort_edge[1], &dst_edge[1], sizeof(pos));
			se_exc = 0;
		}
		else {
			//sort_edge[0] = dst_edge[1];
			//sort_edge[1] = dst_edge[0];
			memcpy(&sort_edge[0], &dst_edge[1], sizeof(pos));
			memcpy(&sort_edge[1], &dst_edge[0], sizeof(pos));
			se_exc = 1;
		}
	} // if
	else { // others
		for(i=1;i<4;i++) {
			if(dst_edge[top].v == dst_edge[i].v) {
				if(dst_edge[top].h > dst_edge[i].h)
					top = i;
			}// if
			else if(dst_edge[top].v < dst_edge[i].v) {
				top = i;
			}
		} // for

		// source position copy
		for(i=0;i<4;i++) {
			memcpy(&sort_edge[i], &src_edge[0x3&(i+top)], sizeof(pos));
		}
		for(i=0;i<4;i++) {
			memcpy(&src_edge[i], &sort_edge[i], sizeof(pos));
		}
		// destination position copy
		for(i=0;i<4;i++) {
			memcpy(&sort_edge[i], &dst_edge[0x3&(i+top)], sizeof(pos));
		}
		if(top == 0) se_exc = 0;
		else 		 se_exc = 1;
	} // else 
} // sort_edges


//------------------------------------------------------------
// Search 4 edges
int search_edges(pos *dredges)
// dredges : drawing edges. drawing할 외각 경계를 나타내는 edge point.
// return  : SUCC/FAIL
{
	pos     tmp_pos[4];

	if(beel_circle == BEELINE)
		bl_edge(tmp_pos, dredge, line_width, edge_style);
	else 
		c_edge(tmp_pos, dredge, line_width, circle_dir);
	
	memcpy(dredge, tmp_edge, 4*sizeof(pos));

	return SUCC;
} // search_edges

//=================================================================
// Pattern 처리.

// line pattern position의 보정.
// line drawing을 시작 하기 전에 수행.
// end point부터 drawing할때, line pattern을 미리 계산하여 뒤에서 부터
// drawing을 수행하기 위해 pattern position을 조정한다.

void line_pat_pos(int *pat_pos, int now_num, int exc, pos *ppos, int width)
// now_num : now line number. line 번호.
// pat_pos : line pattern position
// exc : exchange line start/stop position
// ppos : line start/end pixel point structure. [0] : start, [1] : end
// width : line width. 0 : width 1.
{
	// line_len is 0, length is 1 : 동일점일 경우에는 길이는 1
	int     line_len_v;
	int     line_len_h;
	int     line_len;

	int     line_pixel; // line의 pixel개수.

	if(now_num == 0) 
		*pat_pos = 0;
	else {
		*pat_pos --; // 두번째 이후의 line의 시작위치는 이전 line의 마지막 pixel
 		             // 이므로 보정이 필요.
		// line길이 계산.
		if(exc != 0) {
			line_len_v = ppos[1].v - ppos[0].v;
			if(ppos[0].h > ppos[1].h)
				line_len_h = ppos[0].h - ppos[1].h;
			else line_len_h = ppos[1].h - ppos[0].h;
			
			if(line_len_v >= line_len_h) line_len = line_len_v;
			else line_len = line_len_h;
		}
		
		// pixel개수 계산.
		line_pixel = line_len/width;

		line_pixel += (line_len%width > (width/2))? 1 : 0; // rounding
		
		*pat_pos += line_pixel;
		*pat_pos %= 32; // 32는 다시 0으로 되돌림.
 
		// end point부터 drawing할 경우 pattern position을 중앙을 대칭으로 뒤바꿈.
		// pattern 자체를 좌우로 뒤집는 것은 다른 곳에서 수행.
		if(exc != 0) *pat_pos = 31 - *pat_pos;
	}
} // line_pat_pos



//------------------------------------------------------------
// calculate pattern length
// se_exc가 1이면, pattern을 좌우로 뒤집고, position도 대칭이동한 뒤에
// bit count를 수행한다.
// 시작 bit가 1이면 1의 개수를, 0이면 0의 개수를 센다.
// 1이나 0, 한가지만 세는 block을 만들고, 필요에 따라 pattern을 inverse
// 한 뒤에 bit를 센다.

int calc_ptn_len(uint lpat, int *lpos, int exc)
// lpat : line pattern
// lpos : line position. s/e exchange에 의한 보정(31-pos)은 완료된 값.
// exc : start/end position exchange
// return : counted number. 1~32
{
	uint    pat_tmp;
	uint    bit_tmp;
	int     bit_cnt;
	int     i;

	// 좌우 대칭 번환
	if(exc) {
		pat_tmp = 0;
		
		for(i=0;i<32;i++) pat_tmp = (pat_tmp<<1) | ((lpat>>i)&1);
	}
	
	// pattern rotate
	i=0;
	while(i < *lpos) {
		bit_tmp = pat_tmp & 1;
		bit_tmp = (it_tmp<<31) & 0x80000000;
		pat_tmp = (pat_tmp >> 1) & 0x7fffffff;
		pat_tmp |= bit_tmp;
		i++;
	}

	// bit inverse
	if((pat_tmp & 1) == 0) pat_tmp = ~pat_tmp;

	// count value 1
	for(bit_cnt=1;bit_cnt<32;bit_cnt++) {
		if( ((pat_tmp>>bit_cnt)&1) == 0 ) break;
	}

	*lpos += bit_cnt;  // pattern position 보정.

	return  bit_cnt;
} // clac_ptn_len



//--------------------------------------------------------------
// line pattern에 의한 다음 line 변경점.

int next_vpoint(pos spos, int dh, int dv, uint lpat, int *lpos, 
				int exc, int lwidth,
				int *hpoint, int *hfg, int *vpoint, int *vfg)
// spos : start vertical position
// dh : line의 horizontal 증가량
// dv : line의 vertical 증가량
// lpat : line pattern
// lpos : position at the line pattern
// exc : start/end position exchange
// lwidth : line width
// hpoint : horizontal position for store
// hfg : check flag of the horizontal. sign of (now position - vpoint)
// vpoint : vertical position for store
// vfg : check flag of the vertical. sign of (now position - hpoint)
// return : SUCC/FAIL
{
	int      pat_len; // length of a line pattern
	int      ppat; // previous pattern. 1bit
	
	// pattern count
	pat_len =  calc_ptn_len(lpat, lpos, exc);
	
	// 실제 pixel의 길이로 변환.
	pat_len *= lwidth; // always plus

	// 기울기의 case별로 적절할 처리를 수행.
	if(dv == 0) { // 수평선.
		*vpoint = spos.v;
		*vfg = 0;
		*hpoint = spos.h + pat_len;
		*hfg = 0;
	}
	else if(dh == 0) { // 수직선.
		*vpoint = spos.v + pat_len;
		*vfg = 0;
		*hpoint = spos.h; // 두개의 수직 line모두 항상 범위내로 되도록.
		*hfg = 1;
	}
	else if(dh > 0 && dv > 0) { // 왼쪽에서 오른쪽으로 drawing
		if(dv > dh) { // virtical이 더 많이 증가.
			*vpoint = spos.v + pat_len;
			*vfg = 0;
			*hpoint = spos.h + (int)((float)(pat_len * dh) / dv + 0.5); // 0.5 : rounding
			*hfg = 0;
		}
		else { // horizontal이 더 많이 증가.
			*vpoint = spos.v + (int)((float)(pat_len * dv) / dh + 0.5); // 0.5 : rounding
			*vfg = 0;
			*hpoint = spos.h + pat_len;
			*hfg = 0;
		}
	}
	else { // 오른쪽에서 왼쪽으로 drawing
		if(dv > abs(dh)) { // virtical이 더 많이 증가.
			*vpoint = spos.v + pat_len;
			*vfg = 0;
			*hpoint = spos.h + (int)((float)(pat_len * dh) / dv + 0.5); // 0.5 : rounding
			*hfg = 1;
		}
		else { // horizontal이 더 많이 증가.
			*vpoint = spos.v + (int)((float)(pat_len * dv) / abs(dh) + 0.5); // 0.5 : rounding
			*vfg = 0;
			*hpoint = spos.h + pat_len;
			*hfg = 1;
		}
		
	}
	return SUCC;
}


//----------------------------------------------
// circle case 결정.
int gen_ccase(pos edges, int cdir)
// edges : line start/end point
// cdir : circle direction
// return : circle case
{
	int     hcmp;
	int     ccase;

	hcmp = edges[1].h - edges[0].h;

	if(hcmp < 0 ) { // end point 가 오른쪽에.
		if(cdir == 0) ccase = 0;
		else          ccase = 1;
	}
	else {
		if(cdir == 0) ccase = 2;
		else          ccase = 3;
	}
	return ccase;
}




//----------------------------------------------
// drawing 영역결정.

// Generate Line estimation information, no pattern
// if no Line drawing, or No pattern line

int gen_le_info(bline_info *bline, cicle_info *circle, pos *edge, 
				int s_vpos, int ltype, int sslop, int ccase, int lpat,
				int *lppos, int exc, int lwidth, int cmd_kind_now)
// bline : beeline destination information
// circle : circle destination information
// edge : drawing area
// s_vpos : start vertical position
// ltype : line type. circle/beeline. bline_circle
// sslop : signe of a beeline slope. bline_sslop
// ccase : circle case. 0 ~ 3
// lpat : line pattern
// lppos : line pattern position
// lexc : start/end attern exchange
// lwidth : line width
// cmd_kind_now : command kind
// return : SUCC/FAIL
{
	int     i;
	int     lpat_en;
	int     llen; // line pattern length

	// line pattern 유효 체크.
	if(cmd_kind_now == LINEDRW && lpat != 0xffffffff)
		lpat_en = 1;
	else lpat_en = 0;


	//check the start position from a top position
	if(s_vpos == edge[0].v) {

		llen = calc_ptn_len( lpat, lppos, exc);
		llen *= lwidth;

		if(ltype == 0) { // beeline
			bline_top(bline, edge, lpat_en, llen, sslop);
		} // if beeline
		else { // circle
			circle_top(circle, edge, lpat_en, llen, ccase );
		} // else circle
	} // if top position
	else { // others
		// Beeline check
		for(i=0;i<2;) {
			if(bline[i].epos.v != s_vpos || bline[i].en == 0) {
				i ++;
				continue;
			}
			// if matched


			

			i++;
		} // for. beeline

		// circle check
		for(i=0;i<2;) {
			if(circle[i].epos.v != s_vpos || circle[i].en == 0) {
				i ++;
				continue;
			}
			// if matched


			

			i++;
		} // for. beeline


	} // else others

} // gen_le_info

//-----------------------------------------------
// top point부터 시작할때 beeline estimation parameter를 결정하는 함수.
void bline_top(bline_info *bline, pos *edge, int lpat_en, 
			   int llen, int sslop )
// bline : beeline destination information
// edge : drawing area
// lpat_en : line pattern enable/disable
// lwidth : line width
// sslop : sign of a beeline slop
{
	int     edge_sp, edge_ep;
	int     slen;  // 변화량이 작은 축의 증감량.

	// left line estimation information
	if(edge[0].v == edge[3].v && edge[0].h == edge[3].h) // if triangle.
		edge_sp = 3;
	else edge_sp = 0;
	edge_ep = (edge_sp - 1) & 0x03;
	bline[0].en = 1;
	bline[0].spos.v = edge[edge_sp].v;
	bline[0].spos.h = edge[edge_sp].h;
	bline[0].dv = edge[edge_ep].v - edge[edge_sp].v;
	bline[0].dh = edge[edge_ep].h - edge[edge_sp].h;
	bline[0].evorh = 1; // check the vertical
	

	if(lpat_en == 1 &&
	   ((bline[0].dh >= 0 && sslop >= 0) || (bline[0].dh < 0 && sslop < 0))
		) { // active line pattern
		if(bline[0].dh > bline[0].dv) {
			slen = (int)((float)llen * (float)bline[0].dv / (float)bline[0].dh + 0.5);
			bline[0].epos.v = edge[edge_sp].v + abs(slen);
			bline[0].epos.h = edge[edge_sp].h + abs(llen);
		} // if
		else {
			slen = (int)((float)llen * (float)bline[0].dh / (float)bline[0].dv + 0.5);
			bline[0].epos.v = edge[edge_sp].v + abs(llen);
			bline[0].epos.h = edge[edge_sp].h + abs(slen);
		} // else
	} // if
	else { // no line pattern
		bline[0].epos.v = edge[edge_ep].v;
		bline[0].epos.h = edge[edge_ep].h;
	}// else 


	// right line estimation information
	if(edge[0].v == edge[1].v) // if triangle.
		edge_sp = 1;
	else edge_sp = 0;
	edge_ep = (edge_sp + 1) & 0x03;
	bline[1].en = 1;
	bline[1].spos.v = edge[edge_sp].v;
	bline[1].spos.h = edge[edge_sp].h;
	bline[1].dv = edge[edge_ep].v - edge[edge_sp].v;
	bline[1].dh = edge[edge_ep].h - edge[edge_sp].h;
	bline[1].evorh = 1; // check the vertical

	if(lpat_en == 1 &&
	   ((bline[1].dh >= 0 && sslop >= 0) || (bline[1].dh < 0 && sslop < 0))
		) { // active line pattern
		if(bline[1].dh > bline[0].dv) {
			slen = (int)((float)llen * (float)bline[1].dv / (float)bline[1].dh + 0.5);
			bline[1].epos.v = edge[edge_sp].v + abs(slen);
			bline[1].epos.h = edge[edge_sp].h + abs(llen);
		} // if
		else {
			slen = (int)((float)llen * (float)bline[1].dh / (float)bline[1].dv + 0.5);
			bline[1].epos.v = edge[edge_sp].v + abs(llen);
			bline[1].epos.h = edge[edge_sp].h + abs(slen);
		} // else
	} // if
	else { // no line pattern
		bline[1].epos.v = edge[edge_ep].v;
		bline[1].epos.h = edge[edge_ep].h;
	}// else 

}

//-----------------------------------------------
// top point부터 시작할때 circle estimation parameter를 결정하는 함수.

void circle_top(circle_info *circle, pos *edge, int lpat_en, 
			   int llen, int ccase )
// circle : beeline destination information
// edge : drawing area
// lpat_en : line pattern enable/disable
// lwidth : line width
// sslop : sign of a beeline slop
{
	int     clen_estm;
	pos     bline_pat; // pattern에 의한 beeline
	pos     ccenter; // circle center. 원점.

	clen_estm = (int)((float)llen * CIRCLE_LEN_ESTM + 0.5);

	// if case 0 or 2, circle 1, beeline 1
	// others, only circle enable
	if(ccase == 0 ) { // case 0
		//            __
		//          --
		//         /
		//        /
		//       /
		//      |
		//      |

		// 원점의 좌표
		ccenter.v = edge[3].v;
		ccenter.h = edge[0].h;

		circle[0].en = 1;
		circle[0].spos.v = edge[0].v;
		circle[0].spos.h = edge[0].h;
		circle[0].r = edge[3].v - edge[0].v;
		
		if(edge[0].v == edge[1].v) { // line width is 1
			circle[1].en = 1;
			circle[1].spos.v = circle[0].spos.v;
			circle[1].spos.h = circle[0].spos.h;
			circle[1].r = circle[0].r;

			bline[1].en = 0;
		} // if line width is 1
		else { // line width is not 1
			circle[1].en = 0;

			bline[1].en = 1;
			bline[1].spos.v = edge[0].v;
			bline[1].spos.h = edge[0].h;
			bline[1].dv = 1; // 수직선
			bline[1].dh = 0;
			bline[1].epos.v = edge[1].v;
			bline[1].epos.h = edge[1].h;
			bline[1].evorh = 1; // check the vertical
		} // else. line width is not 1

		// line pattern에 의한 beeline
		if(lpat_en == 1) {  // active line pattern
			if(clen_estm <= circle[0].r) {
				bline_pat.v = edge[0].v;
				bline_pat.h = edge[0].h - clen_estm;
				
				bline[0].en = 1;
				bline[0].spos.v = bline_pat.v;
				bline[0].spos.h = bline_pat.h;
				bline[0].dv = ccenter.v - bline[0].spos.v; 
				bline[0].dh = ccenter.h - bline[0].spos.h;
				bline[0].epos.v = ccenter.v;
				bline[0].epos.h = ccenter.h;
				bline[0].evorh = 1;
			} // if
			else {
				bline_pat.v = edge[0].v + clen_estm - circle[0].r;
				bline_pat.h = edge[0].h - circle[0].r;

				bline[0].en = 1;
				bline[0].spos.v = edge[3].v;
				bline[0].spos.h = edge[0].h;
				bline[0].dv = 1; // 수직선.
				bline[0].dh = 0;
				bline[0].epos.v = bline_pat.v;
				bline[0].epos.h = bline_pat.h;
				bline[0].evorh = 1; // check the vertical
			} // else
		} // if
		else { // no pattern
			bline[0].en = 0;
		}
	} // if
	else if(ccase == 2) { // case 2
		// __
		//   --       
		//	   \
		//		\
		//		 \
		//        |
		//        |
		
		// 원점의 좌표.
		ccenter.v = edge[1].v;
		ccenter.h = edge[0].h;

		circle[1].en = 1;
		circle[1].spos.v = edge[0].v;
		circle[1].spos.h = edge[0].h;
		circle[1].r = edge[1].v - edge[0].v;

		if(edge[0].v == edge[3].v) { // line width is 1
			circle[0].en = 1;
			circle[0].spos.v = circle[1].spos.v;
			circle[0].spos.h = circle[1].spos.h;
			circle[0].r = circle[1].r;

			bline[0].en = 0;
		} // if line width is 1
		else { // line width is not 1
			circle[0].en = 0;
			
			bline[0].en = 1;
			bline[0].spos.v = edge[0].v;
			bline[0].spos.h = edge[0].h;
			bline[0].dv = 1; // 수직선
			bline[0].dh = 0;
			bline[0].epos.v = edge[3].v;
			bline[0].epos.h = edge[3].h;
			bline[0].evorh = 1; // check the vertical
		} // else. line width is not 1.

		// Line pattern에 의한 beeline
		if(lpat_en == 1) { // active line pattern
			if(clen_estm <= circle[1].r) {
				bline_pat.v = edge[0].v;
				bline_pat.h = edge[0].h + clen_estm;
				
				bline[1].en = 1;
				bline[1].spos.v = bline_pat.v;
				bline[1].spos.h = bline_pat.h;
				bline[1].dv = ccenter.v - bline[1].spos.v; 
				bline[1].dh = ccenter.h - bline[1].spos.h;
				bline[1].epos.v = ccenter.v;
				bline[1].epos.h = ccenter.h;
				bline[1].evorh = 1;
			} // if
			else {
				bline_pat.v = edge[0].v + clen_estm - circle[0].r;
				bline_pat.h = edge[0].h - circle[0].r;

				bline[1].en = 1;
				bline[1].spos.v = edge[0].v;
				bline[1].spos.h = edge[1].h;
				bline[1].dv = 1; // 수직선.
				bline[1].dh = 0;
				bline[1].epos.v = bline_pat.v;
				bline[1].epos.h = bline_pat.h;
				bline[1].evorh = 1; // check the vertical
			} // else
		} // if
		else {  // no pattern
			bline[1].en = 0;
		} // else

	} // else if
	else { // case 1 or 3
		ccenter.v = edge[0].v;
		ccenter.h = edge[3].h;
		
		circle[0].en = 1;
		circle[0].spos.h = edge[0].h;
		circle[0].spos.v = edge[0].v;
		circle[0].r = edge[3].v - edge[0].v;

		circle[1].en = 1;
		circle[1].spos.h = edge[1].h;
		circle[1].spos.v = edge[1].v;
		circle[1].r = edge[2].v - edge[1].v;
		
		// line pattern에 의한 beeline
		if(lpat_en == 1) {  // active line pattern
			if(ccase == 1) {
				if(clen_estm <= circle[0].r) {
					bline_pat.v = ccenter.v + clen_estm;
					bline_pat.h = ccenter.h + circle[0].r;
				} // if
				else {
					bline_pat.v = ccenter.v + circle[0].r;
					//bline_pat.h = ccenter.h + circle[0].r - (clen_estm - circle[0].r);
					bline_pat.h = ccenter.h + (2*circle[0].r) - clen_estm;
				} // else
				
				bline[0].en = 1;
				bline[0].spos.v = ccenter.v;
				bline[0].spos.h = ccenter.h;
				bline[0].dv = bline_pat.v - ccenter.v; 
				bline[0].dh = bline_pat.h - ccenter.h;
				bline[0].epos.v = bline_pat.v;
				bline[0].epos.h = bline_pat.h;
				bline[0].evorh = 1;

				bline[1].en = 0;
			} // if ccase 1
			else { // ccase 3
				if(clen_estm <= circle[0].r) {
					bline_pat.v = ccenter.v + clen_estm;
					bline_pat.h = ccenter.h - circle[0].r;
				} // if
				else {
					bline_pat.v = ccenter.v + circle[0].r;
					//bline_pat.h = ccenter.h - circle[0].r + clen_estm - circle[0].r;
					bline_pat.h = ccenter.h - (2*circle[0].r) + clen_estm;
				} // else
				
				bline[1].en = 1;
				bline[1].spos.v = ccenter.v;
				bline[1].spos.h = ccenter.h;
				bline[1].dv = bline_pat.v - ccenter.v; 
				bline[1].dh = bline_pat.h - ccenter.h;
				bline[1].epos.v = bline_pat.v;
				bline[1].epos.h = bline_pat.h;
				bline[1].evorh = 1;

				bline[0].en = 0;
			} // else ccase 3
		} // if 
		else {
			bline[0].en = 0;
			bline[1].en = 0;
		}
	} // else 
	

	if(circle[0].en == 1)	circle[0].ccase = ccase;
	if(circle[1].en == 1)	circle[1].ccase = ccase;

}

//------------------------------------------------------
// beeline 의 다음 line information 등록.
// 8/1


/***************************************************************
// old function. 미완성.
int gen_le_info_np(bline_info *bline, cicle_info *circle, pos *edge, 
				   int s_vpos, int ltype, int ccase, 
				   int lwidth, int cmd_kind_now)
// bline : beeline destination information
// circle : circle destination information
// edge : drawing area
// s_vpos : start vertical position
// ltype : line type. circle/beeline
// ccase : circle case. 0 ~ 3
// lwidth : line width
// cmd_kind_now : command kind
// return : SUCC/FAIL
{
	int    in_area;
	int    i, j;
	int    edge_sp, edge_ep;
	int    edge_p;

	// drawing 영역내인지 check
	for(in_area=0;in_area<4;in_area++) {
		if(edge[in_area].v >= (s_vpos+1)) break;
	}
	if(in_area >= 4) return FAIL; // out of range

	// vertical position이 일치하는 edge를 검색.
	for(in_area=0;in_area<4;in_area++) {
		if(edge[in_area].v == s_vpos) break;
	}

	if(in_area >= 4) return FAIL; // no matched edge
	
	//
	if(ltype == LINEDRW && lwidth == 0) {
		// line width가 1 pixel인 beeline
		for(i=0;i<4;i++) {
			if(edge[i].v == s_vpos) {
				//bline[0].en = 1;
				//bline[0].spos.v = 




			}
		} // for
		
	} // if Line width is 1 pixel.
	else { // normal command
		if(ltype == 0) { // beeline
			if(edge[0].v == s_vpos) { // top edge. start drawing area
				// left line estimation information
				if(edge[0].v == edge[3].v && edge[0].h == edge[3].h) // if triangle.
					edge_sp = 3;
				else edge_sp = 0;
				edge_ep = (edge_sp - 1) & 0x03;
				bline[0].en = 1;
				bline[0].spos.v = edge[edge_sp].v;
				bline[0].spos.h = edge[edge_sp].h;
				bline[0].dh = edge[edge_ep].h - edge[edge_sp].h;
				bline[0].dv = edge[edge_ep].v - edge[edge_sp].v;
				bline[0].epos.v = edge[edge_ep].v;
				bline[0].epos.h = edge[edge_ep].h;
				bline[0].evorh = 1; // check the vertical
				
				// right line estimation information
				if(edge[0].v == edge[1].v) // if triangle.
					edge_sp = 1;
				else edge_sp = 0;
				edge_ep = (edge_sp + 1) & 0x03;
				bline[1].en = 1;
				bline[1].spos.v = edge[edge_sp].v;
				bline[1].spos.h = edge[edge_sp].h;
				bline[1].dh = edge[edge_ep].h - edge[edge_sp].h;
				bline[1].dv = edge[edge_ep].v - edge[edge_sp].v;
				bline[1].epos.v = edge[edge_ep].v;
				bline[1].epos.h = edge[edge_ep].h;
				bline[1].evorh = 1; // check the vertical
			}// if top
			else { // other edge
				for(i=1;i<4;i++) {
					// vertical position이 일치하는 edge 검색.
					if(edge[i].v == s_vpos) {
						for(j=0;j<2;j++) { // left and right 순차적으로.
							if(bline[j].en == 1 && bline[j].evorh == 0 && 
							   ((bline[j].epos.h == edge[i].h && bline[j].evorh == 0) || // compare horizontal
								(bline[j].epos.v == edge[i].v && bline[j].evorh == 1)) // compare vertical
								) {
								edge_sp = i;
								if(j == 0)  // left line
									edge_ep = (i + 1) & 0x03;
								else        // right line
									edge_ep = (i - 1) & 0x03;

								bline[j].spos.v = edge[i].v;
								bline[j].spos.h = edge[i].h;
								bline[j].dh = edge[edge_ep].h - edge[edge_sp].h;
								bline[j].dv = edge[edge_ep].v - edge[edge_sp].v;
								bline[j].epos.v = edge[edge_ep].v;
								bline[j].epos.h = edge[edge_ep].h;
								bline[j].evorh = 1; // check the vertical
								
							} // if match beeline estimation
						} // for j
					} // if matched
				} // for
			} // else 
		} // if beeline
		else { // circle
			if(s_vpos == edge[0].v) { // top edge. start drawing
				// if case 0 or 2, circle 1, beeline 1
				// others, only circle enable
				if(ccase == 0 ) { // case 0
					//            __
					//          --
					//         /
					//        /
					//       /
					//      |
					//      |
					circle[0].en = 1;
					circle[0].spos.h = edge[0].h;
					circle[0].spos.v = edge[0].v;
					circle[0].r = edge[3].v - edge[0].v;
					circle[0].ccase = ccase;
					
					circle[1].en = 0;

					bline[0].en = 0;
				
					bline[1].en = 1;
					bline[1].spos.v = edge[0].v;
					bline[1].spos.h = edge[0].h;
					bline[1].dh = 0;
					bline[1].dv = edge[1].v - edge[0].v;
					bline[1].epos.v = edge[1].v;
					bline[1].epos.h = edge[1].h;
					bline[1].evorh = 1; // check the vertical
				} // if
				else if(ccase == 2) { // case 2
					// __
					//   --       
					//     \
					//      \
					//       \
					//        |
					//        |
					circle[0].en = 0;

					circle[1].en = 1;
					circle[1].spos.h = edge[0].h;
					circle[1].spos.v = edge[0].v;
					circle[1].r = edge[1].v - edge[0].v;
					circle[1].ccase = ccase;
					
					bline[0].en = 1;
					bline[0].spos.v = edge[0].v;
					bline[0].spos.h = edge[0].h;
					bline[0].dh = 0;
					bline[0].dv = edge[3].v - edge[0].v;
					bline[0].epos.v = edge[3].v;
					bline[0].epos.h = edge[3].h;
					bline[0].evorh = 1; // check the vertical

					bline[1].en = 0;
				} // else if
				else { // case 1 or 3
					circle[0].en = 1;
					circle[0].spos.h = edge[0].h;
					circle[0].spos.v = edge[0].v;
					circle[0].r = edge[3].v - edge[0].v;
					circle[0].ccase = ccase;

					circle[1].en = 1;
					circle[1].spos.h = edge[1].h;
					circle[1].spos.v = edge[1].v;
					circle[1].r = edge[2].v - edge[1].v;
					circle[1].ccase = ccase;

					bline[0].en = 0;
					bline[1].en = 0;
				} // else 
			} // if top edge
			else { // other edge
				// search match edge
				for(i=1;i<4;i++) {
					if(s_vpos == edge[0].v) break;
				}
				if(i >= 4) return FAIL;
						
						
				swtich(ccase) {
				case 0 :
					
					break;
				case 1 :
					break;
				case 2 :
					break;
				case 3 :
					break;
				default :
					printf("\n Error : wrong circle case.");
					return FAIL;
				} // switch
				
			}// else other edge

		}// else circle
	} // else

} // gen_le_info_np
*****************************************************************/


/*
// 시작 영역의 pattern이 active인지 inactive인지 체크.
// non-drawing 영역이면, drawing영역까지 pointer를 이동.
// drawing영역의 line 기울기 변경점을 계산.
int dcs_drw_area(int svpos, int dh, int dv, uint lpat, int *lpos, 
				int exc, int lwidth,
				int *hpoint, int *hfg, int *vpoint, int *vfg)
// svpos : start vertical position
// dh : line의 horizontal 증가량
// dv : line의 vertical 증가량
// lpat : line pattern
// lpos : position at the line pattern
// exc : start/end position exchange
// lwidth : line width
// hpoint : horizontal position for store
// hfg : check flag of the horizontal
// vpoint : vertical position for store
// vfg : check flag of the vertical
// return : SUCC/FAIL
{
	int    draw_st_pos_color;
	int    same_pat_len; // same pattern length
	
	// get start pixel pattern
	if(exc == 0) // normal
		draw_st_pos_color = (lpat>>(*lpos)) & 1;
	else draw_st_pos_color = (lpat>>(31-(*lpos))) & 1;
	
	// not drawing area
	if(draw_st_pos_color == 0) {
		// 동일한 pattern값의 길이.
		same_pat_len = calc_ptn_len(lpat, lpos, exc);
		

	}

	//---------------------------
	// drawing area

	// 동일한 pattern값의 길이.
	same_pat_len = clac_ptn_len(lpat, lpos, exc);


}
*/
