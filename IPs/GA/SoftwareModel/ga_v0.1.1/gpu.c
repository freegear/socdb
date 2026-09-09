
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
uint     bline_circle;  // beeline or circle
int      bline_dv;      // beeline virtical 증가량.
int      bline_dh;      // beeline horizontal 증가량.
int      bline_sslop;   // the sign of a beeline slop // 0/-1
uint     circle_dir;    // circle direction
int      circle_case;   // circle의 종류.
uint     anti_alias;    // anti-aliasing
int      se_exc;        // start/end position exchange. line의 시작점이 끝점보다 아래 있을때 active.
int      lpat_pos;      // line pattern position. 다음에 적용할 pattern steam에서 위치.
int      pat_attr;      // pattern attribute. visual/invisual
int      rest_pat_px;   // rest pattern pixel count. clear at line drawing command
//                           다음 line에 pattern을 이어 그리기 위한 변수.
//                           line의 끝에서 유효.
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
pos      sort_edge[4];
int      max_vpos; // edge 중 가장 큰 vertical position
//                    drawing end 조건 검사에 사용.

// circle에서 line의 pattern을 적용하기 위한 변수.
// pattern에 의한 beeline의 정보.

// line estimation에 사용할 information structure
// 이 정보를 이용하여 hrange를 계산.
bline_info    bline_i[2];
cicle_info    circle_i[2];

// line pattern에 의해서 중단되었던 point의 position.
// pattern에 의한 영역 하나를 다 drawing하면 next_st_pos에서 
// 재 시작. line을 변경할때 저장.
bline_info    next_st_pos;

int       now_vpos;  // 현재 drawing하고 있는 vertical position

// horizontal range
pos       hrange[4];

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
	int    i;
	int    buff_st_pos; // start position of the buffer 
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
	case GET_CMD_INFO :
		// get picture informations
		//    command structure에 있는 picture 정보를 적당한 variable에 복사.
		get_cmd_info();
		
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

			gpu_proc = WAIT_LINE_PARAM;
		} // if
		else { // other command
			
			gpu_proc = AREA_FIRST; // jump
		}
		break;
	case WAIT_LINE_PARAM : // wait rest command load
		// memory operation이 완료되어 buffer가 fill되면 다음으로 진행.
		if(chk_op() == 0) gpu_proc = LINE_EDGE;
		break;
	case GET_LINE_INFO :
		get_line_info();

		gpu_proc = CHK_IN_BUFF;
		break;
	case LINE_EDGE : // v. Line의 width를 고려하여 drawing area결정
		     //   1. Line의 외각 edge를 결정.
             //   2. Circle인지 beeline인지에 따라 별도의 함수 호출.

		// drawing할 area의 edge point 추출.
		// command마다 다르게 추출.
		if(cmd_kind == LINEDRW) {
			// line drawing일 경우 
			// memory operation이 완료되면 진행. 아니면 return
			//    line width적용.
			search_edges(sort_edge);
		}
		
		//---------------------------
		//  get maximum vertical position
		max_vpos = sort_edge[0].v;
		for(i=1;i<4;i++) 
			if(sort_edge[i].v > max_vpos) max_vpos = sort_edge[i].v;
		//---------------------------
				
		gpu_proc = CHECK_NEXT_LINE;
		break;
/**********************************
	case AREA_FIRST :
		first_edge_param( bline_i, next_st_pos, circle_i, sort_edge,
						  bline_circle, bline_sslop, circle_case,
						  line_pattern, lpat_pos, se_exc, line_width, 
						  cmd_kind);
		
		// need : 수평선일 때, line information 수정.
		//        first_edge_param에 추가해도 됨.

		// Line Estimation parameter 설정.
		pre_hrange(bline,circle,beeline_pm,circle_pm,anti_alias);
**********************************/


	case CHECK_NEXT_LINE :  // include line의 끝을 검사. 
		break;

	case LINE_PARAM : // Setting line parameter
		// now_vpos을 initial.



		
	case LINE_ESTIMATE :  // horizontal range estimation
		// line의 horizontal position을 계산.
		next_bline();
		circle_est();
		
		// 유효한 horizontal position을 추출.
		get_hrange();

		gpu_proc = CHK_DRAW_AREA;
		break;
	case CHK_DRAW_AREA :	

	case DRAW_HLINE :
		// wait end of a drawing h.line
		

	default : // end command. close command and prepare next instruction
		//if rest line, command check and jump get_line_info

		
		break;
	} // switch
	
} // gpu






//======================================================
// picture정보를 command structure에서 register로 복사.

