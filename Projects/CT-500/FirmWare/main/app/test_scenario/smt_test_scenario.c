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


/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/



/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
void SMTRtnFunc(void);

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
	Function name	: SMTTestScenario()
	Prototype		: void SMTTestScenario(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void SMTTestScenario(void)
{
	smtInt8 user_input;
	smtInt8 backToMain[] = "Type '0' to return Menu\n";

	while(1)
	{
		smt2UARTPrint(CFG_UART_CH,"==== SMT Test scenario ====\n");
		smt2UARTPrint(CFG_UART_CH,"1. Nand boot\n");
		smt2UARTPrint(CFG_UART_CH,"2. JPEG decoding\n");
		smt2UARTPrint(CFG_UART_CH,"3. Graphic plane palette display\n");
		smt2UARTPrint(CFG_UART_CH,"4. Video Plane display using GDMA\n");
		smt2UARTPrint(CFG_UART_CH,"5. Three plane overlay display with alpha\n");
		smt2UARTPrint(CFG_UART_CH,"6. Display image change effect -> Enough to scenario 4\n");
		smt2UARTPrint(CFG_UART_CH,"7. Sound play with three plane overlay\n");
		smt2UARTPrint(CFG_UART_CH,"8. External video input\n");
		smt2UARTPrint(CFG_UART_CH,"9. Nor  boot\n");
		smt2UARTPrint(CFG_UART_CH,"a. Stress test\n");


		do
		{
			smt2UARTGetCh(CFG_UART_CH, &user_input, 0);
		} while(user_input < '1' && user_input > '8');

		switch(user_input)
		{
			case '1':
				smt2UARTPrint(CFG_UART_CH,"Nand boot menu selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				NandBootWriter();

				SMTRtnFunc();
				break;
			case '2':
				smt2UARTPrint(CFG_UART_CH,"Jpeg decoding menu selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				JPEGTest();

				SMTRtnFunc();
				break;
			case '3':
				smt2UARTPrint(CFG_UART_CH,"Graphic plane palette menu selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				graphicPaletteTest();

				SMTRtnFunc();
				break;
			case '4':
				smt2UARTPrint(CFG_UART_CH,"Video plane overlay menu selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				VideoWithGDMATest();

				SMTRtnFunc();
				break;
			case '5':
				smt2UARTPrint(CFG_UART_CH,"Three plane overlay display menu selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				OverlayDisplayTest();

				SMTRtnFunc();
				break;
			case '6':
				smt2UARTPrint(CFG_UART_CH,backToMain);

				SMTRtnFunc();
				break;

			case '7':
				smt2UARTPrint(CFG_UART_CH,"Sound play with three plane menu selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				SoundDisplay();
				SMTRtnFunc();
				break;
			case '8':
				smt2UARTPrint(CFG_UART_CH,"External video input menu selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				VideoInTest();

				SMTRtnFunc();
				break;
			case '9':
				smt2UARTPrint(CFG_UART_CH,"Nor boot menu selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				NorBootWriter();
				SMTRtnFunc();
				break;
			case 'a':
				smt2UARTPrint(CFG_UART_CH,"Stress test selected\n");
				smt2UARTPrint(CFG_UART_CH,backToMain);
				StressTest();

				SMTRtnFunc();
				break;				
				
		}
	}
}

/*----------------------------------------------------------
	Function name	: SMTRtnFunc()
	Prototype		: void SMTRtnFunc(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void SMTRtnFunc(void)
{
	smtUint32 i;
	smtUint32 count;

	i = 0;

	while(1)
	{
		char uart_input;
		count = 100000;

		i++;
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
			if(uart_input == '0') 
			{
				break;
			}
		}
		i &= 0xfffff;
		while(count--);
	}
}
