/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: uart_pre_drv.c 
	Description	: SD/MMC test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "uart_pre_drv.h"
/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARE
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: smtUARTSetCmd
	Prototype		: void smtUARTSetCmd(UartChannel uartCh, UartMaster *pUartCmd)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTSetCmd(UartChannel uartCh, UartMaster *pUartCmd)
{
	SMT_WRITE(UARTXMASTER(uartCh),
		 ((pUartCmd->uartEn			& 0x1 )	<< 31)\
		|((pUartCmd->intEn	 		& 0x1 )	<< 30)\
		|((pUartCmd->rxTimeoutEn	& 0x1 )	<< 29)\
		|((pUartCmd->swReset		& 0x1 )	<< 28)\
		|((pUartCmd->dmaReqEn		& 0x1 )	<< 27)\
		|((pUartCmd->parity			& 0x3 )	<< 25)\
		|((pUartCmd->dataBit		& 0x1 )	<< 24)\
		|((pUartCmd->stopBit		& 0x1 )	<< 23)\
		|((pUartCmd->loopbackEn		& 0x1 )	<< 22)\
		|((pUartCmd->txIntEn		& 0x1 )	<< 15)\
		|((pUartCmd->txWaterLev		& 0x3F)	<<  8)\
		|((pUartCmd->rxIntEn		& 0x1 )	<<  7)\
		|((pUartCmd->rxWaterLev		& 0x3F)	<<  0)\
	);
}

/*----------------------------------------------------------
	Function name	: smtUARTGetCmd
	Prototype		: void smtUARTGetCmd(UartChannel uartCh, UartMaster *pUartCmd)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTGetCmd(UartChannel uartCh, UartMaster *pUartCmd)
{
	smtUint32 regData;
	regData = SMT_READ(UARTXMASTER(uartCh));

	pUartCmd->uartEn			= ((regData >> 31) & 0x1 );
	pUartCmd->intEn				= ((regData >> 30) & 0x1 );
	pUartCmd->rxTimeoutEn		= ((regData >> 29) & 0x1 );
	pUartCmd->swReset			= 0;//((regData >> 28) & 0x1 );
	pUartCmd->dmaReqEn			= ((regData >> 27) & 0x1 );
	pUartCmd->parity			= ((regData >> 25) & 0x3 );
	pUartCmd->dataBit			= ((regData >> 24) & 0x1 );
	pUartCmd->stopBit			= ((regData >> 23) & 0x1 );
	pUartCmd->loopbackEn		= ((regData >> 22) & 0x1 );
	pUartCmd->txIntEn			= ((regData >> 15) & 0x1 );
	pUartCmd->txWaterLev		= ((regData >>  8) & 0x3F);
	pUartCmd->rxIntEn			= ((regData >>  7) & 0x1 );
	pUartCmd->rxWaterLev		= ((regData >>  0) & 0x3F);
}

/*----------------------------------------------------------
	Function name	: smtUARTSetStatus
	Prototype		: void smtUARTSetStatus(UartChannel uartCh, UartStatus *pUartSts)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTSetStatus(UartChannel uartCh, UartStatus *pUartSts)
{
	SMT_WRITE(UARTXSTATUS(uartCh),
		(((pUartSts->parityErr	& 0x1) << 25)
		|((pUartSts->frameErr	& 0x1) << 24)
		|((pUartSts->overrunErr	& 0x1) << 23)
		)
	);
}

/*----------------------------------------------------------
	Function name	: smtUARTGetStatus
	Prototype		: void smtUARTGetStatus(UartChannel uartCh, UartStatus *pUartSts)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTGetStatus(UartChannel uartCh, UartStatus *pUartSts)
{
	smtUint32 regData;
	regData = SMT_READ(UARTXSTATUS(uartCh));

	pUartSts->interrupt		= ((regData >> 31) & 0x1 );
	pUartSts->maxFifoDepth	= ((regData >> 28) & 0x7 );
	pUartSts->txBusy		= ((regData >> 27) & 0x1 );
	pUartSts->rxBusy		= ((regData >> 26) & 0x1 );
	pUartSts->parityErr		= ((regData >> 25) & 0x1 );
	pUartSts->frameErr		= ((regData >> 24) & 0x1 );
	pUartSts->overrunErr	= ((regData >> 23) & 0x1 );
	pUartSts->rxTimeout		= ((regData >> 22) & 0x1 );
	pUartSts->txFifoInt		= ((regData >> 15) & 0x1 );
	pUartSts->txFifoDMAReq	= ((regData >> 14) & 0x1 );
	pUartSts->txFifoCnt		= ((regData >>  8) & 0x3F);
	pUartSts->rxFifoInt		= ((regData >>  7) & 0x1 );
	pUartSts->rxFifoDMAReq	= ((regData >>  6) & 0x1 );
	pUartSts->rxFifoCnt		= ((regData >>  0) & 0x3F);
	
}

/*----------------------------------------------------------
	Function name	: smtUARTSetBaud
	Prototype		: void smtUARTGetStatus(UartChannel uartCh, UartStatus *pUartSts)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTSetBaud(UartChannel uartCh, smtUint16 baudGen)
{
	SMT_WRITE(UARTXBRD(uartCh),(baudGen & 0xFFFF));
}

/*----------------------------------------------------------
	Function name	: smtUARTGetBaud
	Prototype		: void smtUARTGetBaud(UartChannel uartCh, smtUint16 *pBaudGen)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTGetBaud(UartChannel uartCh, smtUint16 *pBaudGen)
{
	*pBaudGen = (smtUint16)(SMT_READ(UARTXBRD(uartCh)) & 0xFFFF);
}

/*----------------------------------------------------------
	Function name	: smtUARTSetTxFifo
	Prototype		: void smtUARTSetTxFifo(UartChannel uartCh, smtUint8 txData)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTSetTxFifo(UartChannel uartCh, smtUint8 txData)
{
	SMT_WRITE(UARTXTXFIFO(uartCh),(txData&0xFF));
}

/*----------------------------------------------------------
	Function name	: smtUARTGetRxFifo
	Prototype		: void smtUARTGetRxFifo(UartChannel uartCh, smtUint8 *pRxData)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTGetRxFifo(UartChannel uartCh, smtUint8 *pRxData)
{
	*pRxData = (smtUint8)((SMT_READ(UARTXRXFIFO(uartCh))) & 0xFF);
}

/*----------------------------------------------------------
	Function name	: smtUARTSetRxTO
	Prototype		: void smtUARTSetRxTO(UartChannel uartCh, smtUint32 rxTOCnt)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTSetRxTO(UartChannel uartCh, smtUint32 rxTOCnt)
{
	SMT_WRITE(UARTXRXTO(uartCh),
		(rxTOCnt & 0xFFFFF)
		);
}

/*----------------------------------------------------------
	Function name	: smtUARTGetRxTO
	Prototype		: void smtUARTGetRxTO(UartChannel uartCh, smtUint32 *pRxTOCnt)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtUARTGetRxTO(UartChannel uartCh, smtUint32 *pRxTOCnt)
{
	*pRxTOCnt = (SMT_READ(UARTXRXTO(uartCh))) & 0xFFFFF;
}