/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name	: lib.c 
	Description	: Basic peripheral library file
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

#define GLOBAL_DEFINE
#include "global.h"

#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

#include "lib.h"
#include "irq.h"


/*
/////////////////////////////////////////////////////////
	F/W VERSION
///////////////////////////////////////////////////////// 
*/
#define SMT_LIB_NAME		"SMT FW Library"
#define SMT_LIB_VER			"100"

GLOBAL_VAR const char smtLibName[16] = SMT_LIB_NAME;
GLOBAL_VAR	const char smtLibVer[8] = SMT_LIB_VER;


/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: smtDelay100us()
	Prototype		: smtBoolean smtDelay100us(smtInt32 time);
	Return			: smtBoolean
	Argument		: time ->  time to delay
	Comments		: function to delay.
	                  time > 0 : the number of loop time
-----------------------------------------------------------*/
smtBoolean smtDelay100us(smtInt32 time)
{
#if 0
    //sysDelay100us(time);  //sysArmLib.c
#else
	{
		smtUint32 i;
		for(i=0; i<(time*100*4); i++)
		{
			// this volatile is effective when compiler cutting over at optimization.
			volatile smtInt32 j;	
			j++;
			j--;
		}
	}
#endif

    return SMT_SUCCESS;
}


/*----------------------------------------------------------
        DMA
-----------------------------------------------------------*/
extern DMA_STRUCT gDmaVariable;


void DMA2Init(smtBoolean polling)
{	
	smtUint32 i;
	
	for(i=0;i<MAX_DMA_CHANNEL;i++)
	{
		gDmaVariable.intOn[i]    = SMT_FALSE;
		gDmaVariable.channel[i] = SMT_FALSE;
		gDmaVariable.status[i] = SMT_FALSE;
	}
	
	gDmaVariable.polling = polling;
}


smtUint32 smt2EDMAChSelect(DMA_DEVICE device, smtUint32 *channel)
{
	smtUint32 i, data;


	for(i=0;i<DMA_MAX_CHANNEL;i++)
	{
		if(gDmaVariable.channel[i] == SMT_FALSE)
		{
			gDmaVariable.channel[i] = SMT_TRUE;
			*channel = i;

			data = SMT_READ(RS_DMAMUX);
			data &= ~(0x000000f<<(i*4));
			data |= (device & 0x000f)<<(i*4);
			SMT_WRITE(RS_DMAMUX, data);

			return SMT_TRUE;
		}
	}

	return SMT_FALSE;
}

/*----------------------------------------------------------
	Function name	: smt2EDMAChDeSelect()
	Prototype		: smtUint32 smt2EDMAChDeSelect(smtUint32 channel)
	Return		: void
	Argument	: void
	Comments	: 
-----------------------------------------------------------*/
smtUint32 smt2EDMAChDeSelect(smtUint32 channel)
{
	gDmaVariable.channel[channel] = SMT_FALSE;

	return SMT_TRUE;

}


/*----------------------------------------------------------
	Function name	: smt2DMAMemToMemCopy()
	Prototype		: smtUint32 smt2DMAMemToMemCopy(void)
	Return		: void
	Argument	: void
	Comments	: 
		Memory to memory copy using DMA
-----------------------------------------------------------*/
smtUint32 smt2EDMACopy(DMA_DEVICE device, EDMA_STRUCT *dma, smtUint8 descCount)
{
	smtUint32 channel = 0;
	smtUint32 ret;

	ret = smt2EDMAChSelect(device, &channel);
	if(ret==SMT_FALSE)
	{
		// CHANNEL allocation failure
		return SMT_FALSE;
	}

	
	if(gDmaVariable.polling==SMT_FALSE)
	{
		Disable_IRQ();
		EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
		RequestIRQ(channel, DmaIRQHandler);
		Enable_IRQ();				
	}

	if(descCount==1)
		smt2EDMANoDescriptor(dma, channel);
	else
		smt2EDMAUseDescriptor(dma, channel, descCount);

	if(gDmaVariable.polling==SMT_FALSE)
	{
		ReleaseIRQ(channel);
	}

	ret = smt2EDMAChDeSelect(channel);
	if(ret==SMT_FALSE)
	{
		// CHANNEL allocation failure
		return SMT_FALSE;
	}
	
	return SMT_TRUE;

}

