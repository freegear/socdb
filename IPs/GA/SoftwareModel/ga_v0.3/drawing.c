/****************************************************
  
   Horizontal line drawing

   file name : drawing.c
   created by gtlee
   data : 2006.9.27

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __DRAWING__
#define  __DRAWING__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"
#include "cmd_buff.h"
#include "src_pic.h"


#include "drawing.h"





//-----------------------------------------------------
// source pixel read count
int    src_pixel_st; // vertical line별 진행 상황을 나타냄.

// source pattern read count
int    src_pat_st;

// State of Write Buffer
int stage_wr_buff;




//===================================================
// initial pipeline slot registers and etc variables
//   reset시 호출되는 함수.
void init_draw(void)
{
	int     i;

	// slot1
	slot1.cmd_kind = 0;
	slot1.dst_pic_hsize = 0;
	slot1.dst_pic_vsize = 0;
	slot1.dst_pic_ctype = CA32BPP;
	slot1.dst_pic_pnt = 0;
	slot1.dst_pal_pnt = 0;

	slot1.dst_pat_hsize = 0;
	slot1.dst_pat_vsize = 0;
	slot1.dst_pat_ctype = MONO;
	slot1.dst_pat_pnt = 0;

	slot1.src_pic_hsize = 0;
	slot1.src_pic_vsize = 0;
	slot1.src_pic_ctype = CA32BPP;
	slot1.src_pic_pnt = 0;
	slot1.src_pal_pnt = 0;

	slot1.src_pat_hsize = 0;
	slot1.src_pat_vsize = 0;
	slot1.src_pat_ctype = MONO;
	slot1.src_pat_pnt = 0;
	
	slot1.draw_fcolor = 0xFFFFFFFF;
	slot1.draw_bcolor = 0;

	slot1.brush_hsize = 0;
	slot1.brush_vsize = 0;
	slot1.brush_pnt = 0;
	
	slot1.t_color = 0;
	slot1.r_color = 0;
	slot1.b_color = 0;
	slot1.l_color = 0;

	slot1.avalue_rcode = 0; // bypass
	slot1.alpha_choose = 1;
	slot1.alpha_raster = 0x0ff;

	slot1.cconv_format = 0x0231;
	slot1.sel_b = 0;
	slot1.sel_g = 1;
	slot1.sel_r = 2;
	slot1.sel_a = 3;
	
	for(i=0;i<4;i++) {
		slot1.dst_vpos[i] = 0;
		slot1.src_pos.v = 0;
		slot1.src_pos.h = 0;
	} // for
	
	slot1.sin_fix = 0;
	slot1.cos_fix = 0x0ffff;

	slot1.now_vpos = 0;
	slot1.st_hpos = 0;
	slot1.ed_hpos = 0;
	slot1.now_hpos = 0;
	slot1.st_hpos_addr = 0;
	slot1. ed_hpos_addr = 0;

	slot1.dst_addr = 0;
	slot1.dst_offset = 0;
	slot1.dst_pat_addr = 0;
	slot1.src_h_ratio = 0;
	slot1.src_v_ratio = 0;

	slot1.grad_fill = 0;
	for(i=0;i<4;i++) {
		slot1.grad_fcolor[i] = 0;
		slot1.grad_ratio[i] = 0;
	}
	slot1.lastp = 0;
	slot1.nop = 1;
	slot1.stall = 0;

	// slot 2
	slot2.draw_fcolor = 0;

	slot2.now_vpos = 0;
	slot2.st_hpos = 0;
	slot2.ed_hpos = 0;
	slot2.now_hpos = 0;
	slot2.st_hpos_addr = 0;
	slot2.ed_hpos_addr = 0;

	slot2.src_pos.h = 0;
	slot2.src_pos.v = 0;
	slot2.src_h_ratio = 0;
	slot2.src_v_ratio = 0;

	slot2.dst_addr = 0;
	slot2.dst_pat_addr = 0;

	slot2.src_pixel_pos.h = 0;
	slot2.src_pixel_pos.v = 0;

	for(i=0;i<4;i++) {
		slot2.src_pixel[i].h = 0;
		slot2.src_pixel[i].v = 0;
		slot2.src_addr = 0;
		slot2.src_pat_addr = 0;
	} // for

	slot2.grad_fill = 0;
	slot2.grad_icolor = 0;

	slot2.brush_pat = 0;

	slot2.lastp = 0;
	slot2.nop = 1;
	slot2.stall = 0;

	// slot 3
	slot3.draw_fcolor = 0;

	slot3.now_vpos = 0;
	slot3.st_hpos = 0;
	slot3.ed_hpos = 0;
	slot3.now_hpos = 0;

	slot3.dst_addr = 0;
	slot3.dst_pixel = 0;
	slot3.dst_pat = 0;

	slot3.src_pixel_pos.h = 0;
	slot3.src_pixel_pos.v = 0;

	for(i=0;i<4;i++) {	
		slot3.src_pixels[i] = 0;
		slot3.src_pat[i] = 0;
	}
	slot3.src_pal = 0;

	slot3.brush_pat = 0;

	slot3.lastp = 0;
	slot3.nop = 1;
	slot3.stall = 0;
	slot3.bypass = 0;

	// slot 4
	slot4.draw_fcolor = 0;

	slot4.now_vpos = 0;
	slot4.st_hpos = 0;
	slot4.ed_hpos = 0;
	slot4.now_hpos = 0;

	slot4.dst_addr = 0;
	slot4.dst_pixel = 0;
	slot4.dst_pat = 0;

	slot4.src_pixel = 0;
	slot4.src_pat = 0;
	slot4.src_pal = 0;

	slot4.grad_fill = 0;
	slot4.grad_icolor = 0;
	slot4.brush_pat = 0;

	slot4.lastp = 0;
	slot4.nop = 1;
	slot4.stall = 0;
	slot4.bypass = 0;

	// slot 5
	slot5.ed_hpos = 0;
	slot5.now_hpos = 0;

	slot5.dst_addr = 0;
	slot5.dst_pixel = 0;

	slot5.lastp = 0;
	slot5.nop = 1;
	slot5.stall = 0;
	slot5.bypass = 0;

	// slot 6
	slot6.ed_hpos = 0;
	slot6.now_hpos = 0;
	slot6.dst_addr = 0;
	slot6.dst_pixel = 0;

	slot6.lastp = 0;
	slot6.nop = 1;
	slot6.stall = 0;
	slot6.bypass = 0;
	
	stage_wr_buff = 0;

} // init_draw at reset









//----------------------------------------
// command structure의 information을 전달하는 함수.
// command당 1번 수행.
void set_cmd_info(void)
{
	int    i;
	uint   cmd;
	int    src_base_pos;  // base position of the source info at the command structure
	int    over_base_pos;


	// read source info.
	slot1.cmd_kind = rd_cmd_kind();


	// read destination info.
	cmd = rd_cmd_wd(DST_PIC_SIZE);
	slot1.dst_pic_hsize = cmd & 0x0FFF;
	slot1.dst_pic_vsize = (cmd>>16) & 0x0FFF;

	slot1.dst_pic_ctype = 0x01f & rd_cmd_wd(DST_PIC_COLOR_TYPE);
	slot1.dst_pic_pnt = rd_cmd_wd(DST_PIC_POINTER);

	if(slot1.cmd_kind == CCONV) {
		slot1.dst_pal_pnt = 0;
		
		slot1.dst_pat_hsize = 0;
		slot1.dst_pic_vsize = 0;
		
		slot1.dst_pat_ctype = 0;
		slot1.dst_pat_pnt = 0;
	} // if CCONV
	else {
		slot1.dst_pal_pnt = rd_cmd_wd(DST_PAL_POINTER);
		
		cmd = rd_cmd_wd(DST_PAT_SIZE);
		slot1.dst_pat_hsize = cmd & 0x0FFF;
		slot1.dst_pic_vsize = (cmd>>16) & 0x0FFF;
		
		slot1.dst_pat_ctype = 0x01f & rd_cmd_wd(DST_PAT_COLOR_TYPE);
		slot1.dst_pat_pnt = rd_cmd_wd(DST_PAT_POINTER);
	} // else 

	switch(slot1.cmd_kind) {
	case BLTDRW :
		src_base_pos = SRC_BASE_BLT;   // 14
		break;
	case ROTDRW :
		src_base_pos = SRC_BASE_ROT;   // 10
		break;
	case CCONV :
		src_base_pos = SRC_BASE_CCONV; // 6
		break;
	default :
		src_base_pos = 0;
		break;
	} // switch

	if(src_base_pos != 0) {
		cmd = rd_cmd_wd(src_base_pos + SRC_PIC_SIZE);
		slot1.src_pic_hsize = cmd & 0x0FFF;
		slot1.src_pic_vsize = (cmd>>16) & 0x0FFF;
		
		slot1.src_pic_ctype = 0x01f & rd_cmd_wd(src_base_pos+SRC_PIC_COLOR_TYPE);
		slot1.src_pic_pnt = rd_cmd_wd(src_base_pos + SRC_PIC_POINTER);
		slot1.src_pal_pnt = rd_cmd_wd(src_base_pos + SRC_PAL_POINTER);

		if(slot1.cmd_kind == CCONV) {
			slot1.src_pat_hsize = 0;
			slot1.src_pat_vsize = 0;
			slot1.src_pat_ctype = 0;
			slot1.src_pat_pnt = 0;
		} // if CCONV
		else {
			cmd = rd_cmd_wd(src_base_pos + SRC_PAT_SIZE);
			slot1.src_pat_hsize = cmd & 0x0FFF;
			slot1.src_pat_vsize = (cmd>>16) & 0x0FFF;
			
			slot1.src_pat_ctype = 0x01f & rd_cmd_wd(src_base_pos+SRC_PAT_COLOR_TYPE);
			slot1.src_pat_pnt = rd_cmd_wd(src_base_pos + SRC_PAT_POINTER);
		} // else 

	} // if src_base_pos is not 0
	else { // src_base_pos is 0
		slot1.src_pic_hsize = 0;
		slot1.src_pic_vsize = 0;
		
		slot1.src_pic_ctype = 0;
		slot1.src_pic_pnt = 0;
		slot1.src_pal_pnt = 0;

		slot1.src_pat_hsize = 0;
		slot1.src_pat_vsize = 0;
		slot1.src_pat_ctype = 0;
		slot1.src_pat_pnt = 0;
	} // else. src_base_pos is 0

	
	// brush info.
	if(slot1.cmd_kind == LINEDRW)
		slot1.draw_fcolor = rd_cmd_wd(LINE_FCOLOR);
	else if(slot1.cmd_kind == FILLDRW)
		slot1.draw_fcolor = rd_cmd_wd(FILL_FCOLOR);
	else if(slot1.cmd_kind == BLTDRW)
		slot1.draw_fcolor = rd_cmd_wd(BLT_FCOLOR);
	else slot1.draw_fcolor = 0;

	if(slot1.cmd_kind == FILLDRW)
		slot1.draw_bcolor = rd_cmd_wd(FILL_BCOLOR);
	else if(slot1.cmd_kind == BLTDRW)
		slot1.draw_bcolor = rd_cmd_wd(BLT_BCOLOR);
	else slot1.draw_bcolor = 0;
	
	if(slot1.cmd_kind == FILLDRW) {
		cmd = rd_cmd_wd(FILL_BRUSH_PAT_SIZE);
		slot1.brush_hsize = cmd & 0x0FFF;
		slot1.brush_vsize = (cmd>>16) & 0x0FFF;

		slot1.brush_pnt = rd_cmd_wd(FILL_BRUSH_PNT);
	} // if Fill draw
	else if(slot1.cmd_kind == BLTDRW) {
		cmd = rd_cmd_wd(BLT_BRUSH_PAT_SIZE);
		slot1.brush_hsize = cmd & 0x0FFF;
		slot1.brush_vsize = (cmd>>16) & 0x0FFF;

		slot1.brush_pnt = rd_cmd_wd(BLT_BRUSH_PNT);
	} // else if BLT
	else {
		slot1.brush_hsize = 0;
		slot1.brush_vsize = 0;
		slot1.brush_pnt = 0;
	} // else


	// gradient fill color
	slot1.t_color = rd_cmd_wd(GRAD_FILL_BASE);
	slot1.r_color = rd_cmd_wd(GRAD_FILL_BASE + 1);
	slot1.b_color = rd_cmd_wd(GRAD_FILL_BASE + 2);
	slot1.l_color = rd_cmd_wd(GRAD_FILL_BASE + 3);

	
	// overlay
	switch(slot1.cmd_kind) {
	case ROTDRW :
		over_base_pos = ROT_OVERLAY;
		break;
	case CCONV :
		over_base_pos = CCONV_OVERLAY;
		break;
	default : 
		over_base_pos = OTHER_OVERLAY;
		break;
	} // switch

	cmd = rd_cmd_wd(over_base_pos);
	slot1.avalue_rcode = 0x0FF & (cmd>>16);
	slot1.alpha_choose = 1 & (cmd>>29);
	slot1.alpha_raster = 0x03 & (cmd>>30);

	
	// color convert info.
	cmd = rd_cmd_wd(CCONV_INFO);
	slot1.cconv_format = 0x3FF & cmd;
	slot1.sel_b = 0x03 & (cmd>>16);
	slot1.sel_g = 0x03 & (cmd>>18);
	slot1.sel_r = 0x03 & (cmd>>20);

	// destination picture vertical position at BLT
	if(slot1.cmd_kind == BLTDRW) {
		for(i=0;i<4;i++) {
			slot1.dst_vpos[i] = 0x01FFF & (rd_cmd_wd(BLT_DST_POS+i) >> 16);
			// sign extension
			if((slot1.dst_vpos[i] & 0x01000) != 0)
				slot1.dst_vpos[i] |= 0xFFFFF000;
		} // for
	} // if BLT
	else {
		for(i=0;i<4;i++) {
			slot1.dst_vpos[i] = 0;
		} // for
	} // else


	// source picture position at BLT
	if(slot1.cmd_kind == BLTDRW) {
		for(i=0;i<4;i++) {
			cmd = rd_cmd_wd(BLT_SRC_POS+i);
			slot1.src_pos[i].h = 0x01FFF & cmd;
			// sign extension
			if((slot1.src_pos[i].h & 0x01000) != 0)
				slot1.src_pos[i].h |= 0xFFFFF000;

			slot1.src_pos[i].v = 0x01FFF & (cmd >> 16);
			// sign extension
			if((slot1.src_pos[i].v & 0x01000) != 0)
				slot1.src_pos[i].v |= 0xFFFFF000;
		} // for
	} // if BLT
	else {
		for(i=0;i<4;i++) {
			slot1.src_pos[i].v = 0;
			slot1.src_pos[i].h = 0;
		} // for
	} // else
		
	
	// sin, cos value for Rotate
	cmd = rd_cmd_wd(ROT_SIN_COS);
	slot1.cos_fix = 0x0FFFF & cmd;
	slot1.sin_fix = 0x0FFFF & (cmd >> 16);

	// load brush pattern
	//    brush pattern position
	//    send memory read command
	//    실제 read는 pipeline을 진행하기 전에 check.
	fill_brush_buff(slot1.brush_pnt,slot1.brush_hsize, brush_vsize);
	

	
	// clear last pixel flag
	slot1.lastp = 0;

} // set_cmd_info








//----------------------------------------
// H.Range 계산하는 함수에서 계산된 H.Range를 drawing block에 
// 전달하기 위해서 호출하는 함수.
// pipeline stage보다 우선순위가 높으므로 pipeline처리가 완료되면 수행해야 한다.
void set_init_value(uint draw_color )
// draw_color : drawing foreground color. line drawing시 line마다 설정.
{
	slot1.draw_fcolor = draw_color;
	slot1.now_hpos = slot1.st_hpos;


	//-------------------------------------------
	//   calc. destination address
	slot1.st_hpos_addr = calc_addr(slot1.dst_pic_pnt, slot1.dst_pic_ctype, 
							   slot1.dst_pic_hsize, slot1.dst_pic_vsize, 
							   slot1.now_vpos, slot1.st_hpos);
	
	slot1.ed_hpos_addr = calc_addr(slot1.dst_pic_pnt, slot1.dst_pic_ctype, 
							   slot1.dst_pic_hsize, slot1.dst_pic_vsize, 
							   slot1.now_vpos, slot1.ed_hpos);
	
	slot1.dst_addr = slot1.st_hpos_addr;
	

	switch(slot1.dst_pic_ctype) {
	case MONO :
		slot1.dst_offset = 1;
		break;
	case C8BPP :
		slot1.dst_offset = 1;
		break;
	case C16BPP :
	case C16BPP :
		slot1.dst_offset = 2;
		break;
	case C24BPP :
		slot1.dst_offset = 3;
		break;
	default :
		slot1.dst_offset = 4;
		break;
	} // switch

	
	

	//-------------------------------------------
	//   calc. destination pattern address
	if(slot1.dst_pat_pnt == 0)
		slot1.dst_pat_addr = 0;
	else {// not zero
		slot1.dst_pat_addr = calc_addr(slot1.dst_pat_pnt, MONO,
									   slot1.dst_pat_hsize, slot1.dst_pat_vsize,
									   slot1.now_vpos, slot1.now_hpos);
	} // else. not zero


	// source base position 계산.
	switch(slot1.cmd_kind) {
	case BLTDRW :
		src_base_pos_blt(slot1.dst_vpos[0], slot1.dst_vpos[1], 
						 slot1.dst_vpos[3], slot1.dst_vpos[2],
						 slot1.now_vpos, st_hpos, ed_hpos,
						 slot1.src_pos[0], slot1.src_pos[1],
						 slot1.src_pos[3], slot1.src_pos[2],
						 &slot1.src_h_ratio, &slot1.src_v_ratio, 
						 &slot1.src_pixel_pos);
		break;
	case ROTDRW :
		src_base_pos_rot(slot1.dst_vpos[0], slot1.now_vpos,
						 slot1.sin_fix, slot1.cos_fix,
						 &slot1.src_h_ratio, &slot1.src_v_ratio, 
						 &slot1.src_pixel_pos );
		break;
	default : // 1대1 mapping
		slot1.src_pos.v = (float)now_vpos;
		slot1.src_pos.h = (float)now_hpos;
		slot1.src_h_ratio = 1;
		slot1.src_v_ratio = 0;
		break;
	} // switch slot1.comd_kind


	//-----------------------------------------
	// gradient color interpolation
	gradient_base(slot1.t_color, slot1.r_color, slot1.b_color, slot1.l_color,
				  slot1.dst_vpos, slot1.now_vpos, slot1.st_hpos, slot1.ed_hpos,
				  slot1.grad_fcolor, slot1.grad_ratio);
	

	// clear last pixel flag
	slot1.lastp = 0;

} // set_init_value









//===================================================
// drawing state machine
void draw_sm(void)
{
	// command info 초기화시 메모리 동작이 완료 될때까지 다음 동작을 진행하지 않음(현 stage유지).








} // draw_sm









//====================================================
// H.line drawing시 제일 처음에 하는 작업.
// pixel별 연산을 하기 위한 데이터 준비.
void pre_calc_draw(void)
{
	// if source picture가 존재 할 경우
	// src_base_pos(va, vb, vc, vd, now_vpos, hda, hdb, sa, sb,sc, sd,
	// &h_ratio);
	// 

} // pre_calc_draw








//===================================================
// drawing pipeline
void draw_pipe(void)
{
	int   i;

	//-------------------------------------------
	// stage6 : slot6 --> write buffer
	stage6();

	//-------------------------------------------
	// stage5 : slot5 --> slot6
	if(slot6.stall == 0)
		stage5();
	else  // at stall
		slot5.stall = 1;

	
	//-------------------------------------------
	// stage4 : slot4 --> slot5
	if(slot6.stall ==0 && slot5.stall == 0)
		stage4();
	else  // at stall
		slot4.stall = 1;

	//-------------------------------------------
	// stage3 : slot3 --> slot4
	if(slot6.stall ==0 && slot5.stall == 0 && slot4.stall == 0)
		stage3();
	else  // at stall
		slot3.stall = 1;

	//-------------------------------------------
	// stage2 : slot2 --> slot3
	if(slot6.stall ==0 && slot5.stall == 0 && 
	   slot4.stall == 0 && slot3.stall == 0)
		stage2();
	else  // at stall
		slot2.stall = 1;
	

	//-------------------------------------------
	// stage1 : slot1 --> slot2
	if(slot6.stall ==0 && slot5.stall == 0 && 
	   slot4.stall == 0 && slot3.stall == 0 && 
	   slot2.stall == 0) {
		stage1();
	else  // at stall
		slot1.stall = 1;
		

	//-------------------------------------------
	// update slot1
	if(slot6.stall ==0 && slot5.stall == 0 && 
	   slot4.stall == 0 && slot3.stall == 0 && 
	   slot2.stall == 0 && slot1.stall == 0)
		update_slot1();


} // draw_pipe







//-----------------------------------------------
// update slot1 register
void update_slot1(void)
{
	// next destination address and destination pattern address


	// update destination address
	//   must be located before updating now_hpos
	if(slot1.dst_pic_ctype == MONO) {
		if((slot1.now_hpos & 0x07) == 7) slot1.dst_addr ++ ;
	}
	else 	slot1.dst_addr += dst_offset;
	


	//     next source position
	if(slot1.nop == 0 && slot1.now_hpos <= slot1.ed_hpos) {
		//    update destination position
		slot1.now_hpos = slot1.now_hpos + 1;

		if(slot1.now_hpos == slot1.ed_hpos)
			slot1.lastp = 1; // last pixel flag

		//    update source position
		slot1.src_pixel_pos.v += src_v_ratio;
		slot1.src_pixel_pos.h += src_h_ratio;

	} // if
	else {
		slot1.lastp = 0;
	}

	//     next gradient color
	//        only add operation
	next_color(slot1.grad_fcolor, slot1.grad_ratio);
	
} // update_slot1








//-----------------------------------------------
// drawing pipeline Stage 1
// stage1 : slot1 --> slot2
void stage1(void)
{
	int   i;

	pos   low;
	pos   low_p1; // low + 1
	pos   src_pixel[4]; // 시계방향.
	

	//-------------------------------------------
	//   calc. destination address
	slot2.dst_addr = slot1.dst_addr;
	slot2.st_hpos_addr = slot1.st_hpos_addr;
	slot2.ed_hpos_addr = slot1.ed_hpos_addr;


	//-------------------------------------------
	//   calc. destination pattern address
	slot2.dst_pat_addr = slot1.dst_pat_addr;


	//-------------------------------------------
	// get 4 source pixel position
	//      check the range 
	if(slot1.src_pos.v < 0) {
		low.v = 0;
		low_p1.v = 0;
	} // if less 0
	else if(slot1.src_pos.v >= slot1.src_pic_vsize) {
		low.v = slot1.src_pic_vsize;
		low_p1.v = slot1.src_pic_vsize;
	} // else if more max
	else {
		low.v = (int)slot1.src_pos.v;
		low_p1.v = (int)slot1.src_pos.v +1;
	} // else. normal

	
	if(slot1.src_pos.h < 0) {
		low.h = 0;
		low_p1.h = 0;
	} // if less 0
	else if(slot1.src_pos.h >= slot1.src_pic_hsize) {
		low.h = slot1.src_pic_hsize;
		low_p1.h = slot1.src_pic_hsize;
	} // else if more max
	else {
		low.h = (int)slot1.src_pos.h;
		low_p1.h = (int)slot1.src_pos.h +1;
	} // else. normal
	
	//     top left
	src_pixel[0].v = low.v;
	src_pixel[0].h = low.h;
	//     top right
	src_pixel[1].v = low.v;
	src_pixel[1].h = low_p1.h;
	//     bottom right
	src_pixel[2].v = low_p1.v;
	src_pixel[2].h = low.h;
	//     bottom left
	src_pixel[3].v = low_p1.v;
	src_pixel[3].h = low_p1.h;

	//      copy source pixel position
	for(i=0;i<4;i++) {
		slot1.src_pixel[i].v = src_pixel[i].v;
		slot1.src_pixel[i].h = src_pixel[i].h;
	} // for



	//-------------------------------------------
	// calc. source address
	if(slot1.src_pic_pnt == 0) {
		for(i=0;i<4;i++)
			slot2.src_addr[i] = 0;
	} // if zero
	else { // not zero
		for(i=0;i<4;i++) {
			slot2.src_addr[i] = calc_addr(slot1.src_pic_pnt, slot1.src_pic_ctype,
										  slot1.src_pic_hsize, slot1.src_pic_vsize,
										  src_pixel[i].h,src_pixel[i].v);
		} // for				  
	} // else. not zero
	


	//-------------------------------------------
	// calc. source pattern address
	if(slot1.src_pat_pnt == 0) {
		for(i=0;i<4;i++)
			slot2.src_pat_addr[i] = 0;
	} // if zero
	else { // not zero
		for(i=0;i<4;i++) {
			slot2.src_pat_addr[i] = calc_addr(slot1.src_pat_pnt, MONO,
											  slot1.src_pat_hsize, slot1.src_pat_vsize,
											  src_pixel[i].h,src_pixel[i].v);
		} // for				  
	} // else. not zero



	slot2.src_pixel_pos.v = slot1.src_pixel_pos.v;
	slot2.src_pixel_pos.h = slot1.src_pixel_pos.h;


	//-------------------------------------------
	// get gradient color
	slot2.grad_icolor = satr_color(slot1.grad_fcolor); // saturation


	// horizontal line parameter
	slot2.now_vpos = slot1.now_vpos;
	slot2.st_hpos = slot1.st_hpos;
	slot2.ed_hpos = slot1.ed_hpos;	
	slot2.now_hpos = slot1.now_hpos;

	//-------------------------------------------
	// clear last pixel flag
	slot2.lastp = slot1.lastp;

	if(slot1.now_hpos <= slot1.ed_hpos)
		slot2.nop = slot1.nop;
	else slot2.nop = 0;

	slot1.stall = 0;

} // stage1







//-----------------------------------------------
// drawing pipeline Stage 2
// stage2 : slot2 --> slot3
//    사용안 하는 pixel정보(dummy)는 bypass flag를 active시켜 다음 stage로 전달.
//    --> 아무런 처리 없이 write buffer로 전달.
//        address는 buffer내에서의 위치 offset.
void stage2(void)
{
	int    i;
	
	int    p_mode_dst; // pipeline mode for destination picture
	int    p_mode_dstp; // pipeline mode for destination mask pattern
	int    p_mode_src; // pipeline mode for source picture
	int    p_mode_srcp; // pipeline mode for source mask pattern
	int    p_mode_srcpl; // pipeline mode for source palette
	
	int    f_color;

	// 뒤 stage가 run일 경우에만 수행.

	//----------------------------------------------
	// Read destination pixel
	// update pipeline status bits and destination pixel
	p_mode_dst = dst_pixel(&slot2, &slot3);
	
	// read destination mask pattern
	p_mode_dstp = dst_pat(&slot2, &slot3);

	//-----------------------------------------------
	// Read source pixels
	// max 4 pixels
	// bypass gradient color

	if(slot2.grad_fill == 1)
		f_color = slot2.grad_icolor;
	else f_color = draw_fcolor;

	slot3.draw_fcolor = f_color;

	if(src_pic_pnt == 0) { // if no source
		p_mode_src = RUN;
		for(i=0;i<4;i++) slot3.src_pixels[i] = f_color;
	}
	else p_mode_src =  src_pixel(&slot2, &slot3);
	
	// read source mask pattern
	if(src_pat_pnt == 0) { // if no pattern
		p_mode_srcp = RUN;
		for(i=0;i<4;i++) slot3.src_pat[i] = 1;
	}
	else p_mode_srcp = src_pat(&slot2, &slot3);

	// source color palette. use source pixel at slot 3
	if(slot1.cmd_kind == CCONV && slot1.src_pat_ctype == C8BPP &&
	   slot1.src_pal_pnt != 0)
		p_mode_srcpl = src_pal(&slot2, &slot3, slot3.src_pixels[0]);
	else {
		p_mode_srcpl = RUN;
		src_pal = slot3.src_pixels[0];
	} // else

	slot3.src_pixel_pos.v = slot2.src_pixel_pos.v;
	slot3.src_pixel_pos.h = slot2.src_pixel_pos.h;

	//----------------------------------------------
	// Brush Info.
	//   get brush pattern of destination pixel from brush pattern buffer
	slot3.brush_pat = get_brush_pat(slot2.now_hpos - slot2.st_hpos, 
									slot2.now_vpos - slot1.dst_vpos[0], 
									slot1.brush_hsize, slot1.brush_vsize);

	slot3.brush_pat = slot2.brush_pat;
	
	if(p_mode_dst == P_BYPASS) {
		// bypass destination pixel dummy
		slot2.stall = 1;
		slot3.bypass = 1; // destination pixel color를 그대로 write buffer에 write
		slot3.nop = 1;

		// clear last pixel flag
		slot3.lastp = 0;
	} // if
	else if(p_mode_dst == NOP || p_mode_dstp == NOP ||
			p_mode_src == NOP || p_mode_srcp == NOP ||
			p_mode_srcp == NOP) { // stall
		slot2.stall = 1;
		slot3.bypass = 0;
		slot3.nop = 1;

		// clear last pixel flag
		slot3.lastp = 0;
	} // else
	else { // RUN
		slot2.stall = 0;
		slot3.bypass = 0;
		slot3.nop = slot2.nop;

		// clear last pixel flag
		slot3.lastp = slot2.lastp;
	} // 

} // stage2








//--------------------------------------------------
// work at stage2
// get destination pixel color
// or send read command
// or wait memory operation
// or send dummys
int dst_pixel(str_drw_slot2 *s2,str_drw_slot3 *s3)
// s2 : point of the slot2 structure
// s2 : point of the slot3 structure
// return : pipeline mode. run/nop/bypass
{
	int     i;

	int     buff_num;
	uint    target_addr;

	//---------------------------------------
	// fill a buffer 
	if(s2->nop == 0 && (chk_dst_full(0) == 0 || chk_dst_full(1) == 0)) {
		if(chk_dst_rd() == NOPMEM) { // if opearation nothing
			target_addr = s2->dst_addr & (~DST_BUFF_IDX_MSK); // mask 0x01f
			if(chk_dst_full(used_fg) != 0) // if pre-read
				target_addr += DST_BUFF_WLEGTH*4; // add 32

			// send read command
			read_dst(target_addr);
		} // if
		else { // when operation is doing
			if(get_dst() == SUCC) { // if move data from bus to dst_buff.
				if(chk_dst_full(used_fg) == 0) 
					buff_num = 0;
				else buff_num = 1;
				// update dummy flag
				update_dummy_fg(s2->ctype, s2->st_hpos_addr,
								s2->ed_hpos_addr, buff_num)
			} // if. Success
		} // else
	} // if empty buffer

	//--------------------------------------
	// read pixel data
	if(chk_dst_pixel(s2->dst_addr) == HIT) {
		// check that all dummy are sent
		if(sd_dummy_wd(&(s3->dst_pixel), &(s3->dst_addr)) == RUN) {
			//                           mask 0xff
			// 2개의 destination read buffer에 걸쳐 pixel이 존재할경우 검사.
			if(chk_ld_dst(s2->dst_addr, slot1.dst_pic_ctype,
						   s2->now_hpos) == WAIT) {
				return P_NOP;  // 두번째 dst buffer에 pre-read가 완료될 때까지 기다림.
			} // if

			// get 1 pixel
			s3->dst_pixel = rd_dst_pixel(slot1.dst_pic_ctype, s2->now_hpos);

			return P_RUN;
		}
		else { // if rest dummy
			// 이미 sd_dummy_wd에서 dummy word를 load완료.

			//s2->stall = 1;
			//s3->bypass = 1; // destination pixel color를 그대로 write buffer에 write
			//s3->nop = 1;

			return P_BYPASS;
		}
	} // if hit
	else { // miss
		//s2->stall = 1;
		//s3->bypass = 0;
		//s3->nop = 1;

		return P_NOP;
	} // else. miss

} // dst_pixel



//--------------------------------------------------
// work at stage2
// get destination picture mask pattern
// or send read command
// or wait memory operation
int dst_pat(str_drw_slot2 *s2,str_drw_slot3 *s3)
// s2 : point of the slot2 structure
// s2 : point of the slot3 structure
// return : pipeline mode. run/nop
{
	uint    target_addr;


	//---------------------------------------
	// fill a buffer 
	if(s2->nop == 0 && (chk_dst_pat_full(0) == 0 || chk_dst_pat_full(1) == 0)) {
		if(chk_dst_pat_rd() == NOPMEM) { // if opearation nothing
			target_addr = s2->dst_pat_addr & (~DSTP_BUFF_IDX_MSK); // mask 0x07
			if(chk_dst_pat_full(used_fg) != 0) // if pre-read
				target_addr += DSTP_BUFF_WLEGTH*4; // add 32

			// send read command
			read_dst_pat(target_addr);
		} // if
		else { // when operation is doing
			get_dst_pat(); // if move data from bus to dst_buff.
		} // else
	} // if empty buffer

	//--------------------------------------
	// read pixel data
	if(chk_dst_pat(s2->dst_pat_addr) == HIT) {
		//                           mask 0xff
		// get 1 pixel   rd_dst_pat(int hpos)
		s3->dst_pat = rd_dst_pat(s2->now_hpos);

		return P_RUN;
	} // if hit
	else { // miss
		//s2->stall = 1;
		//s3->bypass = 0;
		//s3->nop = 1;

		return P_NOP;
	} // else. miss

} // dst_pat







//--------------------------------------------------
// work at stage2
// get source pixel color
// or send read command
// or wait memory operation

int src_pixel(str_drw_slot2 *s2,str_drw_slot3 *s3)
// s2 : point of the slot2 structure
// s2 : point of the slot3 structure
// return : pipeline mode. run/nop
{
	int       i;
	uint      t_addr[2];
	uint      hpos;
	uint      *pixel0, *pixel1;
	int       hit[2]; // if hit, 1

	// check hit/miss
	if(src_pixel_st == 0) {	// check hit/miss of the left pixels
		t_addr[0] = s2->src_addr[0];
		t_addr[1] = s2->src_addr[3];
		hpos = s2->src_pixel[0];
		pixel0 = &(s2->src_pixel[0]);
		pixel1 = &(s2->src_pixel[3]);
	} // if left
	else if(src_pixel_st == 1) { // check hit/miss of the right pixels
		t_addr[0] = s2->src_addr[1];
		t_addr[1] = s2->src_addr[2];
		hpos = s2->src_pixel[1];
		pixel0 = &(s2->src_pixel[1]);
		pixel1 = &(s2->src_pixel[2]);
	}// else right
	else { // all complete
		return RUN;
	}
	

	// 두 address 주고 성공적으로 read했으면 Run을 return,
	// read하지 못 했으면 NOP을 return.
	if(src_pixel_st == 1 && s2->src_addr[0] == s2->src_addr[1]) {
		s2->src_pixel[1] = s2->src_pixel[0];
		s2->src_pixel[2] = s2->src_pixel[3];
	} // if same
	else { // not same
		i = rd_src_two(t_addr[0], t_addr[1], hpos,
				   slot1.src_pic_ctype,  pixel0, pixel1);
		if(i == NOP)  return NOP;
	}

	src_pixel_st ++;

	return RUN;

} // src_pixel

/*
{ // old
	int     i;

	uint    target_addr; // memory operation
	uint    pixel_addr; // source pixel address for pixel read
	int     index;      // source 4 pixel중 index

	//---------------------------------------
	// fill a buffer 
	if(s2->nop == 0 && (chk_src_full(0) == 0 || chk_src_full(1) == 0)) {
		if(chk_src_rd() == NOPMEM) { // if opearation nothing
			// next memory operation을 결정.
			if(chk_src_full(0) == 0) {
				if(small_vline == 0) { // small veritcal number
					if(src_pixel_st[0] == 0) // top left pixel read timing
						target_addr = s2->src_addr[0] & (~SRC_BUFF_IDX_MSK); // mask 0x0f
					else target_addr = s2->src_addr[1] & (~SRC_BUFF_IDX_MSK);
				}
				else { // large veritcal number
					if(src_pixel_st[1] == 0) // top left pixel read timing
						target_addr = s2->src_addr[0] & (~SRC_BUFF_IDX_MSK); // mask 0x0f
					else target_addr = s2->src_addr[1] & (~SRC_BUFF_IDX_MSK);
				}
			} // if
			else { //if(chk_src_full(1) == 0)
				if(small_vline == 1) { // small veritcal number
					if(src_pixel_st[0] == 0) // top left pixel read timing
						target_addr = s2->src_addr[0] & (~SRC_BUFF_IDX_MSK); // mask 0x0f
					else target_addr = s2->src_addr[1] & (~SRC_BUFF_IDX_MSK);
				}
				else { // large veritcal number
					if(src_pixel_st[1] == 0) // top left pixel read timing
						target_addr = s2->src_addr[0] & (~SRC_BUFF_IDX_MSK); // mask 0x0f
					else target_addr = s2->src_addr[1] & (~SRC_BUFF_IDX_MSK);
				}
			} // else if
			// send read command
			read_src(target_addr, small_vline);
		} // if
		else {
			get_dst(); // if move data from bus to dst_buff.
		} // else
	} // if empty buffer


	//--------------------------------------
	// read pixel data
	
	// lower vertical number
	for(i=0;i<2;i++) {
		if(src_pixel_st[0] < 2) {
			index = src_pixel_st[0];
			if(chk_src_pixel(s2->src_addr[index],0) == MISS) 
				break;
			if(chk_ld_src(slot1.src_pic_ctype,
						  s2->src_pixel[index].h,0) == WAIT)
				break;
			
			s2->src_pixel[index] = rd_src_pixel(slot1.src_pic_ctype, 
												s2->src_pixel[index].h,0);
			src_pixel_st[0] ++;
		} // if
	} // for

	// higher vertical number
	for(i=0;i<2;i++) {
		if(src_pixel_st[1] < 2) {
			index = 2 + (1&(~src_pixel_st[1]));
			if(chk_src_pixel(s2->src_addr[index],1) == MISS) 
				break;
			if(chk_ld_src(slot1.src_pic_ctype,
						  s2->src_pixel[index].h,1) == WAIT)
				break;
			
			s2->src_pixel[index] = rd_src_pixel(slot1.src_pic_ctype, 
												s2->src_pixel[index].h,1);

			src_pixel_st[1] ++;
		}
	} // for

	if(src_pixel_st[0] >= 2 && src_pixel_st[1] >= 2 ) 
		return P_RUN;
	return P_NOP;
} // src_pixel
*/






