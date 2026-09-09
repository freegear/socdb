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
        E-DMA
-----------------------------------------------------------*/
#define DMA_MAX_SZ		(1024*1024 -1) // 1MB
#define EDMA_TO_DISABLE 0x7FFFF

#define EDMA_EC_NONE			(0<<0)
#define EDMA_EC_DISABLE			(1<<1)
#define EDMA_EC_CH_ALLOC		(1<<2)

/*----------------------------------------------------------
        G-DMA
-----------------------------------------------------------*/
#define GDMA_TO_INT				(0x7FFFF)
#define GDMA_TO_POL				(0x7FFFF)

#define GDMA_EC_NONE			(0<<0)
#define GDMA_EC_INT_TO			(1<<1)
#define GDMA_EC_POL_TO			(1<<2)
#define GDMA_EC_TRANS_FAIL		(1<<3)
#define GDMA_EC_NOT_2S_COMP		(1<<4)
#define GDMA_EC_NULL_INTFUNC	(1<<5)

static volatile smtBoolean gGDMAIntOn = SMT_FALSE;

/*----------------------------------------------------------
	Function name	: smt2EDMAChAsign
	Prototype		: smtUint32 smt2EDMAChAsign(smtBoolean method, smtUint16 device, smtUint8 *ch)
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtUint32 smt2EDMAChAsign(smtBoolean method, smtUint16 device, EdmaChannel *ch)
{
	smtUint32 data;
	smtInt32 i;

	static EdmaChAlloc Channel[EDMA_MAX_CHANNEL] =
	{
		{0, 1},{1, 1},{2, 1},{3, 1},
		{4, 1},{5, 1},{6, 1},{7, 1}
	};


	if(method==DMA_CHDALLOC)
	{
		if(*ch >= EDMA_MAX_CHANNEL)
			return SMT_FALSE;

		Channel[*ch].free = 1;

		return EDMA_EC_NONE;
	}


	// Check if pre-allocated channel exists
	for(i = 0; i <EDMA_MAX_CHANNEL; i++)
	{
		if(Channel[i].device == device
			&& Channel[i].free == 1)
		{	
			*ch = i;
			return EDMA_EC_NONE;
		}
	}

	// Search free available channel
	for(i = 0; i < EDMA_MAX_CHANNEL; i++)
	{
		if(Channel[i].free == 1)
		{
			Channel[i].device = device;
			Channel[i].free = 0;

			data = SMT_READ(RS_DMAMUX);
			data &= ~(0x000000f<<(i*4));
			data |= (device & 0x000f)<<(i*4);
			SMT_WRITE(RS_DMAMUX, data);
			*ch = i;
			return EDMA_EC_NONE;
		}
	}

	return EDMA_EC_CH_ALLOC;
}

/*----------------------------------------------------------
	Function name	: smt2DMADisable
	Prototype		: smtUint32 smt2DMADisable(smtUint8 ch)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtUint32 smt2DMADisable(EdmaChannel ch)
{
	smtUint32 timeOut = 0;
	smtUint32 errCode = EDMA_EC_NONE;
	
	// EDMA Disable
	SMT_WRITE(DMACSta(ch), 0xF); 
		
	// polling Active bit => 0
	while ((SMT_READ(DMACSta(ch))&DMA_ACTIVE_MASK) == DMA_ACTIVE_MASK)
	{
		if(timeOut++ == EDMA_TO_DISABLE)
		{
			errCode = EDMA_EC_DISABLE;
			break;
		}
	}
	return errCode;
}

/*----------------------------------------------------------
	Function name	: smtEDMANoDescrp
	Prototype		: void smtEDMANoDescrp(smtUint8 ch, EdmaStruct edma)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
void smtEDMANoDescrp(EdmaChannel ch, EdmaStruct *pEdma)
{
	//set EDMA src/dest address
	SMT_WRITE (DMACSAdr(ch), pEdma->src); 	
	SMT_WRITE (DMACDAdr(ch), pEdma->dst); 
	
	//set EDMA Ctrl
	SMT_WRITE (DMACCon (ch),
		 ((pEdma->startIntEn	&0x1)	<< 31)	/**/\
		|((pEdma->endIntEn		&0x1)	<< 30)	/**/\
		|((pEdma->enM2M			&0x1)	<< 29)	/**/\
		|((pEdma->srcInc		&0x1)	<< 28)	/**/\
		|((pEdma->srcWidth		&0x3)	<< 26)	/**/\
		|((pEdma->dstInc		&0x1)	<< 25)	/**/\
		|((pEdma->dstWidth		&0x3)	<< 23)	/**/\
		|((pEdma->transSize		&0x7)	<< 20)	/**/\
		|((pEdma->totSize		&0xFFFFF))		/**/\
		);

	//set EDMA base address of desctriptor		   	   
	SMT_WRITE (DMACDescrp(ch), DMA_DESCREND_MASK);
	
	//enable EDMA
	SMT_WRITE(DMACSta(ch),
		 ((DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK)
		|((pEdma->stopIntEn & 0x1) << 4))
		);
}

