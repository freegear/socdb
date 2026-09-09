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

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"

#include "mmu.h"

#include "uart_pre_drv.h"
#include "uart_post_drv.h"

#include "uart.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/

unsigned int mboot[] = {
#if 0
0xE59FF018, 0xE59FF018, 0xE59FF018, 0xE59FF018,
0xE59FF018, 0x00000014, 0xE59FF018, 0xE59FF010,

0x0000003C, 0x00000044, 0x0000004C, 0x00000054,
0x0000005C, 0x0000006C, 0x00000064, 0xE59F1030,
0xE12FFF11, 0xE59F102C, 0xE12FFF11, 0xE59F1028,
0xE12FFF11, 0xE59F1024, 0xE12FFF11, 0xE59F1020,
0xE12FFF11, 0xE59F101C, 0xE12FFF11, 0xE59F1018,
0xE12FFF11, 0x60100000, 0x60100004, 0x60100008,
0x6010000C, 0x60100014, 0x60100018, 0x6010001C
#else
0xe59ff018,0xe59ff018,0xe59ff018,0xe59ff018,
0xe59ff018,0x00000014,0xe59ff018,0xe59ff010,

0x60100000,0x60100004,0x60100008,0x6010000C,
0x60100014,0x6010001C,0x60100018
#endif
};


/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

/*--------------------------
	SMTTestFunc function list
--------------------------*/
// Peripheral Test Function
smtUint32 DMATest(void);
smtUint32 VICTest(void);
smtUint32 GPIOTest(void);
smtUint32 RegisterTest(void);
smtUint32 TimerTest(void);
smtUint32 WDTTest(void);

// Communication Test Function
void ADV7181BTest(void);
smtUint32 I2STest(void);
void SST25VF020Test(void);
smtUint32 UARTTest(void);

// Storage Test Function
smtUint32 ESRAMTest(void);
smtUint32 DDRSDRAMTest(void);

// PCI
smtUint32 PCITest(void);

/*--------------------------
	SMTFirstApp function list
--------------------------*/
void BGMTest(void);
void AudioDelayedLoopback(void);
void InterruptTest(void);


void SMTTestFunc(void);
void SMTFirstApp(void);


/*
/////////////////////////////////////////////////////////
	VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static UartConfig uartBasicCfg;
DMA_STRUCT gDmaVariable;


/*
/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: TimerIRQ()
	Prototype		: static void TimerIRQ(unsigned irq)
	Return			: void
	Argument		:
	Comments		:
----------------------------------------------------------*/
static void TimerIRQ(unsigned irq)
{
	smt2UartPrint(11, "Timer(%d) IRQ(%d)\n", irq-IRQ_TIMER0, irq);
}

/*----------------------------------------------------------
	Function name	: Main()
	Prototype		: void Main(void)
	Return			: void
	Argument		:
	Comments		:
----------------------------------------------------------*/
int main1(void)
{	
	smtInt32 ret;
	smtInt8 buf[10];
	FILE *fp;
	smtInt8 echo;
	smtInt32 i;
	//UartConfig uartBasicCfg;
	smtUint32 *s_addr = (smtUint32 *)0x60000000;

	// Vector table copy to virtual addr(0x0) mapped by mmu
	for(i=0;i<36;i++)
		*s_addr++ = mboot[i];

	Disable_IRQ();
	//MMU_Init();
	Enable_IRQ();

#if 1
	// uart init
	uartBasicCfg.baudrate		= 38400;
	uartBasicCfg.enInt		= 0x0;	// 0 : Enable int, 1 : Disable int
	uartBasicCfg.enRxTimeout	= 0x0;
	uartBasicCfg.swReset		= 0x0;
	uartBasicCfg.enDmaReq	= 0x0;
	uartBasicCfg.parity		= 0x0;
	uartBasicCfg.dataBit		= 0x1;
	uartBasicCfg.stopBit		= 0x0;
	uartBasicCfg.enLoopBack	= 0x0;
	uartBasicCfg.txWaterLev	= 0x8;
	uartBasicCfg.rxWaterLev	= 0x8;
	uartBasicCfg.uartCh		= UART_CHANNEL0;
	// Invert flag : Enable interrupt, Interrupt assert flag

	smt2UartInit(uartBasicCfg);
#endif

	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);

	// 1. SMT Test code Routine
	smt2UartPrint(11, "Main function : Test start\n");

	// GPIO/Timer/I2S
	SMTTestFunc();

	// 2. SMT First Application
	//SMTFirstApp();

	while(1);

	return 0;
}	