//--------------------------------------------------
// work at stage2
// get source picture mask pattern
// or send read command
// or wait memory operation
int src_pat(str_drw_slot2 *s2,str_drw_slot3 *s3)
// s2 : point of the slot2 structure
// s2 : point of the slot3 structure
// return : pipeline mode. run/nop
{
	int       i;
	uint      t_addr[2];
	uint      hpos;
	uint      *pat0, *pat1;
	int       hit[2]; // if hit, 1

	// check hit/miss
	if(src_pat_st == 0) {	// check hit/miss of the left patterns
		t_addr[0] = s2->src_pat_addr[0];
		t_addr[1] = s2->src_pat_addr[3];
		hpos = s2->src_pixel[0];
		pat0 = &(s2->src_pat[0]);
		pat1 = &(s2->src_pat[3]);
	} // if left
	else if(src_pat_st == 1) { // check hit/miss of the right patterns
		t_addr[0] = s2->src_pat_addr[1];
		t_addr[1] = s2->src_pat_addr[2];
		hpos = s2->src_pixel[0]+1;
		pat0 = &(s2->src_pat[1]);
		pat1 = &(s2->src_pat[2]);
	}// else right
	else { // all complete
		return RUN;
	}
	
	// 두 address 주고 성공적으로 read했으면 Run을 return,
	// read하지 못 했으면 NOP을 return.
	if(src_pat_st == 1 && s2->src_pat_addr[0] == s2->src_pat_addr[1]) {
		s2->src_pat[1] = s2->src_pat[0];
		s2->src_pat[2] = s2->src_pat[3];
	} // if same
	else { // not same
		i = rd_src_pat_two(t_addr[0], t_addr[1], hpos, pat0, pat1);
		if(i == NOP)  return NOP;
	}

	src_pat_st ++;

	return RUN;
} // dst_pat




