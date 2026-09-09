/*************************************************************************

   Header of the Command Buffer

   file name : cmdbuff.h

   created by gtlee

   data : 2006.6.26

   note :
        Depth : 32
          
   history :

************************************************************************/


//================================================
// Global

#define   CMDQUEUE           1



//---------------------------------
// Command code
// command kind
#define   LINEDRW         0x42
#define   FILLDRW         0x44
#define   BLTDRW          0x60
#define   ROTDRW          0x70
#define   CCONV           0x20


// word length of the command structure
#define   LINECMDLEN      14    // minimum size
#define   FILLCMDLEN      18
#define   BLTCMDLEN       29
#define   ROTCMDLEN       19
#define   CCONVCMDLEN     12


// color type convert
#define   DST_A16BPP         8
#define   DST_16BPP          9
#define   DST_24BPP       0x0c
#define   DST_F32BPP      0x10
#define   DST_A32BPP      0x11


// Command Buffer
#define   CMDBUFF_DEPTH    32



//======================================================
// Command position at the structure 
//    command structure에서의 index
#define   DST_PIC_SIZE               2
#define   DST_PIC_COLOR_TYPE         3
#define   DST_PIC_POINTER            4
#define   DST_PAL_POINTER            5

#define   DST_PAT_SIZE               6
#define   DST_PAT_COLOR_TYPE         7
#define   DST_PAT_POINTER            8

#define   SRC_BASE_BLT               14
#define   SRC_BASE_ROT               10
#define   SRC_BASE_CCONV             6

#define   SRC_PIC_SIZE               0
#define   SRC_PIC_COLOR_TYPE         1
#define   SRC_PIC_POINTER            2
#define   SRC_PAL_POINTER            3

#define   SRC_PAT_SIZE               4
#define   SRC_PAT_COLOR_TYPE         5
#define   SRC_PAT_POINTER            6


// foreground color
#define   LINE_FCOLOR                12 // line마다 별도로 설정.
#define   FILL_FCOLOR                14
#define   BLT_FCOLOR                 25


// background color
#define   FILL_BCOLOR                15
#define   BLT_BCOLOR                 26

// brush info.
#define   FILL_BRUSH_PAT_SIZE        16
#define   FILL_BRUSH_PNT             17
#define   BLT_BRUSH_PAT_SIZE         27
#define   BLT_BRUSH_PNT              28


// Gradient Fill color base position
#define   GRAD_FILL_BASE             14


// overlay info.
#define   ROT_OVERLAY                 9
#define   CCONV_OVERLAY              11
#define   OTHER_OVERLAY              13

// color convert info.
#define   CCONV_INFO                 10


// BLT info
#define   BLT_DST_POS                 9
#define   BLT_SRC_POS                21


// sin, cos value for ROTATE
#define   ROT_SIN_COS                18







//====================================================
#ifdef   __CMD_BUFF__
// Local

int lnklist(uint s_addr, uint e_addr);
void map_pic_pnt(uint cmd_list);
int set_cmd_pnt(void);
int par_overlay(uint param);
void par_position(uint param, pos *pos);

#ifdef    CMDQUEUE
int  chk_cbuff(void);
uint ld_buff(void);
int rd_cmds(int max_num);
int rd_fst_cmd(void);
void rd_rest_cmd(void);
void rd_rest_line(void);
void get_fst8cmd(void);
void get_rest_cmd(void);
void line_cmd_info(void);
void line_info(void);
void fill_cmd_info(void);
void blt_cmd_info(void);
void rot_cmd_info(void);
void cconv_cmd_info(void);
void get_pic_info(s_pic *pic, int pat);
#else    // CMDQUEUE  =============
void par_line(uint param);
int set_nxt_cmd(void);
int rd_cmds(int spos,int max_num);
uint rd_cmd_wd(int pos);
int rd_cmd_kind(void);
int rd_cmd_fst(void);
void rd_cmd_rest(void);
int get_line_param(void);
int get_pic_info(s_pic *pic, int cmd_off, int pat);
#endif   // CMDQUEUE ==============


#else // __CMD_BUFF__===================================
//--------------------------------------------
// External


extern uint     cmd_kind;

// picture and pattern information
extern s_pic    dst_pic_info;
extern s_pic    dst_pat_info;
extern s_pic    src_pic_info;
extern s_pic    src_pat_info;
extern s_pic    dpt_pat_info;

extern overlay  alpha_rater;

// for line drawing
extern int      line_num;
extern int      line_cnt;
extern uint     line_pat_for;
extern uint     line_pat_rev;
extern uint     line_pattern;

//    line option
extern uint     line_width;
extern uint     edge_style;
extern uint     bline_circle;
extern uint     circle_dir;

//   fill syle
extern int      fill_style;

// drawing colors
extern uint     fore_color;
extern uint     back_color;

extern uint     grad_color[4];

extern int      tmode;

// Rotate 삼각함수값.
extern int      sin_int;
extern int      cos_int;

// Color convert
extern int      ccnv_form;

extern int      a_pos;
extern int      r_pos;
extern int      g_pos;
extern int      b_pos;

// edge
extern pos      dst_edge[4];
extern pos      src_edge[4];

//-----------------------------------

#ifdef    CMDQUEUE
extern int  chk_cbuff(void);
extern uint ld_buff(void);
extern int rd_cmds(int max_num);
extern int rd_fst_cmd(void);
extern void rd_rest_cmd(void);
extern void rd_rest_line(void);
extern void get_fst8cmd(void);
extern void get_rest_cmd(void);
extern void line_cmd_info(void);
extern void line_info(void);
extern void fill_cmd_info(void);
extern void blt_cmd_info(void);
extern void rot_cmd_info(void);
extern void cconv_cmd_info(void);
extern void get_pic_info(s_pic *pic, int pat);
#else    // CMDQUEUE  =============
extern int set_nxt_cmd(void);
extern int rd_cmds(int spos,int max_num);
extern uint rd_cmd_wd(int pos);
extern int rd_cmd_kind(void);
extern int rd_cmd_fst(void);
extern void rd_cmd_rest(void);
extern int get_line_param(void);
extern int get_pic_info(s_pic *pic, int cmd_off, int pat);
#endif   // CMDQUEUE ==============



#endif  // __CMD_BUFF__  ============================
