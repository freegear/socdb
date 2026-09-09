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

/*/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"

/*/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// */

/* When you wanna test a peri-module, define the following */

// Peripheral Module Test
#define	ADC_TEST			1
#define	DMA_TEST			0
#define	INTERRUPT_TEST	0
#define	GPIO_TEST			0
#define	PLL_TEST			0
#define	PWR_TEST			0
#define	REGISTER_TEST		0
#define	TIMER_PWM_TEST	1
#define	WDT_TEST			0

// Communication Module Test
#define	CS8900_TEST		0
#define	GPS_TEST			0
#define	I2C_TEST			0
#define	I2S_TEST			0
#define	UART_TEST			1
#define	USB_TEST			0
#define	SPI_TEST			0

// Display Module Test
#define	DM_TEST			0

// Media Module Test
#define	AUDIO_TEST			0

// Storage Module Test
#define	SDRAM_TEST		0
#define	SMC_TEST			0
#define	FMC_TEST			0

// 2D Accelerator Module Test
#define	TWODACCEL_TEST	0


/*/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
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
smtUint32 CS8900Test(void);
smtUint32 GPSTest(void);
smtUint32 I2CTest(void);
smtUint32 I2STest(void);
smtUint32 UARTTest(void);
smtUint32 USBTest(void);
smtUint32 SPITest(void);

// Display Test Function
smtUint32 DMTest(void);

// Media Test Function
smtUint32 AudioTest(void);

// Storage Test Function
smtUint32 SDRAMTest(void);
smtUint32 ESMCTest(void);
smtUint32 FMCTest(void);

// 2D Accelerator Test Function
smtUint32 TwoDAcceleratorTest(void);


/*/////////////////////////////////////////////////////////
	VARIABLE DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: Main()
	Prototype		: void Main(void)
	Return			: void
	Argument		:
	Comments		:
----------------------------------------------------------*/
void Main(void)
{
	smtUint32 errorCode = 0;	// Valid only last 4 bit

	// 1. VIC Initialization
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);

	// Other Initialization
	// GPIO & Timer/PWM & UART & ADC & WDT -> Further work (When test evaluation board)


	///////////////////////////
	// 2. Module Test
	// Peripheral Module Test
#if REGISTER_TEST
	errorCode = RegisterTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if INTERRUPT_TEST
	errorCode = VICTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if ADC_TEST
	errorCode = ADCTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if DMA_TEST
	errorCode = DMATest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if GPIO_TEST
	errorCode = GPIOTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if PLL_TEST
	errorCode = PLLTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if PWR_TEST
	errorCode = PWRManageTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if TIMER_PWM_TEST
	errorCode = TimerTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if WDT_TEST
	errorCode = WDTTest();
	if(errorCode != NO_ERROR)
        	goto out;
#endif

// Communication Module Test
#if CS8900_TEST
	errorCode = CS8900Test();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if GPS_TEST
	errorCode = GPSTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if I2C_TEST
	errorCode = I2CTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if I2S_TEST
	errorCode = I2STest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if UART_TEST
	errorCode = UARTTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if USB_TEST
	errorCode = USBTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if SPI_TEST
	errorCode = SPITest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

	// Display Module Test
#if DM_TEST
	errorCode = DMTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

	// Media Module Test
#if AUDIO_TEST
	errorCode = AudioTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

	// Storage Module Test
#if SDRAM_TEST
	errorCode = SDRAMTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if SMC_TEST
	errorCode = ESMCTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

#if FMC_TEST
	errorCode = FMCTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif

	// 2D Accelerator Module Test
#if TWODACCEL_TEST
	errorCode = TwoDAcceleratorTest();
	if(errorCode != NO_ERROR)
		goto out;
#endif


out :
	//SMT_WRITE(GPIO_CON2, 0x0000FFFF);	// GPIO2 : all push-pull output
	SMT_WRITE(GPIO0_OE, 0x0000FFFF);
	// Stop Simulation
	//SMT_WRITE(GPIO_DAT2, 0x000000D0 | (errorCode&0x0000000F));
	SMT_WRITE(GPIO0_OUT, 0x000000D0 | (errorCode&0x0000000F));

	// inifinte loop & never return
	while(1);
}