//--------------------------------------------------
// read source picture palette
int src_pal(str_drw_slot2 *s2,str_drw_slot3 *s3, uint color)
// s2 : point of the slot2 structure
// s2 : point of the slot3 structure
// return : pipeline mode. run/nop
{
	uint    target_addr;

	target_addr = s1.src_pal_pnt + (color & 0x0FF);
	target_addr &= (~SRCPL_BUFF_IDX_MSK); // mask 0x03

	//---------------------------------------
	// fill a buffer 
	if(s2->nop == 0 && chk_src_pal_full() == 0) {
		if(chk_src_pal_rd() == NOPMEM) { // if opearation nothing
			// send read command
			read_src_pal(target_addr);
		} // if
		else { // when operation is doing
			get_src_pal(); // if move data from bus to dst_buff.
		} // else
	} // if empty buffer

	//--------------------------------------
	// read pixel data
	if(chk_src_pal(target_addr) == HIT) {
		// get 1 pixel   rd_dst_pat(int hpos)
		s3->src_pal = rd_src_pal(target_addr);

		return P_RUN;
	} // if hit
	else { // miss
		//s2->stall = 1;
		//s3->bypass = 0;
		//s3->nop = 1;

		return P_NOP;
	} // else. miss
	
} // src_pal





//--------------------------------------------------------
// drawing pipeline Stage 3
// stage3 : slot3 --> slot4
//    사용안 하는 pixel정보(dummy)는 bypass flag를 active시켜 다음 stage로 전달.
//    --> 아무런 처리 없이 write buffer로 전달.
//        address는 buffer내에서의 위치 offset.
void stage3(void)
{
	int       i;
	uint      src_cconv[4];


	//----------------------------
	// destination pixel color conversion
	slot4.dst_addr = slot3.dst_addr;
	slot4.dst_pixel = to32bpp(slot1.dst_pic_ctype,slot3.dst_pixel);

	slot4.dst_pat = slot3.dst_pat;

	//-----------------------------
	// source pixel information
	if(slot1.cmd_kind == CCONV && slot1.src_pat_ctype == C8BPP) {
		// if indexed color
		slot4.src_pixel = slot3.src_pal;
		slot4.src_pat = slot3.src_pat[0];
	} // if. indexed color
	else {
		// source pixel color conversion
		for(i=0;i<4;i++) {
			src_cconv[i] = to32bpp(slot1.src_pic_ctype,slot3.src_pixels[i]);
		} // for. color conversion
		
		// source pixel interpolation
		slot4.src_pixel = interp_src_pixel(src_cconv, &slot3.src_pixel_pos);
	} // else
	
	// select a pattern
	slot4.src_pat = interp_src_pat(slot3.src_pat, &slot3.src_pixel_pos);
	

	//------------------------------
	slot4.draw_fcolor = slot3.draw_fcolor;

	slot4.now_vpos = slot3.now_vpos;
	slot4.st_hpos = slot3.st_hpos;
	slot4.ed_hpos = slot3.ed_hpos;
	slot4.now_hpos = slot3.now_hpos;

	//slot4.grad_fill = slot3.grad_fill;
	//slot4.grad_icolor = slot3.grad_icolor;
	
	slot4.brush_pat = slot3.brush_pat;

	slot4.nop = slot3.nop;
	slot4.bypass = slot3.bypass;

	// clear last pixel flag
	slot4.lastp = slot3.lastp;
	
	slot3.stall = 0;

} // stage3







