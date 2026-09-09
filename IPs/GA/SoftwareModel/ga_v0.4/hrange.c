/*************************************************************************

   Calculation the horizontal range

   file name : hrange.c
   created by gtlee
   data : 2006.7.4

   note :
      calc. horizontal range.

   history :

************************************************************************/

#define __DEBUG__


#ifndef    __HRANGE__
#define    __HRANGE__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "gbus.h"
#include "gpu.h"

#include "hrange.h"


bl_param   beeline_pm[2]; // left : 0    right : 1
cl_param   circle_pm[2];

//bl_param   beeline_bk[4]; // backup beeline parameter
//   beeline info.의 position에 fraction을 포함하면 param는 
//   backup할 필요 없음.







// backup beeline estimation parameter

void mv_bl_param(bl_param *dst, bl_param *src)
// dst : destination structure
// src : source structure
{

	memcpy(dst, src, sizeof(bl_param));

} // mv_bl_param









//------------------------------------------------------------
// line length에 의한 경계 검사 함수 - No used.
// beeline과 circle은 별도의 algorithm으로 동작.
// beeline의 length L 떨어진 pixel의 horizontal position

int bleng_posx(int st_posx, int l, int dx, int dy)
// st_posx : start horizontal position
// l : line length
// dx : line 기울기.
// dy : line 기울기.
{
	float      offx; // offset

	offx = l * (1 - (0.293 * (dy /dx)));

	return (int)offx;
	
} // bleng_posx








//---------------------------------------------------
int calc_delta(int sp, int ep)
// sp : start position
// ep : end position
// return : 변화량
{
	int delta;
	
	delta = ep - sp + 1;
	
	return delta;
} // calc_delta









//--------------------------------------------------
// 기울기 계산.
int calc_slope(int dh, int dv)
// dh : horizontal 변화량
// dv : vertical 변화량
// return : beeline slope
{
	int      slope;

	slope = dh / dv;

	if((dh % dv) != 0) slope ++;

	return     slope;
} // calc_slope








//-------------------------------------------
// Line estimation 전처리기
//  anti-aliasing에 의해서 beeline 4개로 확장.
//  circle에서 beeline 사용.

int pre_hrange(bline_info *src_bl, circle_info *src_cl,
			   bl_param *dst_bl, cl_param *dst_cl, int anti_alias)
// src_bl : beeline information.
// src_cl : circle information.
// dst_bl : beeline estimation parameter. 2개.
// dst_cl : circle estimation parameter. 2개.
// anti_alias : anti-aliasing en/disable.
// return : SUCC/FAIL
{
	int     i;

	// beeline 
	for(i=0;i<2;i++) {
		pre_bl(&src_bl[i], &dst_bl[i], anti_alias, i);
	}

	
	// circle
	for(i=0;i<2;i++) {
		pre_cl(&src_cl[i], &dst_cl[i], anti_alias, i);
	}
	
	return SUCC;
} // pre_hrange









