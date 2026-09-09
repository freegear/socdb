/*************************************************************************

   Graphic sub-processor

   file name : gpu.c
   created by gtlee
   data : 2006.7.4

   note :
        emulation the function of the v8 processor

   history :
       2006.9.4 version 0.2

************************************************************************/


#ifndef    __GPU__
#define    __GPU__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "gbus.h"
#include "cmd_buff.h"
#include "line_param.h"
#include "hrange.h"
#include "line.h"

#include "gpu.h"

//----------------------------------------------------
// global variables



//=======================================
// Command parameters
uint     cmd_kind;

// picture and pattern information
s_pic    dst_pic_info;  // destination picture
s_pic    dst_pat_info;
s_pic    src_pic_info;  // source picture
s_pic    src_pat_info;
s_pic    dpt_pat_info;  // drawing pattern. for brush

s_pic    dst_msk_info;  // destination masking pattern
s_pic    src_msk_info;  // destination masking pattern

overlay  alpha_rater;   // overlay parameter

// for line drawing
int      line_pnt;      // line pointer. command buffer에서 다음에 처리해야 할 line정보의 offset.
int      line_num;      // drawing할 line의 개수.
int      line_cnt;      // drawing한 line의 개수.
uint     line_pat_for;  // forward line pattern
uint     line_pat_rev;  // reverse line pattern
uint     line_pattern;  // line의 pattern. drawing에서 사용되는 변수.

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
                        // sort_edges에서 결정.
int      line_len;      // init line length. circle의 경우에는 현재까지의 line길이.
                        // beeline : 감소하는 방향. init = length
                        // circle : 증가하는 방향. init = 0
int      lpat_pos;      // line pattern position. 다음에 적용할 pattern steam에서 위치.
int      pat_len;       // 현재 drawing할 pattern의 길이.
int      pat_attr;      // pattern attribute. visual/invisual
int      rest_pat_px;   // rest pattern pixel count. clear at line drawing command
//                           다음 line에 pattern을 이어 그리기 위한 변수.
//                           line의 끝에서 유효.
// line pattern을 적용할 때, line의 끝점이 위에 있으면, 끝점부터 그린다.
// 따라서, 이런 경우에는 line의 마지막 pattern의 위치를 계산하여 뒤에서부터 적용한다.
// line의 시작위치가 위에 있으면, lpat_pos을 증가시키며 그리고, line의 시작위치가
// 아래에 있으면, line의 마지막 lpat_pos을 계산하고 뒤에서부터 그린다.
// line drawing이 완료되면 다음 line의 pattern시작위치를 재계산한다.
int      lpat_pos_bk; // next line pattern position backup
int      pat_attr_bk; // next line pattern의 종류를 백업.
int      rest_pat_bk; // next line pattern의 길이 백업.

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
circle_info   circle_i[2];

// line pattern에 의해서 중단되었던 point의 position.
// pattern에 의한 영역 하나를 다 drawing하면 next_st_pos에서 
// 재 시작. line을 변경할때 저장.
bline_info    next_st_pos;

int       now_vpos;  // 현재 drawing하고 있는 vertical position
int       pre_vpos;  // previous vertical position for circle drawing

// horizontal range
//    beeline 2개, circle 2개.
int       hrange[4]; // 각 line의 horizontal position
int       eff_hrange[2]; // effective line의 종류를 저장. beeline : 0, circle : 1
int       eff_hrange_old[2]; // 이전 vertical line의 effective line의 종류.

//=======================================





//==================================================
// GPU processing

// drawing할 hrange를 계산하고 drawing이 완료 될때까지 기다림.
// drawing은 gpu function을 종료하고 상위에서 호출.

int    gpu_proc = 0; // gpu의 현재 process
                     // first command load, rest command load
                     // process번호는 gpu.h에서 define
int    state;

