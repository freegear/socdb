/*----------------------------------------------------------
	File Name   : apidmac.c 
	Description : DMA controller test code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "dmac.h"
#include "global.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */




/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void DMCCEnable(smtUint8 channel);
void DMCCDisable(smtUint8 channel);
void DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtUint32 DestAddr, smtUint16 TransSize, smtUint8 Width,smtBoolean SrcIncrease, smtBoolean DstIncrease);
void DMACUseDescrp(smtUint8 channel, smtBoolean mem2mem);
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
	SMT_WRITE(DMACSta(channel), (SMT_READ(DMACSta(channel))&(!Enable&0xFFFFFFFF))); // DMAC Enable
	while ((SMT_READ(DMACSta(channel))&Active) == Active);// polling Active bit => 0
}
/*-----------------------------------------------------------------------
    Function name   : DMACNoDescrp()
    Prototype       : void DMACNoDescrp(smtUint8 channel, smtUint32 SourceAddr, smtUint32 DestAddr, smtUint16 TSize)
    Return          : 
    Argument        :
    Comments        : DMA Not Use Descriptor
-----------------------------------------------------------------------*/

void DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtUint32 DestAddr, smtUint16 TransSize, smtUint8 Width,smtBoolean SrcIncrease, smtBoolean DstIncrease)
{
	SMT_WRITE (DMACSAdr(channel), SrcAddr); // assign Source address
	SMT_WRITE (DMACDAdr(channel), DestAddr); // assign Destination address
	SMT_WRITE (DMACCon (channel), ((Width&(0x03))<<20)|((SrcIncrease&0x01)<<26)|((DstIncrease&0x01)<<22)|(TransSize&TransferLength)); // Control register setting
	SMT_WRITE (DMACDescrp(channel), DescrEnd);
	SMT_WRITE (DMACSta(channel), Enable);
}

/*-----------------------------------------------------------------------
    Function name   : DMADescrp()
    Prototype       : void DMACUseDescrp(smtUint8 channel, smtBoolean mem2mem)
    Return          : 
    Argument        :
    Comments        : DMA Use Descriptor
-----------------------------------------------------------------------*/
void DMACUseDescrp(smtUint8 channel, smtBoolean mem2mem)
{

	SMT_WRITE (DMACCon(channel),(0x00)&TransferLength); // Control register setting
	if (mem2mem)
	{SMT_WRITE(DMACDescrp(channel),M2M); // Memory to Memory
	}
	SMT_WRITE (DMACSta(channel), Enable);

}