// estimation parameter prepare
int pre_bl(bline_info *src_bl, bl_param *dst_bl, int anti_alias, int side)
// src_bl : beeline information. 1개.
// dst_bl : beeline estimation parameter. 2개.
// anti_alias : anti-aliasing en/disable.
// side : left(0) or right(1) line
// return : SUCC/FAIL
{
	// bl_param[0] : main
	// bl_param[1] : sub
	int       anti_alias_en;
	int       slope;

	if(anti_alias == 0 || src_bl->dh == 0 || src_bl->dv == 0)
		// 수직, 수평선이면 anti-aliasing 사용 안 함.
		anti_alias_en = 0;
	else anti_alias_en = 1;
	
	if(src_bl->dh > src_bl->dv) {

		if(side == LEFT_SIDE) {
			if(src_bl->dh >= 0) { // slope plus
				dst_bl[0].en = src_bl->en;
				dst_bl[0].dv = src_bl->dv;
				dst_bl[0].dh = src_bl->dh;
				dst_bl[0].slope = calc_slope((dst_bl[0].dh<<8), dst_bl[0].dv);  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
				
				/*
				dst_bl[1].dv = src_bl->dv;
				dst_bl[1].dh = src_bl->dh;
				dst_bl[1].slope = dst_bl[0].slope;  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
				*/
				if(anti_alias_en == 0) {
					dst_bl[0].st_posh = src_bl->st_pos.h << 8;
					//dst_bl[1].en = 0;
				} // if no anti-aliasing
				else {
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) - (dst_bl[0].slope>>2);
					
					//dst_bl[1].en = src_bl->en;
					//dst_bl[1].st_posh = (src_bl->st_pos.h<<8) + (dst_bl[0].slope>>2);
				} // else. anti-aliasing
			} // if
			else { // slop minus
				dst_bl[0].en = src_bl->en;
				dst_bl[0].dv = src_bl->dv;
				dst_bl[0].dh = src_bl->dh;
				dst_bl[0].slope = calc_slope((dst_bl[0].dh<<8), dst_bl[0].dv);  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
				/*
				dst_bl[1].dv = src_bl->dv;
				dst_bl[1].dh = src_bl->dh;
				dst_bl[1].slope = dst_bl[0].slope;  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
				*/
				if(anti_alias_en == 0) {
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) - dst_bl[0].slope + (1<<8);
					//dst_bl[1].en = 0;
				} // if no anti-aliasing
				else {
					//dst_bl[0].st_posh = (src_bl->st_pos.h<<8) - dst_bl[0].slope + (dst_bl[0].slope>>2) + (1<<8);
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) - (dst_bl[0].slope>>2) + (1<<8);
					
					//dst_bl[1].en = src_bl->en;
					//dst_bl[1].st_posh = (src_bl->st_pos.h<<8) - dst_bl[0].slope - (dst_bl[0].slope>>2) + (1<<8);
				} // else. anti-aliasing
			}// else
		} // if left
		else { // RIGHT_SIDE
			if(src_bl->dh >= 0) { // slope plus
				dst_bl[0].en = src_bl->en;
				dst_bl[0].dv = src_bl->dv;
				dst_bl[0].dh = src_bl->dh;
				dst_bl[0].slope = calc_slope((dst_bl[0].dh<<8), dst_bl[0].dv);  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
				/*
				dst_bl[1].dv = src_bl->dv;
				dst_bl[1].dh = src_bl->dh;
				dst_bl[1].slope = dst_bl[0].slope;  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
				*/
				if(anti_alias_en == 0) {
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) + dst_bl[0].slope - (1<<8);
					//dst_bl[1].en = 0;
				} // if no anti-aliasing
				else {
					//dst_bl[0].st_posh = (src_bl->st_pos.h<<8) + dst_bl[0].slope - (dst_bl[0].slope>>2) - (1<<7);
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) + (dst_bl[0].slope>>2) - (1<<7);
					
					//dst_bl[1].en = src_bl->en;
					//dst_bl[1].st_posh = (src_bl->st_pos.h<<8) + dst_bl[0].slope + (dst_bl[0].slope>>2) - (1<<7);
				} // else. anti-aliasing
			} // if
			else { // slop minus
				dst_bl[0].en = src_bl->en;
				dst_bl[0].dv = src_bl->dv;
				dst_bl[0].dh = src_bl->dh;
				dst_bl[0].slope = calc_slope((dst_bl[0].dh<<8), dst_bl[0].dv);  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
				/*
				dst_bl[1].dv = src_bl->dv;
				dst_bl[1].dh = src_bl->dh;
				dst_bl[1].slope = dst_bl[0].slope;  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
				*/
				if(anti_alias_en == 0) {
					dst_bl[0].st_posh = src_bl->st_pos.h << 8;
					//dst_bl[1].en = 0;
				} // if no anti-aliasing
				else {  // anti-aliasing
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) + (dst_bl[0].slope>>2) + (1<<7);
					
					//dst_bl[1].en = src_bl->en;
					//dst_bl[1].st_posh = (src_bl->st_pos.h<<8) - (dst_bl[0].slope>>2) + (1<<7);
				} // else. anti-aliasing
			} // else. slop minus
		} // else right
	}// if dh > dv
	else { //  dh <= dv
		//if(anti_alias_en == 0) {
			dst_bl[0].en = src_bl->en;
			dst_bl[0].dv = src_bl->dv;
			dst_bl[0].dh = src_bl->dh;
			dst_bl[0].slope = calc_slope((dst_bl[0].dh<<8), dst_bl[0].dv);  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
			dst_bl[0].st_posh = src_bl->st_pos.h << 8;			

			//dst_bl[1].en = 0;
			//}  // if no anti-aliasing
		/*
		else {  // anti-aliasing
			// 좌표 보정용 기울기 계산.
			slope = calc_slope((dst_bl[0].dv<<8), dst_bl[0].dh);
			
			dst_bl[0].en = src_bl->en;
			dst_bl[0].dv = src_bl->dv;
			dst_bl[0].dh = src_bl->dh;
			dst_bl[0].slope = calc_slope((dst_bl[0].dh<<8), dst_bl[0].dv);  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
			
			dst_bl[1].en = src_bl->en;
			dst_bl[1].dv = src_bl->dv;
			dst_bl[1].dh = src_bl->dh;
			dst_bl[1].slope = calc_slope((dst_bl[0].dh<<8), dst_bl[0].dv);  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
			if(side == LEFT_SIDE) {
				if(src_bl->dv >= 0) { // slope plus
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) - (slope>>2);
					//dst_bl[1].st_posh = (src_bl->st_pos.h<<8) - (slope>>2) + (1<<7);
				} // if
				else { // slop minus
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) + (slope>>2);
					//dst_bl[1].st_posh = (src_bl->st_pos.h<<8) + (slope>>2) - (1<<7);
				} // else. slop minus
			} // if left
			else { // RIGHT_SIDE
				if(src_bl->dv >= 0) { // slope plus
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) - (slope>>2) + (1<<7);
					//dst_bl[1].st_posh = (src_bl->st_pos.h<<8) - (slope>>2) + (1<<8);
				} // if
				else { // slop minus
					dst_bl[0].st_posh = (src_bl->st_pos.h<<8) + (slope>>2) + (1<<7);
					//dst_bl[1].st_posh = (src_bl->st_pos.h<<8) + (slope>>2);
				} // else. slop minus
			} // else. right
		} // else.  anti-aliasing
		*/
	} // else dh <= dv

	dst_bl[0].pposh = dst_bl[0].st_posh;
	dst_bl[0].nposh = dst_bl[0].st_posh;


	return SUCC;
} // pre_bl






