/*************************************************************************

   Command Buffer

   file name : cmd_buff.c
   created by gtlee
   data : 2006.6.26
   note :
        Depth : 32
          
   history :

************************************************************************/

#define __DEBUG__


#ifndef  __CMD_BUFF__
#define  __CMD_BUFF__
#endif


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "gbus.h"
#include "axi_if.h"
#include "gpu.h"
#include "ld_file.h"

#include "cmd_buff.h"


//---------------------------------------------------
// Command Buffer
uint    cmd_buff[CMDBUFF_DEPTH] = {0};
uint    cmd_pnt; // current command pointer. get from command queue
uint    cmd_pnt_nxt; // pointer for next command






//==================================
#ifdef    CMDQUEUE

int   bstart = 0;
int   bend = 0;

int   empty_fg = 1; // if fifo empty, actived.

#endif //  CMDQUEUE






//=======================================
// Command parameters
uint     cmd_kind;

// picture and pattern information
s_pic    dst_pic_info;  // destination picture
s_pic    dst_pat_info;
s_pic    src_pic_info;  // source picture
s_pic    src_pat_info;
s_pic    dpt_pat_info;  // drawing pattern. for brush

overlay  alpha_rater;   // overlay parameter

// for line drawing
int      line_num;      // drawing할 line의 개수.
int      line_cnt;      // drawing한 line의 개수.
uint     line_pat_for;  // forward line pattern
uint     line_pat_rev;  // reverse line pattern
uint     line_pattern;  // line의 pattern. drawing에서 사용되는 변수.

//    line option
uint     line_width;    // line width. 1 ~ 16
uint     edge_style;    // edge style. long or short
uint     bline_circle;  // beeline or circle
uint     circle_dir;    // circle direction
//uint     anti_alias;    // anti-aliasing. not suport yet.

//   fill syle
int      fill_style;    // paint, pattern, gradient fill

// drawing colors
uint     fore_color; // foreground color
uint     back_color; // background color

uint     grad_color[4]; // for gradient fill

// BLT mode
int      tmode; // transfer mode : crop or resize


// Rotate 삼각함수값.
int      sin_int;
int      cos_int;

// Color convert
int      ccnv_form; // color convert 종류 결정.

int      a_pos; // 2006.10.30
int      r_pos;
int      g_pos;
int      b_pos;

// edges
// drawing의 경계를 나타내는 사각형.
// 각 edge를 잇는 line을 estimation해야 한다.
pos      dst_edge[4]; // destination edge position
pos      src_edge[4]; // source edge position





//===============================================================
// parsing command linked list
// configuration function~!!!
int lnklist(uint s_addr, uint e_addr)
// s_addr : start address
// e_addr : end address
// return : number of command
{
	uint  *n_addr; // now address
	//uint  p_naddr; // the next command address of a previous command structure
	int   cmd_cnt; // command count
	int   cmd_kind_loc;
	int   cmd_len;

	// uint로 단위 변경.
	n_addr = (uint *)s_addr;

	while(n_addr <= (uint*)e_addr) {
		// command type
		cmd_kind_loc = *n_addr & 0x0ff;
		
		// word length를 구함.
		switch(cmd_kind_loc) {
		case LINEDRW :
			cmd_len = ((*(n_addr)>>16) & 0x0ff) * 3 + LINECMDLEN;
			break;
		case FILLDRW :
			cmd_len = FILLCMDLEN;
			break;
		case BLTDRW :
			cmd_len = BLTCMDLEN;
			break;
		case ROTDRW :
			cmd_len = ROTCMDLEN;
			break;
		case CCONV :
			cmd_len = CCONVCMDLEN;
			break;
		default : // command error
			printf("\n ERROR : Invalid command");
			return 0;
			break;
		} // switch
		
		cmd_len *= 4; // byte로 변환.
		
		// set next command virtual address
		*(n_addr + 1) = (uint)(n_addr + cmd_len);
		
		// change next command
		n_addr += cmd_len;
		cmd_cnt ++;
	} // while
	
	// set the end of a command structure
	n_addr -= cmd_len;
	*(n_addr + 1) = 0;

	return cmd_cnt;

} // lnklist








