
/*************************************************************************

   Graphic sub-processor

   file name : gpu.c
   created by gtlee
   data : 2006.7.4

   note :
        emulation the function of the v8 processor

   history :

************************************************************************/


#ifndef    __GPU__
#define    __GPU__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#incluce "gbus.h"
#include "cmd_buff.h"

#include "gpu.h"

//----------------------------------------------------
// global variables
// Line type
#define  BEELINE          0
#define  CIRCLE           1

// gradient color position define
#define  GRAD_C_T      0
#define  GRAD_C_R      1
#define  GRAD_C_B      2
#define  GRAD_C_L      3


//=======================================
// Command parameters
uint     cmd_kind;

// picture and pattern information
s_pic    dst_pic_info;  // destination picture
s_pic    src_pic_info;  // source picture
s_pic    dpt_pic_info;  // drawing pattern

s_pic    dst_msk_info;  // destination masking pattern
s_pic    src_msk_info;  // destination masking pattern

overlay  alpha_rater;   // overlay parameter

// for line drawing
int      line_pnt;      // line pointer. command buffer에서 다음에 처리해야 할 line정보의 offset.
int      line_num;      // drawing할 line의 개수.
int      line_cnt;      // drawing한 line의 개수.
uint     line_pattern;  // line의 pattern

//    line option
uint     line_width;    // line width
uint     edge_style;    // edge style. long or short
uint     bline_circle;   // beeline or circle
int      bline_sslop;   // the sign of a beeline slop // 0/-1
uint     circle_dir;    // circle direction
uint     anti_alias;    // anti-aliasing
int      se_exc;        // start/end position exchange. line의 시작점이 끝점보다 아래 있을때 active.
int      lpat_pos;      // line pattern position. 다음에 적용할 pattern steam에서 위치.
int      circle_case;   // circle의 종류.
// line pattern을 적용할 때, line의 끝점이 위에 있으면, 끝점부터 그린다.
// 따라서, 이런 경우에는 line의 마지막 pattern의 위치를 계산하여 뒤에서부터 적용한다.
// line의 시작위치가 위에 있으면, lpat_pos을 증가시키며 그리고, line의 시작위치가
// 아래에 있으면, line의 마지막 lpat_pos을 계산하고 뒤에서부터 그린다.
// line drawing이 완료되면 다음 line의 pattern시작위치를 재계산한다.


// drawing colors
uint     fore_color; // forground color
uint     back_color; // background color

uint     grad_color[4]; // for gradient fill

// Rotate 삼각함수값.
int      sin_int;
int      cos_int;

// Color convert
int      ccnv_form; // color convert 종류 결정.

int      r_pos;
int      g_pos;
int      b_pos;

// edges
// drawing의 경계를 나타내는 사각형.
// 각 edge를 잇는 line을 estimation해야 한다.
pos      dst_edge[4]; // destination edge position
pos      src_edge[4]; // source edge position

// 정렬된 line의 시작과 끝.
pos      sort_edge[2];

// real drawing area의 edge
pos      real_edge[4]; // sorted real destination edge. 4edge를 재 정렬한 결과.
                       // line drawing에서 순서를 재정열. 그 외에는 그냥 copy한다.

// beeline의 기울기가 변경될 next vertical position
// 둘중 하나만이라도 meet하면 line을 변경하게 된다.
int      chk_hpoint; // line을 변경하게 된다.
int      chk_vpoint; // line을 변경하게 된다.
int      chk_hfg;    // line을 변경하게 될 부호.
int      chk_vfg;    // line을 변경하게 될 부호.
// circle에서 line의 pattern을 적용하기 위한 변수.
// pattern에 의한 beeline의 정보.

// line estimation에 사용할 information structure
// 이 정보를 이용하여 hrange를 계산.
bline_info    bline_i[2];
cicle_info    circle_i[2];

// line pattern에 의해서 중단되었던 point의 position.
// pattern에 의한 영역 하나를 다 drawing하면 next_spos에서 
// 재 시작. line을 변경할때 저장.
bline_info    next_spos[2];
                     


//=======================================





//==================================================
// GPU processing

// drawing할 hrange를 계산하고 drawing이 완료 될때까지 기다림.
// drawing은 gpu function을 종료하고 상위에서 호출.