//------------------------------------------------------------
// estimation parameter prepare

int pre_cl(circle_info *src_cl, cl_param *dst_cl, int anti_alias, int side)
// src_cl : circle information. 1개.
// dst_cl : circle estimation parameter. 1개.
// anti_alias : anti-aliasing en/disable.
// side : left(0) or right(1) line
// return : SUCC/FAIL
{
	// cl_param : only 1. anti-aliasing mode일 경우에는 r을 2배로.
	
	dst_cl->en = src_cl->en;
	dst_cl->st_posh = src_cl->st_pos.h<<8;
	dst_cl->ccase = src_cl->ccase;

	if(anti_alias == 0)
		dst_cl->r = src_cl->r;
	else 
		dst_cl->r = src_cl->r << 1;
	
	dst_cl->pposh = dst_cl->st_posh;
	dst_cl->nposh = dst_cl->st_posh;

	return SUCC;
} // pre_cl







//-------------------------------------------
// Line estimation
void est_hrange(bl_param *dst_bl, cl_param *dst_cl, int bl_new, int cl_new)
// dst_bl : beeline estimation parameter. 2개.
// dst_cl : circle estimation parameter. 2개.
// bl_new : beeline first estimation
// cl_new : circle first estimation
{
	int     i;

	// beeline 
	for(i=0;i<2;i++) {
		next_bline(bl_new, &dst_bl[i]);
	} // for

	circle_est(cl_new, dst_cl);
	
} // est_hrange






//---------------------------------------------------
// Next Beeline estimation
// 동작 조건
//     slope >= 1
//     horizontal and vertical 모두 증가하는 방향으로 진행.
//     --> line은 왼쪽 위에서 오른쪽 아래로 진행.
//     그외의 조건은 축에 대하여 대칭이동으로 계산.
// 동일한 block이 4개 존재하여 anti-aliasing mode 까지 동시에 연산가능.