//----------------------------------------------
// mapping a picture and palette number to a picture or palette pointer
void map_pic_pnt(uint cmd_list)
// cmd_list : parsing할 command의 시작 주소.
{
	uint    *base;
	uint    *next;
	int      cmd_kind_loc; // command kind
	int      fill_kind; // kind of a fill drawing
	int      num;
	int      hsize;
	int      vsize;
	int      size;

	next = (uint *)cmd_list;

	while(1) {
		// set base address and next command address
		base = next;
		next = (uint *)(*(base + 1)); // 다음 command structure의 시작 주소.
		
		cmd_kind_loc = (*base) & 0x0ff;
		
		// Destination picture, palette and pattern
		num = *(base + DST_PIC_POINTER) & 0x15;
		*(base + DST_PIC_POINTER) = picture[num].addr;
		hsize = picture[num].maxx;
		vsize = picture[num].maxy;
		size = (vsize << 16) | hsize;
		*(base + DST_PIC_SIZE) = size;
		*(base + DST_PIC_COLOR_TYPE) = picture[num].type;
		
		if(cmd_kind_loc != CCONV) {
			num = *(base + DST_PAL_POINTER) & 7;
			*(base + DST_PAL_POINTER) = palette[num];

			num = *(base + DST_PAT_POINTER) & 0x15;
			*(base + DST_PAT_POINTER) = picture[num].addr;
			hsize = picture[num].maxx;
			vsize = picture[num].maxy;
			size = (vsize << 16) | hsize;
			*(base + DST_PIC_SIZE) = size;
			*(base + DST_PIC_COLOR_TYPE) = picture[num].type;
		} // if


		
		// Source picture, palette and pattern
		if(cmd_kind_loc != LINEDRW && cmd_kind_loc != FILLDRW) {
			num = *(base + SRC_PIC_POINTER) & 0x15;
			*(base + DST_PIC_POINTER) = picture[num].addr;
			hsize = picture[num].maxx;
			vsize = picture[num].maxy;
			size = (vsize << 16) | hsize;
			*(base + DST_PIC_SIZE) = size;
			*(base + DST_PIC_COLOR_TYPE) = picture[num].type;
			
			num = *(base + SRC_PAL_POINTER) & 7;
			*(base + DST_PAL_POINTER) = palette[num];
			
			if(cmd_kind_loc != CCONV) {
				num = *(base + SRC_PAT_POINTER) & 0x15;
				*(base + SRC_PAT_POINTER) = picture[num].addr;
				hsize = picture[num].maxx;
				vsize = picture[num].maxy;
				size = (vsize << 16) | hsize;
				*(base + DST_PIC_SIZE) = size;
				*(base + DST_PIC_COLOR_TYPE) = picture[num].type;
			} // if not color convert
		}// if not line
		


		// Brush pattern
		fill_kind = (*base >> 16) & 3;
		if(cmd_kind_loc == FILLDRW && fill_kind == 1) { // at pattern fill
			num = *(base + FILL_BRUSH_PNT) & 7;
			*(base + FILL_BRUSH_PNT) = picture[num].addr;
			hsize = picture[num].maxx;
			vsize = picture[num].maxy;
			size = (vsize << 16) | hsize;
			*(base + FILL_BRUSH_PAT_SIZE) = size;
		} // if pattern fill
		else if(cmd_kind_loc == BLTDRW) { // at block transfer
			num = *(base + BLT_BRUSH_PNT) & 7;
			*(base + BLT_BRUSH_PNT) = picture[num].addr;
			hsize = picture[num].maxx;
			vsize = picture[num].maxy;
			size = (vsize << 16) | hsize;
			*(base + BLT_BRUSH_PAT_SIZE) = size;
		} // if block drawing

		if(next == 0) break;
	} // while
} // map_pic_pnt








