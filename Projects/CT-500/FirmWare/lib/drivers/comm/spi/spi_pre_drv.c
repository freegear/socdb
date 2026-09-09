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
    Prototype		: void smtSPISetMode(SpiChannel channel, SpiCtrl *pspiControl)
    Return			: void
    Argument		:
    Comments        : SPI control register setting
-----------------------------------------------------------------------*/
void smtSPISetMode(SpiChannel channel, SpiCtrl *pspiControl)
{
	SMT_WRITE(SPICON(channel),
					((pspiControl->spiEnable		<< 3) & SPIENABLE)|		// SPI Enable  0: Disable 1: Enable
					((pspiControl->masterSel	<< 2) & MS)|					// SPI Master/Slave Mode Select 0: Master 1: Slave
					((pspiControl->polaritySel	<< 1) & CPOL)|				// SPI Mode0 Setting
					((pspiControl->phaseSel		<< 1) & CPHA) );			// Control Register Setting
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIGetMode()
    Prototype		: void smtSPIGetMode(SpiChannel channel, SpiCtrl pspiControl)
    Return			: void
    Argument		:
    Comments        : SPI control register getting
-----------------------------------------------------------------------*/
void smtSPIGetMode(SpiChannel channel, SpiCtrl *pspiControl)
{
	smtUint32 rdData;
	rdData = SMT_READ(SPICON(channel));

	pspiControl->spiEnable	= (rdData & 0x8) >> 3;
	pspiControl->masterSel	= (rdData & 0x4) >> 2;
	pspiControl->polaritySel	= (rdData & 0x2) >> 1;
	pspiControl->phaseSel	= (rdData & 0x1) >> 0;
}

/*-----------------------------------------------------------------------
    Function name	: smtSPISetPrescaler()
    Prototype		: void smtSPISetPrescaler(SpiChannel channel, smtUint32 preVal, smtUint32 divVal)
    Return			: void
    Argument		:
    Comments        : SPI prescale setting
-----------------------------------------------------------------------*/
void smtSPISetPrescaler(SpiChannel channel, smtUint32 preVal, smtUint32 divVal)
{
	SMT_WRITE(SPIPRE(channel), (preVal & SPIPRESCALER )|(divVal& SPIDIVIDER)); 	// Prescaler Setting
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIGetStatus()
    Prototype		: void smtSPIGetStatus(SpiChannel channel, SpiStatus pstatus)
    Return			: void
    Argument		:
    Comments        : SPI status read
-----------------------------------------------------------------------*/
void smtSPIGetStatus(SpiChannel channel, SpiStatus *pstatus)
{
	smtUint32 rdData;
	rdData = SMT_READ(SPISTA(channel));

	pstatus->txFifoLevel	= (rdData & 0x3C00) >> 10;
	pstatus->rxFifoLevel	= (rdData & 0x3C0)>> 6;
	pstatus->txFifoFull	= (rdData & 0x20) >> 5;
	pstatus->txFifoEmpty	= (rdData & 0x10) >> 4;
	pstatus->rxFifoFull	= (rdData & 0x8) >> 3;
	pstatus->rxFifoEmpty	= (rdData & 0x4) >> 2;
	pstatus->busy		= (rdData & 0x2) >> 1;
}

/*-----------------------------------------------------------------------
    Function name	: smtSPISetIntDMA()
    Prototype		: void smtSPISetIntDMA(SpiChannel channel, SpiIntDma *pspiInterruptDMA)
    Return			: void
    Argument		:
    Comments        : SPI Intr & DMA info setting
-----------------------------------------------------------------------*/
void smtSPISetIntDMA(SpiChannel channel, SpiIntDma *pspiInterruptDMA)
{
	SMT_WRITE(SPIINTDMA(channel),	
					( ((pspiInterruptDMA->txFifoIntEn		<< 13) &SPITXFINTEN) 		|	// Tx FIFO Interrupt
					((pspiInterruptDMA->rxFifoIntEn		<< 12) &SPIRXFINTEN)		|	// RX FIFO Interrupt
					((pspiInterruptDMA->rxTimeOutIntEn	<< 11) &SPIRXTOUTINTEN)	|	// RX Time Out Interrupt
					((pspiInterruptDMA->rxOverRunIntEn	<< 10) &SPIRXFOVRINTEN)	|	// RX FIFO Overrun Interrupt	
					((pspiInterruptDMA->txDMAEn			<< 9)   &SPITXDMAREQEN)	|	// TX DMA Request Enable
					((pspiInterruptDMA->txDMAlevel		<< 5)   &SPITXDMALEVEL)	|	// TX DMA Request Level Setting
					((pspiInterruptDMA->rxDMAEn			<< 4)   &SPIRXDMAREQEN)	|	// RX DMA Request Enable
					((pspiInterruptDMA->rxDMAlevel		<< 0)   &SPIRXDMALEVEL) ));	// RX DMA Request Level Setting
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIGetIntDMA()
    Prototype		: void smtSPIGetIntDMA(SpiChannel channel, SpiIntDma *pspiInterruptDMA)
    Return			: void
    Argument		:
    Comments        : SPI intr & DMA info getting
-----------------------------------------------------------------------*/
void smtSPIGetIntDMA(SpiChannel channel, SpiIntDma *pspiInterruptDMA)
{
	smtUint32 rdData;
	rdData = SMT_READ(SPIINTDMA(channel));

	pspiInterruptDMA->txFifoIntEn		= (rdData & 0x2000) >> 13;
	pspiInterruptDMA->rxFifoIntEn		= (rdData & 0x1000) >> 12;
	pspiInterruptDMA->rxTimeOutIntEn	= (rdData & 0x800) >> 11;
	pspiInterruptDMA->rxOverRunIntEn	= (rdData & 0x400) >> 10;
	pspiInterruptDMA->txDMAEn		= (rdData & 0x200) >> 9;
	pspiInterruptDMA->txDMAlevel		= (rdData & 0x1E0) >> 5;
	pspiInterruptDMA->rxDMAEn		= (rdData & 0x10) >> 4;
	pspiInterruptDMA->rxDMAlevel		= (rdData & 0xF) >> 0;
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIGetIntStatus()
    Prototype		: void smtSPIGetIntStatus(SpiChannel channel, SpiIntStatus *pintStatus)
    Return			: void
    Argument		:
    Comments        : Getting SPI status information
-----------------------------------------------------------------------*/
void smtSPIGetIntStatus(SpiChannel channel, SpiIntStatus *pintStatus)
{
	smtUint32 rdData;
	rdData = SMT_READ(SPIINTSTA(channel));

	pintStatus->txFifoIntSta 		= (rdData & 0x8) >> 3;
	pintStatus->rxFifoIntSta 		= (rdData & 0x4) >> 2;
	pintStatus->rxTimeOutIntSta	= (rdData & 0x2) >> 1;
	pintStatus->rxOverRunIntSta	= (rdData & 0x1) >> 0;
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIClrIntStatus()
    Prototype		: void smtSPIClrIntStatus(SpiChannel channel, SpiIntStatus intStatus)
    Return			: void
    Argument		:
    Comments        : Clear SPI Interrupt status
-----------------------------------------------------------------------*/
void smtSPIClrIntStatus(SpiChannel channel, SpiIntStatus intStatus)
{
	SMT_WRITE(SPIINTSTA(channel),
		((intStatus.rToutIntClr & 0x1)	<< 5) |
		((intStatus.rOverIntClr& 0x1)	<< 4) );
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIWrite()
    Prototype		: void smtSPIWrite(SpiChannel channel, smtUint8 data)
    Return			: void
    Argument		:
    Comments        : SPI Initialize
-----------------------------------------------------------------------*/
void smtSPIWrite(SpiChannel channel, smtUint8 data)
{
	SMT_WRITE(SPITXDAT(channel),data);
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIRead()
    Prototype		: void smtSPIRead(SpiChannel channel, smtUint8 *pdata)
    Return			: void
    Argument		:
    Comments        : SPI Initialize
-----------------------------------------------------------------------*/
void smtSPIRead(SpiChannel channel, smtUint8 *pdata)
{
	//return SMT_READ(SPIRXDAT(channel));
	*pdata = (smtUint8)SMT_READ(SPIRXDAT(channel));
}

/*-----------------------------------------------------------------------
    Function name	: smtSPIInit()
    Prototype		: smtSPIInit(SpiChannel channel, smtUint32 PreVal, smtUint32 DivVal)
    Return			: void
    Argument		:
    Comments        : SPI Initialize
-----------------------------------------------------------------------*/
void smtSPIInit(SpiChannel channel, smtUint32 PreVal, smtUint32 DivVal)
{
	SpiIntDma spiInterruptDMA;
	SpiCtrl spiControl;

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

	spiInterruptDMA.txFifoIntEn		= 0;
	spiInterruptDMA.rxFifoIntEn		= 0;
	spiInterruptDMA.rxTimeOutIntEn	= 0;
	spiInterruptDMA.rxOverRunIntEn	= 0;
	spiInterruptDMA.txDMAEn		= 0;
	spiInterruptDMA.txDMAlevel		= 1;
	spiInterruptDMA.rxDMAEn		= 0;
	spiInterruptDMA.rxDMAlevel		= 1;
	smtSPISetIntDMA(channel, &spiInterruptDMA);

	/*
	SMT_WRITE(SPICON(channel),
					((1<<3)&SPIENABLE)|			// SPI Enable  0: Disable 1: Enable
					((0<<2)&MS)|				// SPI Master/Slave Mode Select 0: Master 1: Slave
					((1<<1)&CPOL)|				// SPI Mode3 Setting
					((1<<1)&CPHA)
					);							// Control Register Setting
	*/

	spiControl.spiEnable	= 1; 
	spiControl.masterSel	= 0;
	spiControl.polaritySel	= 0;
	spiControl.phaseSel	= 0;
	smtSPISetMode(channel, &spiControl);
}