smtUint32 smt2EDMANoDescriptor(EDMA_STRUCT *dma, smtUint32 channel)
{
	smtUint32 reg;
	EDMA_STRUCT *pEDma = dma;
	smtUint32 totLength, splitLength;


	pEDma = dma;
	totLength = pEDma->nBytes;
	while(1)
	{
		if(totLength > DMA_MAX_SZ)
			splitLength = DMA_MAX_SZ;
		else
			splitLength = totLength;	
			
		SMT_WRITE(DMACSta(channel), 0xF);	

		SMT_WRITE (DMACSAdr(channel), (smtUint32)pEDma->src);
		SMT_WRITE (DMACDAdr(channel), (smtUint32)pEDma->dst);

		SMT_WRITE (DMACCon (channel),
			 ((pEDma->startIntEn&0x1)<<31)
			|((pEDma->EndIntEn&0x1)<<30)
			|((pEDma->m2m&0x1)<<29)		
			|((pEDma->srcInc&0x1)<<28)
			|((pEDma->srcWidth&0x3)<< 26)
			|((pEDma->dstInc&0x1)<<25)
			|((pEDma->dstWidth&0x3)<<23)
			|((pEDma->tSize&0x7)<<20)
			|(totLength&0xFFFFF));
			
		SMT_WRITE (DMACDescrp(channel), DMA_DESCREND_MASK);
		SMT_WRITE (DMACSta(channel), DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK|DMA_STOPINTEN_MASK);


		if(gDmaVariable.polling==SMT_TRUE)
		{
			while(1)
			{
				reg = SMT_READ(DMACSta(channel));
				
				if(reg&DMA2D_STOPINTEN_MASK) 
				{
					SMT_WRITE(DMACSta(channel), 0x0F);

					if(pEDma->intFunction!=0x0)
						pEDma->intFunction(channel);
										
					if(reg&DMA2D_ERRINT_MASK) goto out;//return ERR_DMA_TRANSFAIL;
					else break;
				}
			}
		}
		else		
		{
			while(1)
			{
				if(gDmaVariable.intOn[channel]==SMT_TRUE) 
				{
					if(pEDma->intFunction!=0x0)
						pEDma->intFunction(channel);
					
					gDmaVariable.intOn[channel] =SMT_FALSE;
					break;
				}
			}
		}
						
		totLength -= splitLength;
		if(totLength==0) goto out;

	}
	
out:
	
	return SMT_TRUE;
}

smtUint32 smt2EDMAUseDescriptor(EDMA_STRUCT *dma, smtUint8 channel, smtUint8 descCount)
{
	EDMA_STRUCT *pEDma = dma;
	smtUint32 *descriptor, *p_desc;
	smtUint32 count, reg;
		
	descriptor = (smtUint32 *)malloc(4 * descCount);
	if(descriptor==0)
	{
		;
	}

	p_desc = descriptor;
	for(count=0;count<descCount;count++)
	{
		// src address
		*p_desc++ = pEDma->src;
		
		// dest address
		*p_desc++ = pEDma->dst;
		
		// control
		*p_desc++ = ((pEDma->startIntEn&0x1)<<31)	|
					((pEDma->EndIntEn&0x1)<<30)		|
					((pEDma->m2m&0x1)<<29)			|		
					((pEDma->srcInc&0x1)<<26)		|
					((pEDma->srcWidth&0x3) << 24)	|
					((pEDma->dstInc&0x1)<<22)		|
					((pEDma->dstWidth&0x3)<<20)		|
					((pEDma->tSize&0x7)<<16)		|
					((pEDma->nBytes&0xFFFFF));

		
		// next descriptor
		*p_desc++ = 4 + (smtUint32)&p_desc;
		
		pEDma++;
	}
	
	if(gDmaVariable.polling==SMT_TRUE)
	{
		while(1)
		{
			reg = SMT_READ(DMACSta(channel));
			
			if(reg&DMA2D_STOPINTEN_MASK) 
			{
				SMT_WRITE(DMACSta(channel), 0x0F);

				if(pEDma->intFunction!=0x0)
					pEDma->intFunction(channel);
									
				if(reg&DMA2D_ERRINT_MASK) goto out;//return ERR_DMA_TRANSFAIL;
				else break;
			}
		}
	}
	else		
	{
		while(1)
		{
			if(gDmaVariable.intOn[channel]==SMT_TRUE) 
			{
				if(pEDma->intFunction!=0x0)
					pEDma->intFunction(channel);

				gDmaVariable.intOn[channel] =SMT_FALSE;
				break;
			}
		}
	}

	// if interrupt then 	ptEDMAIntFunction()
out:	
	
	if(descriptor!=0x0)
		free(descriptor);	
	
	return SMT_TRUE;

}



smtUint32 smt2DMAMemCopy(smtUint32 *src, smtUint32 *dst, smtUint32 length)
{
	smtUint32 len64K = (1024*64 -1);
	smtUint32 totLength, splitLength, reg;

	if(gDmaVariable.polling==SMT_FALSE)
	{
		Disable_IRQ();
		EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
		RequestIRQ(IRQ_DMA2D, DmaIRQHandler);
		Enable_IRQ();				
	}

	totLength = length;

	while(1)
	{
		if(totLength > len64K)
			splitLength = len64K;
		else
			splitLength = totLength;

#if 0
		SMT_WRITE(DMA2D_STATUS,DMA2D_STOPINT_MASK);

		SMT_WRITE(DMA2D_SRCADDR, src);
		SMT_WRITE(DMA2D_DSTADDR, dst);

		SMT_WRITE(DMA2D_SIZE, splitLength);
		SMT_WRITE(DMA2D_CNT,(0<<16)|splitLength);	
		SMT_WRITE(DMA2D_ADDRUPD,(0<<16)|0);

		SMT_WRITE(DMA2D_STATUS, SMT_READ(DMA2D_STATUS)
						| DMA2D_EN_MASK
						| DMA2D_STOPINTEN_MASK
						| DMA2D_STOPINT_MASK
						| DMA2D_ERRINT_MASK);


		if(gDmaVariable.polling==SMT_TRUE)
		{
			while(1)
			{
				reg = SMT_READ(DMA2D_STATUS);
				
				if(reg&DMA2D_STOPINT_MASK) 
				{									

					SMT_WRITE(DMA2D_STATUS,DMA2D_STOPINT_MASK);
					if(reg&DMA2D_ERRINT_MASK) goto out;//return ERR_DMA_TRANSFAIL;
					else break;
				}
			}
		}
		else		
		{
			while(1)
			{
				if(gDmaVariable.intOn[IRQ_DMA2D]==SMT_TRUE) 
				{
					SMT_WRITE(DMA2D_STATUS,DMA2D_STOPINT_MASK);
					gDmaVariable.intOn[IRQ_DMA2D] =SMT_FALSE;
					break;
				}
			}
		}
#endif


		totLength -= splitLength;
		if(totLength==0) goto out;

		(smtUint8 *)src += splitLength;
		(smtUint8 *)dst += splitLength;
	}

out:

	if(gDmaVariable.polling==SMT_FALSE)
	{
		ReleaseIRQ(IRQ_DMA2D);
	}
	
	return SMT_TRUE;
	
}

