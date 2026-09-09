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
//#include "global.h"
#include "nand.h"
#include "k9lag08u0m.h"
#include "lib.h"
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

//
//	Time out
//
#define	NANDT_TO_RDREADY				(0x7FFFF)
#define	NANDT_TO_RDEND					(0x7FFFF)
#define	NANDT_TO_RDRNB					(0x7FFFF)
#define	NANDT_TO_WRREADY				(0x7FFFF)
#define	NANDT_TO_WREND					(0x7FFFF)
#define	NANDT_TO_WR_DATA_LD				(0x7FFFF)
#define	NANDT_TO_WRRNB					(0x7FFFF)
#define	NANDT_TO_STATUSVALID			(0x7FFFF)
#define NANDT_TO_INTLVE_WREND			(0x7FFFF)
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

//
// NAND Test config
//
#define NAND_TEST_START					(16)
#define NAND_TEST_LEN					(4)

#define NAND_TEST_CHIP_SEL				(0)
#define NAND_TEST_MAX_CHIP_SEL			(4)

#define NANDDPRINTF	printf
#define CFG_UART_CH 0

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
//extern void 	DCacheFlushing(void);
//extern smtUint8	mu_ecc_generate_256(smtUint8 *eccbuf, smtUint8 *datbuf);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

static volatile smtBoolean	gNANDRdReady 	= 0;
static volatile smtBoolean	gNANDRdEnd	 	= 0;
static volatile smtBoolean	gNANDRdRnB	 	= 0;