/*----------------------------------------------------------
	Function name	: SMTFirstApp()
	Prototype		: void SMTFirstApp(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void SMTFirstApp(void)
{
	smtInt8 user_input;
	smtInt8 backToMain[] = "\nType '0' to return Menu\n";

	while(1)
	{
		UARTPrintf("==== Test Menu ====\n");
		UARTPrintf("1. Back Ground Music Play\n");
		UARTPrintf("2. Audio Delayed Loop Back\n");
		UARTPrintf("3. Interrupt Test\n");

		do
		{
			user_input = UARTGetch();
		} while(user_input < '1' && user_input > '4');

		switch(user_input)
		{
			case '1':
				UARTPrintf("Back Ground Music Play Start\n");
				UARTPrintf(backToMain);
				BGMTest();
				break;
			case '2':
				UARTPrintf("Audio Delayed Loop Back Start\n");
				UARTPrintf(backToMain);
				AudioDelayedLoopback();
				break;
			case '3':
				UARTPrintf("Interrupt Test Start\n");
				UARTPrintf(backToMain);
				InterruptTest();
				break;
		}
	}
}

/*----------------------------------------------------------
	Function name	: SMTTestFunc()
	Prototype		: void SMTTestFunc(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void SMTTestFunc(void)
{
	smtInt8 input;

	smt2UartPrint(11, "\nPress Y/N key to Nand boot\n");
	input = smt2UartGetCh(0);
	
	if (input == 'y')
	{
		NandBootWriter();
		smt2UartPrint(11, "Nandboot ready\n");
	}

#if 1
	/*-----------------------------------
		Basic peripheral Test
		Timer / WDT / E-DMA
	-----------------------------------*/
	// GPIO Test
	/*
	smt2UartPrint(11, "\nPress any key to GPIOTest\n");
	smt2UartGetCh(0);
	GPIOTest();
	*/

	// Timer Test
	smt2UartPrint(11, "\nPress any key to TimerTest\n");
	smt2UartGetCh(0);
	TimerTest();

	// WDT Test
	smt2UartPrint(11, "\nPress any key to WDTTest\n");
	smt2UartGetCh(0);
	WDTTest();

	/*-----------------------------------
		Communication Test
		I2C / I2S / SPI / UART
	-----------------------------------*/
	// I2C Test
	/*
	smt2UartPrint(11, "\nPress any key to I2CTest\n");
	smt2UartGetCh(0);
	ADV7181BTest();
	*/

	// I2S Test
	/*
	smt2UartPrint(11, "\nPress any key to I2STest\n");
	smt2UartGetCh(0);
	I2STest();
	*/
#endif
#if 1
	// UART Test
	smt2UartPrint(11, "Press any key to UARTTest\n");
	smt2UartDeInit();
	UARTTest();
	smt2UartInit(uartBasicCfg);
#endif

	/*-----------------------------------
		Storage Test
		NAND / SRAM / DDR SDRAM
	-----------------------------------*/
	// NAND Test
	/*
	smt2UartPrint(11, "\nPress any key to NANDTest\n");
	smt2UartGetCh(0);
	SMT_WRITE(RS_DMAMUX, DMADEV_NAND);	// DMA mux for NAND by djkim 2007/03/27
	NANDTest();
	smt2UartPrint(11, "\nNAND test done\n");
	*/

	// SRAM Test
	smt2UartPrint(11, "\nPress any key to SRAMTest\n");
	smt2UartGetCh(0);
	ESRAMTest();
	smt2UartPrint(11, "\nSRAM test done\n");

	// DDR Test
	smt2UartPrint(11, "\nPress any key to DDRTest\n");
	smt2UartGetCh(0);
	DDRSDRAMTest();
	smt2UartPrint(11, "\nDDR test done\n");

	// PCI Test
	smt2UartPrint(11, "\nPress any key to PCITest\n");
	smt2UartGetCh(0);
	PCITest();
	smt2UartPrint(11, "\nPCI test done\n");
}
