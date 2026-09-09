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

#define __DEBUG__


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
#include "drawing.h"


#include "gpu.h"

//----------------------------------------------------
// global variables



//-------------------------------
// converted values
 
// line parameter
int      bline_dv;      // beeline virtical 증가량.
int      bline_dh;      // beeline horizontal 증가량.
int      bline_sslop;   // the sign of a beeline slop // 0/-1
int      circle_case;   // circle의 종류.
int      se_exc;        // start/end position exchange. line의 시작점이 끝점보다 아래 있을때 active.
                        // sort_edges에서 결정.
int      line_len;      // init line length. circle의 경우에는 현재까지의 line길이.
                        // beeline : 감소하는 방향. init = length
                        // circle : 증가하는 방향. init = 0

//       line pattern
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

int       bl_new = 1;
int       cl_new = 1;

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
int    state = 0;

int    draw_param_st;// draw parameter status
                     // pipeline에 drawing command를 주기 위한 단계.
                     // command의 처음 or line의 처음 or normal

int gpu(void)
// return : SUCC/FAIL. FAIL : no command
{
	int    i;
	int    buff_st_pos; // start position of the buffer 
                      // line drawing command의 남은 부분을 load할
                      // 시작 offset.

#ifdef  __DEBUG__
	printf("\n\n GPU State Machine status : %d", gpu_proc);
#endif //  __DEBUG__
	
	switch(gpu_proc) {
	case PROC_GET_QUEUE :
		if(set_cmd_pnt() == FAIL) return FAIL; // no command
		gpu_proc = RD_8_CMD;

	case RD_8_CMD :
		// read 8 command words
		rd_fst_cmd();
		gpu_proc = WAIT_BUS_8;
		break;
	case WAIT_BUS_8 : 
		// wait the end of bus operation
		if(chk_op(MEM_CMD_STR) == FALSE) gpu_proc = RD_REST_CMD;
		break;
	case RD_REST_CMD :
		// read rest command words
		get_fst8cmd();   

		// send the command that read a drawing command structure from memory to buffer
		rd_rest_cmd();

		gpu_proc = WAIT_BUS_REST;
		break;
	case WAIT_BUS_REST : 
		// wait the end of bus operation
		if(chk_op(MEM_CMD_STR) == FALSE) gpu_proc = GET_CMD_INFO;
		break;
	case GET_CMD_INFO :
		// get picture informations
		//    command structure에 있는 picture 정보를 적당한 variable에 복사.
		get_cmd_info();

#ifdef  __DEBUG__
		printf("\n Command Kind : %x", cmd_kind);
#endif //  __DEBUG__

		draw_param_st = NEW_CMD;   // set to a new command
		gpu_proc = CHK_IN_BUFF;
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
			// memory에서 추가로 read해오는 function 호출.
			if(chk_cbuff == FALSE) // command buffer에 다음 line정보가 없을때
				rd_rest_line();

			gpu_proc = WAIT_LINE_PARAM;
		} // if
		else { // other command
			gpu_proc = INIT_LINE_INFO; // jump
		}
		break;
	case WAIT_LINE_PARAM : // wait rest command load
		// memory operation이 완료되어 buffer가 fill되면 다음으로 진행.
		if(chk_op(MEM_CMD_STR) == FALSE) gpu_proc = INIT_LINE_INFO;
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

		if(state == FIRST_DRAW) {
			// first drawing flag
			bl_new = 1;
			cl_new = 1;
		} // if
		else if(state == NEXT_LINE) {
			// first drawing flag
			bl_new = 1;
			cl_new = 0;
		} // else if

		if(gpu_proc == LINE_ESTIMATE) {
			now_vpos ++;
			// now_vpos을 initial.
		}
		else if(gpu_proc != CHK_LINE_CMD && state != FIRST_DRAW) {
			if(NEW_AREA) now_vpos = set_new_vpos(now_vpos);
			else 	 now_vpos ++;
		}

#ifdef __DEBUG__
		printf("\n Now Vertical Position : %d", now_vpos);
#endif // __DEBUG__

		break;

	case SET_PARAM : // Setting line parameter
#ifdef __DEBUG__
		printf("\n Drawing State : %d",state);
#endif // __DEBUG__
		if(set_parameter(state) == 1) gpu_proc = CHK_LINE_CMD;
		else {
			pre_hrange(bline_i, circle_i, beeline_pm, circle_pm, 0);
			str_vpos_circle(); // set virtical positions to the start position
			
			gpu_proc = LINE_ESTIMATE;
		} // else
		break;

	case LINE_ESTIMATE :
		// Moved 2006.11.8
		//str_vpos_circle(); // set virtical positions to the start position
		
		// estimation horizontal range
		get_estimation(hrange, eff_hrange, bl_new, cl_new);
		
		bl_new = 0;
		cl_new = 0;
				
		gpu_proc = CHK_DRAW_AREA;
		break;

	case CHK_DRAW_AREA :	
		if(chk_draw() == DRAW) gpu_proc = DRAW_HLINE;
		else gpu_proc = CHECK_NEXT_LINE;
		break;

		//-------------------------------------
	case DRAW_HLINE :
		// wait end of a drawing h.line
		if(draw_param_st == NEW_CMD) gpu_proc = CMD_PARAM;
		else if(draw_param_st == NEW_LINE) gpu_proc = LINE_PARAM;
		else gpu_proc = DRAW_CMD;

#ifdef  __DEBUG__
		for(i=0;i<4;i++)
			printf("\n H.Range[%d] : %d", i,hrange[i]);
		printf("\n Effective H.Range Left  : %d",eff_hrange[0]);
		printf("\n Effective H.Range Right : %d",eff_hrange[1]);
#endif //  __DEBUG__

	case CMD_PARAM :
		// check the status of the drawing pipeline.
		if(chk_pipe_nop() == PIPE_NOP) {
			set_cmd_param(); // send parameters to the pipeline
			
			if(cmd_kind == LINEDRW) {  // first of a line at line drawing
				draw_param_st = NEW_LINE;
				gpu_proc = LINE_PARAM;
			} // if
			else { // normal drawing
				draw_param_st = DRAW_PROS;
				gpu_proc = DRAW_CMD;
			} // else
		} // if
		else   break;
	case LINE_PARAM :
		if(chk_pipe_newline() == PIPE_OK) {
			set_line_param();
			draw_param_st = DRAW_PROS;
			gpu_proc = DRAW_CMD;
		} // if
		else   break;
	case DRAW_CMD :
		// set horizontal line drawing command
		if(chk_pipe_newline() == PIPE_OK) {
			set_each_param(); // include drawing start signal
			gpu_proc = CHECK_NEXT_LINE;
		} // if
		
		break;

		//-------------------------------------

	case CHK_LINE_CMD : // 더 그려야 할 poly line이 있는지 확인.
		if(cmd_kind == LINEDRW && line_cnt <= line_num) {
			lpat_pos = lpat_pos_bk;
			pat_attr = pat_attr_bk;
			rest_pat_px = rest_pat_bk;
			gpu_proc = CHK_IN_BUFF;
			draw_param_st = NEW_LINE;
		}
		else gpu_proc = _DEFAULT_;
		break;

	default : // end command. close command and prepare next instruction
		gpu_proc = PROC_GET_QUEUE;
		break;
	} // switch


	return SUCC;
} // gpu









