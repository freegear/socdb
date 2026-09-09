/*************************************************************************

   Calculation the horizontal range

   file name : hrange.c
   created by gtlee
   data : 2006.7.4

   note :
      calc. horizontal range.

   history :

************************************************************************/


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




//---------------------------------------------------
// Next Beeline estimation
int   bl_spos[2]; // start position
int   bl_ppos[2]; // previous position
int   bl_delta[2]; // 기울기.
int   bl_cnt[2];  // 연속으로 estimation한 pixel의 개수.

void next_bline(int se, int new, int dx, int dy, int sposx, 
			   int &posn, int &posn5)
// se : start/end. select variable pair.
// new : new line or next line.
// dx : delta x, horizontal increament.
// dy : delta y, vertical increament.
// sposx : horizontal start position
//         dx, dy, sposx는 new일 경우만 적용.
// posn : new horizontal position at n. 정수+소수1자리.
// posn5 : new horizontal position at n.5. 정수+소수1자리.
//    return position의 LSB는 2^-1이다.
{
	int    delta;
	int    n, n5;

	se %= 2;

	if(new) { // initialize
		bl_ppos[se] = sposx<<8;
		bl_spos[se] = sposx<<8;
		bl_delta[se] = (dx<<8)/dy;  // virtical 1 pixel이동할때 horizontal의 변화량이 필요.

		n = bl_ppos[se];
		n5 = bl_ppos[se];

		bl_cnt[se] = 0;
	} // if new
	else { // claculate a next position
		if(bl_cnt[se] >= 128) { // reset 
			delta = (dx<<8)*128 / dy;
			bl_ppos[se] = (sposx << 8) + delta;
			
			bl_spos[se] = bl_ppos[se];
			
			n5 = bl_ppos[se];
			n = (sposx << 8) + (delta>>1);
		} // if
		else { // normal
			n5 = bl_ppos[se] + bl_delta[se];
			n  = bl_ppos[se] + bl_delta[se]>>1;

			bl_ppos[se] = *posn5;
		}
		
		bl_cnt[se] ++;
	}
	*posn = n>>7;  // 정수부+소수1자리만 return.
	*posn5 = n5>>7;  // 정수부+소수1자리만 return.
} // next_bline


//---------------------------------------------------
// Next circle estimation
//   x,y 모두 LSB는 소수 첫번째자리.
int     deltax[2];  // 0부터 r*2까지 증가함.
int     x2m1[2];
int     d[2];
int     deltay[2];   // r*2에서 0까지 감소함. 

void next_circle(int se, int new, int r, int &posn, int &posn5)
// se : start/end. select variable pair.
// new : new line or next line.
// r : radius of a circle
// posn : new horizontal position at n. 정수+소수1자리.
// posn5 : new horizontal position at n.5. 정수+소수1자리.
//    return position의 LSB는 2^-1이다.
{
	int     i; // loop count
	int     py; // previous y

	se %= 2;
	
	if(new) { // initialize
		deltax[se] = 0;
		x2m1[se] = -1;
		deltay[se] = r<<1;
		d[se] = -(r<<1);

		*posn = deltay[se]; // no used
		*posn5 = deltay[se];
	}// if
	else { // normal
		for(i=0;i<2;i++) {
			if(deltax[se] < (int)((float)r*sqrt(2)*2)) { // 0 ~ 45도.
				x2m1[se] += 2;
				d[se] += x2m1[se];
				if(d[se] >= 0) {
					deltay[se] --;
					d[se] -= (deltay[se]<<1);
				}
			}
			else { // 45 ~ 90도.
				// y가 변경될때까지 loop
				py = deltay[se];
				while(py == deltay[se]) {
					for(deltax[se]-=1;deltax[se]>0;deltax[se]--) {
						d[se] += (deltay[se]<<1);
						d[se] -= x2m1[se];
						if(d[se] >= 0) d[se] -= (deltay[se]<<1);
						else deltay[se] ++;
						x2m1[se] -= 2;
					} // for
				} // while
			}
			if(i == 0) *posn = deltay[se];
			else    *posn5 = deltay[se];
		} // for
	} // else normal
} // next_circle


//------------------------------------------
// circle case 적용.
// 시작점과 끝점의 위치, circle의 방향을 이용해서 case를 구분.
int cc_case(int sposx, int eposx, int cd)
// sposx : start position x
// eposx : end position x
// vertical position은 항상 start point가 더 큼.
// cd : circle direction
// return : circle case. 0~3
{
	cd &= 1;

	if(eposx < sposx) {
		if(cd == 0) return 0; //위로 볼록.
		else return 1;
	}
	else {
		if(cd == 0) return 2; //위로 볼록.
	}
	
	return 3;
} // cc_case


//------------------------------------------
// calc. simple bold line edge
//    start or end point에서 edge를 계산하기 위한 delta를 구하는 함수.
//    start point의 아래쪽 edge를 기준으로 delta계산.

void sbbl_edge(int width, int dy, int dx, int estyle, 
			   int *deltax, int *deltay)
// width : line width. if 0, real line width is 1.  dy : line의
// 기울기.  dx : line의 기울기.  estyle : edge style. short type(0) or
// long type(1) deltax : edge 까지의 delta x deltay : edge 까지의
// delta y
{
	// edge style에 따라 계산이 달라짐.
	float    m, n;

	if(estyle == 0) { // short edge
		//n = width*(1+(1/sqrt(2)-1)*(dy/dx));
		n = width*(1-(0.29289*(dy/dx)));
		if(n == 0) m = 0; // -0을 방지.
		else       m = -(dy/dx)*n;
	} // if
	else { // long edge
		if(width == 0) m = 0; // -0을 방지.
		else m = - (width * (1 + (sqrt(2) - 1)*(dy/dx)));
		n = (1-a) * width;
	} // else
	
	*deltax = (int)(m + 0.5); // rounding.
	*deltay = (int)(n + 0.5); // rounding.

} // sbbl_edge

//==========================================
// calc. 4 edges of a line
//   beeline과 circle의 최각 edge point를 계산.

void bl_edge(pos *le_pos, pos *l_pos, int width, int estyle)
// le_pos : line edge position
// l_pos : line positioin
// width : line width
// estyle : edge style
{
	int      dx, dy; // 기울기.
	int      up_edx, up_edy; // edge delata x, y
	int      dn_edx, dn_edy; // edge delata x, y
	int      hwidth;

	dx = l_pos[1].h - l_pos[0].h;
	dy = l_pos[1].v - l_pos[0].v;

	// width는 16으로 제한.
	hwidth = width % 16;
	hwidth = hwidth >> 1;

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

} // bl_edge


void c_edge(pos *le_pos, pos *l_pos, int width, int ccase)
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


} // c_edge



//------------------------------------------------------------
// line length에 의한 경계 검사 함수.
// beeline과 circle은 별도의 algorithm으로 동작.

// beeline의 length L 떨어진 pixel의 horizontal position

int bleng_posx(int sposx, int l, int dx, int dy)
// sposx : start horizontal position
// l : line length
// dx : line 기울기.
// dy : line 기울기.
{
	float      offx; // offset

	offx = l * (1 - (0.293 * (dy /dx)));

	return (int)offx;
	
}


//int cleng_pos()




//===============================================================
// determin the horizontal range.

int hrange(int *spos, int *epos, )
// spos : start horizontal position
// epos : end horizontal position
{






}
