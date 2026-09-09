/*----------------------------------------------------------
	File Name   : dmac.c 
	Description : DMA controller API code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "Commonmacro.h"
#include "dmac_internal.h"
#include "dmac.h"
#include "gpio.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void DMACEnable(smtUint8 channel);
void DMACDisable(smtUint8 channel);
void DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth, smtUint32 DestAddr,  smtBoolean DstIncrease, smtUint8 DWidth, smtUint8 TransSize, smtUint16 TotalSize);
void DMACUseDescrp(smtUint8 channel, smtUint32 FirstDescAddr);
void DMACMemCopy(smtUint8 channel, unsigned char *dest, unsigned char *src, unsigned nbytes);
/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name   : DMACEnable()
    Prototype       : void DMACEnable(smtUint8 channel)
    Return          : 
    Argument        :
    Comments        : Enable DMA 
-----------------------------------------------------------------------*/
void DMACEnable(smtUint8 channel)
{
	SMT_WRITE(DMACSta(channel), (SMT_READ(DMACSta(channel))|Enable)); // DMAC Enable
}
/*-----------------------------------------------------------------------
    Function name   : DMACDisable()
    Prototype       : void DMACDisable(smtUint8 channel)
    Return          : 
    Argument        :
    Comments        : Disable DMA Channel
-----------------------------------------------------------------------*/
void DMACDisable(smtUint8 channel)
{
	SMT_WRITE(DMACSta(channel), (SMT_READ(DMACSta(channel))&(!Enable&0xFFFFFFFF))); // DMAC Disable
	while ((SMT_READ(DMACSta(channel))&Active) == Active);// polling Active bit => 0
}
/*-----------------------------------------------------------------------
    Function name   : DMACNoDescrp()
    Prototype       : void DMACNoDescrp(smtUint8 channel, smtUint32 SourceAddr, smtUint32 DestAddr, smtUint16 TSize)
    Return          : 
    Argument        :
    Comments        : DMA Don't Use Descriptor
-----------------------------------------------------------------------*/

void DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth,
	      	smtUint32 DestAddr,  smtBoolean DstIncrease, smtUint8 DWidth, smtUint8 TransSize, smtUint16 TotalSize)
{
	SMT_WRITE (DMACSAdr(channel), SrcAddr); // assign Source address
	SMT_WRITE (DMACDAdr(channel), DestAddr); // assign Destination address
	SMT_WRITE (DMACCon (channel), ((SrcIncrease&0x01)<<28)|((SWidth&0x03)<<26)|((DstIncrease&0x01)<<25)|((DWidth&0x03)<<23)|((TransSize&0x07)<<20)|(TotalSize&TransferLength)); // Control register setting
	SMT_WRITE (DMACDescrp(channel), DescrEnd);
	SMT_WRITE (DMACSta(channel), Enable|ErrorInt|StopInt);
}

/*-----------------------------------------------------------------------
    Function name   : DMADescrp()
    Prototype       : void DMACUseDescrp(smtUint8 channel, smtBoolean mem2mem)
    Return          : 
    Argument        :
    Comments        : DMA Use Descriptor
-----------------------------------------------------------------------*/
void DMACUseDescrp(smtUint8 channel, smtUint32 FirstDescAddr)
{
	unsigned *desc = (unsigned *)FirstDescAddr;
	SMT_WRITE(DMACDescrp(channel),FirstDescAddr); // Memory to Memory
	SMT_WRITE(DMACCon(channel), (((desc[2])>>16)&0x0000000f)<<20);	// DMA Bug for Size registering
	SMT_WRITE(DMACSta(channel), Enable);
}

void DMACMemCopy(smtUint8 channel, unsigned char *dest, unsigned char *src, unsigned nbytes)
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
		if(nbytes > (1024*1024-4))
			transferLen = 1024*1024-4;
		else
			transferLen = nbytes;
		SMT_WRITE(DMACSAdr(channel), (unsigned)src);
		SMT_WRITE(DMACDAdr(channel), (unsigned)dest);
		SMT_WRITE(DMACCon(channel), (m2m<<29)|(Width<<26)|(srcIncr<<28)|(destIncr<<25)|(Width<<23)|(size<<20)|transferLen);
		SMT_WRITE(DMACDescrp(channel), 1);
		SMT_WRITE(DMACSta(channel), 0x8000001F);

		while(1)
		{
			if(SMT_READ(DMACSta(channel)) & 0x00000009)	// Stop/Error Interrupt Check
				break;
		}

		if(SMT_READ(DMACSta(channel)) & 0x00000001)	// Error Interrupt
		{
			GPIOWrite(0xdead);
			while(1) ;
		}
		nbytes -= transferLen;
	}
}