/*----------------------------------------------------------
	Function name	: smtEDMAUseDescrp
	Prototype		: void smtEDMAUseDescrp(smtUint8 ch, smtUint32 descCnt, EdmaStruct *edma)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
void smtEDMAUseDescrp(EdmaChannel ch, smtUint32 descCnt, EdmaStruct *edma)
{
	smtUint32 i;
	smtUint32 *pDescListBase = (smtUint32 *)edma->descListBase;
	smtUint32 control;
	EdmaStruct *pEdma = edma;
	smtUint32 descListBase = edma->descListBase;
	smtUint32 regData = 0;
	for(i=0;i<descCnt;i++)
	{
		control  = (pEdma->startIntEn	&0x1)	<<31;
		control |= (pEdma->endIntEn		&0x1)	<<30;
		control |= (pEdma->enM2M		&0x1)	<<29;//shkim-20070418 : new EDMA 
		control |= (pEdma->srcInc		&0x1)	<<28;
		control |= (pEdma->srcWidth		&0x3)	<<26;
		control |= (pEdma->dstInc		&0x1)	<<25;
		control |= (pEdma->dstWidth		&0x3)	<<23;
		control |= (pEdma->transSize	&0x7)	<<20;
		control |= (pEdma->totSize)		&0xFFFFF;

		pDescListBase[0 + (4*i)] = pEdma->src;
		pDescListBase[1 + (4*i)] = pEdma->dst;
		pDescListBase[2 + (4*i)] = control;
		pDescListBase[3 + (4*i)] = (i==(descCnt-1)) ? 1 : descListBase + (16*(i+1));

		pEdma++;
	}	

	//set EDMA control register
	regData |= ((edma->enM2M & 0x1) << 29);
	SMT_WRITE(DMACCon(ch),regData);
	
	//set descriptor base address
	SMT_WRITE(DMACDescrp(ch),descListBase);

	//enable EDMA
	SMT_WRITE(DMACSta(ch),
		 ((DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK)
		|((edma->stopIntEn & 0x1) << 4))
		);
}

/*----------------------------------------------------------
	Function name	: smtEDMAGetStatus
	Prototype		: smtUint32 smtEDMAGetStatus(smtUint8 ch)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
void smtEDMAGetStatus(EdmaChannel ch, smtUint32 *pStatus)
{
	*pStatus = SMT_READ(DMACSta(ch));
}

/*----------------------------------------------------------
	Function name	: smtEDMASetStatus
	Prototype		: void smtEDMASetStatus(smtUint8 ch, smtUint32 status)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
void smtEDMASetStatus(EdmaChannel ch, smtUint32 status)
{
	SMT_WRITE((DMACSta(ch)),status);
}

/*----------------------------------------------------------
	Function name	: smtEDMAGetTransLength
	Prototype		: smtUint32 smtEDMAGetTransLength(smtUint8 ch, smtUint32 dstAddr)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
void smtEDMAGetTransLength(EdmaChannel ch, smtUint32 dstAddr, smtUint32 *pTotLen)
{
	*pTotLen = ((DMACDAdr(ch)) - dstAddr);
}

/*----------------------------------------------------------
	Function name	: smt2GDMACopy
	Prototype		: smtUint32 smt2GDMACopy(GdmaStruct *gdma, smtBoolean polling)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtUint32 smt2GDMACopy(GdmaStruct *gdma, smtBoolean polling)
{	
	smtUint32 reg, sSkip, dSkip;
	extern void DCacheFlushing(void);
	smtUint32 clipXlen;
	smtUint32 clipYlen;

	smtUint32 srcAddr = 0, dstAddr =0;
	smtUint32 timeOut, errCode;

	smtBoolean gdmaIntOn;
	clipXlen = gdma->clipWidth * gdma->bpp;
	clipYlen = gdma->clipHeight - 1;

	srcAddr = gdma->src + (gdma->sClipX + (gdma->sClipY*gdma->sWidth)) * gdma->bpp;
	dstAddr = gdma->dst + (gdma->dClipX + (gdma->dClipY*gdma->dWidth)) * gdma->bpp;

	sSkip = (gdma->sWidth * gdma->bpp) - clipXlen;
	dSkip = (gdma->dWidth * gdma->bpp) - clipXlen;
	
	if((sSkip%2) | (dSkip%2))
	{
		errCode = GDMA_EC_NOT_2S_COMP;
		goto ERROR;
	}
	
	if(polling==SMT_FALSE)
	{
		if(gdma->intFunction==0x0)
		{
			errCode = GDMA_EC_NULL_INTFUNC;
			goto ERROR;
		}
			
		Disable_IRQ();
		EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
		RequestIRQ(IRQ_DMA2D, gdma->intFunction);
		Enable_IRQ();				
	}

	DCacheFlushing();
	SMT_WRITE(DMA2D_STATUS,DMA2D_STOPINT_MASK);

	SMT_WRITE(DMA2D_SRCADDR,	srcAddr);
	SMT_WRITE(DMA2D_DSTADDR,	dstAddr);

	SMT_WRITE(DMA2D_SIZE, 	clipXlen);
	SMT_WRITE(DMA2D_CNT,	(clipYlen<<16)|clipXlen);	
	SMT_WRITE(DMA2D_ADDRUPD,(sSkip<<16)|dSkip);

	SMT_WRITE(DMA2D_STATUS, SMT_READ(DMA2D_STATUS)
					| DMA2D_EN_MASK
					| DMA2D_STOPINTEN_MASK
					| DMA2D_STOPINT_MASK
					| DMA2D_ERRINT_MASK);
	
	if(polling==SMT_TRUE)
	{
		timeOut = 0;
		while(1)
		{
			reg = SMT_READ(DMA2D_STATUS);
			
			if(reg&DMA2D_STOPINT_MASK) 
			{									

				SMT_WRITE(DMA2D_STATUS,DMA2D_STOPINT_MASK);

				if(gdma->intFunction!=0x0)
					gdma->intFunction(0);

				if(reg&DMA2D_ERRINT_MASK)
				{
					errCode = GDMA_EC_TRANS_FAIL;
					goto ERROR;
				}
				else break;
				
			}
			if(timeOut++ == GDMA_TO_POL)//polling timeout
			{
				errCode = GDMA_EC_POL_TO;
				goto ERROR;
			}
		}
	}
	else		
	{
		timeOut = 0;
		while(1)
		{
			smtGDMAGetIntOn(&gdmaIntOn);
			if(gdmaIntOn)
			{
				reg = SMT_READ(DMA2D_STATUS);
				if(reg & DMA2D_ERRINT_MASK)
				{
					SMT_WRITE(DMA2D_STATUS, DMA2D_ERRINT_MASK);
					errCode = GDMA_EC_TRANS_FAIL;
					goto ERROR;
				}
				SMT_WRITE(DMA2D_STATUS,DMA2D_STOPINT_MASK);
				smtGDMASetIntOn(SMT_FALSE);
				break;
			}
			if(timeOut++ == GDMA_TO_INT)
			{
				errCode = GDMA_EC_INT_TO;
				goto ERROR;
			}
		}
	}

	if(polling==SMT_FALSE)
		ReleaseIRQ(IRQ_DMA2D);
	return GDMA_EC_NONE;

ERROR:
	if(polling==SMT_FALSE)
		ReleaseIRQ(IRQ_DMA2D);
	return errCode;
}

/*----------------------------------------------------------
	Function name	: smtGDMASetIntOn
	Prototype		: void smtGDMASetIntOn(smtBoolean intOn)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
void smtGDMASetIntOn(smtBoolean intOn)
{
	gGDMAIntOn = intOn;
}

/*----------------------------------------------------------
	Function name	: smtGDMAGetIntOn
	Prototype		: void smtGDMAGetIntOn(smtBoolean *pIntOn)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
void smtGDMAGetIntOn(smtBoolean *pIntOn)
{
	*pIntOn = gGDMAIntOn;
}

/*----------------------------------------------------------
        MEMORY
-----------------------------------------------------------*/
/* FMC */
/*----------------------------------------------------------
	Function name	: smtFMCSetMode()
	Prototype		: smtBoolean smtFMCSetMode(FMC_STRUCT fmc);
	Return			: smtBoolean
	Argument		:
	Comments		: 
	            Set System wait & cpu hold & operation mode
-----------------------------------------------------------*/
smtBoolean smtFMCSetMode(FMC_STRUCT fmc)
{
#if FMC_NOT_SUPPORTED
	SMT_WRITE(FMUCON,
		fmc.waitReg<<SHIFT_DN_FROM_MASK(WAIT_REG) |
		0<<SHIFT_DN_FROM_MASK(UCPUH_EN) |   // CPU hold disable
		fmc.mode);

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif

}

