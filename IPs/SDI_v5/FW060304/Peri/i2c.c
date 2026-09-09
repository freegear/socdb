/*----------------------------------------------------------
	File Name   : i2c.c 
	Description : I2C test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "i2c.h"
#include "global.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define SLAVE_ADDR0     0x00B0
#define SLAVE_ADDR1     0x00C0
//#define I2C1_STATUS     (*(volatile unsigned *)0x01FF8398)

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

smtUint32 I2CTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

//static volatile int interruptWaiting;
static volatile smtInt32 slaveError;
static volatile smtInt32 readOrWrite0;
static volatile smtInt32 readOrWrite1;
static volatile smtInt32 testMode;
static volatile smtInt32 I2C0Cnt;
static volatile smtInt32 I2C1Cnt;
volatile smtInt32 readDataM[256] = {0xaa,0x00,};
volatile smtInt32 writeDataM[10] = {0x01,0x03,0x80,0x81,0xff,0xaa,0xeb,0xcc,0xde,0xf0};
volatile smtInt32 count;
volatile smtInt32 subAddress;
volatile smtBoolean repeatStart;
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : I2CTest()
    Prototype           : smtUint32 I2CTest(void)
    Return              : error code
    Argument        :
    Comments        : Return a error-code

    I2C register list

    IIC0

        ICCR0_0  - Control register			(R/W) 
        ICSR0    - Control/Status register	(R/W)
        IAR0     - Slave Address register	(R/W)
        IDSR0    - Data register			(R/W)
        ICCR0_1  - Clock Control register	(R/W)

    IIC1

        ICCR1_0  - Control register			(R/W)
        ICSR1    - Control/Status register	(R/W)
        IAR1     - Slave Address register	(R/W)
        IDSR1    - Data register			(R/W)
        ICCR1_1  - Clock Control register	(R/W)

        // ICCR0 register
        ACK_EN              (0x1UL)<<7
        TX_CLK_SEL          (0x1UL)<<6 // We NOT USE!!!
        INTERRUPT_EN        (0x1UL)<<5
        INTR_PENDING_FLAG   (0x1UL)<<4
        TX_CLK_VALUE        (0xfUL)<<0 // We NOT USE!!!

        // ICCR1 register
        HIGH_SPEED_CYCLE    (0x3fUL)<<0
        
        
        Sampling Freq = Fclk/(2^ICCR1[2:0])
        
        SCL Freq = (Sampling Freq)/(10*ICCR1[6:3])

        // ICSR register
        I2C_MODE_SEL        (0x3UL)<<6
        I2C_START           (0x1UL)<<5
        TXRX_EN             (0x1UL)<<4
        ARBITOR_FLAG        (0x1UL)<<3
        START_BIT           (0x1UL)<<2
        ZERO_ADDR_FLAG      (0x1UL)<<1
        LAST_RX_BIT_FLAG    (0x1UL)<<0

        // IAR register
        SLAVE_ADDR_MASK     (0x7fUL)<<1
        // IDSR register
        DATA_SHIFT_MASK     (0xffUL)<<0

-----------------------------------------------------------------------*/
smtUint32 I2CTest(void)
{
    smtUint8 addr, data0, data1;
    smtUint8 i, error0, error1, error2, error3, error4, error5;
    smtUint8 matchData1[20]={0xaa,0x00,0x00,0x00,0x00,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0,};
    smtUint8 matchData2[10]={0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a};
    
    smtUint8 data[10]={0x00,0x55,};

	readOrWrite0 = 1;
	readOrWrite1 = 1;

    addr = 0xa0;
    data0 = 0x55;
    data1 = 0x00;
	
	repeatStart = 0;
	count = 0;
	subAddress =0;
	
    error0 = error1 = error2 = error3 = error4 = error5 = SMT_SUCCESS;
    testMode = 4; // I2C0(master)-> slave_model testmode
    
    gI2C.highPeriod = 0x05;
    gI2C.channel = I2C_CH0;
    gI2C.slaveAddr = 0xB0;
    
    slaveError = SMT_SUCCESS;
    I2C0Cnt = 0;
    I2C1Cnt = 0;

    // Register I2C isr handle function
    RequestIRQ(IRQ_I2C0, I2C0Isr);                  // I2C0 Interrupt Handler
    //I2C0 only master...
    //RequestIRQ(IRQ_I2C0_AAS, I2C0_AASIsr);  // I2C0_AAS Interrupt Handler
    RequestIRQ(IRQ_I2C1, I2C1Isr);                  // I2C1 Interrupt Handler
    RequestIRQ(IRQ_I2C1_AAS, I2C1_AASIsr);  // I2C1_AAS Interrupt Handler
  
    // Register PreSetting
    //I2C0  pre-setting
    SMT_WRITE(ICCR0_1, 0x00);             // load prescaler
    SMT_WRITE(IAR0, 0x00B0);              // I2C0 Device Address setting
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);     // I2C0 interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN);            // I2C0 Serial Output Enable for Slave
    
    //I2C1  pre-setting
    SMT_WRITE(ICCR1_1, 0x05);             // load prescaler
    SMT_WRITE(IAR1, 0x00C0);              // I2C1 Device Address setting
    SMT_WRITE(ICCR1_0, INTERRUPT_EN);     // I2C1 interrupt enable
    SMT_WRITE(ICSR1, TXRX_EN);            // I2C1 Serial Output Enable for Slave
   	
    // !!!! this function must setting !!!!	
   	SMT_WRITE(ICCR1_0, ACK_EN|INTERRUPT_EN);   // ACK enable
	 
    //--------------- I2C0 Master to Slave test-----------------
    // !!! Other slave TEST !!!
    //
    // Write Operation to I2CSlavemodel
    ////////////////
    smt2I2CWrite(addr, data, 2);
    
    // Read Operation
    ////////////////
    smt2I2CRead(addr, data, 2);
   
    if(data[1] == data[0])
        error4 = SMT_SUCCESS;
    else
        error4 = SMT_ERROR;
    
    /*// !!! Loop Back TEST !!!
    // I2C0(Master Tx)  I2C1(Slave Rx)
    ////////////////////////////////////////////////////
    I2CLoopTest(0,&error0);
    // !!! Loop Back TEST !!!
    // I2C0(Master Rx)  I2C1(Slave Tx)
    ////////////////////////////////////////////////////
    I2CLoopTest(1,&error1);
    // !!! Loop Back TEST !!!
    // I2C1(Master Tx)  I2C0(Slave Rx)
    ////////////////////////////////////////////////////
    I2CLoopTest(2,&error2);
    // !!! Loop Back TEST !!!
    // I2C1(Master Rx)  I2C0(Slave Tx)
    ////////////////////////////////////////////////////
    I2CLoopTest(3,&error3);
    // Release I2C isr handle function
    */
    
    //--------------I2C1 Slave Test1---------------------------
    //start->slave address(W)-> subaddress -> data 
    //---------------------------------------------------------
    while(count<9);

    for(i=0 ; i<10 ; i++)
    {
        if (readDataM[i] != matchData1[i])
        error5=SMT_ERROR;
    }

    while(count != 1);
    while(count<10);

	
	while(count != 1);
    while(count<9);
    
    while(count != 1);
    while(count<9);

	for(i=0 ; i<9 ; i++)
    {
        if (readDataM[i+15] != matchData2[i])
        error3=SMT_ERROR;
    }

    //IRQ relese...
    ReleaseIRQ(IRQ_I2C0);
    ReleaseIRQ(IRQ_I2C1);
    ReleaseIRQ(IRQ_I2C0_AAS);
    ReleaseIRQ(IRQ_I2C1_AAS);
 
    //All error check
    if((error0 && error1 && error2 && error3 && error4 && error5 && slaveError) == SMT_SUCCESS)
        return NO_ERROR;
    else
        return I2C_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : I2C0Isr()
    Prototype           : static void I2C0Isr(smtUint32 IRQ)
    Return              : 
    Argument        :
    Comments        : I2C0 interrupt handle function