//======================================================
// picture정보를 command structure에서 register로 복사.

int get_cmd_info(void)
// return : SUCC/FAIL
{
	uint    command;
	int     i;
	pos     src_size;

	// get command parameters
	get_rest_cmd();

	
	// generate reversed line pattern.
	line_pat_rev = reverse_pat(line_pat_for);

	lpat_pos = 0;
	rest_pat_px = 0;
	pat_attr = line_pat_for & 1;


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

	if(cmd_kind == LINEDRW) {
		line_info(); // get line parameter from the command buffer

		line_cnt ++;

		// edge 의 위치를 정렬.
		// vertical position이 위쪽인 point를 첫번째 edge로 결정.
		sort_edges();  // dst_edge --> sort_edge

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
		
	} // if line
	else { // else others
		// edge 의 위치를 정렬.
		// vertical position이 위쪽인 point를 첫번째 edge로 결정.
		sort_edges();  // dst_edge --> sort_edge
	} // else 



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

#ifdef __DEBUG__
	printf("\n Max Vertical Position : %d",max_vpos);
#endif // __DEBUG__

} // get_max_vpos







// get_pic_info is moved to cmd_buff.c 2006.10.30






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
#ifdef __DEBUG__
	  printf("\n First drawing");
#endif // __DEBUG__
  }
  else { 
	  if(chk_end_draw() == SUCC) {
		  *proc = CHK_LINE_CMD;
		  *state = NEW_AREA;
#ifdef __DEBUG__
		  printf("\n one drawing end");
#endif // __DEBUG__
	  }
	  else if(chk_next_area() == SUCC) { // one area is ended.
		  *proc = SET_PARAM;
		  *state = NEW_AREA;
#ifdef __DEBUG__
		  printf("\n New drawing area");
#endif // __DEBUG__
	  }
	  else if(chk_next_line() == SUCC) {
		  *proc = SET_PARAM;
		  *state = NEXT_LINE;
#ifdef __DEBUG__
		  printf("\n change next line ");
#endif // __DEBUG__
		  }
	  else {
		  *proc = LINE_ESTIMATE; // move to check next line pattern
		  *state = EST_LINE;
#ifdef __DEBUG__
		  printf("\n New estimation");
#endif // __DEBUG__
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

	if(state == NEW_AREA || state == FIRST_DRAW) {
#ifdef __DEBUG__
		printf("\n\n Set AREA Info. for New area.");
#endif // __DEBUG__
		nxt = set_new_area(state);
	}
	else if(state == NEXT_LINE) {
#ifdef __DEBUG__
		printf("\n\n Set Line Info. for New area.");
#endif // __DEBUG__
		set_new_line();
		nxt = 0;
	}
	else { // error
		printf("\n ERROR : invalid state code.");
		exit(0);
	}
	
#ifdef __DEBUG__
	disp_bline_info(&bline_i[0]);
	disp_bline_info(&bline_i[1]);
	disp_circle_info(&circle_i[0]);
	disp_circle_info(&circle_i[1]);
#endif // __DEBUG__

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
		if(line_pattern == 0xffffffff) { // dash line
			set_no_pattern();
		} // if dash line
		else { // with line pattern
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

		} // else with line pattern
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
		if(line_pattern == 0xffffffff ||
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
	// now v. position backup
	circle_i[0].sp_vpos = now_vpos;
	circle_i[1].sp_vpos = now_vpos;
} // str_vpos_circle






//================================================================
// Init. H.Range Drawing Parameters using command structure
//     command당 1번만 수행.
void set_cmd_param(void)
{
	int      i;
	
	
	// command structure information
	slot1.cmd_kind = cmd_kind;

	slot1.dst_pic_hsize = dst_pic_info.maxx;
	slot1.dst_pic_vsize = dst_pic_info.maxy;
	slot1.dst_pic_ctype = dst_pic_info.type;
	slot1.dst_pic_pnt = dst_pic_info.addr;
	slot1.dst_pal_pnt = dst_pic_info.palette;
	
	slot1.dst_pat_hsize = dst_pat_info.maxx;
	slot1.dst_pat_vsize = dst_pat_info.maxy;
	slot1.dst_pat_ctype = dst_pat_info.type;
	slot1.dst_pat_pnt   = dst_pat_info.addr;
	
	slot1.src_pic_hsize = src_pic_info.maxx;
	slot1.src_pic_vsize = src_pic_info.maxy;
	slot1.src_pic_ctype = src_pic_info.type;
	slot1.src_pic_pnt = src_pic_info.addr;
	slot1.src_pal_pnt = src_pic_info.palette;

	slot1.src_pat_hsize = src_pat_info.maxx;
	slot1.src_pat_vsize = src_pat_info.maxy;
	slot1.src_pat_ctype = src_pat_info.type;
	slot1.src_pat_pnt = src_pat_info.addr;

	slot1.draw_bcolor = back_color;
	
	slot1.brush_hsize = dpt_pat_info.maxx;
	slot1.brush_vsize = dpt_pat_info.maxy;
	slot1.brush_pnt = dpt_pat_info.addr;

	slot1.t_color = grad_color[0];
	slot1.r_color = grad_color[1];
	slot1.b_color = grad_color[2];
	slot1.l_color = grad_color[3];

	slot1.tmode = tmode;

	slot1.cconv_format = ccnv_form;

	slot1.sel_a = a_pos;
	slot1.sel_r = r_pos;
	slot1.sel_g = g_pos;
	slot1.sel_b = b_pos;

	slot1.dst_vpos[0] = dst_edge[0].v;
	slot1.dst_vpos[1] = dst_edge[1].v;
	slot1.dst_vpos[2] = dst_edge[3].v; // no 시계방향.
	slot1.dst_vpos[3] = dst_edge[2].v;

	for(i=0;i<2;i++) {
		slot1.src_pos[i].v = src_edge[i].v;
		slot1.src_pos[i].h = src_edge[i].h;
	} // for

	// no 시계방향
	slot1.src_pos[2].v = src_edge[3].v;  
	slot1.src_pos[2].h = src_edge[3].h;

	slot1.src_pos[3].v = src_edge[2].v;
	slot1.src_pos[3].h = src_edge[2].h;


	slot1.sin_fix = sin_int;
	slot1.cos_fix = cos_int;

	new_cmd = 1;
} // set_cmd_param






//--------------------------------------------
// Init Line command parameter
//     drawing line마다 수행.
void set_line_param(void)
{
	// drawing color
	slot1.draw_fcolor = fore_color;
	// overlay
	slot1.avalue_rcode = alpha_rater.code;
	slot1.bg_code = alpha_rater.brcode;
	slot1.alpha_choose = alpha_rater.ac;
	slot1.alpha_raster = alpha_rater.kind;

} // set_line_param






//--------------------------------------------
// Init drawing parameter
//      Horizontal line마다 수행.
void set_each_param(void)
{
	// generated information
	slot1.now_vpos = now_vpos;
	slot1.st_hpos = hrange[eff_hrange[0]&1];
	slot1.ed_hpos = hrange[2+(eff_hrange[0]&1)];

	// set start flag
	dstart = 1; 

} // set_each_param







#ifdef  __DEBUG__

//=======================================================
// Display beeline estimation info
void disp_bline_info(bline_info *bline)
// bline_info : 출력할 structure
{

//	printf("\n");
	printf("\n Beeline Enable : %d",bline->en);
	printf("\n Beeline Updata : %d",bline->update);
	printf("\n Start V Pos : %d",	bline->st_pos.v);
	printf("\n Start H Pos : %d",	bline->st_pos.h);
	printf("\n Stop V Pos : %d",	bline->sp_pos.v);
	printf("\n Stop H Pos : %d",  	bline->sp_pos.h);
	printf("\n End V Pos : %d",	    bline->ed_pos.v);
	printf("\n End H Pos : %d",	    bline->ed_pos.h);
	printf("\n Delta V : %d",       bline->dv);
	printf("\n Delta H : %d",		bline->dh);
	printf("\n");

} // disp_bline_info






//----------------------------------------------
// Display circle estimation info
void disp_circle_info(circle_info *circle)
// circle_info : 출력할 structure
{
	printf("\n Circle Enable : %d",circle->en);
	printf("\n Circle Updata : %d",circle->update);
	printf("\n Circle case : %d",  circle->ccase);
	printf("\n Start V Pos : %d",  circle->st_pos.v);
	printf("\n Start H Pos : %d",  circle->st_pos.h);
	printf("\n End V Pos : %d",	   circle->ed_pos.v);
	printf("\n End H Pos : %d",	   circle->ed_pos.h);
	printf("\n Radius V : %d",     circle->r);
	printf("\n");

} // disp_circle_info


#endif // __DEBUG__
