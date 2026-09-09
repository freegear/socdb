/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: main.c 
	Description	: NAND test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

#include "sysinc.h"

#define NOR_BASE_ADDR	(0x00020000) // addr of the 2nd sector
#define DDR_IMAGE_BASE	(0x60100000) // addr of DDR
#define FW_IMAGE_SIZE	(0x00600000) // 6MB

/*----------------------------------------------------------
	Function name	: CopyDataToMemory
	Prototype		: void CopyDataToMemory(void)
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void CopyDataToMemory(void)
{
	smtUint32 regData;	
	smtUint32 i;

    extern void Jump(unsigned int test);

 	for(i = 0 ; i < FW_IMAGE_SIZE/0x80000; i++)
	{
		GPIO0_OUT = i;
		// DMA settting for copy
		regData =
 			((0x0 << 31)							// disable start interrupt
			|(0x0 << 30)							// disable end interrupt
			|(0x1 << 29)							// M2M
			|(0x1 << 28)							// source increasement
			|(0x2 << 26)							// source WORD width
			|(0x1 << 25)							// destination increasement
			|(0x2 << 23)							// target WORD width
			|(0x5 << 20)							// burst size 32 byte
			|(0x80000));								// total transfer size 512KB
    				 
		DMACSAdr(0) 	= (smtUint32)NOR_BASE_ADDR	+ i*0x80000;	// set source address
		DMACDAdr(0) 	= (smtUint32)DDR_IMAGE_BASE	+ i*0x80000;	// set destination address
		DMACCon(0)  	= (smtUint32)regData;					// set DMA control
		DMACDescrp(0)	= 0x1;									// no descriptor
		DMACSta(0)		= DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK;
		
		while(!(DMACSta(0)&0x9));		// DMA end check
	}

	Jump(0x60100000);
}