/*----------------------------------------------------------
        MEMORY
-----------------------------------------------------------*/
/* ESMC */
/*----------------------------------------------------------
	Function name	: smtSRAMSetMode()
	Prototype		: smtBoolean smtSRAMSetMode (ESMC_CON sramCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Setting the sram control
-----------------------------------------------------------*/
smtBoolean smtSRAMSetMode(ESMC_CON sramCtrl, smtUint8 bankSel)
{
#if ESRAM_NOT_SUPPORTED
	smtUint32 addr;
	smtUint32 writeData;

	switch(bankSel)
	{
		case SMC_BANK0 :
			addr = ESMC_B0_CON;
			break;
		case SMC_BANK1 :
			addr = ESMC_B1_CON;
			break;
		case SMC_BANK2 :
			addr = ESMC_B2_CON;
			break;
		case SMC_BANK3 :
			addr = ESMC_B3_CON;
			break;

		default :
			return SMT_ERROR;
	}

	writeData =
		( (sramCtrl.aSetup	<<SHIFT_DN_FROM_MASK(TAS_MASK))		& TAS_MASK) |
		( (sramCtrl.csSetup	<<SHIFT_DN_FROM_MASK(TCSS_MASK))	& TCSS_MASK) |
		( (sramCtrl.access	<<SHIFT_DN_FROM_MASK(TACC_MASK))	& TACC_MASK) |
		( (sramCtrl.csHold	<<SHIFT_DN_FROM_MASK(TCSH_MASK))	& TCSH_MASK) |
		( (sramCtrl.aHold		<<SHIFT_DN_FROM_MASK(TAH_MASK))		& TAH_MASK)|
		( (sramCtrl.busWidth	<<SHIFT_DN_FROM_MASK(WIDTH_MASK))	& WIDTH_MASK) |
		( (sramCtrl.addrShift	<<SHIFT_DN_FROM_MASK(SHIFT_MASK))	& SHIFT_MASK) ;
		
	SMT_WRITE(addr, writeData);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}

/*----------------------------------------------------------
	Function name	: smtSRAMGetMode()
	Prototype		: smtBoolean smtSRAMGetMode (ESMC_CON sramCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Getting the sram control
-----------------------------------------------------------*/
smtBoolean smtSRAMGetMode(ESMC_CON sramCtrl, smtUint8 bankSel)
{
#if ESRAM_NOT_SUPPORTED
	smtUint32 addr;
	smtUint32 readData;

	switch(bankSel)
	{
		case SMC_BANK0 :
			addr = ESMC_B0_CON;
			break;
		case SMC_BANK1 :
			addr = ESMC_B1_CON;
			break;
		case SMC_BANK2 :
			addr = ESMC_B2_CON;
			break;
		case SMC_BANK3 :
			addr = ESMC_B3_CON;
			break;

		default :
			return SMT_ERROR;
	}

	readData = SMT_READ(addr);
	sramCtrl.aSetup	= (readData & TAS_MASK)	>> SHIFT_DN_FROM_MASK(TAS_MASK);
	sramCtrl.csSetup	= (readData & TCSS_MASK)	>> SHIFT_DN_FROM_MASK(TCSS_MASK);
	sramCtrl.access	= (readData & TACC_MASK)	>> SHIFT_DN_FROM_MASK(TACC_MASK);
	sramCtrl.csHold	= (readData & TCSH_MASK)	>> SHIFT_DN_FROM_MASK(TCSH_MASK);
	sramCtrl.aHold	= (readData & TAH_MASK)	>> SHIFT_DN_FROM_MASK(TAH_MASK);
	sramCtrl.busWidth= (readData & WIDTH_MASK)>>SHIFT_DN_FROM_MASK(WIDTH_MASK);
	sramCtrl.addrShift= (readData & SHIFT_MASK)	>> SHIFT_DN_FROM_MASK(SHIFT_MASK);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}