//============================================
// set command pointer
//   for new command
int set_cmd_pnt(void)
// return : SUCC/FAIL
{
	// get from command queue
	cmd_pnt = ld_queue();
	if(cmd_pnt == 0) return FAIL;
	
	return SUCC;
} // set_cmd_pnt







//--------------------------------------------------
// parsing overlay parameter
int par_overlay(uint param)
// param : overlay parameter command
// return : SUCC/FAIL
{
	alpha_rater.kind = (param >> 30) & 0x03;
	alpha_rater.code = (param >> 16) & 0xff;
	alpha_rater.ac = (param >> 29) & 1;
	alpha_rater.brcode = (param >> 8) & 0xff;
} // par_overlay







//--------------------------------------------------
// parsing position parameter
// position은 signed value이기 때문에 sign확장을 해야 한다.
void par_position(uint param, pos *pos)
// param : position parameter command
// pos : destination position structure
{
	if((param & 0x01000) != 0) // minus
		pos->h = 0xfffff000 | param;
	else                // plus
		pos->h = param & 0x0fff;
	
	if((param>>16) & 0x01000) // minus
		pos->v = 0xfffff000 | (param>>16);
	else                // plus
		pos->v = (param >> 16) & 0x0fff;
} // par_position










//==============================================================
#ifdef    CMDQUEUE



//--------------------------------------------------
// check the command buffer that has a command.
int  chk_cbuff(void)
// return : TRUE/FALSE
{
	if(empty_fg == 0) 
		return TRUE;
	
	return    FALSE;
} // chk_cbuff





//------------------------------------------------------
// command queue의 address를 fetch
uint ld_buff(void)
// return : command
{
	int     start;
	uint    cmd;

	// Check Empty
	if(empty_fg == 1) {
		printf("\n ERROR : No Command.");
		exit(0);
	} // if

	cmd = cmd_buff[bstart];

#ifdef __DEBUG__
	printf("\n CMD buffer point at read : %d, %d",bstart,bend);
#endif // __DEBUG__

	if(bstart == bend) {
		empty_fg = 1;
		bstart = 0;
		bend = 0;
	} // if
	else {
		start = bstart+1;
		
		if(start >= CMDBUFF_DEPTH) start = 0;
		bstart = start;
	} // else
	
	return cmd;

} // ld_queue







//-------------------------------------------
// load command from main memory
int rd_cmds(int max_num)
// max_num : the maximum command length
// return : readed word count
{
	int    i;
	int    rd_wd_num; // read word number
	int    rd_byte_num;

	if(empty_fg == 0) {
		printf("\n ERROR : Command buffer is not empty.");
		exit(0);
	} // if error

	if(max_num >= CMDBUFF_DEPTH) {
		printf("\n ERROR : Max number of reading of command buffer is too big.");
		exit(0);
	} // if 
	//bstart = 0;
	bend += (max_num-1);
	if(bend >= CMDBUFF_DEPTH) bend -= CMDBUFF_DEPTH;

	empty_fg = 0;

#ifdef __DEBUG__
	printf("\n CMD buffer point : %d, %d",bstart,bend);
#endif // __DEBUG__

	rd_wd_num = max_num;
	rd_byte_num = 4 * rd_wd_num;
	
	if(set_rd_mem(MEM_CMD_STR, cmd_pnt, rd_byte_num,
				  (uchar *)cmd_buff,0) == FAIL) {
		printf("\n ERROR : command structure read fail.");
		exit(0);
	} // if

	cmd_pnt += rd_byte_num; // pointer 조정.
	
	return rd_wd_num;
} // rd_cmds








//======================================================
// read command structure
//    cmd_pnt가 준비되어 있어야 한다.
int rd_fst_cmd(void)
// return : SUCC/FAIL
{
	// if command is exist.
	// read 8 word at first
	rd_cmds(8);

	return SUCC;
} // rd_fst_cmd






