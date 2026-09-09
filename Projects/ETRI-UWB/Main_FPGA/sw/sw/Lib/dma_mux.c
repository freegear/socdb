/*----------------------------------------------------------
	File Name   : dma_ch.c 
	Description : DMA Channel muxing module
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
#define NUMBER_OF_DMA_CHANNEL	8
typedef struct dma_channel_alloctator_entry_ 
{
	smtUint16 dma_device;
	smtUint16 free;
} dma_channel_allocator_entry; 

static dma_channel_allocator_entry dma_channel_allocator[NUMBER_OF_DMA_CHANNEL] = {
	{ 0, 1 },
	{ 1, 1 },
	{ 2, 1 },
	{ 3, 1 },
	{ 4, 1 },
	{ 5, 1 },
	{ 6, 1 },
	{ 7, 1 }
};

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : DMAChannelAlloc(smtUint16 dma_device)
    Prototype       : int DMAChannelAlloc(smtUint16 dma_device)
    Return          : -1 when no available channel
                      DMA channel number for your device.
	Argument        : dma_device -> predefined number of each device
    Comments        : ResourceShare setting(I think this routine should be exeucted with IRQ off, but ...)
-----------------------------------------------------------------------*/
int DMAChannelAlloc(smtUint16 dma_device)
{
	smtUint32 data;
	int i;

	// Check if allready allocated channel exists
	for(i = 0; i < NUMBER_OF_DMA_CHANNEL; i++)
	{
		if(dma_channel_allocator[i].dma_device == dma_device
			&& dma_channel_allocator[i].free == 0)
			return i;
	}

	// Check if previously allocated channel exists
	for(i = 0; i < NUMBER_OF_DMA_CHANNEL; i++)
	{
		if(dma_channel_allocator[i].dma_device == dma_device)
		{
			dma_channel_allocator[i].free = 0;
			return i;
		}
	}

	// Search free available channel
	for(i = 0; i < NUMBER_OF_DMA_CHANNEL; i++)
	{
		if(dma_channel_allocator[i].free == 1)
		{
			dma_channel_allocator[i].dma_device = dma_device;
			dma_channel_allocator[i].free = 0;
			data = SMT_READ(RS_DMAMUX);
			data &= ~(0x000000f<<(i*4));
			data |= (dma_device & 0x000f)<<(i*4);
			SMT_WRITE(RS_DMAMUX, data);

			return i;
		}
	}

	// No available channel exists
	return -1;
}

/*-----------------------------------------------------------------------
    Function name   : DMAChannelFree(smtInt32 channelNo)
    Prototype       : void DMAChannelFree(smtInt32 channelNo)
    Return          : void
	Argument        : channelNo => return value of DMAChannelAlloc()
    Comments        : 
-----------------------------------------------------------------------*/
void DMAChannelFree(smtInt32 channelNo)
{
	if(channelNo < 0 || channelNo >= NUMBER_OF_DMA_CHANNEL)
		return;

	dma_channel_allocator[channelNo].free = 1;
}