void gpu(void)
{
	int    i;
	int    buff_st_pos; // start position of the buffer 
                      // line drawing command의 남은 부분을 load할
                      // 시작 offset.

	switch(gpu_proc) {
	case PROC_GET_QUEUE :
		if(set_cmd_pnt() == FAIL) return ; // no command
		gpu_proc = RD_8_CMD;

	case RD_8_CMD :
		// read 8 command words
		rd_cmd_fst();
		gpu_proc = WAIT_BUS_8;
		break;
	case WAIT_BUS_8 : 
		// wait the end of bus operation
		if(chk_op(CMD_STR) == 0) gpu_proc = WAIT_BUS_REST;
		break;
	case RD_REST_CMD :
		// read rest command words
		set_nxt_cmd();
		rd_cmd_rest();
		gpu_proc = WAIT_BUS_REST;
		break;
	case WAIT_BUS_REST : 
		// wait the end of bus operation
		if(chk_op(CMD_STR) == 0) gpu_proc = GET_CMD_INFO;
		break;
	case GET_CMD_INFO :
		// get picture informations
		//    command structure에 있는 picture 정보를 적당한 variable에 복사.
		get_cmd_info();
		
		break;

	case CHK_IN_BUFF : // check line command in buffer
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
			
			gpu_proc = INIT_LINE_INFO; // jump
		}
		break;
	case WAIT_LINE_PARAM : // wait rest command load
		// memory operation이 완료되어 buffer가 fill되면 다음으로 진행.
		if(chk_op(CMD_STR) == 0) gpu_proc = INIT_LINE_INFO;
		break;
	case INIT_LINE_INFO :
		init_line_info_();

		//  get maximum vertical position
		get_max_vpos();
				
		gpu_proc = CHECK_NEXT_LINE;
		break;

	case CHECK_NEXT_LINE :  // include line의 끝을 검사. 
		pre_vpos = now_vpos; // set previous vertical position
		
		chk_next_draw(&gpu_proc,&state);
		if(gpu_proc == LINE_ESTIMATE) {
			now_vpos ++;
			// now_vpos을 initial.
		}
		else if(gpu_proc != CHK_LINE_CMD && state != FIRST_DRAW) {
			if(NEW_AREA) now_vpos = set_new_vpos(now_vpos);
			else 	 now_vpos ++;
		}
/*      // org
		if(gpu_proc == LINE_ESTIMATE) {
			now_vpos ++;
			// now_vpos을 initial.
		}
		else if(gpu_proc == CHK_LINE_CMD) {
			gpu_proc = CHK_LINE_CMD;
		}
		else if(state == FIRST_DRAW) {
			gpu_proc = SET_PARAM;
			// no need that modify vertical position
		}
		else {
			if(NEW_AREA) now_vpos = set_new_vpos(now_vpos);
			else 	 now_vpos ++;
			gpu_proc = SET_PARAM;
		}
*/
		break;

	case SET_PARAM : // Setting line parameter
		if(set_parameter(state) == 1) gpu_proc = CHK_LINE_CMD;
		else gpu_proc = LINE_ESTIMATE;
		break;

	case LINE_ESTIMATE :
		str_vpos_circle();
		
		// estimation horizontal range
		get_estimation(bline_i, circle_i, hrange, eff_hrange);

		gpu_proc = CHK_DRAW_AREA;
		break;

	case CHK_DRAW_AREA :	
		if(chk_draw() == DRAW) gpu_proc = DRAW_HLINE;
		else gpu_proc = CHECK_NEXT_LINE;
		break;

	case DRAW_HLINE :
		// wait end of a drawing h.line
		
		

		gpu_proc = CHECK_NEXT_LINE;
		break;

	case CHK_LINE_CMD : // 더 그려야 할 poly line이 있는지 확인.
		if(cmd_kind == LINEDRW && line_cnt <= line_num) {
			lpat_pos = lpat_pos_bk;
			pat_attr = pat_attr_bk;
			rest_pat_px = rest_pat_bk;

			gpu_proc = CHK_IN_BUFF;
		}
		else gpu_proc = _DEFAULT_;
		break;

	default : // end command. close command and prepare next instruction
		gpu_proc = PROC_GET_QUEUE;
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
	pos     src_size;

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
		dst_pat_info.palette = 0;
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
		src_pat_info.palette = 0;
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
		src_pat_info.palette = 0;
	} // else

	// (drawing) brush pattern
	if(cmd_kind == BLTDRW) {
		//get_pic_info(&dpt_pic_info, 26, NO_PALETTE);
		dpt_pat_info.maxx = rd_cmd_wd(27) & 0x0fff;
		dpt_pat_info.maxy = (rd_cmd_wd(27)>>16) & 0x0fff;
		dpt_pat_info.type = MONO;
		dpt_pat_info.addr = rd_cmd_wd(28);
		dpt_pat_info.palette = 0;
	}
	else if(cmd_kind == FILLDRW && 
			((rd_cmd_wd(0)>>16)&0x03) ) {
		//get_pic_info(&dpt_pic_info, 14, NO_PALETTE);
		dpt_pat_info.maxx = rd_cmd_wd(16) & 0x0fff;
		dpt_pat_info.maxy = (rd_cmd_wd(16)>>16) & 0x0fff;
		dpt_pat_info.type = MONO;
		dpt_pat_info.addr = rd_cmd_wd(17);
		dpt_pat_info.palette = 0;
	}
	else {
		dpt_pat_info.maxx = 0;
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

	switch(cmd_kind) {
	case FILLDRW :
		switch((rd_cmd_wd(0) >> 16)&0x3) {
		case FILL_PAINT :
			fore_color = rd_cmd_wd(14);
			back_color = 0;
			break;
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

	//------------------------------------------
	// get destination edge position information
	switch(cmd_kind) {
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
		// calc destination edge position
		src_size.h = src_pic_info.maxx;
		src_size.v = src_pic_info.maxy;
		rotate_edges(dst_edge[0], src_size, sin_int, cos_int, &dst_edge);
		break;
	default :
		for(i=0;i<4;i++)
			par_position(0, &dst_edge[i]);
	} // switch

	
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
		line_pat_for = rd_cmd_wd(10);
		// line pattern position을 보정.
	}
	else {
		line_pat_for = -1; // 모든 bit을 1로.
	}
	
	// generate reversed line pattern.
	line_pat_rev = reverse_pat(line_pat_for);

	lpat_pos = 0;
	rest_pat_px = 0;
	pat_attr = line_pat_for & 1;

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
} // get_cmd_info


//------------------------------------------------------
// multi line에서만 사용될 변수 초기화.
int init_line_info_(void)
{
	uint      pat_tmp;
	int       len_v;
	int       len_h;
	int       i;

	// edge 의 위치를 정렬.
	// vertical position이 위쪽인 point를 첫번째 edge로 결정.
	sort_edges();  // dst_edge --> sort_edge

	if(cmd_kind == LINEDRW) {
		line_cnt ++;

		if(bline_circle == BEELINE) { // beeline
			// beeline slope
			bline_dh = sort_edge[1].h - sort_edge[0].h;
			bline_dv = sort_edge[1].v - sort_edge[0].v;

			bline_sslop = ((bline_dh * bline_dv) >= 0)? 1 : 0;
		} // beeline
		else { // circle
			bline_dh = 0;
			bline_dv = 0;

			bline_sslop = 0;
		} // circle
		
		if(se_exc == 1)  // exchange line pattern
			line_pattern = line_pat_rev;
		else line_pattern = line_pat_for;

		//---------------------------------
		// Line의 width를 고려하여 drawing area결정
		//   1. Line의 외각 edge를 결정.
		//   2. Circle인지 beeline인지에 따라 별도의 함수 호출.
		search_edges(sort_edge);

		//---------------------------------
		// set line length
		if(bline_circle == BEELINE) // beeline
			set_bline_len();
		else // circle 
			set_circle_len();


		// line pattern 정보 처리.
		//    next line에서 사용할 rest pattern length와 pattern attribute, 
		//    next pattern position설정.
		//    reverse drawing일때, drawing정보를 line의 끝으로 설정하여 
		//    뒤에서 부터 pattern을 설정할 수 있도록 준비.
		//    rest pattern length가 line length보다 클때도 고려.
		line_pat_corr();
		
	}

	//---------------------------------------------------
	// new vertical position initial
	now_vpos = 1-2048; // initial to minimum
	
	// clear structures
	for(i=0;i<2;i++) {
		bline_i[i].en = 0;
		circle_i[i].en = 0;
	}
	next_st_pos.en = 0;
} // init_line_info_






//------------------------------------------------------
// get max vertical position
void get_max_vpos(void)
{
	int i;

	//--------------------------------------
	max_vpos = sort_edge[0].v;
	for(i=1;i<4;i++) 
		if(sort_edge[i].v > max_vpos) 
			max_vpos = sort_edge[i].v;
} // get_max_vpos







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
		printf("\n ERROR : invalide color type %x at get pic infor.", dst_pic_info.type);
		exit(0);
	} // switch

	return SUCC;
} // get_pic_info