//-----------------------------------------------
// read rest commands
void rd_rest_cmd(void)
{
	int     cmd_len;

	// check the kind of a command
	switch( cmd_kind ) {
	case LINEDRW :
		cmd_len = (line_num * 3) + 14; // line_num은 0부터 시작.
		break;
	case FILLDRW :
		cmd_len = 18;
		break;
	case BLTDRW :
		cmd_len = 29;
		break;
	case ROTDRW :
		cmd_len = 19;
		break;
	case CCONV :
		cmd_len = 12;
		break;
	default :
		printf("\n ERROR : unkown command : %02x", cmd_kind);
		exit(0);
	} // switch

	// rest words
	cmd_len -= 8;    // 앞서서 8 word를 읽었으므로 빼줘야 함.

#ifdef __DEBUG__
	printf("\n Rest command length : %d", cmd_len);
#endif // __DEBUG__

	if(cmd_len >= 32) cmd_len = 30;

	// read rest words
	rd_cmds(cmd_len);

} // rd_rest_cmd





//---------------------------------------------------------
// read rest line information
void rd_rest_line(void)
{
	int    cmd_len;

	cmd_len = 3 * (line_num - line_cnt);

	if(cmd_len >= 32) cmd_len = 30;

	// read rest words
	rd_cmds(cmd_len);

} // rd_rest_line







//==================================================================
// Get command parameters
void get_fst8cmd(void)
// return : SUCC/FAIL
{
	uint    cmd;

	// 0th word
	cmd = ld_buff();
	
	cmd_kind = cmd & 0x0ff;

#ifdef  __DEBUG__
	printf("\n Command Kind : %Xh", cmd_kind);
#endif //  __DEBUG__


	if(cmd_kind == LINEDRW) {
		line_num = (cmd >> 16) & 0x0ff; // for line drawing

#ifdef  __DEBUG__
		printf("\n Line Command.");
		printf("\n Line count : %d", line_num+1);
#endif //  __DEBUG__

	} // if line command
	else line_num = 0;

	line_cnt = 0; // clear

	if(cmd_kind == FILLDRW) {
		fill_style = (cmd >> 16) & 3;   // for fill drawing

#ifdef  __DEBUG__
		printf("\n Fill Drawing Command.");
		printf("\n Fill style : %d",fill_style);
#endif //  __DEBUG__

	} // if fill drawing
	else fill_style = 0;

	if(cmd_kind == BLTDRW) {
		tmode = (cmd >> 16) & 1; // for BLT drawing

#ifdef  __DEBUG__
		printf("\n Block Transfer Command.");
		printf("\n BLT mode : %s.",(tmode == 0)?"crop":"resize");
#endif //  __DEBUG__

	} // if Block transfer
	else tmode = 0; // crop mode

	// 1st word
	cmd = ld_buff();
	cmd_pnt_nxt = cmd;

#ifdef  __DEBUG__
	printf("\n Next Command Address : %8Xh",cmd_pnt_nxt);
#endif //  __DEBUG__


	// 2nd ~ 5th word
#ifdef  __DEBUG__
		printf("\n\n Destination Picture Info.");
#endif //  __DEBUG__

	get_pic_info(&dst_pic_info,USE_PALETTE);

	// 6th ~ 7th word
	if(cmd_kind != CCONV ) { // if color convert
		// 6th word
		cmd = ld_buff();
		dst_pat_info.maxx = cmd & 0x0fff;
		dst_pat_info.maxy = (cmd>>16) & 0x0fff;
#ifdef  __DEBUG__
		printf("\n Destination pattern size : %d, %d", dst_pat_info.maxx,dst_pat_info.maxy);
#endif //  __DEBUG__
	
		// 7th word
		cmd = ld_buff();
		dst_pat_info.type = cmd & 0x01f;
#ifdef  __DEBUG__
		printf("\n Destination pattern type : %d", dst_pat_info.type);
#endif //  __DEBUG__

		dst_pat_info.palette = 0;
	} // if color convert
	else { // others
		dst_pat_info.maxx = 0;
		dst_pat_info.maxy = 0;
		dst_pat_info.type = 0;
		dst_pat_info.addr = 0;
		dst_pat_info.palette = 0;

#ifdef  __DEBUG__
		printf("\n\n Color conversion."); 
		printf("\n Source Picture Info.");
#endif //  __DEBUG__

		get_pic_info(&src_pic_info,NO_PALETTE);
		// palette은 나중에 채워 넣는다.
	} // else

} // get_fst8cmd






