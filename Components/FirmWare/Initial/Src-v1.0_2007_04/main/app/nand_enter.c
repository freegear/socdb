/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name   : nand.c 
	Description : Nand test code
	Created by  : 
					SHMT SoC Team
					SHMT SW Team
-----------------------------------------------------------*/


/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "uart.h"
#include "gpio.h"
#include "nand_pre_drv.h"

//-----------------------------------------------------------
//	K9K8G08U0A 
//-----------------------------------------------------------
//
// command code
//
#define CC_RDIDCMD     					(0x90)		
#define CC_PAGERDCMD0  					(0x00)		
#define CC_PAGERDCMD1  					(0x30)		
#define CC_PAGEWRCMD0  					(0x80)		
#define CC_PAGEWRCMD1  					(0x10)		
#define CC_BERASECMD0  					(0x60)		
#define CC_BERASECMD1  					(0xD0)		
#define CC_RESETCMD    					(0xFF)		
#define CC_RDSTATCMD0  					(0x70)		
#define CC_RDSTATCMD1  					(0x7B)		

#define	CC_PAGERWRDCMD0					(0x85)		
#define	CC_PAGERWRDCMD1					(0x00)		
#define	CC_PAGERRRDCMD0					(0x05)		
#define	CC_PAGERRRDCMD1					(0xE0)		
//
// address+command size
//
#define CS_RDIDCMD     					(0x02)		
#define CS_PAGEWRCMD  					(0x07)		
#define CS_PAGERDCMD  					(0x07)		
#define CS_BERASECMD  					(0x05)		
#define CS_RDSTATCMD   					(0x01)		
#define CS_RESETCMD    					(0x01)		
#define	CS_PAGERWRDCMD					(0x00)		
#define	CS_PAGERRDCMD					(0x00)		
//
// address+command bit flag
//
#define	CB_RESETCMD						(0x01)		
#define	CB_RDIDCMD						(0x01)		
#define	CB_PAGERDCMD					(0x41)		
#define	CB_PAGEWRCMD					(0x41)		
#define	CB_BERASECMD					(0x11)		
#define	OPCFG_FLG_COMMAND				(0x01)
//
//	transize
//
#define	OPCFG_TS_BYTE					(0x00)		
#define	OPCFG_TS_HWORD					(0x01)		
#define	OPCFG_TS_WORD					(0x02)		
//
// operation
//
#define OPCFG_OPR_READDATA    			(0x00)		
#define OPCFG_OPR_READSTATUS 			(0x01)		
#define OPCFG_OPR_READID      			(0x02)		
#define OPCFG_OPR_WRITEDATA   			(0x03)		
#define OPCFG_OPR_NOP         			(0x07)		
//
// option
//
#define OPCFG_OPT_RNBWAIT     			(0x01)		
#define OPCFG_OPT_AUTORDSTAT  			(0x02)		
#define OPCFG_OPT_CONTINUE    			(0x03)		
#define OPCFG_OPT_NOP					(0x00)		
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
#define	NANDT_DMA_INT					(0x0)
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
#define	ADDRESS4(b)                 	(((b) >> 10) & 0xFF)	
/*/////////////////////////////////////////////////////////
        REGISTER CONFIGURATION
///////////////////////////////////////////////////////// */
#define BYTE       	 					(0x0)
#define HALFWORD   		 				(0x1)
#define WORD        					(0x2)
#define RDMOD_ERASE     				(0x0)
#define RDMOD_READ      				(0x1)
#define WRMOD_NORMAL    				(0x0)
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name   : DataWrite()
    Prototype       : void DataWrite(smtUint16 writeSize)
    Return          : success/fail-(0/-1)
    Argument        : writeSize/writeMode-write total size/read mode(normal)
    Comments        : Nand data write