//=======================================================
//
void chk_next_draw(int *proc, int *state)
// proc : now process state
// state : LINE PARAM process를 위해서 원인을 알려주기 위한 변수.
{

  // need check the end of a line
  if(now_vpos < sort_edge[0].v) {  // at first line
	  now_vpos = sort_edge[0].v;
	  *proc = SET_PARAM;
	  *state = FIRST_DRAW;
  }
  else { 
	  if(chk_end_draw() == SUCC) {
		  *proc = CHK_LINE_CMD;
		  *state = NEW_AREA;
	  }
	  else if(chk_next_area() == SUCC) { // one area is ended.
		  *proc = SET_PARAM;
		  *state = NEW_AREA;
	  }
	  else if(chk_next_line() == SUCC) {
		  *proc = SET_PARAM;
		  *state = NEXT_LINE;
		  }
	  else {
		  *proc = LINE_ESTIMATE; // move to check next line pattern
		  *state = EST_LINE;
	  }
  }
} // chk_next_draw







//-------------------------------------------------------
// 하나의 line이나 command가 완료됨을 검사
int chk_end_draw(void)
// return : SUCC/FAIL. if drawing end, return SUCC.
{
	int i;
	
	
	if(now_vpos >= max_vpos) { // now_vpos을 증가시키기 전이므로 같을때도 종료조건이 된다.
		// search stop position
		if(cmd_kind != LINEDRW || line_pattern != 0xffffffff)
			return SUCC;

		// pattern이 있는 line의 경우에는 next area가 존재할 수 있다.
		for(i=0;i<2;i++) {
			if(bline_i[i].en == 1 &&
			   now_vpos == bline_i[i].sp_pos.v) {
				if(bline_i[i].sp_pos.v != bline_i[i].ed_pos.v ||
				   bline_i[i].sp_pos.h != bline_i[i].ed_pos.h)
					return FAIL; // need next area
			} // if beeline
			/*
			  // circle은 stop position이 별도로 존재하지 않으므로 사용하지 않는 코드이다.
			if(circle_i[i].en == 1 &&
			   now_vpos == circle_i[i].sp_pos.v) {
				if(circle_i[i].sp_pos.v != circle_i[i].ed_pos.v ||
				   circle_i[i].sp_pos.h != circle_i[i].ed_pos.h)
					return FAIL; // need next area
			} // if circle
			*/
		} // for
		return SUCC;
	}

	return FAIL;
} // chk_end_draw






