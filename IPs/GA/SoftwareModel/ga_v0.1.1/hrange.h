/*************************************************************************

   Header of the calculation the horizontal range

   file name : hrange.h
   created by gtlee
   data : 2006.7.4

   note :


   history :

************************************************************************/

// Global

// parameter position은 frection 8bit를 포함한다.

typedef struct bl_str {
	int    en;       // enable
	int    st_posh;    // start horizontal position
	int    dv;
	int    dh;

	int    slope;    // 직선의 기울기
	int    pposh;    // previous horizontal position
	int    nposh;    // next start horizontal position
	int    cnt;      // 연속으로 estimation한 pixel의 개수.
}  bl_param;


typedef struct cl_str {
	int    en;
	int    r;  // radius of a circle. anti-aliasing에서는 2배값을 넣고,
	           // 결과를 1/2(즉 LSB가 2^-1을 의미)한다.
	int    st_posh;    // start horizontal position
	int    ccase;    // circle type case

	int    pposh;    // previous horizontal position
	int    nposh;    // next start horizontal position
	int    pposh5;    // previous horizontal position
	int    nposh5;    // next start horizontal position

	int    deltax;   // 0부터 r까지 증가함.
	int    dx;       // 0 ~ (r*sqrt(2))
	int    x2m1;
	int    d;
	int    deltay;   // r에서 0까지 감소함. result.
} cl_param;


#ifdef    __HRANGE__
//-------------------------------------------------
// local

// line의 위치 결정.
#define     LEFT_SIDE      0
#define     RIGHT_SIDE     1


void next_bline(int se, int new, int dx, int dy, int sposx, 
				int &posn, int &posn5);
void next_circle(int se, int new, int r, int &posn, int &posn5);
int cl_case(int sposx, int eposx, int cd);
void sbbl_edge(int width, int dy, int dx, int estyle, 
			   int *deltax, int *deltay);
void bl_edge(pos *le_pos, pos *l_pos, int width, int estyle);
void cl_edge(pos *le_pos, pos *l_pos, int width, int ccase);
int bleng_posx(int sposx, int l, int dx, int dy);

#else
//--------------------------------------------------
// external




#endif
