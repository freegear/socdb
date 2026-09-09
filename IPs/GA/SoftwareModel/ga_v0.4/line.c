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
#include "gbus.h"
#include "gpu.h"
#include "cmd_buff.h"
#include "hrange.h"

#include "line.h"





//------------------------------------------------------
// backup and restore beeline information

void mv_bline(bline_info *src_info, bline_info *dst_info)
// src_info : source data
// dst_info : destination structure
{
	memcpy(dst_info, src_info, sizeof(bline_info));
} // mv_bline







//----------------------------------------------------
// point sort
// 위 아래를 검사하여 윗 점을 첫번째 array에 넣음.
void sort_edges(void)
{
	int      top;
	int      i;
	
	top = 0;
	if(cmd_kind == LINEDRW) {
		if(dst_edge[0].v == dst_edge[1].v) {
			if(dst_edge[0].h < dst_edge[1].h) {
				top = 1;
			}
		} // if
		else if(dst_edge[0].v > dst_edge[1].v)
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
			else if(dst_edge[top].v > dst_edge[i].v) {
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








//-----------------------------------------------------------
//
//  v의 방향이 반대이므로 수식은 다음과 같이 수정된다.
//  H = cos * h + sin * v
//  V = -sin * h + cos * v
//  

void rotate_edge(pos px, int sin_int, int cos_int, pos *rs)
// px : pixel position. effetive width : 13bit
// sin_int : sin value. effective width :16bit , max 1 (all bit 1 without sign bit)
// cos_int : cos value. effective width :16bit , max 1 (all bit 1 without sign bit)
// rs : result position
{


	if(cos_int == 0x07fff) { // if 1,
		rs->h = px.h << 15;
		rs->v = px.v << 15;
	}
	else if(cos_int == 0xffffffff) { // if -1
		rs->h = 0 - (px.h<<15);
		rs->v = 0 - (px.v<<15);
	}
	else {
		rs->h = cos_int * px.h;
		rs->v = cos_int * px.v;
	}
	
	if(sin_int == 0x07fff) { // if 1
		rs->h = rs->h - (px.v << 15);
		rs->v = rs->v + (px.h << 15);
	}
	else if(sin_int = 0xffffffff) { // if -1
		rs->h = rs->h + (px.v << 15);
		rs->v = rs->v - (px.h << 15);
	}
	else {
		rs->h = rs->h - sin_int * px.v;
		rs->v = rs->v + sin_int * px.h;
	}
	
	rs->h = rs->h + 0x04000;
	rs->v = rs->v + 0x04000;
	
	rs->h = rs->h >> 15;
	rs->v = rs->v >> 15;
} // rotate_edge




// source picture의 외각 점을 일정 각도만큼 회전한 좌표를 계산.
void rotate_edges(pos base, pos src_size, int sin_int, int cos_int, 
				  pos *edges)
// base : base position
// src_size : source picture's size
// sin_int : sin value width :16bit , max 1 (all bit 1 without sign bit)
// cos_int : cos value width :16bit , max 1 (all bit 1 without sign bit)
// edges : result positions
{
	pos     dst;
	pos     px;

	// top right
	px.h = src_size.h;
	px.v = 0;
	rotate_edge(px, sin_int, cos_int, &dst);
	edges[1].h = base.h + dst.h;
	edges[1].v = base.v + dst.v;

	// bottom right
	px.h = src_size.h;
	px.v = src_size.v;
	rotate_edge(px, sin_int, cos_int, &dst);
	edges[2].h = base.h + dst.h;
	edges[2].v = base.v + dst.v;

	// bottom left
	px.h = 0;
	px.v = src_size.v;
	rotate_edge(px, sin_int, cos_int, &dst);
	edges[3].h = base.h + dst.h;
	edges[3].v = base.v + dst.v;
} // rotate_edges







//------------------------------------------------------------
// Search 4 edges
int search_edges(pos *dredges)
// dredges : drawing edges. drawing할 외각 경계를 나타내는 edge point.
// return  : SUCC/FAIL
{
	pos     tmp_pos[4];

	if(bline_circle == BEELINE)
		bl_edge(tmp_pos, dredges, (line_width - 1), edge_style);
	else 
		cl_edge(tmp_pos, dredges, (line_width - 1), circle_dir);
	
	memcpy(dredges, tmp_pos, 4*sizeof(pos));

	return SUCC;
} // search_edges






//-------------------------------------------------
// calc. simple bold line edge
//    start or end point에서 edge를 계산하기 위한 delta를 구하는 함수.
//    start point의 아래쪽 edge를 기준으로 delta계산.
//  2006.11.7 : dx == 0 인 경우 추가.
void sbbl_edge(int width, int dy, int dx, int estyle, 
			   int *deltax, int *deltay)
// width : line width. if 0, real line width is 1.  
// dy : line의 기울기.
// dx : line의 기울기.
// estyle : edge style. short type(0) or long type(1) 
// deltax : edge 까지의 delta x 
// deltay : edge 까지의 delta y
{
	// edge style에 따라 계산이 달라짐.
	float    m, n;
	int      w;

	w = width; 

	if(estyle == 0) { // short edge
		if(dx == 0) n = 0;
		else {
			//n = w*(1+(1/sqrt(2)-1)*(dy/dx));
			n = w*(1-(0.29289*(dy/dx)));
		} // else

		if(n == 0) m = w; // -0을 방지.
		else       m = -(dy/dx)*n;
	} // if
	else { // long edge
		if(w == 0) m = 0; // -0을 방지.
		else {
			if(dx == 0) m = w;
			else m = - (w * (1 + (sqrt(2) - 1)*(dy/dx)));
		} // else

		if( dx == 0) n = w;
		n = (1-(dy/dx)) * w;
	} // else
	
	*deltax = (int)(m + 0.5); // rounding.
	*deltay = (int)(n + 0.5); // rounding.

} // sbbl_edge







//------------------------------------------------
// calc. 4 edges of a line
//   beeline과 circle의 최각 edge point를 계산.

//   beeline의 외각을 구성하는 edge를 구성.
void bl_edge(pos *le_pos, pos *l_pos, int width, int estyle)
// le_pos : line edge position
// l_pos : line positioin
// width : line width
// estyle : edge style
{
	int      dx, dy; // 기울기.
	int      up_edx, up_edy; // edge delta x, y
	int      dn_edx, dn_edy; // edge delta x, y
	int      hwidth;

	dx = l_pos[1].h - l_pos[0].h;
	dy = l_pos[1].v - l_pos[0].v;

#ifdef   __DEBUG__
	printf("\n line slope : h=%d, v=%d",dx,dy);
#endif //  __DEBUG__


	// width는 16으로 제한.
	hwidth = width % 16;
	hwidth = hwidth >> 1;

	if(width == 0) {
		if(dy == 0) { // 수평선
			le_pos[0].h = l_pos[0].h;
			le_pos[0].v = l_pos[0].v;
			
			le_pos[1].h = l_pos[1].h;
			le_pos[1].v = l_pos[1].v;
			
			le_pos[2].h = l_pos[1].h;
			le_pos[2].v = l_pos[1].v;
			
			le_pos[3].h = l_pos[0].h;
			le_pos[3].v = l_pos[0].v;
		}// if
		else { // others
			le_pos[0].h = l_pos[0].h;
			le_pos[0].v = l_pos[0].v;
			
			le_pos[1].h = l_pos[0].h;
			le_pos[1].v = l_pos[0].v;
			
			le_pos[2].h = l_pos[1].h;
			le_pos[2].v = l_pos[1].v;
			
			le_pos[3].h = l_pos[1].h;
			le_pos[3].v = l_pos[1].v;
		} // else

	} // width 1
	else { // bold line
		sbbl_edge(hwidth, dy, dx, estyle, &dn_edx, &dn_edy);
		
		hwidth += (width & 1); // upper쪽으로는 나머지 width 1을 더함.
		
		sbbl_edge(hwidth, dy, dx, estyle, &up_edx, &up_edy);
		
		// dy는 항상 양수.
		if(dx > 0) {
			le_pos[0].h = l_pos[0].h + up_edx;
			le_pos[0].v = l_pos[0].v + up_edy;
			
			le_pos[1].h = l_pos[1].h + up_edx;
			le_pos[1].v = l_pos[1].v + up_edy;
			
			le_pos[2].h = l_pos[1].h - dn_edx;
			le_pos[2].v = l_pos[1].v - dn_edy;
			
			le_pos[3].h = l_pos[0].h - dn_edx;
			le_pos[3].v = l_pos[0].v - dn_edy;
		} // if
		else {
			le_pos[0].h = l_pos[0].h + up_edx;
			le_pos[0].v = l_pos[0].v + up_edy;
			
			le_pos[1].h = l_pos[0].h - dn_edx;
			le_pos[1].v = l_pos[0].v - dn_edy;
			
			le_pos[2].h = l_pos[1].h - dn_edx;
			le_pos[2].v = l_pos[1].v - dn_edy;
			
			le_pos[3].h = l_pos[1].h + up_edx;
			le_pos[3].v = l_pos[1].v + up_edy;
		} // else
	} // else bold line

} // bl_edge






// circle의 외각 edge좌표를 생성.
void cl_edge(pos *le_pos, pos *l_pos, int width, int ccase)
// le_pos : line edge position
// l_pos : line positioin
// width : line width
// ccase : circle direction case
{
	// 첫번째와 네번째가 왼쪽 호를 구성하고, 두번째와 세번째가 오른쪽 호를 구성한다.
	//1.	case 0
	//   시작점의 위, 시작점의 아래, 끝점의 오른쪽, 끝점의 왼쪽 순으로 배열된다.
	//2.	case 1
	//   시작점의 왼쪽, 시작점의 오른쪽, 끝점의 아래, 끝점의 위 순으로 배열된다.
	//3.	case 2
	//   시작점의 아래, 시작점의 위, 끝점의 오른쪽, 끝점의 왼쪽 순으로 배열된다.
	//4.	case 3
	//   시작점의 왼쪽, 시작점의 오른쪽, 끝점의 위, 끝점의 아래 순으로 배열된다.

	switch( ccase ) {
	case 0 :
		le_pos[0].h = l_pos[0].h;
		le_pos[0].v = l_pos[0].v - width;

		le_pos[1].h = l_pos[0].h;
		le_pos[1].v = l_pos[0].v + width;

		le_pos[2].h = l_pos[1].h + width;
		le_pos[2].v = l_pos[1].v;

		le_pos[3].h = l_pos[1].h - width;
		le_pos[3].v = l_pos[1].v;
		break;
	case 1 :
		le_pos[0].h = l_pos[0].h - width;
		le_pos[0].v = l_pos[0].v;

		le_pos[1].h = l_pos[0].h + width;
		le_pos[1].v = l_pos[0].v;

		le_pos[2].h = l_pos[1].h;
		le_pos[2].v = l_pos[1].v + width;

		le_pos[3].h = l_pos[1].h;
		le_pos[3].v = l_pos[1].v - width;
		break;
	case 2 :
		le_pos[0].h = l_pos[0].h;
		le_pos[0].v = l_pos[0].v + width;

		le_pos[1].h = l_pos[0].h;
		le_pos[1].v = l_pos[0].v - width;

		le_pos[2].h = l_pos[1].h + width;
		le_pos[2].v = l_pos[1].v;

		le_pos[3].h = l_pos[1].h - width;
		le_pos[3].v = l_pos[1].v;
		break;
	case 3 :
		le_pos[0].h = l_pos[0].h - width;
		le_pos[0].v = l_pos[0].v;

		le_pos[1].h = l_pos[0].h + width;
		le_pos[1].v = l_pos[0].v;

		le_pos[2].h = l_pos[1].h;
		le_pos[2].v = l_pos[1].v - width;

		le_pos[3].h = l_pos[1].h;
		le_pos[3].v = l_pos[1].v + width;
		break;
	default:
		printf("\n ERROR : Invalid circle case");
		exit(0);
	}
} // cl_edge






//----------------------------------------------
// circle case 결정.
int gen_ccase(pos *edges, int cdir)
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






//===================================================
// beeline의 line길이 계산.
//   line edge style도 고려.
void set_bline_len(void)
{
	if(bline_sslop == 1 || bline_dh == 0) { // slope minus or 수직선.
		bline_dv = sort_edge[3].v - sort_edge[0].v;
		bline_dh = sort_edge[0].h - sort_edge[3].h;
	}
	else { // 수평선 or slope plus
		bline_dv = sort_edge[1].v - sort_edge[0].v;
		bline_dh = sort_edge[1].h - sort_edge[0].h;
	}
	bline_dv = abs(bline_dv);
	bline_dh = abs(bline_dh);

	if(bline_dv > bline_dh)
		line_len = bline_dv;
	else line_len = bline_dh;
} // set_bline_len






//------------------------------------
// beeline의 line길이 계산.
//   line edge style도 고려.
void set_circle_len(void)
{
	int    r;

	switch( circle_case ) {
	case 0 :
		r = sort_edge[0].h - sort_edge[3].h;
		break;
	case 1 :
		r = sort_edge[2].h - sort_edge[1].h;
		break;
	case 2 :
		r = sort_edge[1].h - sort_edge[0].h;
		break;
	default :
		r = sort_edge[3].h - sort_edge[0].h;
		break;
	}
	line_len = 8 * r * 2 / 5; // include float 1bit
	line_len = (line_len >> 1) + (line_len & 1); // rounding
} // set_circle_len






//###########################################################
// Pattern 처리.

//---------------------------------------------
// line pattern을 뒤집는 함수.
int reverse_pat(int lpat)
// lpat : original line pattern
// return : reversed line pattern
{
	uint    pat_tmp;
	int     i;

	pat_tmp = 0;
	
	for(i=0;i<32;i++) pat_tmp = (pat_tmp<<1) | ((lpat>>i)&1);

	return pat_tmp;
} // reverse_pat







//-----------------------------------------------------
// line Pattern의 시작 위치 보정.
//   long edge line에 대한 보정,
//   line을 뒤에서부터 그릴때,
//   등을 보정.
//	 rest pattern length가 line length보다 클때도 고려.
void line_pat_corr(void)
{
	//int     line_len_dh;
	//int     line_len_dv;
	int     line_len_t; // total line length. edge stype이나 circle포함.
	int     edge_len;
	int     r;

	int     org_len; // 본래 시작점과 끝점까지의 길이.
	int     pat_num; // pattern bit number

	int     new_pat_pos;

	// line width에 의한 line 외각이 모두 계산된 상태.
	line_len_t = line_len; // 이미 계산되어 있다.

	// 본 line의 길이.
	org_len = (bline_dv > bline_dh)? bline_dv : bline_dh;
	
	// long edge style 일때 start position 보정 
	if(edge_style == 1) { // long
		// 원래 line과 drawing line과의 실제 길이차를 계산.
		edge_len = line_len_t - org_len;
		edge_len >>= 1; // divide by 2
		
		rest_pat_px += edge_len;
		rest_pat_px %= line_width;

		pat_num = (rest_pat_px / line_width);
		pat_num += (rest_pat_px == 0)? 0 : 1;
		pat_num %= 32; // 일정한 길이 내로 제한.

		lpat_pos -= pat_num;
		pat_attr = line_pat_for >> lpat_pos;
	} // if
	
	if(rest_pat_px >= line_len_t) { // 남은 pattern의 길이가 line의 길이보다 길때.
		// 다음 line을 위한 rest pattern length를 설정.
		// drawing결정은 new area parameter setup block에서 결정.
		rest_pat_bk = rest_pat_px - org_len;
		pat_attr_bk = pat_attr;
		lpat_pos_bk = lpat_pos;

		rest_pat_px = line_len_t;
	} // if
	else {

		//--------------------------------------------
		// pattern position 재계산.
		// 3가지 parameter를 설정.
		if(se_exc == 0) {  // forward일 경우에는
			org_len -= rest_pat_px;
			rest_pat_bk %= line_width;   // 1
			
			lpat_pos_bk /= line_width; // pixel 수.
			lpat_pos_bk = lpat_pos + lpat_pos_bk;
			lpat_pos_bk &= 0x01f;
			
			pat_attr_bk = (line_pattern >> lpat_pos_bk) & 1;  // 2
			
			pat_attr_bk += (rest_pat_bk == 0)? 0 : 1; // 경계를 넘어가면 1 증가.
			lpat_pos_bk &= 0x01f;   // 3
		} // if forward
		else {  // At reverse drawing
			// line pattern은 이미 좌우대칭 완료.
			
			// for next line
			new_pat_pos = 32 - lpat_pos;
			line_len_t -= rest_pat_px;
			pat_num = (line_len_t / line_width) + 1;
			new_pat_pos += pat_num;
			
			rest_pat_px = line_len_t % line_width;
			lpat_pos = 32 - ((new_pat_pos) & 0x01f); // reverse pattern을 사용해야 하므로 32에서 뺀다.
			pat_attr = 1 & ( line_pat_for >> ((new_pat_pos+1) & 0x01f) );
			
			// for now line
			if(rest_pat_px == 0) {
				rest_pat_bk = 0;
				lpat_pos_bk = (new_pat_pos+1) & 0x01f;
			}
			else {
				rest_pat_bk = line_width - rest_pat_px;
				lpat_pos_bk = (new_pat_pos+2) & 0x01f;
			}
			pat_attr_bk = pat_attr;
		} // at reverse
	} // else 
		
} // line_pat_corr







//------------------------------------------------------------
// calculate pattern length.
// Hardware로 만들어야 함.
// 시작 bit가 1이면 1의 개수를, 0이면 0의 개수를 센다.
// 1이나 0, 한가지만 세는 block을 만들고, 필요에 따라 pattern을 inverse
// 한 뒤에 bit를 센다.

int calc_ptn_len(uint lpat, int *lpos)
// lpat : line pattern
// lpos : line position.
// return : counted number. 1~32
{
	uint    pat_tmp;
	uint    bit_tmp;
	int     bit_cnt;
	int     i;

	// pattern rotate
	// LSB를 MSB로 rotate
	pat_tmp = lpat;
	
	for(i=0;i<*lpos;i++) {
		bit_tmp = pat_tmp & 1;
		bit_tmp = (bit_tmp<<31) & 0x80000000;
		pat_tmp = (pat_tmp >> 1) & 0x7fffffff;
		pat_tmp |= bit_tmp;
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