//------------------------------------------------------
// line pattern에 의한 한 영역의 drawing의 완료를 검사 
int chk_next_area(void)
// return : SUCC/FAIL
{
	int      i;

	// if left position is greater then the right position
	// available only circle drawing
	if(hrange[(eff_hrange[0])&1] > hrange[2+(eff_hrange[1]&1)]) return SUCC;
	
	if(now_vpos >= max_vpos) {
		// pattern이 있는 line의 경우에는 next area가 존재할 수 있다.
		for(i=0;i<2;i++) {
			if(bline_i[i].en == 1 &&
			   now_vpos == bline_i[i].sp_pos.v) {
				if(bline_i[i].sp_pos.v != bline_i[i].ed_pos.v ||
				   bline_i[i].sp_pos.h != bline_i[i].ed_pos.h)
					return SUCC; // goto next area
			} // if beeline
			/*
			if(circle_i[i].en == 1 &&
			   now_vpos == circle_i[i].sp_pos.v) {
				if(circle_i[i].sp_pos.v != circle_i[i].ed_pos.v ||
				   circle_i[i].sp_pos.h != circle_i[i].ed_pos.h)
					return SUCC; // goto next area
			} // if circle
			*/
		} // for
	} // if

	return FAIL;
} // chk_next_area





//------------------------------------------------------
// line 전환을 검사
int chk_next_line(void)
// return : SUCC/FAIL
{
	int      i;
	
	// if change a effective line
	// available only circle drawing
	for(i=0;i<2;i++) {
		if(eff_hrange[i] != eff_hrange_old[i]) return SUCC;
	}
	
	// line의 stop position이 도달했는지 검사.
	for(i=0;i<2;i++) {
		if(bline_i[i].en == 1 &&
		   now_vpos == bline_i[i].sp_pos.v) {
			return SUCC; // need next area
		} // if beeline
		if(circle_i[i].en == 1 &&
		   now_vpos == circle_i[i].ed_pos.v) {
			return SUCC; // need next area
		} // if circle
	} // for
	return  FAIL;
} // chk_next_line



