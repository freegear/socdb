/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: nand.c 
	Description	: NAND test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "global.h"
#include "nand_pre_drv.h"
#include "micro_ecc.h"
//#include "dmac.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define CC_PAGEWRCMD0  					(0x80)
#define CC_PAGEWRCMD1  					(0x10)
#define	CC_PAGERWRDCMD0					(0x00)
#define	CC_PAGERWRDCMD1					(0x00)
#define CC_PAGERDCMD0  					(0x00)
#define CC_PAGERDCMD1  					(0x30)
#define	CC_PAGERRRDCMD0					(0x00)
#define	CC_PAGERRRDCMD1					(0x00)
#define CC_RDIDCMD     					(0x90)
#define CC_RDSTATCMD   					(0x70)
#define CC_RESETCMD    					(0xff)
#define CC_BERASECMD0  					(0x60)
#define CC_BERASECMD1  					(0xd0)

#define CS_PAGEWRCMD  					(0x80)
#define	CS_PAGERWRDCMD					(0x00)
#define CS_PAGERDCMD  					(0x00)
#define	CS_PAGERRDCMD					(0x00)
#define CS_RDIDCMD     					(0x02)
#define CS_RDSTATCMD   					(0x70)
#define CS_RESETCMD    					(0x02)
#define CS_BERASECMD  					(0xd0)

#define DS_RDIDCMD		     			(0x05)
#define DS_RESETCMD			   			(0x00)
#define DS_BERASECMD					(0x00)
#define DS_RDSTATCMD		   			(0x00)
#define DS_PAGEWRCMD					(0x00)	// don't use
#define DS_PAGERDCMD		  			(0x00)	// don't use


#define	OPCFG_TS_BYTE					(0x00)
#define	OPCFG_TS_HWORD					(0x00)
#define	OPCFG_TS_WORD					(0x00)

// chipsel
#define	OPCFG_CS_SEL					(0x00)
#define	OPCFG_CS_UNSEL					(0x01)

// operation
#define OPCFG_OPR_READDATA    			(0x00)
#define OPCFG_OPR_READSTATUS 			(0x01)
#define OPCFG_OPR_READID      			(0x02)
#define OPCFG_OPR_WRITEDATA   			(0x03)
#define OPCFG_OPR_NOP         			(0x07)

// option
#define OPCFG_OPT_RNBWAIT     			(0x01)
#define OPCFG_OPT_AUTORDSTAT  			(0x02)
#define OPCFG_OPT_CONTINUE    			(0x03)
#define OPCFG_OPT_NOP					(0x00)

// flag
#define	OPCFG_FLG_ADDRESS				(0x00)
#define	OPCFG_FLG_COMMAND				(0x01)

// config
#define	NANDT_CFG_NANDBOOTEN			(0x00)
#define	NANDT_CFG_IOWIDTH				(0x00)
#define	NANDT_CFG_NANDWITH				(0x00)
#define	NANDT_CFG_BOOTCFG				(0x00)
#define	NANDT_CFG_OUTDTMN				(0x00)
#define	NANDT_CFG_TADLTWB				(0x0F)
#define	NANDT_CFG_TACLS					((0x2UL)<<9)
#define	NANDT_CFG_TRWLP					((0x2UL)<<9)
#define	NANDT_CFG_TRWHP					((0x2UL)<<9)

#define	NANDT_DMA_CH					(0x0)
#define	NANDT_DMA_NAND_BIT_WIDTH		(0x0)
#define	NANDT_DMA_MEM_BIT_WIDTH			(0x0)
#define	NANDT_DMA_BURST_WIDTH			(0x0)
#define	NANDT_PERI_ADDR					NANDDATA

// 

#define	ADDRESS0(c)						((c) & 0xFF)
#define	ADDRESS1(c)                 	(((c) >> 8) & 0xF)
#define	ADDRESS2(p, b)                 	(((p) & 0x3F) | ((b) & 0x3))
#define	ADDRESS3(b)                 	(((b) >> 2) & 0xFF)	
#define	ADDRESS4(b)                 	(((b) >> 10) & 0xFF)