int    gpu_proc = 0; // gpu의 현재 process
                     // first command load, rest command load
                     // process번호는 gpu.h에서 define

void gpu(void)
{
	int    buff_spos; // start position of the buffer 
                      // line drawing command의 남은 부분을 load할
                      // 시작 offset.

	switch(gpu_proc) {
	case PROC_GET_QUEUE :
		if(set_cmd_pnt() == FAIL) return FAIL; // no command
		gpu_proc = RD_8_CMD;

	case RD_8_CMD :
		// read 8 command words
		rd_cmd_fst();
		gpu_proc = WAIT_BUS_8;
		break;
	case WAIT_BUS_8 : 
		// wait the end of bus operation
		if(chk_op() == 0) gpu_proc = WAIT_BUS_REST;
		break;
	case RD_REST_CMD :
		// read rest command words
		set_nxt_cmd();
		rd_cmd_rest();
		gpu_proc = WAIT_BUS_REST;
		break;
	case WAIT_BUS_REST : 
		// wait the end of bus operation
		if(chk_op() == 0) gpu_proc = GET_INFO;
		break;
	case GET_INFO :
		// get picture informations
		//    command structure에 있는 picture 정보를 적당한 variable에 복사.
		get_info();
		
		gpu_proc = CHK_IN_BUFF;
		break;
	case CHK_IN_BUFF : // iv. Line edge 추출
		if(cmd_kind == LINEDRW) {
			// line parameter가 command buffer에 있는지 check.
			// check the last line.
			if(line_cnt > line_num) { // end of command.
				gpu_proc = _DEFAULT_;  // JUMP to default;
				break;
			} // if
			//----------------------------------------
			// command parameter가 buffer에 있는지 검사.
			// line parameter가 command buffer에 없을 경우 
			// memory에서 추가로 read해오는 function필요.
			if(line_pnt > (CMDBUFF_DEPTH-3)) {// 일부만 load된 경우.
				// 남은 command의 길이와 buffer에 남은 길이 비교.
				int    cmd_len;
				
				cmd_len = (line_num - line_cnt) * 3 // 남은 line의 parameter 개수. 
					+ CMDBUFF_DEPTH - line_pnt;     // 이번 line의 load된 parameter 개수.
				// buffer의 비어 있는 영역과 남은 command의 개수중 작은 개수를 선택.
				cmd_len = (cmd_len > line_pnt)? line_pnt : cmd_len;
				//-----------------------------------------------------------
				// line drawing command중 command buffer에 load하지 않은 것중 
				// 일부를 load.
				// gpu.c에서 load가 완료되면 다음 단계를 진행.
				// 따라서, start address, length를 지정.
				rd_cmds(0, cmd_len); // 시작 offset과 word 개수를 지정. cmd_len은 개수.
			} // if
			//----------------------------------------

			gpu_proc = WAIT_LINE_PARM;
		} // if
		else { // other command
			
			gpu_proc = SET_LINE_PARM; // jump
		}
		break;
	case WAIT_LINE_PARM : // wait rest command load
		// memory operation이 완료되어 buffer가 fill되면 다음으로 진행.
		if(chk_op() == 0) gpu_proc = LINE_EDGE;
		break;
	case LINE_EDGE : // v. Line의 width를 고려하여 drawing area결정
		     //   1. Line의 외각 edge를 결정.
             //   2. Circle인지 beeline인지에 따라 별도의 함수 호출.

		// drawing할 area의 edge point 추출.
		// command마다 다르게 추출.
		if(cmd_kind == LINEDRW) {
			// line drawing일 경우 
			// memory operation이 완료되면 진행. 아니면 return
			search_edges(sort_edge);
		}
		gpu_proc = LINE_PAT;
		break;
	case LINE_PAT : // vi.	Line Pattern에 의해서 Line에서 drawing할 영역결정
 		     //    1. 각 line estimation block에서 필요로 하는 parameter생성.
		// Line Pattern적용.
		// 최종 drawing area결정.
		if(cmd_kind == LINEDRW) {

		}
		gpu_proc = SET_LINE_PARM;
	case SET_LINE_PARM : // vii. 시작 point 결정 및 next line 경계 check.
		if(cmd_kind == LINEDRW) {

		}
		else {

		}

		gpu_proc = GET_HRANGE;
		
	case GET_HRANGE : // viii. Horizontal Range 결정




		
	case DRAW_HLINE :
		// wait end of a drawing h.line
		
		
		
	default : // end command. close command and prepare next instruction
		

		
		break;
	} // switch
	
} // gpu



