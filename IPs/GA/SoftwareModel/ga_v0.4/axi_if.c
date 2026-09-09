/******************************************************

   AXI interface

   file name : axi_if.c
   created by gtlee
   data : 2006.6.23

   note :
       interface to axi bus
       Not used vertual memory
          
   history :

******************************************************/

#ifndef  __AXI_IF__
#define  __AXI_IF__
#endif
  

#define __DEBUG__


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"

#include "axi_if.h"






//------------------------------------------------------

void write_mem(uint addr, uchar *data, int len)
// addr : target address
// data : write data
// len : write size
{
	uchar   *t_addr;
	
	if(addr == 0) {
		printf("\n ERROR : no the memory for write.");
		exit(0);
	}
	t_addr = (uchar *)addr;
	memcpy(t_addr, data, len);
}







void read_mem(uint addr, uchar *data, int len)
// addr : target address
// data : read data
// len  : read size
{
#ifdef __DEBUG__
	int     i;
#endif  // __DEBUG__
	uchar   *t_addr;
	
	if(addr == 0) {
		printf("\n ERROR : no the memory for read.");
		exit(0);
	}
	t_addr = (uchar *)addr;


	for(i=0;i<len;i++) {
		*(data + i) = *(t_addr + i);

#ifdef __DEBUG__
		printf("\n Read Data : %08X : %02Xh",t_addr + i,*(t_addr + i));
#endif // __DEBUG__

	} // for

	//memcpy(data, t_addr,len);
}