void next_bline(int new, bl_param *bl_est)
// new : new line or next line.
// bl_est : beeline estimation parameter
//       st_posh : horizontal start position with fraction 8bit.
//       dh, dv, st_posh는 new일 경우만 적용.
//       nposh : new horizontal position at n.low. 정수+소수1자리. no anti-aliasing시 사용.
//               return position의 LSB는 2^-1이다.
{
	int    delta;
	int    next;

	if(new) { // initialize
		
		bl_est->pposh = bl_est->st_posh;
		//bl_est->slope = calc_slope((bl_est->dh<<8), bl_est->dv);  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.
		bl_est->cnt   = 1;

		delta = bl_est->slope - 1;

		next = bl_est->pposh + delta;
	} // if new
	else { // claculate a next position
		bl_est->pposh = bl_est->nposh;

		if(bl_est->cnt >= 128) { // reset 
			delta = calc_slope(((bl_est->dh<<8)*128), bl_est->dv);
			next = bl_est->st_posh + delta;
			
			bl_est->st_posh = next;
			
			next = bl_est->st_posh;
		} // if
		else { // normal
			next = bl_est->pposh + bl_est->slope;
		}
		
		bl_est->cnt ++;
	}

	bl_est->pposh = bl_est->nposh;
	bl_est->nposh = next;
} // next_bline






//---------------------------------------------------
// Next circle estimation


//---------------------------------------------------
// estimated circle

int circle_est(int new, cl_param *circle)
// circle : circle estimated parameter
// hrange : the destination horizontal range
// return
{
	int      i, j;
	int      ccase;
	int      watchdx; // watch delta x
	int      watchdy; // watch delta y
	int      predx;   // previous delata x
	int      predy;   // previous delata y
	int      loop;

	int      predh;   // previous delta for horizontal delta
	int      deltah;  // delta for horizontal

	
	for(i=0;i<2;i++) {                 // left, right
		
		ccase = circle[i].ccase;
		
		if( new == 1 ) {
			// circle estimation.
			next_circle(1, &circle[i]);
		} // if
		
		// 기준 저장.
		watchdx = circle[i].deltax;
		watchdy = circle[i].deltay;
		
		//-------------------------------------------------
		// START.  Generate predh, deltah
		// circle next position estimation
		if(watchdx < circle[i].r) {
			// circle estimation을 수행.
			for(loop=0;loop<=4096;loop++) {  // 기준 좌표가 변할때까지
				// delata x, y를 backup
				predx = circle[i].deltax;
				predy = circle[i].deltay;
				
				// circle estimation.
				next_circle(0, &circle[i]);
				
				if(ccase == 0 || ccase == 2) {
					if(watchdy != circle[i].deltay) {
						break;
					} // if
				} // if
				else {
					if(watchdx != circle[i].deltax) {
						break;
					} // if
				} // else
			} // for loop
			watchdx = circle[i].deltax;
			
			
			// delta selection
			// horizontal and vertical
			if(ccase == 0 || ccase == 2) {
				predh = predy;
				deltah = circle[i].deltax;				
			} // if
			else {
				predh = predx;
				deltah = circle[i].deltay;
			} // else
			
			// horizontal line의 시작과 끝으로 보정.
			predh += 1;
			deltah -= 1;

		} //  if. watchx < r
		else {
			// watchx >= r
			// End circle next position estimation
			// offset이 r이 되는 경우
			
			// delta selection
			// horizontal and vertical
			if(ccase == 0 || ccase == 2) predh = predy;
			else   predh = predx;
			
			deltah = circle[i].r;				
			
			// horizontal line의 시작과 끝으로 보정.
			predh += 1;
		} // else. watchx >= r
		//----------------------------
		
		// sign of horizontal delta
		//   v가 증가할때 h가 감소하게 될 경우 delta의 부호를 음수로 바꾼다.
		if(ccase == 0 || ccase == 1) {
			predh *= -1;
			deltah *= -1;
		}
		
		// END.  Generate predh, deltah
		//-------------------------------------------------
		
		
		//-------------------------------
		// Normal
		// 조건에 따라 predx, predy, deltax, deltay를 선택 사용한다.
		// 조건은 left/right, ccase,
		
		circle[i].pposh = circle[i].nposh;
		
		// horizontal 좌표 계산.
		if( (i == LEFT_SIDE && (ccase == 2 || ccase == 3)) ||  // LEFT SIDE
			(i != LEFT_SIDE && (ccase == 0 || ccase == 1)) ) { // LEFT SIDE
			// set to start position
			circle[i].nposh = circle[i].st_posh + (predh<<8);
		} // if ccase 1, 2. end set to start position
		else { // set to end position
			circle[i].nposh = circle[i].st_posh + (deltah<<8);
		} // else. end set to end position
		//------------------------------------
	} // for i
} // circle_est