int get_cmd_info(void)
// return : SUCC/FAIL
{
	uint    command;
	int     i;

	cmd_kind = rd_cmd_kind(); //read rest command에서 set
	
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


	//-----------------------------------------------
	// line pattern
	if(cmd_kind == LINEDRW) {
		line_pattern = rd_cmd_wd(10);
		// line pattern position을 보정.
	}
	else {
		line_pattern = -1;
	}

	lpat_pos = 0;
	rest_pat_px = 0;
	pat_attr = line_pattern & 1;

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


// multi line에서만 사용될 변수 초기화.
int get_line_info(void)
{

	// edge 의 위치를 정렬.
	// vertical position이 위쪽인 point를 첫번째 edge로 결정.
	sort_edges();  // dst_edge --> sort_edge

	if(cmd_kind == LINEDRW) {
		// beeline slope
		bline_dh = sort_edge[1].h - sort_edge[0].h;
		bline_dv = sort_edge[1].v - sort_edge[0].v;
	
		bline_sslop = ((bline_dh * bline_dv) >= 0)? 1 : 0;

		line_pat_pos(&lpat_pos, line_num, se_exc, sort_edge, line_width);
	}

	//---------------------------------------------------
	// new vertical position initial
	now_vpos = 1-2048; // initial to minimum
	
	// clear structures
	for(i=0;i<2;i++) {
		bline_i[i].en = 0;
		circle_i[i].en = 0;

		beeline_pm[i*2] = 0;
		beeline_pm[i*2+1].en = 0;
		circle_pm[i].en = 0;
		beeline_bk[i*2].en = 0;
		beeline_bk[i*2+1].en = 0;
	}
	next_st_pos.en = 0;
	
}



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


//---------------------------------------------------------
//
void chk_next_line(int *proc, int *state)
// proc : now process state
// state : LINE PARAM process를 위해서 원인을 알려주기 위한 변수.
{
	int i;

	// update the now vertical position 
	if(chk_vline_area(max_vpos,now_vpos) == END) // end drawing
		*proc = _DEFAULT_;
	else {
		// need check the end of a line
		if(now_vpos < edges[0].v) {  // at first line
			now_vpos = edges[0].v;
			*state = NEW_DRAW;
			*proc = LINE_PARAM;
		}
		else if(chk_stop_pos(bline_i,circle_i,now_vpos) == SUCC) {
			*state = NEW_LINE;
			*proc = LINE_PARAM;
		}
		else if(chk_hline_area(hrange)== END) { // one area is ended.
			*state = NEW_AREA;
			*proc = LINE_PARAM;
		}
		else {
			now_vpos ++; // change to the next vertical line
			*proc = LINE_ESTIMATE; // move to check next line pattern
		}
	} // chk_next_line
}

/**********************************************
//-------------------------------------------------------
// Generate H.Range edge information

int gen_line_info(int state, bl_param *bline_p, cl_param *circle_p,
				  bline_info *bline_i, bline_info *next_bl,
				  cicle_info *circle_i,
				  int *now_vpos, pos *edges)
// state : estimation state. parameter setting을 어떻게 할지 선택.
//         first estimation or change line or change area
// bline_p : beeliine estimation parameter.
// circle_p : circle estimation parameter.
// bline_i : beeline information. updated
// next_bl : beeline information backup. updated
// circle_i : circle information. updated
// now_vpos : 현재 처리하고 있는 vertical position. updated
// edges : for drawing area.

// return : SUCC/FAIL
{
	int     lpat_en;
	int     llpos_v, llpos_i;  // length line pattern visable, invisable

	// line pattern 유효 체크.
	if(cmd_kind == LINEDRW && line_pattern != 0xffffffff)
		lpat_en = 1;
	else lpat_en = 0;

	//check the start position from a top position
	
	

	llen = calc_ptn_len( lpat_pos, lppos, se_exc);
	llen *= line_width;


	// backup beeline information
	backup_line_info(state, lpat_en);
	
	


	// beeline : left side
	
	
	


	// now vertical line update.
	if(state == NEW_LINE)
		*now_vpos ++; // line을 변경하면 필요에 따라 수행할 수 있다.

}


//------------------------------------------------------
// backup beeline information for line pattern drawing
//    line pattern에 의해서 구분되는 영역을 drawing할때,
//    다음 line area를 drawing할때 사용하기 위해서 잠시
//    별도의 장소에 line information을 저장.

int  backup_line_info(int state, int lpat_en)
// state   : estimation state. parameter setting을 어떻게 할지 선택.
// lpat_en : line pattern enabled.
// return : SUCC/FAIL
//          FAIL이면 backup을 하지 않았음을 의미.
{
	int      i;


	if(lpat_en == 0) {
		next_st_pos.en = 0;
		return FAIL;
	}
	
	// line pattern 경계 백업 
	if(state == NEW_LINE && bline_circle == 0) { // if beeline
		if(bline_dv != 0) { // 수평선 --> 백업할 필요 없다. 새로 생성하면 된다.
			for(i=0;i<2;i++) {
				if(bline_i[i].sp_pos == now_vpos && 
				   bline_i[i].ed_pos != bline_i[i].sp_pos) {
					mv_bline(next_st_pos[i], bline[i]);   // copy information
					return SUCC;
				} // if
			} // for
		} // if
	} // if
	return FAIL;
}
 ***************************************************************/

//------------------------------------------------------
// Set Line parameter
// beeline left side.

 int bl_left(int state, int lpat_en, int llen)
// state   : estimation state. parameter setting을 어떻게 할지 선택.
// lpat_en : line pattern enabled.
// llen    : line pattern length
// return : SUCC/FAIL
{
	int          i;

	
	
	// enable and update signals.
	if( bline_circle == 1 ) { // if circle
		if(lpat_en == 0) {    // no line pattern
			if(now_vpos == sort_edge[0].v || 
			   (circle_case == 2 && now_vpos == sort_edge[3].v))
				bline_i[0].en = 0;
			else
				bline_i[0].en = 1;
		} // if
		else { // line pattern is enabled
			if( (circle_case == 3 && now_vpos == sort_edge[0].v) ||
				(circle_case == 2 && now_vpos == sort_edge[3].v) )
				bline_i[0].en = 0;
			else bline_i[0].en = 1;
		} // else
	} // if
	else { // if beeline
		bline_i[0].en = 1;
	} // else
	

	// start and end positions
	if(sort_edge[0].v == now_vpos) { // if top
		bline_i[0].update = 1;

		bline_i[0].st_pos.v = sort_edge[0].v;
		bline_i[0].st_pos.h = sort_edge[0].h;

		// end position
		if(sort_edge[0].pos.v == sort_edge[3].v &&
		   sort_edge[0].pos.h == sort_edge[3].h) { // if tri-angle
			bline_i[0].ed_pos.v = sort_edge[2].v;
			bline_i[0].ed_pos.h = sort_edge[2].h;
		} // if
		else { // rectangle or circle
			bline_i[0].ed_pos.v = sort_edge[3].v;
			bline_i[0].ed_pos.h = sort_edge[3].h;
		} // else

		// stop position
		if(lpat_en == 0) {
			bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
			bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
		} // if
		else {
			

		} // else

	} // if
	else if(bline_i[0].sp_pos.v == now_vpos) { // vertical stop conditionc
		// if stop position is same as end position, 
		//          end of the one line then, start the next line.
		// if stop position is difference with end position, 
		//          pattern의 경계에 도달. pattern에 의한 경계선으로 전환.
		bline_i[0].update = 1;

		// set new start position
		bline_i[0].st_pos.v = bline_i[0].sp_pos.v;
		bline_i[0].st_pos.v = bline_i[0].sp_pos.v;

		if(bline_i[0].sp_pos.v == bline_i[0].ed_pos.v) {
			// edge에서 현재 point를 검색.
			for(i=0;i<4;i++) {
				if((bline_i[0].sp_pos.v == sort_edge[i].v) &&
				   (bline_i[0].sp_pos.h == sort_edge[i].h)) break;
			}
			if(i == 4) {
				printf("\n ERROR : Cannot find edge point at Beeline 0");
				exit(0);
			}
			
			// new end position
			i --;    // set end position
			i %= 3;  // rotation
			
			bline_i[0].ed_pos.v = sort_edge[i].v;
			bline_i[0].ed_pos.h = sort_edge[i].h;
			
			// set stop position
			bline_i[0].sp_pos.v = sort_edge[i].v;
			bline_i[0].sp_pos.h = sort_edge[i].h;
			
			// slope
			bline_i[0].dv = bline_i[0].sp_pos.v - bline_i[0].st_pos.v;
			bline_i[0].dh = bline_i[0].sp_pos.h - bline_i[0].st_pos.h;
		}
		else {  // pattern boundary. only a line drawing

			// backup beeline information and parameter
			mv_bline(next_st_pos, bline[0]);
			//mv_bl_param(beeline_bk[0], beeline_pm[0]);
			//mv_bl_param(beeline_bk[1], beeline_pm[1]);

			// vertual stop position 
			bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
			bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
			
			// invese slope
			int     dtmp;
			
			dtmp = bline_i[0].dv;
			bline_i[0].dv = bline_i[0].dh;
			bline_i[0].dh = dtmp;
		}
	} // else if
	else if(state == NEW_AREA){ // end drawing area
		// skip invalid pattern 
		
		
		if(bline_dh == bline_dv) {
			




		} // if
		else {





		} // else
		
	} // else NEW_AREA

	// stop 


	
}


// beeline right side.
int bl_right()
{



}


// circle left side
int cl_left()
{



}


// circle right side
int cl_right()
{



}
