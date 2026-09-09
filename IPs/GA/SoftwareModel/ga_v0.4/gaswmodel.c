/*************************************************************************

   Graphic Accelerator Software Model Main

   file name : gaswmodel.c
   created by gtlee
   data : 2006.6.28

   note :
          
   history :

************************************************************************/

#define __DEBUG__


#ifndef  __GASWMODEL__
#define  __GASWMODEL__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"

#include "cmd_queue.h"
#include "cmd_buff.h"
#include "pcache.h"

#include "axi_if.h"
#include "ld_file.h"
#include "wr_file.h"


#include "gaswmodel.h"



// Global variables
FILE    *cfg_file = NULL;

//    write list file
char    wrflist[104] = {0};





//=============================================================
//
int main(int argc, char *argv[]) 
{
	int     i;
	int     cmd_num;


	atexit(exit_fun);

	// initial variables
	if(argc < 2) {
		printf(" ERROR : no configuration file.");
		exit(0);
	}
	cfg(argv[1]);

	//-----------------------------
	// convert command picture pointers
	for(i=0;i<100;i++) {
		if(cmdstr_list[i] == 0) break;
		map_pic_pnt(cmdstr_list[i]);
	} // for

	// initialize pixel cache
	init_pcache();

	init_draw(); // init. drawing pipeline

	cmd_num = 0;


	//======================================================
	while(1) {
		// set command queue
		for(;cmd_num<100;cmd_num++) {
			if(cmdstr_list[cmd_num] == 0) break;
			if(str_queue(cmdstr_list[cmd_num]) == FAIL) break; // if full,
		} // for
		
		
		//------------------------------------
		// excution commands
		ga();
	
		
		//------------------------------------
		// check end of command
		if(cmdstr_list[cmd_num] == 0 || cmd_num >= 100) break;
	} // while
	//======================================================


	// End command
	wr_pic_list(wrflist);
	exit(0);
} // main







//=============================================================
//
void exit_fun(void)
{
	
	//---------------------------------
	cfg_close(); // main

	close_pcache(); // free memorys for a pixel cache 

	ld_close(); // at ld_file.c
} // exit_fun







//=============================================================
// load base datas(picture, palette, commands, etc)
//
void cfg(char *cfg_fname)
// cfg_fname : configuration file name
{
	int       cnt; // °³¼ö.
	uint      vmoff;
	char      fname[104];

#ifdef __DEBUG__
	printf("\n Start configuration.");
#endif

	cfg_file = fopen(cfg_fname,"r");
	if(cfg_file == NULL) {
		printf("\n ERROR : cannot open the configuration file : %s",
			   cfg_fname);
		exit(0);
	} // if


	
	//---------------------------------------------
	// Load the pictures
	if(fscanf(cfg_file,"%s",fname) == EOF) {
		printf("\n ERROR : unexpected end 1 of the configuration file : %s",
			   cfg_fname);
		exit(0);
	}

	// Load picture
	cnt = ld_pic(fname);

	if(cnt == 0) { // if no picture
		printf("\n ERROR : picture is not exist.");
		exit(0);
	}
	
	printf("\n Number of the loaded Pictures : %d.",cnt);




	//---------------------------------------------
	// load palette
	if(fscanf(cfg_file,"%s",fname) == EOF) {
		printf("\n ERROR : unexpected end 2 of the configuration file : %s",
			   cfg_fname);
		exit(0);
	}

	cnt = ld_pal_list(fname);

	printf("\n Palette loaded : %d.",cnt);



	//---------------------------------------------
	// Load the Commands
	// get command list file name
	if(fscanf(cfg_file,"%s",fname) == EOF) {
		printf("\n ERROR : unexpected end 2 of the configuration file : %s",
			   cfg_fname);
		exit(0);
	}
	
	// load command
	cnt = ld_cmdstr(fname);

	if(cnt == 0) { // if no command
		printf("\n ERROR : Drawing command is not exist.");
		exit(0);
	}

	printf("\n Command structure list loaded : %d.",cnt);




	// Destination file name
	//----------------------------------------------
	if(fscanf(cfg_file,"%s",wrflist) == EOF) {
		printf("\n ERROR : no write to file : %s",cfg_fname);
	}
	else 
		printf("\n Write list file name : %s",wrflist);
} // cfg








//-----------------------------------------------
// close config file.
void cfg_close(void)
{
	if(cfg_file != NULL) fclose(cfg_file);
	cfg_file = NULL;
} // cfg_close