//---------------------------------------------------
// get rest commands
void get_rest_cmd(void)
{
	switch(cmd_kind) {
	case LINEDRW :
		line_cmd_info();
		//line_info();
		break;
	case FILLDRW :
		fill_cmd_info();
		break;
	case BLTDRW :
		blt_cmd_info();
		break;
	case ROTDRW :
		rot_cmd_info();
		break;
	case CCONV :
		cconv_cmd_info();
		break;
	default :
		printf("\n ERROR : unkown command : %02x", cmd_kind);
		exit(0);
	} // switch
		
} // get_rest_cmd



//-----------------------------------------
// get line command information
void line_cmd_info(void)
{
	uint    cmd;
	
	// 8th word
	// destination pattern information.
	cmd = ld_buff();
	dst_pat_info.addr = cmd;

	// 9th word
	cmd = ld_buff();

#ifdef __DEBUG__
	printf("\n Start position word : %08Xh",cmd);
#endif // __DEBUG__

	// init first point
	par_position(cmd, &dst_edge[1]); // hrange계산시 [0]로 shift.
	par_position(0, &dst_edge[0]);
	par_position(0, &dst_edge[2]);
	par_position(0, &dst_edge[3]);

#ifdef  __DEBUG__
	printf("\n Start position : %x, %x",dst_edge[1].h, dst_edge[1].v);
#endif //  __DEBUG__

	// 10th word
	cmd = ld_buff();
	line_pat_for = cmd;

	// no used pictures
	src_pic_info.addr = 0;
	src_pat_info.addr = 0;
	dpt_pat_info.addr = 0;

	// unused
	sin_int = 0;
	cos_int = 0;

	
	memset(&src_pic_info, 0, sizeof(s_pic));
	memset(&src_pat_info, 0, sizeof(s_pic));
	memset(&dpt_pat_info, 0, sizeof(s_pic));

} // line_cmd_info



//-------------------------------------
// get line information
void line_info(void)
{
	uint        cmd;

	memcpy(&dst_edge[0], &dst_edge[1], sizeof(pos));
	
	// 11th word
	//    position word
	cmd = ld_buff();
	par_position(cmd, &dst_edge[1]);

#ifdef   __DEBUG__
	printf("\n End edge : %xh, %xh",dst_edge[1].h,dst_edge[1].v);
#endif //  __DEBUG__

	// 12th word
	//    color word
	cmd = ld_buff();
	fore_color = cmd;

#ifdef   __DEBUG__
	printf("\n Drawing color : %08xh",fore_color);
#endif //  __DEBUG__

	// 13th word
	//     overlay
	cmd = ld_buff();
	par_overlay(cmd);
	
	//     line style
	line_width = (cmd & 0x0f) + 1;
	edge_style = (cmd>>4) & 1;
	circle_dir = (cmd>>5) & 1;
	bline_circle = (cmd>>6) & 1;
	
	// unused
	sin_int = 0;
	cos_int = 0;

#ifdef   __DEBUG__
	printf("\n End line Info");
#endif //  __DEBUG__

} // line_info




