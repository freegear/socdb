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

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

#include "lib.h"

#define GLOBAL_DEFINE
#include "global.h"

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
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
/*----------------------------------------------------------
	Function name	: smtDMACEnable()
	Prototype		: void smtDMACEnable(smtUint8 channel)
	Return			: 
	Argument		:
	Comments		: Enable DMA 
----------------------------------------------------------*/
void smtDMACEnable(smtUint8 channel)
{
	// DMAC Enable
	SMT_WRITE(
		DMACSta(channel),						// DMA control status register
		(SMT_READ(DMACSta(channel) | DMA_ENABLE_MASK))	// Enable bit set
	); 
}

/*----------------------------------------------------------
	Function name	: smtDMACDisable()
	Prototype		: void smtDMACDisable(smtUint8 channel)
	Return			: 
	Argument		:
	Comments		: Disable DMA Channel
----------------------------------------------------------*/
void smtDMACDisable(smtUint8 channel)
{
	// DMAC Disable
	SMT_WRITE(
		DMACSta(channel),						// DMA control status register
		(SMT_READ(DMACSta(channel)) & (~DMA_ENABLE_MASK))	// Enable bit clear
	); 
	
	// polling Active bit => 0
	while ((SMT_READ(DMACSta(channel)) & DMA_ACTIVE_MASK) == DMA_ACTIVE_MASK)
	{
		;
	}
}

/*----------------------------------------------------------
	Function name	: smtDMACNoDescrp()
	Prototype		: void smtDMACNoDescrp(smtUint8 channel, 
							smtUint32 SourceAddr, 
							smtUint32 DestAddr, smtUint16 TSize)
	Return			: 
	Argument		:
	Comments		: DMA Don't Use Descriptor
----------------------------------------------------------*/
void smtDMACNoDescrp(
	smtUint8 channel, 
	smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth,
	smtUint32 DestAddr, smtBoolean DstIncrease, smtUint8 DWidth, 
	smtUint8 TransSize, smtUint16 TotalSize)
{
	// Set Source address
	SMT_WRITE (DMACSAdr(channel), SrcAddr); 			

	// Set Destination address
	SMT_WRITE (DMACDAdr(channel), DestAddr); 		

	// Set control register value
	SMT_WRITE (DMACCon (channel),		// to DMA control register
		((SrcIncrease	& 0x01) << 26)	// set source increase type
		|((SWidth		& 0x03) << 24)	// set source width
		|((DstIncrease	& 0x01) << 22)	// set target increase type
		|((DWidth		& 0x03) << 20)	// set target width
		|((TransSize		& 0x07) << 16)	// set DMA burst size
		|(TotalSize		& DMA_TXLENGTH_MASK));// set DMA total transfer size+1
		   
	// Set descriptor register to none
	SMT_WRITE (DMACDescrp(channel), DMA_DESCREND_MASK);
	
	// Run DMA
	SMT_WRITE (DMACSta(channel), DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);
}

/*----------------------------------------------------------
	Function name	: smtDMACUseDescrp()
	Prototype		: void smtDMACUseDescrp(smtUint8 channel, smtBoolean mem2mem)
	Return			: 
	Argument		:
	Comments		: DMA Use Descriptor
----------------------------------------------------------*/
void smtDMACUseDescrp(smtUint8 channel, smtUint32 FirstDescAddr)
{
	unsigned *desc = (unsigned *)FirstDescAddr;
	
	// set descriptor value
	SMT_WRITE(DMACDescrp(channel),FirstDescAddr); 
	
	// DMA Bug for Size registering
	SMT_WRITE(DMACCon(channel), (((desc[2]) >> 16) & 0xF) << 16);	
	
	// DMA run 
	SMT_WRITE(DMACSta(channel), DMA_ENABLE_MASK);
}

/*----------------------------------------------------------
	This function is util function ... and remove from proto type
  ----------------------------------------------------------*/
/*
void DMACMemCopy(
	smtUint8 channel,
	unsigned char *dest,
	unsigned char *src,
	unsigned nbytes)
{
	unsigned int m2m = 1;		// Memory2Memory Transfer
	unsigned int srcIncr = 1;	// Source Increment
	unsigned int destIncr = 1;	// Destination Increment
	unsigned int Width = 2;		// WORD
	unsigned int size = 5;		// 32 byte
	unsigned int transferLen;

	if(nbytes == 0)
		return;
	while(nbytes > 0)
	{
		if(nbytes > 65532)
			transferLen = 65532;
		else
			transferLen = nbytes;

		SMT_WRITE(DMACSAdr(channel), (unsigned)src);
		SMT_WRITE(DMACDAdr(channel), (unsigned)dest);
		SMT_WRITE(DMACCon(channel), 
			(m2m		<<29)
			|(Width		<<24)
			|(srcIncr		<<26)
			|(destIncr	<<22)
			|(Width		<<20)
			|(size		<<16)
			|transferLen);
		   
		SMT_WRITE(DMACDescrp(channel), 1);
		SMT_WRITE(DMACSta(channel), 0x8000001F);

		while(1)
		{
			// Stop/Error Interrupt Check
			if(SMT_READ(DMACSta(channel)) & 0x00000009)	
				break;
		}

		if(SMT_READ(DMACSta(channel)) & 0x00000001)	// Error Interrupt
		{
			//GPIO_Write(0xdead);
			while(1) ;
		}
		nbytes -= transferLen;
	}
}
*/