/*----------------------------------------------------------
	Function name	: smtMemWrite()
	Prototype		: smtBoolean smtMemWrite
						(smtUint32 addr, smtUint32 *data, smtUint32 length)
	Return			: error code
	Argument		:
	Comments		: Write operation
		Write data to memory as length
-----------------------------------------------------------*/
smtBoolean smtMemWrite(smtUint32 addr, smtUint32 *data, smtUint32 length)
{
	smtUint32 size;
	smtUint32 memAddr;
	
	memAddr = addr;
	
	for(size=0; size<length/4; size++)
	{
		SMT_WRITE((*(smtUint32 *)memAddr), *(data+size));
		memAddr += 4;
	}
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtMemRead()
	Prototype		: smtBoolean smtMemRead(void)
	Return			: error code
	Argument		:
	Comments		: Write operation
		Normal program
-----------------------------------------------------------*/
smtBoolean smtMemRead(smtUint32 addr, smtUint32 *data, smtUint32 length)
{
	smtUint32 size;
	smtUint32 memAddr;
	
	memAddr = addr;
	
	for(size=0; size<length/4; size++)
	{
		*(data+size) = SMT_READ((*(smtUint32 *)memAddr));
		memAddr += 4;
	}
	
	return SMT_SUCCESS;
}

/* ESDMC */
/*----------------------------------------------------------
	Function name	: smtSDRAMSetTimeCtrl()
	Prototype		: smtBoolean smtSDRAMSetTimeCtrl (ESDMC_TCON timeCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Set SDRAM timing control
-----------------------------------------------------------*/
smtBoolean smtSDRAMSetTimeCtrl(ESDMC_TCON timeCtrl)
{
#if ESDRAM_NOT_SUPPORTED
	smtUint32 writeData;

	writeData =
		( (timeCtrl.tRowCycle	<<SHIFT_DN_FROM_MASK(TRC_MASK))	& TRC_MASK) |
		( (timeCtrl.tRowActive	<<SHIFT_DN_FROM_MASK(TRAS_MASK))& TRAS_MASK) |
		( (timeCtrl.tCasLatency<<SHIFT_DN_FROM_MASK(TCL_MASK))	& TCL_MASK) |
		( (timeCtrl.tDelay		<<SHIFT_DN_FROM_MASK(TRCD_MASK))& TRCD_MASK) |
		( (timeCtrl.tPrecharge	<<SHIFT_DN_FROM_MASK(TRP_MASK))	& TRP_MASK);
		
	SMT_WRITE(SDRTCON, writeData);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif

}

/*----------------------------------------------------------
	Function name	: smtSDRAMGetTimeCtrl()
	Prototype		: smtBoolean smtSDRAMGetTimeCtrl (ESDMC_TCON timeCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Get SDRAM Timing cotrol inform
-----------------------------------------------------------*/
smtBoolean smtSDRAMGetTimeCtrl(ESDMC_TCON timeCtrl)
{
#if ESDRAM_NOT_SUPPORTED
	smtUint32 readData;

	readData = SMT_READ(SDRTCON);
	timeCtrl.tRowCycle	= (readData & TRC_MASK)	>> SHIFT_DN_FROM_MASK(TRC_MASK);
	timeCtrl.tRowActive	= (readData & TRAS_MASK)	>> SHIFT_DN_FROM_MASK(TRAS_MASK);
	timeCtrl.tCasLatency	= (readData & TCL_MASK)	>> SHIFT_DN_FROM_MASK(TCL_MASK);
	timeCtrl.tDelay		= (readData & TRCD_MASK)	>> SHIFT_DN_FROM_MASK(TRCD_MASK);
	timeCtrl.tPrecharge	= (readData & TRP_MASK)	>> SHIFT_DN_FROM_MASK(TRP_MASK);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}

/*----------------------------------------------------------
	Function name	: smtSDRAMSetCtrl()
	Prototype		: smtBoolean smtSDRAMSetCtrl (ESDMC_CON sdramCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Set SDRAM control
-----------------------------------------------------------*/
smtBoolean smtSDRAMSetCtrl(ESDMC_CON sdramCtrl)
{
#if ESDRAM_NOT_SUPPORTED
	smtUint32 writeData;

	writeData =
		( (sdramCtrl.bitSel		<<SHIFT_DN_FROM_MASK(BIT16SEL_MASK))		& BIT16SEL_MASK) |
		( (sdramCtrl.colAddrSize	<<SHIFT_DN_FROM_MASK(COLADDRSIZ_MASK))	& COLADDRSIZ_MASK) |
		( (sdramCtrl.addrSwapEn	<<SHIFT_DN_FROM_MASK(ADDRSWAPEN_MASK))	& ADDRSWAPEN_MASK) |
		( (sdramCtrl.sdramEn		<<SHIFT_DN_FROM_MASK(SDREN_MASK))		& SDREN_MASK);
		
	SMT_WRITE(SDRCON, writeData);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif	
}

/*----------------------------------------------------------
	Function name	: smtSDRAMGetCtrl()
	Prototype		: smtBoolean smtSDRAMGetCtrl (ESDMC_CON sdramCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Get SDRAM cotrol inform
-----------------------------------------------------------*/
smtBoolean smtSDRAMGetCtrl(ESDMC_CON sdramCtrl)
{
#if ESDRAM_NOT_SUPPORTED
	smtUint32 readData;

	readData = SMT_READ(SDRCON);
	sdramCtrl.bitSel		= (readData & BIT16SEL_MASK)		>> SHIFT_DN_FROM_MASK(BIT16SEL_MASK);
	sdramCtrl.colAddrSize	= (readData & COLADDRSIZ_MASK)	>> SHIFT_DN_FROM_MASK(COLADDRSIZ_MASK);
	sdramCtrl.addrSwapEn	= (readData & ADDRSWAPEN_MASK)	>> SHIFT_DN_FROM_MASK(ADDRSWAPEN_MASK);
	sdramCtrl.sdramEn	= (readData & SDREN_MASK)		>> SHIFT_DN_FROM_MASK(SDREN_MASK);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif	
}

/*----------------------------------------------------------
	Function name	: smtSDRAMSetPWRCtrl()
	Prototype		: smtBoolean smtSDRAMSetPWRCtrl (ESDMC_PWR_CON pwrCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Set SDRAM power control
-----------------------------------------------------------*/
smtBoolean smtSDRAMSetPWRCtrl(ESDMC_PWR_CON pwrCtrl)
{
#if ESDRAM_NOT_SUPPORTED
	smtUint32 writeData;

	writeData =
		( (pwrCtrl.pwdnRef	<<SHIFT_DN_FROM_MASK(SEFLREFEN_MASK))	& SEFLREFEN_MASK) |
		( (pwrCtrl.selfRefEn	<<SHIFT_DN_FROM_MASK(PWDNEN_MASK))		& PWDNEN_MASK) |
		( (pwrCtrl.pwdnEn		<<SHIFT_DN_FROM_MASK(PWDNREF_MASK))	& PWDNREF_MASK);
		
	SMT_WRITE(SDRPCON, writeData);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif		
}

/*----------------------------------------------------------
	Function name	: smtSDRAMGetPWRCtrl()
	Prototype		: smtBoolean smtSDRAMGetPWRCtrl (ESDMC_PWR_CON pwrCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Get SDRAM power cotrol inform
-----------------------------------------------------------*/
smtBoolean smtSDRAMGetPWRCtrl(ESDMC_PWR_CON pwrCtrl)
{
#if ESDRAM_NOT_SUPPORTED
	smtUint32 readData;

	readData = SMT_READ(SDRPCON);
	pwrCtrl.pwdnRef	= (readData & SEFLREFEN_MASK)	>> SHIFT_DN_FROM_MASK(SEFLREFEN_MASK);
	pwrCtrl.selfRefEn	= (readData & PWDNEN_MASK)	>> SHIFT_DN_FROM_MASK(PWDNEN_MASK);
	pwrCtrl.pwdnEn	= (readData & PWDNREF_MASK)	>> SHIFT_DN_FROM_MASK(PWDNREF_MASK);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif		
}

/*----------------------------------------------------------
	Function name	: smtSDRAMSetRefreshCtrl()
	Prototype		: smtBoolean smtSDRAMSetRefreshCtrl (ESDMC_REF_CON refreshCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Set SDRAM refresh control
-----------------------------------------------------------*/
smtBoolean smtSDRAMSetRefreshCtrl(ESDMC_REF_CON refreshCtrl)
{
#if ESDRAM_NOT_SUPPORTED
	smtUint32 writeData;

	writeData =
		( (refreshCtrl.refCount<<SHIFT_DN_FROM_MASK(REFNUM_MASK))		& REFNUM_MASK) |
		( (refreshCtrl.refNum	<<SHIFT_DN_FROM_MASK(REFCOUNT_MASK))	& REFCOUNT_MASK);
		
	SMT_WRITE(SDRREF, writeData);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif		
}

/*----------------------------------------------------------
	Function name	: smtSDRAMGetRefreshCtrl()
	Prototype		: smtBoolean smtSDRAMGetRefreshCtrl (ESDMC_REF_CON refreshCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Get SDRAM refresh cotrol inform
-----------------------------------------------------------*/
smtBoolean smtSDRAMGetRefreshCtrl(ESDMC_REF_CON refreshCtrl)
{
#if ESDRAM_NOT_SUPPORTED
	smtUint32 readData;

	readData = SMT_READ(SDRREF);
	refreshCtrl.refCount	= (readData & REFNUM_MASK)	>> SHIFT_DN_FROM_MASK(REFNUM_MASK);
	refreshCtrl.refNum	= (readData & REFCOUNT_MASK)	>> SHIFT_DN_FROM_MASK(REFCOUNT_MASK);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif		
}


/*----------------------------------------------------------
        TIMER & PWM
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtTIMERSetMode()
	Prototype		: void smtTIMERSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
	Return		: void
	Argument	:
	Comments	: 
		Set timer mode
-----------------------------------------------------------*/
void smtTIMERSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
	smtUint32 addr;

	addr = TIMER_BASEADDR + 0x10*timerSel;

	#if 1
	SMT_WRITE((*(volatile smtUint32*)(addr+0x00)), timer.data);
	SMT_WRITE((*(volatile smtUint32*)(addr+0x04)), (timer.prescale & 0x3FF));
	SMT_WRITE((*(volatile smtUint32*)(addr+0x08)), 
											 ( ((timer.timerEn & 0x1)	<< 0)
											 | ((timer.timerClear & 0x1)	<< 1)
											 | ((timer.opMode & 0x1)	<< 2))
											 );
	#endif

#if 0
	SMT_WRITE(TIMERDAT(timerSel), timer.data);
	SMT_WRITE(TIMERPRE(timerSel), (timer.prescale & 0x3FF));


	/*
	SMT_WRITE(TIMERCON(timerSel), 
								   ((timer.timerEn & 0x1)	<< 0)
								 | ((timer.timerClear & 0x1)	<< 1)
								 | ((timer.opMode & 0x1)	<< 2) );
	*/


	SMT_WRITE(TIMERCON(timerSel), 
								   ((timer.timerEn << 0)	& 0x1)
								 | ((timer.timerClear << 1)	& 0x2)
								 | ((timer.opMode << 2)	& 0x4) );
#endif
}

