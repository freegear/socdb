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

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "i2s_pre_drv.h"
#include "commonmacro.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/

/*----------------------------------------------------------
	I2S controller
	
	# clock functions  
		- smtI2SSetClockMode/smtI2SGetClockMode
	
	# TX/RX function
		- smtI2SClearFIFO
		- smtI2SResetFIFO
		- smtI2SSetMode/smtI2SGetMode
		- smtI2SEnable
		- smtI2SGetStatus
		
	# Data function
		- smtI2SGetData;
		- smtI2SSetData;
		
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtI2SSetClockMode()
	Prototype		: void smtI2SSetClockMode(I2sClkMode *pclkMode)
	Return			: none
	Argument		: I2SClockMode structure
	Comments		: Set I2S clock mode
-----------------------------------------------------------*/
void smtI2SSetClockMode(I2sClkMode *pclkMode)
{
	SMT_WRITE(I2S_CLKCTRL, 
		( (pclkMode->ClkMaster	& 0x1)			<< 31)	// set master and slave
		|((pclkMode->LRClkInv	& 0x1)			<< 30)	// set LR polority invert
		|((pclkMode->MClkOn		& 0x1)			<< 18)	// DTO on/off
		|((pclkMode->MClkOE		& 0x1)			<< 19)	// DTO out enable signal
		|((pclkMode->DTORatio	& 0x0FFFFFFF)	<< 00)	// DTO ratio
	);
}

/*----------------------------------------------------------
    Function name   : smtI2SGetClockMode()
    Prototype       : void smtI2SGetClockMode(I2sClkMode *pclkMode) 
    Return          : none
    Argument        : I2sClkMode structure
    Comments        : Get I2S clock mode
-----------------------------------------------------------*/
void smtI2SGetClockMode(I2sClkMode *pclkMode) 
{
	smtUint32 Register;
	
	Register			= SMT_READ(I2S_CLKCTRL);
	pclkMode->ClkMaster	= ((Register>>31)&0x1);			// get master and slave
	pclkMode->LRClkInv	= ((Register>>30)&0x1);			// get LR polority invert
	pclkMode->MClkOn	= ((Register>>18)&0x1);			// get DTO on/off            
	pclkMode->MClkOE	= ((Register>>19)&0x1);         // get DTO out enable signal 
	pclkMode->DTORatio	= ((Register>>00)&0x0FFFFFFF);  // get DTO ratio             
}

/*----------------------------------------------------------
	Function name	: smtI2SSetMode
	Prototype		: void smtI2SSetMode(I2sTransDir dir, I2sCtrl *pcontrol)
	Return			: none
	Argument		: I2sCtrl structure
	Comments		: Set I2S RX/TX mode
-----------------------------------------------------------*/
void smtI2SSetMode(I2sTransDir dir, I2sCtrl *pcontrol)
{
	smtUint32 reg;

	if(dir == I2S_DIR_RX) 
	{
		reg = SMT_READ(I2S_CTRL) & 0x0000FFFF;
		SMT_WRITE(I2S_CTRL, 
			reg
			|((pcontrol->DMAIntEn		&0x1)	<<29)	// set DMA IRQ enable
			|((pcontrol->FifoOURIntEn	&0x1)	<<28)	// set Over run IRQ enable
			|((pcontrol->WLen			&0x3)	<<25)	// Set Sample width
			|((pcontrol->Ljust			&0x1)	<<24)	// Set justify
			|((pcontrol->FifoTH			&0x3F)	<<16)	// Set FIFO threshold
		);		
		
	} 
	else if(dir == I2S_DIR_TX) 
	{
		reg = SMT_READ(I2S_CTRL) & 0xFFFF0000;
		SMT_WRITE(I2S_CTRL,
			reg 
			|((pcontrol->DMAIntEn		&0x1)	<<13)	// set DMA IRQ enable
			|((pcontrol->FifoOURIntEn	&0x1)	<<12)	// set under run IRQ enable
			|((pcontrol->WLen			&0x3)	<< 9)	// Set Sample width
			|((pcontrol->Ljust			&0x1)	<< 8)	// Set justify
			|((pcontrol->FifoTH			&0x3F)	<< 0)	// Set FIFO threshold
		);		
	}
	
}

