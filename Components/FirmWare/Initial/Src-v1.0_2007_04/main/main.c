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


/* When you wanna test a peri-module, define the following */

// Peripheral Module Test
#define	ADC_TEST			0
#define	DMA_TEST			1	//available
#define	INTERRUPT_TEST		0
#define	GPIO_TEST			1	//available
#define	PLL_TEST			0
#define	PWR_TEST			0
#define	REGISTER_TEST		0
#define	TIMER_PWM_TEST		1	//available
#define	WDT_TEST			1	//available

// Communication Module Test
#define	CS8900_TEST			0
#define	GPS_TEST			0
#define	I2C_TEST			1	//available
#define	I2S_TEST			1	//available
#define	UART_TEST			1	//available
#define	USB_TEST			1	//available
#define	SPI_TEST			1	//available

// Display Module Test
#define	DM_TEST				0	
#define VIF_TEST			0	

// Media Module Test
#define	AUDIO_TEST			0

// Storage Module Test
#define	SDRAM_TEST			0
#define	SMC_TEST			1	//available
#define	FMC_TEST			1	//available
#define SDMMCC_TEST			1	//available
#define DDRC_TEST			1	//available
// 2D Accelerator Module Test
#define	TWODACCEL_TEST	0

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

/*--------------------------
	SMTTestFunc function list
--------------------------*/
// Peripheral Test Function
smtUint32 ADCTest(void);
smtUint32 DMATest(void);
smtUint32 VICTest(void);
smtUint32 GPIOTest(void);
smtUint32 PLLTest(void);
smtUint32 PWRManageTest(void);
smtUint32 RegisterTest(void);
smtUint32 TimerTest(void);
smtUint32 WDTTest(void);

// Communication Test Function
smtUint32 ADV7181BTest(void); //shkim-20070504 : test code integration 
smtUint32 I2STest(void);
smtUint32 SST25VF020Test(void);
smtUint32 UARTTest(void);

// Display Test Function
smtUint32 DMTest(void);

// Storage Test Function
smtUint32 NANDTest(void);
smtUint32 ESRAMTest(void);
smtUint32 DDRSDRAMTest(void);

/*--------------------------
	SMTFirstApp function list
--------------------------*/
void BGMTest(void);
void AudioDelayedLoopback(void);
void VideoTest(void);
void InterruptTest(void);


void SMTTestFunc(void);
void SMTFirstApp(void);
void EnterFW(void);


void SMTTestScenario(void);

/*
/////////////////////////////////////////////////////////
	VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static UartConfig uartBasicCfg;

/*
/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// 
*/
void file_control(void);

/*----------------------------------------------------------
	Function name	: TimerIRQ()
	Prototype		: static void TimerIRQ(unsigned irq)
	Return			: void
	Argument		:
	Comments		:
----------------------------------------------------------*/
static void TimerIRQ(unsigned irq)
{
	smt2UARTPrint(CFG_UART_CH, "Timer(%d) IRQ(%d)\n", irq-IRQ_TIMER0, irq);
}

/*----------------------------------------------------------
	Function name	: Main()
	Prototype		: void Main(void)
	Return			: void
	Argument		:
	Comments		:
----------------------------------------------------------*/
int main0(void)
{
	UartConfig uart;	
	
	smtUint32 *s_addr = (smtUint32 *)0x60000000;
	int i;
	
	for(i=0;i<15;i++)
		*s_addr++ = mboot[i];
		
	Disable_IRQ();		
	MMU_Init();
	
	smt2UARTInit(&uart);	
	smt2UARTPrint(CFG_UART_CH, "Enter main function\n");

	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);	
	
	SMT_WRITE(TIMER0_DAT, 0x3000);
	SMT_WRITE(TIMER1_DAT, 0x6000);
	SMT_WRITE(TIMER2_DAT, 0xc000);
	SMT_WRITE(TIMER3_DAT, 0xc000);
	SMT_WRITE(TIMER0_PRE, 0x03ff);
	SMT_WRITE(TIMER1_PRE, 0x03ff);
	SMT_WRITE(TIMER2_PRE, 0x03ff);
	SMT_WRITE(TIMER3_PRE, 0x03ff);
	SMT_WRITE(TIMER0_CON, 0x0001);
	SMT_WRITE(TIMER1_CON, 0x0001);
	SMT_WRITE(TIMER2_CON, 0x0001);
	SMT_WRITE(TIMER3_CON, 0x0001);

	RequestIRQ(IRQ_TIMER0, TimerIRQ);
	RequestIRQ(IRQ_TIMER1, TimerIRQ);
	RequestIRQ(IRQ_TIMER2, TimerIRQ);
	RequestIRQ(IRQ_TIMER3, TimerIRQ);
	
	Enable_IRQ();
		 	
	while(1)
	{
		;
	}
	
	return 0;
}


