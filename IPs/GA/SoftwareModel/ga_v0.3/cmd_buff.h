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


// Command code
// command kind
#define   LINEDRW         0x42
#define   FILLDRW         0x44
#define   BLTDRW          0x60
#define   ROTDRW          0x70
#define   CCONV           0x20


// length of the command structure 
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



#ifdef   __CMD_BUFF__
// Local

int lnklist(uint s_addr, uint e_addr);
int set_cmd_pnt(void);
int set_nxt_cmd(void);
int rd_cmds(int spos,int max_num);
uint rd_cmd_wd(int pos);

#else 
// External
extern uint    cmd_buff[CMDBUFF_DEPTH];

extern int lnklist(uint s_addr, uint e_addr);
extern int set_cmd_pnt(void);
extern int set_nxt_cmd(void);
extern int rd_cmds(int spos,int max_num);
extern uint rd_cmd_wd(int pos);

#endif