/*----------------------------------------------------------
	Function name	: smtDMA2DEnable()
	Prototype		: void smtDMA2DEnable(void)
	Return		: void
	Argument	: void
	Comments	: 
		Enable the DMA2D
-----------------------------------------------------------*/
void smtDMA2DEnable(void)
{
	smtUint32 readData;

	readData = SMT_READ(DMA2D_STATUS);
	SMT_WRITE(DMA2D_STATUS,
		readData |
		(0x1 << SHIFT_DN_FROM_MASK(DMA2D_EN_MASK)) |			// Enable bit set
		(0x1 << SHIFT_DN_FROM_MASK(DMA2D_STOPINT_MASK)) |	//  Stop intr clear
		(0x1 << SHIFT_DN_FROM_MASK(DMA2D_ERRINT_MASK))		// Err intr clear
		);
}

/*----------------------------------------------------------
	Function name	: smtDMA2DDisable()
	Prototype		: void smtDMA2DDisable(void)
	Return		: void
	Argument	: void
	Comments	: 
		Disable the DMA2D
-----------------------------------------------------------*/
void smtDMA2DDisable(void)
{
	smtUint32 readData;

	readData = SMT_READ(DMA2D_STATUS);
	SMT_WRITE(DMA2D_STATUS,
		(readData & ~DMA2D_EN_MASK) );

	while ((SMT_READ(DMA2D_STATUS) & DMA2D_ACTIVE_MASK) == DMA2D_ACTIVE_MASK)
	{
		;	// Wait until active bit is '0'
	}
}

/*----------------------------------------------------------
	Function name	: smtDMA2DEnableIntr()
	Prototype		: void smtDMA2DEnableIntr(void)
	Return		: void
	Argument	: void
	Comments	: 
		Enable the DMA2D interrupt
-----------------------------------------------------------*/
void smtDMA2DEnableIntr(void)
{
	smtUint32 readData;

	readData = SMT_READ(DMA2D_STATUS);
	SMT_WRITE(DMA2D_STATUS,
		readData | (0x1 << SHIFT_DN_FROM_MASK(DMA2D_STOPINTEN_MASK)) );
}

/*----------------------------------------------------------
	Function name	: smtDMA2DDisableIntr()
	Prototype		: void smtDMA2DDisableIntr(void)
	Return		: void
	Argument	: void
	Comments	: 
		Disable the DMA2D interrupt
-----------------------------------------------------------*/
void smtDMA2DDisableIntr(void)
{
	smtUint32 readData;

	readData = SMT_READ(DMA2D_STATUS);
	SMT_WRITE(DMA2D_STATUS, 
		(readData & ~DMA2D_STOPINTEN_MASK) );
}

/*----------------------------------------------------------
	Function name	: smtDMA2DClearIntr()
	Prototype		: void smtDMA2DClearIntr(smtUint8 clearIntr)
	Return		: void
	Argument	: DMA2D interrupt clear bit
	Comments	: 
		Clear the DMA2D interrupt
-----------------------------------------------------------*/
void smtDMA2DClearIntr(smtUint8 clearIntr)
{
	smtUint32 readData;

	readData = SMT_READ(DMA2D_STATUS);

	if (clearIntr != 0x0)	// When StopInt bit
	{
		SMT_WRITE(DMA2D_STATUS,
			readData | (0x1 << SHIFT_DN_FROM_MASK(DMA2D_STOPINT_MASK)) );
	}
	else
	{
		SMT_WRITE(DMA2D_STATUS,
			readData | (0x1 << SHIFT_DN_FROM_MASK(DMA2D_ERRINT_MASK)) );
	}
}

/*----------------------------------------------------------
	Function name	: smtDMA2DClearIntr()
	Prototype		: smtUint8 smtDMA2DClearIntr(void)
	Return		: smtUint8
	Argument	: void
	Comments	: 
		Get the DMA2D interrupt status
-----------------------------------------------------------*/
smtUint8 smtDMA2DGetIntrInfo(void)
{
	smtUint32 readData;

	readData = SMT_READ(DMA2D_STATUS);

	if ( (readData & DMA2D_STOPINT_MASK) == DMA2D_STOPINT_MASK)	// When stop interrupt status is
		return DMA2D_STOPINT;
	else if ( (readData & DMA2D_ERRINT_MASK) == DMA2D_ERRINT_MASK)// When Error interrupt status is
		return DMA2D_ERRINT;
	else
		return DMA2D_NO_INT;
}

