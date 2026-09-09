/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: nand_pre_drv.c 
	Description	: SD/MMC test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdio.h>
#include "nand_pre_drv.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARE
///////////////////////////////////////////////////////// 
*/
extern void HexDump(void * buffer, smtUint32 size);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define NANDDPRINTF printf
/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static smtUint8 bankFlag = 0;
static smtUint8 bankFlag1 = 0;
/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: smtNANDInit
	Prototype		: smtBoolean smtNANDInit(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtNANDInit(void)
{
	
	//ch = 0;// prevent compile error
	// set nand Configuration reg
		NF0_CONF0	= 0x92;
		NF0_CONF1	= 0x1E;
		NF0_CONF2	= 0x0 ;

		// set nand control reg
		NF0_CTRL0	= 0x80; // DMA enable
		NF0_CTRL1	= 0x1C; // set Fifo level to 7
}

/*----------------------------------------------------------
	Function name	: smtNANDDeinit
	Prototype		: smtBoolean smtNANDDeinit(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smtNANDDeinit(void)
{
	//ch = 0; // prevent compile error
	return true;	
}
/*----------------------------------------------------------
	Function name	: smtNANDErase
	Prototype		: smtBoolean smtNANDErase(smtUint8 ch, smtUint8 bank, smtUint32 pba)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smtNANDErase(smtUint8 bank, smtBlkAddr pba)
{
	smtUint32 timeout;

	//ch = 0; // prevent compile warning
	//printf("[NAND] bank = %bd pba = %d\n",bank,pba);
	//======================================
	// send erase command
	//======================================
	// the 1st operation
	NF0_OPER0 =  0x31;				// CmdAddrFlag(8) 0011 0001B
	NF0_OPER1 =  0xE6;				// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF0_OPER2 =  0x0 ;				// DataSize(8)
	NF0_OPER3 =  0x20 | (bank << 6);// ChipSel(2)|Option(2)|DataSize(4)
	
	// the 2nd operation
	NF0_OPER0 =  0x60; 				//  CC0 for erase block
	NF0_OPER1 =  ADDRESS2(0,pba); 	//  row address
	NF0_OPER2 =  ADDRESS3(pba); 	//  row address
	NF0_OPER3 =  ADDRESS4(pba); 	//  row address

	// the 3rd operation
	NF0_OPER0 =  0xD0;				//  CC1 for erase block
	NF0_OPER1 =  0x70;				//  CC for read status
	NF0_OPER2 =  0x00;				//  Dummy
	NF0_OPER3 =  0x00;				//  Dummy

	//======================================
	// check if erase finished
	//=====================================
	timeout=0;
	while(1)
	{
		if(NF0_STAT0&0x1)// check NFStatValid
		{
			NF0_STAT0 = NF0_STAT0;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("check NFStatValid error\n");
			goto ERROR;
		}
		//NANDDPRINTF("check NFStatValid\n");		
	}
	return true;
	
ERROR:
	// clear status register???
	return false;	
}

/*----------------------------------------------------------
	Function name	: smtNANDWrite
	Prototype		: smtBoolean smtNANDWrite(smtUint8 ch, smtUint8 bank, 
									NandRWInfo main, NandRWInfo spare);
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smtNANDWrite(smtUint8 bank, NandRWInfo *pMain, NandRWInfo *pSpare)
{
	smtUint32	timeout;
	//ch = 0; // prevent compile warning

	
	
	// check if the bank is ready
	timeout = 0;
	while(1)
	{
		// 
		if(!(bankFlag & 1 << bank))//convert to array
		{
			bankFlag |= 1 << bank;
			//printf("this is the first time to call nandwr func\n");
			break;
		}
		// is ready???
		if((NF0_STAT3 >> (bank+4)) & 0x1)
		{
			NF0_STAT3 = 1 << (bank+4);
			//printf("bank ready!!!\n");
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			printf("[NAND Write] is ready timeout??\n");
			goto ERROR;
		}
		
		// clear then break;
	}
	//======================================
	// send program command
	//======================================
	// the 1st operation
	NF0_OPER0 	= 0x01;												// CmdAddrFlag(8) 0000 0001B
	NF0_OPER1 	= 0x66;												// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF0_OPER2 	= (smtUint8)(pMain->size & 0xFF);					// DataSize(8)
	NF0_OPER3 	= bank << 6|0x30\
				  |((smtUint8)(pMain->size >> 8) & 0xF);			// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	NF0_OPER0 	= 0x80;									//  CC0 for program
	NF0_OPER1 	= ADDRESS0(pMain->col); 				//  column addr
	NF0_OPER2 	= ADDRESS1(pMain->col); 				//  column addr
	NF0_OPER3 	= ADDRESS2(pMain->ppa, pMain->pba); 	//  row addr

	// the 3rd operation
	NF0_OPER0 	= ADDRESS3(pMain->pba);		//  row addr
	NF0_OPER1 	= ADDRESS4(pMain->pba);		//  row addr
	NF0_OPER2 	= 0x00; 					
	NF0_OPER3 	= 0x00; 					//  CC for read status

	//======================================
	// transfer data from ram to nand fifo 
	//======================================

	// transfer main area
	NANDRAM0SEL	= 0x1;
	DMA0START_H = 0x0;
	DMA0START_L	= 0x0;
	DMA0SIZE_H 	= ((pMain->size-1)>>8)&0x7;
	DMA0SIZE_L	= (pMain->size-1)&0xFF;
	DMA0CTRL	= 0x7D;

	timeout = 0;
	while(1)
	{
		if(DMA0CTRL & 0x08)
		{
			DMA0CTRL = 0x08;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("DMA done timeout\n");
			goto ERROR;
		}
			
	}

	//======================================
	// send program command
	//======================================
	// the 1st operation
	NF0_OPER0 	= 0x09;												// CmdAddrFlag(8) 0000 1001B
	NF0_OPER1 	= 0x64;												// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF0_OPER2 	= (smtUint8)(pSpare->size & 0xFF);					// DataSize(8)
	NF0_OPER3 	= bank << 6\
				  |((smtUint8)(pSpare->size >> 8) & 0xF);			// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	NF0_OPER0 	= 0x85;									//  CC0 for program
	NF0_OPER1 	= ADDRESS0(pSpare->col); 				//  column addr
	NF0_OPER2 	= ADDRESS1(pSpare->col); 				//  column addr
	NF0_OPER3 	= 0x10; 									//  dummy

	// transper spare area
	NANDRAM0SEL	= 0x2;
	DMA0START_H = 0x0;
	DMA0START_L	= 0x0;
	DMA0SIZE_H 	= ((pSpare->size-1)>>8)&0x7;
	DMA0SIZE_L	= (pSpare->size-1)&0xFF;
	DMA0CTRL	= 0x7D;
	timeout = 0;
	while(1)
	{
		if(DMA0CTRL & 0x08)
		{
			DMA0CTRL = 0x08;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("DMA done timeout\n");
			goto ERROR;
		}
	}

	// check wr end
	timeout = 0;
	while(1)
	{
		if(!(NF0_STAT0&0x2))// check if NFCtrlBusy is not busy 
		{
			NF0_STAT0 = NF0_STAT0;
			break;
		}

		if(timeout++ == 0xFFFF)
		{
			NANDDPRINTF("check NFCtrlBusy failed!!\n");
			goto ERROR;
		}
	}

	NANDRAM0SEL = 0x0;
	return true;
ERROR:
	NANDRAM0SEL = 0x0;
	return false;	
}
/*----------------------------------------------------------
	Function name	: smtNANDRead
	Prototype		: smtBoolean smtNANDRead(smtUint8 ch, smtUint8 bank, 
									NandRWInfo main, NandRWInfo spare);
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smtNANDRead(smtUint8 bank, NandRWInfo *pMain, NandRWInfo *pSpare)
{
	smtUint32 timeout;
	//ch = 0; // prevent compile warning
	//======================================
	// send program command
	//======================================
	if(pMain->size)
	{
	// the 1st operation
	NF0_OPER0 	= 0x41;										// CmdAddrFlag(8) 0100 0001B
	NF0_OPER1 	= 0x07;										// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF0_OPER2 	= pMain->size & 0xFF;						// DataSize(8)
	NF0_OPER3 	= (bank << 6)|((pMain->size >> 8)&0xF);		// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	NF0_OPER0 	= 0x00; 							// CC0 for read
	NF0_OPER1 	= ADDRESS0(pMain->col); 			// column addr
	NF0_OPER2 	= ADDRESS1(pMain->col);				// column addr
	NF0_OPER3 	= ADDRESS2(pMain->ppa,pMain->pba); 	// row addr

	// the 3rd operation
	NF0_OPER0 	= ADDRESS3(pMain->pba); 			// row addr
	NF0_OPER1 	= ADDRESS4(pMain->pba); 			// row addr
	NF0_OPER2 	= 0x30; 							// CC1 for read
	NF0_OPER3 	= 0x0 ; 							// Dummy

	//======================================
	// transfer data from nand fifo to ram 
	//======================================
	// Read main area
	NANDRAM0SEL	= 0x1;
	DMA0START_H = 0x0;
	DMA0START_L	= 0x0;
	DMA0SIZE_H 	= ((pMain->size-1)>>8)&0x7;
	DMA0SIZE_L	= (pMain->size-1)&0xFF;
	DMA0CTRL	= 0x7F;
	timeout = 0;
	while(1)
	{
		if(DMA0CTRL & 0x08)
		{
			DMA0CTRL = 0x80;
			break;
		}
		
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("DMA main read done timeout\n");
			goto ERROR;
		}
		
		//NANDDPRINTF("waiting for DMA main read done \n");
	}
		//NANDDPRINTF("[DONE]DMA main read done \n");
	
	}
	//======================================
	// send program command
	//======================================
	// the 1st operation
	// the 1st operation
	if(pSpare->size)
	{
	NF0_OPER0 	= 0x41;										// CmdAddrFlag(8) 0100 0001B
	NF0_OPER1 	= 0x07;										// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF0_OPER2 	= pSpare->size & 0xFF;						// DataSize(8)
	NF0_OPER3 	= (bank << 6)|((pSpare->size >> 8)&0xF);		// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	NF0_OPER0 	= 0x00; 							// CC0 for read
	NF0_OPER1 	= ADDRESS0(pSpare->col); 			// column addr
	NF0_OPER2 	= ADDRESS1(pSpare->col);				// column addr
	NF0_OPER3 	= ADDRESS2(pSpare->ppa,pSpare->pba); 	// row addr

	// the 3rd operation
	NF0_OPER0 	= ADDRESS3(pSpare->pba); 			// row addr
	NF0_OPER1 	= ADDRESS4(pSpare->pba); 			// row addr
	NF0_OPER2 	= 0x30; 							// CC1 for read
	NF0_OPER3 	= 0x0 ; 							// Dummy

	// Read Spare area
	NANDRAM0SEL	= 0x2;
	DMA0START_H = 0x0;
	DMA0START_L	= 0x0;
	DMA0SIZE_H 	= ((pSpare->size-1)>>8)&0x7;
	DMA0SIZE_L	= (pSpare->size-1)&0xFF;
	DMA0CTRL	= 0x7F;

	timeout = 0;
	while(1)
	{
		if(DMA0CTRL & 0x08)
		{
			DMA0CTRL = 0x80;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("DMA spare read done timeout\n");
			goto ERROR;
		}

		//NANDDPRINTF("waiting for DMA spare read done \n");
	}
		//NANDDPRINTF("[DONE] DMA spare read done \n");

	}
	NANDRAM0SEL = 0;
	return true;
	
ERROR:
	NANDRAM0SEL = 0;
	return false;
	
}

/*----------------------------------------------------------
	Function name	: smtNAND1Init
	Prototype		: smtBoolean smtNAND1Init(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtNAND1Init(void)
{
	
	// set nand Configuration reg
		NF1_CONF0	= 0x92;
		NF1_CONF1	= 0x1E;
		NF1_CONF2	= 0x0 ;

		// set nand control reg
		NF1_CTRL0	= 0x80; // DMA enable
		NF1_CTRL1	= 0x1C; // set Fifo level to 7
}

/*----------------------------------------------------------
	Function name	: smtNAND1Deinit
	Prototype		: smtBoolean smtNAND1Deinit(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smtNAND1Deinit(void)
{
	return true;	
}
/*----------------------------------------------------------
	Function name	: smtNAND1Erase
	Prototype		: smtBoolean smtNAND1Erase(smtUint8 ch, smtUint8 bank, smtUint32 pba)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smtNAND1Erase(smtUint8 bank, smtBlkAddr pba)
{
	smtUint32 timeout;

	//ch = 0; // prevent compile warning
	
	//======================================
	// send erase command
	//======================================
	// the 1st operation
	NF1_OPER0 =  0x31;				// CmdAddrFlag(8) 0011 0001B
	NF1_OPER1 =  0xE6;				// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF1_OPER2 =  0x0 ;				// DataSize(8)
	NF1_OPER3 =  0x20 | (bank << 6);// ChipSel(2)|Option(2)|DataSize(4)
	
	// the 2nd operation
	NF1_OPER0 =  0x60; 				//  CC0 for erase block
	NF1_OPER1 =  ADDRESS2(0,pba); 	//  row address
	NF1_OPER2 =  ADDRESS3(pba); 	//  row address
	NF1_OPER3 =  ADDRESS4(pba); 	//  row address

	// the 3rd operation
	NF1_OPER0 =  0xD0;				//  CC1 for erase block
	NF1_OPER1 =  0x70;				//  CC for read status
	NF1_OPER2 =  0x00;				//  Dummy
	NF1_OPER3 =  0x00;				//  Dummy

	//======================================
	// check if erase finished
	//=====================================
	timeout=0;
	while(1)
	{
		if(NF1_STAT0&0x1)// check NFStatValid
		{
			NF1_STAT0 = NF1_STAT0;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("check NFStatValid error\n");
			goto ERROR;
		}
		//NANDDPRINTF("check NFStatValid\n");		
	}
	return true;
	
ERROR:
	// clear status register???
	return false;	
}

/*----------------------------------------------------------
	Function name	: smtNANDWrite
	Prototype		: smtBoolean smtNANDWrite(smtUint8 ch, smtUint8 bank, 
									NandRWInfo main, NandRWInfo spare);
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smtNAND1Write(smtUint8 bank, NandRWInfo *pMain, NandRWInfo *pSpare)
{
	smtUint32	timeout;
//	ch = 0; // prevent compile warning

	
	
	// check if the bank is ready
	timeout = 0;
	while(1)
	{
		// 
		if(!(bankFlag1 & 1 << bank))//convert to array
		{
			bankFlag1 |= 1 << bank;
			//printf("this is the first time to call nandwr func\n");
			break;
		}
		// is ready???
		if((NF1_STAT3 >> (bank+4)) & 0x1)
		{
			NF1_STAT3 = 1 << bank+4;
			//printf("bank ready!!!\n");
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			printf("[NAND Write] is ready timeout\n");
			goto ERROR;
		}
		
		// clear then break;
	}
	//======================================
	// send program command
	//======================================
	// the 1st operation
	NF1_OPER0 	= 0x01;												// CmdAddrFlag(8) 0000 0001B
	NF1_OPER1 	= 0x66;												// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF1_OPER2 	= (smtUint8)(pMain->size & 0xFF);					// DataSize(8)
	NF1_OPER3 	= bank << 6|0x30\
				  |((smtUint8)(pMain->size >> 8) & 0xF);			// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	NF1_OPER0 	= 0x80;									//  CC0 for program
	NF1_OPER1 	= ADDRESS0(pMain->col); 				//  column addr
	NF1_OPER2 	= ADDRESS1(pMain->col); 				//  column addr
	NF1_OPER3 	= ADDRESS2(pMain->ppa, pMain->pba); 	//  row addr

	// the 3rd operation
	NF1_OPER0 	= ADDRESS3(pMain->pba);		//  row addr
	NF1_OPER1 	= ADDRESS4(pMain->pba);		//  row addr
	NF1_OPER2 	= 0x00; 					
	NF1_OPER3 	= 0x00; 					//  CC for read status

	//======================================
	// transfer data from ram to nand fifo 
	//======================================

	// transfer main area
	NANDRAM1SEL	= 0x1;
	DMA1START_H = 0x0;
	DMA1START_L	= 0x0;
	DMA1SIZE_H 	= ((pMain->size-1)>>8)&0x7;
	DMA1SIZE_L	= (pMain->size-1)&0xFF;
	DMA1CTRL	= 0x7D;

	timeout = 0;
	while(1)
	{
		if(DMA1CTRL & 0x08)
		{
			DMA1CTRL = 0x08;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("DMA done timeout\n");
			goto ERROR;
		}
			
	}

	//======================================
	// send program command
	//======================================
	// the 1st operation
	NF1_OPER0 	= 0x09;												// CmdAddrFlag(8) 0000 1001B
	NF1_OPER1 	= 0x64;												// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF1_OPER2 	= (smtUint8)(pSpare->size & 0xFF);					// DataSize(8)
	NF1_OPER3 	= bank << 6\
				  |((smtUint8)(pSpare->size >> 8) & 0xF);			// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	NF1_OPER0 	= 0x85;									//  CC0 for program
	NF1_OPER1 	= ADDRESS0(pSpare->col); 				//  column addr
	NF1_OPER2 	= ADDRESS1(pSpare->col); 				//  column addr
	NF1_OPER3 	= 0x10; 									//  dummy

	// transper spare area
	NANDRAM1SEL	= 0x2;
	DMA1START_H = 0x0;
	DMA1START_L	= 0x0;
	DMA1SIZE_H 	= ((pSpare->size-1)>>8)&0x7;
	DMA1SIZE_L	= (pSpare->size-1)&0xFF;
	DMA1CTRL	= 0x7D;
	timeout = 0;
	while(1)
	{
		if(DMA1CTRL & 0x08)
		{
			DMA1CTRL = 0x08;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("DMA done timeout\n");
			goto ERROR;
		}
	}

	// check wr end
	timeout = 0;
	while(1)
	{
		if(!(NF1_STAT0&0x2))// check if NFCtrlBusy is not busy 
		{
			NF1_STAT0 = NF1_STAT0;
			break;
		}

		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("check NFCtrlBusy failed!!\n");
			goto ERROR;
		}
	}

	NANDRAM1SEL = 0x0;
	return true;
ERROR:
	NANDRAM1SEL = 0x0;
	return false;	
}
/*----------------------------------------------------------
	Function name	: smtNANDRead
	Prototype		: smtBoolean smtNANDRead(smtUint8 ch, smtUint8 bank, 
									NandRWInfo main, NandRWInfo spare);
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smtNAND1Read(smtUint8 bank, NandRWInfo *pMain, NandRWInfo *pSpare)
{
	smtUint32 timeout;
//	ch = 0; // prevent compile warning
	//======================================
	// send program command
	//======================================
	if(pMain->size)
	{
	// the 1st operation
	NF1_OPER0 	= 0x41;										// CmdAddrFlag(8) 0100 0001B
	NF1_OPER1 	= 0x07;										// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF1_OPER2 	= pMain->size & 0xFF;						// DataSize(8)
	NF1_OPER3 	= (bank << 6)|((pMain->size >> 8)&0xF);		// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	NF1_OPER0 	= 0x00; 							// CC0 for read
	NF1_OPER1 	= ADDRESS0(pMain->col); 			// column addr
	NF1_OPER2 	= ADDRESS1(pMain->col);				// column addr
	NF1_OPER3 	= ADDRESS2(pMain->ppa,pMain->pba); 	// row addr

	// the 3rd operation
	NF1_OPER0 	= ADDRESS3(pMain->pba); 			// row addr
	NF1_OPER1 	= ADDRESS4(pMain->pba); 			// row addr
	NF1_OPER2 	= 0x30; 							// CC1 for read
	NF1_OPER3 	= 0x0 ; 							// Dummy

	//======================================
	// transfer data from nand fifo to ram 
	//======================================
	// Read main area
	NANDRAM1SEL	= 0x1;
	DMA1START_H = 0x0;
	DMA1START_L	= 0x0;
	DMA1SIZE_H 	= ((pMain->size-1)>>8)&0x7;
	DMA1SIZE_L	= (pMain->size-1)&0xFF;
	DMA1CTRL	= 0x7F;
	timeout = 0;
	while(1)
	{
		if(DMA1CTRL & 0x08)
		{
			DMA1CTRL = 0x80;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("[NAND ch1]DMA read done timeout\n");
			goto ERROR;
		}
			
	}
	}
	//======================================
	// send program command
	//======================================
	// the 1st operation
	// the 1st operation
	if(pSpare->size)
	{
	NF1_OPER0 	= 0x41;										// CmdAddrFlag(8) 0100 0001B
	NF1_OPER1 	= 0x07;										// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	NF1_OPER2 	= pSpare->size & 0xFF;						// DataSize(8)
	NF1_OPER3 	= (bank << 6)|((pSpare->size >> 8)&0xF);		// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	NF1_OPER0 	= 0x00; 							// CC0 for read
	NF1_OPER1 	= ADDRESS0(pSpare->col); 			// column addr
	NF1_OPER2 	= ADDRESS1(pSpare->col);				// column addr
	NF1_OPER3 	= ADDRESS2(pSpare->ppa,pSpare->pba); 	// row addr

	// the 3rd operation
	NF1_OPER0 	= ADDRESS3(pSpare->pba); 			// row addr
	NF1_OPER1 	= ADDRESS4(pSpare->pba); 			// row addr
	NF1_OPER2 	= 0x30; 							// CC1 for read
	NF1_OPER3 	= 0x0 ; 							// Dummy

	// Read Spare area
	NANDRAM1SEL	= 0x2;
	DMA1START_H = 0x0;
	DMA1START_L	= 0x0;
	DMA1SIZE_H 	= ((pSpare->size-1)>>8)&0x7;
	DMA1SIZE_L	= (pSpare->size-1)&0xFF;
	DMA1CTRL	= 0x7F;

	timeout = 0;
	while(1)
	{
		if(DMA1CTRL & 0x08)
		{
			DMA1CTRL = 0x80;
			break;
		}
		if(timeout++ == 0xFFFFF)
		{
			NANDDPRINTF("[NAND ch0]DMA read done timeout\n");
			goto ERROR;
		}
	}
	}
	NANDRAM1SEL = 0;
	return true;
	
ERROR:
	NANDRAM1SEL = 0;
	return false;
	
}