//-----------------------------------------------------
// 



 


//======================================================
// picture정보를 command structure에서 register로 복사.

int get_info(void)
// return : SUCC/FAIL
{
	uint    command;
	int     i;

	//cmd_kind = rd_cmd_kind(); //read rest command에서 set
	
	// get destination picture info
	get_pic_info(&dst_pic_info, 2, USE_PALETTE);
	
	// get destination pattern info
	if(cmd_kind != CCONV ) 
		get_pic_info(&dst_pat_info, 6, NO_PALETTE);
	else {
		dst_pat_info.maxx = 0;
		dst_pat_info.maxy = 0;
		dst_pat_info.type = 0;
		dst_pat_info.addr = 0;
		dpt_pat_info.palette = 0;
	} // else
	
	// get source picture info
	if(cmd_kind == BLTDRW)
		get_pic_info(&src_pic_info, 14, USE_PALETTE);
	else if(cmd_kind == ROTDRW)
		get_pic_info(&src_pic_info, 10, USE_PALETTE);
	else if(cmd_kind == CCONV)
		get_pic_info(&src_pic_info, 6, USE_PALETTE);
	else {
		src_pic_info.maxx = 0;
		src_pic_info.maxy = 0;
		src_pic_info.type = 0;
		src_pic_info.addr = 0;
		dpt_pat_info.palette = 0;
	} // else 

	// get source pattern info
	if(cmd_kind == BLTDRW)
		get_pic_info(&src_pat_info, 17, NO_PALETTE);
	else if(cmd_kind == ROTDRW)
		get_pic_info(&src_pat_info, 13, NO_PALETTE);
	else {
		src_pat_info.maxx = 0;
		src_pat_info.maxy = 0;
		src_pat_info.type = 0;
		src_pat_info.addr = 0;
		dpt_pat_info.palette = 0;
	} // else

	// (drawing) brush pattern
	if(cmd_kind == BLTDRW) {
		//get_pic_info(&dpt_pic_info, 26, NO_PALETTE);
		dpt_pic_info.maxx = rd_cmd_wd(27) & 0x0fff;
		dpt_pat_info.maxy = (rd_cmd_wd(27)>>16) & 0x0fff;
		dpt_pat_info.type = MONO;
		dpt_pat_info.addr = rd_cmd_wd(28);
		dpt_pat_info.palette = 0;
	}
	else if(cmd_kind == FILLDRW && 
			((rd_cmd_wd(0)>>16)&0x03) ) {
		//get_pic_info(&dpt_pic_info, 14, NO_PALETTE);
		dpt_pic_info.maxx = rd_cmd_wd(16) & 0x0fff;
		dpt_pat_info.maxy = (rd_cmd_wd(16)>>16) & 0x0fff;
		dpt_pat_info.type = MONO;
		dpt_pat_info.addr = rd_cmd_wd(17);
		dpt_pat_info.palette = 0;
	}
	else {
		dpt_pic_info.maxx = 0;
		dpt_pat_info.maxy = 0;
		dpt_pat_info.type = 0;
		dpt_pat_info.addr = 0;
		dpt_pat_info.palette = 0;
	} // else 

	//------------------------------------------------
	// overlay parameter
	// alpha blending or raster operation
	if(cmd_kind == ROTDRW) command = rd_cmd_wd(9);
	else if(cmd_kind == CCONV) command = rd_cmd_wd(11) & 0x80ff0000;
	else command = rd_cmd_wd(13);
	
	par_overlay(command);

	//-----------------------------------------------
	// colors

	for(i=0;i<4;i++) grad_color[i] = 0;

	swtich(cmd_kind) {
	case FILLDRW :
		switch((rd_cmd_wd(0) >> 16)&0x3) {
		case FILL_PAINT :
			fore_color = rd_cmd_wd(14);
			back_color = 0;
			break
		case FILL_PATTERN :
			fore_color = rd_cmd_wd(14);
			back_color = rd_cmd_wd(15);
			break;
		case FILL_GRAD :
			fore_color = 0;
			back_color = 0;
			for(i=0;i<4;i++) grad_color[i] = rd_cmd_wd(14+i);
			break;
		default :
			printf("\n ERROR : invalie fill type at parsing color.");
			exit(0);
		} // switch
		break;
	case BLTDRW : // set to brush color
		fore_color = rd_cmd_wd(25);
		back_color = rd_cmd_wd(26);
		break;
	case LINEDRW :
	case ROTDRW :
	case CCONV :
		fore_color = 0;
		back_color = 0;
		break;
	default :
		printf("\n ERROR : invalie command kind %x at parsing color.", cmd_kind);
		exit(0);
	} // switch
	
	//------------------------------------------
	// get destination edge position information

	swtich(cmd_kind) {
	case LINEDRW :
		par_position(rd_cmd_wd(9), &dst_edge[1]); // hrange계산시 [0]로 shift.
		par_position(0, &dst_edge[0]);
		par_position(0, &dst_edge[2]);
		par_position(0, &dst_edge[3]);
		break;
	case FILLDRW :
	case BLTDRW :
		for(i=0;i<4;i++)
			par_position(rd_cmd_wd(9+i), &dst_edge[i]);
		break;
	case ROTDRW :
		par_position(rd_cmd_wd(17), &dst_edge[0]);
		for(i=1;i<4;i++)
			par_position(rd_cmd_wd(9+i), &dst_edge[i]);
		break;
	default :
		for(i=0;i<4;i++)
			par_position(0, &dst_edge[i]);
	}
	
	// get source edge position information
	if(cmd_kind == BLTDRW)
		for(i=0;i<4;i++)
			par_position(rd_cmd_wd(21+i), &src_edge[i]);
	else 
		for(i=0;i<4;i++)
			par_position(0, &src_edge[i]);

	// edge 의 위치를 정렬.
	// vertical position이 위쪽인 point를 첫번째 edge로 결정.
	sort_edges();

	//-----------------------------------------------
	// line pattern
	if(cmd_kind == LINEDRW) {
		line_pattern = rd_cmd_wd(10);
		// line pattern position을 보정.
		line_pat_pos(&lpat_pos, line_num, se_exc, sort_edge, line_width);
	}
	else {
		line_pattern = 0;
		lpat_pos = 0;
	}

	// line drawing에서 첫번째 line 정보의 시작위치 지정.
	// drawing할 line의 개수를 set.
	if(cmd_kind == LINEDRW) {
		line_pnt = 11 - 3; // offset. 
		// +3후에 parameter를 읽기 때문에 3 작은 값으로 setting한다.

		line_num = rd_cmd_wd(0) & (0x0ff<<16); // line 개수.
	}
	else {
		line_pnt =  0;
		line_num = 0;
	}
	line_cnt = 0; // initial.

	//------------------------------------------------
	// rotate 삼각함수.
	if(cmd_kind == ROTDRW) {
		cos_int = 0x0ffff & rd_cmd_wd(18);
		if(cos_int & 0x08000) cos_int |= 0xffff0000; // sign extension

		sin_int = 0x0ffff & (rd_cmd_wd(18) >> 16);
		if(sin_int & 0x08000) sin_int = 0xffff0000 | sin_int;
	}
	else {
		sin_int = 0;
		cos_int = 0;
	}

	//------------------------------------------------
	// color convert 
	if(cmd_kind == CCONV) {
		ccnv_form = rd_cmd_wd(10) & 0x03ff;
		b_pos = 3 & (rd_cmd_wd(10) >> 16);
		g_pos = 3 & (rd_cmd_wd(10) >> 18);
		r_pos = 3 & (rd_cmd_wd(10) >> 20);
	}
	else {
		ccnv_form = 0;
		r_pos = 0;
		g_pos = 0;
		b_pos = 0;
	}

	return SUCC;
} // get_info(void)


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

	if(pat == USE_PALETTE) // a pattern does not have a palette
		pic->palette = rd_cmd_wd(cmd_off+3);
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
		printf("\n ERROR : invalie color type %x at get pic infor.", dst_pic_info.type);
		exit(0);
	} // switch

	return SUCC;
} // get_pic_info





