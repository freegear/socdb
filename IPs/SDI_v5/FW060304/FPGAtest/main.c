/*----------------------------------------------------------
	File Name   : main.c 
	Description : Application Entry Point File
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#define  __GCC_ARM__  1
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq_toy.c"

//FPGA GCC environment
#include "inc.h"
#include "./API/apiuart.c"
#include "./API/apii2c.c"
#include "./API/apiwdt.c"
#include "./API/apigpio.c"
#include "./API/apipower.c"
#include "./API/apipwm.c"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/* When you wanna test a peri-module, define the following */

#define INTERRUPT_TEST          0
#define TIMER_PWM_TEST          0
#define WDT_TEST                0
#define UART_TEST               0
#define I2C_TEST                0
#define GPIO_TEST               0
#define ADC_TEST                0
#define SMC_TEST                0
#define FMC_TEST                0
#define PWR_TEST                0
#define REGISTER_TEST           0


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

smtUint32 GPIOTest(void);

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


void PWMTEST(void);
void UART_Initial(void);
void UART_printf(char *);

int TEST_MODE1(void);
int TEST_MODE2(void);
int TEST_MODE3(void);

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
    smtUint32 getchar = 0;

    // 1. VIC Initialization
    EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);

//___________________FPGA test start
    #if GPIO_TEST 
    GPIOOUTTEST();
    while(1);
    #endif

    //SMT_WRITE(GPIO_CON2, 0x0000FFFF);	// GPIO2 : all push-pull output
	//SMT_WRITE(GPIO_DAT2, 0x0000ffff);
    //while(1);


    UART_Initial();
    
//	SMT_WRITE(SYSCON,0X1054);// 46 54 62
    while(1)
    {
        UART_printf("_______________TEST SDIV5 (UART test)_____________________________\n\r");
        UART_printf("\n\r");
        UART_printf("_______________Press FPGA MODE Number_____________________________\n\r");
        UART_printf("_______________1. FPGA MODE : GENERAL TEST MODE___________________\n\r");
        UART_printf("_______________2. FPGA MODE : TCAP, TCLK TEST MODE________________\n\r");
        UART_printf("_______________3. FPGA MODE : SMC, PWM TEST MODE__________________\n\r");

        UART_printf("__________________________________________________________________\n\r");
        UART_printf("\n\r");
        
        getchar = UART_getch();
        switch(getchar)
        {
            case 0x31: while (TEST_MODE1()!=1);
                    break;
            case 0x32: while (TEST_MODE2()!=1);
                    break;
            case 0x33: while (TEST_MODE3()!=1);
                    break;
                    
        }
    }

    while(1);

//___________________FPGA test end


    // Other Initialization
    // GPIO & Timer/PWM & UART & ADC & WDT -> Further work (When test evaluation board)


    ///////////////////////////
    // 2. Module Test
    // Interrupt Controller Test
    
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

#if REGISTER_TEST
    errorCode = RegisterTest();
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

