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

	smt2UARTInit(&uartBasicCfg);
	SMT_WRITE(GPIO0_OUT, 0xA4322);

#if 1
	smt2UARTPrint(CFG_UART_CH, "Power On Self Test Start\n");
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
	//while(1);
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
	smtUint8 user_input;
	smtInt8 backToMain[] = "Type '0' to return Menu\n";

	InitSEIP();

	while(1)
	{
		smt2UARTPrint(CFG_UART_CH,"==== Test Menu ====\n");
		smt2UARTPrint(CFG_UART_CH,"1. Note On\n");
		smt2UARTPrint(CFG_UART_CH,"2. Note Off\n");
		smt2UARTPrint(CFG_UART_CH,"3. Play SoundData( NotUseDMA )\n");
		smt2UARTPrint(CFG_UART_CH,"4. Rec( NotUseDMA )\n");
		smt2UARTPrint(CFG_UART_CH,"5. Play RecData( NotUseDMA )\n");
		smt2UARTPrint(CFG_UART_CH,"6. Play SoundData( UseDMA )\n");
		smt2UARTPrint(CFG_UART_CH,"7. Rec( UseDMA(polling) )\n");
		smt2UARTPrint(CFG_UART_CH,"8. Rec( UseDMA(Interrupt) )\n");
		smt2UARTPrint(CFG_UART_CH,"9. Play RecData( UseDMA )\n");

		do {
		     smt2UARTGetCh(CFG_UART_CH, &user_input, 0);
		} while(!(user_input >= '0' && user_input <= '9'));

		switch(user_input)
		{
			case '0':
				smt2UARTPrint(CFG_UART_CH,"Exit Test Menu\n");
				return;
			case '1':
				smt2UARTPrint(CFG_UART_CH,"Note On\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				NoteOn();
				break;
			case '2':
				smt2UARTPrint(CFG_UART_CH,"Note Off\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				NoteOff();
				break;
			case '3':
				smt2UARTPrint(CFG_UART_CH,"Play SoundData( NotUseDMA )\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				PlaySoundData_NotUseDMA();
				break;
			case '4':
				smt2UARTPrint(CFG_UART_CH,"Rec( NotUseDMA )\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				Rec_NotUseDMA();
				break;
			case '5':
				smt2UARTPrint(CFG_UART_CH,"Play RecData( NotUseDMA )\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				Play_RecData_NotUseDMA();
				break;
			case '6':
				smt2UARTPrint(CFG_UART_CH,"Play SoundData( UseDMA )\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				break;
			case '7':
				smt2UARTPrint(CFG_UART_CH,"Rec( UseDMA(Polling) )\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				New_WriteRecTest(SMT_FALSE);
			break;
			case '8':
				smt2UARTPrint(CFG_UART_CH,"Rec( UseDMA(Interrupt) )\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				New_WriteRecTest(SMT_TRUE);
			break;

			case '9':
				smt2UARTPrint(CFG_UART_CH,"Play RecData( UseDMA )\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				New_ReadRecTest();
			break;
		}
	}
}
