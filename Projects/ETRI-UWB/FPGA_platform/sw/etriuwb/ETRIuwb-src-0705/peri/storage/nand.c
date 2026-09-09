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

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include <string.h>
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "global.h"
#include "nand_pre_drv.h"
#include "micro_ecc.h"
#include "smt_nand_cfg.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
//-----------------------------------------------------------
//	K9K8G08U0A 
//-----------------------------------------------------------
//
// command code
//
#define CC_RDIDCMD     					(0x90)		// check
#define CC_PAGERDCMD0  					(0x00)		// check
#define CC_PAGERDCMD1  					(0x30)		// check
#define CC_PAGEWRCMD0  					(0x80)		// check
#define CC_PAGEWRCMD1  					(0x10)		// check
#define CC_BERASECMD0  					(0x60)		// check
#define CC_BERASECMD1  					(0xD0)		// check
#define CC_RESETCMD    					(0xFF)		// check
#define CC_RDSTATCMD0  					(0x70)		// check
#define CC_RDSTATCMD1  					(0x7B)		// check

#define	CC_PAGERWRDCMD0					(0x85)		// check	
#define	CC_PAGERWRDCMD1					(0x00)		// check
#define	CC_PAGERRRDCMD0					(0x05)		// check
#define	CC_PAGERRRDCMD1					(0xE0)		// check
//
// address+command size
//
#define CS_RDIDCMD     					(0x02)		// check cmd0+c0
#define CS_PAGEWRCMD  					(0x07)		// check cmd0+c0+c1+r0+r1+r2+cmd1
#define CS_PAGERDCMD  					(0x07)		// check cmd0+c0+c1+r0+r1+r2+cmd1
#define CS_BERASECMD  					(0x05)		// check cmd0+r0+r1+r2+cmd1
#define CS_RDSTATCMD   					(0x01)		// check cmd0
#define CS_RESETCMD    					(0x01)		// ???	not tested
#define	CS_PAGERWRDCMD					(0x00)		// ???	not tested
#define	CS_PAGERRDCMD					(0x00)		// ???	not tested
//
// address+command bit flag
//
#define	CB_RESETCMD						(0x01)		// check (b 0000 0001)
#define	CB_RDIDCMD						(0x01)		// check (b 0000 0001)
#define	CB_PAGERDCMD					(0x41)		// check (b 0100 0001)
#define	CB_PAGEWRCMD					(0x41)		// check (b 0100 0001)
#define	CB_BERASECMD					(0x11)		// check (b 0001 0001)
#define	OPCFG_FLG_COMMAND				(0x01)
//
//	transize
//
#define	OPCFG_TS_BYTE					(0x00)		// check
#define	OPCFG_TS_HWORD					(0x01)		// check
#define	OPCFG_TS_WORD					(0x02)		// check
//
// operation
//
#define OPCFG_OPR_READDATA    			(0x00)		// check
#define OPCFG_OPR_READSTATUS 			(0x01)		// check 
#define OPCFG_OPR_READID      			(0x02)		// check
#define OPCFG_OPR_WRITEDATA   			(0x03)		// check
#define OPCFG_OPR_NOP         			(0x07)		// check
//
// option
//
#define OPCFG_OPT_RNBWAIT     			(0x01)		// check
#define OPCFG_OPT_AUTORDSTAT  			(0x02)		// check
#define OPCFG_OPT_CONTINUE    			(0x03)		// check
#define OPCFG_OPT_NOP					(0x00)		// check
//
// config
//
#define	NANDT_CFG_NANDBOOTEN			(0x00)
#define	NANDT_CFG_IOWIDTH				(0x00)
#define	NANDT_CFG_NANDWITH				(0x00)
#define	NANDT_CFG_BOOTCFG				(0x00)
#define	NANDT_CFG_OUTDTMN				(0x00)
#define	NANDT_CFG_TADLTWB				(0x0F)
#define	NANDT_CFG_TACLS					(0x02)
#define	NANDT_CFG_TRWLP					(0x02)
#define	NANDT_CFG_TRWHP					(0x02)
#define	NANDT_CTRL_FIFOLEV				(0x07)
#define	NANDT_DMA_CH					(0x0)
#define	NANDT_DMA_INT					(IRQ_DMA0)
#define	NANDT_DMA_NAND_BIT_WIDTH		(0x0)
#define	NANDT_DMA_MEM_BIT_WIDTH			(0x0)
#define	NANDT_DMA_BURST_WIDTH			(0x0)
#define	NANDT_PERI_ADDR					NANDDATA
//
//	address define
//
#define	ADDRESS0(c)						((c) & 0xFF)					// A00 ~ A07
#define	ADDRESS1(c)                 	(((c) >> 8) & 0xF)				// A08 ~ A11
#define	ADDRESS2(p, b)                 	((((b) & 0x3)<<6)|((p) & 0x3F))	// A12 ~ a19 
#define	ADDRESS3(b)                 	(((b) >> 2) & 0xFF)				// A20 ~ A27
#define	ADDRESS4(b)                 	(((b) >> 10) & 0xFF)			// A28 ~ A30
//
//	Time out
//
#define	NANDT_TO_RDREADY				(0x7FFFF)
#define	NANDT_TO_RDEND					(0x7FFFF)
#define	NANDT_TO_RDRNB					(0x7FFFF)
#define	NANDT_TO_WRREADY				(0x7FFFF)
#define	NANDT_TO_WREND					(0x7FFFF)
#define	NANDT_TO_WRRNB					(0x7FFFF)
#define	NANDT_TO_STATUSVALID			(0x7FFFF)
#define	NANDT_TO_DMAEND					(0x7FFFF)
//
// Error code
//
#define	NANDT_EC_NONE					(0<<0)
#define	NANDT_EC_RDREADY				(1<<0)
#define	NANDT_EC_RDEND					(1<<1)
#define	NANDT_EC_RDRNB					(1<<2)
#define	NANDT_EC_WRREADY				(1<<3)
#define	NANDT_EC_WREND					(1<<4)
#define	NANDT_EC_WRRNB					(1<<5)
#define	NANDT_EC_STATUSVALID			(1<<6)
#define	NANDT_EC_DMAEND					(1<<7)


extern smtBoolean smt2UartPrint(int dispLvl, char *fmt, ...);
//#define NANDDPRINTF(11, f, args...)		 smt2UartPrint(11, f, ##args)
#define NANDDPRINTF	smt2UartPrint

// Edit your code

/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
extern void 	DCacheFlushing(void);
extern smtUint8	mu_ecc_generate_256(smtUint8 *eccbuf, smtUint8 *datbuf);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static volatile smtBoolean	gDMAEnd 		= 0;

static volatile smtBoolean	gNANDRdReady 	= 0;
static volatile smtBoolean	gNANDRdEnd	 	= 0;
static volatile smtBoolean	gNANDRdRnB	 	= 0;

static volatile smtBoolean	gNANDWrReady 	= 0;
static volatile smtBoolean	gNANDWrEnd 		= 0;
static volatile smtBoolean	gNANDWrRnB 		= 0;