/*----------------------------------------------------------
	Function name	: smtTIMERGetMode()
	Prototype		: void smtTIMERGetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
	Return		: void
	Argument	:
	Comments	: 
		Get timer mode
-----------------------------------------------------------*/
void smtTIMERGetMode(TIMER_STRUCT *timer, TIMER_SEL timerSel)
{
	smtUint32 addr;
	smtUint32 control;
	
	addr = TIMER_BASEADDR + 0x10*timerSel;

	timer->data		= SMT_READ(*(volatile smtUint32*)(addr+0x00));
	timer->prescale	= (smtUint16)(SMT_READ(*(volatile smtUint32*)(addr+0x04)) & 0x3FF);

	control = SMT_READ(*(volatile smtUint32*)(addr+0x08));
	timer->timerEn	= (smtUint8)(control & 0x01);
	timer->timerClear= (smtUint8)(control & 0x02);
	timer->opMode	= (smtUint8)(control & 0x04);
}

/*----------------------------------------------------------
	Function name	: smtTIMERClrCount()
	Prototype		: void smtTIMERClrCount(smtUint8 timerCh)
	Return		: void
	Argument	:
	Comments	: 
		Set timer mode
-----------------------------------------------------------*/
void smtTIMERClrCount(smtUint8 timerCh)
{
	smtUint32 rdData;

	rdData = SMT_READ(TIMERCON(timerCh));
	rdData |= 0x2;		// Timer counter Clear
	SMT_WRITE(TIMERCON(timerCh), rdData);
}