/*----------------------------------------------------------
	Function name	: smtFMWrite()
	Prototype		: smtBoolean smtFMWrite(FM_STRUCT flashWrite);
	Return			: error code
	Argument		:
	Comments		: Write operation
		Erase   - Sector or Chip erase
		Program - Normal or Option program
-----------------------------------------------------------*/
smtBoolean smtFMWrite(FM_STRUCT flashWrite)
{
#if FMC_NOT_SUPPORTED
	FM_STRUCT flash;
	
	flash.addr = flashWrite.addr+FLASH_STARTADDR;
	flash.data = flashWrite.data;
	flash.length = flashWrite.length;
	flash.mode = flashWrite.mode;
	
	if(flash.mode > FM_ERASE_CHIP)	// Except for flash memory chip erase operation.
		SMT_WRITE(FMADDR, flash.addr);
	
	if(flash.mode > FM_ERASE_SECTOR) // When normal program or option program is
		SMT_WRITE(FMDATA, flash.data);
	
	SMT_WRITE(FMKEY, FM_KEYVALUE);
	
	//SMT_WRITE(FMUCON, UOSCEN_EN); // OSCEN set. Don't care 2006/03/10
	SMT_WRITE(FMUCON, SMT_READ(FMUCON) | USTRSTPT | flash.mode );
	
	while(SMT_READ(FMKEY) != 0)
	{
		; // When program operation complete is, FMKEY/FMUCON is cleared
	}
	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}