static	smtUint32 buffer[(512*4)/4];

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: NANDRdIntHandler
	Prototype		: static void NANDRdIntHandler(smtUint32 irq)
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void NANDRdIntHandler(smtUint32 irq)
{
	static NAND_STAT	nandStatus;
	
	smtNANDGetStatus(&nandStatus);
	if(nandStatus.RnBDetect0)
	{	
		memset(&nandStatus, 0, sizeof(NAND_STAT));
		nandStatus.RnBDetect0 = 0x1;
		smtNANDSetStatus(&nandStatus);
		gNANDRdRnB = 1;
	}
	
	smtNANDGetStatus(&nandStatus);
	if(nandStatus.rdFIFOReady)
	{
		gNANDRdReady = 1;
	}
	
	smtNANDGetStatus(&nandStatus);
	if(nandStatus.rdEnd)
	{
	
		memset(&nandStatus, 0, sizeof(NAND_STAT));
		nandStatus.rdEnd = 0x1;
		smtNANDSetStatus(&nandStatus);

		gNANDRdEnd = 1;
	}		

}
/*----------------------------------------------------------
	Function name	: NANDWrIntHandler
	Prototype		: static void NANDWrIntHandler(smtUint32 irq)
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void NANDWrIntHandler(smtUint32 irq)
{
	static NAND_STAT nandStatus;
	
	smtNANDGetStatus(&nandStatus);
	if(nandStatus.wrFIFOReady)
	{
		gNANDWrReady = 1;
	}
	
	smtNANDGetStatus(&nandStatus);
	if(nandStatus.wrEnd)
	{
		memset(&nandStatus, 0, sizeof(nandStatus));
		nandStatus.wrEnd 		= 0x1;
		smtNANDSetStatus(&nandStatus);
		
		gNANDWrEnd = 1;
	}	
	
	smtNANDGetStatus(&nandStatus);
	if(nandStatus.RnBDetect0)
	{
		memset(&nandStatus, 0, sizeof(NAND_STAT));
		nandStatus.RnBDetect0 = 0x1;
		smtNANDSetStatus(&nandStatus);
		
		gNANDWrRnB = 1;
	}	

	
}
/*----------------------------------------------------------
	Function name	: NANDDMAHandler
	Prototype		: static void NANDDMAHandler(smtUint32 irq)
	Return			: none
	Argument		: requested system interrupt number
	Comments		: NAND DMA end interrupt handler
-----------------------------------------------------------*/
static void NANDDMAHandler(smtUint32 irq)
{
	SMT_WRITE(DMACSta(NANDT_DMA_CH), 0xf);
	gDMAEnd = 1;
}
/*----------------------------------------------------------
	Function name	: MakePattern
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static smtBoolean MakePattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
{
	smtUint32 	i;//, j;
	smtUint32	*pbuffer = (smtUint32*)buffer;
	
	
	for(i = 0; i < size/sizeof(int); i++)
	{
		pbuffer[i] = (seed | i);
	}	
	
	return 0;
}
/*----------------------------------------------------------
	Function name	: CheckPattern
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static smtBoolean CheckPattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
{
	smtUint32 	i;//, j;
	smtUint32	pattern;
	smtUint32	*pbuffer = (smtUint32*)buffer;
	for(i = 0; i < size/4; i++)
	{
		
		pattern = (seed | i);
		if(pbuffer[i] != pattern)
		{
			NANDDPRINTF(11, "error 0x%08x:0x%08x\n", 
				pbuffer[i], pattern);
			return false;
		}
	}	
	
	return true;
}
/*----------------------------------------------------------
	Function name	: HexDump
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void HexDump(smtUint32 buffer, smtUint32 size)
{
	smtUint32 	i, j;
	smtUint8	*pbuffer = (smtUint8*)buffer;
	for(i = 0; i < size/16; i++)
	{
		NANDDPRINTF(11, "0x%08x : ", &pbuffer[i*16+j]);
		for(j = 0; j < 16; j++) 
		 	NANDDPRINTF(11, "%02x ", pbuffer[i*16+j]);
		 
		NANDDPRINTF(11, " | ");
		 
		for(j = 0; j < 16; j++) 
		{
			if((pbuffer[i*16+j] != '\n')
			&& (pbuffer[i*16+j] != '\r')
			&& (pbuffer[i*16+j] != '\t'))
		 		NANDDPRINTF(11, "%c", pbuffer[i*16+j]);
		 	else
		 		NANDDPRINTF(11, " ");
		}
		
		NANDDPRINTF(11, "\n");
		
	}	
	NANDDPRINTF(11, "\n");
}

/*----------------------------------------------------------
	Function name	: NandDefaultSetting
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void NandDefaultSetting(void)
{
	NAND_CFG	nandCfg;
	NAND_CTRL	nandCtrl;	

	// init nand controller
	nandCfg.nandBootEn		= NANDT_CFG_NANDBOOTEN;
	nandCfg.IOWidth			= NANDT_CFG_IOWIDTH;
	nandCfg.NandWidth		= NANDT_CFG_NANDWITH;
	nandCfg.bootCfg			= NANDT_CFG_BOOTCFG;
	nandCfg.OutDtmn			= NANDT_CFG_OUTDTMN;
	nandCfg.TADLTWB			= NANDT_CFG_TADLTWB;
	nandCfg.TCALS			= NANDT_CFG_TACLS;
	nandCfg.TRWLP			= NANDT_CFG_TRWLP;
	nandCfg.TRWHP			= NANDT_CFG_TRWHP;
	smtNANDSetCfg(&nandCfg);	

	nandCtrl.NFCtrlRst		= 0x1;
	nandCtrl.FIFOLevel		= NANDT_CTRL_FIFOLEV;
	nandCtrl.Ecc512byteEn	= 0x0;
	nandCtrl.autoEccWr		= 0x0;
	nandCtrl.DMAEn			= 0x0;
	nandCtrl.wrEndIntEn		= 0x0;
	nandCtrl.rdEndIntEn		= 0x0;
	nandCtrl.FIFOIntEn		= 0x0;
	nandCtrl.RnBintEn0		= 0x0;
	smtNANDSetControl(&nandCtrl);	
}
/*-----------------------------------------------------------
    Function name   : Reset
    Prototype       : smtUint32 Reset(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtUint32 Reset(void)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_STAT	nandStatus;
    smtUint32	errorCode;
    
    // 
    errorCode = NANDT_EC_NONE;   
   
    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= 0x00;
    nandOpConfig.opMode				= OPCFG_OPR_NOP;
    nandOpConfig.TransSize			= OPCFG_TS_WORD;
    nandOpConfig.cmdAddrTransByte	= CS_RESETCMD;				
    nandOpConfig.cmdAddrFlag		= CB_RESETCMD;				
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_RESETCMD;	
    smtNANDSetOPT1(&nandCmdAddr0);
     
    smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);   
     
    return errorCode;
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
    smtUint32	timeOut;
    smtUint32	errorCode;

    // 
    errorCode = NANDT_EC_NONE;
    
    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= 0x05;
    nandOpConfig.opMode				= OPCFG_OPR_READID;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_RDIDCMD;
    nandOpConfig.cmdAddrFlag		= CB_RDIDCMD;
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command
    nandCmdAddr.CMDADDR[0]			= CC_RDIDCMD;
    nandCmdAddr.CMDADDR[1]			= 0x00;
    smtNANDSetOPT1(&nandCmdAddr);
    
    timeOut = 0;
	while(true)
	{		
		smtNANDGetStatus(&nandStatus);
		if(nandStatus.rdFIFOReady) 
		{
			break;
		}
		
		if(timeOut++ == NANDT_TO_RDREADY)
		{
			errorCode = NANDT_EC_RDREADY;
			goto Error;
		}
	}		    
	
    NANDDPRINTF(11, "ReadID:: get NAND ID code data\n");
    // get NAND ID code data
    id[0] = smtNANDGetData();
    id[1] = smtNANDGetData();
    id[2] = smtNANDGetData();
    id[3] = smtNANDGetData();
    id[4] = smtNANDGetData();
    
    NANDDPRINTF(11, "ID code: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
    	id[0], id[1], id[2], id[3], id[4]);
 
    
  	NANDDPRINTF(11, "-ReadID\n");
  
Error:
	smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);
	return errorCode;
   
}

/*-----------------------------------------------------------------------
    Function name   : Read
    Prototype       : smtUint32 Read(
    					smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
						smtUint32 ppagebuf, smtUint8 transSize, smtUint32 sizeInByte)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
smtUint32 Read(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint8 transSize, smtUint32 sizeInByte)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint32	timeOut;
    smtUint32	errorCode;
    smtUint32	wi, bi, *ptrg, tmpData;
    
    // 
    errorCode = NANDT_EC_NONE;

    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA; 
    nandOpConfig.TransSize			= transSize; 			
    nandOpConfig.cmdAddrTransByte	= CS_PAGERDCMD;			
    nandOpConfig.cmdAddrFlag		= CB_PAGERDCMD;			
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
    

	// read fifo by CPU
   	ptrg = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/sizeof(int); wi++)
    {
    	switch(transSize) 
    	{
    	//---------------------------------------------------
    	//	byte access
    	//---------------------------------------------------
    	case OPCFG_TS_BYTE:
        	tmpData = 0;
        	for(bi = 0; bi < 4; bi++) 
       		{
       			// wait util read target fifo level read available 
    			if(!((wi*4+bi)%((NANDT_CTRL_FIFOLEV+1)))) 
    			{
    				timeOut = 0;
					while(true)
					{
						smtNANDGetStatus(&nandStatus);
						if(nandStatus.rdFIFOReady) 
						{
							break;
						}
						
						if(timeOut++ == NANDT_TO_RDREADY) 
						{
							errorCode = NANDT_EC_RDREADY;
							goto Error;
						}
					}    		
				}
       			
    			tmpData	|= ((smtNANDGetData()&0xFF)<<(8*bi));
    		}    		
    		break;
    	//---------------------------------------------------
    	//	half word access
    	//---------------------------------------------------
    	case OPCFG_TS_HWORD:
        	tmpData = 0;
        	for(bi = 0; bi < 2; bi++) 
       		{
       			// wait util read target fifo level read available 
    			if(!((wi*4+bi)%((NANDT_CTRL_FIFOLEV+1)*2))) 
    			{
    				timeOut = 0;
					while(true)
					{
						smtNANDGetStatus(&nandStatus);
						if(nandStatus.rdFIFOReady) 
						{
							break;
						}
						
						if(timeOut++ == NANDT_TO_RDREADY) 
						{
							errorCode = NANDT_EC_RDREADY;
							goto Error;
						}
					}    		
				}
       			
    			tmpData	|= ((smtNANDGetData()&0xFFFF)<<(16*bi));
    		}    		
    		break;
    	//---------------------------------------------------
    	//	word access
    	//---------------------------------------------------
    	case OPCFG_TS_WORD:
    		if(!((wi*4)%((NANDT_CTRL_FIFOLEV+1)*4))) 
    		{
    			timeOut = 0;
				while(true)
				{
					smtNANDGetStatus(&nandStatus);
					if(nandStatus.rdFIFOReady) 
					{
						break;
					}
					
					if(timeOut++ == NANDT_TO_RDREADY) 
					{
						errorCode = NANDT_EC_RDREADY;
						goto Error;
					}
				}    		
			}
			tmpData	= smtNANDGetData();
    		break;
    	}
        *ptrg++ = tmpData;
    }    

Error:
	smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);
	return errorCode;
   
}
/*-----------------------------------------------------------------------
    Function name   : ReadInt
    Prototype       : smtUint32 ReadInt(
    					smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
						smtUint32 ppagebuf, smtUint8 transSize, smtUint32 sizeInByte)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
smtUint32 ReadInt(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint8 transSize, smtUint32 sizeInByte)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;  
    NAND_STAT	nandStatus;
    smtUint32	wi, bi, *ptrg, tmpData;
    smtUint32	errorCode;
    smtUint32	timeOut;

     // 
    errorCode = NANDT_EC_NONE;

    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA; 
    nandOpConfig.TransSize			= transSize; 			
    nandOpConfig.cmdAddrTransByte	= CS_PAGERDCMD;			
    nandOpConfig.cmdAddrFlag		= CB_PAGERDCMD;			
    smtNANDSetOPT0(&nandOpConfig);
    
    // configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(IRQ_NAND, NANDRdIntHandler);
	gNANDRdRnB		= 0;
	gNANDRdReady 	= 0;
	gNANDRdEnd		= 0;
	Enable_IRQ();
    
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
    
	// check rnb
	timeOut = 0;
	while(true)
	{
		if(gNANDRdRnB) 
		{
			//NANDDPRINTF(11, "check RnB detected!!!\n");
			gNANDRdRnB = 0;
			break;
		}
		
		if(timeOut++ == NANDT_TO_RDRNB)
		{
			errorCode = NANDT_EC_RDRNB;
			goto Error;
		}
	}
	
	
	// read fifo by CPU
   	ptrg = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/sizeof(int); wi++)
    {
     	switch(transSize) 
    	{
    	//---------------------------------------------------
    	//	byte access
    	//---------------------------------------------------
    	case OPCFG_TS_BYTE:
        	tmpData = 0;
        	for(bi = 0; bi < 4; bi++) 
       		{
       			// wait util read target fifo level read available 
    			if(!((wi*4+bi)%((NANDT_CTRL_FIFOLEV+1)))) 
    			{
    				timeOut = 0;
					while(true)
					{
						if(gNANDRdReady) 
						{
							gNANDRdReady = 0;
							break;
						}
						
						if(timeOut++ == NANDT_TO_RDREADY)
						{
							errorCode = NANDT_EC_RDREADY;
							goto Error;
						}
					} 		
				}
       			
    			tmpData	|= ((smtNANDGetData()&0xFF)<<(8*bi));
    		}    		
    		break;
    	//---------------------------------------------------
    	//	half word access
    	//---------------------------------------------------
    	case OPCFG_TS_HWORD:
        	tmpData = 0;
        	for(bi = 0; bi < 2; bi++) 
       		{
       			// wait util read target fifo level read available 
    			if(!((wi*4+bi)%((NANDT_CTRL_FIFOLEV+1)*2))) 
    			{
    				timeOut = 0;
					while(true)
					{
						if(gNANDRdReady) 
						{
							gNANDRdReady = 0;
							break;
						}
						
						if(timeOut++ == NANDT_TO_RDREADY)
						{
							errorCode = NANDT_EC_RDREADY;
							goto Error;
						}
					}    		
				}
       			
    			tmpData	|= ((smtNANDGetData()&0xFFFF)<<(16*bi));
    		}    		
    		break;
    	//---------------------------------------------------
    	//	word access
    	//---------------------------------------------------
    	case OPCFG_TS_WORD:
    		// wait util read target fifo level read available 
    		if(!((wi*4)%((NANDT_CTRL_FIFOLEV+1)*4))) 
    		{
    			timeOut = 0;
				while(true)
				{
					if(gNANDRdReady) 
					{
						gNANDRdReady = 0;
						break;
					}
					
					if(timeOut++ == NANDT_TO_RDREADY)
					{
						errorCode = NANDT_EC_RDREADY;
						goto Error;
					}
				}    		
   		
			}
			tmpData	= smtNANDGetData();
    		break;
    	}
        *ptrg++ = tmpData;
    }    
    
    // check read end 
    timeOut = 0;
    while(true)
	{
		if(gNANDRdEnd) 
		{
			//NANDDPRINTF(11, "Read end interrupt!!!\n");
			gNANDRdEnd = 0;
			break;
		}
		
		if(timeOut++ == NANDT_TO_RDEND)
		{
			errorCode = NANDT_EC_RDEND;
			goto Error;
		}
	}
    
Error:
	
	// disable interrupt
	ReleaseIRQ(IRQ_NAND);	
	smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);
    return errorCode;
}
/*-----------------------------------------------------------------------
    Function name   : ReadDMA
    Prototype       : smtUint32 ReadDMA(
    					smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
						smtUint32 ppagebuf, smtUint8 transSize, smtUint32 sizeInByte)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
smtUint32 ReadDMA(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint8 transSize, smtUint32 sizeInByte)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;    
    smtUint32	regValue;
    smtUint32	burstSize;
    smtUint32	timeOut;
    smtUint32	errorCode;
    
    // 
    errorCode = NANDT_EC_NONE;
    
    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA;
    nandOpConfig.TransSize			= transSize; 		
    nandOpConfig.cmdAddrTransByte	= CS_PAGERDCMD;		
    nandOpConfig.cmdAddrFlag		= CB_PAGERDCMD;		
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command and address
    nandCmdAddr0.CMDADDR[0]			= CC_PAGERDCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGERDCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
    		   
	// configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(NANDT_DMA_INT, NANDDMAHandler);
	gDMAEnd = 0;
	Enable_IRQ();
	
	DCacheFlushing();
	
	// disable
	SMT_WRITE(DMACSta(NANDT_DMA_CH), 0xf);
	
	// set source address
	SMT_WRITE (DMACSAdr(NANDT_DMA_CH), (smtUint32)&NANDDATA);
	
	// set destination address
	SMT_WRITE (DMACDAdr(NANDT_DMA_CH), (smtUint32)ppagebuf);	
	
	// set burst size
	switch(transSize)
	{
	case OPCFG_TS_BYTE:
		burstSize = 0x3;
		break;
		
	case OPCFG_TS_HWORD:
		burstSize = 0x4;
		break;
		
	case OPCFG_TS_WORD:
		burstSize = 0x5;
		break;
	}
				
	// set configuration 
	regValue =
	 	((0x0 << 31)				// disable start interrupt
		|(0x1 << 30)				// enable end interrupt
		|(0x0 << 29)				// no using flow control(hand shaking)
		|(0x0 << 28)				// source increasement
		|(transSize << 26)			// source WORD width, NAND is always word width???
		|(0x1 << 25)				// destination increasement
		|(0x2 << 23)				// target WORD width
		|(burstSize << 20)			// burst size 32 byte
		|(sizeInByte));				// total transfer size
	SMT_WRITE (DMACCon(NANDT_DMA_CH), regValue);
	
	// no use descriptor
	SMT_WRITE (DMACDescrp(NANDT_DMA_CH), 0x1);
	
	// run 
	SMT_WRITE(DMACSta(NANDT_DMA_CH), 
		DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);
	
	// wait DMA end
	timeOut = 0;
	while(1) 
	{
		if(gDMAEnd) 
		{
			gDMAEnd = 0;
			break;
		}
		
		if(timeOut++ == NANDT_TO_DMAEND)
		{
			errorCode = NANDT_EC_DMAEND;
			goto Error;
		}
	}  	
	
	// cache invalidate
	//MMU_InvalidateDCache();



    
Error:
	
	// disable interrupt
	ReleaseIRQ(NANDT_DMA_INT);	
	smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);
	return errorCode;
	    
}
/*-----------------------------------------------------------------------
    Function name   : PageProgram
    Prototype       : smtUint32 PageProgram(
    					smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
						smtUint32 ppagebuf, smtUint32 transSize, smtUint32 sizeInByte)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtUint32 PageProgram(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 transSize, smtUint32 sizeInByte)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;  
    smtUint32	timeOut;
    smtUint32	errorCode;
    smtUint32	wi, bi, *psrc, tmpData;
    
    //
    errorCode = NANDT_EC_NONE;        

    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_WRITEDATA;
    nandOpConfig.TransSize			= transSize;						
    nandOpConfig.cmdAddrTransByte	= CS_PAGEWRCMD+1;					
    nandOpConfig.cmdAddrFlag		= CB_PAGEWRCMD;						
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command and address
    nandCmdAddr0.CMDADDR[0]			= CC_PAGEWRCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGEWRCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
   
	
    // program operation
  	psrc = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/sizeof(int); wi++)
    {
    	switch(transSize) 
    	{
    	//---------------------------------------------------
    	//	byte access
    	//---------------------------------------------------
    	case OPCFG_TS_BYTE:
        	for(bi = 0; bi < 4; bi++) 
       		{
       			if(!((wi*4+bi)%((NANDT_CTRL_FIFOLEV+1)))) 
       			{
       				timeOut = 0;
					while(true)
					{
						smtNANDGetStatus(&nandStatus);
						if(nandStatus.wrFIFOReady) 
						{
							break;
						}
						
						if(timeOut++ == NANDT_TO_WRREADY)
						{
							errorCode = NANDT_EC_WRREADY;
							goto Error;
						}
					}           			
				}
				
    			tmpData	= (*psrc>>(8*bi)&0xFF);
    			smtNANDSetData(&tmpData);	  
    		}    		
    		psrc++;
    		break;
    	//---------------------------------------------------
    	//	half word access
    	//---------------------------------------------------
    	case OPCFG_TS_HWORD:
        	for(bi = 0; bi < 2; bi++) 
       		{	
       			if(!((wi*4+bi)%((NANDT_CTRL_FIFOLEV+1)*2))) 
       			{
       				timeOut = 0;
					while(true)
					{
						smtNANDGetStatus(&nandStatus);
						if(nandStatus.wrFIFOReady) 
						{
							break;
						}
						
						if(timeOut++ == NANDT_TO_WRREADY)
						{
							errorCode = NANDT_EC_WRREADY;
							goto Error;
						}
					}           			
				}
       			
    			tmpData	= (*psrc>>(16*bi)&0xFFFF);
    			smtNANDSetData(&tmpData);	       			
    		}    	
    		psrc++;
    		break;
    	//---------------------------------------------------
    	//	word access
    	//---------------------------------------------------
    	case OPCFG_TS_WORD:
			if(!((wi*4)%((NANDT_CTRL_FIFOLEV+1)*4))) 
			{
				timeOut = 0;
				while(true)
				{
					smtNANDGetStatus(&nandStatus);
					if(nandStatus.wrFIFOReady) 
					{
						break;
					}
					
					if(timeOut++ == NANDT_TO_WRREADY)
					{
						errorCode = NANDT_EC_WRREADY;
						goto Error;
					}
					
					
				}           			
			}    		
    		tmpData	= *psrc++;
    		smtNANDSetData(&tmpData);
    		break;
    	}
    }     
    
    // check write status
    timeOut = 0;
    while(true)
    {
    	smtNANDGetStatus(&nandStatus);
    	if(nandStatus.NFStatValid) 
    	{
			//NANDDPRINTF(11, "status: 0x%02x\n", nandStatus.NFStatus);
			memset(&nandStatus, 0, sizeof(nandStatus));
			nandStatus.NFStatValid = 1;
			smtNANDSetStatus(&nandStatus);
    		break;
    	}
    	
    	if(timeOut++ == NANDT_TO_WREND)
    	{
    		errorCode = NANDT_EC_WREND;
    		goto Error;
    	}
    }
    
    return errorCode;
Error:
	
	smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);
	return errorCode;
}
/*-----------------------------------------------------------------------
    Function name   : PageProgramInt
    Prototype       : smtUint32 PageProgram(
    					smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
						smtUint32 ppagebuf, smtUint32 transSize, smtUint32 sizeInByte)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtUint32 PageProgramInt(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 transSize, smtUint32 sizeInByte)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;  
    smtUint32	timeOut;
    smtUint32	errorCode;
    smtUint32	wi, bi, *psrc, tmpData;
    
    // 
    errorCode = NANDT_EC_NONE;  
   
    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_WRITEDATA;
    nandOpConfig.TransSize			= transSize;						
    nandOpConfig.cmdAddrTransByte	= CS_PAGEWRCMD+1;					
    nandOpConfig.cmdAddrFlag		= CB_PAGEWRCMD;						
    smtNANDSetOPT0(&nandOpConfig);
    
    // configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(IRQ_NAND, NANDWrIntHandler);
	gNANDWrRnB		= 0;
	gNANDWrReady 	= 0;
	gNANDWrEnd		= 0;
	Enable_IRQ();
    
    // send command and address
    nandCmdAddr0.CMDADDR[0]			= CC_PAGEWRCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(&nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGEWRCMD1;					// second command
    smtNANDSetOPT2(&nandCmdAddr1);
    
    // program operation
  	psrc = (smtUint32*)ppagebuf;
  	for(wi=0; wi<sizeInByte/sizeof(int); wi++)
    {
      	switch(transSize) 
    	{
    	//---------------------------------------------------
    	//	byte access
    	//---------------------------------------------------
    	case OPCFG_TS_BYTE:
        	for(bi = 0; bi < 4; bi++) 
       		{
       			if(!((wi*4+bi)%((NANDT_CTRL_FIFOLEV+1)))) 
       			{
       				timeOut = 0;
					while(true)
					{
						if(gNANDWrReady) 
						{
							gNANDWrReady = 0;
							break;
						}
						
						if(timeOut++ == NANDT_TO_WRREADY)
						{
							errorCode = NANDT_EC_WRREADY;
							goto Error;
						}
					}	  
				}
				
    			tmpData	= (*psrc>>(8*bi)&0xFF);
    			smtNANDSetData(&tmpData);	  
    		}    		
    		psrc++;
    		break;
    	//---------------------------------------------------
    	//	half word access
    	//---------------------------------------------------
    	case OPCFG_TS_HWORD:
        	for(bi = 0; bi < 2; bi++) 
       		{	
       			if(!((wi*4+bi)%((NANDT_CTRL_FIFOLEV+1)*2))) 
       			{
       				timeOut = 0;
					while(true)
					{
						if(gNANDWrReady) 
						{
							gNANDWrReady = 0;
							break;
						}
						
						if(timeOut++ == NANDT_TO_WRREADY)
						{
							errorCode = NANDT_EC_WRREADY;
							goto Error;
						}
					}	          			
				}
       			
    			tmpData	= (*psrc>>(16*bi)&0xFFFF);
    			smtNANDSetData(&tmpData);	       			
    		}    	
    		psrc++;
    		break;
    	//---------------------------------------------------
    	//	word access
    	//---------------------------------------------------
    	case OPCFG_TS_WORD:
			if(!((wi*4)%((NANDT_CTRL_FIFOLEV+1)*4))) 
			{
				timeOut = 0;
				while(true)
				{
					if(gNANDWrReady) 
					{
						gNANDWrReady = 0;
						break;
					}
					
					if(timeOut++ == NANDT_TO_WRREADY)
					{
						errorCode = NANDT_EC_WRREADY;
						goto Error;
					}
				}	          			
			}    		
    		tmpData	= *psrc++;
    		smtNANDSetData(&tmpData);
    		break;
    	}
    }     
    
    // check write status
    timeOut = 0;
    while(true)
    {
    	smtNANDGetStatus(&nandStatus);
    	if(nandStatus.NFStatValid) 
    	{
			memset(&nandStatus, 0, sizeof(nandStatus));
			nandStatus.NFStatValid = 0x1;
			smtNANDSetStatus(&nandStatus);
    		break;
    	}
    	
    	if(timeOut++ == NANDT_TO_STATUSVALID)
    	{
    		errorCode = NANDT_EC_STATUSVALID;
    		goto Error;
    	}
    }
    
    // check write end 
    timeOut = 0;
    while(true)
	{
		if(gNANDWrEnd) 
		{
			gNANDWrEnd = 0;
			break;
		}
		
		if(timeOut++ == NANDT_TO_WREND)
		{
			errorCode = NANDT_EC_WREND;
			goto Error;
		}
	}
    
	// check rnb
	timeOut = 0;
	while(true)
	{
		if(gNANDWrRnB) 
		{
			gNANDWrRnB = 0;
			break;
		}
		
		if(timeOut++ == NANDT_TO_WRRNB)
		{
			errorCode = NANDT_EC_WRRNB;
			goto Error;
		}
	}    

Error:
	smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);
    
	return errorCode;          
    
}
/*-----------------------------------------------------------------------
    Function name   : PageProgramDMA
    Prototype       : smtUint32 PageProgramDMA(
    					smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
						smtUint32 ppagebuf, smtUint32 transSize, smtUint32 sizeInByte)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtUint32 PageProgramDMA(smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 transSize, smtUint32 sizeInByte)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;   
    smtUint32	regValue;
    smtUint32	burstSize;
    smtUint32	timeOut;
    smtUint32	errorCode;
    
    // 
    errorCode = NANDT_EC_NONE;    
    
    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_WRITEDATA;
    nandOpConfig.TransSize			= transSize;						
    nandOpConfig.cmdAddrTransByte	= CS_PAGEWRCMD+1;					
    nandOpConfig.cmdAddrFlag		= CB_PAGEWRCMD;						
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
  	
	// configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(NANDT_DMA_INT, NANDDMAHandler);
	gDMAEnd = 0;
	Enable_IRQ();  
	
	// cache flush
	MMU_TestCleanDCache();
  
    // disable
	SMT_WRITE(DMACSta(NANDT_DMA_CH), 0xf);
	
	// set source address
	SMT_WRITE (DMACSAdr(NANDT_DMA_CH), (smtUint32)ppagebuf);
	
	// set destination address
	SMT_WRITE (DMACDAdr(NANDT_DMA_CH), (smtUint32)&NANDDATA);	
	
	// set burst size
	switch(transSize)
	{
	case OPCFG_TS_BYTE:
		burstSize = 0x3;
		break;
		
	case OPCFG_TS_HWORD:
		burstSize = 0x4;
		break;
		
	case OPCFG_TS_WORD:
		burstSize = 0x5;
		break;
	}
				
	// set configuration 
	regValue =
	 	((0x0 << 31)				// disable start interrupt
		|(0x1 << 30)				// enable end interrupt
		|(0x0 << 29)				// no using flow control(hand shaking)
		|(0x1 << 28)				// source increasement
		|(0x2 << 26)				// source WORD width
		|(0x0 << 25)				// destination increasement
		|(transSize << 23)			// target WORD width, NAND is always WORD width???
		|(burstSize << 20)			// burst size 32 byte
		|(sizeInByte));				// total transfer size
	SMT_WRITE (DMACCon(NANDT_DMA_CH), regValue);
	
	// no use descriptor
	SMT_WRITE (DMACDescrp(NANDT_DMA_CH), 0x1);
	
	// run 
	SMT_WRITE(DMACSta(NANDT_DMA_CH), 
		DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);

	// wait DMA end
	timeOut = 0;
	while(1) 
	{
		if(gDMAEnd) 
		{
			gDMAEnd = 0;
			break;
		}
		
		if(timeOut++ == NANDT_TO_DMAEND)
		{
			errorCode = NANDT_EC_DMAEND;
			goto Error;
		}
	}  	
	    
    // check write status form NAND 
    timeOut = 0;
    while(true)
    {
    	smtNANDGetStatus(&nandStatus);
    	if(nandStatus.NFStatValid) 
    	{
    		/*
    		memset(&nandStatus, 0, sizeof(nandStatus));
			nandStatus.NFStatValid = 1;
			smtNANDSetStatus(&nandStatus);
			*/
    		break;
    	}
    	
    	if(timeOut++ == NANDT_TO_STATUSVALID)
    	{
    		errorCode = NANDT_EC_STATUSVALID;
    		goto Error;
    	}
    }


