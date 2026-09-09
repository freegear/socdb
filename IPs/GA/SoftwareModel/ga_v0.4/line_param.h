/*************************************************************************

   Set Line information and parameter

   file name : line_param.c
   created by gtlee
   data : 2006.9.5

   note :

   history :

************************************************************************/
//-----------------------------------------------------
// Global




#ifdef    __LINE_PARAM__ //=============================

// local

void set_no_pattern(void);
void set_rest_pat(void);
void set_first_draw(void);
void set_new_bline_area(void);

void set_first_np_circle(void);
void fnp_case0(void);
void fnp_case1(void);
void fnp_case2(void);
void fnp_case3(void);

void set_new_circle(void);
void snc_case0(void);
void snc_case1(void);
void snc_case2(void);
void snc_case3(void);
int  est_circle_len(int len);

void mv_stop_pos(bline_info *bline, int length);
void mv_start_pos(bline_info *bline, int length);
void set_bline_edge(int side, int edge_num);
void set_bline_pat(int side);
void inv_slope(int *dv, int *dh);


#else   // __LINE_PARAM__ //=============================
// external

extern void set_no_pattern(void);
extern void set_rest_pat(void);
extern void set_first_draw(void);
extern void set_new_bline_area(void);

extern void set_first_np_circle(void);
extern void fnp_case0(void);
extern void fnp_case1(void);
extern void fnp_case2(void);
extern void fnp_case3(void);

extern void set_new_circle(void);
extern void snc_case0(void);
extern void snc_case1(void);
extern void snc_case2(void);
extern void snc_case3(void);
extern int est_circle_len(int len);

extern void mv_stop_pos(bline_info *bline, int length);
extern void mv_start_pos(bline_info *bline, int length);
extern void set_bline_edge(int side, int edge_num);
extern void set_bline_pat(int side);
extern void inv_slope(int *dv, int *dh);

#endif  // __LINE_PARAM__ //=============================