//========================================================
// New area의 시작 위치를 결정. err
int set_new_vpos(int vpos)
// return : 새로운 vertical position
{
	if(bline_circle == BEELINE) { // beeline
		if(bline_dh == 0) { // 수직선
			return (vpos+1);
		}
		else {
			return next_st_pos.sp_pos.v;
		}
	}
	else { // circle
		if(circle_i[0].en == 0 || circle_i[1].en == 0)
			return sort_edge[0].v;
		else if(circle_i[0].sp_vpos >= circle_i[1].sp_vpos)
			return circle_i[1].sp_vpos;
		else return circle_i[0].sp_vpos;
	}
} // set_new_vpos








//========================================================
// Set Line parameter


int set_parameter(int state)
// state : new area인지 new line인지 구분
// return : next process code. <-- no use
//          if 1, goto end drawing line command
//          if 0, goto line estimation
{
	int   nxt;

	if(state == NEW_AREA || state == FIRST_DRAW)
		nxt = set_new_area(state);
	else if(state == NEXT_LINE) {
		set_new_line();
		nxt = 0;
	}
	else { // error
		printf("\n ERROR : invalid state code.");
		exit(0);
	}

	return nxt;
} // set_parameter





//-------------------------------------------------------
// if New Area

int set_new_area(int state)
// state : drawing case를 알려줌.
// return : next process code. <-- no use
//          if 1, goto end drawing line command
//          if 0, goto line estimation
{

	//--------------------------------------
	// beeline
	if(bline_circle == BEELINE) {
		if(line_pattern == 0xffffffff) {
			// yes
			rest_pat_px = abs(rest_pat_px);

			if(rest_pat_px > 0) { // yes
				set_rest_pat();
				pat_len = rest_pat_px;
				rest_pat_px = 0;
			}
			else pat_len = 0;

			while(1) {
				if(pat_len == 0) { // no rest pattern length
					pat_attr = 1&(line_pattern >> lpat_pos);
					pat_len = calc_ptn_len(line_pattern,&lpat_pos);
					if(pat_len > line_len) {
						pat_len = line_len;
					}
				}
				line_len -= pat_len;

				if(pat_attr != 0) break; // if visible, exist
				
				// if invisible pattern
				if(line_len <= 0) return 1;
				
				// stop position 이동
				mv_stop_pos(&bline_i[0],pat_len);
				mv_stop_pos(&bline_i[1],pat_len);
			}
			
			// check pattern boundary
			if(state == FIRST_DRAW) {
				set_first_draw(); // 2006.9.7
			}
			else if(state = NEW_AREA) {
				set_new_bline_area();
			}
			else {
				// ERROR
				printf("\n ERROR : error drawing state code %d.",state);
				exit(0);
			}

		} // if pattern
		else { // no pattern
			set_no_pattern();
		}
	} // if beeline
	//--------------------------------------
	// circle
	else {
		if(line_pattern != 0xffffffff) {
			// with pattern
			if(now_vpos == sort_edge[0].v ) { // first drawing
				if(rest_pat_px > 0) { // yes
					pat_len = rest_pat_px;
					rest_pat_px = 0;
				}
				else { // no
					pat_attr = 1&(line_pattern >> lpat_pos);
					pat_len = calc_ptn_len(line_pattern, &lpat_pos);
					if(pat_len > line_len) { // 남은 line의 길이가 작을 때
						pat_len = line_len;
					}
				}
				line_len -= pat_len;
				// goto no pattern
			} // if first drawing
			else { // new area
				pat_attr = 1&(line_pattern >> lpat_pos);
				pat_len = calc_ptn_len(line_pattern,&lpat_pos);
				if(pat_len > line_len) { // 남은 line의 길이가 작을 때
					pat_len = line_len;
				}
				line_len -= pat_len;
				
				if(line_len <= 0 && pat_attr == 0) return 1;
				
				set_new_circle();
			} // else new area
		} // if pattern

		// first drawing시에는 이전에 처리해야할 것이 있으므로 
		// 아래 block이 뒤에 위치하게 된다.
		if(line_pattern != 0xffffffff ||
		   now_vpos == sort_edge[0].v ) {
			// no pattern or first drawing
			set_first_np_circle();
		} // if no pattern
	} // circle
	return 0;
} // set_new_area



