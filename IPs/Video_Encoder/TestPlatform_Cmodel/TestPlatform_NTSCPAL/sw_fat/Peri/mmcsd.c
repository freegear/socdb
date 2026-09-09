/*----------------------------------------------------------
	File Name   : mmcsd.c 
	Description : MMCSD test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "mmcsd.h"
#include "global.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

smtUint32 MMCSDTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

//static volatile int interruptWaiting;
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
#define	MMCSD_BASE
#define SDICON             	(*(volatile unsigned *)(MMCSD_BASE+0x00000000))
#define SDIPRE              	(*(volatile unsigned *)(MMCSD_BASE+0x00000004))
#define SDICmdArg		(*(volatile unsigned *)(MMCSD_BASE+0x00000008))
#define SDICmdCon              	(*(volatile unsigned *)(MMCSD_BASE+0x0000000C))
#define SDICmdSta           	(*(volatile unsigned *)(MMCSD_BASE+0x00000010))
#define SDIRSP0	       		(*(volatile unsigned *)(MMCSD_BASE+0x00000014))
#define SDIRSP1	        	(*(volatile unsigned *)(MMCSD_BASE+0x00000018))
#define SDIRSP2	        	(*(volatile unsigned *)(MMCSD_BASE+0x0000001C))
#define SDIRSP3	        	(*(volatile unsigned *)(MMCSD_BASE+0x00000020))
#define SDIDTimer        	(*(volatile unsigned *)(MMCSD_BASE+0x00000024))
#define SDIBSize        	(*(volatile unsigned *)(MMCSD_BASE+0x00000028))
#define SDIDatCon        	(*(volatile unsigned *)(MMCSD_BASE+0x0000002C))
#define SDIDatSta        	(*(volatile unsigned *)(MMCSD_BASE+0x00000030))
#define SDIFSTA	        	(*(volatile unsigned *)(MMCSD_BASE+0x00000034))
#define SDIIntMsk        	(*(volatile unsigned *)(MMCSD_BASE+0x00000038))
#define SDIIDAT	        	(*(volatile unsigned *)(MMCSD_BASE+0x0000003C)

// SDICON register
#define	SDreset			(0x1Ul)<<8 
#define	CTYP			(0x1Ul)<<5 
#define	ByteOrder		(0x1Ul)<<4
#define RcvIOInt		(0x1Ul)<<3
#define	RWaitEn			(0x1Ul)<<2		
#define ENCLK			(0x1Ul)<<0
// SDIPRE register
#define	SDIPRE			(0xfUl)<<0

// SDICmdArg
#define	CmdArg			(0xffffUl)<<0

// SDICmdCon
#define	BusyRsp			(0x1Ul)<<14
#define	NoCRCRsp		(0x1Ul)<<13
#define	AbortCmd		(0x1Ul)<<12
#define WithData		(0x1Ul)<<11
#define LongRsp			(0x1Ul)<<10
#define	WaitRsp			(0x1Ul)<<9
#define	CMST			(0x1Ul)<<8
#define	CmdIndex		(0xffUl)<<0

#define	RspCrc			(0x1Ul)<<12
#define	CmdSent			(0x1Ul)<<11
#define	CmdTout			(0x1Ul)<<10
#define RspFin			(0x1Ul)<<9
#define	CmdOn			(0x1Ul)<<8
#define	RspIndex		(0x1Ul)<<0

#define	Response0		(0xffffUl)<<0
#define	Response1		(0xffffUl)<<0
#define	Response2		(0xffffUl)<<0
#define	Response3		(0xffffUl)<<0

//SDIDTimer Register
#define	DataTimer		(0x1Ul)<<0

//SDIBSize Register
#define BlkSize			(0xfffUl)<<0

//SDIDatCon
#define	DMASize			(0x1Ul)<<26
#define	MMCPlus			(0x1Ul)<<25
#define	Burst4			(0x1Ul)<<24
#define	DataSize		(0x2Ul)<<22
#define	PrdType			(0x1Ul)<<21
#define	TARSP			(0x1Ul)<<20
#define	RACMD			(0x1Ul)<<19
#define	BACMD			(0x1Ul)<<18
#define	BlkMode			(0x1Ul)<<17
#define	WideBus			(0x1Ul)<<16
#define	EnDMA			(0x1Ul)<<15
#define	DTST			(0x1Ul)<<14
#define	DatMode			(0x2Ul)<<12
#define	BlkNum			(0xfffUl)<<0

//SDIDatCnt register
#define	BlkNumCnt		(0xfffUl)<<12
#define	BlkCnt			(0xfffUl)<<0

//SDIDatSta
#define	NoBusy			(0x1Ul)<<11
#define	RWaitReq		(0x1Ul)<<10
#define	IOIntDet		(0x1Ul)<<9
#define	CrcSta			(0x1Ul)<<7
#define	DatCrc			(0x1Ul)<<6
#define	DatTout			(0x1Ul)<<5
#define	DatFin			(0x1Ul)<<4
#define	BusyFin			(0x1Ul)<<3
#define TxDatOn			(0x1Ul)<<1
#define	RxDatOn			(0x1Ul)<<0

//SDIFSTA register
#define	FRST			(0x1Ul)<<16
#define	FFfail			(0x2Ul)<<14
#define	TFDET			(0x1Ul)<<13
#define	TFHalf			(0x1Ul)<<12
#define	TFEmpty			(0x1Ul)<<11
#define	RFDET			(0x1Ul)<<8
#define	RFHalf			(0x1Ul)<<7
#define	FFCNT			(0x3fUl)<<0

//SDIIntMsk register
#define	NoBusyInt		(0x1Ul)<<18
#define	RspCrcInt		(0x1Ul)<<17
#define	CmdSentInt		(0x1Ul)<<16
#define	CmdToutInt		(0x1Ul)<<15
#define	RspEndInt		(0x1Ul)<<14
#define	RWReqInt		(0x1Ul)<<13
#define	IntDetInt		(0x1Ul)<<12
#define	FFfailInt		(0x1Ul)<<11
#define	CrcStaInt		(0x1Ul)<<10
#define	DatCrcInt		(0x1Ul)<<9
#define	DatToutInt		(0x1Ul)<<8
#define	DatFinInt		(0x1Ul)<<7
#define	BusyFinInt		(0x1Ul)<<6
#define	TFHalfInt		(0x1Ul)<<4
#define	TFEmptyInt		(0x1Ul)<<3
#define	RFLastInt		(0x1Ul)<<2
#define	RFFullInt		(0x1Ul)<<1
#define	RFHalfInt		(0x1Ul)<<0	

/*-----------------------------------------------------------------------
    Function name   : MMCSDTest()
    Prototype       : smtUint32 MMCSDTest(void)
    Return          : error code
    Argument        :
    Comments        : Return a error-code

-----------------------------------------------------------------------*/
smtUint32 MMCSDTest(int CardType)
{
	MMCInitialize();
	MMCWriteSingle();

	MMCReadSingle();

	MMCWriteMultiple();

	MMCReadMultiple();
	if (CardType==SD)
	{
		SDEraseBlock();
	}
	else
	{
		MMCEraseBlock();
	}
	MMCReadMultiple();
}

