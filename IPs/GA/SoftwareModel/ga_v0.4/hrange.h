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
	int    r;  // radius of a circle.
	int    st_posh;    // start horizontal position
	int    ccase;    // circle type case

	int    pposh;    // previous horizontal position
	int    nposh;    // next start horizontal position

	int    deltax;   // 0부터 r까지 증가함.
	int    dx;       // 0 ~ (r*sqrt(2))
	int    x2m1;
	int    d;
	int    deltay;   // r에서 0까지 감소함. result.
} cl_param;


#ifdef    __HRANGE__  //=========================================
// local

// line의 위치 결정.
#define     LEFT_SIDE      0
#define     RIGHT_SIDE     1


void mv_bl_param(bl_param *dst, bl_param *src);
int bleng_posx(int st_posx, int l, int dx, int dy);
int calc_delta(int sp, int ep);
int calc_slope(int dh, int dv);
int pre_hrange(bline_info *src_bl, circle_info *src_cl,
			   bl_param *dst_bl, cl_param *dst_cl, int anti_alias);
int pre_bl(bline_info *src_bl, bl_param *dst_bl, int anti_alias, int side);
int pre_cl(circle_info *src_cl, cl_param *dst_cl, int anti_alias, int side);
void est_hrange(bl_param *dst_bl, cl_param *dst_cl, int bl_new, int cl_new);
void next_bline(int new, bl_param *bl_est);
int circle_est(int new, cl_param *circle);
void next_circle(int new, cl_param *cl_est);
void get_hrange(bl_param *bline, cl_param *circle, int *eff_hr);
void get_estimation(int *hrangep, int *eff_hr, int bl_new, int cl_new);

#else // __HRANGE__  //=========================================
// external
extern bl_param   beeline_pm[2]; // left : 0    right : 1
extern cl_param   circle_pm[2];


extern void mv_bl_param(bl_param *dst, bl_param *src);
extern int bleng_posx(int st_posx, int l, int dx, int dy);
extern int calc_delta(int sp, int ep);
extern int calc_slope(int dh, int dv);
extern int pre_hrange(bline_info *src_bl, circle_info *src_cl,
					  bl_param *dst_bl, cl_param *dst_cl, int anti_alias);
extern int pre_bl(bline_info *src_bl, bl_param *dst_bl, 
				  int anti_alias, int side);
extern int pre_cl(circle_info *src_cl, cl_param *dst_cl, 
				  int anti_alias, int side);
extern void next_circle(int new, cl_param *cl_est);
extern void get_hrange(bl_param *bline, cl_param *circle, int *eff_hr);
extern void get_estimation(int *hrangep, int *eff_hr, int bl_new, int cl_new);

#endif // __HRANGE__  //=========================================