//--------------------------------------------------------
// drawing pipeline Stage 4
// stage4 : slot4 --> slot5
//    사용안 하는 pixel정보(dummy)는 bypass flag를 active시켜 다음 stage로 전달.
//    --> 아무런 처리 없이 write buffer로 전달.
//        address는 buffer내에서의 위치 offset.
//    Pixel Overlay
void stage4(void)
{
	uint     brush_color;
	uint     src_color;


	brush_color = (slot4.brush_pat == 0)? slot1.draw_bcolor : slot4.draw_fcolor;
	src_color = (slot4.brush_pat == 0 || slot4.src_pat == 0)? 0 : slot4.src_pixel;

	if(slot4.dst_pat == 1 && slot4.bypass == 0) { // bypass
		// check overlay mode
		switch(3 & slot1.alpha_raster) {
		case 0 :  // write through
			if(src_pic_pnt == 0) { // no source picture
				if(slot4.brush_pat == 1)
					slot5.dst_pixel = brush_color;
				else slot5.dst_pixel = slot4.dst_pixel;
			} // if
			else { // with source picture
				if(slot4.src_pat == 1 && slot4.brush_pat == 1) { // foreground color
					slot5.dst_pixel = slot4.src_pixel;
				}
				else slot5.dst_pixel = slot4.dst_pixel;
			} // else
			break;
		case 1 : // Raster operation
			slot5.dst_pixel = rast_op(slot1.avalue_rcode, slot4.dst_pixel, 
									  slot4.dst_pat, slot4.src_pixel, 
									  slot4.src_pat, brush_color);
			break;
		default : // Alpha Blending
			if(src_pic_pnt == 0) { // no source picture
				slot5.dst_pixel = alpha_blend(slot1.avalue_rcode, slot1.alpha_choose,
											  slot4.dst_pixel, brush_color);
			} // if
			else { // with source picture
				slot5.dst_pixel = alpha_blend(slot1.avalue_rcode, slot1.alpha_choose,
											  slot4.dst_pixel, src_color);
			}
			break;
		} // switch
	} // if
	else { 
		slot5.dst_pixel = slot4.dst_pixel;
	} // else
	
	slot5.dst_addr = slot4.dst_addr;
	slot5.now_hpos = slot4.now_hpos;
	slot5.ed_hpos = slot4.ed_hpos;

	slot4.stall = 0;
	slot5.bypass = slot4.bypass;
	slot5.nop = slot4.nop;
	
	// clear last pixel flag
	slot5.lastp = slot4.lastp;

} // stage4









