/******************************************************

   AXI interface

   file name : axi_if.c
   created by gtlee
   data : 2006.6.23

   note :
       interface to axi bus
          
   history :

******************************************************/

#ifndef  __AXI_IF__
#define  __AXI_IF__
#endif
  
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"

#include "axi_if.h"


#define __DEBUG__

uchar  *vmm_base = NULL;  // the main memory of the virtual machine
int     vmm_size = 0; // the size of a virtual main mememory 


//======================================================
// allocation virtual main memory
uchar *alloc_vmm(int size)
// size : memory size
// return : memory pointer
{
	if(size < 1024*1024) {
		printf("\n ERROR : vertual main memory size is too small.");
		exit(0);
	}

	vmm_size = size;

	vmm_base = malloc(size);
	if(vmm_base == NULL) {
		printf("\n ERROR : virtual main memory allocation error.");
		exit(0);
	}

	return vmm_base;
}



void close_mem(void)
{
	if(vmm_base != NULL) free(vmm_base);
	vmm_base = NULL;
}


//------------------------------------------------------

void write_mem(uint addr, void *data, int len)
// addr : target address
// data : write data
// len : write size
{
	uchar   *t_addr;
	
	if((addr+len) >= vmm_size) {
		printf("\n ERROR : write a out of the memory.");
		exit(0);
	}
	t_addr = vmm_base + addr;
	memcpy(t_addr, data, len);
}



void read_mem(uint addr, void *data, int len)
// addr : target address
// data : read data
// len  : write size
{
	uchar   *t_addr;
	
	if((addr+len) >= vmm_size) {
		printf("\n ERROR : write a out of the memory.");
		exit(0);
	}
	t_addr = vmm_base + addr;

	memcpy(data, t_addr,len);
}