//-----------------------------------------
// get fill command information
void fill_cmd_info(void)
{
	uint    cmd;
	int     i;

	// 8th word
	//    destination pattern information.
	cmd = ld_buff();
	dst_pat_info.addr = cmd;

	// 9th ~ 12th word
	//     area edges
	for(i=0;i<4;i++) {
		cmd = ld_buff();
		par_position(cmd, &dst_edge[i]);
	} // for

	// 13th word
	//     overlay
	cmd = ld_buff();
	par_overlay(cmd);

	//     line style
	line_width = 1;
	edge_style = 0;
	circle_dir = (cmd>>5) & 1;
	bline_circle = (cmd>>6) & 1;
	
	// 14th ~ 17th word
	switch(fill_style) {
	case 0 : // paint
		cmd = ld_buff();
		fore_color = cmd;
		back_color = 0;
		memset(&dpt_pat_info, 0, sizeof(s_pic));
		break;
	case 1 : // pattern
		cmd = ld_buff();
		fore_color = cmd;
		cmd = ld_buff();
		back_color = cmd;

		cmd = ld_buff();
		dpt_pat_info.maxx = cmd & 0x0fff;
		dpt_pat_info.maxy = (cmd>>16) & 0x0fff;

		cmd = ld_buff();
		dpt_pat_info.addr = ld_buff();

		dpt_pat_info.palette = 0;
		dpt_pat_info.type = MONO;
		break;
	default : // gradient
		fore_color = 0;
		back_color = 0;
		for(i=0;i<4;i++) {
			cmd = ld_buff();
			grad_color[i] = cmd;
		} // for
		memset(&dpt_pat_info, 0, sizeof(s_pic));
		break;
	} // switch

	// unused
	sin_int = 0;
	cos_int = 0;

	// no line pattern
	line_pat_for = -1;

	// source picture info -> not used
	memset(&src_pic_info, 0, sizeof(s_pic));
	memset(&src_pat_info, 0, sizeof(s_pic));
	
} // fill_cmd_info







//---------------------------------------------
// get blt command information
void blt_cmd_info(void)
{
	int     i;
	uint    cmd;

	// 8th word
	//    destination pattern information.
	cmd = ld_buff();
	dst_pat_info.addr = cmd;

	// 9th ~ 12th word
	//    destination area edges
	for(i=0;i<4;i++) {
		cmd = ld_buff();
		par_position(cmd, &dst_edge[i]);
	} // for
	
	// 13th word
	//     overlay
	cmd = ld_buff();
	par_overlay(cmd);

	//     line style
	line_width = 1;
	edge_style = 0;
	circle_dir = 0;
	bline_circle = 0;
	
	// 14th ~ 17th word
	// source picture information
	get_pic_info(&src_pic_info,USE_PALETTE);

	// 18th ~ 20th word
	// source pattern information
	get_pic_info(&src_pat_info,NO_PALETTE);

	// 21 ~ 24th word
	// source area edges
	for(i=0;i<4;i++) {
		cmd = ld_buff();
		par_position(cmd, &dst_edge[i]);
	} // for

	
	// brush information
	// 25th word
	cmd = ld_buff();
	fore_color = cmd;
	
	// 26th word
	cmd = ld_buff();
	back_color = cmd;
	
	// 27th word
	cmd = ld_buff();
	dpt_pat_info.maxx = cmd & 0x0fff;
	dpt_pat_info.maxy = (cmd>>16) & 0x0fff;
	
	// 28th word
	cmd = ld_buff();
	dpt_pat_info.addr = cmd;

	dpt_pat_info.type = MONO;
	dpt_pat_info.palette = 0;


	// no line pattern
	line_pat_for = -1;

	// unused
	sin_int = 0;
	cos_int = 0;

} // blt_cmd_info







