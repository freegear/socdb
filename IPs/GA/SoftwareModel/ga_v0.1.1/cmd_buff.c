/*************************************************************************

   Command Buffer

   file name : cmd_buff.c
   created by gtlee
   data : 2006.6.26
   note :
        Depth : 32
          
   history :

************************************************************************/


#ifndef  __CMD_BUFF__
#define  __CMD_BUFF__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"
#include "gbus.h"
#include "axi_if.h"

#include "cmd_buff.h"

// Command Buffer
uint    cmd_buff[CMDBUFF_DEPTH] = {0};
uint    cmd_pnt; // current command pointer. get from command queue
uint    cmd_pnt_nxt; // pointer for next command

//---------------------------------------
// parsing command linked list
// configuration function~!!!
int lnklist(uint s_addr, uint e_addr)
// s_addr : start offset. byte단위.
// e_addr : end offset. byte단위.
// return : number of command
{
	uint  *n_addr; // now address
	//uint  p_naddr; // the next command address of a previous command structure
	int   cmd_cnt; // command count
	int   cmd_kind;
	int   cmd_len;

	// uint로 단위 변경.
	n_addr = (uint *)(vmm_base + s_addr);

	while((uchar *)n_addr <= (vmm_base+e_addr)) {
		// command type
		cmd_kind = *n_addr & 0x0ff;
		switch(cmd_kind) {
		case LINEDRW :
			cmd_len = (*(n_addr+2) & 0x0ff) * 3 + 12;
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
// load command from virtual memory
int rd_cmds(int spos,int max_num)
// spos : the start position of the command buffer
// max_num : the maximum command length
// return : readed word count
{
	int    rd_wd_num; // read word number

	if((max_num + spos) >= CMDBUFF_DEPTH) rd_wd_num = CMDBUFF_DEPTH-spos;
	else rd_wd_num = max_num;

	if(set_rd_cmd_pal(CMD_STR, cmd_pnt, 0, rd_wd_num,
					  &cmd_buff[spos],0) == FAIL) {
		printf("\n ERROR : command structure read fail.");
		exit(0);
	}

	cmd_pnt += rd_wd_num;
	return rd_wd_num;
} // rd_cmds


//---------------------------------------------
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
int rd_cmd_fst(void)
// return : SUCC/FAIL
{

	if(set_cmd_pnt() == FAIL) return FAIL; // no command

	// if command is exist.
	// read 8 word at first
	rd_cmds(0, 8);
	return SUCC;
} // rd_cmd_fst


// read rest commands
void rd_cmd_rest(void)
{
	//int     cmd_kind;
	int     cmd_len;

	// check the kind of a command
	cmd_kind = rd_cmd_kind();
	switch(cmd_kind) {
	case LINEDRW :
		cmd_len = (rd_cmd_wd>>16) & 0x0ff; // get line count
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



//--------------------------------------------------
// parsing overlay parameter
int par_overlay(uint param)
// param : overlay parameter command
// return : SUCC/FAIL
{
	alpha_rater.kind = (param >> 30) & 0x03;
	alpha_rater.code = (param >> 16) & 0xff;
	alpha_rater.ac = (param >> 29) & 1;
} // par_overlay


//--------------------------------------------------
// parsing position parameter
// position은 signed value이기 때문에 sign확장을 해야 한다.
void par_position(uint param, pos *pos)
// param : position parameter command
// pos : destination position structure
{
	if(param & 0x01000) // minus
		pos->h = 0xfffff000 | param;
	else                // plus
		pos->h = param & 0x0fff;
	
	if((param>>16) & 0x01000) // minus
		pos->h = 0xfffff000 | (param>>16);
	else                // plus
		pos->h = (param >> 16) & 0x0fff;
} // par_position

//--------------------------------------------------
void par_line(uint param)
// param : line option command
{
	line_width = param & 0x0f;
	edge_style = (param>>4) & 1;
	rcle_dir = (param>>5) & 1;
	beel_circle = (param>>6) & 1;
	anti_alias = (param>>7) & 1;
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