//-----------------------------------------------
// drawing pipeline Stage 5
// stage5 : slot5 --> slot6
//    사용안 하는 pixel정보(dummy)는 bypass flag를 active시켜 다음 stage로 전달.
//    --> 아무런 처리 없이 write buffer로 전달.
//        address는 buffer내에서의 위치 offset.
// Exchange color position and color type convert
void stage5(void)
{
	uint     a, r, g, b;
	uint     cnvted_color;

	//----------------------------------------------
	// exchange color position 
	if(slot1.cmd_kind == CCONV) {
		a = (slot5.dst_pixel >> (slot1.sel_a * 8) ) && 0x0ff;
		r = (slot5.dst_pixel >> (slot1.sel_r * 8) ) && 0x0ff;
		g = (slot5.dst_pixel >> (slot1.sel_g * 8) ) && 0x0ff;
		b = (slot5.dst_pixel >> (slot1.sel_b * 8) ) && 0x0ff;

		//----------------------------------------------
		// color type convert
		switch(slot1.cconv_format) {
		case DST_A16BPP :
			if(a == 0) cnvted_color = (r & 0xf8) << (11-3) | (g & 0xf8) << (5-3) | b >> 3;
			else cnvted_color = 1 << 15 | (r & 0xf8) << (11-3) | (g & 0xf8) << (5-3) | b >> 3;
			break;
		case DST_16BPP :
			cnvted_color = (r & 0xf8) << (11-3) | (g & 0xfC) << (5-2) | b >> 3;
			break;
		case DST_24BPP :
			cnvted_color = a << 24 | r << 16 | g << 8 | b;
		case DST_F32BPP :
			if(a == 0) cnvted_color =  r << 16 | g << 8 | b;
			else cnvted_color = 0x80 << 24 | r << 16 | g << 8 | b;
			break;
		case DST_A32BPP :
			cnvted_color = a << 24 | r << 16 | g << 8 | b;
			break;
		default :
			printf("\n ERROR : Unkown Destination type");
			break;
		} // switch
		
	} // if
	else { // normal command
		cnvted_color = from32bpp(slot1.dst_pic_ctype, slot5.dst_pixel);
	} // else
	
	if(slot4.bypass == 0)
		slot6.dst_pixel = cnvted_color;
	else slot6.dst_pixel = slot5.dst_pixel;

	slot6.dst_addr = slot5.dst_addr;
	slot6.now_hpos = slot5.now_hpos;
	slot6.ed_hpos = slot5.ed_hpos;

	slot5.stall = 0;
	slot6.bypass = slot5.bypass;
	slot6.nop = slot5.nop;
	
	// clear last pixel flag
	slot6.lastp = slot5.lastp;
} // stage5