#include <stdio.h>
#include <stdlib.h>
#include <math.h>

smtBoolean init_gpio_polling(void)
{
	GpioProperty gpio;
	smtBoolean ret;
	
	// Card Power Enable
	GPIO0_OE = 0x80000000;

	gpio.intLevel 	 = 1;
	gpio.intPolarity = 0;
	gpio.intBothEdge = 0; 	

	gpio.gpioNum	 = 29;
	smtGPIOSetIntProperty(GPIO0_TYPE, &gpio);

	ret = SMT_READ(GPIO0_IN)>>29;
	if(ret&0x01)
	{
		ret = SMT_FALSE; /* card extract */
	}
	else
	{
		ret = SMT_TRUE; /* card insert */
	}

	gpio.intLevel 	 = 0;
	gpio.intPolarity = 0;
	gpio.intBothEdge = 1; 	

	gpio.gpioNum	 = 29;
	smtGPIOSetIntProperty(GPIO0_TYPE, &gpio);	

	gpio.intLevel 	 = 1;
	gpio.intPolarity = 1;
	gpio.intBothEdge = 0; 	

	gpio.gpioNum	 = 30;
	smtGPIOSetIntProperty(GPIO0_TYPE, &gpio);	

	return ret;
}

int main1(void)
{	
	smtInt32 i;
	smtUint32 *s_addr = (smtUint32 *)0x60000000;
	
	// Vector table copy to virtual addr(0x0) mapped by mmu
	for(i=0;i<36;i++)
		*s_addr++ = mboot[i];
		
	Disable_IRQ();
	MMU_Init();
	Enable_IRQ();
#if 1
	// uart init
	uartBasicCfg.baudrate		= 38400;
	uartBasicCfg.enInt			= 0x0;	// 0 : Enable int, 1 : Disable int
	uartBasicCfg.enRxTimeout	= 0x0;
	uartBasicCfg.swReset		= 0x0;
	uartBasicCfg.enDmaReq		= 0x0;
	uartBasicCfg.parity			= 0x0;
	uartBasicCfg.dataBit		= 0x1;
	uartBasicCfg.stopBit		= 0x0;
	uartBasicCfg.enLoopBack		= 0x0;
	uartBasicCfg.txWaterLev		= 0x8;
	uartBasicCfg.rxWaterLev		= 0x8;
	#ifdef __CT500_EVB__	
	uartBasicCfg.uartCh			= UART_CHANNEL3;
	#else
	uartBasicCfg.uartCh			= UART_CHANNEL0;
	#endif
	// Invert flag : Enable interrupt, Interrupt assert flag

	smt2UARTInit(&uartBasicCfg);
#endif

	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);

	// 1. SMT Test code Routine
	//smt2UARTPrint(CFG_UART_CH, "Main function : Test start\n");
	//SMTTestFunc();

	// 2. SMT First Application
	//SMTFirstApp();

	// 3. Enter F/W Application
	//smt2UARTDeInit(CFG_UART_CH);
	//EnterFW();

	// 4. SMT Test scenario
	SMTTestScenario();
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
	smtUint8 user_input;
	smtInt8 backToMain[] = "Type '0' to return Menu\n";

	while(1)
	{
		smt2UARTPrint(CFG_UART_CH, "==== Test Menu ====\n");
		smt2UARTPrint(CFG_UART_CH, "1. Back Ground Music Play\n");
		smt2UARTPrint(CFG_UART_CH, "2. Audio Delayed Loop Back\n");
		smt2UARTPrint(CFG_UART_CH, "3. Video Test\n");
		smt2UARTPrint(CFG_UART_CH, "4. Interrupt Test\n");

		do
		{
			smt2UARTGetCh(CFG_UART_CH, &user_input, 0);

		} while(user_input < '1' && user_input > '4');

		switch(user_input)
		{
			case '1':
				smt2UARTPrint(CFG_UART_CH, "Back Ground Music Play Start\n");
				smt2UARTPrint(CFG_UART_CH, backToMain);
				BGMTest();
				break;
			case '2':
				smt2UARTPrint(CFG_UART_CH, "Audio Delayed Loop Back Start\n");
				smt2UARTPrint(CFG_UART_CH, backToMain);
				AudioDelayedLoopback();
				break;
			case '3':
				smt2UARTPrint(CFG_UART_CH, "Video Output Test\n");
				smt2UARTPrint(CFG_UART_CH, backToMain);
				VideoTest();
				break;
			case '4':
				smt2UARTPrint(CFG_UART_CH, "Interrupt Test Start\n");
				smt2UARTPrint(CFG_UART_CH, backToMain);
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
	smtUint32	ret = SMT_ERROR;
	smtUint8	uart_input;
	/*-----------------------------------
		Basic peripheral Test
		Timer / WDT / E-DMA
	-----------------------------------*/
	#if GPIO_TEST
	// GPIO Test
	ret = GPIOTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"GPIO test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	#if TIMER_PWM_TEST
	// Timer Test
	ret = TimerTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"TIMER test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	#if WDT_TEST	
	// WDT Test
	ret = WDTTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"WDT test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	
	#if DMA_TEST
	// E-DMA Test
	ret = DMATest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"E/G DMA test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif

	/*-----------------------------------
		Communication Test
		I2C / I2S / SPI / UART / USB
	-----------------------------------*/
	#if I2C_TEST
	// I2C Test
	ret = ADV7181BTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"I2C test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	
	#if I2S_TEST
	// I2S Test
	ret = I2STest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"I2S test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	
	#if SPI_TEST
	// SPI Test
	ret = SST25VF020Test();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"SPI test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	
	#if UART_TEST
	// UART Test
	smtDelay100us(1000);
	smt2UARTDeInit(CFG_UART_CH);
	ret = UARTTest();
	smt2UARTInit(&uartBasicCfg);
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"UART test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif

	#if USB_TEST
	ret = USBTest(init_gpio_polling());		
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"USB test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	/*-----------------------------------
		Display Test
		DM / Video Encoder / VIF
	-----------------------------------*/
	#if DM_TEST
	// DM Test
	ret = DMTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"DM(Display Module) test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	
	#if VIF_TEST
	// VIF test
	ret = VideoInputTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"External VIF test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	

	/*-----------------------------------
		Storage Test
		SD/MMC / NAND / SRAM / DDR SDRAM
	-----------------------------------*/
	#if SDMMCC_TEST
	// SD/MMC Test
	//SD card
	smt2UARTPrint(CFG_UART_CH, "\ninsert SD card!!\n");
	smt2UARTPrint(CFG_UART_CH, "\nPress any key to SDMMCTest\n");
	smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);

	ret = SDMMCTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"SD card test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	
	//MMC card
	smt2UARTPrint(CFG_UART_CH, "\ninsert MMC card!!\n");
	smt2UARTPrint(CFG_UART_CH, "\nPress any key to SDMMCTest\n");
	smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
	ret = SDMMCTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"MMC test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}

	//RS MMC card
	smt2UARTPrint(CFG_UART_CH, "\ninsert RS MMC card!!\n");
	smt2UARTPrint(CFG_UART_CH, "\nPress any key to SDMMCTest\n");
	smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
	ret = SDMMCTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"RSMMC test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif

	#if FMC_TEST
	// NAND Test
	ret = NANDTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"NAND test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	
	#if SMC_TEST
	// SRAM Test
	ret = ESRAMTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"SRAM test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif

	#if DDRC_TEST
	// DDR Test
	ret = DDRSDRAMTest();
	if(ret != SMT_SUCCESS)
	{
		smt2UARTPrint(CFG_UART_CH,"DDR test failed!!!\n");
		smt2UARTPrint(CFG_UART_CH,"press any key to continue!!!\n");
		smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);		
	}
	#endif
	return;
}
