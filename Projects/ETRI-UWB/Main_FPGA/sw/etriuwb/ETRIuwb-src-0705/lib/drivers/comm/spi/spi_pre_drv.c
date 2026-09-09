/*----------------------------------------------------------
	File Name   : spi.c 
	Description : spi API code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "spi_pre_drv.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name	: smtSPISetMode()
    Prototype		: void smtSPISetMode(smtUint8 channel, SPI_CON spi)
    Return			: void
    Argument		:
    Comments        : SPI control register setting
-----------------------------------------------------------------------*/
void smtSPISetMode(smtUint8 channel, SPI_CON_STRUCT spiCtrl)
{
	SMT_WRITE(SPICON(channel),
					((spiCtrl.spiEnable		<< 3) & SPIENABLE)|		// SPI Enable  0: Disable 1: Enable
					((spiCtrl.masterSel	<< 2) & MS)|				// SPI Master/Slave Mode Select 0: Master 1: Slave
					((spiCtrl.polaritySel	<< 1) & CPOL)|			// SPI Mode0 Setting
					((spiCtrl.phaseSel		<< 1) & CPHA) );			// Control Register Setting
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIGetMode()
    Prototype		: void smtSPIGetMode(smtUint8 channel, SPI_CON_STRUCT spiCtrl)
    Return			: void
    Argument		:
    Comments        : SPI control register getting
-----------------------------------------------------------------------*/
void smtSPIGetMode(smtUint8 channel, SPI_CON_STRUCT spiCtrl)
{
	smtUint32 rdData;
	rdData = SMT_READ(SPICON(channel));

	spiCtrl.spiEnable	= (rdData & 0x8) >> 3;
	spiCtrl.masterSel	= (rdData & 0x4) >> 2;
	spiCtrl.polaritySel	= (rdData & 0x2) >> 1;
	spiCtrl.phaseSel	= (rdData & 0x1) >> 0;
}

/*-----------------------------------------------------------------------
    Function name	: smtSPISetPrescaler()
    Prototype		: void smtSPISetPrescaler(smtUint8 channel, smtUint32 preVal, smtUint32 divVal)
    Return			: void
    Argument		:
    Comments        : SPI prescale setting
-----------------------------------------------------------------------*/
void smtSPISetPrescaler(smtUint8 channel, smtUint32 preVal, smtUint32 divVal)
{
	SMT_WRITE(SPIPRE(channel), (preVal & SPIPRESCALER )|(divVal& SPIDIVIDER)); 	// Prescaler Setting
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIGetStatus()
    Prototype		: void smtSPIGetStatus(smtUint8 channel, SPI_STATUS_STRUCT spiStatus)
    Return			: void
    Argument		:
    Comments        : SPI status read
-----------------------------------------------------------------------*/
void smtSPIGetStatus(smtUint8 channel, SPI_STATUS_STRUCT spiStatus)
{
	smtUint32 rdData;
	rdData = SMT_READ(SPISTA(channel));

	spiStatus.txFifoLevel	= (rdData & 0x3C00) >> 10;
	spiStatus.rxFifoLevel	= (rdData & 0x3C0)>> 6;
	spiStatus.txFifoFull	= (rdData & 0x20) >> 5;
	spiStatus.txFifoEmpty	= (rdData & 0x10) >> 4;
	spiStatus.rxFifoFull	= (rdData & 0x8) >> 3;
	spiStatus.rxFifoEmpty	= (rdData & 0x4) >> 2;
	spiStatus.busy		= (rdData & 0x2) >> 1;
}

/*-----------------------------------------------------------------------
    Function name	: smtSPISetPrescaler()
    Prototype		: void smtSPISetIntDMA(smtUint8 channel, SPI_INTDMA_STRUCT spiIntDMA)
    Return			: void
    Argument		:
    Comments        : SPI Intr & DMA info setting
-----------------------------------------------------------------------*/
void smtSPISetIntDMA(smtUint8 channel, SPI_INTDMA_STRUCT spiIntDMA)
{
	SMT_WRITE(SPIINTDMA(channel),	
					( ((spiIntDMA.txFifoIntEn		<< 13) &SPITXFINTEN) 		|	// Tx FIFO Interrupt
					((spiIntDMA.rxFifoIntEn		<< 12) &SPIRXFINTEN)		|	// RX FIFO Interrupt
					((spiIntDMA.rxTimeOutIntEn	<< 11) &SPIRXTOUTINTEN)	|	// RX Time Out Interrupt
					((spiIntDMA.rxOverRunIntEn	<< 10) &SPIRXFOVRINTEN)	|	// RX FIFO Overrun Interrupt	
					((spiIntDMA.txDMAEn			<< 9)   &SPITXDMAREQEN)	|	// TX DMA Request Enable
					((spiIntDMA.txDMAlevel		<< 5)   &SPITXDMALEVEL)	|	// TX DMA Request Level Setting
					((spiIntDMA.rxDMAEn			<< 4)   &SPIRXDMAREQEN)	|	// RX DMA Request Enable
					((spiIntDMA.rxDMAlevel		<< 0)   &SPIRXDMALEVEL) ));	// RX DMA Request Level Setting
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIGetIntDMA()
    Prototype		: void smtSPIGetIntDMA(smtUint8 channel, SPI_INTDMA_STRUCT spiIntDMA)
    Return			: void
    Argument		:
    Comments        : SPI intr & DMA info getting
-----------------------------------------------------------------------*/
void smtSPIGetIntDMA(smtUint8 channel, SPI_INTDMA_STRUCT spiIntDMA)
{
	smtUint32 rdData;
	rdData = SMT_READ(SPIINTDMA(channel));

	spiIntDMA.txFifoIntEn		= (rdData & 0x2000) >> 13;
	spiIntDMA.rxFifoIntEn		= (rdData & 0x1000) >> 12;
	spiIntDMA.rxTimeOutIntEn	= (rdData & 0x800) >> 11;
	spiIntDMA.rxOverRunIntEn	= (rdData & 0x400) >> 10;
	spiIntDMA.txDMAEn		= (rdData & 0x200) >> 9;
	spiIntDMA.txDMAlevel		= (rdData & 0x1E0) >> 5;
	spiIntDMA.rxDMAEn		= (rdData & 0x10) >> 4;
	spiIntDMA.rxDMAlevel		= (rdData & 0xF) >> 0;
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIGetIntStatus()
    Prototype		: void smtSPIGetIntStatus(smtUint8 channel, SPI_INTSTA_STRUCT spitIntDMA)
    Return			: void
    Argument		:
    Comments        : Getting SPI status information
-----------------------------------------------------------------------*/
void smtSPIGetIntStatus(smtUint8 channel, SPI_INTSTA_STRUCT spitIntDMA)
{
	smtUint32 rdData;
	rdData = SMT_READ(SPIINTSTA(channel));

	spitIntDMA.txFifoIntSta 		= (rdData & 0x8) >> 3;
	spitIntDMA.rxFifoIntSta 		= (rdData & 0x4) >> 2;
	spitIntDMA.rxTimeOutIntSta	= (rdData & 0x2) >> 1;
	spitIntDMA.rxOverRunIntSta	= (rdData & 0x1) >> 0;
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIClrIntStatus()
    Prototype		: void smtSPIClrIntStatus(smtUint8 channel, SPI_INTSTA_STRUCT spitIntDMA)
    Return			: void
    Argument		:
    Comments        : Clear SPI Interrupt status
-----------------------------------------------------------------------*/
void smtSPIClrIntStatus(smtUint8 channel, SPI_INTSTA_STRUCT spitIntDMA)
{
	SMT_WRITE(SPIINTSTA(channel),
		((spitIntDMA.rToutIntClr & 0x1)	<< 5) |
		((spitIntDMA.rOverIntClr& 0x1)	<< 4) );
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIOnebyteWrite()
    Prototype		: void smtSPIOnebyteWrite(smtInt8 channel, smtInt8 data)
    Return			: void
    Argument		:
    Comments        : SPI Initialize
-----------------------------------------------------------------------*/
void smtSPIOnebyteWrite(smtInt8 channel, smtInt8 data)
{
	SMT_WRITE(SPITXDAT(channel),data);
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIOnebyteRead()
    Prototype		: smtInt8 smtSPIOnebyteRead(smtInt8 channel)
    Return			: void
    Argument		:
    Comments        : SPI Initialize
-----------------------------------------------------------------------*/
smtInt8 smtSPIOnebyteRead(smtInt8 channel)
{
	return SMT_READ(SPIRXDAT(channel));
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIInit()
    Prototype		: smtSPIInit(smtInt8 channel, smtUint32 PreVal, smtUint32 DivVal)
    Return			: void
    Argument		:
    Comments        : SPI Initialize
-----------------------------------------------------------------------*/
void smtSPIInit(smtInt8 channel, smtUint32 PreVal, smtUint32 DivVal)
{
	SPI_INTDMA_STRUCT spiIntDMA;
	SPI_CON_STRUCT spiCtrl;

	//PCLK/(SPIDIVIDE*(SPIRESCALER+1))
	smtSPISetPrescaler(channel, PreVal, DivVal);

	/*
	SMT_WRITE(SPIINTDMA(channel),	
					( ((1<<13)&SPITXFINTEN) 	|	// Tx FIFO Interrupt
					((1<<12)&SPIRXFINTEN)	|	// RX FIFO Interrupt
					((1<<11)&SPIRXTOUTINTEN)|	// RX Time Out Interrupt
					((1<<10)&SPIRXFOVRINTEN)|	// RX FIFO Overrun Interrupt	
					((1<<9)&SPITXDMAREQEN)	|	// TX DMA Request Enable
					((1<<5)&SPITXDMALEVEL)	|	// TX DMA Request Level Setting
					((1<<4)&SPIRXDMAREQEN)	|	// RX DMA Request Enable
					((1<<0)&SPIRXDMALEVEL)	));	// RX DMA Request Level Setting
	*/							

	spiIntDMA.txFifoIntEn		= 0;
	spiIntDMA.rxFifoIntEn		= 0;
	spiIntDMA.rxTimeOutIntEn	= 0;
	spiIntDMA.rxOverRunIntEn	= 0;
	spiIntDMA.txDMAEn		= 0;
	spiIntDMA.txDMAlevel		= 1;
	spiIntDMA.rxDMAEn		= 0;
	spiIntDMA.rxDMAlevel		= 1;
	smtSPISetIntDMA(channel, spiIntDMA);

	/*
	SMT_WRITE(SPICON(channel),
					((1<<3)&SPIENABLE)|			// SPI Enable  0: Disable 1: Enable
					((0<<2)&MS)|				// SPI Master/Slave Mode Select 0: Master 1: Slave
					((1<<1)&CPOL)|				// SPI Mode3 Setting
					((1<<1)&CPHA)
					);							// Control Register Setting
	*/

	spiCtrl.spiEnable	= 1; 
	spiCtrl.masterSel	= 0;
	spiCtrl.polaritySel	= 0;
	spiCtrl.phaseSel	= 0;
	smtSPISetMode(channel, spiCtrl);
}

