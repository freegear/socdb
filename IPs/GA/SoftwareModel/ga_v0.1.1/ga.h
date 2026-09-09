/*************************************************************************
   Header of the Graphic Accelerator

   file name : ga.h
   created by gtlee
   data : 2006.6.22

   note :

   history :
       Color Type의 값 변경.
************************************************************************/

#define   SUCC     1
#define   FAIL     0

#define   TRUE     1
#define   FALSE    0

// Color type 
#define  MONO      0
#define  C8BPP     4
#define  C16BPP    8  // 565
#define  CA16BPP   9  //1555
#define  C24BPP    12
#define  C32BPP    16
#define  CA32BPP   17

// Picture kind
#define  SRC_PIC    0   // source picture
#define  SRC_PAT    1   // source masking pattern
#define  DST_PIC    2   // destination picture
#define  DST_PAT    3   // destination masking pattern
#define  DRW_PAT    4   // pattern picture
#define  PALLETE    5   // pallete --> 별도의 picture structure를 갖지 않음.
#define  CMD_STR    6

#define  NUM_PIC    5
#define  NUM_KIND   7


#define  NO_CACHE_TYPE    4  // caching 하지 않는 kind 경계
                             // 이 값 이상일 경우에는 cache에 caching하지 않음.


// Palette type
#define USE_PALETTE      1
#define NO_PALETTE       0


// Virtual memory map
#define  DEF_VMM_SIZE    (20*1024*1024) // 10Mbyte


#define  MAP_CMDLIST    (1024*1024)
#define  MAP_PICS       (1024*1024*2)
#define  MAP_PALETTE    (1024*1024*8)


typedef unsigned int  uint;
typedef unsigned char uchar;


// Picture structure
typedef struct str_pic {
	int    maxx;
	int    maxy;
	int    type;  // color type bpp
	uint   addr;  // Picture start address
	uint   palette; // palete address. 늦게 추가.
} s_pic;


// position structure
typedef struct str_pos {
	int  h;
	int  v;
} pos;


// Pixel color value structure
// signed value
typedef struct str_pixel {
	int  r;
	int  g;
	int  b;
} pixel;


// Overlay Option
#define KIND_NOOVER        0
#define KIND_RASTER        1
#define KIND_ALPHA_FL      2
#define KIND_ALPHA_ALL     3

#define AC_CODE            0
#define AC_PIC             1

typedef struct str_overlay {
	int      kind;  // alpha or raster
	int      code;  // alpha value or raster opcode
	int      ac;    // alpha blending opetion flag : choose alpha value
} overlay;


// Fill style
#define FILL_PAINT         0
#define FILL_PATTERN       1
#define FILL_GRAD          2

//------------------------------------------------------
#ifdef __GA__
// local





#else 
//------------------------------------------------------
// external


//--------------------------------------------
// bus signal emulation
// GA의 global parameter.
// command structure를 해석해서 값을 setting
// command에 따라 변경.
//  GA의 내부 변수.
//  어디에????
extern s_pic   pic_info[NUM_PIC];

extern s_pic   *src_pic; // pic_info[0]
extern s_pic   *dst_pic; // pic_info[1]
extern s_pic   *src_pat; // pic_info[2]
extern s_pic   *dst_pat; // pic_info[3]
extern s_pic   *drw_pat; // pic_info[4]

//extern uint     pal_base_addr; // pallete base address


#endif