/*----------------------------------------------------------
	Function name	: smtFMRead()
	Prototype		: smtUint32 smtFMRead(smtUint32 addr)
	Return			: read data
	Argument		:
	Comments		: 4B read operation
-----------------------------------------------------------*/
smtUint32 smtFMRead(smtUint32 addr)
{
#if FMC_NOT_SUPPORTED
	smtUint32 readData;
	readData = *((smtUint32 *)(addr+FLASH_STARTADDR));

	return readData;
	
#else
	return SMT_FALSE;
#endif
}

/*----------------------------------------------------------
	Function name	: smt2FMProgramNormal()
	Prototype		: smtBoolean smt2FMProgramNormal(void)
	Return			: error code
	Argument		:
	Comments	: Write operation
		Normal program
-----------------------------------------------------------*/
smtBoolean smt2FMProgramNormal(smtUint32 addr, smtUint32 *data, smtUint32 length)
{
#if FMC_NOT_SUPPORTED
	smtUint32 size;
	FM_STRUCT flashWrite;
	
	flashWrite.addr = addr;
	flashWrite.length = length;
	flashWrite.mode = FM_PROGRAM;
	
	for(size=0; size<length/4; size++)
	{
		flashWrite.data = *(data+size); // Flash memory 4Byte(Word) access
		smtFMWrite(flashWrite);
		flashWrite.addr += 4;
	}

	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}