//---------------------------------------------
// get rotation command information
void rot_cmd_info(void)
{
	uint    cmd;

	// 8th word
	//     destination pattern information.
	cmd = ld_buff();
	dst_pat_info.addr = cmd;

	// 9th word
	//     overlay
	cmd = ld_buff();
	par_overlay(cmd);
	
	// 10th ~ 13th word
	// source picture information
	get_pic_info(&src_pic_info,USE_PALETTE);

	// 14th ~ 16th word
	// source pattern information
	get_pic_info(&src_pat_info,NO_PALETTE);

	// 17th word
	//      destination position
	par_position(cmd, &dst_edge[0]); // hrange계산시 [0]로 shift.
	par_position(0, &dst_edge[1]);
	par_position(0, &dst_edge[2]);
	par_position(0, &dst_edge[3]);

	// 18th word
	//      rotation angle
	cmd = ld_buff();
	cos_int = 0x0ffff & cmd;
	if(cos_int & 0x08000) cos_int |= 0xffff0000; // sign extension
	
	sin_int = 0x0ffff & (cmd >> 16);
	if(sin_int & 0x08000) sin_int |= 0xffff0000;

	// no line pattern
	line_pat_for = -1;

	memset(&dpt_pat_info, 0, sizeof(s_pic));

} // rot_cmd_info








//---------------------------------------------
// get color convert command information
void cconv_cmd_info(void)
{
	uint    cmd;
	
	// source pattern information.
	//     8th word
	cmd = ld_buff();
	src_pic_info.addr = cmd;

	//     9th word
	cmd = ld_buff();
	src_pic_info.palette = cmd;

	// 10th word
	cmd = ld_buff();
	
	ccnv_form = cmd & 0x01ff;
	a_pos = 3 & (cmd >> 22);
	r_pos = 3 & (cmd >> 20);
	g_pos = 3 & (cmd >> 18);
	b_pos = 3 & (cmd >> 16);

	// 11th word
	//     overlay
	cmd = ld_buff();
	par_overlay(cmd);	
	
	// no line pattern
	line_pat_for = -1;

	// unused
	sin_int = 0;
	cos_int = 0;

	memset(&dpt_pat_info, 0, sizeof(s_pic));

} // cconv_cmd_info








//--------------------------------------------------
// command buffer에서 picture 정보를 읽어 picture structure에 
// 채워 넣는 함수.
void get_pic_info(s_pic *pic, int pat)
// pic : target picture structure
// pat : select a palette info. pattern(NO_PALETTE) or picture(USE_PALETTE)
{
	uint      cmd;

	cmd = ld_buff();
	pic->maxx = cmd & 0x0fff;
	pic->maxy = (cmd>>16) & 0x0fff;
	
	cmd = ld_buff();
	pic->type = cmd & 0x01f;
	
	cmd = ld_buff();
	pic->addr = cmd;

	if(pat == USE_PALETTE) { // a pattern does not have a palette
		cmd = ld_buff();
		pic->palette = cmd;
	} // if
	else  pic->palette = 0;

} // get_pic_info







#else // CMDQUEUE ==================================================







//---------------------------------------------
// set next command pointer
int set_nxt_cmd(void)
// return : SUCC/FAIL. if no next command, return FAIL
{
	//if(cmd_buff[1] == 0) return FAIL;
	cmd_pnt_nxt = cmd_buff[1];
	return SUCC;
} // set_nxt_cmd






//-------------------------------------------
// load command from main memory
int rd_cmds(int spos,int max_num)
// spos : the start position of the command buffer
// max_num : the maximum command length
// return : readed word count
{
	int    rd_wd_num; // read word number
	int    rd_byte_num;

	if((max_num + spos) >= CMDBUFF_DEPTH) rd_wd_num = CMDBUFF_DEPTH-spos;
	else rd_wd_num = max_num;

	rd_byte_num = 4 * rd_wd_num;

	if(set_rd_mem(MEM_CMD_STR, cmd_pnt, 0, rd_byte_num,
				  (uchar *)&cmd_buff[spos],0) == FAIL) {
		printf("\n ERROR : command structure read fail.");
		exit(0);
	}

	cmd_pnt += rd_wd_num;

	return rd_wd_num;
} // rd_cmds







//===================================================
// read command word
uint rd_cmd_wd(int pos)
// pos : word position
// return : command value
{
	return cmd_buff[pos];
} // rd_cmd_wd







