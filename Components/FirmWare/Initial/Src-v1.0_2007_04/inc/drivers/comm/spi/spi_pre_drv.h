/*----------------------------------------------------------
	File Name   : spi.h
	Description : spi API code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#ifndef _SPI_H_
#define _SPI_H_

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
// SPICON register
#define SPIENABLE			(0x1Ul)<<3
#define MS					(0x1Ul)<<2


// SPICON register
#define SPIENABLE			(0x1Ul)<<3
#define MS					(0x1Ul)<<2
#define CPOL					(0x1Ul)<<1
#define CPHA					(0x1Ul)<<0

// SPIPRE register
#define SPIPRESCALER		(0xffUl)<<0
#define SPIDIVIDER			(0xffUl)<<8
// PCLK/(SPIDIVIDE*(SPIRESCALER+1))

// SPISTA register
#define SPITXFIFOFULL		(0x1Ul)<<5
#define SPITXFIFOEMPTY		(0x1Ul)<<4
#define SPIRXFIFOFULL		(0x1Ul)<<3
#define SPIRXFIFOEMPTY		(0x1Ul)<<2
#define SPIBUSY				(0x1Ul)<<1
#define SPIERROR				(0x1Ul)<<0

// SPIINTDMA
#define SPITXFINTEN			(0x1Ul)<<13
#define SPIRXFINTEN			(0x1Ul)<<12
#define SPIRXTOUTINTEN		(0x1Ul)<<11
#define SPIRXFOVRINTEN		(0x1Ul)<<10
#define SPITXDMAREQEN		(0x1Ul)<<9
#define SPITXDMALEVEL		(0xFUl)<<5
#define SPIRXDMAREQEN		(0x1Ul)<<4
#define SPIRXDMALEVEL		(0xFUl)<<0

// SPIINTSTA
#define RTIC					(0x1Ul)<<5
#define RORIC				(0x1Ul)<<4
#define TXFIFOINTSTA		(0x1Ul)<<3
#define RXFIFOINTSTA		(0x1Ul)<<2
#define RXTOUTINTSTA		(0x1Ul)<<1
#define RXOVRINTSTA			(0x1Ul)<<0

// SPITXDAT
#define TXDAT				(0xFFFFUl)<<0

// SPIRXDAT
#define	RXDAT				(0xFFFFUl)<<0

// SPIHIDDEN
#define DATASIZE			(0xFUl)<<4
#define	MODE				(0x3Ul)<<2
#define	SLAVEOEN			(0x1Ul)<<1
#define	LBM					(0x1Ul)<<0

// SPI DMA Channel
#define SPIRXDMACH			0 			// DMAREQ0
#define SPITXDMACH			1			// DMAREQ1

#define IncAdrType			1
#define NoIncAdrType		0
#define WidthBYTE			0x0
#define WidthHWORD			0x1
#define WidthWORD			0x2
#define TSize1B				0x0
#define TSize2B				0x1
#define TSize4B				0x2
#define TSize8B				0x3
#define TSize16B				0x4
#define TSize32B				0x5

typedef enum
{
	SPI_CHANNEL0,
	SPI_CHANNEL1
} SpiChannel;

typedef struct
{
	smtUint8 spiEnable;
	smtUint8 masterSel;
	smtUint8 polaritySel;
	smtUint8 phaseSel;
} SpiCtrl;

typedef struct
{
	smtUint8 txFifoIntEn;
	smtUint8 rxFifoIntEn;
	smtUint8 rxTimeOutIntEn;
	smtUint8 rxOverRunIntEn;
	smtUint8 txDMAEn;
	smtUint8 txDMAlevel;
	smtUint8 rxDMAEn;
	smtUint8 rxDMAlevel;
} SpiIntDma;

typedef struct
{
	smtUint8 txFifoLevel;
	smtUint8 rxFifoLevel;
	smtUint8 txFifoFull;
	smtUint8 txFifoEmpty;
	smtUint8 rxFifoFull;
	smtUint8 rxFifoEmpty;
	smtUint8 busy;
} SpiStatus;

typedef struct
{
	smtUint8 rToutIntClr;
	smtUint8 rOverIntClr;
	smtUint8 txFifoIntSta;
	smtUint8 rxFifoIntSta;
	smtUint8 rxTimeOutIntSta;
	smtUint8 rxOverRunIntSta;
} SpiIntStatus;

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
void smtSPISetMode(SpiChannel channel, SpiCtrl *pspiControl);
void smtSPIGetMode(SpiChannel channel, SpiCtrl *pspiControl);
void smtSPISetPrescaler(SpiChannel channel, smtUint32 preVal, smtUint32 divVal);
void smtSPIGetStatus(SpiChannel channel, SpiStatus *pstatus);
void smtSPISetIntDMA(SpiChannel channel, SpiIntDma *pspiInterruptDMA);
void smtSPIGetIntDMA(SpiChannel channel, SpiIntDma *pspiInterruptDMA);
void smtSPIGetIntStatus(SpiChannel channel, SpiIntStatus *pintStatus);
void smtSPIClrIntStatus(SpiChannel channel, SpiIntStatus intStatus);
void smtSPIWrite(SpiChannel channel, smtUint8 data);
void smtSPIRead(SpiChannel channel, smtUint8 *pdata);
void smtSPIInit(SpiChannel channel, smtUint32 PreVal, smtUint32 DivVal);

#endif 
