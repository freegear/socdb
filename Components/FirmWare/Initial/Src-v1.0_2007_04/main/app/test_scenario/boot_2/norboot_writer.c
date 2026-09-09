/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: norboot_writer.c 
	Description	: SD/MMC test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "norboot_code.h"
/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARE
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

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

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: NorBootWriter
	Prototype		: void NorBootWriter(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void NorBootWriter(void)
{
	smtUint8 *fwImage = (smtUint8*)0x60100000;
	smtUint8 temp;
	smtUint8 mID, dID;
	
	smtNorReadID(&mID, &dID);
	smt2UARTPrint(CFG_UART_CH,"[NOR BOOT] MenID=[0x%02x], DevID=[0x%02x]\n",mID, dID);
	
	smt2UARTPrint(CFG_UART_CH, "[NOR BOOT] press any key to copy image to nor flash\n");
	smt2UARTGetCh(CFG_UART_CH, &temp, 0);

	smtNorReset();
	smtNorWriteBlock(0, (smtUint8*)norBootCode, sizeof(norBootCode));	// write boot code
	smtNorWriteBlock(0x20000, fwImage, 0x600000);						// write f/w image
	
	smt2UARTPrint(CFG_UART_CH, "[NOR BOOT] Copying image to nor flash finished!!\n");
}