//----------------------------------------------
// read the kind of a command 
int rd_cmd_kind(void)
// return : command kind
{
	return rd_cmd_wd(0) & 0x0ff;
} // rd_cmd_kind







//======================================================
// read command structure
//    cmd_pnt가 준비되어 있어야 한다.
int rd_cmd_fst(void)
// return : SUCC/FAIL
{
	// if command is exist.
	// read 8 word at first
	rd_cmds(0, 8);

	return SUCC;
} // rd_cmd_fst







// read rest commands
void rd_cmd_rest(void)
{
	int     cmd_len;

	// check the kind of a command
	cmd_kind = rd_cmd_kind();
	switch( cmd_kind ) {
	case LINEDRW :
		cmd_len = (rd_cmd_wd(0)>>16) & 0x0ff; // get line count
		cmd_len = (cmd_len * 3) + 11;
		break;
	case FILLDRW :
		cmd_len = 18;
		break;
	case BLTDRW :
		cmd_len = 29;
		break;
	case ROTDRW :
		cmd_len = 19;
		break;
	case CCONV :
		cmd_len = 12;
		break;
	default :
		printf("\n ERROR : unkown command : %02x", cmd_kind);
		exit(0);
	} // switch

	// read rest words
	rd_cmds(8,cmd_len-8);

} // rd_cmd_rest




//----------------------------------------------------
void par_line(uint param)
// param : line option command
{
	line_width = (param & 0x0f) + 1;
	edge_style = (param>>4) & 1;
	circle_dir = (param>>5) & 1;
	bline_circle = (param>>6) & 1;
//	anti_alias = (param>>7) & 1; // unused
} // par_line






//------------------------------------------------------------
// 각 line마다의 parameter를 추출.
// line color, overlay, line attribute, end position
// start position은 이전 line의 end position을 사용.
int get_line_param(void)
// return : SUCC/FAIL
{
	if(line_cnt > line_num) return FAIL; // if no rest line
	line_cnt ++;
	line_pnt += 3; //next line command position
	
	dst_edge[0] = dst_edge[1];
	par_position(rd_cmd_wd(line_pnt), &dst_edge[1]);
	fore_color = rd_cmd_wd(line_pnt+1);
	par_line(rd_cmd_wd(line_pnt+2));
	par_overlay(line_pnt+2);

	return SUCC;
} // get_line_param




//--------------------------------------------------

int get_pic_info(s_pic *pic, int cmd_off, int pat)
// pic : target picture structure
// cmd_off : start position of the command structure
// pat : select a palette info. pattern(NO_PALETTE) or picture(USE_PALETTE)
// return : SUCC/FAIL
{

	pic->maxx = rd_cmd_wd(cmd_off) & 0x0fff;
	pic->maxy = (rd_cmd_wd(cmd_off)>>16) & 0x0fff;
	pic->addr = rd_cmd_wd(cmd_off+2);

#ifdef  __DEBUG__
	printf("\n Picture size : %d, %d", pic->maxx,pic->maxy);
	printf("\n Picture address : %08xh", pic->addr);
#endif //  __DEBUG__


	if(pat == USE_PALETTE) { // a pattern does not have a palette
		pic->palette = rd_cmd_wd(cmd_off+3);
#ifdef  __DEBUG__
		printf("\n Palette address : %08xh", pic->palette);
#endif //  __DEBUG__
	} // if use palette
	else 
		pic->palette = 0;
	
	switch(dst_pic_info.type) { // color type
	case MONO : 
	case C8BPP :
	case C16BPP :
	case CA16BPP :
	case C24BPP :
	case C32BPP :
	case CA32BPP:
		pic->type = rd_cmd_wd(cmd_off+1) & 0x01f;
		break;
	default : // error check
		printf("\n ERROR : invalide color type %x at get pic infor.", dst_pic_info.type);
		exit(0);
	} // switch

#ifdef  __DEBUG__
	printf("\n Picture type : %d", pic->type);
#endif //  __DEBUG__

	return SUCC;
} // get_pic_info



#endif // CMDQUEUE