/*-----------------------------------------------------------------------
    Function name   : TEST_MODE1()
    Prototype           : int TEST_MODE1(void)
    Return              : int
    Argument        :
    Comments        : TEST function for FPGA MODE1
-----------------------------------------------------------------------*/
int TEST_MODE1(void)
{
    
    smtUint32 getchar = 0;
    while(1)
        {   
        UART_printf("_____________TEST SDIV5 (UART test)__________________\n\r");
        UART_printf("_______________Press Test Number_____________________\n\r");
        UART_printf("\n\r");
        UART_printf("1. GPIO IN TEST (INSERT SWITCH IN GPIO SOCKET)\n\r");
        UART_printf("2. External Interrupt TEST \n\r");
        UART_printf("3. WDT TEST \n\r");
        UART_printf("4. TIMER TEST \n\r");
        UART_printf("5. I2C TEST \n\r");
        UART_printf("6. GPIO OUT TEST \n\r");
        UART_printf("7. PWR TEST \n\r");
        UART_printf("0. RETURN PREVIOUS MENU\n\r");
        UART_printf("\n\r");
        UART_printf("______________________________________________________\n\r");
        UART_printf("\n\r");
        UART_printf("\n\r");

    
        getchar = UART_getch();
   
        switch(getchar)
        {
            case 0x31://GPIO IN TEST
                UART_printf("GPIO INPUT TEST : GPIO S/W INPUT TEST \n\r");
                GPIOINTEST();
                break;
            
            case 0x32://External Interrupt TEST
    
                GPIO_EXINT();
                break;
    
    
	        case 0x33:// WDT TEST
                UART_printf("WTD TEST : WDT interupt test \n\r");
	            WDT_FPGATEST();//Insert code
    	        UART_printf("Press any key!!! \n\r");
	            UART_getch();
                break;
	    
    	    case 0x34:// TIMER TEST
    	        TIMER_INTERRUPT_TEST();
                UART_getch();
                ReleaseIRQ(IRQ_TIMER0_TMC);
                ReleaseIRQ(IRQ_TIMER1_TMC);
                ReleaseIRQ(IRQ_TIMER2_TMC);
                ReleaseIRQ(IRQ_TIMER3_TMC);
                ReleaseIRQ(IRQ_TIMER4_TMC);
                ReleaseIRQ(IRQ_TIMER5_TMC);
                ReleaseIRQ(IRQ_TIMER6_TMC);
                ReleaseIRQ(IRQ_TIMER7_TMC);
                UART_printf("TOUT ==> GPIO0 !!! \n\r");
    	        UART_printf("TOUT ==> GPIO2 !!! \n\r");
    	        UART_printf("Press any key!!! \n\r");
    	        UART_getch();
                break;
	        
	        
	     
    	    case 0x35:// I2C TEST AUDIO I2C REGISTER READ WRITE TEST
                UART_printf("I2C TEST :AUDIO CHIP I2C REGISTER READ WRITE TEST\n\r");
	            SMT_WRITE(GPIO_DAT2, 0Xffff);
	            AudioI2C_test();
    	        UART_printf("Press any key!!! \n\r");
	            UART_getch();
	            //Insert code
                break;
	        
    	    case 0x36:// SMC TEST
                UART_printf("GPIO OUTOUT TEST \n\r");
                GPIOOUTTEST2();
                break;
	        
	        case 0x37:// PWR TEST
                UART_printf("POWERMANAGEMENT TEST\n\r");
                POWERMANAGE_TEST();
                ReleaseIRQ(IRQ_TIMER0_TMC);
                ReleaseIRQ(IRQ_TIMER1_TMC);
                ReleaseIRQ(IRQ_TIMER2_TMC);
                ReleaseIRQ(IRQ_TIMER3_TMC);
                ReleaseIRQ(IRQ_TIMER4_TMC);
                ReleaseIRQ(IRQ_TIMER5_TMC);
                ReleaseIRQ(IRQ_TIMER6_TMC);
                ReleaseIRQ(IRQ_TIMER7_TMC);
                break;
            case 0x30:
                UART_printf("RETURN PREVIOUS MENU\n\r");
                UART_printf("\n\r");
                return 1;

            
        }
    }
}
/*-----------------------------------------------------------------------
    Function name   : TEST_MODE2()
    Prototype           : int TEST_MODE2(void)
    Return              : int
    Argument        :
    Comments        : TEST function for FPGA mode 2
-----------------------------------------------------------------------*/
int TEST_MODE2(void)
{
    smtUint32 getchar = 0;
    while(1)
        {   
        UART_printf("_____________TEST SDIV5 (UART test)__________________\n\r");
        UART_printf("_______________Press Test Number_____________________\n\r");
        UART_printf("\n\r");
        UART_printf("1. WDT TEST \n\r");
        UART_printf("2. I2C TEST \n\r");
        UART_printf("3. TCAP TEST \n\r");
        UART_printf("4. TCLK TEST \n\r");
        UART_printf("0. RETURN PREVIOUS MENU\n\r");
        UART_printf("\n\r");
        UART_printf("______________________________________________________\n\r");
        UART_printf("\n\r");
        UART_printf("\n\r");

    
        getchar = UART_getch();
   
        switch(getchar)
        {
    
	        case 0x31:// WDT TEST
                UART_printf("WTD TEST : WDT interupt test \n\r");
	            WDT_FPGATEST();//Insert code
    	        UART_printf("Press any key!!! \n\r");
	            UART_getch();
                break;

    	    case 0x32:// I2C TEST AUDIO I2C REGISTER READ WRITE TEST
                UART_printf("I2C TEST :AUDIO CHIP I2C REGISTER READ WRITE TEST\n\r");
	            SMT_WRITE(GPIO_DAT2, 0Xffff);
	            AudioI2C_test();
    	        UART_printf("Press any key!!! \n\r");
	            UART_getch();
	            //Insert code
                break;
	        
    	    case 0x33:// SMC TEST
                UART_printf("Number 6 \n\r");
	            TCAPTEST();
                break;
	        
	        case 0x34:// PWR TEST
                UART_printf("Number 7 \n\r");
                TCLKTEST();	        //Insert code
                break;
             case 0x30:
                UART_printf("RETURN PREVIOUS MENU\n\r");
                UART_printf("\n\r");

                return 1;

        }
    }
}
/*-----------------------------------------------------------------------
    Function name   : TEST_MODE3()
    Prototype           : int TEST_MODE3(void)
    Return              : int
    Argument        :
    Comments        : TEST function for FPGA mode 3
-----------------------------------------------------------------------*/
int TEST_MODE3(void)
{
    smtUint32 getchar = 0;
    while(1)
        {   
        UART_printf("_____________TEST SDIV5 (UART test)__________________\n\r");
        UART_printf("_______________Press Test Number_____________________\n\r");
        UART_printf("\n\r");
        UART_printf("1. WDT TEST \n\r");
        UART_printf("2. I2C TEST \n\r");
        UART_printf("3. PWM TEST \n\r");
        UART_printf("4. SMC TEST \n\r");
        UART_printf("0. RETURN PREVIOUS MENU\n\r");
        UART_printf("\n\r");
        UART_printf("______________________________________________________\n\r");
        UART_printf("\n\r");
        UART_printf("\n\r");

    
        getchar = UART_getch();
   
        switch(getchar)
        {
    
	        case 0x31:// WDT TEST
                UART_printf("WTD TEST : WDT interupt test \n\r");
	            WDT_FPGATEST();//Insert code
    	        UART_printf("Press any key!!! \n\r");
	            UART_getch();
                break;

    	    case 0x32:// I2C TEST AUDIO I2C REGISTER READ WRITE TEST
                UART_printf("I2C TEST :AUDIO CHIP I2C REGISTER READ WRITE TEST\n\r");
	            SMT_WRITE(GPIO_DAT2, 0Xffff);
	            AudioI2C_test();
    	        UART_printf("Press any key!!! \n\r");
	            UART_getch();
	            //Insert code
                break;
                
	        case 0x33:// PWM TEST
                UART_printf("PWM TEST : GPIO2 PWM TEST \n\r");
    	        UART_printf("PWM out to GPIO2 and ADDRESS and DATA !!! \n\r");
    	        PWMLINETEST();   
    	        //Insert code
                break;
                
    	    case 0x34:// SMC TEST
                UART_printf("Number 6 \n\r");
	            //TCAPTEST();
                break;
                
	        case 0x30:
                UART_printf("RETURN PREVIOUS MENU\n\r");
                UART_printf("\n\r");

                return 1;

        }
    }
}
