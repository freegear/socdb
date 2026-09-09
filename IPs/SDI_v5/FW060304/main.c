/*----------------------------------------------------------
	File Name   : main.c 
	Description : Application Entry Point File
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/* When you wanna test a peri-module, define the following */

#define INTERRUPT_TEST          0
#define TIMER_PWM_TEST          1
#define WDT_TEST                0
#define UART_TEST               0
#define I2C_TEST                0
#define GPIO_TEST               0
#define ADC_TEST                1
#define SMC_TEST                0
#define FMC_TEST                0
#define PWR_TEST                0
#define REGISTER_TEST           0


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 VICTest(void);
smtUint32 TimerTest(void);
smtUint32 WDTTest(void);
smtUint32 UARTTest(void);
smtUint32 I2CTest(void);
smtUint32 GPIOTest(void);
smtUint32 ADCTest(void);
smtUint32 ESMCTest(void);
smtUint32 FMCTest(void);
smtUint32 PWRManageTest(void);
smtUint32 RegisterTest(void);


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name   : Main()
    Prototype           : void Main(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void Main(void)
{
    smtUint32 errorCode = 0;	// Valid only last 4 bit

    // 1. VIC Initialization
    EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);

    // Other Initialization
    // GPIO & Timer/PWM & UART & ADC & WDT -> Further work (When test evaluation board)


    ///////////////////////////
    // 2. Module Test
    // Interrupt Controller Test
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

#if UART_TEST
    errorCode = UARTTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if I2C_TEST
    errorCode = I2CTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if GPIO_TEST
    errorCode = GPIOTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if ADC_TEST
    errorCode = ADCTest();
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

#if PWR_TEST
    errorCode = PWRManageTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

out :
	SMT_WRITE(GPIO_CON2, 0x0000FFFF);	// GPIO2 : all push-pull output
	// Stop Simulation
	SMT_WRITE(GPIO_DAT2, 0x000000D0 | (errorCode&0x0000000F));

	// inifinte loop & never return
	while(1);
}
