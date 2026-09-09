/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
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

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"

#include "mmu.h"

#include "uart_pre_drv.h"
#include "uart_post_drv.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 


/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
static void Menu(void);

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
	Function name	: EnterFW()
	Prototype		: void EnterFW(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void EnterFW(void)
{
	UartConfig uartBasicCfg;

	// uart init
	uartBasicCfg.baudrate		= 38400;
	uartBasicCfg.enInt			= 0x0;
	uartBasicCfg.enRxTimeout	= 0x0;
	uartBasicCfg.swReset		= 0x0;
	uartBasicCfg.enDmaReq		= 0x0;
	uartBasicCfg.parity			= 0x00;
	uartBasicCfg.dataBit		= 0x1;
	uartBasicCfg.stopBit		= 0x0;
	uartBasicCfg.enLoopBack		= 0x0;
	uartBasicCfg.txWaterLev		= 0x0;
	uartBasicCfg.rxWaterLev		= 0x0;
	uartBasicCfg.uartCh			= UART_CHANNEL0;


	SMT_WRITE(GPIO0_OE, 0x800fffff);
	SMT_WRITE(GPIO0_OUT, 0xA4321);

	smt2UartInit(uartBasicCfg);
	SMT_WRITE(GPIO0_OUT, 0xA4322);

#if 1
	smt2UartPrint(11, "Power On Self Test Start\n");
	DDRTest();
	NandTest();

	SMT_WRITE(GPIO0_OUT, 0xA4323);
	//EthernetReadWriteTest();

	SMT_WRITE(GPIO0_OUT, 0xA4324);
	ADV7181BTest();		// I2C test

	SMT_WRITE(GPIO0_OUT, 0xA4325);
	SEIPReadWriteTest();
#endif
	SMT_WRITE(GPIO0_OUT, 0xA4326);

	Menu();
	while(1);
}

/*----------------------------------------------------------
	Function name	: Menu()
	Prototype		: void Menu(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
static void Menu(void)
{
	smtInt8 user_input;
	smtInt8 backToMain[] = "Type '0' to return Menu\n";

	InitSEIP();

	while(1)
	{
		smt2UartPrint(11,"==== Test Menu ====\n");
		smt2UartPrint(11,"1. Note On\n");
		smt2UartPrint(11,"2. Note Off\n");
		smt2UartPrint(11,"3. Play SoundData( NotUseDMA )\n");
		smt2UartPrint(11,"4. Rec( NotUseDMA )\n");
		smt2UartPrint(11,"5. Play RecData( NotUseDMA )\n");
		smt2UartPrint(11,"6. Play SoundData( UseDMA )\n");
		smt2UartPrint(11,"7. Rec( UseDMA(polling) )\n");
		smt2UartPrint(11,"8. Rec( UseDMA(Interrupt) )\n");
		smt2UartPrint(11,"9. Play RecData( UseDMA )\n");

		do {
		    user_input = smt2UartGetCh(10);
		} while(user_input < '1' && user_input > '4');

		switch(user_input)
		{
			case '1':
				smt2UartPrint(11,"Note On\n");
				smt2UartPrint(11,backToMain);
				NoteOn();
				break;
			case '2':
				smt2UartPrint(11,"Note Off\n");
				smt2UartPrint(11,backToMain);
				NoteOff();
				break;
			case '3':
				smt2UartPrint(11,"Play SoundData( NotUseDMA )\n");
				smt2UartPrint(11,backToMain);
				PlaySoundData_NotUseDMA();
				break;
			case '4':
				smt2UartPrint(11,"Rec( NotUseDMA )\n");
				smt2UartPrint(11,backToMain);
				Rec_NotUseDMA();
				break;
			case '5':
				smt2UartPrint(11,"Play RecData( NotUseDMA )\n");
				smt2UartPrint(11,backToMain);
				Play_RecData_NotUseDMA();
				break;
			case '6':
				smt2UartPrint(11,"Play SoundData( UseDMA )\n");
				smt2UartPrint(11,backToMain);
				break;
			case '7':
				smt2UartPrint(11,"Rec( UseDMA(Polling) )\n");
				smt2UartPrint(11,backToMain);
				New_WriteRecTest(SMT_FALSE);
			break;
			case '8':
				smt2UartPrint(11,"Rec( UseDMA(Interrupt) )\n");
				smt2UartPrint(11,backToMain);
				New_WriteRecTest(SMT_TRUE);
			break;

			case '9':
				smt2UartPrint(11,"Play RecData( UseDMA )\n");
				smt2UartPrint(11,backToMain);
				New_ReadRecTest();
			break;
		}
	}
}
