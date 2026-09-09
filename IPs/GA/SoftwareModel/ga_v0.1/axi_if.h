/*************************************************************************

   Header of the AXI interface

   file name : axi_if.h
   created by gtlee
   data : 2006.6.23

   note :
       interface to axi bus
          
   history :

************************************************************************/


//=====================================================
// Global








#ifdef __AXI_IF__
//================================================
// Internal

void write_mem(uint addr, void *data, int len);
void read_mem(uint addr, void *data, int len);


#else
//================================================
// External
extern  uchar  *vmm_base;
extern  int     vmm_size;

extern void write_mem(uint addr, void *data, int len);
extern void read_mem(uint addr, void *data, int len);



#endif