Error:    
	// disable DMA interrupt
	ReleaseIRQ(NANDT_DMA_INT);	
    
	smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);
    
    return errorCode;
}

/*-----------------------------------------------------------
    Function name   : BlockErase
    Prototype       : smtUint32 BlockErase(smtUint32 blockAddr)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtUint32 BlockErase(smtUint32 blockAddr)
{
    NAND_OPT0	nandOpConfig;
    NAND_OPT1	nandCmdAddr0;
    NAND_OPT2	nandCmdAddr1;
    NAND_STAT	nandStatus;  	
    smtUint32	timeOut;
    smtUint32	errorCode;
    
    // 
    errorCode = NANDT_EC_NONE;

    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= 0x00;
    nandOpConfig.opMode				= OPCFG_OPR_NOP;
    nandOpConfig.TransSize			= OPCFG_TS_WORD;
    nandOpConfig.cmdAddrTransByte	= CS_BERASECMD+1;	
    nandOpConfig.cmdAddrFlag		= CB_BERASECMD;		
    smtNANDSetOPT0(&nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_BERASECMD0;
    nandCmdAddr0.CMDADDR[1]			= ADDRESS2(0, blockAddr);	
    nandCmdAddr0.CMDADDR[2]			= ADDRESS3(blockAddr);
    nandCmdAddr0.CMDADDR[3]			= ADDRESS4(blockAddr);
    smtNANDSetOPT1(&nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= CC_BERASECMD1;
    nandCmdAddr1.CMDADDR[1]			= CC_RDSTATCMD0;
    smtNANDSetOPT2(&nandCmdAddr1);
    
    
	// check write status
	timeOut = 0;
    while(1) 
	{
		smtNANDGetStatus(&nandStatus);
		if(nandStatus.NFStatValid)
		{
			smtNANDSetStatus(&nandStatus);
    		break;
    	}
    	
    	if(timeOut++ == NANDT_TO_STATUSVALID)
    	{
    		errorCode = NANDT_EC_STATUSVALID;
    		goto Error;
    	}
    }

Error:    
	
	smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);
    return errorCode;
}
/*-----------------------------------------------------------
    Function name   : GetECC
    Prototype       : smtBoolean GetECC(smtUint16 sector, smtUint32 *pMECC, smtUint32 *pSECC)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtBoolean GetECC(smtUint16 sector, smtUint32 *pMECC, smtUint32 *pSECC)
{
	
    smtNANDGetECC(sector, pMECC, pSECC);
    return 0;
}
/*-----------------------------------------------------------
	Function name	: NANDRWTest
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean	NANDRWTest(void)
{

	smtUint32	seed 	= 0xAAAA0000;
	smtUint32	size	= 2048;
	smtUint32	atIdx, colAddr, pageAddr, blkAddr;
	smtUint32	ret;
	smtBoolean	compareResult;
	NAND_CTRL	nandCtrl;	
	smtUint32	accessType[] 		
		= {OPCFG_TS_BYTE, OPCFG_TS_HWORD, OPCFG_TS_WORD};
	static char	accessTypeStr[][80] 
		= {"OPCFG_TS_BYTE", "OPCFG_TS_HWORD", "OPCFG_TS_WORD"};
		
	//--------------------------------------------------------------------------
	// 1. CPU read/write test for 1 Block
	//--------------------------------------------------------------------------	
	NANDDPRINTF(11, "[NAND TEST] CPU read/write test start!!!\n");
	
	// set default setting
	NandDefaultSetting();
	
	for(atIdx = 2; atIdx < 3; atIdx++) 
	{
		NANDDPRINTF(11, "-------------------------------------------------------------\n");
		NANDDPRINTF(11, "[NAND TEST] CPU --%s!!!\n", accessTypeStr[atIdx]);
		NANDDPRINTF(11, "-------------------------------------------------------------\n");
		
		for(blkAddr = NAND_TEST_START; 
			blkAddr < NAND_TEST_START+NAND_TEST_LEN; 
			blkAddr++) 	// for one block
		{
			// erase
			NANDDPRINTF(11, "[NAND TEST] block(b:%05d) erase!!!\n", blkAddr);
			BlockErase(blkAddr);
			
			for(pageAddr = 0; pageAddr < 4; pageAddr++) // is large block
			{
				for(colAddr = 0; colAddr < (512+16); colAddr += (512+16)) // all page
				{
					NANDDPRINTF(11, "[NAND TEST] test nand(b:%05d, p:%05d, c:%05d)...\n"
								,blkAddr, pageAddr, colAddr);
					// program
					memset(buffer, 0, sizeof(buffer));
    				MakePattern(seed, (smtUint32)buffer, size);
					ret = PageProgram(colAddr, pageAddr, blkAddr,  
							(smtUint32)buffer, accessType[atIdx], size);
					if(ret)
					{
						NANDDPRINTF(11, "NANDRWTest::PageProgram(e)0x%08x\n", 
							ret);
						return false;
					}							
		
					// read and check pattern
					memset(buffer, 0, sizeof(buffer));
					ret = Read(colAddr, pageAddr, blkAddr, 
							(smtUint32)buffer, accessType[atIdx], size);
					if(ret)
					{
						NANDDPRINTF(11, "NANDRWTest::Read(e)0x%08x\n", 
							ret);
						return false;
					}									
							
					compareResult = CheckPattern(seed, (smtUint32)buffer, size);
					if(compareResult == false) 
					{
						NANDDPRINTF(11, "[NAND TEST] (%d) test fail!!!\n", atIdx);
						return false;
					}
					
					//HexDump((smtUint32)buffer, 512);
				}
			}
		}
	}
	NANDDPRINTF(11, "[NAND TEST] CPU read/write test done!!!\n");

	
	//--------------------------------------------------------------------------
	// 2. DMA read/write test for 1 Block
	//--------------------------------------------------------------------------
	NANDDPRINTF(11, "[NAND TEST] DMA read/write test start!!!\n");
	// set default setting
	NandDefaultSetting();
	
	// control control
	smtNANDGetControl(&nandCtrl);
	nandCtrl.DMAEn					= 0x1;
	smtNANDSetControl(&nandCtrl);
	for(atIdx = 0; atIdx < 3; atIdx++) 
	{
		NANDDPRINTF(11, "-------------------------------------------------------------\n");
		NANDDPRINTF(11, "[NAND TEST] DMA --%s!!!\n", accessTypeStr[atIdx]);
		NANDDPRINTF(11, "-------------------------------------------------------------\n");		
		
		for(blkAddr = NAND_TEST_START; 
			blkAddr < NAND_TEST_START+NAND_TEST_LEN; 
			blkAddr++) 	// for one block
		{
			// erase
			NANDDPRINTF(11, "[NAND TEST] block(b:%05d) erase!!!\n", blkAddr);
			BlockErase(blkAddr);
			
			for(pageAddr = 0; pageAddr < 4; pageAddr++) // is large block
			{
				for(colAddr = 0; colAddr < (512*1); colAddr += (512+16)) // all page
				{
					NANDDPRINTF(11, "[NAND TEST] test nand(b:%05d, p:%05d, c:%05d)...\n"
								,blkAddr, pageAddr, colAddr);
						
					// program
					memset(buffer, 0, sizeof(buffer));
	    			MakePattern(seed, (smtUint32)buffer, size);
					ret = PageProgramDMA(colAddr, pageAddr, blkAddr,  
							(smtUint32)buffer, accessType[atIdx], size);
					if(ret)
					{
						NANDDPRINTF(11, "NANDRWTest::PageProgramDMA(e)0x%08x\n", 
							ret);
						return false;
					}	
			
					// read and check pattern
					memset(buffer, 0, sizeof(buffer));
					ret = ReadDMA(colAddr, pageAddr, blkAddr, 
							(smtUint32)buffer, accessType[atIdx], size);
					if(ret)
					{
						NANDDPRINTF(11, "NANDRWTest::ReadDMA(e)0x%08x\n", 
							ret);
						return false;
					}	
							
					compareResult = CheckPattern(seed, (smtUint32)buffer, size);
					if(compareResult == false) 
					{
						return false;
					}
					
					//HexDump((smtUint32)buffer, 512);
				}
			}
		}
	}
	NANDDPRINTF(11, "[NAND TEST] DMA read/write test done!!!\n");
	//--------------------------------------------------------------------------
	// 3. CPU read/write test for 1 Block by interrupt
	//--------------------------------------------------------------------------	
	NANDDPRINTF(11, "[NAND TEST] interrupt test start!!!\n");
	
	// set default setting
	NandDefaultSetting();
	
	// control config
    smtNANDGetControl(&nandCtrl);
	nandCtrl.wrEndIntEn				= 0x1;
	nandCtrl.rdEndIntEn				= 0x1;
	nandCtrl.FIFOIntEn				= 0x1;
	nandCtrl.RnBintEn0				= 0x1;
	smtNANDSetControl(&nandCtrl);
	
	for(atIdx = 0; atIdx < 3; atIdx++) 
	{
		NANDDPRINTF(11, "-------------------------------------------------------------\n");
		NANDDPRINTF(11, "[NAND TEST] interrupt --%s!!!\n", accessTypeStr[atIdx]);
		NANDDPRINTF(11, "-------------------------------------------------------------\n");		
		
		for(blkAddr = NAND_TEST_START; 
			blkAddr < NAND_TEST_START+NAND_TEST_LEN; 
			blkAddr++) 	// for one block
		{
			// erase
			NANDDPRINTF(11, "[NAND TEST] block(b:%05d) erase!!!\n", blkAddr);
			BlockErase(blkAddr);
			
			for(pageAddr = 0; pageAddr < 4; pageAddr++) // is large block
			{
				for(colAddr = 0; colAddr < (512+16); colAddr += (512+16)) // all page
				{
					NANDDPRINTF(11, "[NAND TEST] test nand(b:%05d, p:%05d, c:%05d)...\n"
								,blkAddr, pageAddr, colAddr);
						
					// program
					memset(buffer, 0, sizeof(buffer));
	    			MakePattern(seed, (smtUint32)buffer, size);
					ret = PageProgramInt(colAddr, pageAddr, blkAddr,  
							(smtUint32)buffer, accessType[atIdx], size);
					if(ret)
					{
						NANDDPRINTF(11, "NANDRWTest::PageProgramInt(e)0x%08x\n", 
							ret);
						return false;
					}	
					
					// read and check pattern
					memset(buffer, 0, sizeof(buffer));
					ret = ReadInt(colAddr, pageAddr, blkAddr, 
							(smtUint32)buffer, accessType[atIdx], size);
					if(ret)
					{
						NANDDPRINTF(11, "NANDRWTest::ReadInt(e)0x%08x\n", 
							ret);
						return false;
					}	
							
					compareResult = CheckPattern(seed, (smtUint32)buffer, size);
					if(compareResult == false) 
					{
						return false;
					}
					
					//HexDump((smtUint32)buffer, 512);
				}
			}
		}
	}
	NANDDPRINTF(11, "[NAND TEST] interrupt read/write test!!!\n");		
	
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

	static smtUint32 	tmpBuffer[((512+16)*4)/4];
	
	smtUint32	tbi;
	smtUint32	tmpBufferSizeInByte;
	smtUint32	SWMainECC, SWSpareECC;
	smtUint32 	HWMainECC, HWSpareECC;
	smtUint32	AutoMainECC, AutoSpareECC;
	smtUint32	mainIdx, spareIdx;
	smtUint32	colAddr, pageAddr, blkAddr;
	smtUint32	ret;
	NAND_CTRL	nandCtrl;	
	smtUint32	eccSecSize;
	smtUint8	*pbuffer;
	
	pbuffer				= (smtUint8*)tmpBuffer;
	tmpBufferSizeInByte = (512+16)*4;
	
	
	//--------------------------------------------------------------------------
	// main/spare 256byte ECC test
	//--------------------------------------------------------------------------	
	NANDDPRINTF(11, "-------------------------------------------------------------\n");
	NANDDPRINTF(11, "[NAND TEST] main ECC 256 bytes test start!!!\n");
	NANDDPRINTF(11, "-------------------------------------------------------------\n");
	
	NandDefaultSetting();
	
	eccSecSize = 256;
	
	for(blkAddr = NAND_TEST_START; 
		blkAddr < NAND_TEST_START+NAND_TEST_LEN; 
		blkAddr++) 	// for one block
	{
		BlockErase(blkAddr);
		
		for(pageAddr = 0; pageAddr < 4; pageAddr++) // is large block
		{
			// Main area
			for(mainIdx = 0; mainIdx < 8; mainIdx++) 
			{
				// make pattern
				for(tbi = 0; tbi < eccSecSize; tbi++)
				{
					pbuffer[(eccSecSize*mainIdx)+tbi] = 0xff;	
				}
				
				// make test bits
				pbuffer[(eccSecSize*mainIdx)] ^= (1<<mainIdx);
			}
			
			// Spare area
			for(spareIdx = 0; spareIdx < 4; spareIdx++)
			{
				
				for(tbi = 0; tbi < 3; tbi++)
				{
					pbuffer[(eccSecSize*mainIdx)+(spareIdx*16)+2+tbi] = 0xee;	
				}
				
				// make test bits
				pbuffer[(eccSecSize*mainIdx)+(spareIdx*16)+2] ^= (1<<spareIdx);
			}
	
	
			NANDDPRINTF(11, "[NAND TEST] write ecc test(b:%05d, p:%05d, c:%05d)...\n"
								,blkAddr, pageAddr, 0);
			// program
			ret = PageProgram(0, pageAddr, blkAddr, 
					(smtUint32)tmpBuffer, OPCFG_TS_BYTE, tmpBufferSizeInByte);
			if(ret)
			{
				NANDDPRINTF(11, "NANDECCTest::PageProgram(e)0x%08x\n", 
					ret);
				return false;
			}
					
			// get main HW/SW ECC by Program
			for(mainIdx = 0; mainIdx < 8; mainIdx++) 
			{
				GetECC(mainIdx, &HWMainECC, 0);
				mu_ecc_generate_256((smtUint8*)&SWMainECC, 
						(smtUint8*)(&pbuffer[(eccSecSize*mainIdx)]));
				
				// compare with  SW ECC and HW ECC
				if(HWMainECC != SWMainECC) 
				{
					NANDDPRINTF(11, "error p[%d] sw:hw-0x%08x:0x%08x\n", 
						mainIdx, SWMainECC, HWMainECC);
					return false;
				}
			}
			
			
			// get Spare HW/SW ECC by Program
			for(spareIdx = 0; spareIdx < 4; spareIdx++)
			{
				
				GetECC(spareIdx, 0, &HWSpareECC);
				mu_ecc_generate_3((smtUint8*)&SWSpareECC, 
						(smtUint8*)(&pbuffer[(512*4)+(spareIdx*16)+2]));
						
				// compare with  SW ECC and HW ECC
				if((HWSpareECC&0xFFFF) != (SWSpareECC&0xFFFF)) 
				{
					NANDDPRINTF(11, "error sp[%d] hw:sw-0x%08x:0x%08x\n", 
						spareIdx, HWSpareECC, SWSpareECC);
					return false;
				}
			}
			
		
			
			NANDDPRINTF(11, "[NAND TEST]  read ecc test(b:%05d, p:%05d, c:%05d)...\n"
								,blkAddr, pageAddr, 0);
			
			// read
			ret = Read(0, pageAddr, blkAddr, 
				(smtUint32)tmpBuffer, OPCFG_TS_BYTE, tmpBufferSizeInByte);	
			if(ret)
			{
				NANDDPRINTF(11, "NANDECCTest::Read(e)0x%08x\n", 
					ret);
				return false;
			}		
			
			// get main HW/SW ECC by read
			for(mainIdx = 0; mainIdx < 8; mainIdx++) 
			{
				GetECC(mainIdx, &HWMainECC, 0);
				mu_ecc_generate_256((smtUint8*)&SWMainECC, 
						(smtUint8*)(&pbuffer[(eccSecSize*mainIdx)]));
				
				// compare with  SW ECC and HW ECC
				if(HWMainECC != SWMainECC) 
				{
					NANDDPRINTF(11, "error p[%d] sw:hw-0x%08x:0x%08x\n", 
						mainIdx, SWMainECC, HWMainECC);
					return false;
				}
			}			

			// get Spare HW/SW ECC by read
			for(spareIdx = 0; spareIdx < 4; spareIdx++)
			{
				
				GetECC(spareIdx, 0, &HWSpareECC);
				mu_ecc_generate_3((smtUint8*)&SWSpareECC, 
						(smtUint8*)(&pbuffer[(eccSecSize*mainIdx)+(spareIdx*16)+2]));
				
				// compare with  SW ECC and HW ECC
				if((HWSpareECC&0xFFFF) != (SWSpareECC&0xFFFF)) 
				{
					NANDDPRINTF(11, "error sp[%d] sw:hw-0x%08x:0x%08x\n", 
						spareIdx, HWSpareECC, SWSpareECC);
					return false;
				}
			}			

	
			
		}
	}
	NANDDPRINTF(11, "NANDECCTest::main 256byte ECC success!!!\n");	
	//--------------------------------------------------------------------------
	// main/spare 512byte ECC test
	//--------------------------------------------------------------------------

	NANDDPRINTF(11, "-------------------------------------------------------------\n");
	NANDDPRINTF(11, "[NAND TEST] main ECC 512 bytes test start!!!\n");
	NANDDPRINTF(11, "-------------------------------------------------------------\n");	
	
	NandDefaultSetting();
	smtNANDGetControl(&nandCtrl);
	nandCtrl.Ecc512byteEn		= 0x1;
	smtNANDSetControl(&nandCtrl);
	
	eccSecSize = 512;
	
	for(blkAddr = NAND_TEST_START; 
		blkAddr < NAND_TEST_START+NAND_TEST_LEN; 
		blkAddr++) 	// for one block
	{
		BlockErase(blkAddr);
		
		for(pageAddr = 0; pageAddr < 8; pageAddr++) // is large block
		{
			// Main area
			for(mainIdx = 0; mainIdx < 4; mainIdx++) 
			{
				// make pattern
				for(tbi = 0; tbi < eccSecSize; tbi++)
				{
					pbuffer[(eccSecSize*mainIdx)+tbi] = 0xee;	
				}
				
				// make test bits
				pbuffer[(eccSecSize*mainIdx)] ^= (1<<mainIdx);
			}
			
			// Spare area
			for(spareIdx = 0; spareIdx < 4; spareIdx++)
			{
				for(tbi = 0; tbi < 3; tbi++)
				{
					pbuffer[(eccSecSize*mainIdx)+(spareIdx*16)+2+tbi] = 0xee;	
				}
				
				// make test bits
				pbuffer[(eccSecSize*mainIdx)+(spareIdx*16)+2] ^= (1<<spareIdx);
			}
	
	
			NANDDPRINTF(11, "[NAND TEST] write ecc test(b:%05d, p:%05d, c:%05d)...\n"
								,blkAddr, pageAddr, 0);
			// program
			ret = PageProgram(0, pageAddr, blkAddr, 
					(smtUint32)tmpBuffer, OPCFG_TS_BYTE, tmpBufferSizeInByte);
			if(ret)
			{
				NANDDPRINTF(11, "NANDECCTest::PageProgram(e)0x%08x\n", 
					ret);
				return false;
			}
					
			// get main HW/SW ECC by Program
			for(mainIdx = 0; mainIdx < 4; mainIdx++) 
			{
				GetECC(mainIdx, &HWMainECC, 0);
				mu_ecc_generate_512((smtUint8*)&SWMainECC, 
						(smtUint8*)(&pbuffer[(eccSecSize*mainIdx)]));

				// compare with  SW ECC and HW ECC
				if(HWMainECC != SWMainECC) 
				{
					NANDDPRINTF(11, "error p[%d] sw:hw-0x%08x:0x%08x\n", 
						mainIdx, SWMainECC, HWMainECC);
					return false;
				}
			}
	
			// get Spare HW/SW ECC by Program
			for(spareIdx = 0; spareIdx < 4; spareIdx++)
			{
				
				GetECC(spareIdx, 0, &HWSpareECC);
				mu_ecc_generate_3((smtUint8*)&SWSpareECC, 
						(smtUint8*)(&pbuffer[(eccSecSize*mainIdx)+(spareIdx*16)+2]));
				
				
				// compare with  SW ECC and HW ECC
				if((HWSpareECC&0xFFFF) != (SWSpareECC&0xFFFF)) 
				{
					NANDDPRINTF(11, "error p[%d] sw:hw-0x%08x:0x%08x\n", 
						mainIdx, HWSpareECC, SWSpareECC);
					return false;
				}
			}

			NANDDPRINTF(11, "[NAND TEST]  read ecc test(b:%05d, p:%05d, c:%05d)...\n"
								,blkAddr, pageAddr, 0);
			
			
			// read
			ret = Read(0, pageAddr, blkAddr, 
				(smtUint32)tmpBuffer, OPCFG_TS_BYTE, tmpBufferSizeInByte);
			if(ret)
			{
				NANDDPRINTF(11, "NANDECCTest::Read(e)0x%08x\n", 
					ret);
				return false;
			}
				
			// get main HW/SW ECC by read
			for(mainIdx = 0; mainIdx < 4; mainIdx++) 
			{
				GetECC(mainIdx, &HWMainECC, 0);
				mu_ecc_generate_512((smtUint8*)&SWMainECC, 
						(smtUint8*)(&pbuffer[(eccSecSize*mainIdx)]));
	
				
				// compare with  SW ECC and HW ECC
				if(HWMainECC != SWMainECC) 
				{
					NANDDPRINTF(11, "error p[%d] sw:hw-0x%08x:0x%08x\n", 
						mainIdx, SWMainECC, HWMainECC);
					return false;
				}
			}			
			// get Spare HW/SW ECC by read
			for(spareIdx = 0; spareIdx < 4; spareIdx++)
			{
				
				GetECC(spareIdx, 0, &HWSpareECC);
				mu_ecc_generate_3((smtUint8*)&SWSpareECC, 
						(smtUint8*)(&pbuffer[(eccSecSize*mainIdx)+(spareIdx*16)+2]));
				
				// compare with  SW ECC and HW ECC
				if((HWSpareECC&0xFFFF) != (SWSpareECC&0xFFFF)) 
				{
					NANDDPRINTF(11, "error p[%d] sw:hw-0x%08x:0x%08x\n", 
						mainIdx, HWSpareECC, SWSpareECC);
					return false;
				}
			}				
		}
	}
	
	NANDDPRINTF(11, "NANDECCTest::main 512byte ECC success!!!\n");	

	
	
	//--------------------------------------------------------------------------
	// main/spare ECC auto write test
	//--------------------------------------------------------------------------	
	NANDDPRINTF(11, "-------------------------------------------------------------\n");
	NANDDPRINTF(11, "[NAND TEST] main/spare ECC auto write test start!!!\n");
	NANDDPRINTF(11, "-------------------------------------------------------------\n");
	
	NandDefaultSetting();
	
	
	smtNANDGetControl(&nandCtrl);
	nandCtrl.autoEccWr		= 0x1;
	smtNANDSetControl(&nandCtrl);
	
	eccSecSize = 256;
	
	for(blkAddr = NAND_TEST_START; 
		blkAddr < NAND_TEST_START+NAND_TEST_LEN; 
		blkAddr++) 	// for one block
	{
		BlockErase(blkAddr);
		
		for(pageAddr = 0; pageAddr < 4; pageAddr++) // is large block
		{
			// Main area
			for(mainIdx = 0; mainIdx < 8; mainIdx++) 
			{
				// make pattern
				for(tbi = 0; tbi < eccSecSize; tbi++)
				{
					pbuffer[(eccSecSize*mainIdx)+tbi] = 0xff;	
				}
				
				// make test bits
				pbuffer[(eccSecSize*mainIdx)] ^= (1<<mainIdx);
			}
			
			// Spare area
			for(spareIdx = 0; spareIdx < 4; spareIdx++)
			{
				for(tbi = 0; tbi < 16; tbi++)
				{
					pbuffer[(512*4)+(spareIdx*16)+tbi] = 0xee;	
				}
				
				// make test bits
				pbuffer[(eccSecSize*mainIdx)+(spareIdx*16)+2] ^= (1<<spareIdx);
			}
	
			NANDDPRINTF(11, "[NAND TEST] auto write ecc test(b:%05d, p:%05d, c:%05d)...\n"
								,blkAddr, pageAddr, 0);
			// program
			ret = PageProgram(0, pageAddr, blkAddr, 
					(smtUint32)pbuffer, OPCFG_TS_BYTE, tmpBufferSizeInByte);
			if(ret)
			{
				NANDDPRINTF(11, "NANDECCTest::PageProgram(e)0x%08x\n", 
					ret);
				return false;
			}
					
			ret = Read(0, pageAddr, blkAddr, 
					(smtUint32)pbuffer, OPCFG_TS_BYTE, tmpBufferSizeInByte);
			if(ret)
			{
				NANDDPRINTF(11, "NANDECCTest::Read(e)0x%08x\n", 
					ret);
				return false;
			}
					
			// get main HW/SW ECC by Program
			for(mainIdx = 0; mainIdx < 8; mainIdx++) 
			{
				GetECC(mainIdx, &HWMainECC, 0);
				
				mu_ecc_generate_256((smtUint8*)&SWMainECC, 
						(smtUint8*)(&pbuffer[(eccSecSize*mainIdx)]));
						
				AutoMainECC = 
						(((pbuffer[(512*4)+2+8+(mainIdx/2)*16+5*(mainIdx%2)]) << 16)
						|((pbuffer[(512*4)+1+8+(mainIdx/2)*16+5*(mainIdx%2)]) <<  8)
						|((pbuffer[(512*4)+0+8+(mainIdx/2)*16+5*(mainIdx%2)]) <<  0));

	
				// compare with  SW ECC and HW ECC
				if(HWMainECC != AutoMainECC) 
				{
					NANDDPRINTF(11, "error p[%d] sw:hw:au-0x%08x:0x%08x:0x%08x\n", 
						mainIdx, SWMainECC, HWMainECC, AutoMainECC);
					return false;
				}
			}
			
			
			// get Spare HW/SW ECC by Program
			for(spareIdx = 0; spareIdx < 4; spareIdx++)
			{
				
				GetECC(spareIdx, 0, &HWSpareECC);
				mu_ecc_generate_3((smtUint8*)&SWSpareECC, 
						(smtUint8*)(&pbuffer[(512*4)+(spareIdx*16)+2]));
				
				
				// compare with  SW ECC and HW ECC
				if((HWSpareECC&0xFFFF) != (SWSpareECC&0xFFFF)) 
				{
					NANDDPRINTF(11, "error p[%d] sw:hw:au-0x%08x:0x%08x\n", 
						mainIdx, HWSpareECC, SWSpareECC);
					return false;
				}
			}
			
			
				
		}
	}
	NANDDPRINTF(11, "NANDECCTest::main auto write ECC success!!!\n");	

	
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
	
	NANDDPRINTF(11, "+NANDTest\n"); 
	
	
	
	//-------------------------------------------------------------------------- 
	//	1. Check NAND identify code
	//--------------------------------------------------------------------------
	NandDefaultSetting();
	
	result = ReadID(idCode);
	if(result)
	{
		NANDDPRINTF(11, "NANDTest::NAND READ ID fail!!!\n");
		return FMC_ERROR;
	}
	NANDDPRINTF(11, "-------------------------------------------------------------\n");
	NANDDPRINTF(11, " Nand ID Read \n");
	NANDDPRINTF(11, "-------------------------------------------------------------\n");
	NANDDPRINTF(11, "NANDTest::Nand 1st ID : 0x%02X\n",idCode[0]);
	NANDDPRINTF(11, "NANDTest::Nand 2nd ID : 0x%02X\n",idCode[1]);
	NANDDPRINTF(11, "NANDTest::Nand 3rd ID : 0x%02X\n",idCode[2]);
	NANDDPRINTF(11, "NANDTest::Nand 4th ID : 0x%02X\n",idCode[3]);
    NANDDPRINTF(11, "NANDTest::Nand 5th ID : 0x%02X\n",idCode[4]);    
    
    
    //--------------------------------------------------------------------------
	// 	2. NAND read/write
	//		- CPU read/write
	//		- DMA read/write
	//		- interrupt read/write
	//--------------------------------------------------------------------------
	result = NANDRWTest();
	if(result == false)
	{
		NANDDPRINTF(11, "NANDTest::NAND read/write test fail!!!\n");
		return FMC_ERROR;
	}
	NANDDPRINTF(11, "NANDTest::NAND read/write test success!!!\n");
	
	
	//--------------------------------------------------------------------------
	//	3. ecc test
	//		- main ecc 	
	//		- spare ecc	later time
	//--------------------------------------------------------------------------
	result = NANDECCTest();
	if(result == false)
	{
		NANDDPRINTF(11, "NANDTest::NAND ECC test fail!!!\n");
		return FMC_ERROR;
	}
	NANDDPRINTF(11, "NANDTest::NAND ECC test success!!!\n");

	return NO_ERROR;
}
/*-----------------------------------------------------------------------
    Function name   : NANDU_Open
    Prototype       : 
    Return          : 
    Argument        : 
    Comments        : 
-----------------------------------------------------------------------*/	
smtBoolean NANDU_Open(void)
{
	smtUint32	id[5];
	NAND_CTRL	nandCtrl;
	
	// NAND controller init
	NandDefaultSetting();
	
	// NAND cell reset
	Reset();
	
	// NAND read ID
	ReadID(id);
	
	// set DMA
	smtNANDGetControl(&nandCtrl);
	nandCtrl.DMAEn					= 0x1;
	smtNANDSetControl(&nandCtrl);
	
}
/*-----------------------------------------------------------------------
    Function name   : NANDU_Close
    Prototype       : 
    Return          : 
    Argument        : 
    Comments        : 
-----------------------------------------------------------------------*/		
smtBoolean NANDU_Close(void)
{
	// No operation
}			
/*-----------------------------------------------------------------------
    Function name   : NANDU_128kWriter
    Prototype       : 
    Return          : 
    Argument        : 
    Comments        : 
-----------------------------------------------------------------------*/		
smtBoolean	NANDU_128kWriter(smtUint32 addr128k, smtUint32 buffer)
{
	smtUint32	pageIdx;
	smtUint32	blockIdx;
	smtUint32	offset;
	smtUint32	ret;
	static NAND_STAT	nandStatus;
	static NAND_CTRL	nandCtrl;	
	

	// get index
	blockIdx = addr128k;
	
	//NANDDPRINTF(11, "NANDU_128kWriter::Write block: %04d\n", blockIdx);
		
	// erase block 
	ret = BlockErase(blockIdx);
	if(ret)
	{
		NANDDPRINTF(11, "NANDU_128kWriter::BlockErase(e))x%08x\n", ret);
		return false;
	}
	
	// write 64 page program
	for(pageIdx = 0; pageIdx < 64; pageIdx++)
	{
    	offset 	= pageIdx*2048;
		ret 	= PageProgramDMA(0,  pageIdx, blockIdx, buffer+offset, OPCFG_TS_WORD, 2048);
		if(ret)
		{
			NANDDPRINTF(11, "NANDU_128kWriter::PageProgramDMA(e))x%08x\n", ret);
			return false;
		}		
		
	}
	
	return true;
	
}
/*-----------------------------------------------------------------------
    Function name   : NANDU_128kReader
    Prototype       : 
    Return          : 
    Argument        : 
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean	NANDU_128kReader(smtUint32 addr128k, smtUint32 buffer)
{
	smtUint32	pageIdx;
	smtUint32	offset;
	smtUint32	blockIdx;
	smtUint32	ret;
	NAND_STAT	nandStatus;
	NAND_CTRL	nandCtrl;	
	
	
	// get index
	blockIdx = addr128k;	
	
	//NANDDPRINTF(11, "NANDU_128kWriter::Read block: %04d\n", blockIdx);	
	
	// read 64 page 
	for(pageIdx = 0; pageIdx < 64; pageIdx++)
	{
		offset 	= pageIdx*2048;
		ret		= ReadDMA(0, pageIdx, blockIdx, buffer+offset, OPCFG_TS_WORD, 2048);
		if(ret)
		{
			NANDDPRINTF(11, "NANDU_128kReader::ReadDMA(e))x%08x\n", ret);
			return false;
		}	
	}
	
	return true;
}