/*----------------------------------------------------------
	Function name	: smtTIMEROperation()
	Prototype		: void smtTIMEROperation(TIMER_STRUCT timer, TIMER_SEL timerSel);
	Return		: void
	Argument	:
	Comments	: 
		Timer start or stop
		You need to GPIO set before use the smtTimerOperatoin().
			ex)
			smtTimerOperation(timer, timerSel);
-----------------------------------------------------------*/
void smtTIMEROperation(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
	if(timer.timerEn == SMT_TRUE)       // When timer enable
		smtTIMERSetMode(timer, timerSel);
}


/*----------------------------------------------------------
        WDT
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtWDTSetMode()
	Prototype		: void smtWDTSetMode(WDT_STRUCT wdt);
	Return		: smtBoolean
	Argument	: WDT struct
	Comments	: 
		Set the WDT mode
-----------------------------------------------------------*/
void smtWDTSetMode(WDT_STRUCT wdt)
{
	SMT_WRITE(WDTPSR, wdt.preScale);
	SMT_WRITE(WDTLDR, wdt.reloadValue);
	
	SMT_WRITE(WDTCON,
		((wdt.div & 0x3)	<< 0x4) |
		((wdt.clkSel & 0x1)	<< 0x3) |
		((wdt.intEn & 0x1)	<< 0x2) |
		((wdt.rstEn & 0x1)	<< 0x1) |
		((wdt.wdtEn & 0x1)	<< 0x0)	);
}

/*----------------------------------------------------------
	Function name	: smtWDTGetMode()
	Prototype		: void smtWDTGetMode(WDT_STRUCT *wdt);
	Return		: void
	Argument	: WDT struct
	Comments	: 
		Get the WDT mode
-----------------------------------------------------------*/
void smtWDTGetMode(WDT_STRUCT *wdt)
{
	smtUint32 rdData;

	rdData = SMT_READ(WDTPSR);
	wdt->preScale	= (rdData >> 0) & 0xFFFF;

	rdData = SMT_READ(WDTLDR);
	wdt->reloadValue= (rdData >> 0) & 0xFFFF;

	rdData = SMT_READ(WDTCON);
	wdt->div	= (rdData >> 4) & 0x3;
	wdt->clkSel	= (rdData >> 3) & 0x1;
	wdt->intEn	= (rdData >> 2) & 0x1;
	wdt->rstEn	= (rdData >> 1) & 0x1;
	wdt->wdtEn	= (rdData >> 0) & 0x1;
}

/*----------------------------------------------------------
	Function name	: smtWDTGetCount()
	Prototype		: void smtWDTGetCount(smtUint16 *count)
	Return		: void
	Argument	: 
	Comments	: 
		Get the WDT count
-----------------------------------------------------------*/
void smtWDTGetCount(smtUint16 *count)
{
	smtUint32 rdData;
	rdData = SMT_READ(WDTCNT);
	*count = rdData & 0xFFFF;
}

