/*----------------------------------------------------------
	 MMC controller SOC
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name	: lib.c 
	Description	: Basic peripheral library file
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#define GLOBAL_DEFINE

#include "global.h"
#include "lib.h"
#include "mmc8052.h"


/*
/////////////////////////////////////////////////////////
	F/W VERSION
///////////////////////////////////////////////////////// 
*/
/*
#define SMT_LIB_NAME		"SMT FW Library"
#define SMT_LIB_VER			"100"

GLOBAL_VAR const char smtLibName[16] = SMT_LIB_NAME;
GLOBAL_VAR	const char smtLibVer[8] = SMT_LIB_VER;
*/


/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/

#define UART_PRINTF_MAX_STRING 128


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
	Function name	: smtDelay100us()
	Prototype		: smtBoolean smtDelay100us(smtInt16 time);
	Return			: smtBoolean
	Argument		: time ->  time to delay
	Comments		: function to delay.
	                  time > 0 : the number of loop time
-----------------------------------------------------------*/
smtBoolean smtDelay100us(smtInt16 time)
{
#if 0
	{
		smtUint16 i;
		for(i=0; i<(time*100*4); i++)
		{
			// this volatile is effective when compiler cutting over at optimization.
			volatile smtInt16 j;	
			j++;
			j--;
		}
	}
#endif

    return SMT_SUCCESS;
}


/*----------------------------------------------------------
        Interrupt Handler
-----------------------------------------------------------*/
/*------------------------------------------------------------------------------
    Function name	: smtExternal0ISR
    Return			:
    Argument		: 
    Comments		:
    	External interrupt 0 ISR
------------------------------------------------------------------------------*/
void smtExternal0ISR(void) interrupt 0 using 2
{
}

/*------------------------------------------------------------------------------
    Function name	: smtTimer0ISR
    Return			:
    Argument		: 
    Comments		:
    	Timer0 interrupt ISR
------------------------------------------------------------------------------*/
void smtTimer0ISR(void) interrupt 1 using 2
{
	if (TMOD == 0x25)
	{
		TH0 =0xff;
		TL0 =0xff-3;
	}
}

/*------------------------------------------------------------------------------
    Function name	: smtExternal1ISR
    Return			:
    Argument		: 
    Comments		:
    	External interrupt 1 ISR
------------------------------------------------------------------------------*/
void smtExternal1ISR(void) interrupt 2 using 2
{
}

/*------------------------------------------------------------------------------
    Function name	: smtTimer1ISR
    Return			:
    Argument		: 
    Comments		:
    	Timer0 interrupt ISR
------------------------------------------------------------------------------*/
void smtTimer1ISR(void) interrupt 3 using 2
{
}

/*------------------------------------------------------------------------------
    Function name	: smtUartISR
    Return			:
    Argument		: 
    Comments		:
    	Uart interrupt 0 ISR
------------------------------------------------------------------------------*/
void smtUartISR(void) interrupt 4 using 2
{
}


/*----------------------------------------------------------
        Peripheral (8051)
-----------------------------------------------------------*/
/*------------------------------------------------------------------------------
    Function name	: smtExtIntInitial
    Return			:
    Argument		: 
    Comments		:
    	External interrupt initialize
------------------------------------------------------------------------------*/
void smtExtIntInitial(void)
{
	IT0=1;		// Intr0 control bit (falling edge)
	IT1=1;		// Intr1 control bit (falling edge)

	EX0=1;		// Enable ext intr0
	PX0=0;		// Priority ext intr0 - Low
	EX1=1;		// Enable ext intr1
	PX1=1;		// Priority ext intr1 - High

	EA=1;		// Enable intr
}

/*------------------------------------------------------------------------------
    Function name	: smtTimer0Initial
    Return			: 
    Argument		: 
    Comments		:
    	Timer0 initialize
------------------------------------------------------------------------------*/
void smtTimer0Initial(void)
{
	TMOD=0x25;		// Timer1 bit auto-reload, Timer0 16bit counter
	TH0 =0xff;
	TL0 =0xff-3;
	TR0=1;			// Timer0 run
	PT0=1;			// Timer0 priority
	TF0=1;			// Timer0 overflow
	ET0=1;			// Enable Timer0 intr
}


/*----------------------------------------------------------
        POWER MANAGEMENT
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name		: smtPower()
	Prototype			: smtUint16 smtPower(POWER_MODE pwrMode);
	Return			: smtUint16 - ADC data
	Argument		:
	Comments		: 
		Set power mode
-----------------------------------------------------------*/
smtBoolean smtPower(PM_PWR_MODE pwrMode)
{
	return SMT_FALSE;
}