/*----------------------------------------------------------
	Function name	: smt2DMA2DMemToMemCopy()
	Prototype		: void smt2DMA2DMemToMemCopy(void)
	Return		: void
	Argument	: void
	Comments	: 
		Memory to memory copy using DMA2D
-----------------------------------------------------------*/
void smt2DMA2DMemToMemCopy(DMA2D_STRUCT dma2D)
{
	// Set G-DMA register
	SMT_WRITE(DMA2D_SRCADDR, dma2D.src);
	SMT_WRITE(DMA2D_DSTADDR, dma2D.dst);
	SMT_WRITE(DMA2D_SIZE, dma2D.bytePerLine);
	SMT_WRITE(DMA2D_CNT, dma2D.count);
	SMT_WRITE(DMA2D_ADDRUPD,
		(dma2D.srcIncSize << SHIFT_DN_FROM_MASK(DMA2D_UPPER_MASK)) |
		(dma2D.dstIncSize & DMA2D_LOWER_MASK) );

	// G-DMA configure
	smtDMA2DEnable();
	// Insert other configure by DJKIM 2007/01/18

	//return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smt2DMAMemToMemCopy()
	Prototype		: smtUint32 smt2DMAMemToMemCopy(void)
	Return		: void
	Argument	: void
	Comments	: 
		Memory to memory copy using DMA
-----------------------------------------------------------*/
smtUint32 smt2DMAMemToMemCopy (
	smtUint8 channel, 
	smtUint8 *dest, 
	smtUint8 *src, 
	smtUint32 nbytes
	)
{
	smtUint32 transferLen;
	smtUint32 returnErr;

	if(nbytes == 0)
		return;

	while(nbytes > 0)
	{
		if(nbytes > 65532)
			transferLen = 65532;
		else
			transferLen = nbytes;

		// DMACNoDescrp()
		smtDMACNoDescrp(
			channel,
			&src,
			1,		// Source address increment
			2,		// Word src bus width
			&dest,
			1,		// Dst address increment
			2,		// Word dst bus width
			5,		// Each transfer size 32Bytes
			transferLen
			);
		SMT_WRITE(DMACCon(channel), 
			SMT_READ(DMACSta(channel)) | 1<<24 );	// Set DMA to memtomem

		/*
		SMT_WRITE(DMACSAdr(channel), (unsigned)src);
		SMT_WRITE(DMACDAdr(channel), (unsigned)dest);
		SMT_WRITE(DMACCon(channel),
			(m2m<<29)|(Width<<24)|(srcIncr<<26)|(destIncr<<22)|(Width<<20)|(size<<16)|transferLen);

		SMT_WRITE(DMACDescrp(channel), 1);
		SMT_WRITE(DMACSta(channel), 0x8000001F);
		*/

		// Wait DMA end
		while(1)
		{
			returnErr = SMT_READ(DMACSta(channel));
			if(returnErr & 0x00000009)	// Stop/Error Interrupt Check
			{
				if (returnErr == 0x8)
					return DMA2D_STOPINT;
				else
					return DMA2D_ERRINT;
			}
		}

		nbytes -= transferLen;
	}

	return DMA2D_NO_INT;
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
	SMT_WRITE(FMUCON,
		fmc.waitReg<<SHIFT_DN_FROM_MASK(WAIT_REG) |
		0<<SHIFT_DN_FROM_MASK(UCPUH_EN) |   // CPU hold disable
		fmc.mode);
	
	return SMT_SUCCESS;
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
	smtUint32 readData;
	readData = *((smtUint32 *)(addr+FLASH_STARTADDR));
	
	return readData;
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
	smtUint32 writeData;

	writeData =
		( (timeCtrl.tRowCycle	<<SHIFT_DN_FROM_MASK(TRC_MASK))	& TRC_MASK) |
		( (timeCtrl.tRowActive	<<SHIFT_DN_FROM_MASK(TRAS_MASK))& TRAS_MASK) |
		( (timeCtrl.tCasLatency<<SHIFT_DN_FROM_MASK(TCL_MASK))	& TCL_MASK) |
		( (timeCtrl.tDelay		<<SHIFT_DN_FROM_MASK(TRCD_MASK))& TRCD_MASK) |
		( (timeCtrl.tPrecharge	<<SHIFT_DN_FROM_MASK(TRP_MASK))	& TRP_MASK);
		
	SMT_WRITE(SDRTCON, writeData);

	return SMT_SUCCESS;
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
	smtUint32 readData;

	readData = SMT_READ(SDRTCON);
	timeCtrl.tRowCycle	= (readData & TRC_MASK)	>> SHIFT_DN_FROM_MASK(TRC_MASK);
	timeCtrl.tRowActive	= (readData & TRAS_MASK)	>> SHIFT_DN_FROM_MASK(TRAS_MASK);
	timeCtrl.tCasLatency	= (readData & TCL_MASK)	>> SHIFT_DN_FROM_MASK(TCL_MASK);
	timeCtrl.tDelay		= (readData & TRCD_MASK)	>> SHIFT_DN_FROM_MASK(TRCD_MASK);
	timeCtrl.tPrecharge	= (readData & TRP_MASK)	>> SHIFT_DN_FROM_MASK(TRP_MASK);

	return SMT_SUCCESS;
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
	smtUint32 writeData;

	writeData =
		( (sdramCtrl.bitSel		<<SHIFT_DN_FROM_MASK(BIT16SEL_MASK))		& BIT16SEL_MASK) |
		( (sdramCtrl.colAddrSize	<<SHIFT_DN_FROM_MASK(COLADDRSIZ_MASK))	& COLADDRSIZ_MASK) |
		( (sdramCtrl.addrSwapEn	<<SHIFT_DN_FROM_MASK(ADDRSWAPEN_MASK))	& ADDRSWAPEN_MASK) |
		( (sdramCtrl.sdramEn		<<SHIFT_DN_FROM_MASK(SDREN_MASK))		& SDREN_MASK);
		
	SMT_WRITE(SDRCON, writeData);

	return SMT_SUCCESS;
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
	smtUint32 readData;

	readData = SMT_READ(SDRCON);
	sdramCtrl.bitSel		= (readData & BIT16SEL_MASK)		>> SHIFT_DN_FROM_MASK(BIT16SEL_MASK);
	sdramCtrl.colAddrSize	= (readData & COLADDRSIZ_MASK)	>> SHIFT_DN_FROM_MASK(COLADDRSIZ_MASK);
	sdramCtrl.addrSwapEn	= (readData & ADDRSWAPEN_MASK)	>> SHIFT_DN_FROM_MASK(ADDRSWAPEN_MASK);
	sdramCtrl.sdramEn	= (readData & SDREN_MASK)		>> SHIFT_DN_FROM_MASK(SDREN_MASK);

	return SMT_SUCCESS;
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
	smtUint32 writeData;

	writeData =
		( (pwrCtrl.pwdnRef	<<SHIFT_DN_FROM_MASK(SEFLREFEN_MASK))	& SEFLREFEN_MASK) |
		( (pwrCtrl.selfRefEn	<<SHIFT_DN_FROM_MASK(PWDNEN_MASK))		& PWDNEN_MASK) |
		( (pwrCtrl.pwdnEn		<<SHIFT_DN_FROM_MASK(PWDNREF_MASK))	& PWDNREF_MASK);
		
	SMT_WRITE(SDRPCON, writeData);

	return SMT_SUCCESS;
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
	smtUint32 readData;

	readData = SMT_READ(SDRPCON);
	pwrCtrl.pwdnRef	= (readData & SEFLREFEN_MASK)	>> SHIFT_DN_FROM_MASK(SEFLREFEN_MASK);
	pwrCtrl.selfRefEn	= (readData & PWDNEN_MASK)	>> SHIFT_DN_FROM_MASK(PWDNEN_MASK);
	pwrCtrl.pwdnEn	= (readData & PWDNREF_MASK)	>> SHIFT_DN_FROM_MASK(PWDNREF_MASK);

	return SMT_SUCCESS;
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
	smtUint32 writeData;

	writeData =
		( (refreshCtrl.refCount<<SHIFT_DN_FROM_MASK(REFNUM_MASK))		& REFNUM_MASK) |
		( (refreshCtrl.refNum	<<SHIFT_DN_FROM_MASK(REFCOUNT_MASK))	& REFCOUNT_MASK);
		
	SMT_WRITE(SDRREF, writeData);

	return SMT_SUCCESS;
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
	smtUint32 readData;

	readData = SMT_READ(SDRREF);
	refreshCtrl.refCount	= (readData & REFNUM_MASK)	>> SHIFT_DN_FROM_MASK(REFNUM_MASK);
	refreshCtrl.refNum	= (readData & REFCOUNT_MASK)	>> SHIFT_DN_FROM_MASK(REFCOUNT_MASK);

	return SMT_SUCCESS;
}


/*----------------------------------------------------------
        Video Interface Controller (VIF)
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtVIFSWReset()
	Prototype		: void smtVIFSWReset(void)
	Return			: void
	Argument		:
	Comments		: 
		Set VIF mode
-----------------------------------------------------------*/
void smtVIFSWReset(void)
{
	smtUint32 readData;

	readData = SMT_READ(VIFCON);
	SMT_WRITE(VIFCON, readData | SWRST_MASK);	// VIF SW reset
}

/*----------------------------------------------------------
	Function name	: smtVIFStart()
	Prototype		: void smtVIFStart(void)
	Return			: void
	Argument		:
	Comments		: 
		Set VIF mode
-----------------------------------------------------------*/
void smtVIFStart(void)
{
	smtUint32 readData;

	readData = SMT_READ(VIFCON);
	SMT_WRITE(VIFCON, readData | DMAEN_MASK);
}

/*----------------------------------------------------------
	Function name	: smtVIFSetMode()
	Prototype		: smtBoolean smtVIFSetMode(VIF_CTRL_STRUCT vif)
	Return			: smtBoolean
	Argument		:
	Comments		: 
		Set VIF mode
-----------------------------------------------------------*/
smtBoolean smtVIFSetMode(VIF_CTRL_STRUCT vif)
{
	smtUint32 writeData;

	writeData =
		( (vif.ycOrder	<< SHIFT_DN_FROM_MASK(YCORDER_MASK))	& YCORDER_MASK) |
		( (vif.startIntEn<< SHIFT_DN_FROM_MASK(STARTINTEN_MASK))& STARTINTEN_MASK) |
		( (vif.endIntEn<< SHIFT_DN_FROM_MASK(ENDINTEN_MASK))	& ENDINTEN_MASK) |
		( (vif.dmaEn	<< SHIFT_DN_FROM_MASK(DMAEN_MASK))		& DMAEN_MASK);

	SMT_WRITE(VIFCON, writeData);

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtVIFGetMode()
	Prototype		: smtBoolean smtVIFGetMode(VIF_CTRL_STRUCT vif)
	Return			: smtBoolean
	Argument		:
	Comments		: 
		Get VIF mode
-----------------------------------------------------------*/
smtBoolean smtVIFGetMode(VIF_CTRL_STRUCT vif)
{
	smtUint32 readData;

	readData = SMT_READ(VIFCON);

	vif.ycOrder	= (readData & YCORDER_MASK)	>> SHIFT_DN_FROM_MASK(YCORDER_MASK);
	vif.startIntEn	= (readData & STARTINTEN_MASK)>> SHIFT_DN_FROM_MASK(STARTINTEN_MASK);
	vif.endIntEn	= (readData & ENDINTEN_MASK)	>> SHIFT_DN_FROM_MASK(ENDINTEN_MASK);
	vif.dmaEn	= (readData & DMAEN_MASK)	>> SHIFT_DN_FROM_MASK(DMAEN_MASK);

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtVIFGetIntStatus()
	Prototype		: smtUint8 smtVIFGetIntStatus(void)
	Return			: smtUint8
	Argument		:
	Comments		: 
		Get VIF interrupt status
-----------------------------------------------------------*/
smtUint8 smtVIFGetIntStatus(void)
{
	smtUint32 readData;

	readData = SMT_READ(VIFSTS);

	if ( (readData & VIF_ENDFRAME) == VIF_ENDFRAME)
		return VIF_ENDFRAME;
	else if ( (readData & VIF_START_FRAME) == VIF_START_FRAME)
		return VIF_START_FRAME;
	else
		return VIF_NO_INT;
}

/*----------------------------------------------------------
	Function name	: smtVIFSetProperty()
	Prototype		: smtBoolean smtVIFSetProperty(VIF_PROP_STRUCT vifProp)
	Return			: smtBoolean
	Argument		:
	Comments		: 
		Set VIF property
-----------------------------------------------------------*/
smtBoolean smtVIFSetProperty(VIF_PROP_STRUCT vifProp)
{
	smtUint32 writeData;

	// X,Y position set
	writeData = 
		( (vifProp.vifXPos	<< SHIFT_DN_FROM_MASK(X_MASK))	& X_MASK) |
		( (vifProp.vifYPos	<< SHIFT_DN_FROM_MASK(Y_MASK))	& Y_MASK);
	SMT_WRITE(VIFPOS, writeData);

	// X,Y size set
	writeData =
		( (vifProp.vifXSize<< SHIFT_DN_FROM_MASK(X_MASK))	& X_MASK) |
		( (vifProp.vifYSize	<< SHIFT_DN_FROM_MASK(Y_MASK))	& Y_MASK);
	SMT_WRITE(VIFSIZ, writeData);

	// DMA address set
	SMT_WRITE(VIFADDR, vifProp.vifDmaAddr);

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtVIFGetProperty()
	Prototype		: smtBoolean smtVIFGetProperty(VIF_PROP_STRUCT vifProp)
	Return			: smtBoolean
	Argument		:
	Comments		: 
		Get VIF property
-----------------------------------------------------------*/
smtBoolean smtVIFGetProperty(VIF_PROP_STRUCT vifProp)
{
	smtUint32 readData;

	// X,Y position Get
	readData = SMT_READ(VIFPOS);

	vifProp.vifXPos	= (readData & X_MASK) >> SHIFT_DN_FROM_MASK(X_MASK);
	vifProp.vifYPos	= (readData & Y_MASK)	 >> SHIFT_DN_FROM_MASK(Y_MASK);

	// X,Y size Get
	readData =  SMT_READ(VIFSIZ);

	vifProp.vifXSize	= (readData & X_MASK) >> SHIFT_DN_FROM_MASK(X_MASK);
	vifProp.vifYSize	= (readData & Y_MASK) >> SHIFT_DN_FROM_MASK(Y_MASK);

	// DMA address Get
	vifProp.vifDmaAddr = SMT_READ(VIFADDR);

	return SMT_SUCCESS;
}


/*----------------------------------------------------------
        TIMER & PWM
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtTIMERSetMode()
	Prototype		: smtBoolean smtTIMERSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
	Return			: smtBoolean
	Argument		:
	Comments		: 
		Set timer mode
-----------------------------------------------------------*/
smtBoolean smtTIMERSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
	smtUint32 addr;
	
	addr = TPRE_START + 0x20*timerSel;
	//SMT_WRITE(TPRE0, TIMER0_PRE);
	SMT_WRITE((*(volatile smtUint32*)addr), timer.prescale);
	
	if(!TIMER_CAPTURE)
	{
		addr = TDAT_START + 0x20*timerSel;
		//SMT_WRITE(TDAT0, TIMER0_DAT);
		SMT_WRITE((*(volatile smtUint32*)addr), timer.data);
	}
	
	addr = TCON_START + 0x20*timerSel;
	//SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
	SMT_WRITE((*(volatile smtUint32*)addr),
		timer.phase<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		timer.timerClear<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) );
		//timer.timerEn<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtTIMERGetMode()
	Prototype		: smtBoolean smtTIMERGetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
	Return		: smtBoolean
	Argument	:
	Comments	: 
		Get timer mode
-----------------------------------------------------------*/
smtBoolean smtTIMERGetMode(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
	smtUint32 addr;
	smtUint32 prescale, data, control;
	
	addr = TPRE_START + 0x20*timerSel;
	prescale = SMT_READ(*(volatile smtUint32*)addr);

	if(!TIMER_CAPTURE)
	{
		addr = TDAT_START + 0x20*timerSel;
		data = SMT_READ(*(volatile smtUint32*)addr);
	}
	
	addr = TCON_START + 0x20*timerSel;
	control = SMT_READ(*(volatile smtUint32*)addr);

	timer.phase		= (control & TIMER_PHASE_INVERT_SEL) >> SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL);
	timer.clk			= (control & TIMER_IN_CLK_SEL) >> SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL);
	timer.opMode		= (control & TIMER_OP_MODE_SEL) >> SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL);
	timer.timerClear	= (control & TIMER_CNT_CLR) >> SHIFT_DN_FROM_MASK(TIMER_CNT_CLR);

	timer.prescale	= (smtUint8)(prescale & 0xFF);
	timer.data		= (smtUint16)(data & 0xFFFF);

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtTIMEROperation()
	Prototype		: smtBoolean smtTIMEROperation(TIMER_STRUCT timer, TIMER_SEL timerSel);
	Return			: smtBoolean
	Argument		:
	Comments		: 
		Timer start or stop
		You need to GPIO set before use the smtTimerOperatoin().
			ex)
			GPIO_STRUCT gpio;
			gpio.gpioMode = ;
			gpio.gpioNum = ;
			smtGPIOSetDir(GPIO_STRUCT gpio);
			
			smtTimerOperation(timer, timerSel);