//--------------------
// next basic position
//   같은 block이 2개존재. 
//   anti-aliasing mode일 경우에는 총 4번 동작.
//   anti-aliasing mode일때에는 모두 LSB는 소수 첫번째자리.

void next_circle(int new, cl_param *cl_est)
// new : new line or next line.
// cl_param : circle estimation parameter
{

	if( new ) { // initialize
		cl_est->deltax = 0;
		cl_est->dx = 0;
		cl_est->x2m1 = -1;
		cl_est->deltay = cl_est->r;
		cl_est->d = 0 - cl_est->r;

		cl_est->pposh = cl_est->st_posh;
//		cl_est->pposh5 = cl_est->st_posh;
		cl_est->nposh = cl_est->st_posh;
//		cl_est->nposh5 = cl_est->st_posh;
	}// if
	else { // normal
		if(cl_est->dx < (int)((float)cl_est->r*sqrt(2))) { // 0 ~ 45도.
			cl_est->deltax ++;
			cl_est->dx ++;

			cl_est->x2m1 += 2;
			cl_est->d += cl_est->x2m1;
			if(cl_est->d >= 0) {
				cl_est->deltay --;
				cl_est->d -= (cl_est->deltay<<1);
			}
		} // if
		else { // 45 ~ 90도.
			cl_est->deltax ++;
			cl_est->dx --;

			cl_est->d += (cl_est->deltay<<1);
			cl_est->d -= cl_est->x2m1;
			
			if(cl_est->d >= 0) cl_est->d -= (cl_est->deltay<<1);
			else cl_est->deltay ++;
			
			cl_est->x2m1 -= 2;
		} // else
	} // else normal
} // next_circle






//--------------------------------------------------
// estimation된 결과로 유효한 line을 찾는다.
//   circle 대신 beeline이 경계값으로 사용되면, 다음 pattern area를
//   위해서 circle estimation을 임시로 중단한다.
//   중단한 circle estimation은 다음 line pattern area를 estimation
//   할 때 재 사용한다. --> LINE_PARAM process에서 수행.

void get_hrange(bl_param *bline, cl_param *circle, int *eff_hr)
// bline : the parameter for a beeline estimation
// circle : the parameter for a circle estimation
// vpos : now vertical position
// eff_hr : effective line kind.  beeline or circle for each side(left/right)

{
	int         left, right;


	// 유효한 position 추출.
	//    left : 큰 값을 가지는 쪽이 유효.
	left = -2048;
	if(bline[0].en != 0) {
		left = bline[0].nposh;
		eff_hr[0] = 0;
	}
	
	if(circle[0].en != 0) {
		if(circle[0].nposh > left) {
			left = circle[0].nposh;
			eff_hr[0] = 1;
		}
		//else circle[0].en = 0; // for line pattern
	}
	
	//    right : 작은 값을 가지는 쪽이 유효.
	right = 2048-1;
	if(bline[1].en != 0) {
		right = bline[1].nposh;
		eff_hr[1] = 0;
	}
	
	if(circle[1].en != 0) {
		if(circle[1].nposh < right) {
			right = circle[1].nposh;
			eff_hr[1] = 1;
		}
		//else circle[1].en = 0; // for line pattern
	}
	
} // get_hrange



//==================================================================
// line estimation
void get_estimation(int *hrangep, int *eff_hr, int bl_new, int cl_new)
// hrangep : hrozontal range position. 총 4개로 구성.
//           left : 0,1    right : 2,3
// eff_hr : effective line kind.  beeline or circle for each side(left/right)
// bl_new : beeline first estimation
// cl_new : circle first estimation
{
	//pre_hrange(src_bl, src_cl, beeline_pm, circle_pm, 0); // Moved. 2006.11.8

	// copy horizontal position
	hrangep[0] = beeline_pm[0].nposh;
	hrangep[2] = beeline_pm[1].nposh;
	hrangep[1] = circle_pm[0].nposh;
	hrangep[3] = circle_pm[1].nposh;

	est_hrange(beeline_pm, circle_pm, bl_new, cl_new);

	get_hrange(beeline_pm, circle_pm, eff_hr);
	
} // get_estimation

