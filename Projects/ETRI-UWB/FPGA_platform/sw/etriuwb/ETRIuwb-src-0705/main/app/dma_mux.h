/*----------------------------------------------------------
	File Name   : dma_mux.h
	Description : DMA MUX header file
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __DMA_MUX_H_
#define __DMA_MUX_H_

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

// DMA device assigned number
#define DMA_NAND	0
#define DMA_SEIPTX	1
#define DMA_SEIPRX	2
#define DMA_I2STX	3
#define DMA_I2SRX	4
#define DMA_SPITX	5
#define DMA_SPIRX	6
#define DMA_UART0TX	7
#define DMA_UART0RX	8
#define DMA_UART1TX	9
#define DMA_UART1RX	10

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
int DMAChannelAlloc(smtUint16 dma_device);
void DMAChannelFree(smtInt32 channelNo);
#endif  /* __IRQ_H__ */