-----------------------------------------------------------------------*/ 
static int DataWrite(smtUint16 writeSize,smtUint8 writeMode)
{
    smtUint32 	i,j;
    smtUint32 	wdata;
    smtUint32	timeOut;
    smtUint8 	data0, data1, data2, data3;
    NandStat	nandStatus;      
    
    timeOut	= 0x7FFFF;	// status valid timeout count
    data0 	= 0x0; 		// data pattern 0
	data1 	= 0x1; 		// data pattern 1
	data2 	= 0x2; 		// data pattern 2
	data3 	= 0x3; 		// data pattern 3
    
    for(j = 0; j < (writeSize/32); j++)
    {
		
		// check fifo write fifo ready
		while(true)
		{
			smtNANDGetStatus(&nandStatus);
			if(nandStatus.wrFIFOReady) 
			{
				smtNANDSetStatus(&nandStatus);
				break;
			}
		}          
        
        // write data
        for(i = 0; i < 8; i++)
        {  
            if(writeMode == WRMOD_NORMAL)
            {	
                wdata = (data3<<24|data2<<16|data1<<8|data0);
                smtNANDSetData(&wdata);	
            }
            
            data0 = data0 + i;
            data1 = data1 + i;
            data2 = data2 + i;
            data3 = data3 + i;
        }
    }
    
    // check write valid status
    while(true)
    {
    	smtNANDGetStatus(&nandStatus);
    	if(nandStatus.NFStatValid) 
    	{
    		break;
    	}
    	
    	if(!timeOut)
    	{
    		return -1;
    	}
    	timeOut--;
    }
    
    return 0;

}
/*-----------------------------------------------------------------------
    Function name   : DataRead
    Prototype       : void DataRead(smtUint8 readMode)
    Return          : success/fail-(0/-1)
    Argument        : readSize/readMode-read total size/read mode(erase/normal)
    Comments        : Nand read data
-----------------------------------------------------------------------*/ 
static int DataRead(smtUint16 readSize,smtUint8 readMode)
{
    int j,i;
    smtUint8	data0 	= 0x0;
    smtUint8	data1 	= 0x1;
    smtUint8	data2 	= 0x2;
    smtUint8	data3 	= 0x3;
    smtUint32	timeOut	= 0x7FFFF;
    smtUint32	readData;
    smtUint32	compValue;
    NandStat	nandStatus;  	

    for(j=0;j<readSize/32;j++)
    {
		while(true)
		{
			smtNANDGetStatus(&nandStatus);
			if(nandStatus.rdFIFOReady) 
			{
				break;
			}
			
			if(!timeOut)
			{
				return -1;
			}
			
			timeOut--;
		}    	        
        
        for(i=0;i<8;i++) {
        
            smtNANDGetData(&readData);
            if(readMode == RDMOD_ERASE)
            {
            	compValue=0xffffffff;
            }
            else
            {
            	compValue = (data3<<24|data2<<16|data1<<8|data0);
            }

            if(readData != compValue)
            {
               	SMT_WRITE(GPIO0_OUT, 0xeeee);
				return -1;
            }
            
            data0 = data0 + i;
            data1 = data1 + i;
            data2 = data2 + i;
            data3 = data3 + i;
            
        }
    }
	return 0;
}
/*-----------------------------------------------------------------------
    Function name   : NandInit
    Prototype       : void NandInit(void)
    Return          : none
    Argument        : none
    Comments        : Nand controller initialize
-----------------------------------------------------------------------*/ 
static void NandInit(void)
{

   	NandCfg	nandCfg;
	NandCtrl	nandCtrl;	

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
/*-----------------------------------------------------------------------
    Function name   : BlockErase
    Prototype       : void BlockErase(void)
    Return          : success/fail-(0/-1)
    Argument        : blockAddr-block address
    Comments        : Nand flash block erase
-----------------------------------------------------------------------*/ 
static int BlockErase(smtUint16 blockAddr)
{

	NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandOpt2	nandCmdAddr1;
    NandStat	nandStatus;  
    smtUint32	timeOut = 0x7FFFF;	

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
    while(1) 
	{
		smtNANDGetStatus(&nandStatus);
		if(nandStatus.NFStatValid)
		{
    		break;
    	}
    	
    	if(!timeOut) 
    	{
    		return -1;
    	}
    	timeOut--;
    }
    
	// clear status
    smtNANDGetStatus(&nandStatus);
    smtNANDSetStatus(&nandStatus);     
    
    return 0;
}
/*-----------------------------------------------------------------------
    Function name   : IdRead
    Prototype       : void IdRead(void)
    Return          : success/fail-(0/-1)
    Argument        : none
    Comments        : Read NAND ID code 
-----------------------------------------------------------------------*/ 
static int IdRead(void)
{
	
 	NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr;
    NandStat	nandStatus;
    smtUint32 	id[5];
    smtUint32	timeOut	= 0x7FFFF;
    
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
    
	while(true)
	{		
		smtNANDGetStatus(&nandStatus);
		if(nandStatus.rdFIFOReady) 
		{
			smtNANDSetStatus(&nandStatus);
			break;
		}
		
		if(!timeOut)
		{
			return -1;
		}
		timeOut--;
	}		    
	
    // get NAND ID code data
	smtNANDGetData(&id[0]);
	smtNANDGetData(&id[1]);
	smtNANDGetData(&id[2]);
	smtNANDGetData(&id[3]);
	smtNANDGetData(&id[4]);
	smt2UARTPrint(CFG_UART_CH, "[NAND] ID code dectect: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
    	id[0], id[1], id[2], id[3], id[4]);    

	return 0;
}
/*-----------------------------------------------------------------------
    Function name   : PageRead()
    Prototype       : void PageRead(smtUint16 blockAddr,smtUint16 pageAddr
    						,smtUint16 colAddr,smtUint16 readSize,smtUint8 transSize)
    Return          : none
    Argument        : blockAddr/pageAddr/colAddr/readSize/transSize
    				- blk address/page address/column address/total write size/access type
    Comments        : Nand read configure, command, address
-----------------------------------------------------------------------*/
static void PageRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr
			,smtUint16 readSize,smtUint8 transSize)
{
    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandOpt2	nandCmdAddr1;
    NandStat	nandStatus;    
    smtUint32	wi, bi, *ptrg, tmpData;

    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_NOP;
    nandOpConfig.dataSize			= readSize;
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
}
/*-----------------------------------------------------------------------
    Function name   : PageWrite()
    Prototype       : void PageRead(smtUint32 PageSize, ,smtUint32 Block addr 
    					,smtUint32 Pageaddr,smtUint32 writeData,smtUint8 transSize)
    Return          : none
    Argument        : blockAddr/pageAddr/colAddr/writeSize/transSize
    				- blk address/page address/column address/total write size/access type
    Comments        : NAND program configure, command, address
-----------------------------------------------------------------------*/
static void PageWrite(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,
	smtUint32 writeSize,smtUint8 transSize)
{
    NandOpt0	nandOpConfig;
    NandOpt1	nandCmdAddr0;
    NandOpt2	nandCmdAddr1;
    NandStat	nandStatus;  
    smtUint32	wi, bi, *psrc, tmpData;

    // operation configure
    nandOpConfig.chipSel			= 0x0;
    nandOpConfig.option				= OPCFG_OPT_AUTORDSTAT;
    nandOpConfig.dataSize			= writeSize;
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
}
/*-----------------------------------------------------------------------
    Function name   : NandTest
    Prototype       : void NandTest(void)
    Return          : none
    Argument        : none
    Comments        : Nand simple test top
-----------------------------------------------------------------------*/
void NandTest(void)
{
    int i;

	smt2UARTPrint(CFG_UART_CH,"[NAND] Simple test start\n");
	
    NandInit();
    
	i = 0;
    if(IdRead())
    {
		goto error;
	}
	
	i = 1;
	if(BlockErase(0))
	{
		goto error;
	}
	//smt2UARTPrint(CFG_UART_CH, "[NAND] Block erase Done!!!\n");

	i = 2;
    PageWrite(0,1,0,2112,WORD);
    if(DataWrite(2112,WRMOD_NORMAL))
    {
		goto error;
	}
	//smt2UARTPrint(CFG_UART_CH, "[NAND] Program Done!!!\n");

	i = 3;
    PageRead(0,1,0,2112,WORD);
    if(DataRead(2112,RDMOD_READ))
    {
		goto error;
	}
	//smt2UARTPrint(CFG_UART_CH, "[NAND] Read & Verify Done!!!\n");

	smt2UARTPrint(CFG_UART_CH,"[NAND] Simple test Done\n");
	
	return;
	
error:
	
	switch(i)
	{
	case 0: 
		smt2UARTPrint(CFG_UART_CH,"[NAND] Error(ID Read)\n"); 
		break;
		
	case 1: 
		smt2UARTPrint(CFG_UART_CH,"[NAND] Error(Block Erase)\n"); 
		break;
		
	case 2: 
		smt2UARTPrint(CFG_UART_CH,"[NAND] Error(Data Write)\n"); 
		break;
		
	case 3: 
		smt2UARTPrint(CFG_UART_CH,"[NAND] Error(Data Read)\n"); 
		break;
		
	default: 
		smt2UARTPrint(CFG_UART_CH,"[NAND] Error\n"); 
		break;
	}
}
