/*----------------------------------------------------------
	File Name   : adc.c 
	Description : ADC controller test routine
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"
#include "Commonmacro.h"
#include "irq.h"
#include "lib.h"
#include "adc.h"

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

smtUint32 ADCTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

volatile static smtUint32 interruptCountRead = 0;
volatile static smtUint32 PASS_TEST = 0;

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define     READSTARTMODE_PASS  1
#define     ADENMODE_PASS       2
#define     INT_TOTAL_COUNT     7

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : ADCTest()
    Prototype       : smtUint32 ADCTest(void)
    Return          : smtUint32
    Argument        :
    Comments        : Test ADC controller
-----------------------------------------------------------------------*/
smtUint32 ADCTest(void)
{
    smtUint32   sysConReg;

    //setting ACLKDIV
    sysConReg = SMT_READ(SYSCON);
    SMT_WRITE(SYSCON, sysConReg &
             ((0x00<<SHIFT_DN_FROM_MASK(ADC_CLK_DIV)) | 0x00FF) ); 

    //READ_START mode test_____________________________
    ReadStartSet();
    //_________________________________________________

    //check pass mode
    while(PASS_TEST != READSTARTMODE_PASS);

    //ADEN mode test___________________________________
    ADENSet();
    //_________________________________________________


    //check pass mode
    while(PASS_TEST != ADENMODE_PASS);
    


    if(PASS_TEST == ADENMODE_PASS)
    {
        //STBY TEST
        SMT_WRITE(ADCCON, 
                0x0<<SHIFT_DN_FROM_MASK(ADENABLE) |
                0x0<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
                0x1<<SHIFT_DN_FROM_MASK(ADC_STBY) |
                0x0<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );

        //PASS TEST READSTARTMODE & ADENMODE
        return NO_ERROR;
    }
    else 
    {
        //STBY TEST
        SMT_WRITE(ADCCON, 
                0x0<<SHIFT_DN_FROM_MASK(ADENABLE) |
                0x0<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
                0x1<<SHIFT_DN_FROM_MASK(ADC_STBY) |
                0x0<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );
        return ADC_ERROR;
    }
    return ADC_ERROR;
}    

/*-----------------------------------------------------------------------
    Function name   : ReadStartSet()
    Prototype       : void ReadStartSet(void)
    Return          : void
    Argument        :
    Comments        : ReadStartSet function
-----------------------------------------------------------------------*/
void ReadStartSet(void)
{
    smtUint32   temp;
    //Enable = 0
    //Read_START = 1
    //ADC_STBY = 0
    //ADC_IN_SEL = 0
    SMT_WRITE(ADCCON, 
                0x0<<SHIFT_DN_FROM_MASK(ADENABLE) |
                0x1<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
                0x0<<SHIFT_DN_FROM_MASK(ADC_STBY)       |
                0x0<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );

    //START conversion
    temp = SMT_READ(ADCDAT);

    //ISR define
    RequestIRQ(IRQ_ADC, ADCReadISR);
}


/*-----------------------------------------------------------------------
    Function name   : ADENSet()
    Prototype       : void ADENSet(void)
    Return          : void
    Argument        :
    Comments        : ADENSet function
-----------------------------------------------------------------------*/
void ADENSet(void)
{
    //Enable = 0
    //Read_START = 1
    //ADC_STBY = 0
    //ADC_IN_SEL = 0
    SMT_WRITE(ADCCON, 
                0x1<<SHIFT_DN_FROM_MASK(ADENABLE) |
                0x0<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
                0x0<<SHIFT_DN_FROM_MASK(ADC_STBY)       |
                0x0<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );
    //ISR define
    RequestIRQ(IRQ_ADC, ADCADENISR);
}



/*-----------------------------------------------------------------------
    Function name   : ADCADENISR()
    Prototype       : void ADCADENISR(smtUint32)
    Return          : smtUint32
    Argument        :
    Comments        : ADEN enable interrupt service 
-----------------------------------------------------------------------*/
void ADCADENISR(smtUint32 IRQ)
{

    smtUint32 readData;

    // GPIO2 : all push-pull output
    SMT_WRITE(GPIO_CON2, 0x0000FFFF);	

    /*
        ADC output SEL = 3'b000   output => 0
        SEL = 3'b001   output => 1
        SEL = 3'b ~~~~
    
        SEL = 3'b111   output => 7
    */
    interruptCountRead++;
    
    //check that ADC is not busy, before set ADEN = 1
    // ADC_FLAG = 1'b1 --> not busy
    while((ADC_FLAG & SMT_READ(ADCCON)) != ADC_FLAG);


    SMT_WRITE(ADCCON, 
            0x1<<SHIFT_DN_FROM_MASK(ADENABLE) |
            0x0<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
            0x0<<SHIFT_DN_FROM_MASK(ADC_STBY) |
            (interruptCountRead)<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );
    
    readData = SMT_READ(ADCDAT);

    // Read DATA from ADC controller
    SMT_WRITE(GPIO_DAT2, ((interruptCountRead -1) & 0x0000000F) | 0x000000C0);
    SMT_WRITE(GPIO_DAT2, (readData   & 0x0000000F) | 0x000000E0);

    if(interruptCountRead >= INT_TOTAL_COUNT)
    {
        PASS_TEST = ADENMODE_PASS;
        ReleaseIRQ(IRQ);
    }
}

/*-----------------------------------------------------------------------
    Function name   : ADCReadISR()
    Prototype       : void ADCReadISR(smtUint32)
    Return          : smtUint32
    Argument        :
    Comments        : ReadStart interrupt service 
-----------------------------------------------------------------------*/
void ADCReadISR(smtUint32 IRQ)
{
    smtUint32 readData;

    // GPIO2 : all push-pull output
    SMT_WRITE(GPIO_CON2, 0x0000FFFF);	

        /*
                ADC output SEL = 3'b000   output => 0
                SEL = 3'b001   output => 1
                SEL = 3'b ~~~~

                SEL = 3'b111   output => 7
        */

    interruptCountRead++;

    SMT_WRITE(ADCCON, 
                    0x0<<SHIFT_DN_FROM_MASK(ADENABLE) |
                    0x1<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
                    0x0<<SHIFT_DN_FROM_MASK(ADC_STBY) |
                    (interruptCountRead)<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );


    //check that ADC is not busy, before read data
    // ADC_FLAG = 1'b1 --> not busy
    while((ADC_FLAG & SMT_READ(ADCCON)) != ADC_FLAG);

    readData = SMT_READ(ADCDAT);

    // Read DATA from ADC controller
    SMT_WRITE(GPIO_DAT2, ((interruptCountRead -1) & 0x0000000F) | 0x000000A0);
    SMT_WRITE(GPIO_DAT2, (readData   & 0x0000000F) | 0x000000B0);

    if(interruptCountRead >= INT_TOTAL_COUNT)
    {
        PASS_TEST = READSTARTMODE_PASS;
        interruptCountRead = 0;
        ReleaseIRQ(IRQ);
    }
}
