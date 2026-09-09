/*----------------------------------------------------------
	File Name   : apii2c.c 
	Description : i2c for PULSUS-PSM711A
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

// 
#define PSM711A_ADDR 0x38
#define BUS_ERROR 1
#define ARBIT_LOST 2
void I2C0_Initial(char prescaler);
void I2C0_2ByteWrite(char regAddr, char firstData, char secondData);
void I2C0_3ByteWrite(char regAddr,char firstData, char secondData, char thirdData);
static int I2C0_2ByteRead(char regAddr,char *first, char *second);
void I2C0_3ByteRead(char regAddr,char *first, char *second, char *third);
void value_test(char firstdata, char seconddata, char defaultMSB, char defaultLSB);
void AudioI2C_test(void);
void AUDIO_I2C_CHECK(char addr, char *firstdata, char *seconddata);
void I2CTESTMasterHandler(smtUint32 IRQ);
/*-----------------------------------------------------------------------
    Function name   : I2C0_Initial(char prescaler)
    Prototype       : void I2C0_Initial(char prescaler)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void I2C0_Initial(char prescaler)
{   
    RequestIRQ(IRQ_I2C0,I2CTESTMasterHandler);
    SMT_WRITE(ICCR0_1, prescaler);             // load prescaler
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);     // I2C0 interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN);            // I2C0 Serial Output Enable for Slave
}
/*-----------------------------------------------------------------------
    Function name   : I2C0_2ByteWrite(char regAddr,char firstData, char secondData)
    Prototype       : void I2C0_2ByteWrite(char regAddr,char firstData, char secondData)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void I2C0_2ByteWrite(char regAddr, char firstData, char secondData)
{   
    interruptWait = 1;
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);       // Interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);  //Start condition
    while(interruptWait == 1);              // Wait until I2C interrupt process is completed
    interruptWait = 1;

    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, ((PSM711A_ADDR<<1)|0x00));       // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 2. Addr transmit
    SMT_WRITE(IDSR0, regAddr);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 3. firstData transmit
    SMT_WRITE(IDSR0, firstData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 4. secondData transmit
    SMT_WRITE(IDSR0, secondData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 5. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear

}

/*-----------------------------------------------------------------------
    Function name   : I2C0_3ByteWrite(char regAddr,char firstData, char secondData, char thirdData)
    Prototype       : void I2C0_3ByteWrite(char regAddr,char firstData, char secondData, charthirdData)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void I2C0_3ByteWrite(char regAddr,char firstData, char secondData, char thirdData)
{   
    interruptWait = 1;
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);       // Interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);  //Start condition
    while(interruptWait == 1);              // Wait until I2C interrupt process is completed
    interruptWait = 1;

    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, ((PSM711A_ADDR<<1)|0x00));       // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 2. Addr transmit
    SMT_WRITE(IDSR0, regAddr);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 3. firstData transmit
    SMT_WRITE(IDSR0, firstData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 4. secondData transmit
    SMT_WRITE(IDSR0, secondData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 5. thirdData transmit
    SMT_WRITE(IDSR0, thirdData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 6. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear

}
/*-----------------------------------------------------------------------
    Function name   : I2C0_2ByteRead(char regAddr,char *first, char *second)
    Prototype       : void I2C0_2ByteRead(char regAddr,char *first, char *second)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static int I2C0_2ByteRead(char regAddr,char *first, char *second)
{
    UART_printf("address : ");
    UART_putchhex(regAddr);
    UART_printf(" read\n\r");
    
    
    // 0. Start condition
    interruptWait = 1;
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt enable
    while(interruptWait == 1);
    interruptWait = 1;
    
    if (SMT_READ(ICSR0)==0x40)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return BUS_ERROR;
        }
    else if (SMT_READ(ICSR0)==0x47)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return ARBIT_LOST;
        }
    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, 0x70);       // Master Rx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;
    
    if (SMT_READ(ICSR0)==0x40)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return BUS_ERROR;
        }
 //   else if (SMT_READ(ICSR0)==0x44)
 //       {
 //           SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
 //           return BUS_ERROR;
 //       }
    else if (SMT_READ(ICSR0)==0x47)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return ARBIT_LOST;
        }
    
    // 2. Addr transmit
    SMT_WRITE(IDSR0, regAddr);          // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    if (SMT_READ(ICSR0)==0x40)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return BUS_ERROR;
        }
   // else if (SMT_READ(ICSR0)==0x44)
      //  {
      //     SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
    //        return BUS_ERROR;
      //  }
    else if (SMT_READ(ICSR0)==0x47)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return ARBIT_LOST;
        }

    // 3. Repeat Start condition
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    if (SMT_READ(ICSR0)==0x40)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return BUS_ERROR;
        }
    //else if (SMT_READ(ICSR0)==0x44)
    //    {
    //        SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
    //        return BUS_ERROR;
    //    }
    else if (SMT_READ(ICSR0)==0x47)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return ARBIT_LOST;
        }

    // 4. Slave addr transmit
    SMT_WRITE(IDSR0, 0x71);      // Master Rx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    if (SMT_READ(ICSR0)==0x40)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return BUS_ERROR;
        }
    else if (SMT_READ(ICSR0)==0x47)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return ARBIT_LOST;
        }

    // 5. First Data read
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    SMT_WRITE(ICCR0_0, ACK_EN|INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    if (SMT_READ(ICSR0)==0x40)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return BUS_ERROR;
        }
    else if (SMT_READ(ICSR0)==0x47)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return ARBIT_LOST;
        }

    *first = SMT_READ(IDSR0);
    
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    
    while(interruptWait == 1);
    interruptWait = 1;
    if (SMT_READ(ICSR0)==0x40)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return BUS_ERROR;
        }
    else if (SMT_READ(ICSR0)==0x47)
        {
            SMT_WRITE(I2C0_SRST,0xFF);    //soft reset code
            return ARBIT_LOST;
        }

    // 6. Second Data read
    *second = SMT_READ(IDSR0);            //data read code
    UART_printf("read data : ");
    UART_putchhex(*first);
    UART_printf(" ");
    UART_putchhex(*second);
    UART_printf("\n\r");
    
    // 7. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    interruptWait = 1;
    return 0;

}
/*-----------------------------------------------------------------------
    Function name   : I2C0_3ByteRead(char regAddr,char *first, char *second, char *third)
    Prototype       : void I2C0_3ByteRead(char regAddr,char *first, char *second, char *third)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void I2C0_3ByteRead( char regAddr,char *first, char *second, char *third)
{
    
    // 0. Start condition
    interruptWait = 1;
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);
    while(interruptWait == 1);
    interruptWait = 1;

    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, ((PSM711A_ADDR<<1)|0x00));       // Master Rx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 2. Addr transmit
    SMT_WRITE(IDSR0, regAddr);                   // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

     // 3. Repeat Start condition
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 4. Slave addr transmit
    SMT_WRITE(IDSR0, ((PSM711A_ADDR<<1)|0x01));      // Master Rx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    SMT_WRITE(ICCR0_0, ACK_EN|INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 5. First Data read
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    SMT_WRITE(ICCR0_0, ACK_EN|INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;
    *first = SMT_READ(IDSR0);            //data read code
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    SMT_WRITE(ICCR0_0, ACK_EN|INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;
    
    // 6. Second Data read
    *second = SMT_READ(IDSR0);            //data read code
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;
    
    // 7. Second Data read
    *third = SMT_READ(IDSR0);            //data read code
    // 8. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    interruptWait = 1;

}

/*-----------------------------------------------------------------------
    Function name   : AudioI2C_test(void)
    Prototype       : boolean AudioI2C_test(void)
    Return          : boolean
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void AudioI2C_test(void)
{
    
    char firstdata;
    char seconddata;
    int error_return =0;
    I2C0_Initial(0xff);//11 is 400k 39 is 100k
    // Audio Chip default register value 
   
    SMT_WRITE(GPIO_CON3,GPIO3_GPIO_OUTPUT_MODE|0xf000); //AUDIO IC RESET
     
    UART_printf("AUDIO CODEC register default setting read Test\n\r");

    AUDIO_I2C_CHECK(0x00, &firstdata, &seconddata);
/*    do 
    {
    error_return=I2C0_2ByteRead(0x00, &firstdata, &seconddata);
    }   
    while(error_return!=0);*/

    value_test(firstdata,seconddata, 0x00, 0x01);
    
    AUDIO_I2C_CHECK(0x10, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0xBD);

    AUDIO_I2C_CHECK(0x11, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x30, 0x30);

    AUDIO_I2C_CHECK(0x15, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x2C, 0x2C);

    AUDIO_I2C_CHECK(0x17, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x01);

    AUDIO_I2C_CHECK(0x19, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x25);

    AUDIO_I2C_CHECK(0x1A, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x02);

    AUDIO_I2C_CHECK(0x1B, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x66);

    AUDIO_I2C_CHECK(0x1C, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x02);

    AUDIO_I2C_CHECK(0x1D, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x66);

    AUDIO_I2C_CHECK(0x1E, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x10);

    AUDIO_I2C_CHECK(0x30, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x03, 0x00);

    AUDIO_I2C_CHECK(0x31, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x04);

    AUDIO_I2C_CHECK(0x3A, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x00);

    AUDIO_I2C_CHECK(0x3B, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x00);

    AUDIO_I2C_CHECK(0x36, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x07, 0x07);

    AUDIO_I2C_CHECK(0x37, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x00);

    AUDIO_I2C_CHECK(0x38, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x00);

    AUDIO_I2C_CHECK(0x39, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x00);

    AUDIO_I2C_CHECK(0x3A, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x00);

    AUDIO_I2C_CHECK(0x3B, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x00, 0x00);
