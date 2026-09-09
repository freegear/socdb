/****************************************************

   Header of Horizontal line drawing

   file name : drawing.h
   created by gtlee
   data : 2006.9.27

   note :
         
   history :

****************************************************/

//==================================================
// global

// Pipeline Modes
#define  P_RUN           0
#define  P_NOP           1    // at stall
#define  P_BYPASS        2    // for sending dummy. stall





#ifdef  __DRAWING__
//==================================================
// Local

// picture info는 commmend register에서 가져옴.

// H.Range block에서 new line 정보를 줄때까지 유지한다.
typedef struct draw_slot1 {
	int    cmd_kind;

	// destination info.
	uint   dst_pic_hsize; // range 0 ~ hsize
	uint   dst_pic_vsize; // range 0 ~ vsize
	int    dst_pic_ctype; // color type
	uint   dst_pic_pnt; // destination picture pointer
	uint   dst_pal_pnt; // destination palette pointer. <= no used.
	
	uint   dst_pat_hsize; // range 0 ~ hsize
	uint   dst_pat_vsize; // range 0 ~ vsize
	int    dst_pat_ctype; // color type. always MONO
	uint   dst_pat_pnt; // destination picture pointer

	// source info.
	uint   src_pic_hsize; // range 0 ~ hsize
	uint   src_pic_vsize; // range 0 ~ vsize
	int    src_pic_ctype; // color type
	uint   src_pic_pnt; // source picture pointer
	uint   src_pal_pnt; // source palette pointer <= used only color convert.
	
	uint   src_pat_hsize; // range 0 ~ hsize
	uint   src_pat_vsize; // range 0 ~ vsize
	int    src_pat_ctype; // color type. always MONO
	uint   src_pat_pnt; // source picture pointer
	
	// drawing info.
	uint   draw_fcolor; // drawing foreground color. line마다 별도로 설정.
	uint   draw_bcolor; // drawing background color

	// brush info.
	uint   brush_hsize; // range 0 ~ hsize
	uint   brush_vsize;	// range 0 ~ bsize
	uint   brush_pnt; // brush pattern pointer

	// gradient color.
	//    used at only grdient fill
	uint   t_color;
	uint   r_color;
	uint   b_color;
	uint   l_color;

	// overlay info.
	int    avalue_rcode; // constant alpha value or rater code
	int    alpha_choose; // select alpha value
	int    alpha_raster; // no, rater, alpha flag, all alpha
	
	// color convert info.
	int    cconv_format;
	int    sel_b;
	int    sel_g;
	int    sel_r;
	int    sel_a;
	
	// destination picture vertical position at BLT
	int    dst_vpos[4]; // 시계방향으로 나열하지 않음.

	// source picture position at BLT
	pos    src_pos[4]; // 시계방향으로 나열하지 않음.
	
	// sin, cos value for rotate
	int    sin_fix;
	int    cos_fix;


	// horizontal position
	int    now_vpos;
	int    st_hpos;
	int    ed_hpos;
	int    now_hpos; // pipeline이 진행하면 증가된다.
	uint   st_hpos_addr; // start position의 memory 주소.
	uint   ed_hpos_addr; // start position의 memory 주소.

	// destination pixel info.
	uint   dst_addr; // address of destination picture
	int    dst_offset; // mono는 별도로 처리필요.
	uint   dst_pat_addr; // address of destination pattern

	fpos   src_pixel_pos;   // source picture에서의 pixel position
	float  src_h_ratio; // source pixel의 이동량
	float  src_v_ratio; // source pixel의 이동량

	// gradient
	int    grad_fill; // actived at the grdient fill mode flag
	float  grad_fcolor[4]; // float type of the gradient color
	float  grad_ratio[4];


	// slot control signals
	int    lastp; // last pixel
	int    nop;
	int    stall;  // pipeline의 상태를 나타내는 flag
	
} str_drw_slot1; 





// pipeline이 진행하면 변경된다.
typedef struct draw_slot2 {

	// drawing info.
	uint   draw_fcolor; // drawing foreground color. line마다 별도로 설정.


	// horizontal position
	int    now_vpos;
	int    st_hpos;
	int    ed_hpos;
	int    now_hpos;
	uint   st_hpos_addr; // start position의 memory 주소.line이 변경되면 수정된다.
	uint   ed_hpos_addr; // end position의 memory 주소.line이 변경되면 수정된다.

	fpos   src_pos;   // source picture에서의 pixel position
	float  src_h_ratio; // source pixel의 이동량
	float  src_v_ratio; // source pixel의 이동량


	// destination pixel info.
	uint   dst_addr; // address of destination picture
	uint   dst_pat_addr; // address of destination pattern
	
	
	// source pixel address. max 4 pixel. 시계방향.
	fpos   src_pixel_pos;   // source picture에서의 pixel position
	pos    src_pixel[4]; // source pixel position. 시계방향.
	uint   src_addr[4]; // address of source picture
	uint   src_pat_addr[4]; // address of source pattern


	// gradient
	int    grad_fill; // actived at the grdient fill mode flag
	uing   grad_icolor; // gradient color interpolation
	

	// Brush info
	int    brush_pat; // destination pixel에 해당하는 brush pattern정보.

	// slot control signals
	int    lastp; // last pixel
	int    nop;
	int    stall;

} str_drw_slot2;






