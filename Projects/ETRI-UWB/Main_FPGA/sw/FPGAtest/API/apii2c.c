/*----------------------------------------------------------
	File Name   : apii2c.c 
	Description : i2c for PULSUS-PSM711A
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

// 
#define PSM711A_ADDR 0x38
#define BUS_ERROR 1
#define ARBIT_LOST 2
static void InterruptWait(void);
void InitializePSM(unsigned char prescaler);
void PSM_2ByteWrite(char regAddr, char firstData, char secondData);
unsigned  PSM_2ByteWriteAndCheck(char regAddr, char firstData, char secondData);
void PSM_3ByteWrite(char regAddr,char firstData, char secondData, char thirdData);
static int PSM_2ByteRead(char regAddr,char *first, char *second);
void PSM_3ByteRead(char regAddr,char *first, char *second, char *third);
void PSM_InitialTest(void);
unsigned PSM_2ByteReadCheck(char addr, char firstdata, char seconddata);
void InterruptStatusPrint(void);
/*-----------------------------------------------------------------------
    Function name   : InitializePSM(char prescaler)
    Prototype       : void InitializePSM(char prescaler)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void delay(void)
{
	unsigned data;

	data = 1000000;
	while(data-- > 0);
}

void InitializePSM(unsigned char prescaler)
{   
	static initialized = 0;
	unsigned data;

	if(initialized)	return;
	initialized = 1;

	// PSM : Reset
	data = SMT_READ(GPIO_OUT);
	SMT_WRITE(GPIO_OUT, data | 0x80000000);

	// I2C Controller Setting
    SMT_WRITE(ICCR0_1, prescaler);             // load prescaler
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);     // I2C0 interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN);            // I2C0 Serial Output Enable for Slave
}
/*-----------------------------------------------------------------------
    Function name   : PSM_2ByteWrite(char regAddr,char firstData, char secondData)
    Prototype       : void PSM_2ByteWrite(char regAddr,char firstData, char secondData)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void PSM_2ByteWrite(char regAddr, char firstData, char secondData)
{   
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);       // Interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);  //Start condition
	InterruptWait();

    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, ((PSM711A_ADDR<<1)|0x00));       // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 2. Addr transmit
    SMT_WRITE(IDSR0, regAddr);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 3. firstData transmit
    SMT_WRITE(IDSR0, firstData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 4. secondData transmit
    SMT_WRITE(IDSR0, secondData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 5. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear

}

/*-----------------------------------------------------------------------
    Function name   : PSM_3ByteWrite(char regAddr,char firstData, char secondData, char thirdData)
    Prototype       : void PSM_3ByteWrite(char regAddr,char firstData, char secondData, charthirdData)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void PSM_3ByteWrite(char regAddr,char firstData, char secondData, char thirdData)
{   
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);       // Interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);  //Start condition
	InterruptWait();

    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, ((PSM711A_ADDR<<1)|0x00));       // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 2. Addr transmit
    SMT_WRITE(IDSR0, regAddr);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 3. firstData transmit
    SMT_WRITE(IDSR0, firstData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 4. secondData transmit
    SMT_WRITE(IDSR0, secondData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 5. thirdData transmit
    SMT_WRITE(IDSR0, thirdData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 6. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear

}
/*-----------------------------------------------------------------------
    Function name   : PSM_2ByteRead(char regAddr,char *first, char *second)
    Prototype       : void PSM_2ByteRead(char regAddr,char *first, char *second)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static int PSM_2ByteRead(char regAddr,char *first, char *second)
{
//    UART_printf("address : ");
//    UART_putchhex(regAddr);
//    UART_printf(" read\n\r");
    
    
    // 0. Start condition
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt enable
	InterruptWait();
    
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
	InterruptWait();
    
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
	InterruptWait();

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
	InterruptWait();

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
	InterruptWait();

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
	InterruptWait();

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
    
	InterruptWait();
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
//    UART_printf("read data : ");
//    UART_putchhex(*first);
//    UART_printf(" ");
//    UART_putchhex(*second);
//    UART_printf("\n\r");
    
    // 7. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    return 0;

}
/*-----------------------------------------------------------------------
    Function name   : PSM_3ByteRead(char regAddr,char *first, char *second, char *third)
    Prototype       : void PSM_3ByteRead(char regAddr,char *first, char *second, char *third)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void PSM_3ByteRead( char regAddr,char *first, char *second, char *third)
{
    
    // 0. Start condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);
	InterruptWait();

    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, ((PSM711A_ADDR<<1)|0x00));       // Master Rx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 2. Addr transmit
    SMT_WRITE(IDSR0, regAddr);                   // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

     // 3. Repeat Start condition
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 4. Slave addr transmit
    SMT_WRITE(IDSR0, ((PSM711A_ADDR<<1)|0x01));      // Master Rx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    SMT_WRITE(ICCR0_0, ACK_EN|INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();

    // 5. First Data read
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    SMT_WRITE(ICCR0_0, ACK_EN|INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();
    *first = SMT_READ(IDSR0);            //data read code
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    SMT_WRITE(ICCR0_0, ACK_EN|INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();
    
    // 6. Second Data read
    *second = SMT_READ(IDSR0);            //data read code
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
	InterruptWait();
    
    // 7. Second Data read
    *third = SMT_READ(IDSR0);            //data read code
    // 8. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear

}

/*-----------------------------------------------------------------------
    Function name   : PSM_InitialTest(void)
    Prototype       : boolean PSM_InitialTest(void)
    Return          : boolean
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void PSM_InitialTest(void)
{
	unsigned char addr;
	unsigned char data0;
	unsigned char data1;
	unsigned read_data;
	int i;

	const unsigned char addr_data_array[] = {
		0x00, 0x00, 0x01,		// addr(0x00), data0(0x00), data1(0x01)
		0x10, 0x00, 0xBD,
		0x11, 0x30, 0x30,
		0x15, 0x2C, 0x2C,
		0x17, 0x00, 0x01,
		0x19, 0x00, 0x25,
		0x1A, 0x00, 0x02,
		0x1B, 0x00, 0x66,
		0x1C, 0x00, 0x02,
		0x1D, 0x00, 0x66,
		0x1E, 0x00, 0x10,
		0x30, 0x03, 0x00,
		0x31, 0x00, 0x04,
		0x36, 0x1f, 0x1f,
		0x37, 0x00, 0x00,
		0x38, 0x00, 0x00,
		0x39, 0x00, 0x00,
		0x3A, 0x00, 0x00,
		0x3B, 0x00, 0x00,
		0x8F, 0x18, 0x7f,
		0x95, 0x00, 0x64,
		0x0A, 0x2E, 0x30,
		0x0B, 0x2E, 0x30,
		0xff, 0xff, 0xff		// End condition
	};
		

    InitializePSM(0xff);//11 is 400k 39 is 100k
   
    UART_printf("PSM register read test...");

	i = 0;
	while(1)
	{
		addr = addr_data_array[i++];
		if(addr == 0xff) break;
		data0 = addr_data_array[i++];
		data1 = addr_data_array[i++];
    	delay();
    	if(read_data = PSM_2ByteReadCheck(addr, data0, data1)) goto error;
	}

	UART_printf("Done\n");
	return;

error:
	UART_printf("Error(Addr 0x%02x read 0x%02x 0x%02x when 0x%02x 0x%02x expected)\n", addr, (read_data&0x0000ff00)>>8, (read_data & 0x000000ff), data0, data1);
}


unsigned PSM_2ByteReadCheck(char addr, char firstdata, char seconddata)
{
    
    int error_return =0;
	unsigned char data[2];

    do 
    {
    SMT_WRITE(I2C0_SRST,0xFF);
    error_return=PSM_2ByteRead(addr, &data[0], &data[1]);
    }   
    while(error_return!=0);

	if(data[0] != firstdata || data[1] != seconddata)
	{
		return (0x01000000 | (data[0]<<8) | data[1]);
	}

	return 0;
}

unsigned PSM_2ByteWriteAndCheck(char regAddr, char firstData, char secondData)
{
	unsigned data;
	delay();
	PSM_2ByteWrite(regAddr, firstData, secondData);
	delay();
	data = PSM_2ByteReadCheck(regAddr, firstData, secondData);
	if(data)
		UART_printf("PSM Write Error : Addr(0x%02x), Value(0x%02x%02x), Read(0x%02x%02x)\n",
			regAddr, firstData, secondData, (data&0x0000ff00)>>8, data&0x000000ff);
}

void InterruptStatusPrint(void)
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
}

static void InterruptWait(void)
{
	unsigned data;
	while(1)
	{
		data = SMT_READ(ICCR0_0);
		if(data & 0x00000010)
			break;
	}

//	InterruptStatusPrint();
	SMT_WRITE(ICCR0_0, (data | 0x00000010));
}

