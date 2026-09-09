/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: i2s_pre_drv.c
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "i2s_pre_drv.h"
#include "commonmacro.h"

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/

/*----------------------------------------------------------
	I2S controller
	
	# clock functions  
		- smtSetClockMode/smtGetClockMode
	
	# TX/RX function
		- smtI2SFIFOClear
		- smtI2SFIFOReset
		- smtSetI2SMode/smtGetI2SMode
		- smtI2SEnable
		- smtI2SGetStatus
		
	# Data function
		- smtI2SGetData;
		- smtI2SSetData;
		
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtSetClockMode()
	Prototype		: void smtSetClockMode(I2SClockMode clkMode)
	Return			: none
	Argument		: I2SClockMode structure
	Comments		: Set I2S clock mode
-----------------------------------------------------------*/
void smtSetClockMode(I2S_CLOCK_MODE clkMode)
{
	
	SMT_WRITE(I2S_CLKCTRL, 
		((clkMode.ClkMaster	& 0x1)			<< 31)	// set master and slave
		|((clkMode.LRClkInv	& 0x1)			<< 30)	// set LR polority invert
		|((clkMode.MClkOn	& 0x1)			<< 29)	// DTO on/off
		|((clkMode.MClkOE	& 0x1)			<< 28)	// DTO out enable signal
		|((clkMode.DTORatio	& 0x0FFFFFFF)	<< 00)	// DTO ratio
	);
}

/*----------------------------------------------------------
    Function name   : smtGetClockMode()
    Prototype       : void smtGetClockMode(I2S_CLOCK_MODE *pclkMode) 
    Return          : none
    Argument        : I2S_CLOCK_MODE structure
    Comments        : Get I2S clock mode
-----------------------------------------------------------*/
void smtGetClockMode(I2S_CLOCK_MODE *pclkMode) 
{
	smtUint32 Register;
	
	Register			= SMT_READ(I2S_CLKCTRL);
	pclkMode->ClkMaster	= ((Register>>31)&0x1);			// get master and slave
	pclkMode->LRClkInv	= ((Register>>30)&0x1);			// get LR polority invert
	pclkMode->MClkOn	= ((Register>>29)&0x1);			// get DTO on/off            
	pclkMode->MClkOE	= ((Register>>28)&0x1);         // get DTO out enable signal 
	pclkMode->DTORatio	= ((Register>>00)&0x0FFFFFFF);  // get DTO ratio             
}

/*----------------------------------------------------------
	Function name	: smtSetI2SMode
	Prototype		: void smtSetI2SMode(I2S_TRANS_DIR dir, I2S_CONTROL control)
	Return			: none
	Argument		: I2S_CONTROL structure
	Comments		: 
		Set I2S RX/TX mode
-----------------------------------------------------------*/
void smtSetI2SMode(I2S_TRANS_DIR dir, I2S_CONTROL control)
{

	if(dir == I2S_DIR_RX) 
	{
		SMT_WRITE(I2S_CTRL, 
			((control.DMAIntEn			&0x1)	<<29)	// set DMA IRQ enable
			|((control.FifoOURIntEn		&0x1)	<<28)	// set Over run IRQ enable
			|((control.WLen				&0x3)	<<25)	// Set Sample width
			|((control.Ljust			&0x1)	<<24)	// Set justify
			|((control.FifoTH			&0x3F)	<<16)	// Set FIFO threshold
		);		
		
	} else if(dir == I2S_DIR_TX) 
	{
		SMT_WRITE(I2S_CTRL, 
			 ((control.DMAIntEn			&0x1)	<<13)	// set DMA IRQ enable
			|((control.FifoOURIntEn		&0x1)	<<12)	// set under run IRQ enable
			|((control.WLen				&0x3)	<< 9)	// Set Sample width
			|((control.Ljust			&0x1)	<< 8)	// Set justify
			|((control.FifoTH			&0x3F)	<< 0)	// Set FIFO threshold
		);		
	}
	
}