/*----------------------------------------------------------
	Function name	: smt2FMProgramOption()
	Prototype		: smtBoolean smt2FMProgramOption
						(FM_OPTION_TYPE optionType, smtUint32 sector)
	Return			: error code
	Argument		:
	Comments		: Write operation
		Option operation (Smart or HW protect or RD protect)
-----------------------------------------------------------*/
smtBoolean smt2FMProgramOption(FM_OPTION_TYPE optionType, smtUint32 sector)
{
#if FMC_NOT_SUPPORTED
	FM_STRUCT flashWrite;
	
	switch(optionType)
	{
		case OPTION_SMART:
			flashWrite.addr = SMART_OPT;
			flashWrite.data = sector;   // sector setting
			flashWrite.length = 4;
			flashWrite.mode = FM_PROGRAM_OPTION;
			smtFMWrite(flashWrite);
			break;
		case OPTION_PROTECT_HW:
			flashWrite.addr = PROTECTION_OPT;
			flashWrite.data = ~FM_PROTECT_HW;
			flashWrite.mode = FM_PROGRAM_OPTION;
			smtFMWrite(flashWrite);
			break;
		case OPTION_PROTECT_RD :
			flashWrite.addr = PROTECTION_OPT;
			flashWrite.data = ~FM_PROTECT_RD;
			flashWrite.mode = FM_PROGRAM_OPTION;
			smtFMWrite(flashWrite);
			break;
		
		default :
			return SMT_ERROR;
	}
	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}

/*----------------------------------------------------------
	Function name	: smt2FMErase()
	Prototype		: smtBoolean smt2FMErase
						(FM_OPERATION_MODE eraseType, smtUint32 sector)
	Return			: error code
	Argument		:
	Comments		: Erase operation
		Flash memory erase (Sector or Chip)
-----------------------------------------------------------*/
smtBoolean smt2FMErase(FM_OPERATION_MODE eraseType, smtUint32 sector)
{
#if FMC_NOT_SUPPORTED
	smtUint32 errCode;
	FM_STRUCT flashWrite;
	
	if(eraseType == FM_ERASE_SECTOR) // Sector erase
		flashWrite.addr = sector;
	
	if(eraseType > FM_ERASE_SECTOR) // When FM_PROGRAM or FM_PROGRAM_OPTION is
		return SMT_ERROR;
	
	flashWrite.mode = eraseType;
	errCode = smtFMWrite(flashWrite);
	
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}

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
	Prototype		: void smtTIMERSetMode(TimerChannel channel, TimerProperty ptimer)
	Return		: void
	Argument	:
	Comments	: 
		Set timer mode
-----------------------------------------------------------*/
void smtTIMERSetMode(TimerChannel channel, TimerProperty *ptimer)
{
	smtUint32 addr;

	addr = TIMER_BASEADDR + 0x10*channel;

	#if 0
	SMT_WRITE((*(volatile smtUint32*)(addr+0x00)), ptimer->data);
	SMT_WRITE((*(volatile smtUint32*)(addr+0x04)), (ptimer->prescale & 0x3FF));
	SMT_WRITE((*(volatile smtUint32*)(addr+0x08)), 
											 ( ((ptimer->timerEn & 0x1)	<< 0)
											 | ((ptimer->timerClear & 0x1)	<< 1)
											 | ((ptimer->opMode & 0x1)	<< 2))
											 );
	#endif
	SMT_WRITE(TIMERDAT(channel), ptimer->data);
	SMT_WRITE(TIMERPRE(channel), (ptimer->prescale & 0x3FF));
	SMT_WRITE(TIMERCON(channel), 
								   ((ptimer->timerEn << 0)	& 0x1)
								 | ((ptimer->timerClear << 1)	& 0x2)
								 | ((ptimer->opMode << 2)	& 0x4) );
}