// pipeline이 진행하면 변경된다.
typedef struct draw_slot3 {
	// drawing info.
	uint   draw_fcolor; // drawing foreground color. line마다 별도로 설정.


	// horizontal position
	int    now_vpos;
	int    st_hpos;
	int    ed_hpos;
	int    now_hpos; // pipeline이 진행하면 증가된다.

	// destination pixel info.
	uint   dst_addr; // address of destination picture
	

	// destination pixel datas
	uint   dst_pixel;
	uint   dst_pat;   // only 1 bit
	
	// source pixel info. 시계방향.
	fpos   src_pixel_pos;   // source picture에서의 pixel position
	uint   src_pixels[4]; // 시계방향.
	uint   src_pat[4]; // only 1 bits. 시계방향.
	uint   src_pal; // palette of the top pixel of source picture

	// gradient
	//int    grad_fill; // actived at the grdient fill mode flag
	//uing   grad_icolor; // gradient color interpolation

	
	uint   brush_pat; // only 1 bit
	
	// slot control signals
	int    lastp; // last pixel
	int    nop;
	int    stall;
	int    bypass; // 연산처리 하지 않을 pixel정보를 전달. 아무 처리 안 하고 그대로 전송.
} str_drw_slot3;







// pipeline이 진행하면 변경된다.
typedef struct draw_slot4 {
	// drawing info.
	uint   draw_fcolor; // drawing foreground color. line마다 별도로 설정.


	// horizontal position
	int    now_vpos;
	int    st_hpos;
	int    ed_hpos;
	int    now_hpos; // pipeline이 진행하면 증가된다.

	// destination pixel info.
	uint   dst_addr; // address of destination picture
	uint   dst_pixel;
	uint   dst_pat;   // only 1 bit
	

	// source pixel datas
	uint   src_pixel;
	uint   src_pat; // only 1 bits
	uint   src_pal; // palette of the top pixel of source picture


	// gradient
	int    grad_fill; // actived at the grdient fill mode flag
	uint   grad_icolor; // gradient color interpolation
	uint   brush_pat; // only 1 bit
	
	// slot control signals
	int    lastp; // last pixel
	int    nop;
	int    stall;
	int    bypass; // 연산처리 하지 않을 pixel정보를 전달. 아무 처리 안 하고 그대로 전송.

} str_drw_slot4;






// pipeline이 진행하면 변경된다.
typedef struct draw_slot5 {
	// horizontal position
	int    ed_hpos;
	int    now_hpos; // pipeline이 진행하면 증가된다.

	// destination pixel info.
	uint   dst_addr; // address of destination picture
	uint   dst_pixel;

	// slot control signals
	int    lastp; // last pixel
	int    nop;
	int    stall;
	int    bypass; // 연산처리 하지 않을 pixel정보를 전달. 아무 처리 안 하고 그대로 전송.
} str_drw_slot5;




// pipeline이 진행하면 변경된다.
typedef struct draw_slot6 {
	// horizontal position
	int    ed_hpos;
	int    now_hpos; // pipeline이 진행하면 증가된다.

	// destination pixel info.
	uint   dst_addr; // address of destination picture
	uint   dst_pixel;

	// slot control signals
	int    lastp; // last pixel
	int    nop;
	int    stall;
	int    bypass; // 연산처리 하지 않을 pixel정보를 전달. 아무 처리 안 하고 그대로 전송.
} str_drw_slot6;


/*

// pipeline이 진행하면 변경된다.
typedef struct draw_slot7 {



} str_drw_slot7;



// pipeline이 진행하면 변경된다.
typedef struct draw_slot8 {



} str_drw_slot8;




// pipeline이 진행하면 변경된다.
typedef struct draw_slot9 {



} str_drw_slot9;




// pipeline이 진행하면 변경된다.
typedef struct draw_slot10 {



} str_drw_slot10;
*/

// draw pipeline slot register 선언.
str_drw_slot1    slot1;
str_drw_slot2    slot2;
str_drw_slot3    slot3;
str_drw_slot4    slot4;
str_drw_slot5    slot5;
str_drw_slot6    slot6;
//str_drw_slot7    slot7;
//str_drw_slot8    slot8;
//str_drw_slot9    slot9;
//str_drw_slot10   slot10;



// pipeline 진행 상황 설정 at state machine










#else 
//==================================================
// External






#endif