/*----------------------------------------------------------
	Function name	: smtI2SGetMode
	Prototype		: void smtI2SGetMode(I2sTransDir dir, I2sCtrl *pControl)
	Return			: none
	Argument		: none
	Comments		: Get RX status
-----------------------------------------------------------*/
void smtI2SGetMode(I2sTransDir dir, I2sCtrl *pControl)
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
	Prototype		: void smtI2SGetStatus(I2sTransDir dir, I2sStatusDat *pstatus)
	Return			: none
	Argument		: none
	Comments		: Get RX status
-----------------------------------------------------------*/
void smtI2SGetStatus(I2sTransDir dir, I2sStatusDat *pstatus)
{

	smtUint32 Register;	
	
	if(dir == I2S_DIR_RX)
	{
		Register			= SMT_READ(I2S_STATUS);
		pstatus->DMAInt		= ((Register>>29)&0x1);
		pstatus->FIFOURInt	= ((Register>>28)&0x1);
		pstatus->FIFODepth	= ((Register>>24)&0xF);
		pstatus->FIFOL		= ((Register>>16)&0x7F);				
		
	}
	else if(dir == I2S_DIR_TX)
	{
		Register			= SMT_READ(I2S_STATUS);
		pstatus->DMAInt		= ((Register>>13)&0x1);
		pstatus->FIFOURInt	= ((Register>>12)&0x1);
		pstatus->FIFODepth	= ((Register>> 8)&0xF);
		pstatus->FIFOL		= ((Register>> 0)&0x7F);		
	}
}

/*----------------------------------------------------------
	Function name	: smtI2SClearFIFO
	Prototype		: void smtI2SClearFIFO(I2sTransDir dir)
	Return			: none
	Argument		: none
	Comments		: Clear Under run interrupt clear
-----------------------------------------------------------*/
void smtI2SClearFIFO(I2sTransDir dir)
{
	if(dir == I2S_DIR_RX)
	{
		SMT_WRITE(I2S_STATUS, (1<<28));
	}
	else if(dir == I2S_DIR_TX)
	{
		SMT_WRITE(I2S_STATUS, (1<<12));
	}
}

/*----------------------------------------------------------
	Function name	: smtI2SResetFIFO
	Prototype		: void smtI2SResetFIFO(I2sTransDir dir)
	Return			: none
	Argument		: void
	Comments		: Set reset TX
-----------------------------------------------------------*/
void smtI2SResetFIFO(I2sTransDir dir)
{
	if(dir == I2S_DIR_RX)
	{
		SMT_WRITE(I2S_CTRL,
			SMT_READ(I2S_CTRL)			// previous value
			|(0x1 << 30)				// set reset bit
		);
	}
	else if(dir == I2S_DIR_TX)
	{
		SMT_WRITE(I2S_CTRL,
			SMT_READ(I2S_CTRL)			// previous value
			|(0x1 << 14)				// set reset bit
		);		
	}
}

/*----------------------------------------------------------
	Function name	: smtI2SEnable
	Prototype		: void smtI2SEnable(I2sTransDir dir, smtUint32 enable) 
	Return			: none
	Argument		: enable flag
	Comments		: Set enable
-----------------------------------------------------------*/
void smtI2SEnable(I2sTransDir dir, smtUint32 enable)
{
	if(dir == I2S_DIR_RX) 
	{
		SMT_WRITE(I2S_CTRL,
			SMT_READ(I2S_CTRL)			// previous value
			|((enable & 0x1) << 31)		// set enable flag
	);
	}
	else if(dir == I2S_DIR_TX) 
	{
		SMT_WRITE(I2S_CTRL,
			SMT_READ(I2S_CTRL)			// previous value
			|((enable & 0x1) << 15)		// set enable flag
		);
	}
}
/*----------------------------------------------------------
	Function name	: smtI2SGetData
	Prototype		: void smtI2SGetData(smtUint32 *pdata)
	Return			: none
	Argument		: none
	Comments		: get data from I2S
-----------------------------------------------------------*/
void smtI2SGetData(smtUint32 *pdata)
{
	
	*pdata = (smtUint32)SMT_READ(I2S_DATA);
}
/*----------------------------------------------------------
	Function name	: smtI2SSetData
	Prototype		: void smtI2SSetData(smtUint32 *pdata)
	Return			: none
	Argument		: none
	Comments		: Set data from I2S
-----------------------------------------------------------*/
void smtI2SSetData(smtUint32 *pdata)
{
	SMT_WRITE(I2S_DATA, *pdata);
}