// Edit your code

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 NANDTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
volatile int sRWEnd;


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: InterruptHandler()
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void EventHandler(int irq) 
{
	
}

/*----------------------------------------------------------
	Function name	: NandInit()
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void NandInit(void)
{
	NAND_CFG	nandCfg;
	
	// init nand controller
	nandCfg.nandBootEn	= NANDT_CFG_NANDBOOTEN;
	nandCfg.IOWidth		= NANDT_CFG_IOWIDTH;
	nandCfg.NandWidth	= NANDT_CFG_NANDWITH;
	nandCfg.bootCfg		= NANDT_CFG_BOOTCFG;
	nandCfg.OutDtmn		= NANDT_CFG_OUTDTMN;
	nandCfg.TADLTWB		= NANDT_CFG_TADLTWB;
	nandCfg.TCALS		= NANDT_CFG_TACLS;
	nandCfg.TRWLP		= NANDT_CFG_TRWLP;
	nandCfg.TRWHP		= NANDT_CFG_TRWHP;
	smtNANDSetCfg(&nandCfg);	
}


/*----------------------------------------------------------
	Function name	: ReadID()
	Prototype		: smtUint32 ReadID(smtUint32 id[5])
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 ReadID(smtUint32 id[5])
{

    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr;
    NAND_STAT	nandStatus;
    
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= DS_RDIDCMD;
    nandOpConfig.opMode				= OPCFG_OPR_READID;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_RDIDCMD;
    nandOpConfig.cmdAddrFlag		= OPCFG_FLG_COMMAND;
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command
    nandCmdAddr.CMDADDR[0]			= CC_RDIDCMD;
    nandCmdAddr.CMDADDR[1]			= 0x00;
    smtNANDSetOPT1(&nandCmdAddr);
    
    // check ID valid
    while(true) 
    {
    	smtNANDGetStatus(&nandStatus);
    	if(nandStatus.NFIDValid) break;
    }
    
    // get NAND ID code data
    smtNANDGetData(&id[0]);
    smtNANDGetData(&id[1]);
    smtNANDGetData(&id[2]);
    smtNANDGetData(&id[3]);
    smtNANDGetData(&id[4]);
    
  
    return 1;
   
}
/*-----------------------------------------------------------------------
    Function name   : Read
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
smtBoolean Read(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 sizeInByte)
{
    
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint8	addr0, addr1, addr2, addr3, addr4;
    smtUint32	wi, *ptrg;
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_PAGERDCMD;						// 7 byte
    nandOpConfig.cmdAddrFlag		= OPCFG_FLG_COMMAND;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGERDCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGERDCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
    
   	ptrg = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/32; wi++)
    {
        //read FIFO ready check
    	while(true)
    	{
    		smtNANDGetStatus(&nandStatus);
    		if(nandStatus.rdFIFOReady) break;
    	}
        smtNANDGetData(ptrg++);
    }    
    
    return 0;
}
/*-----------------------------------------------------------------------
    Function name   : RandomDataOutput
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
smtBoolean RandomDataOutput(smtUint16 colAddr, 
	smtUint32 ppagebuf, smtUint32 sizeInByte)
{
    
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint32	wi, *ptrg;
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_PAGERRDCMD;		
    nandOpConfig.cmdAddrFlag		= 0x9;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGERRRDCMD0;		
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				
    nandCmdAddr0.CMDADDR[3]			= CC_PAGERRRDCMD1;					
    smtNANDSetOPT1(&nandCmdAddr0);
    
   	ptrg = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/32; wi++)
    {
        //read FIFO ready check
    	while(true)
    	{
    		smtNANDGetStatus(&nandStatus);
    		if(nandStatus.rdFIFOReady) break;
    	}
        smtNANDGetData(ptrg++);
    }    
    
    return 0;
}
/*-----------------------------------------------------------------------
    Function name   : Read
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
smtBoolean ReadDMA(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 sizeInByte)
{
    
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint32	wi, *ptrg;
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_PAGERDCMD;						// 7 byte
    nandOpConfig.cmdAddrFlag		= OPCFG_FLG_COMMAND;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGERDCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGERDCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
    
    
    smtDMACEnable(NANDT_DMA_CH);
    smtDMACNoDescrp
    (
    	NANDT_DMA_CH,
    	NANDT_PERI_ADDR,
    	0,
    	NANDT_DMA_NAND_BIT_WIDTH,
    	(unsigned int)ppagebuf,
    	1,
    	NANDT_DMA_MEM_BIT_WIDTH,
    	NANDT_DMA_BURST_WIDTH,
    	sizeInByte
    );
    
    while(1) 
    {
		smtNANDGetStatus(&nandStatus);
    	if(nandStatus.rdEnd) break;    
    }

    smtDMACDisable(NANDT_DMA_CH);
    
    
    return 0;
}
/*-----------------------------------------------------------------------
    Function name   : Read
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
smtBoolean ReadInt(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 sizeInByte)
{
    
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint8	addr0, addr1, addr2, addr3, addr4;
    smtUint32	wi, *ptrg;
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_PAGERDCMD;						// 7 byte
    nandOpConfig.cmdAddrFlag		= OPCFG_FLG_COMMAND;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGERDCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGERDCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
    
   	ptrg = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/32; wi++)
    {
        //read FIFO ready check
    	while(true)
    	{
    		smtNANDGetStatus(&nandStatus);
    		if(nandStatus.rdFIFOReady) break;
    	}
        smtNANDGetData(ptrg++);
    }    
    
    return 0;
}
smtBoolean WaitReadInt(void)
{
	return 0;
}
/*-----------------------------------------------------------------------
    Function name   : PageProgram
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtBoolean PageProgram(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 sizeInByte)
{
    
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint8	addr0, addr1, addr2, addr3, addr4;
    smtUint32	wi, *psrc;
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_WRITEDATA;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_PAGEWRCMD;						// 7 byte
    nandOpConfig.cmdAddrFlag		= OPCFG_FLG_COMMAND;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGEWRCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGEWRCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
    
   	psrc = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/32; wi++)
    {
        //write FIFO ready check
    	while(true)
    	{
    		smtNANDGetStatus(&nandStatus);
    		if(nandStatus.wrFIFOReady) break;
    	}
        smtNANDSetData(psrc++);
    }    
    
    return 0;
}
/*-----------------------------------------------------------------------
    Function name   : RandomDataInput
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
smtBoolean RandomDataInput(smtUint16 colAddr, 
		smtUint32 ppagebuf, smtUint32 sizeInByte)
{
    
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint32	wi, *psrc;
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_PAGERWRDCMD;						
    nandOpConfig.cmdAddrFlag		= 0x9;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGERWRDCMD0;	
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);
    nandCmdAddr0.CMDADDR[3]			= CC_PAGERWRDCMD1;	
    smtNANDSetOPT1(&nandCmdAddr0);
    
    
   	psrc = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/32; wi++)
    {
        //read FIFO ready check
    	while(true)
    	{
    		smtNANDGetStatus(&nandStatus);
    		if(nandStatus.rdFIFOReady) break;
    	}
        smtNANDSetData(psrc++);
    }    
    
    return 0;
}
/*-----------------------------------------------------------------------
    Function name   : PageProgram
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtBoolean PageProgramDMA(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 sizeInByte)
{
    
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint8	addr0, addr1, addr2, addr3, addr4;
    smtUint32	wi, *psrc;
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_WRITEDATA;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_PAGEWRCMD;						// 7 byte
    nandOpConfig.cmdAddrFlag		= OPCFG_FLG_COMMAND;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGEWRCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGEWRCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
    
    smtDMACEnable(NANDT_DMA_CH);
	smtDMACNoDescrp
    (
    	NANDT_DMA_CH,
    	(unsigned int)ppagebuf,
    	1,
    	NANDT_DMA_MEM_BIT_WIDTH,
    	NANDT_PERI_ADDR,
    	0,
    	NANDT_DMA_NAND_BIT_WIDTH,    	
    	NANDT_DMA_BURST_WIDTH,
    	sizeInByte
    );
    
    while(1) 
    {
		smtNANDGetStatus(&nandStatus);
    	if(nandStatus.wrEnd) break;    
    }    
    
    smtDMACDisable(NANDT_DMA_CH);
    
    return 0;
}
/*-----------------------------------------------------------------------
    Function name   : PageProgram
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtBoolean PageProgramInt(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 sizeInByte)
{
    
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint8	addr0, addr1, addr2, addr3, addr4;
    smtUint32	wi, *psrc;
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_WRITEDATA;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_PAGEWRCMD;						// 7 byte
    nandOpConfig.cmdAddrFlag		= OPCFG_FLG_COMMAND;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGEWRCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGEWRCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
    
   	psrc = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/32; wi++)
    {
        //write FIFO ready check
    	while(true)
    	{
    		smtNANDGetStatus(&nandStatus);
    		if(nandStatus.wrFIFOReady) break;
    	}
        smtNANDSetData(psrc++);
    }    
    
    return 0;
}
smtBoolean WaitPageProgramInt(void)
{
	return 0;
}
/*-----------------------------------------------------------
    Function name   : Reset
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtBoolean Reset(void)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;   
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= DS_RESETCMD;
    nandOpConfig.opMode				= OPCFG_OPR_NOP;
    nandOpConfig.TransSize			= OPCFG_TS_WORD;
    nandOpConfig.cmdAddrTransByte	= CS_RESETCMD;				
    nandOpConfig.cmdAddrFlag		= 0xc0;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_RESETCMD;	
    nandCmdAddr0.CMDADDR[1]			= CC_RDSTATCMD;
    smtNANDSetOPT1(&nandCmdAddr0);
    
    // get status
   	smtNANDGetStatus(&nandStatus);
    if(nandStatus.NFStatus&0x1) 
    {
    	//DPRINTF("Nand Reset Fail \n");
    	return 0;
    }
    
    //DPRINTF("Nand Reset OK \n");
    
    return 1;
}
/*-----------------------------------------------------------
    Function name   : BlockErase
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtBoolean BlockErase(smtUint32 blockAddr)
{
	
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;   
   
    // operation configure
    nandOpConfig.chipSel			= OPCFG_CS_SEL;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= DS_BERASECMD;
    nandOpConfig.opMode				= OPCFG_OPR_NOP;
    nandOpConfig.TransSize			= OPCFG_TS_WORD;
    nandOpConfig.cmdAddrTransByte	= CS_BERASECMD;				
    nandOpConfig.cmdAddrFlag		= 0x11;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_BERASECMD0;
    nandCmdAddr0.CMDADDR[1]			= ADDRESS2(0, blockAddr);	
    nandCmdAddr0.CMDADDR[2]			= ADDRESS3(blockAddr);
    nandCmdAddr0.CMDADDR[3]			= ADDRESS4(blockAddr);
    smtNANDSetOPT1(&nandCmdAddr0);
    
    nandCmdAddr1.CMDADDR[0]			= CC_BERASECMD1;
    smtNANDSetOPT2(&nandCmdAddr1);
    
    // get status
   	smtNANDGetStatus(&nandStatus);
    if(nandStatus.NFStatus&0x1) 
    {
    	//DPRINTF("Erase block Fail \n");
    	return 0;
    }
    
    //DPRINTF("Erase block OK \n");
    
    return 1;
}
/*-----------------------------------------------------------
    Function name   : PageProgram
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtBoolean GetECC(smtUint16 colAddr, smtUint32 *pMECC, smtUint32 *pMECCS, 
	smtUint32 *pSECC, smtUint32 *pSECCS)
{
    
    smtNANDGetECC(colAddr/512, pMECC, pSECC);
    smtNANDGetECCStatus(colAddr/512, pMECCS, pSECCS);

    return 0;
}
/*-----------------------------------------------------------
	Function name	: NANDRWTest()
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean	NANDRWTest(void)
{
	
	smtUint32 	tmpBuffer[(512+16)/4];
	smtUint32	tbi;
	smtUint32	tmpBufferSizeInByte;
	
	
	//
	// 1. Sequential test read/write test
	//
	
	// make pattern 
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		tmpBuffer[tbi] = tbi;	
	}
	
	// erase and program
	BlockErase(0);
	PageProgram(0, 0, 0, tmpBuffer, tmpBufferSizeInByte);
	memset(tmpBuffer, 0, sizeof(char)*tmpBufferSizeInByte);
	
	// read and check pattern
	Read(0, 0, 0, tmpBuffer, tmpBufferSizeInByte);
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		if(tmpBuffer[tbi] != tbi)
		{
			// DPRINTF(" read/write fail!!! -> 0x%08X:0x%08X\n"
			//			tmpBuffer[tbi], tbi);
			return false;
		}
	}
	
	// DPRINTF(" read/write test success!!!\n");
	
	//	
	// 2. Random test read/write test
	// 
	
	// make pattern 
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		tmpBuffer[tbi] = tbi;	
	}
	
	// erase and program
	BlockErase(0);
	PageProgram(0, 0, 0, tmpBuffer, tmpBufferSizeInByte/2);
	RandomDataInput(256, tmpBuffer+tmpBufferSizeInByte/2, tmpBufferSizeInByte/2);
	memset(tmpBuffer, 0, sizeof(char)*tmpBufferSizeInByte);
	
	// read and check pattern
	Read(0, 0, 0, tmpBuffer, tmpBufferSizeInByte/2);
	RandomDataOutput(256, tmpBuffer+tmpBufferSizeInByte/2, tmpBufferSizeInByte/2);
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		if(tmpBuffer[tbi] != tbi)
		{
			// DPRINTF(" read/write fail!!! -> 0x%08X:0x%08X\n"
			//			tmpBuffer[tbi], tbi);
			return false;
		}
	}	

	//	
	// 3. DMA read/write test
	// 
	
	// make pattern 
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		tmpBuffer[tbi] = tbi;	
	}
	
	// erase and program
	BlockErase(0);
	PageProgramDMA(0, 0, 0, tmpBuffer, tmpBufferSizeInByte);
	memset(tmpBuffer, 0, sizeof(char)*tmpBufferSizeInByte);
	
	// read and check pattern
	ReadDMA(0, 0, 0, tmpBuffer, tmpBufferSizeInByte);
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		if(tmpBuffer[tbi] != tbi)
		{
			// DPRINTF(" read/write fail!!! -> 0x%08X:0x%08X\n"
			//			tmpBuffer[tbi], tbi);
			return false;
		}
	}
	
	//	
	// 4. RnB interrupt read/write test
	// 
	
	// make pattern 
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		tmpBuffer[tbi] = tbi;	
	}
	
	// erase and program
	BlockErase(0);
	PageProgramInt(0, 0, 0, tmpBuffer, tmpBufferSizeInByte);
	if(!WaitPageProgramInt())
	{
		// DPRINTF(" page program RnB interrupt fail \n");
		return false;
	}
	//DPRINTF(" page program RnB interrupt success !!!\n");
	
	memset(tmpBuffer, 0, sizeof(char)*tmpBufferSizeInByte);
	
	// read and check pattern
	ReadInt(0, 0, 0, tmpBuffer, tmpBufferSizeInByte);
	if(!WaitReadInt())
	{
		// DPRINTF(" read interrupt fail \n");
		return false;
	}
	//DPRINTF(" read RnB interrupt success !!!\n");
	
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		if(tmpBuffer[tbi] != tbi)
		{
			// DPRINTF(" read/write fail!!! -> 0x%08X:0x%08X\n"
			//			tmpBuffer[tbi], tbi);
			return false;
		}
	}	
	
	
	return true;
}
/*----------------------------------------------------------
	Function name	: NANDECCTest()
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean NANDECCTest(void)
{

	smtUint32	tbi;
	smtUint32	tmpBufferSizeInByte;
	smtUint32	SWMainECC, SWSpareECC;
	smtUint32 	SWMainECCStatus, SWSpareECCStatus;
	smtUint32 	HWMainECC, HWSpareECC;
	smtUint32 	HWMainECCStatus, HWSpareECCStatus;	
	smtUint32 	tmpBuffer[(512+16)/4];
	
	//-------------------------------------------------------
	//		- main ecc 	(correct/fail)
	//		- spare ecc	(correct/fail) -> later time
	//-------------------------------------------------------
	//
	// 1. main ecc test
	//
	
	// make pattern 
	for(tbi = 0; tbi < tmpBufferSizeInByte/4; tbi++)
	{
		tmpBuffer[tbi] = tbi;	
	}
	
	// erase and program
	BlockErase(0);
	PageProgram(0, 0, 0, tmpBuffer, tmpBufferSizeInByte);
	
	// get HW/SW ECC
	GetECC(0, &HWMainECC, &HWMainECCStatus, &HWSpareECC, &HWSpareECCStatus);
	mu_ecc_generate_512(tmpBuffer, SWMainECC);
	
	// compare with  SW ECC and HW ECC
	if(HWMainECC != SWMainECC) 
	{
		// DPRINTF(" main ECC fail!!!\n");
		return false;
	}

	// DPRINTF(" main ECC success!!!\n");	
	
	//
	// 2. spare ecc test
	//
	
	// make pattern 
	for(tbi = 0; tbi < 16; tbi++)
	{
		tmpBuffer[tbi] = tbi;	
	}
	
	// erase and program
	BlockErase(0);
	PageProgram(512*4, 0, 0, tmpBuffer, tmpBufferSizeInByte);
	
	// get HW/SW ECC
	GetECC(0, &HWMainECC, &HWMainECCStatus, &HWSpareECC, &HWSpareECCStatus);
	//mu_ecc_generate_spare(tmpBuffer, SWSpareECC);
	
	// compare with  SW ECC and HW ECC
	if(HWSpareECC != SWSpareECC) 
	{
		// DPRINTF(" spare ECC fail!!!\n");
		return false;
	}

	// DPRINTF(" spare ECC success!!!\n");		
	
	
	return true;
}

/*----------------------------------------------------------
	Function name	: NANDTest()
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 NANDTest(void)
{
	// Edit your NAND test code
	smtUint32	idCode[5];	
	smtBoolean	result;
	
	
	
	NandInit();
	
	//------------------------------------------------------- 
	//	check identify code
	//-------------------------------------------------------
	result = ReadID(idCode);
	if(!result)
	{
		// DPRINTF("NAND READ ID fail!!!\n");
		return FMC_ERROR;
	}
	
 	/*
	DPRINTF("-------- Nand ID Read --------\n");
	DPRINTF("Nand 1st ID : 0x%02X\n",idCode[0]);
	DPRINTF("Nand 2nd ID : 0x%02X\n",idCode[1]);
	DPRINTF("Nand 3rd ID : 0x%02X\n",idCode[2]);
	DPRINTF("Nand 4th ID : 0x%02X\n",idCode[3]);
    DPRINTF("Nand 5th ID : 0x%02X\n",idCode[4]);    
    */
	
	//-------------------------------------------------------
	// 	read/write
	//		- Sequential test
	//		- Random test
	//		- DMA test
	//		- Interrupt test
	//		- RnB interrupt test
	//-------------------------------------------------------
	result = NANDRWTest();
	if(!result)
	{
		// DPRINTF("NAND read/write test fail!!!\n");
		return FMC_ERROR;
	}
	// DPRINTF("NAND read/write test success!!!\n");
	

	//-------------------------------------------------------
	//	ecc test
	//		- main ecc 	(correct/fail)
	//		- spare ecc	(correct/fail)
	//-------------------------------------------------------
	result = NANDECCTest();
	if(!result)
	{
		// DPRINTF("NAND ECC test fail!!!\n");
		return FMC_ERROR;
	}
	// DPRINTF("NAND ECC test success!!!\n");
	
	//-------------------------------------------------------
	//	etc specfied function - later time
	//-------------------------------------------------------
			
	
	return NO_ERROR;
}