//-------------------------------------------------
// Write to Write buffer then Memory
void stage6(void)
{
	int     fw;   // force writing
	int     wr;
	int     wr_byte;
	int     bit_pos;


	if(slot6.nop != 0) wr = 1;
	else wr = 0;

	switch(slot1.dst_pic_ctype) {
	case MONO : wr_byte = 0; break;
	case C8BPP : wr_byte = 1; break;
	case C16BPP :
	case CA16BPP : wr_byte = 2; break;
	case C24BPP : wr_byte = 3; break;
	case C32BPP :
	case CA32BPP : wr_byte = 4; break;
	default :
		printf("\n ERROR : Unkown color type at write buffer.");
	} // switch

	if(slot1.dst_pic_ctype == MONO)
		bit_pos = slot6.now_hpos & 0x07;
	else bit_pos = 0;

	fw = slot6.lastp;

	stage_wr_buff = sm_wr_buff(slot6.dst_addr, wr_bytes, bit_pos, 
							   slot6.dst_pixel, wr, fw, stage_wr_buff);

	
	if(stage_wr_buff == 0) slot6.stall = 0;
	else 	slot5.stall = 1;

} // stage6









//=================================================
// color type conversion
// To 32BPP
//     if no alpha value, set alpha value to FF.
uint to32bpp(uint ctype, uint color)
// ctype : color type
// color : source color value
// return : converted 32BPP color value
{
	uint   color_32bpp;
	uchar  r,g,b;


	switch(ctype) {
	case MONO :
		if((color & 1) == 0) color_32bpp = (0xff<<24) | 0;
		else                 color_32bpp = 0xFFFFFFFF;
		break;
	case C8BPP :
		color_32bpp = color & 0x0FF;
		color_32bpp = (0x0ff<<24) | (color_32bpp << 16) | 
			(color_32bpp << 8) | color_32bpp;
		break;
	case C16BPP :
		r = 0x01F & (color >> 11);
		r <<= 3;
		if(r != 0) r |= 0x07; // set low bit

		g = 0x03F & (color >>  5);
		g <<= 2;
		if(g != 0) g |= 0x03;

		b = 0x01F & color;
		b <<= 3;
		if(b != 0) b |= 0x07; // set low bit

		color_32bpp = (0x0ff<<24) | (r << 16) | (g << 8) | b;
		break;
	case CA16BPP :
		r = 0x01F & (color >> 10);
		r <<= 3;
		if(r != 0) r |= 0x07; // set low bit

		g = 0x01F & (color >>  5);
		g <<= 3;
		if(g != 0) g |= 0x07;

		b = 0x01F & color;
		b <<= 3;
		if(b != 0) b |= 0x07; // set low bit
		
		// alpha vlaue
		if((color>>16 & 1) == 0) color_32bpp = 0; // alpha value 0
		else color_32bpp = 0x0FF << 24;

		color_32bpp |= (r << 16) | (g << 8) | b;
		break;
	case C24BPP :
		color_32bpp = (0x0ff<<24) | color;
		break;
	case C32BPP :
		color_32bpp = (0x0ff<<24) | color;
		break;
	case CA32BPP:
		color_32bpp = color;
		break;
	default: // error
		printf("\n ERROR : invalide color type that convert to 32bpp at the color convertion block.");
		exit(0);
	} // switch


	return color_32bpp;

} // to32bpp