static volatile smtBoolean	gNANDWrReady 	= 0;
static volatile smtBoolean	gNANDWrEnd 		= 0;
static volatile smtBoolean	gNANDWrRnB 		= 0;
static volatile NandChannel gNandCh;
static volatile smtBoolean	gIntlveMode		= 0;
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
	static NandStat	nandStatus;
	irq = 0;//prevent compile warnnig
	smtNANDGetStatus(gNandCh, &nandStatus);
	if(nandStatus.RnBDetect0)
	{	
		memset(&nandStatus, 0, sizeof(NandStat));
		nandStatus.RnBDetect0 = 0x1;
		smtNANDSetStatus(gNandCh, &nandStatus);
		gNANDRdRnB = 1;
	}
	
	smtNANDGetStatus(gNandCh, &nandStatus);
	if(nandStatus.rdFIFOReady)
	{
		gNANDRdReady = 1;
	}
	
	smtNANDGetStatus(gNandCh, &nandStatus);
	if(nandStatus.rdEnd)
	{
	
		memset(&nandStatus, 0, sizeof(NandStat));
		nandStatus.rdEnd = 0x1;
		smtNANDSetStatus(gNandCh, &nandStatus);

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
	static NandStat nandStatus;
	irq = 0;//prevent compile warnnig
	smtNANDGetStatus(gNandCh, &nandStatus);
	if(nandStatus.wrFIFOReady)
	{
		gNANDWrReady = 1;
	}
	
	smtNANDGetStatus(gNandCh, &nandStatus);
	if(nandStatus.wrEnd)
	{
		memset(&nandStatus, 0, sizeof(nandStatus));
		nandStatus.wrEnd 		= 0x1;
		smtNANDSetStatus(gNandCh, &nandStatus);
		
		gNANDWrEnd = 1;
	}	
	
	smtNANDGetStatus(gNandCh, &nandStatus);
	if(nandStatus.RnBDetect0)
	{
		memset(&nandStatus, 0, sizeof(NandStat));
		nandStatus.RnBDetect0 = 0x1;
		smtNANDSetStatus(gNandCh, &nandStatus);
		
		gNANDWrRnB = 1;
	}	

	
}
/*----------------------------------------------------------
	Function name	: MakePattern
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean MakePattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
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
smtBoolean CheckPattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
{
	smtUint32 	i;//, j;
	smtUint32	pattern;
	smtUint32	*pbuffer = (smtUint32*)buffer;
	for(i = 0; i < size/4; i++)
	{
		
		pattern = (seed | i);
		if(pbuffer[i] != pattern)
		{
			NANDDPRINTF("error 0x%08x:0x%08x\n", 
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
		NANDDPRINTF("0x%08x : ", &pbuffer[i*16+j]);
		for(j = 0; j < 16; j++) 
		 	NANDDPRINTF("%02x ", pbuffer[i*16+j]);
		 
		NANDDPRINTF(" | ");
		 
		for(j = 0; j < 16; j++) 
		{
			if( (pbuffer[i*16+j] >= 0x00)
			 && (pbuffer[i*16+j] <= 0x1F))
				NANDDPRINTF(" ");
		 	else
				NANDDPRINTF("%c", pbuffer[i*16+j]);
		}
		
		NANDDPRINTF("\n");
		
	}	
	NANDDPRINTF("\n");
}

/*----------------------------------------------------------
	Function name	: NandDefaultSetting
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void NandDefaultSetting(NandChannel ch)
{
	NandCfg		nandCfg;
	NandCtrl	nandCtrl;	

	// init nand controller
	nandCfg.nandBootEn		= NANDT_CFG_NANDBOOTEN;
	nandCfg.IOWidth			= NANDT_CFG_IOWIDTH;
	nandCfg.bootCfg			= NANDT_CFG_BOOTCFG;
	nandCfg.OutDtmn			= NANDT_CFG_OUTDTMN;
	nandCfg.TADLTWB			= NANDT_CFG_TADLTWB;
	nandCfg.TCALS			= NANDT_CFG_TACLS;
	nandCfg.TRWLP			= NANDT_CFG_TRWLP;
	nandCfg.TRWHP			= NANDT_CFG_TRWHP;
	smtNANDSetCfg(ch, &nandCfg);	

	nandCtrl.NFCtrlRst		= 0x1;
	nandCtrl.FIFOLevel		= NANDT_CTRL_FIFOLEV;
	nandCtrl.Ecc512byteEn	= 0x0;
	nandCtrl.autoEccWr		= 0x0;
	nandCtrl.DMAEn			= 0x0;
	nandCtrl.wrEndIntEn		= 0x0;
	nandCtrl.rdEndIntEn		= 0x0;
	nandCtrl.FIFOIntEn		= 0x0;
	nandCtrl.RnBintEn3		= 0x0;
	nandCtrl.RnBintEn2		= 0x0;
	nandCtrl.RnBintEn1		= 0x0;
	nandCtrl.RnBintEn0		= 0x0;	
	smtNANDSetControl(ch, &nandCtrl);	
}
/*-----------------------------------------------------------
    Function name   : Reset
    Prototype       : smtUint32 Reset(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtUint32 Reset(NandChannel ch, smtUint8 chipSel )
{
    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandStat	nandStatus;
    smtUint32	errorCode;
    
    // 
    errorCode = NANDT_EC_NONE;   
   
    // operation configure
    nandOpConfig.chipSel			= chipSel;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= 0x0	;
    nandOpConfig.opMode				= OPCFG_OPR_NOP;
    nandOpConfig.TransSize			= OPCFG_TS_WORD;
    nandOpConfig.cmdAddrTransByte	= CS_RESETCMD;				
    nandOpConfig.cmdAddrFlag		= CB_RESETCMD;				
    smtNANDSetOPT0(ch, &nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_RESETCMD;	
    smtNANDSetOPT1(ch, &nandCmdAddr0);
     
    smtNANDGetStatus(ch, &nandStatus);
    smtNANDSetStatus(ch, &nandStatus);   
     
    return errorCode;
}
/*----------------------------------------------------------
	Function name	: ReadID()
	Prototype		: smtUint32 ReadID(smtUint8 id[5])
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 ReadID(NandChannel ch, smtUint8 chipSel, smtUint8 id[5])
{

    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr;
    NandStat	nandStatus;
    smtUint32	timeOut;
    smtUint32	errorCode;

    // 
    errorCode = NANDT_EC_NONE;
    
    // operation configure
    nandOpConfig.chipSel			= chipSel;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= 0x05;
    nandOpConfig.opMode				= OPCFG_OPR_READID;
    nandOpConfig.TransSize			= OPCFG_TS_BYTE;
    nandOpConfig.cmdAddrTransByte	= CS_RDIDCMD;
    nandOpConfig.cmdAddrFlag		= CB_RDIDCMD;
    smtNANDSetOPT0(ch, &nandOpConfig);
    
    // send command
    nandCmdAddr.CMDADDR[0]			= CC_RDIDCMD;
    nandCmdAddr.CMDADDR[1]			= 0x00;
    smtNANDSetOPT1(ch, &nandCmdAddr);
    
    timeOut = 0;
	while(true)
	{		
		smtNANDGetStatus(ch, &nandStatus);
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
	
    NANDDPRINTF("ReadID:: get NAND ID code data\n");
    // get NAND ID code data
	smtNANDGetDataByte(ch, &id[0]);
    smtNANDGetDataByte(ch, &id[1]);
    smtNANDGetDataByte(ch, &id[2]);
    smtNANDGetDataByte(ch, &id[3]);
    smtNANDGetDataByte(ch, &id[4]);
    
    NANDDPRINTF("ID code: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
    	id[0], id[1], id[2], id[3], id[4]);
 
    
  	NANDDPRINTF("-ReadID\n");
  
Error:
	smtNANDGetStatus(ch, &nandStatus);
    smtNANDSetStatus(ch, &nandStatus);
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
smtUint32 Read(NandChannel ch, smtUint8 chipSel, smtUint16 colAddr, smtUint16 pageAddr, 
				smtUint16 blockAddr, smtUint32 ppagebuf, smtUint8 transSize, smtUint32 sizeInByte)
{
    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandOpt2	nandCmdAddr1;
    NandStat	nandStatus;    
    smtUint32	timeOut;
    smtUint32	errorCode;
    smtUint8	tmp;
	smtUint16	tmpHWD;
    smtUint32	wi, bi, *ptrg, tmpData;
    
    // 
    errorCode = NANDT_EC_NONE;

    // operation configure
    nandOpConfig.chipSel			= chipSel;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA; 
    nandOpConfig.TransSize			= transSize; 			
    nandOpConfig.cmdAddrTransByte	= CS_PAGERDCMD;			
    nandOpConfig.cmdAddrFlag		= CB_PAGERDCMD;			
    smtNANDSetOPT0(ch, &nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGERDCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(ch, &nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGERDCMD1;					// second command
    smtNANDSetOPT2(ch, &nandCmdAddr1);
    

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
						smtNANDGetStatus(ch, &nandStatus);
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
       			
       			smtNANDGetDataByte(ch, &tmp);
    			tmpData	|= ((tmp&0xFF)<<(8*bi));
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
						smtNANDGetStatus(ch, &nandStatus);
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
       			
       			smtNANDGetDataHalfWD(ch, &tmpHWD);
    			tmpData	|= ((tmpHWD&0xFFFF)<<(16*bi));
    		}    		
    		break;
    	}
        *ptrg++ = tmpData;
    }    

Error:
	smtNANDGetStatus(ch, &nandStatus);
    smtNANDSetStatus(ch, &nandStatus);
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
smtUint32 ReadInt(NandChannel ch, smtUint8 chipSel, smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint8 transSize, smtUint32 sizeInByte)
{
    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandOpt2	nandCmdAddr1;  
    NandStat	nandStatus;
    smtUint32	wi, bi, *ptrg, tmpData;
    smtUint32	errorCode;
    smtUint32	timeOut;
    smtUint8	tmp;
	smtUint16	tmpHWD;

     // 
    errorCode = NANDT_EC_NONE;

    // operation configure
    nandOpConfig.chipSel			= chipSel;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_READDATA; 
    nandOpConfig.TransSize			= transSize; 			
    nandOpConfig.cmdAddrTransByte	= CS_PAGERDCMD;			
    nandOpConfig.cmdAddrFlag		= CB_PAGERDCMD;			
    smtNANDSetOPT0(ch, &nandOpConfig);
    
    
	#if 1
	// configure interrupt
	#else
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(IRQ_NAND, NANDRdIntHandler);
	gNANDRdRnB		= 0;
	gNANDRdReady 	= 0;
	gNANDRdEnd		= 0;
	Enable_IRQ();
	#endif
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_PAGERDCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(ch, &nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGERDCMD1;					// second command
    smtNANDSetOPT2(ch, &nandCmdAddr1);
    
	// check rnb
	timeOut = 0;
	while(true)
	{
		if(gNANDRdRnB) 
		{
			//NANDDPRINTF("check RnB detected!!!\n");
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
       			
       			smtNANDGetDataByte(ch, &tmp);
    			tmpData	|= ((tmp&0xFF)<<(8*bi));
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
       			
       			smtNANDGetDataHalfWD(ch, &tmpHWD);
    			tmpData	|= ((tmpHWD&0xFFFF)<<(16*bi));
    		}    		
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
			//NANDDPRINTF("Read end interrupt!!!\n");
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

	#if 1
	// disable interrupt
	#else
	ReleaseIRQ(IRQ_NAND);	
	#endif
	smtNANDGetStatus(ch, &nandStatus);
    smtNANDSetStatus(ch, &nandStatus);
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
smtUint32 PageProgram(NandChannel ch, smtUint8 chipSel,smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 transSize, smtUint32 sizeInByte)
{
    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandOpt2	nandCmdAddr1;
    NandStat	nandStatus;  
    smtUint32	timeOut;
    smtUint32	errorCode;
    smtUint32	wi, bi, *psrc;
	smtUint8	tmpDataB;
	smtUint16	tmpDataHWD;
    
    //
    errorCode = NANDT_EC_NONE;        

    // operation configure
    nandOpConfig.chipSel			= chipSel;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_WRITEDATA;
    nandOpConfig.TransSize			= transSize;						
    nandOpConfig.cmdAddrTransByte	= CS_PAGEWRCMD+1;					
    nandOpConfig.cmdAddrFlag		= CB_PAGEWRCMD;						
    smtNANDSetOPT0(ch, &nandOpConfig);
    
    // send command and address
    nandCmdAddr0.CMDADDR[0]			= CC_PAGEWRCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(ch, &nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGEWRCMD1;					// second command
    smtNANDSetOPT2(ch, &nandCmdAddr1);
   
	
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
						smtNANDGetStatus(ch, &nandStatus);
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
				
    			tmpDataB	= (smtUint8)(*psrc>>(8*bi)&0xFF);
    			smtNANDSetDataByte(ch, &tmpDataB);	  
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
						smtNANDGetStatus(ch, &nandStatus);
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
       			
    			tmpDataHWD	= (smtUint16)(*psrc>>(16*bi)&0xFFFF);
    			smtNANDSetDataHalfWD(ch, &tmpDataHWD);	       			
    		}    	
    		psrc++;
    		break;
    	}
    }     
    
    // check write status
    if(gIntlveMode)
    {
		//check status bit(ready and busy)
		while(1)
		{
			smtNANDGetStatus(ch,&nandStatus);
			if(nandStatus.wrEnd)
			{
				memset(&nandStatus, 0, sizeof(nandStatus));
				nandStatus.wrEnd = 1;
				smtNANDSetStatus(ch,&nandStatus);
				break;
			}
			if(timeOut++ == NANDT_TO_WR_DATA_LD)
				goto Error;
		}
    }
	else
    {
	    timeOut = 0;
	    while(true)
	    {
	    	smtNANDGetStatus(ch, &nandStatus);
	    	if(nandStatus.NFStatValid) 
	    	{
				//NANDDPRINTF("status: 0x%02x\n", nandStatus.NFStatus);
				memset(&nandStatus, 0, sizeof(nandStatus));
				nandStatus.NFStatValid = 1;
				smtNANDSetStatus(ch, &nandStatus);
	    		break;
	    	}
	    	
	    	if(timeOut++ == NANDT_TO_WREND)
	    	{
	    		errorCode = NANDT_EC_WREND;
	    		goto Error;
	    	}
	    }
    }
    return errorCode;
Error:
	
	smtNANDGetStatus(ch, &nandStatus);
    smtNANDSetStatus(ch, &nandStatus);
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
smtUint32 PageProgramInt(NandChannel ch, smtUint8 chipSel, smtUint16 colAddr, smtUint16 pageAddr, smtUint16 blockAddr, 
		smtUint32 ppagebuf, smtUint32 transSize, smtUint32 sizeInByte)
{
    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandOpt2	nandCmdAddr1;
    NandStat	nandStatus;  
    smtUint32	timeOut;
    smtUint32	errorCode;
    smtUint32	wi, bi, *psrc;
	smtUint8	tmpDataB;
	smtUint16	tmpDataHWD;
    
    // 
    errorCode = NANDT_EC_NONE;  
   
    // operation configure
    nandOpConfig.chipSel			= chipSel;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= sizeInByte;
    nandOpConfig.opMode				= OPCFG_OPR_WRITEDATA;
    nandOpConfig.TransSize			= transSize;						
    nandOpConfig.cmdAddrTransByte	= CS_PAGEWRCMD+1;					
    nandOpConfig.cmdAddrFlag		= CB_PAGEWRCMD;						
    smtNANDSetOPT0(ch, &nandOpConfig);

	#if 1
    // configure interrupt
    #else
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(IRQ_NAND, NANDWrIntHandler);
	gNANDWrRnB		= 0;
	gNANDWrReady 	= 0;
	gNANDWrEnd		= 0;
	Enable_IRQ();
	#endif
    
    // send command and address
    nandCmdAddr0.CMDADDR[0]			= CC_PAGEWRCMD0;					// first command
    nandCmdAddr0.CMDADDR[1]			= ADDRESS0(colAddr);				// address 0
    nandCmdAddr0.CMDADDR[2]			= ADDRESS1(colAddr);				// address 1
    nandCmdAddr0.CMDADDR[3]			= ADDRESS2(pageAddr, blockAddr);	// address 2
    smtNANDSetOPT1(ch, &nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= ADDRESS3(blockAddr);				// address 3
    nandCmdAddr1.CMDADDR[1]			= ADDRESS4(blockAddr);				// address 4
    nandCmdAddr1.CMDADDR[2]			= CC_PAGEWRCMD1;					// second command
    smtNANDSetOPT2(ch, &nandCmdAddr1);
    
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
				
    			tmpDataB = (smtUint8)(*psrc>>(8*bi)&0xFF);
    			smtNANDSetDataByte(ch, &tmpDataB);	  
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
       			
    			tmpDataHWD	= (smtUint16)(*psrc>>(16*bi)&0xFFFF);
    			smtNANDSetDataHalfWD(ch, &tmpDataHWD);	       			
    		}    	
    		psrc++;
    		break;
    	}
    }     
    
    // check write status
    timeOut = 0;
    while(true)
    {
    	smtNANDGetStatus(ch, &nandStatus);
    	if(nandStatus.NFStatValid) 
    	{
			memset(&nandStatus, 0, sizeof(nandStatus));
			nandStatus.NFStatValid = 0x1;
			smtNANDSetStatus(ch, &nandStatus);
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
	smtNANDGetStatus(ch, &nandStatus);
    smtNANDSetStatus(ch, &nandStatus);
    
	return errorCode;          
    
}
/*-----------------------------------------------------------
    Function name   : BlockErase
    Prototype       : smtUint32 BlockErase(smtUint32 blockAddr)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
smtUint32 BlockErase(NandChannel ch, smtUint8 chipSel, smtUint32 blockAddr)
{
    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandOpt2	nandCmdAddr1;
    NandStat	nandStatus;  	
    smtUint32	timeOut;
    smtUint32	errorCode;
    
    // 
    errorCode = NANDT_EC_NONE;

    // operation configure
    nandOpConfig.chipSel			= chipSel;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= 0x0;
    nandOpConfig.opMode				= OPCFG_OPR_NOP;
    nandOpConfig.TransSize			= OPCFG_TS_WORD;
    nandOpConfig.cmdAddrTransByte	= CS_BERASECMD+1;	
    nandOpConfig.cmdAddrFlag		= CB_BERASECMD;		
    smtNANDSetOPT0(ch, &nandOpConfig);
    
    // send command 
    nandCmdAddr0.CMDADDR[0]			= CC_BERASECMD0;
    nandCmdAddr0.CMDADDR[1]			= ADDRESS2(0, blockAddr);	
    nandCmdAddr0.CMDADDR[2]			= ADDRESS3(blockAddr);
    nandCmdAddr0.CMDADDR[3]			= ADDRESS4(blockAddr);
    smtNANDSetOPT1(ch, &nandCmdAddr0);
    nandCmdAddr1.CMDADDR[0]			= CC_BERASECMD1;
    nandCmdAddr1.CMDADDR[1]			= CC_RDSTATCMD0;
    smtNANDSetOPT2(ch, &nandCmdAddr1);
    
    
	// check write status
	timeOut = 0;
    while(1) 
	{
		smtNANDGetStatus(ch, &nandStatus);
		if(nandStatus.NFStatValid)
		{
			smtNANDSetStatus(ch, &nandStatus);
    		break;
    	}
    	
    	if(timeOut++ == NANDT_TO_STATUSVALID)
    	{
    		errorCode = NANDT_EC_STATUSVALID;
    		goto Error;
    	}
    }

Error:    
	
	smtNANDGetStatus(ch, &nandStatus);
    smtNANDSetStatus(ch, &nandStatus);
    return errorCode;
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
	NandCtrl	nandCtrl;	
	NandChannel nandCh;
	smtUint32	accessType[] 		
		= {OPCFG_TS_BYTE, OPCFG_TS_HWORD};
	static char	accessTypeStr[][80] 
		= {"OPCFG_TS_BYTE", "OPCFG_TS_HWORD"};
	//--------------------------------------------------------------------------
	// 1. CPU read/write test for 1 Block
	//--------------------------------------------------------------------------	
	NANDDPRINTF("[NAND TEST] CPU read/write test start!!!\n");
	for(nandCh = NAND_CH0 ; nandCh < NAND_CH_MAX; nandCh++)
	{
		// set default setting
		NandDefaultSetting(nandCh);
		
		for(atIdx = 1; atIdx < 2; atIdx++) 
		{
			NANDDPRINTF("-------------------------------------------------------------\n");
			NANDDPRINTF("[NAND TEST] CPU --%s!!!\n", accessTypeStr[atIdx]);
			NANDDPRINTF("-------------------------------------------------------------\n");
			
			for(blkAddr = NAND_TEST_START; 
				blkAddr < NAND_TEST_START+NAND_TEST_LEN; 
				blkAddr++) 	// for one block
			{
				// erase
				NANDDPRINTF("[NAND TEST] block(b:%05d) erase!!!\n", blkAddr);
				BlockErase(nandCh, NAND_TEST_CHIP_SEL, blkAddr);
				
				for(pageAddr = 0; pageAddr < 4; pageAddr++) // is large block
				{
					for(colAddr = 0; colAddr < (512+16); colAddr += (512+16)) // all page
					{
						NANDDPRINTF("[NAND TEST] test nand(b:%05d, p:%05d, c:%05d)...\n"
									,blkAddr, pageAddr, colAddr);
						// program
						memset(buffer, 0, sizeof(buffer));
	    				MakePattern(seed, (smtUint32)buffer, size);
						ret = PageProgram(nandCh, NAND_TEST_CHIP_SEL, 
								colAddr,  pageAddr, blkAddr,  
								(smtUint32)buffer, accessType[atIdx], size);
						if(ret)
						{
							NANDDPRINTF("NANDRWTest::PageProgram(e)0x%08x\n", 
								ret);
							return false;
						}							
			
						// read and check pattern
						memset(buffer, 0, sizeof(buffer));
						ret = Read(nandCh, NAND_TEST_CHIP_SEL, 
								colAddr, pageAddr, blkAddr, 
								(smtUint32)buffer, accessType[atIdx], size);
						if(ret)
						{
							NANDDPRINTF("NANDRWTest::Read(e)0x%08x\n", 
								ret);
							return false;
						}									
								
						compareResult = CheckPattern(seed, (smtUint32)buffer, size);
						if(compareResult == false) 
						{
							NANDDPRINTF("[NAND TEST] (%d) test fail!!!\n", atIdx);
							return false;
						}
						
						//HexDump((smtUint32)buffer, 512);
					}
				}
			}
		}
	}
	NANDDPRINTF("[NAND TEST] CPU read/write test done!!!\n");
	//--------------------------------------------------------------------------
	// 2. CPU read/write test for 1 Block by interrupt
	//--------------------------------------------------------------------------	
	NANDDPRINTF("[NAND TEST] interrupt test start!!!\n");
	for(nandCh = NAND_CH0 ; nandCh < NAND_CH_MAX; nandCh++)
	{
		// set default setting
		NandDefaultSetting(nandCh);
		
		// control config
	    smtNANDGetControl(nandCh, &nandCtrl);
		nandCtrl.wrEndIntEn				= 0x1;
		nandCtrl.rdEndIntEn				= 0x1;
		nandCtrl.FIFOIntEn				= 0x1;
		nandCtrl.RnBintEn0				= 0x1;
		smtNANDSetControl(nandCh, &nandCtrl);
		
		for(atIdx = 0; atIdx < 2; atIdx++) 
		{
			NANDDPRINTF("-------------------------------------------------------------\n");
			NANDDPRINTF("[NAND TEST] interrupt --%s!!!\n", accessTypeStr[atIdx]);
			NANDDPRINTF("-------------------------------------------------------------\n");		
			
			for(blkAddr = NAND_TEST_START; 
				blkAddr < NAND_TEST_START+NAND_TEST_LEN; 
				blkAddr++) 	// for one block
			{
				// erase
				NANDDPRINTF("[NAND TEST] block(b:%05d) erase!!!\n", blkAddr);
				BlockErase(nandCh, NAND_TEST_CHIP_SEL,blkAddr);
				
				for(pageAddr = 0; pageAddr < 4; pageAddr++) // is large block
				{
					for(colAddr = 0; colAddr < (512+16); colAddr += (512+16)) // all page
					{
						NANDDPRINTF("[NAND TEST] test nand(b:%05d, p:%05d, c:%05d)...\n"
									,blkAddr, pageAddr, colAddr);
							
						// program
						memset(buffer, 0, sizeof(buffer));
		    			MakePattern(seed, (smtUint32)buffer, size);
						ret = PageProgramInt(nandCh, NAND_TEST_CHIP_SEL,
								colAddr, pageAddr, blkAddr,  
								(smtUint32)buffer, accessType[atIdx], size);
						if(ret)
						{
							NANDDPRINTF("NANDRWTest::PageProgramInt(e)0x%08x\n", 
								ret);
							return false;
						}	
						
						// read and check pattern
						memset(buffer, 0, sizeof(buffer));
						ret = ReadInt(nandCh, NAND_TEST_CHIP_SEL,
								colAddr, pageAddr, blkAddr, 
								(smtUint32)buffer, accessType[atIdx], size);
						if(ret)
						{
							NANDDPRINTF("NANDRWTest::ReadInt(e)0x%08x\n", 
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
	}
	NANDDPRINTF("[NAND TEST] interrupt read/write test!!!\n");		
	return true;
}

/*-----------------------------------------------------------
	Function name	: NANDRWTest
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 NANDIntlveWTest(void)
{
	smtUint8		ce;		// NAND CHIP ENABLE
	NandChannel		nandCh; // NAND CHANNEL
	NandStat		status;
	smtUint32		timeout;
	smtUint32		seed = 0xAAAA0000;
	
	gIntlveMode = SMT_TRUE;
	
	for(nandCh = NAND_CH0 ; nandCh < NAND_CH_MAX; nandCh++)
	{
		//---------------------------------------------------
		// multi page write
		//---------------------------------------------------
		for( ce = 0; ce < NAND_TEST_MAX_CHIP_SEL ; ce++)
		{
			// page write with chip select
			 BlockErase(nandCh, ce, 6);
			// make pattern
			memset(buffer, 0, sizeof(buffer));
			MakePattern(seed, (smtUint32)buffer, 512);
			PageProgram(nandCh, ce, 0, 0, 6, (smtUint32)buffer, 0x01, 512);
		}
		
		// check if all pages are prgrammed
		timeout = 0;
		while(1)
		{
			smtNANDGetStatus(nandCh, &status);
			if(status.RnBDetect0 && status.RnBDetect1
				&& status.RnBDetect2 && status.RnBDetect3)
			{
				memset(&status, 0, sizeof(status));
				status.RnBDetect0 = status.RnBDetect1 = \
				status.RnBDetect2 = status.RnBDetect3 = 0; 
				smtNANDSetStatus(nandCh, &status);
				break;
			}
			if(timeout++ == NANDT_TO_INTLVE_WREND)
				goto ERROR;
		}
			
		//---------------------------------------------------
		// multi page read
		//---------------------------------------------------
		for( ce = 0; ce < NAND_TEST_MAX_CHIP_SEL ; ce++)
		{
			smtBoolean chPatRslt;
			// page read with chip select
			memset(buffer, 0, sizeof(buffer));
			Read(nandCh, ce, 0, 0, 6, (smtUint32)buffer, 0x01, 512);
			// check pattern
			chPatRslt = CheckPattern(seed,(smtUint32)buffer, 512);
			if(!chPatRslt)
				goto ERROR;
		}
	}
	return NANDT_EC_NONE;

ERROR:
	smtNANDGetStatus(nandCh, &status);
	smtNANDSetStatus(nandCh, &status);
	return NAND_ERROR;
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
	smtUint8	idCode[5];	
	smtBoolean	result;
	
	NANDDPRINTF("+NANDTest\n"); 
	
	//-------------------------------------------------------------------------- 
	//	1. Check NAND identify code
	//--------------------------------------------------------------------------
	NandDefaultSetting(NAND_CH0);
	
	result = ReadID(NAND_CH0, 0, idCode);
	if(result)
	{
		NANDDPRINTF("NANDTest::NAND READ ID fail!!!\n");
		return NAND_ERROR;
	}
	NANDDPRINTF("-------------------------------------------------------------\n");
	NANDDPRINTF(" Nand ID Read NAND_CH%1d CS%1d\n", NAND_CH0, 0);
	NANDDPRINTF("-------------------------------------------------------------\n");
	NANDDPRINTF("NANDTest::Nand 1st ID : 0x%02X\n",idCode[0]);
	NANDDPRINTF("NANDTest::Nand 2nd ID : 0x%02X\n",idCode[1]);
	NANDDPRINTF("NANDTest::Nand 3rd ID : 0x%02X\n",idCode[2]);
	NANDDPRINTF("NANDTest::Nand 4th ID : 0x%02X\n",idCode[3]);
    NANDDPRINTF("NANDTest::Nand 5th ID : 0x%02X\n",idCode[4]);    
	
    //--------------------------------------------------------------------------
	// 	2. NAND read/write
	//		- CPU read/write
	//		- interrupt read/write
	//--------------------------------------------------------------------------
	result = NANDRWTest();
	if(result == false)
	{
		NANDDPRINTF("NANDTest::NAND read/write test fail!!!\n");
		return NAND_ERROR;
	}
	NANDDPRINTF("NANDTest::NAND read/write test success!!!\n");
	
    //--------------------------------------------------------------------------
	// 	3. NAND interleave read/write
	//		- CPU read/write
	//		- interrupt read/write
	//--------------------------------------------------------------------------
	result = NANDIntlveWTest();
	if(result == false)
	{
		NANDDPRINTF("NANDTest::NAND Interleave read/write test fail!!!\n");
		return NAND_ERROR;
	}
	NANDDPRINTF("NANDTest::NAND Interleave read/write test success!!!\n");


	return NO_ERROR;
}

