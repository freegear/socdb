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
		smt2UartPrint(11,"==== SMT Test scenario ====\n");
		smt2UartPrint(11,"1. Nand boot\n");
		smt2UartPrint(11,"2. JPEG decoding\n");
		smt2UartPrint(11,"3. Graphic plane palette display\n");
		smt2UartPrint(11,"4. Video Plane display using GDMA\n");
		smt2UartPrint(11,"5. Three plane overlay display with alpha\n");
		smt2UartPrint(11,"6. Display image change effect -> Enough to scenario 4\n");
		smt2UartPrint(11,"7. Sound play with three plane overlay\n");
		smt2UartPrint(11,"8. External video input\n");


		do
		{
			user_input = smt2UartGetCh(0);
		} while(user_input < '1' && user_input > '8');

		switch(user_input)
		{
			case '1':
				smt2UartPrint(11,"Nand boot menu selected\n");
				smt2UartPrint(11,backToMain);
				NandBootWriter();

				SMTRtnFunc();
				break;
			case '2':
				smt2UartPrint(11,"Jpeg decoding menu selected\n");
				smt2UartPrint(11,backToMain);
				JPEGTest();

				SMTRtnFunc();
				break;
			case '3':
				smt2UartPrint(11,"Graphic plane palette menu selected\n");
				smt2UartPrint(11,backToMain);
				graphicPaletteTest();

				SMTRtnFunc();
				break;
			case '4':
				smt2UartPrint(11,"Video plane overlay menu selected\n");
				smt2UartPrint(11,backToMain);
				VideoWithGDMATest();

				SMTRtnFunc();
				break;
			case '5':
				smt2UartPrint(11,"Three plane overlay display menu selected\n");
				smt2UartPrint(11,backToMain);
				OverlayDisplayTest();

				SMTRtnFunc();
				break;
			case '6':
				smt2UartPrint(11,backToMain);

				SMTRtnFunc();
				break;

			case '7':
				smt2UartPrint(11,"Sound play with three plane menu selected\n");
				smt2UartPrint(11,backToMain);
				SoundDisplay();
				SMTRtnFunc();
				break;
			case '8':
				smt2UartPrint(11,"External video input menu selected\n");
				smt2UartPrint(11,backToMain);
				VideoInTest();

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
		if(smtUartDataAvailable())
		{
			uart_input = smt2UartGetCh();
			if(uart_input == '0') 
			{
				break;
			}
		}
		i &= 0xfffff;
		while(count--);
	}
}