/*----------------------------------------------------------
	Function name	: smtTIMERGetMode()
	Prototype		: void smtTIMERGetMode(TimerChannel channel, TimerProperty *ptimer)
	Return		: void
	Argument	:
	Comments	: 
		Get timer mode
-----------------------------------------------------------*/
void smtTIMERGetMode(TimerChannel channel, TimerProperty *ptimer)
{
	smtUint32 addr;
	smtUint32 control;
	
	addr = TIMER_BASEADDR + 0x10*channel;

	ptimer->data		= SMT_READ(*(volatile smtUint32*)(addr+0x00));
	ptimer->prescale	= (smtUint16)(SMT_READ(*(volatile smtUint32*)(addr+0x04)) & 0x3FF);

	control = SMT_READ(*(volatile smtUint32*)(addr+0x08));
	ptimer->timerEn	= (smtUint8)(control & 0x01);
	ptimer->timerClear= (smtUint8)(control & 0x02);
	ptimer->opMode	= (smtUint8)(control & 0x04);
}

/*----------------------------------------------------------
	Function name	: smtTIMERClrCount()
	Prototype		: void smtTIMERClrCount(TimerChannel channel)
	Return		: void
	Argument	:
	Comments	: 
		Set timer mode
-----------------------------------------------------------*/
void smtTIMERClrCount(TimerChannel channel)
{
	smtUint32 rdData;

	rdData = SMT_READ(TIMERCON(channel));
	rdData |= 0x2;		// Timer counter Clear
	SMT_WRITE(TIMERCON(channel), rdData);
}

/*----------------------------------------------------------
	Function name	: smtTIMEROperation()
	Prototype		: void smtTIMEROperation(TimerChannel channel, TimerProperty ptimer)
	Return		: void
	Argument	:
	Comments	: 
		Timer start or stop
		You need to GPIO set before use the smtTimerOperatoin().
			ex)
			smtTimerOperation(timer, timerSel);
-----------------------------------------------------------*/
void smtTIMEROperation(TimerChannel channel, TimerProperty *ptimer)
{
	if(ptimer->timerEn == SMT_TRUE)       // When timer enable
		smtTIMERSetMode(channel, ptimer);
}


/*----------------------------------------------------------
        WDT
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtWDTSetMode()
	Prototype		: void smtWDTSetMode(WdtProperty *pwdt);
	Return		: smtBoolean
	Argument	: WDT struct
	Comments	: 
		Set the WDT mode
-----------------------------------------------------------*/
void smtWDTSetMode(WdtProperty *pwdt)
{
	SMT_WRITE(WDTPSR, pwdt->preScale);
	SMT_WRITE(WDTLDR, pwdt->reloadValue);
	
	SMT_WRITE(WDTCON,
		((pwdt->div & 0x3)		<< 0x4) |
		((pwdt->clkSel & 0x1)	<< 0x3) |
		((pwdt->intEn & 0x1)	<< 0x2) |
		((pwdt->rstEn & 0x1)	<< 0x1) |
		((pwdt->wdtEn & 0x1)	<< 0x0)	);
}

/*----------------------------------------------------------
	Function name	: smtWDTGetMode()
	Prototype		: void smtWDTGetMode(WdtProperty *pwdt);
	Return		: void
	Argument	: WDT struct
	Comments	: 
		Get the WDT mode
-----------------------------------------------------------*/
void smtWDTGetMode(WdtProperty *pwdt)
{
	smtUint32 rdData;

	rdData = SMT_READ(WDTPSR);
	pwdt->preScale	= (rdData >> 0) & 0xFFFF;

	rdData = SMT_READ(WDTLDR);
	pwdt->reloadValue= (rdData >> 0) & 0xFFFF;

	rdData = SMT_READ(WDTCON);
	pwdt->div	= (rdData >> 4) & 0x3;
	pwdt->clkSel	= (rdData >> 3) & 0x1;
	pwdt->intEn	= (rdData >> 2) & 0x1;
	pwdt->rstEn	= (rdData >> 1) & 0x1;
	pwdt->wdtEn	= (rdData >> 0) & 0x1;
}