-----------------------------------------------------------------------*/
static void I2C0Isr(smtUint32 IRQ)
{
    smtI2CMasterHandler();
}

/*-----------------------------------------------------------------------
    Function name   : I2C1Isr()
    Prototype           : static void I2C0Isr(smtUint32 IRQ)
    Return              : 
    Argument        :
    Comments        : I2C1 interrupt handle function
-----------------------------------------------------------------------*/
static void I2C1Isr(smtUint32 IRQ)
{
    smtI2CSlaveHandler();  	// I2C1 slave test function
}

/*-----------------------------------------------------------------------
    Function name   : I2C0_AASIsr()
    Prototype           : static void I2C0_AASIsr(smtUint32 IRQ)
    Return              : 
    Argument        :
    Comments        : I2C0 AAS interrupt handle function
-----------------------------------------------------------------------*/
static void I2C0_AASIsr(smtUint32 IRQ)
{
    I2C0_AASTest();
}

/*-----------------------------------------------------------------------
    Function name   : I2C0_AASTest()
    Prototype           : void I2C0_AASTest(void)
    Return              : 
    Argument        :
    Comments        : I2C0 AAS loop back test function
-----------------------------------------------------------------------*/
void I2C0_AASTest(void)
{
    if (testMode==2)			// Data register Read for R/W bit detect
        readOrWrite0= 1;		// Receive mode select
    else
    {
        readOrWrite0 = 0;		// Transmit mode select
        SMT_WRITE(IDSR0,readDataM[0]);  // Write Next Data Register      
        I2C0Cnt++;
    }

    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    SMT_WRITE(ICCR0_0, ACK_EN|INTERRUPT_EN);   // ACK enable
}