/*----------------------------------------------------------
	Function name	: smtWDTClearISR()
	Prototype		: void smtWDTClearISR()
	Return		: void
	Argument	: 
	Comments	: 
		clear the WDT interrupt status
-----------------------------------------------------------*/
void smtWDTClearISR(void)
{
	SMT_WRITE(WDTISR, 0x2);
}

/*----------------------------------------------------------
	Function name	: smtWDTGetISR()
	Prototype		: void smtWDTGetISR(smtUint16 *count)
	Return		: void
	Argument	: 
	Comments	: 
		Get the WDT interrupt status
-----------------------------------------------------------*/
void smtWDTGetISR(smtUint8 *intrStatus)
{
	smtUint32 rdData;
	rdData = SMT_READ(WDTISR);
	*intrStatus = rdData & 0x1;
}

/*----------------------------------------------------------
        GPIO
--------------------------------------------------------- */
/*----------------------------------------------------------
	Function name	: smtGPIOSetDefault()
	Prototype		: void smtGPIOSetDefault(void);
	Return		: void
	Argument	:
	Comments	: 
		Set the GPIO default mode
-----------------------------------------------------------*/
void smtGPIOSetDefault(void)
{
	SMT_WRITE(GPIO0_OE,	GPIO_MODE_IN);		// GPIO0 input mode
	SMT_WRITE(GPIO0_INTEN, GPIO_INT_DISABLE);	// GPIO0 interrupt disable
	SMT_WRITE(GPIO0_INTLEVEL, GPIO_INT_EDGE);	// GPIO0 edge interrupt
	SMT_WRITE(GPIO0_INTPOL, GPIO_INT_LOW_POLARITY);// GPIO0 active low
	SMT_WRITE(GPIO0_INTBEDGE, GPIO_INT_SINGLE_EDGE);// GPIO0 interrupt single edge
	SMT_WRITE(GPIO0_INTSTAT, ~0);	// GPIO0 interrupt pending clear

	SMT_WRITE(GPIO1_OE,	GPIO_MODE_IN);		// GPIO0 input mode
	SMT_WRITE(GPIO1_INTEN, GPIO_INT_DISABLE);	// GPIO0 interrupt disable
	SMT_WRITE(GPIO1_INTLEVEL, GPIO_INT_EDGE);	// GPIO0 edge interrupt
	SMT_WRITE(GPIO1_INTPOL, GPIO_INT_LOW_POLARITY);// GPIO0 active low
	SMT_WRITE(GPIO1_INTBEDGE, GPIO_INT_SINGLE_EDGE);// GPIO0 interrupt single edge
	SMT_WRITE(GPIO1_INTSTAT, ~0);	// GPIO0 interrupt pending clear
}

/*----------------------------------------------------------
	Function name	: smtGPIOSetDir()
	Prototype		: void smtGPIOSetDir(smtUint8 channel, smtUint8 gpioNum, smtUint32 mode)
	Return		: void
	Argument	: GPIO type & GPIO mode
	Comments	: 
		Set the GPIO mode
-----------------------------------------------------------*/
void smtGPIOSetDir(smtUint8 channel, smtUint8 gpioNum, smtUint32 mode)
{
	smtUint32 rdData;


	rdData = SMT_READ(GPIO_OE(channel));
	rdData &= ~(0x1 << gpioNum);
	rdData |= ((mode & 0x1) << gpioNum);

	SMT_WRITE(GPIO_OE(channel), rdData);
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetDir()
	Prototype		: void smtGPIOGetDir(smtUint8 channel, smtUint8 gpioNum, smtUint32 *mode)
	Return		: void
	Argument	: GPIO type
	Comments	: 
		Get the GPIO mode
-----------------------------------------------------------*/
void smtGPIOGetDir(smtUint8 channel, smtUint8 gpioNum, smtUint32 *mode)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_OE(channel));
	*mode = (rdData >> gpioNum) & 0x1;
}

/*----------------------------------------------------------
	Function name	: smtGPIOSetData()
	Prototype		: smtUint8 smtGPIOSetData(smtUint8 channel, smtUint8 gpioNum, smtUint32 data)
	Return		: void
	Argument	: GPIO type & GPIO data
	Comments	: 
		Set the GPIO data
-----------------------------------------------------------*/
void smtGPIOSetData(smtUint8 channel, smtUint8 gpioNum, smtUint32 data)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_OUT(channel));
	rdData &= ~(0x1 << gpioNum);
	data = (data & 0x1) << gpioNum;
	rdData |= data;

	SMT_WRITE(GPIO_OUT(channel), rdData);
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetData()
	Prototype		: void smtGPIOGetData(smtUint8 channel, smtUint8 gpioNum, smtUint32 *data)
	Return		: void
	Argument	: GPIO type & GPIO mode
	Comments	: 
		Get the GPIO data
-----------------------------------------------------------*/
void smtGPIOGetData(smtUint8 channel, smtUint8 gpioNum, smtUint32 *data)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_IN(channel));
	rdData = (rdData >> gpioNum) & 0x1;

	*data = rdData;
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetIntStatus()
	Prototype		: void smtGPIOGetIntStatus(smtUint8 channel, smtUint8 gpioNum, smtUint32 *gpioStatus)
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Get GPIO interrupt status
-----------------------------------------------------------*/
void smtGPIOGetIntStatus(smtUint8 channel, smtUint8 gpioNum, smtUint32 *gpioStatus)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_INTSTAT(channel));
	*gpioStatus = (rdData >> gpioNum) & 0x1;
}

