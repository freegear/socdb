/*----------------------------------------------------------
	 MMC controller SOC
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name	: main.c 
	Description	: Application Entry Point File
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/
#pragma LARGE

#include <intrins.h>

#include "sysinc.h"
#include "lib.h"
#include "sdmmc.h"

#include "ftl.h"
#include "nand.h"


/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/
typedef void (*dLoaderFTLFunc)(void);

typedef struct
{
	dLoaderFTLFunc ftlFunc;
} pDLoaderFunc;


/* When you wanna test a peri-module, define the following */


/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
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
/*------------------------------------------------------------------------------
    Function name	: main
    Return			: int
    Argument		: 
    Comments		:
    	main function
------------------------------------------------------------------------------*/
int main(void)
{
	smtUint8 *pData;
	smtUint8 dataCnt;

	smt2UartInit();

	#if 0
	while(1)
	{
		smt2UartGetCh(pData);
		smt2UartPutCh(*pData);
	}
	#endif

	smt2UartPutStr("Hello world\n");
	smt2UartGetStr(pData, 5);

	//printf("Hello\n");
	while(1);

#if 0
	pDLoaderFunc dLFTLFunc;

	smt2UartInit();

	//ADCSEL = 0x7;

	// Initialize
	smtExtIntInitial();
	smtTimer0Initial();

	dLFTLFunc.ftlFunc = 0x2000; //ftl;

	while(1)
	{
		sdmmcCmdParser();
		dynamicLoader();
	}
#endif
}