//-----------------------------------------------------------
// color type conversion
// from 32BPP
//     
uint from32bpp(uint ctype, uint color_32bpp)
// ctype : color type
// color_32bpp : source color value
// return : converted color value
{
	uint   color;
	uchar  r,g,b;

	switch(ctype) {
	case MONO :
		color = (color_32bpp & 1);
		break;
	case C8BPP :
		color = color_32bpp & 0x0FF;
		break;
	case C16BPP :
		r = 0x01F & (color_32bpp >> (16+3));
		g = 0x03F & (color_32bpp >> (8 +2));
		b = 0x01F & (color_32bpp >>     3 );

		color = (r<<11) | (g << 5) | b;
		break;
	case CA16BPP :
		r = 0x01F & (color_32bpp >> (16+3));
		g = 0x01F & (color_32bpp >> (8 +3));
		b = 0x01F & (color_32bpp >>     3 );
		
		// alpha value
		if((color_32bpp & 0xFF000000) == 0)
			color = 0;
		else color = 1 << 15;

		color |= (r<<10) | (g << 5) | b;
		break;
	case C24BPP :
		color = color_32bpp & 0x0ffffff;
		break;
	case C32BPP :
		color = color_32bpp & 0x7fffffff;
		break;
	case CA32BPP:
		color = color_32bpp;
		break;
	default: // error
		printf("\n ERROR : invalide color type that convert from 32bpp at the color convertion block.");
		exit(0);
	} // switch
	
	return color;

} // from32bpp