/*----------------------------------------------------------
	Function name	: smtWDTGetCount()
	Prototype		: void smtWDTGetCount(smtUint16 *coupcountnt)
	Return		: void
	Argument	: 
	Comments	: 
		Get the WDT count
-----------------------------------------------------------*/
void smtWDTGetCount(smtUint16 *pcount)
{
	smtUint32 rdData;
	rdData = SMT_READ(WDTCNT);
	*pcount = rdData & 0xFFFF;
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
	Prototype		: void smtWDTGetISR(smtUint8 *pintrStatus)
	Return		: void
	Argument	: 
	Comments	: 
		Get the WDT interrupt status
-----------------------------------------------------------*/
void smtWDTGetISR(smtUint8 *pintrStatus)
{
	smtUint32 rdData;
	rdData = SMT_READ(WDTISR);
	*pintrStatus = rdData & 0x1;
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
	Prototype		: void smtGPIOSetDir(GpioChannel channel, smtUint8 gpioNum, smtUint32 mode)
	Return		: void
	Argument	: GPIO type & GPIO mode
	Comments	: 
		Set the GPIO mode
-----------------------------------------------------------*/
void smtGPIOSetDir(GpioChannel channel, smtUint8 gpioNum, smtUint32 mode)
{
	smtUint32 rdData;


	rdData = SMT_READ(GPIO_OE(channel));
	rdData &= ~(0x1 << gpioNum);
	rdData |= ((mode & 0x1) << gpioNum);

	SMT_WRITE(GPIO_OE(channel), rdData);
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetDir()
	Prototype		: void smtGPIOGetDir(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pmode)
	Return		: void
	Argument	: GPIO type
	Comments	: 
		Get the GPIO mode
-----------------------------------------------------------*/
void smtGPIOGetDir(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pmode)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_OE(channel));
	*pmode = (rdData >> gpioNum) & 0x1;
}

/*----------------------------------------------------------
	Function name	: smtGPIOSetData()
	Prototype		: smtUint8 smtGPIOSetData(GpioChannel channel, smtUint8 gpioNum, smtUint32 data)
	Return		: void
	Argument	: GPIO type & GPIO data
	Comments	: 
		Set the GPIO data
-----------------------------------------------------------*/
void smtGPIOSetData(GpioChannel channel, smtUint8 gpioNum, smtUint32 data)
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
	Prototype		: void smtGPIOGetData(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pdata)
	Return		: void
	Argument	: GPIO type & GPIO mode
	Comments	: 
		Get the GPIO data
-----------------------------------------------------------*/
void smtGPIOGetData(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pdata)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_IN(channel));
	rdData = (rdData >> gpioNum) & 0x1;

	*pdata = rdData;
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetIntStatus()
	Prototype		: void smtGPIOGetIntStatus(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pgpioStatus)
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Get GPIO interrupt status
-----------------------------------------------------------*/
void smtGPIOGetIntStatus(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pgpioStatus)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_INTSTAT(channel));
	*pgpioStatus = (rdData >> gpioNum) & 0x1;
}

/*----------------------------------------------------------
	Function name	: smtGPIOClearInt()
	Prototype		: void smtGPIOClearInt(GpioChannel channel, smtUint8 gpioNum)
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		GPIO interrupt clear
-----------------------------------------------------------*/
void smtGPIOClearInt(GpioChannel channel, smtUint8 gpioNum)
{
	SMT_WRITE(GPIO_INTSTAT(channel), (0x1 << gpioNum));
}

/*----------------------------------------------------------
	Function name	: smtGPIOEnableInt()
	Prototype		: void smtGPIOEnableInt(GpioChannel channel, smtUint8 enable)
	Return		: void
	Argument	: 
	Comments	: 
		GPIO interrupt set
-----------------------------------------------------------*/
void smtGPIOEnableInt(GpioChannel channel, smtUint8 enable)
{
	if (enable)
		SMT_WRITE(GPIO_INTEN(channel), 0xFFFFFFFFUL);
	else
		SMT_WRITE(GPIO_INTEN(channel), 0x0UL);
}