//-------------------------------------------------------
// if New Line

void set_new_line(void)
{
	int    line_side; // line side. left/right
	int    stop_edge; // stopped edge number

	if(bline_circle == BEELINE) { // beeline
		for(line_side=0;line_side<2;line_side++) {
			//  stop position과 현재 position이 일치하는 line을 검색
			if(bline_i[line_side].en == 1 && 
			   now_vpos == bline_i[line_side].sp_pos.v) { // stop position에 도달한 line

				if(bline_i[line_side].sp_pos.v == bline_i[line_side].ed_pos.v &&
				   bline_i[line_side].sp_pos.h == bline_i[line_side].ed_pos.h) { // yes
					for(stop_edge=0;stop_edge<4;stop_edge++) {
						if(bline_i[line_side].sp_pos.v == sort_edge[stop_edge].v &&
						   bline_i[line_side].sp_pos.h == sort_edge[stop_edge].h)
							break; // if match
					} // for. search edge
					if(stop_edge == 4) { // 일치하는 edge가 존재하지 않을 경우 error
						printf("\n Error : no matched edge point.");
						exit(0);
					}
					set_bline_edge(line_side, stop_edge);
				} // stop == end
				else { // no. stop != end
					if((bline_i[line_side].dh >=0 && bline_sslop >= 0) ||
					   (bline_i[line_side].dh < 0 && bline_sslop < 0)) { // same slope
						// backup beeline information
						mv_bline(&bline_i[line_side], &next_st_pos);
					} // if. backup beeline info.
					set_bline_pat(line_side);
				} // no. stop != end

			} // now == stop
		} // for
	} // if. beeline
	else { // circle
		left_new_circle();
		right_new_circle();
	}// else. circle
} // set_new_line





//----------------------------------------------------
void left_new_circle(void)
{
	int   line;
	
	int   en;
	int   vpos;

	if(eff_hrange_old[0] != eff_hrange[0]) { // change effective line
		// check previous effective line
		if(eff_hrange[0] == 1) { // change to circle
			bline_i[0].en = 0;  // disable
			circle_i[0].en = 1; // enable
		} // if. change to circle
		else { // change to beeline
			bline_i[0].en = 1;  // enable
			// backup beeline information
			mv_bline(&bline_i[0], &next_st_pos);
			circle_i[0].en = 0; // disable
		} // else. change to beeline
	} // if. change effective line
	else { // no change effective line
		for(line=0;line<2;line++) {
			//  stop position과 현재 position이 일치하는 line을 검색
			if(line == 0) { // beeline
				en = bline_i[0].en;
				vpos = bline_i[0].sp_pos.v;
			}// beeline
			else { // circle
				en = circle_i[0].en;
				vpos = circle_i[0].ed_pos.v;
			} // circle

			if(en == 1 && now_vpos == vpos) { // stop position에 도달한 line

				if(line == 1 || 
				   (bline_i[0].sp_pos.v == bline_i[0].ed_pos.v &&
					bline_i[0].sp_pos.h == bline_i[0].ed_pos.h)) { // stop == end
					if(line == 0) { // beeline
						bline_i[0].en = 0;  // disable
						circle_i[0].en = 1; // enable
						circle_i[0].update = 1;
					} // beeline
					else { // circle
						circle_i[0].en = 0;
						
						// left beeline
						bline_i[0].en = 1;
						bline_i[0].update = 1;
						bline_i[0].dv = 1; // 수직선
						bline_i[0].dh = 0;
						bline_i[0].st_pos.v = now_vpos;
						bline_i[0].st_pos.h = circle_pm[0].nposh;
						bline_i[0].ed_pos.v = sort_edge[2].v;
						bline_i[0].ed_pos.h = sort_edge[2].h;
						bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
						bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
					} // circle
				} // if. stop == end
				else { // stop != end
					// only beeline
					if(eff_hrange[0] == 0) { // effective
						bline_i[0].en = 0;  // disable
						circle_i[0].en = 1; // enable
					} // if. effective
					else { // not effective
						bline_i[0].en = 1;
						bline_i[0].update = 1;
						bline_i[0].st_pos.v = now_vpos;
						bline_i[0].st_pos.h = beeline_pm[0].nposh;
						bline_i[0].sp_pos.v = bline_i[0].ed_pos.v;
						bline_i[0].sp_pos.h = bline_i[0].ed_pos.h;
						bline_i[0].dv = bline_i[0].ed_pos.v - bline_i[0].st_pos.v;
						bline_i[0].dh = bline_i[0].ed_pos.h - bline_i[0].st_pos.h;
					} // not effective
				} //else. stop != end
			} // if. stopped line
		} // for. line
	} // else. no change effective line

} // left_new_circle






