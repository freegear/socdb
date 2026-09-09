/************************************************ 
  NAME    : MMU.C
  DESC	  :
  Revision: 2002.2.28 ver 0.0
 ************************************************/

#include "sysinc.h"
#include "sysdatadef.h"
#include "mmu.h"

// 1) Only the section table is used. 
// 2) The cachable/non-cachable area can be changed by MMT_DEFAULT value.
//    The section size is 1MB.

 

void MMU_Init(void)
{
    int i,j;
    //========================== IMPORTANT NOTE =========================
    //The current stack and code area can't be re-mapped in this routine.
    //If you want memory map mapped freely, your own sophiscated MMU
    //initialization code is needed.
    //===================================================================

    MMU_DisableDCache();
    MMU_DisableICache();

    //If write-back is used,the DCache should be cleared. Dcache must be enabled.
    for(i=0;i<4;i++)
    	for(j=0;j<64;j++)
    	    MMU_CleanInvalidateDCacheSET((i<<30)|(j<<5));
    	    
    MMU_InvalidateICache();
    MMU_InvalidateDCache();    

    
    MMU_DisableMMU();
    MMU_InvalidateTLB();


    //MMU_SetMTT(int vaddrStart,int vaddrEnd,int paddrStart,int attr)   
    MMU_SetMTT(0x40000000,0x4FFFFFFF,0x40000000,RW_NCNB); 	// APB0_STARTADDR
    MMU_SetMTT(0x50000000,0x5FFFFFFF,0x50000000,RW_NCNB);   // APB1_STARTADDR    

#if 1
    //MMU_SetMTT(0x63000000,0x63F00000,0x63000000,RW_CNB); 	// DDR_STARTADDR   15MByte
    //MMU_SetMTT(0x60100000,0x62F00000,0x60100000,RW_CNB); 	// DDR_STARTADDR   48MByte
    MMU_SetMTT(0x62000000,0x63F00000,0x62000000,RW_CNB); 	// DDR_STARTADDR   15MByte
    MMU_SetMTT(0x60100000,0x61F00000,0x60100000,RW_CNB); 	// DDR_STARTADDR   48MByte

    MMU_SetMTT(0x00000000,0x00100000,0x60000000,RW_CNB); 	// DDR_STARTADDR   1 MByte
#else
    MMU_SetMTT(0x62000000,0x63F00000,0x62000000,RW_NCNB); 	// DDR_STARTADDR   32MByte
    MMU_SetMTT(0x60000000,0x61F00000,0x60000000,RW_CNB); 	// DDR_STARTADDR   32MByte
    MMU_SetMTT(0x00000000,0x00200000,0x00000000,RW_CNB); 	// DDR_STARTADDR   2 MByte    
#endif
    MMU_SetMTT(0x20000000,0x20100000,0x20000000,RW_CNB); 	// Internal SRAM   1 MByte
	MMU_SetMTT(0x08000000,0x09000000,0x08000000,RW_NCNB); 	// nor flash   16 MByte    

	// USB
	MMU_SetMTT(USB_FIFOBUF_STARTADDR, USB_FIFOBUF_ENDADDR, USB_FIFOBUF_STARTADDR, RW_NCNB);

    MMU_SetTTBase(MMU_startAddress);
    MMU_SetDomain(0x55555550|DOMAIN1_ATTR|DOMAIN0_ATTR); 
   	//DOMAIN1: no_access, DOMAIN0,2~15=client(AP is checked)
    	
    MMU_EnableMMU();
    MMU_EnableICache();
    MMU_EnableDCache(); //DCache should be turned on after MMU is turned on.
}    
  
    

void MMU_SetMTT(smtUint32 vaddrStart,smtUint32 vaddrEnd,smtUint32 paddrStart,smtUint32 attr)
{
    volatile smtUint32 *pTT;
    volatile int i,nSec;
    pTT=(smtUint32 *)MMU_startAddress+(vaddrStart>>20);
    nSec=(vaddrEnd>>20)-(vaddrStart>>20);
    for(i=0;i<=nSec;i++)*pTT++=attr |(((paddrStart>>20)+i)<<20);
}