/*----------------------------------------------------------
	Function name	: smtGPIOSetIntProperty()
	Prototype		: void smtGPIOSetIntProperty(GpioProperty *pgpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Set GPIO interrupt property
-----------------------------------------------------------*/
void smtGPIOSetIntProperty(GpioChannel channel, GpioProperty *pgpio)
{
	smtUint32 data;

	data = SMT_READ(GPIO_INTLEVEL(channel));
	if(pgpio->intLevel)
		data |= (1UL << pgpio->gpioNum);
	else
		data &= ~(1UL << pgpio->gpioNum);
	SMT_WRITE(GPIO_INTLEVEL(channel), data); 

	data = SMT_READ(GPIO_INTPOL(channel));
	if(pgpio->intPolarity)
		data |= (1UL << pgpio->gpioNum);
	else
		data &= ~(1UL << pgpio->gpioNum);
	SMT_WRITE(GPIO_INTPOL(channel), data);

 	data = SMT_READ(GPIO_INTBEDGE(channel));
	if(pgpio->intBothEdge)
		data |= (1UL << pgpio->gpioNum);
	else
		data &= ~(1UL << pgpio->gpioNum);
	SMT_WRITE(GPIO_INTBEDGE(channel), data);
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetIntProperty()
	Prototype		: void smtGPIOGetIntProperty(GpioProperty pgpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Get GPIO interrupt property
-----------------------------------------------------------*/
void smtGPIOGetIntProperty(GpioChannel channel, GpioProperty *pgpio)
{
	smtUint32 rdData;

	rdData = SMT_READ(GPIO_INTLEVEL(channel));
	rdData = (rdData >> pgpio->gpioNum) & 0x1;
	pgpio->intLevel		= rdData;

	rdData = SMT_READ(GPIO_INTPOL(channel));
	rdData = (rdData >> pgpio->gpioNum) & 0x1;
	pgpio->intPolarity		= rdData;

	rdData = SMT_READ(GPIO_INTBEDGE(channel));
	rdData = (rdData >> pgpio->gpioNum) & 0x1;
	pgpio->intBothEdge	= rdData;
}


/*----------------------------------------------------------
        ADC
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtADCSetMode()
	Prototype		: smtBoolean smtADCSetMode(ADC_STRUCT adc);
	Return			: smtBoolean
	Argument		: ADC mode & channel
	Comments		: 
		Set ADC mode
-----------------------------------------------------------*/
smtBoolean smtADCSetMode(ADC_STRUCT adc)
{
#if ADC_NOT_SUPPORTED
	// Standby mode
	if(adc.opMode == ADC_STANDBY)
	{
		SMT_WRITE(ADCCON, 
			SMT_READ(ADCCON) | (ADC_STANDBY<<SHIFT_DN_FROM_MASK(ADC_STBY)) );
		return SMT_SUCCESS;
	}
	
	/*
	    When readstart bit is enable, adcEnabe bit is not valid.
	    But, readstart bit is disable, adcEnable bit is valid.
	*/
	// Normal operation mode
	SMT_WRITE(ADCCON, 
		adc.adcEnable<<SHIFT_DN_FROM_MASK(ADENABLE) |
		adc.readStart<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
		ADC_NORMAL<<SHIFT_DN_FROM_MASK(ADC_STBY)       |
		adc.adcChanSel<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );
	
	return SMT_SUCCESS;
#else
	return SMT_FALSE;
#endif
}

/*----------------------------------------------------------
	Function name	: smtADCDataRead()
	Prototype		: smtUint16 smtADCDataRead(void);
	Return			: smtUint16 - ADC data
	Argument		:
	Comments		: 
		Read ADC data
-----------------------------------------------------------*/
smtUint16 smtADCDataRead(void)
{
#if ADC_NOT_SUPPORTED
	smtUint16 adcData;
	
	// When ADC standby mode is.
	if(SMT_READ(ADCCON)&ADC_STBY == SMT_TRUE)
	    return SMT_ERROR;       // A/D data is garbage
	
	// Wait until ADC operation is finished.
	// Need to ISR routine concern
	while((ADC_FLAG & SMT_READ(ADCCON)) != 1)
	{
		;
	}
	
	adcData = SMT_READ(ADCDAT);
	return adcData;
#else
	return SMT_FALSE;
#endif	
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