/*-----------------------------------------------------------------------
    Function name   : I2C1_AASIsr()
    Prototype           : static void I2C1_AASIsr(smtUint32 IRQ)
    Return              : 
    Argument        :
    Comments        : I2C1 AAS interrupt handle function
-----------------------------------------------------------------------*/
static void I2C1_AASIsr(smtUint32 IRQ)
{
    I2C1AASHandler();
}

/*-----------------------------------------------------------------------
    Function name   : I2C1AASHandler()
    Prototype           : void I2C1AASHandler(void)
    Return              : 
    Argument        :
    Comments        : I2C slave AAS Isr function
-----------------------------------------------------------------------*/
void I2C1AASHandler(void)
{

	smtUint32 i2cStatus;

    i2cStatus = (0x1f & SMT_READ(ICSR1)) << 3 ;

    if (i2cStatus == 0x60)			//  Slave address + write bit received, ACK transmitted
    {                           

    	if ((readOrWrite1 == 1)|(count>2))		// repeat start reset
    	{
    	repeatStart = 0;
    	}
		
		readOrWrite1 = 0;							// for reset repeat condition
        SMT_WRITE(ICCR1_0,INTERRUPT_EN);			// Interrupt Clear
        SMT_WRITE(ICCR1_0,ACK_EN|INTERRUPT_EN);		// ACK bit setting
        count =1;
		
    }                           
    else if(i2cStatus == 0xa8)		//  Slave address + Read bit received, ACK transmitted
    {   

    	if ((readOrWrite1 == 1)|(count>2))		//  repeat start reset
    	{
    	repeatStart = 0;
    	}
    
    	if (repeatStart==1)                        
        {
        SMT_WRITE(IDSR1,readDataM[subAddress-1]);	// Next Data write
        subAddress++;
        }
        else
        {
        SMT_WRITE(IDSR1,readDataM[0]);				// Next Data write        
        }
        readOrWrite1 = 1;
        SMT_WRITE(ICCR1_0,INTERRUPT_EN);			// Interrupt Clear
        SMT_WRITE(ICCR1_0,ACK_EN|INTERRUPT_EN); 	// ACK bit setting
        count =1;

    }
}