//----------------------------------------------------
void right_new_circle(void)
{
	int   line;
	
	int   en;
	int   vpos;

	if(eff_hrange_old[1] != eff_hrange[1]) { // change effective line
		// check previous effective line
		if(eff_hrange[1] == 1) { // change to circle 
			bline_i[1].en = 0;  // disable
			circle_i[1].en = 1; // enable
		} // if, change to circle
		else { // change to beeline
			bline_i[1].en = 1;  // enable
			// backup beeline information
			mv_bline(&bline_i[1], &next_st_pos);
			circle_i[1].en = 0; // disable
		} // else. beeline
	} // if. change effective line
	else { // no change effective line
		for(line=0;line<2;line++) {
			//  stop position과 현재 position이 일치하는 line을 검색
			if(line == 0) { // beeline
				en = bline_i[1].en;
				vpos = bline_i[1].sp_pos.v;
			}// beeline
			else { // circle
				en = circle_i[1].en;
				vpos = bline_i[1].ed_pos.v;
			} // circle

			if(en == 1 && now_vpos == vpos) { // stop position에 도달한 line

				if(line == 1 || 
				   (bline_i[1].sp_pos.v == bline_i[1].ed_pos.v &&
					bline_i[1].sp_pos.h == bline_i[1].ed_pos.h)) { // stop == end
					if(line == 0) { // beeline
						bline_i[1].en = 0;  // disable
						circle_i[1].en = 1; // enable
						circle_i[1].update = 1;
					} // beeline
					else { // circle
						circle_i[1].en = 0;
						
						// right beeline
						bline_i[1].en = 1;
						bline_i[1].update = 1;
						bline_i[1].dv = 1; // 수직선
						bline_i[1].dh = 0;
						bline_i[1].st_pos.v = now_vpos;
						bline_i[1].st_pos.h = circle_pm[1].nposh;
						bline_i[1].ed_pos.v = sort_edge[3].v;
						bline_i[1].ed_pos.h = sort_edge[3].h;
						bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
						bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
					} // circle
				} // if. stop == end
				else { // stop != end
					// only beeline
					if(eff_hrange[1] == 0) { // effective
						bline_i[1].en = 0;  // disable
						circle_i[1].en = 1; // enable
					} // if. effective
					else { // not effective
						bline_i[1].en = 1;
						bline_i[1].update = 1;
						bline_i[1].st_pos.v = now_vpos;
						bline_i[1].st_pos.h = beeline_pm[1].nposh;
						bline_i[1].sp_pos.v = bline_i[1].ed_pos.v;
						bline_i[1].sp_pos.h = bline_i[1].ed_pos.h;
						bline_i[1].dv = bline_i[1].ed_pos.v - bline_i[1].st_pos.v;
						bline_i[1].dh = bline_i[1].ed_pos.h - bline_i[1].st_pos.h;
					} // not effective
				} // stop != end
				
			} // stopped line
		} // for
	} // else. no change effective line
} // right_new_circle
	



//===============================================================
// check drawing area
int chk_draw(void)
// return : drawing, not drawing
{
	if(pat_attr != 0 && eff_hrange[1] >= eff_hrange[0])
		return DRAW;
	else return NDRAW;
} // chk_draw
	



//=============================================================
// circle information에서 현재의 vertical position을 update함.
//    stop했다가 새로운 area drawing시 재시작 위치를 계산하기 위해서 필요함.
void str_vpos_circle(void)
{
	circle_i[0].sp_vpos = now_vpos;
	circle_i[1].sp_vpos = now_vpos;
} // str_vpos_circle