/*----------------------------------------------------------
        Reed Solomon
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name		: smtRSSetMode()
	Prototype			: smtBoolean smtRSSetMode (void)
	Return			: error code
	Argument		:
	Comments		:
		Setting the RS control
-----------------------------------------------------------*/
smtBoolean smtRSSetMode(void)
{
	return SMT_FALSE;
}


/*----------------------------------------------------------
        MEMORY (SRAM)
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name		: smtSRAMSetMode()
	Prototype			: smtBoolean smtSRAMSetMode (ESMC_CON sramCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Setting the sram control
-----------------------------------------------------------*/
smtBoolean smtSRAMSetMode(ESMC_CON sramCtrl, smtUint8 bankSel)
{
	return SMT_FALSE;
}

/*----------------------------------------------------------
	Function name		: smtSRAMGetMode()
	Prototype			: smtBoolean smtSRAMGetMode (ESMC_CON sramCtrl)
	Return			: error code
	Argument		:
	Comments		:
		Getting the sram control
-----------------------------------------------------------*/
smtBoolean smtSRAMGetMode(ESMC_CON sramCtrl, smtUint8 bankSel)
{
	return SMT_FALSE;
}

/*----------------------------------------------------------
	Function name		: smtMemWrite()
	Prototype			: smtBoolean smtMemWrite
						(smtUint16 addr, smtUint16 *dat, smtUint16 length)
	Return			: error code
	Argument		:
	Comments		: Write operation
		Write data to memory as length
-----------------------------------------------------------*/
smtBoolean smtMemWrite(smtUint16 addr, smtUint16 *dat, smtUint16 length)
{
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name		: smtMemRead()
	Prototype			: smtBoolean smtMemRead(void)
	Return			: error code
	Argument		:
	Comments		: Write operation
		Normal program
-----------------------------------------------------------*/
smtBoolean smtMemRead(smtUint16 addr, smtUint16 *dat, smtUint16 length)
{
	return SMT_SUCCESS;
}


/*----------------------------------------------------------
        UART
-----------------------------------------------------------*/
/*------------------------------------------------------------------------------
	Function name		: smt2UartInit()
	Prototype			: void smt2UartInit(void)
	Return			:
	Argument		: 
	Comments		: 
		SCON (Serial Control Register)
			bit 7	: SM0	(Serial Port Operation Mode)
			bit 6	: SM1	[SM0:SM1]	-> mode 00 / 01 / 02 / 03
			bit 5	: SM2	Enable the Automatic Address Recognition in Mode 2 and 3
			bit 4	: REN	Enable/Disable Reception
			bit 3 : TB8	9th data bit that will be tx
			bit 2	: RB8	9th data bit that was rx
			bit 1	: TI		Tx interrupt flag
			bit 0	: RI		Rx interrupt flag

		PCON (Power Control Register)
			bit 7	: SMOD1 (Timer1 baudrate double)
			bit 6	: SMOD0 (Enable SM0 access)

		TMOD (Timer/Counter 0/1 Mode Control Register)
			bit 7	: GATE
			bit 6	: C/T	Counter or Timer1 selector ('0' Timer1)
			bit 5	: M1		Mode Selector
			bit 4	: M0		[M1:M0]	-> mode 0/1/2/3
			bit 3 : GATE
			bit 2	: C/T	Counter or Timer0 selector ('0' Timer0)
			bit 1	: M1		Mode Selector
			bit 0	: M0		[M1:M0]	-> mode 0/1/2/3

		Baudrate
			Timer1 & Serial mode 1 = ((2^SMOD1) / 32) X Fosc X ((3^T1M)/12) X (1/(256-TH1))
			* SMOD1	(PCON.7)	 = 1		-> Double Baudrate
			* T1M	(CKCON.4) = 0	-> Fosc/12
------------------------------------------------------------------------------*/
void smt2UartInit(void)
{
 //------------------------------------------------
 //Set timer 1 up as a baud rate generator.
 //------------------------------------------------
	#if 1
	SCON = 0x50;		// Serial comm mode 1, REN = 1(reception enable)
	PCON = 0x80;		// 0x80=SMOD: set serial baudrate doubler 
	//TMOD = 0x25;		// Timer1 : mode 2, Internal clock use, Timer0 : counter
	TMOD = 0x20;

	//TH1 = 0xFB; 		// 12800
	TH1 = 0xF3; 		// 4800
	TR1 = 1;			// Timer1 run
	TI=1;
	RI=0;
	#else
	SCON = 0x70;
	PCON = 0x80;		// 0x80=SMOD: set serial baudrate doubler 
	TMOD = 0x20;		// mode 2, Internal clock use

	TH1 = 0xF3;		// 19200
	TL1 = 0xF3;
	TCON = 0x00;
	TR1 = 1;			// Timer1 run
	TI=1;
	RI=0;
	#endif
}

/*------------------------------------------------------------------------------
	Function name		: smt2UartPutCh()
	Prototype			: void smt2UartPutCh(smtUint8 uartOutput)
	Return			:
	Argument		:  uartOutput
	Comments		: 
------------------------------------------------------------------------------*/
void smt2UartPutCh(smtUint8 uartOutput) 
{
	if(uartOutput=='\n')
	{
		while(!TI);		// Wait until TI(Transmit intr flag) is set
		TI=0;			// TI flag clear
		SBUF='\r';		// Write a char data to SBUF
	}

	while(!TI);
	TI=0;
	SBUF=uartOutput;
}

/*------------------------------------------------------------------------------
	Function name		: smt2UartGetCh()
	Prototype			: void smt2UartGetCh(smtUint8 *uartInput)
	Return			: 
	Argument		: uartInput
	Comments		: 
------------------------------------------------------------------------------*/
void smt2UartGetCh(smtUint8 *uartInput)
{
	while(!RI);		// Wait until RI(Receive intr flag) is set
	RI=0;			// RI flag clear
	*uartInput = SBUF;
}

/*------------------------------------------------------------------------------
	Function name		: smtUartPutStr()
	Prototype			: smtBoolean smtUartPutStr(smtUint8 *pData)
	Return			: error code
	Argument		: transmit data
	Comments		:
		Transmit the data as data count
------------------------------------------------------------------------------*/
smtUint32 smt2UartPutStr(smtUint8 * str)
{
	smtInt32 index = 0 ;
	while( str[index] != '\000')  
	{      	
		smt2UartPutCh( (char) str[index] ) ;      
		if(str[index] == '\n')
			smt2UartPutCh('\r');
		index++;  
	}
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name		: smt2UartGetStr()
	Prototype			: smtBoolean smtUartStrRead(smtUint8 *pData, smtUint8 dataCnt)
	Return			: error code
	Argument		: Received data, receive data count
	Comments		:
		Receive the data as data count
------------------------------------------------------------------------------*/
smtUint32 smt2UartGetStr(smtUint8 *pData, smtUint8 dataCnt)
{
    smtUint32 len;
    smtUint8 input;

    len = 0;
    while(len < dataCnt-1)
    {
        smt2UartGetCh(&input);

        if(input == '\b')
        {
            if(len)
            {
                len--;
                pData[len] = '\0';
                smt2UartPutStr("\b \b");
            }
        }
        else if(input == '\r')
        {
        	pData[len] = '\0';
        	break;
        }
		else if(input == 0x09)
			continue;
        else
        {
            pData[len] = input;
            len++;
            smt2UartPutCh(input);
        }

    };

    pData[dataCnt-1] = '\0';

    return SMT_SUCCESS;
}


/*----------------------------------------------------------
        Dynamic Loader
-----------------------------------------------------------*/
/*------------------------------------------------------------------------------
    Function name	: dynamicLoader
    Return			:
    Argument		: 
    Comments		:
    	FTL and NAND low-level driver dynamic loader
------------------------------------------------------------------------------*/
void dynamicLoader(void)
{
	//1. Loading from nand to external RAM
	ftlLoading();

	//2. Jump to external RAM to operate FTL process
	jmpToFtl();
}

/*------------------------------------------------------------------------------
    Function name	: ftlLoading
    Return			:
    Argument		: 
    Comments		:
    	Loading ftl operation function from nand to external RAM
------------------------------------------------------------------------------*/
void ftlLoading(void)
{
}

/*------------------------------------------------------------------------------
    Function name	: jmpToFtl
    Return			:
    Argument		: 
    Comments		:
    	Jump to ftl function in the external RAM
------------------------------------------------------------------------------*/
void jmpToFtl(void)
{
}


/*----------------------------------------------------------
        SD/MMC Command Parser
-----------------------------------------------------------*/
/*------------------------------------------------------------------------------
    Function name	: sdmmcCmdParser
    Return			:
    Argument		: 
    Comments		:
    	SD/MMC command parser
------------------------------------------------------------------------------*/
void sdmmcCmdParser(void)
{
}