/*
    firstdata = 0x55; 
    seconddata = 0xAA;

    I2C0_2ByteWrite( 0x00, firstdata, seconddata);
    I2C0_2ByteWrite( 0x02, firstdata, seconddata);
    I2C0_2ByteWrite( 0x03, firstdata, seconddata);
    I2C0_2ByteWrite( 0x10, firstdata, seconddata);
    I2C0_2ByteWrite( 0x11, firstdata, seconddata);
    I2C0_2ByteWrite( 0x15, firstdata, seconddata);
    I2C0_2ByteWrite( 0x16, firstdata, seconddata);
    I2C0_2ByteWrite( 0x17, firstdata, seconddata);
    I2C0_2ByteWrite( 0x19, firstdata, seconddata);
    I2C0_2ByteWrite( 0x1A, firstdata, seconddata);
    I2C0_2ByteWrite( 0x1B, firstdata, seconddata);
    I2C0_2ByteWrite( 0x1C, firstdata, seconddata);
    I2C0_2ByteWrite( 0x1D, firstdata, seconddata);
    I2C0_2ByteWrite( 0x1E, firstdata, seconddata);
    I2C0_2ByteWrite( 0x30, firstdata, seconddata);
    I2C0_2ByteWrite( 0x31, firstdata, seconddata);
    I2C0_2ByteWrite( 0x32, firstdata, seconddata);
    I2C0_2ByteWrite( 0x3A, firstdata, seconddata);
    I2C0_2ByteWrite( 0x3B, firstdata, seconddata);
    I2C0_2ByteWrite( 0x36, firstdata, seconddata);
    I2C0_2ByteWrite( 0x37, firstdata, seconddata);
    I2C0_2ByteWrite( 0x38, firstdata, seconddata);
    I2C0_2ByteWrite( 0x39, firstdata, seconddata);
    I2C0_2ByteWrite( 0x3A, firstdata, seconddata);
    I2C0_2ByteWrite( 0x3B, firstdata, seconddata);

    I2C0_2ByteRead(0x00, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x02, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x03, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x10, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x11, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x15, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x16, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x17, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x19, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x1A, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x1B, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x1C, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x1D, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x1E, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x30, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x31, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x32, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x3A, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x3B, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x36, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x37, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x38, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x39, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x3A, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
    I2C0_2ByteRead(0x3B, &firstdata, &seconddata);
    value_test(firstdata,seconddata, 0x55, 0xAA);
*/
}


