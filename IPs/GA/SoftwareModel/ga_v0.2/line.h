/*************************************************************************

   Line Parameter

   file name : line.c
   created by gtlee
   data : 2006.7.24
   note :
          
   history :

************************************************************************/

#define    CIRCLE_LEN_ESTM       1.25

// process 
#define    END                 0
#define    CONTINUE            1

/*
// LINE PARAM process에서 처리해야 할 동작을 알려줌.
#define    NEW_DRAW            0
#define    NEW_LINE            1
#define    NEW_AREA            2
*/


#ifdef    __LINE__
// Local

void mv_bline(bline_info *src_info, bline_info *dst_info);
void sort_edges(void);
void rotate_edge(pos px, int sin_int, int cos_int, pos *rs);
void rotate_edges(pos base, pos src_size, int sin_int, int cos_int, 
				  pos *edges);
int search_edges(pos *dredges);
void sbbl_edge(int width, int dy, int dx, int estyle, 
			   int *deltax, int *deltay);
void bl_edge(pos *le_pos, pos *l_pos, int width, int estyle);
void cl_edge(pos *le_pos, pos *l_pos, int width, int ccase);
int gen_ccase(pos *edges, int cdir);
int calc_hsize(int ctype, int maxx);
void set_bline_len(void);
void set_circle_len(void);
int reverse_pat(int lpat);
void line_pat_corr(void);
int calc_ptn_len(uint lpat, int *lpos);

#else
// External

extern void mv_bline(bline_info *src_info, bline_info *dst_info);
extern void sort_edges(void);
extern void rotate_edges(pos base, pos src_size, int sin_int, int cos_int, 
						 pos *edges);
extern int search_edges(pos *dredges);
extern void sbbl_edge(int width, int dy, int dx, int estyle, 
			   int *deltax, int *deltay);
extern void bl_edge(pos *le_pos, pos *l_pos, int width, int estyle);
extern void cl_edge(pos *le_pos, pos *l_pos, int width, int ccase);
extern int gen_ccase(pos *edges, int cdir);
extern int calc_hsize(int ctype, int maxx);
extern void set_bline_len(void);
extern void set_circle_len(void);
extern int reverse_pat(int lpat);
extern void line_pat_corr(void);
extern int calc_ptn_len(uint lpat, int *lpos);

#endif


