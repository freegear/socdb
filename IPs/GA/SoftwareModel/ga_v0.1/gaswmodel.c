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

	atexit(exit_fun);

	// initial variables
	if(argc < 2) {
		printf(" ERROR : no configuration file.");
		exit(0);
	}
	cfg(argv[1]);

	// set commands


	// excution commands
	//ga();
	

	// End command
	wr_pic_list(wrflist);
	exit(0);
}

//=============================================================
//
void exit_fun(void)
{
	if(cfg_file != NULL) fclose(cfg_file);
	cfg_file = NULL;
	
	//---------------------------------
	close_mem();
	ld_close();
}


//=============================================================
void cfg(char *cfg_fname)
// cfg_fname : configuration file name
{
	int       cnt; // °³¼ö.
	uint      vmoff;
	char      fname[104];

#ifdef __DEBUG__
	printf("\n Start configuration.");
#endif
	// allocation 
	alloc_vmm(DEF_VMM_SIZE);

#ifdef __DEBUG__
	printf("\n Memory allocation.");
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

	vmoff = MAP_PICS; // 2M~
	cnt = ld_pic(vmoff, fname);

	if(cnt == 0) {
		printf("\n ERROR : picture is not exist.");
		exit(0);
	}
	
	printf("\n Picture loaded : %d.",cnt);

	//---------------------------------------------
	// load palette
	if(fscanf(cfg_file,"%s",fname) == EOF) {
		printf("\n ERROR : unexpected end 2 of the configuration file : %s",
			   cfg_fname);
		exit(0);
	}

	vmoff = MAP_PALETTE; // in ga.h
	cnt = ld_pal_list(vmoff, palette, fname);

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
	vmoff = MAP_CMDLIST;
	// for test
	//cnt = ld_cmdstr(vmoff, cmdstr_list, fname);

	printf("\n Command structure list loaded : %d.",cnt);

	// Destination file name
	//----------------------------------------------
	if(fscanf(cfg_file,"%s",wrflist) == EOF) {
		printf("\n ERROR : no write to file : %s",cfg_fname);
	}
	else 
		printf("\n Write list file name : %s",wrflist);
}