/*----------------------------------------------------------
	Function name	: smtGPIOIntClear()
	Prototype		: void smtGPIOIntClear(smtUint8 channel, smtUint8 gpioNum)
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		GPIO interrupt clear
-----------------------------------------------------------*/
void smtGPIOIntClear(smtUint8 channel, smtUint8 gpioNum)
{
	SMT_WRITE(GPIO_INTSTAT(channel), (0x1 << gpioNum));
}

/*----------------------------------------------------------
	Function name	: smtGPIOIntrEnable()
	Prototype		: void smtGPIOIntrEnable(smtUint8 channel, smtUint8 enable)
	Return		: void
	Argument	: 
	Comments	: 
		GPIO interrupt set
-----------------------------------------------------------*/
void smtGPIOIntrEnable(smtUint8 channel, smtUint8 enable)
{
	if (enable)
		SMT_WRITE(GPIO_INTEN(channel), 0xFFFFFFFFUL);
	else
		SMT_WRITE(GPIO_INTEN(channel), 0x0UL);
}

/*----------------------------------------------------------
	Function name	: smtGPIOSetIntProperty()
	Prototype		: void smtGPIOSetIntProperty(GPIO_STRUCT gpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Set GPIO interrupt property
-----------------------------------------------------------*/
void smtGPIOSetIntProperty(smtUint8 channel, GPIO_STRUCT gpio)
{
	smtUint32 data;

	data = SMT_READ(GPIO_INTLEVEL(channel));
	if(gpio.intLevel)
		data |= (1UL << gpio.gpioNum);
	else
		data &= ~(1UL << gpio.gpioNum);
	SMT_WRITE(GPIO_INTLEVEL(channel), data); 

	data = SMT_READ(GPIO_INTPOL(channel));
	if(gpio.intPolarity)
		data |= (1UL << gpio.gpioNum);
	else
		data &= ~(1UL << gpio.gpioNum);
	SMT_WRITE(GPIO_INTPOL(channel), data);

 	data = SMT_READ(GPIO_INTBEDGE(channel));
	if(gpio.intBothEdge)
		data |= (1UL << gpio.gpioNum);
	else
		data &= ~(1UL << gpio.gpioNum);
	SMT_WRITE(GPIO_INTBEDGE(channel), data);
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetIntProperty()
	Prototype		: void smtGPIOGetIntProperty(GPIO_STRUCT gpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Get GPIO interrupt property
-----------------------------------------------------------*/
void smtGPIOGetIntProperty(smtUint8 channel, GPIO_STRUCT *gpio)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_INTLEVEL(channel));
	rdData = (rdData >> gpio->gpioNum) & 0x1;
	gpio->intLevel		= rdData;

	rdData = SMT_READ(GPIO_INTPOL(channel));
	rdData = (rdData >> gpio->gpioNum) & 0x1;
	gpio->intPolarity		= rdData;

	rdData = SMT_READ(GPIO_INTBEDGE(channel));
	rdData = (rdData >> gpio->gpioNum) & 0x1;
	gpio->intBothEdge	= rdData;
}


/*----------------------------------------------------------
        POWER MANAGEMENT
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtPower()
	Prototype		: smtUint16 smtPower(POWER_MODE pwrMode);
	Return			: smtUint16 - ADC data
	Argument		:
	Comments		: 
		Set power mode
-----------------------------------------------------------*/
smtBoolean smtPower(PM_PWR_MODE pwrMode)
{
#if POWER_NOT_SUPPORTED

	switch(pwrMode)
	{
		case PM_NORMAL :
			SMT_WRITE(PM_CLKCON, PM_NORMAL);
			break;

		case PM_SLOW :
			SMT_WRITE(PM_CLKCON, PM_SLOW_EN);
			break;

		case PM_IDLE :
			SMT_WRITE(PM_CLKCON, PM_CPU_IDLE_EN);
			break;

		case PM_SLEEP :
			// TODO :
			// To wake up from sleep mode, EINT enable and interrupt mak enable
			{
				//SMT_WRITE(GPIO_CON0, GPIO_EINTSET);
				GPIO_STRUCT gpio;
				gpio.gpioNum = GPIO0_TYPE;
				smtGPIOSetDir(gpio);
			}
			
			if(SMT_READ(INTMSK)&0xf00f == 0)    // EINT0~7 interrupt mask check
			{
				//EnableIRQ(IRQ_EINT0);
				SMT_WRITE(INTMSK, 0xf00f);          // EINT0~7 interrupt mask enable
			}
	
			SMT_WRITE(PM_CLKCON, PM_PWDN_EN);    // Power-down mode
	
	#ifdef __ARM_GCC_USE__
			__asm__
			(
				"nop\n\t" \
				"nop\n\t" \
				"nop\n\t" \
				"nop\n\t" \
			);
	#else
			__asm
			{
				 nop;
				 nop;
				 nop;
				 nop;
			}
	#endif
			break;

	    default :
			return SMT_ERROR;
	}

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}
