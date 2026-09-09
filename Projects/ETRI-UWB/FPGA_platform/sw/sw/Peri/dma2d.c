/*----------------------------------------------------------
	File Name   : dmac.c 
	Description : DMA controller API code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "Commonmacro.h"
#include "dma2d.h"
#include "gpio.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void DMA2DCopy(dma2d_t *source, dma2d_t *dest);
/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
void DMA2DCopy(dma2d_t *source, dma2d_t *dest)
{
	smtUint32 status;

	if(source->Xsize == 0)		// Not possible
		return;

	SMT_WRITE(DMA2D_SRCADDR, (unsigned)(source->Addr));
	SMT_WRITE(DMA2D_DSTADDR, (unsigned)(dest->Addr));
	SMT_WRITE(DMA2D_SIZE, (unsigned)(source->Xsize));
	SMT_WRITE(DMA2D_CNT, ((source->Ysize)<<16) | (source->Xsize));
	SMT_WRITE(DMA2D_ADDRUPD, ((source->Stride)<<16) | (dest->Stride & 0x0000ffff));

	SMT_WRITE(DMA2D_STATUS, (1<<31)	// enable 
					| (1<<4)		// StopIntEn == 1
					| (1<<1)		// Clear StopInt
					| (1<<0));		// Clear Error Int
	while(1)
	{
		status =SMT_READ(DMA2D_STATUS);
		if(status & 0x00000003)
			break;
	}

	if(status & 0x00000001)		// Error Interrupt
	{
		GPIOWrite(0xdead);
		while(1) ;
	}

	SMT_WRITE(DMA2D_STATUS, 0);		// disable 
}

