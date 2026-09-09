/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: nand.c 
	Description	: NAND test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

#include "sysinc.h"
#include "system.h"
/*----------------------------------------------------------
	Function name	: CopyDataToMemory
	Prototype		: void CopyDataToMemory(void)
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void CopyDataToMemory(void)
{

  	int i,j;
    smtUint8 	addr1;
    smtUint8 	addr2;
    smtUint8	addr3;
    smtUint8	addr4;
    smtUint8	addr5;
    smtUint32 	regValue;
	smtUint32	readbuffer = 0x60100000;
	volatile smtUint32	buffer;

    smtUint16	blockAddr	= 1;
    smtUint16	pageAddr 	= 0;
    smtUint16	colAddr		= 0;
    smtUint32	readSize	= 0x20000;
    smtUint32	transSize	= 0x5;
    
    extern void Jump(unsigned int);

    
	// NAND init
    NANDCONF	= (TADLTWB|TACLS|TRWLP|TRWHP);
    NANDCTRL	= (FIFOLEVEL|RNBINTEN0|WRENDINTEN|RDENDINTEN|FIFOINTEN);
    
    // NAND reset 
    NANDNFOPER	= (AUTORDSTAT|NOP|WORD|0x2<<8|0x03);
    NANDNFOPER	= (RDSTATCMD<<8|RESETCMD);
    while((NANDSTAT&NFSTATVALID)!=NFSTATVALID);
    NANDSTAT	= NFSTATVALID|RNBDETECT0;
   
    
    for(i = 0; i < 0x600000/0x20000; i++) //shkim-20070404 : load 6MB image
    {
    	blockAddr = i+1;
    	GPIO0_OUT = (i<<8)|GPIO0_IN;
    	for(j = 0; j < 64; j++) 
    	{
	    	pageAddr 	= j;
	    
			// set NAND address
			addr1 = 	colAddr & 0xff;
	    	addr2 = 	(colAddr >> 8) & 0xf;
	    	addr3 = 	(pageAddr & 0x3f) | ((blockAddr & 0x3)<<6);
	    	addr4 = 	(blockAddr>>2)&0xff;
    		addr5 = 	(blockAddr>>10)&0xff;
    
			// set configuration 
			regValue =
	 			((0x0 << 31)							// disable start interrupt
				|(0x0 << 30)							// enable end interrupt
				|(0x0 << 29)							// no using flow control(hand shaking)
				|(0x0 << 28)							// source increasement
				|(0x2 << 26)							// source WORD width, NAND is always word width???
				|(0x1 << 25)							// destination increasement
				|(0x2 << 23)							// target WORD width
				|(0x5 << 20)							// burst size 32 byte
				|(2048));								// total transfer size
	    	
			// DMA control
			DMACSta(0) 		=  0xf;						// disable
        	
			// NAND control
    		NANDSTAT 		=	RDEND;
    		NANDCTRL		= 	(FIFOLEVEL|DMAEN);
	    	NANDNFOPER		= 	(2048<<17|READDATA|WORD<<12|(0x7<<8)|0x41);
	    	NANDNFOPER 		= 	(addr3<<24|addr2<<16|addr1<<8|PAGERDCMD1);
    		NANDNFOPER 		= 	(PAGERDCMD2<<16|addr5<<8|addr4);
        	
			DMACSAdr(0) 	= (smtUint32)&NANDDATA;						// set source address
			DMACDAdr(0) 	= (smtUint32)readbuffer+i*readSize+j*2048;	// set destination address
			DMACCon(0)  	= (smtUint32)regValue;						// set DMA control
			DMACDescrp(0)	= 0x1;										// no descriptor
			DMACSta(0)		= DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK;
        	
			// operation end check
			while(!(DMACSta(0)&0x9));		// DMA end check
	    	while((NANDSTAT&RDEND)!=RDEND); // RdEnd check
    		NANDSTAT = (RDEND|RNBDETECT0);	// status clear
    	}
    }
    
    GPIO0_OUT = 0xf;
    
    Jump(0x60100000);
}