/*-----------------------------------------------------------------------
    Function name   : MMCSDInitialize()
    Prototype       : smtUint32 MMCSDInitialize(void)
    Return          : error code
    Argument        :
    Comments        : Return a error-code

-----------------------------------------------------------------------*/
smtUint32 MMCInitialize(void)
{
	//Prescaler setting 
	SMT_WRITE(SDIPRE, 0x10);
	//Clock Enable
	SMT_WRITE(SDICON, 0x01);
	//Interrupt Enable
	SMT_WRITE(SDIIntMsk,);


	//CMD0 (GO_IDLE_STATE)
	SMT_WRITE(SDICmdArg, 0x00); 
	SMT_WRITE(SDICmdCon, BusyRsp|CMST|0x40);
  	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	
	//------------ACMD41------------
	//CMD55
	SMT_WRITE(SDICmdArg, 0x00000000); 
	SMT_WRITE(SDICmdCon, CMST|WaitRsp|0x77);
  	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD41
	SMT_WRITE(SDICmdArg, 0x00000000); 
	SMT_WRITE(SDICmdCon, CMST|WaitRsp|0x69);
  	//Command Sent Check
	SMT_READ(SDICmdSta);
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit


	//---------ACMD41에 응답이 없으면 CMD1---------------
	//CMD1
	SMT_WRITE(SDICmdArg,0x00000000);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|NoCRCRsp|0x41);//R3 type response
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD2
	SMT_WRITE(SDICmdArg,0x00000000);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|LongRsp|0x42);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit
	
	//CMD3
	SMT_WRITE(SDICmdArg,0x00000000);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x43);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD7
	SMT_WRITE(SDICmdArg,0x00);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x47);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD6(SWITCH) select bus width
	SMT_WRITE(SDICmdArg,0x00);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|BusyRsp|0x46);
	//Command Sent Check 
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD16(Set Block length)
	SMT_WRITE(SDICmdArg,0x01ff);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x50);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit
}
/*-----------------------------------------------------------------------
    Function name   : MMCReadSingle()
    Prototype       : smtUint32 MMCReadSingle(void)
    Return          : 
    Argument        :
    Comments        :  MMC Single Block Read function
-----------------------------------------------------------------------*/
smtUint32 MMCReadSingle(int BlockAddess)
{
	//CMD17(READ_SINGLE_BLOCK)	
	SMT_WRITE(SDICmdArg, BlockAddess);	
	SMT_WRITE(SDICmdCon, CMST|WaitRsp|0x51);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

}
/*-----------------------------------------------------------------------
    Function name   : MMCWriteSingle()
    Prototype       : smtUint32 MMCWriteSingle(void)
    Return          : 
    Argument        :
    Comments        :  MMC Single Block Write function
-----------------------------------------------------------------------*/
smtUint32 MMCWriteSingle(int BlockAddress)
{
	//CMD24(WRITE_BLOCK)
	SMT_WRITE(SDICmdArg, BlockAddress);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x58);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit
}
/*-----------------------------------------------------------------------
    Function name   : MMCReadMultiple()
    Prototype       : static void MMCSDIsr(smtUint32 IRQ)
    Return          : 
    Argument        :
    Comments        :  MMC Multiple Block Read function
-----------------------------------------------------------------------*/
smtUint32 MMCReadMultiple(int BlockCount, int BlockSize, int BlockAddress)
{
	//CMD23(SET_BLOCK_COUNT)
	SMT_WRITE(SDICmdArg,0x00);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x57);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD18(READ_MULTIPLE_BLOCK)
	SMT_WRITE(SDICmdArg, BlockAddress);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x52);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit
}
/*-----------------------------------------------------------------------
    Function name   : MMCWriteMultiple()
    Prototype       : smtUint32 MMCWriteMultiple(int BlockCount, int BlockSize)
    Return          : 
    Argument        :
    Comments        :  MMC Multiple Block Write Function
-----------------------------------------------------------------------*/
smtUint32 MMCWriteMultiple(int BlockCount, int BlockSize, int BlockAddress)
{
	//CMD23(SET_BLOCK_COUNT)
	SMT_WRITE(SDICmdArg,0x00);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x57);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD25(WRITE_MULTIPLE_BLOCK)
	SMT_WRITE(SDICmdArg, BlockAddess);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x59);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit
}
/*-----------------------------------------------------------------------
    Function name   : MMCEraseBlock()
    Prototype       : smtUint32 MMCEraseBlock(int StartBlock, int EndBlock)
    Return          : 
    Argument        :
    Comments        :  MMC Erase Block Function
-----------------------------------------------------------------------*/
smtUint32 MMCEraseBlock(int StartBlock, int EndBlock)
{
	//CMD35(ERASE_GROUP_START)
	SMT_WRITE(SDICmdArg,StartBlock);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x63);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD36(ERASE_GROUP_END)
	SMT_WRITE(SDICmdArg,EndBlock);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x64);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit
	
	//CMD38(ERASE)
	SMT_WRITE(SDICmdArg,0x00);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|BusyRsp|0x66);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit
}
/*-----------------------------------------------------------------------
    Function name   : SDEraseBlock()
    Prototype       : smtUint32 SDEraseBlock(int StartBlock, int EndBlock)
    Return          : 
    Argument        :
    Comments        : SD Erase Block Function
-----------------------------------------------------------------------*/
smtUint32 SDEraseBlock(int StartBlock, int EndBlock)
{
	//CMD32(ERASE_WR_BLOCK_START)
	SMT_WRITE(SDICmdArg,StartBlock);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x60);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD33(ERASE_WR_BLOCK_END)
	SMT_WRITE(SDICmdArg, EndBlock);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|0x61);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit

	//CMD38(ERASE)
	SMT_WRITE(SDICmdArg,0x00);
	SMT_WRITE(SDICmdCon,CMST|WaitRsp|BusyRsp|0x66);
	//Command Sent Check
	while(SMT_READ(SDICmdSta));
	SMT_WRITE(SDICmdSta,); // Clear CmdSent bit
}
/*-----------------------------------------------------------------------
    Function name   : MMCSDIsr()
    Prototype       : static void MMCSDIsr(smtUint32 IRQ)
    Return          : 
    Argument        :
    Comments        :  MMC interrupt handle function
-----------------------------------------------------------------------*/
static void MMCSDIsr(smtUint32 IRQ)
{
    smtMMC_SDsmtHandler();
}