/*----------------------------------------------------------
	Function name	: smtGetI2SMode
	Prototype		: void smtGetI2SMode(I2S_TRANS_DIR dir, I2S_CONTROL *pControl)
	Return			: none
	Argument		: none
	Comments		: 
		Get RX status
-----------------------------------------------------------*/
void smtGetI2SMode(I2S_TRANS_DIR dir, I2S_CONTROL *pControl)
{
	smtUint32 Register;
	
	if(dir == I2S_DIR_RX)
	{
		Register				= SMT_READ(I2S_CTRL);
		pControl->DMAIntEn		= ((Register>>29)&0x1);		// get DMA IRQ enable
		pControl->FifoOURIntEn	= ((Register>>28)&0x1);		// get Over run IRQ enable
		pControl->WLen			= ((Register>>25)&0x3);		// get Sample width           
		pControl->Ljust			= ((Register>>24)&0x1); 	// get justify
		pControl->FifoTH		= ((Register>>16)&0x3F);  	// get FIFO threshold		
	}
	else if(dir == I2S_DIR_TX)
	{
		Register				= SMT_READ(I2S_CTRL);
		pControl->DMAIntEn		= ((Register>>13)&0x1);		// get DMA IRQ enable
		pControl->FifoOURIntEn	= ((Register>>12)&0x1);		// get Over run IRQ enable
		pControl->WLen			= ((Register>> 9)&0x3);		// get Sample width           
		pControl->Ljust			= ((Register>> 8)&0x1); 	// get justify
		pControl->FifoTH		= ((Register>> 0)&0x3F);  	// get FIFO threshold		
	}
}

/*----------------------------------------------------------
	Function name	: smtI2SGetStatus
	Prototype		: void smtI2SGetStatus(I2S_TRANS_DIR dir, I2S_STATUS_DAT *pstatus)
	Return			: none
	Argument		: none
	Comments		: 
		Get RX status
-----------------------------------------------------------*/
void smtI2SGetStatus(I2S_TRANS_DIR dir, I2S_STATUS_DAT *pstatus)
{

	smtUint32 Register;	
	
	if(dir == I2S_DIR_RX)
	{
		Register			= SMT_READ(I2S_STATUS);
		pstatus->DMAInt		= ((Register>>31)&0x1);
		pstatus->FIFOURInt	= ((Register>>30)&0x1);
		pstatus->FIFOL		= ((Register>> 8)&0x7F);		
		
	}
	else if(dir == I2S_DIR_TX)
	{
		Register			= SMT_READ(I2S_STATUS);
		pstatus->DMAInt		= ((Register>>29)&0x1);
		pstatus->FIFOURInt	= ((Register>>28)&0x1);
		pstatus->FIFOL		= ((Register>> 0)&0x7F);		
	}
}

/*----------------------------------------------------------
	Function name	: smtI2SFIFOClear
	Prototype		: void smtI2SFIFOClear(I2S_TRANS_DIR dir)
	Return			: none
	Argument		: none
	Comments		: 
		Clear Under run interrupt clear
-----------------------------------------------------------*/
void smtI2SFIFOClear(I2S_TRANS_DIR dir)
{
	if(dir == I2S_DIR_RX)
	{
		SMT_WRITE(I2S_STATUS, (1<<30));
	}
	else if(dir == I2S_DIR_RX)
	{
		SMT_WRITE(I2S_STATUS, (1<<28));
	}
}

/*----------------------------------------------------------
	Function name	: smtI2SFIFOReset
	Prototype		: void smtI2SFIFOReset(I2S_TRANS_DIR dir)
	Return			: none
	Argument		: void
	Comments		: 
		Set reset TX
-----------------------------------------------------------*/
void smtI2SFIFOReset(I2S_TRANS_DIR dir)
{
	if(dir == I2S_DIR_RX)
	{
		SMT_WRITE(I2S_CTRL,
			SMT_READ(I2S_CTRL)	// previous value
			|(0x1 << 30)		// set reset bit
		);
	}
	else if(dir == I2S_DIR_TX)
	{
		SMT_WRITE(I2S_CTRL,
			SMT_READ(I2S_CTRL)			// previous value
			|(0x1 << 14)					// set reset bit
		);		
	}
}

/*----------------------------------------------------------
	Function name	: smtI2SEnable
	Prototype		: void smtI2SEnable(I2S_TRANS_DIR dir, smtUint32 enable) 
	Return			: none
	Argument		: enable flag
	Comments		: 
		Set enable
-----------------------------------------------------------*/
void smtI2SEnable(I2S_TRANS_DIR dir, smtUint32 enable)
{
	if(dir == I2S_DIR_RX) 
	{
		SMT_WRITE(I2S_CTRL,
			SMT_READ(I2S_CTRL)		// previous value
			|((enable & 0x1) << 31)	// set enable flag
	);
	}
	else if(dir == I2S_DIR_RX) 
	{
		SMT_WRITE(I2S_CTRL,
			SMT_READ(I2S_CTRL)			// previous value
			|((enable & 0x1) << 15)		// set enable flag
		);
	}
}
/*----------------------------------------------------------
	Function name	: smtI2SGetData
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtUint32 	smtI2SGetData(void)
{
	
	return (smtUint32)SMT_READ(I2S_DATA);
}
/*----------------------------------------------------------
	Function name	: smtI2SSetData
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtI2SSetData(smtUint32 data)
{
	SMT_WRITE(I2S_DATA, data);
}