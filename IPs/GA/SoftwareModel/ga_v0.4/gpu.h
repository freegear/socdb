/*************************************************************************

   Header for the Graphic sub-processor

   file name : gpu.h
   created by gtlee
   data : 2006.7.4

   note :
          
   history :

************************************************************************/
//-----------------------------------------------------
// Global

// Line type
#define  BEELINE       0
#define  CIRCLE        1

// gradient color position define
#define  GRAD_C_T      0
#define  GRAD_C_R      1
#define  GRAD_C_B      2
#define  GRAD_C_L      3





#ifdef    __GPU__ //==================================
// local

// define GPU process names
#define    PROC_GET_QUEUE      0
#define    RD_8_CMD            (PROC_GET_QUEUE+1)
#define    WAIT_BUS_8          (RD_8_CMD+1)
#define    RD_REST_CMD         (WAIT_BUS_8+1)
#define    WAIT_BUS_REST       (RD_REST_CMD+1)
#define    GET_CMD_INFO        (WAIT_BUS_REST+1)
#define    CHK_IN_BUFF         (GET_CMD_INFO+1)
#define    WAIT_LINE_PARAM     (CHK_IN_BUFF+1)
#define    INIT_LINE_INFO      (WAIT_LINE_PARAM+1)
#define    CHECK_NEXT_LINE     (INIT_LINE_INFO+1)
#define    SET_PARAM           (CHECK_NEXT_LINE+1)
#define    LINE_ESTIMATE       (SET_PARAM+1)
#define    CHK_DRAW_AREA       (LINE_ESTIMATE+1)
#define    DRAW_HLINE          (CHK_DRAW_AREA+1)
#define    CMD_PARAM           (DRAW_HLINE+1)
#define    LINE_PARAM          (CMD_PARAM+1)
#define    DRAW_CMD            (LINE_PARAM+1)
#define    CHK_LINE_CMD        (DRAW_CMD+1)
#define    _DEFAULT_           (CHK_LINE_CMD+1)

// state define
#define    FIRST_DRAW      0
#define    NEW_AREA        1
#define    NEXT_LINE       2
#define    EST_LINE        4


// check drawing area
#define    NDRAW           0
#define    DRAW            1


// parameter 전달 단계
#define    NEW_CMD         0
#define    NEW_LINE        1
#define    DRAW_PROS       2


int gpu(void);
int get_cmd_info(void);
int init_line_info_(void);
void get_max_vpos(void);
void chk_next_draw(int *proc, int *state);
int chk_end_draw(void);
int chk_next_area(void);
int chk_next_line(void);
int set_parameter(int state);
int set_new_area(int state);
void set_new_line(void);
void left_new_circle(void);
void right_new_circle(void);
int set_new_vpos(int vpos);
int chk_draw(void);
void str_vpos_circle(void);
void set_cmd_param(void);
void set_line_param(void);
void set_each_param(void);

#ifdef __DEBUG__
void disp_bline_info(bline_info *bline);
void disp_circle_info(circle_info *circle);
#endif // __DEBUG__


#else //  __GPU__ //==================================
// external

extern int      bline_dv;
extern int      bline_dh;
extern int      bline_sslop;
extern int      circle_case;
extern int      se_exc;

extern int      line_len;

extern int      lpat_pos;
extern int      pat_len;
extern int      pat_attr;
extern int      rest_pat_px;

extern int      lpat_pos_bk;
extern int      pat_attr_bk;
extern int      rest_pat_bk;

extern pos      sort_edge[4];
extern int      max_vpos;

extern bline_info    bline_i[2];
extern circle_info   circle_i[2];

extern bline_info    next_st_pos;

extern int       now_vpos;
extern int       pre_vpos;

extern int       hrange[4];
extern int       eff_hrange[2];
extern int       eff_hrange_old[2];

//=======================================


extern int gpu(void);
extern int get_cmd_info(void);
extern int init_line_info_(void);
extern void get_max_vpos(void);
extern void chk_next_draw(int *proc, int *state);
extern int chk_end_draw(void);
extern int chk_next_area(void);
extern int chk_next_line(void);
extern int set_parameter(int state);
extern int set_new_area(int state);
extern void set_new_line(void);
extern void left_new_circle(void);
extern void right_new_circle(void);
extern int set_new_vpos(int vpos);
extern int chk_draw(void);
extern void str_vpos_circle(void);
 
#endif  //  __GPU__ //==================================