-----------------------------------------------------------*/
smtBoolean smtTIMEROperation(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
	smtUint32 addr;
	if(timer.timerEn == SMT_TRUE)       // When timer enable
		smtTIMERSetMode(timer, timerSel);
	
	addr = TCON_START + 0x20*timerSel;
	SMT_WRITE((*(volatile unsigned*)addr),
		SMT_READ((*(volatile unsigned*)addr)) | timer.timerEn);
	
	return SMT_SUCCESS;
}


/*----------------------------------------------------------
        WDT
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtWDTSetMode()
	Prototype		: smtBoolean smtWDTSetMode(WDT_STRUCT wdt);
	Return			: smtBoolean
	Argument		: WDT struct
	Comments		: 
		Set the WDT mode
-----------------------------------------------------------*/
smtBoolean smtWDTSetMode(WDT_STRUCT wdt)
{
	SMT_WRITE(WDTPSR,  wdt.preScale);
	SMT_WRITE(WDTTLDR, wdt.reloadValue);
	
	SMT_WRITE(WDTCR,
		wdt.div<<SHIFT_DN_FROM_MASK(WDT_DIV_SEL) |
		wdt.clkSel<<SHIFT_DN_FROM_MASK(WDT_CLKSEL) |
		wdt.intEn<<SHIFT_DN_FROM_MASK(WDT_INTEN) |
		wdt.rstEn<<SHIFT_DN_FROM_MASK(WDT_RSTEN) );
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtWDTOperation()
	Prototype		: smtBoolean smtWDTOperation(WDT_STRUCT wdt);
	Return			: smtBoolean
	Argument		: WDT struct
	Comments		: 
		WDT start/stop
-----------------------------------------------------------*/
smtBoolean smtWDTOperation(WDT_STRUCT wdt)
{
	smtWDTSetMode(wdt);
	SMT_WRITE(WDTCR, SMT_READ(WDTCR) | wdt.wdtEn<<SHIFT_DN_FROM_MASK(WDT_EN) );
	
	return SMT_SUCCESS;
}


/*----------------------------------------------------------
        GPIO
--------------------------------------------------------- */
/*----------------------------------------------------------
	Function name	: smtGPIOSetDir()
	Prototype		: void smtGPIOSetDir(GPIO_STRUCT gpio);
	Return			: void
	Argument		: GPIO type & GPIO mode
	Comments		: 
		Set the GPIO mode
-----------------------------------------------------------*/
void smtGPIOSetDir(GPIO_STRUCT gpio)
{
	// GPIO#, mode
	switch(gpio.gpioNum)
	{
		case GPIO0_TYPE :
			SMT_WRITE(GPIO0_OE, gpio.gpioMode);
			break;
		case GPIO1_TYPE :
			SMT_WRITE(GPIO1_OE, gpio.gpioMode);
			break;
		default :
			;//ASSERT();
	}
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetDir()
	Prototype		: void smtGPIOGetDir(GPIO_STRUCT gpio);
	Return			: void
	Argument		: GPIO type
	Comments		: 
		Get the GPIO mode
-----------------------------------------------------------*/
void smtGPIOGetDir(GPIO_STRUCT gpio)
{
	// GPIO#
	switch(gpio.gpioNum)
	{
		case GPIO0_TYPE :
			gpio.gpioMode = SMT_READ(GPIO0_OE);
			break;
		case GPIO1_TYPE :
			gpio.gpioMode = SMT_READ(GPIO1_OE);
			break;
		default :
			;//ASSERT();
	}
}

/*----------------------------------------------------------
	Function name	: smtGPIOSetData()
	Prototype		: smtUint8 smtGPIOSetData(GPIO_STRUCT gpio, smtUint32 gpioData);
	Return			: void
	Argument		: GPIO type & GPIO data
	Comments		: 
		Set the GPIO data
-----------------------------------------------------------*/
void smtGPIOSetData(GPIO_STRUCT gpio, smtUint32 gpioData)
{
	// GPIO#, mode
	switch(gpio.gpioNum)
	{
		case GPIO0_TYPE :
			SMT_WRITE(GPIO0_OUT, gpioData); //gpio.gpioData);
			break;
		case GPIO1_TYPE :
			SMT_WRITE(GPIO1_OUT, gpioData); //gpio.gpioData);
			break;
		default :
			;//ASSERT();
	}
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetData()
	Prototype		: void smtGPIOGetData(GPIO_STRUCT gpio, smtUint32 gpioData)
	Return			: void
	Argument		: GPIO type & GPIO mode
	Comments		: 
		Get the GPIO data
-----------------------------------------------------------*/
void smtGPIOGetData(GPIO_STRUCT gpio, smtUint32 gpioData)
{
	// GPIO#
	switch(gpio.gpioNum)
	{
		case GPIO0_TYPE :
			gpioData = SMT_READ(GPIO0_IN);
			break;
		case GPIO1_TYPE :
			gpioData = SMT_READ(GPIO1_IN);
			break;
		default :
			;//ASSERT();
	}
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetIntStatus()
	Prototype		: void smtGPIOGetIntStatus(GPIO_STRUCT gpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Get GPIO interrupt status
-----------------------------------------------------------*/
void smtGPIOGetIntStatus(GPIO_STRUCT gpio)
{
	if (gpio.gpioNum == GPIO0_TYPE)
		gpio.intStatus = SMT_READ(GPIO0_INTSTAT);
	else if (gpio.gpioNum == GPIO1_TYPE)
		gpio.intStatus = SMT_READ(GPIO1_INTSTAT);
	else
		;//ASSERT();
}

/*----------------------------------------------------------
	Function name	: smtGPIOIntClear()
	Prototype		: void smtGPIOIntClear(GPIO_STRUCT gpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		GPIO interrupt clear
-----------------------------------------------------------*/
void smtGPIOIntClear(GPIO_STRUCT gpio)
{
	if (gpio.intNum> 31)
		;//ASSERT();

	if (gpio.gpioNum == GPIO0_TYPE)
		SMT_WRITE(GPIO0_INTSTAT, GPIO_INT_DETECTED << gpio.intNum );
	else if (gpio.gpioNum == GPIO1_TYPE)
		SMT_WRITE(GPIO1_INTSTAT, GPIO_INT_DETECTED << gpio.intNum );
	else
		;//ASSERT();
}

/*----------------------------------------------------------
	Function name	: smtGPIOIntEnable()
	Prototype		: void smtGPIOIntEnable(GPIO_STRUCT gpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		GPIO interrupt enable
-----------------------------------------------------------*/
void smtGPIOIntEnable(GPIO_STRUCT gpio)
{
	if (gpio.intNum> 31)
		;//ASSERT();

	if (gpio.gpioNum == GPIO0_TYPE)
	{
		SMT_WRITE(GPIO0_INTEN,
			SMT_READ(GPIO0_INTEN) |GPIO_INT_ENABLE << gpio.intNum);
	}
	else if (gpio.gpioNum == GPIO1_TYPE)
	{
		SMT_WRITE(GPIO1_INTEN,
			SMT_READ(GPIO1_INTEN) |GPIO_INT_ENABLE << gpio.intNum);
	}
	else
		;//ASSERT();
}

/*----------------------------------------------------------
	Function name	: smtGPIOIntDisable()
	Prototype		: void smtGPIOIntDisable(GPIO_STRUCT gpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		GPIO interrupt disable
-----------------------------------------------------------*/
void smtGPIOIntDisable(GPIO_STRUCT gpio)
{
	if (gpio.intNum> 31)
		;//ASSERT();

	if (gpio.gpioNum == GPIO0_TYPE)
	{
		SMT_WRITE(GPIO0_INTEN,
			SMT_READ(GPIO0_INTEN) & (~(GPIO_INT_ENABLE << gpio.intNum)) );
	}
	else if (gpio.gpioNum == GPIO1_TYPE)
	{
		SMT_WRITE(GPIO1_INTEN,
			SMT_READ(GPIO1_INTEN) & (~(GPIO_INT_ENABLE << gpio.intNum)) );
	}
	else
		;//ASSERT();
}

/*----------------------------------------------------------
	Function name	: smtGPIOSetIntProperty()
	Prototype		: void smtGPIOSetIntProperty(GPIO_STRUCT gpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Set GPIO interrupt property
-----------------------------------------------------------*/
void smtGPIOSetIntProperty(GPIO_STRUCT gpio)
{
	if ( (gpio.intLevel > 31) || (gpio.intPolarity > 31) || (gpio.intBothEdge > 31) )
		;//ASSERT();

	if (gpio.gpioNum == GPIO0_TYPE)
	{
		SMT_WRITE(GPIO0_INTLEVEL, gpio.intLevel);
		SMT_WRITE(GPIO0_INTPOL, gpio.intPolarity);
		SMT_WRITE(GPIO0_INTBEDGE, gpio.intBothEdge);
	}
	else if (gpio.gpioNum == GPIO1_TYPE)
	{
		SMT_WRITE(GPIO1_INTLEVEL, gpio.intLevel);
		SMT_WRITE(GPIO1_INTPOL, gpio.intPolarity);
		SMT_WRITE(GPIO1_INTBEDGE, gpio.intBothEdge);
	}
	else
		;//ASSERT();
}

/*----------------------------------------------------------
	Function name	: smtGPIOGetIntProperty()
	Prototype		: void smtGPIOGetIntProperty(GPIO_STRUCT gpio);
	Return		: void
	Argument	: GPIO type & GPIO mode & interrupt information
	Comments	: 
		Get GPIO interrupt property
-----------------------------------------------------------*/
void smtGPIOGetIntProperty(GPIO_STRUCT gpio)
{
	if (gpio.gpioNum == GPIO0_TYPE)
	{
		gpio.intLevel		= SMT_READ(GPIO0_INTLEVEL);
		gpio.intPolarity	= SMT_READ(GPIO0_INTPOL);
		gpio.intBothEdge	= SMT_READ(GPIO0_INTBEDGE);
	}
	else if (gpio.gpioNum == GPIO1_TYPE)
	{
		gpio.intLevel		= SMT_READ(GPIO1_INTLEVEL);
		gpio.intPolarity	= SMT_READ(GPIO1_INTPOL);
		gpio.intBothEdge	= SMT_READ(GPIO1_INTBEDGE);
	}
	else
		;//ASSERT();
}

/*----------------------------------------------------------
	Function name	: smt2GPIOWriteData()
	Prototype		: smtBoolean smt2GPIOWriteData(GPIO_STRUCT gpio, smtUint32 gpioData);
	Return			: smtBoolean
	Argument		: GPIO type & GPIO data
	Comments		: 
		Write the GPIO data
-----------------------------------------------------------*/
smtBoolean smt2GPIOWriteData(GPIO_STRUCT gpio, smtUint32 gpioData)
{
	smtUint8 gpioErr;

	smtGPIOSetDir(gpio);
	smtGPIOSetData(gpio, gpioData);

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smt2GPIOReadData()
	Prototype		: smtBoolean smt2GPIOReadData(GPIO_STRUCT gpio, smtUint32 gpioData);
	Return			: smtBoolean
	Argument		: GPIO type & GPIO data
	Comments		: 
		Read the GPIO data
-----------------------------------------------------------*/
smtBoolean smt2GPIOReadData(GPIO_STRUCT gpio, smtUint32 gpioData)
{
	smtUint8 gpioErr;

	smtGPIOSetDir(gpio);
	smtGPIOGetData(gpio, gpioData);

	return SMT_SUCCESS;
}


/*----------------------------------------------------------
        VIC (Vectored Interrupt Controller)
-----------------------------------------------------------*/


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
}