void AUDIO_I2C_CHECK(char addr, char *firstdata, char *seconddata)
{
    
    int error_return =0;
    do 
    {
    SMT_WRITE(I2C0_SRST,0xFF);
    SMT_WRITE(GPIO_DAT3,0x00); //AUDIO IC RESET
    smtDelay100us(100);
    smtDelay100us(100);
    smtDelay100us(100);
    SMT_WRITE(GPIO_DAT3,0xff); //AUDIO IC RESET
    smtDelay100us(100);
    smtDelay100us(100);
    smtDelay100us(100);
    error_return=I2C0_2ByteRead(addr, firstdata, seconddata);
    }   
    while(error_return!=0);
    UART_printf("press any key : next step\n\r");
    UART_getch();
    

}


void value_test(char firstdata, char seconddata, char defaultMSB, char defaultLSB)
{
    if ((firstdata==defaultMSB)&&(seconddata==defaultLSB))
        {
            UART_printf("Default value collect\n\r");
        }
    else
        {
            UART_printf("Default value not collect\n\r");
        }
}

void I2CTESTMasterHandler(smtUint32 IRQ)
{
    smtUint32 i2cStatus;

    i2cStatus = (0x1f & SMT_READ(ICSR0)) << 3 ;
    switch (i2cStatus) {
        case 0x00 :
            UART_printf("i2c bus error\n\r");
            break;
        case 0x28 :
            UART_printf("Data byte tranmitted in master mode, ACK received\n\r");
            break;          
        case 0x18:          // address + write trans Ack received
            UART_printf("Address + Write bit transmitted, ACK received\n\r");
            break;
        case 0x08 :
            UART_printf("START condition transmitted\n\r");
            break;
        case 0x10:
            UART_printf("Repeated START condition transmitted\n\r");
            break;
        case 0x58:
            UART_printf("Data byte received in master mode, not ACK transmitted\n\r");
            break;
        case 0x50:
            UART_printf("Data byte received in master mode, ACK transmitted\n\r");
            break;
        case 0x40:          // address + Read trans Ack received
            UART_printf("Address + Read bit transmitted, ACK received\n\r");
            break;
        case 0x48:
            UART_printf("Address + Read bit transmitted, ACK not received\n\r");
            break;
        case 0x20:
            UART_printf("Address + Write bit transmitted, ACK not received\n\r");
           break;
        case 0x30:
            UART_printf("Data byte tranmitted in master mode, ACK not received\n\r");
            break;
            
        case 0x38:
            UART_printf("Arbitration lost in address or data byte \n\r");
            break;
            
        case 0x68:
            UART_printf("Arbitration lost in address as master, slave address + Write bit received, ACK transmitted \n\r");
            break;
        default:
            break;
    }
    interruptWait = 0;
}

