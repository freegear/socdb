/*----------------------------------------------------------
	File Name   : i2c.c 
	Description : i2c API code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#include "Commonmacro.h"
#include "i2c.h"

#define BUS_ERROR 1
#define ARBIT_LOST 2
static void InterruptWait(void);
static void InterruptPendingClear(void);
static int  InterruptPended(void);
/*-----------------------------------------------------------------------
    Function name   : I2CInit(char prescaler)
    Prototype       : void I2CInit(char prescaler)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void I2CInit(unsigned char prescaler)
{   
	static int initialized = 0;

	if(initialized)	return;
	initialized = 1;

	// I2C Controller Setting
    SMT_WRITE(I2CCON,
		(1<<12)
		| (prescaler<<4)
		| (0 << 3)		// not interrupt pending clear
		| (1 << 2)		// Master TX Mode
		| (1 << 1)		// Send Ack
		| (1 << 0));		// Interrupt Enable
}

/*-----------------------------------------------------------------------
    Function name   : I2C1ByteWrite
    Prototype       : int I2C1ByteWrite(unsigned char Addr,unsigned char subAddr, unsigned char Data)
    Return          : 0 when no error
    Argument        : Addr : I2C Slave Addr
                      subAddr : Sub Addr
                      Data : Byte to write
    Comments        : 
-----------------------------------------------------------------------*/
int I2C1ByteWrite(unsigned char addr, unsigned char subAddr, unsigned char Data)
{   
	unsigned data;

	SMT_WRITE(I2CDATA, ((addr<<1)|0x00));
	data = SMT_READ(I2CSTA);
	if(InterruptPended())
	{
		SMT_WRITE(I2CSTA, (data | (1<<4)));		// Start
		InterruptPendingClear();
	}
	else
		SMT_WRITE(I2CSTA, (data | (1<<4)));		// Start
	InterruptWait();

	// status check
	data = SMT_READ(I2CSTA);
	if(data & (1<<2))
		return ARBIT_LOST;
	else if((data & (1<<1)))		// Not received Ack
		return BUS_ERROR;
    SMT_WRITE(I2CDATA, subAddr);       // Sub Addr Transmitt
	InterruptPendingClear();
	InterruptWait();

	// status check
	data = SMT_READ(I2CSTA);
	if(data & (1<<2))
		return ARBIT_LOST;
	else if((data & (1<<1)))		// Not received Ack
		return BUS_ERROR;
	SMT_WRITE(I2CDATA, Data);
	InterruptPendingClear();
	InterruptWait();

	// status check
	data = SMT_READ(I2CSTA);
	if(data & (1<<2))
		return ARBIT_LOST;
	else if((data & (1<<1)))		// Not received Ack
		return BUS_ERROR;
	SMT_WRITE(I2CSTA, (data & (~(1UL<<4))));		// Stop
	InterruptPendingClear();
	InterruptWait();

	return 0;
}

/*-----------------------------------------------------------------------
    Function name   : I2C1ByteRead
    Prototype       : void I2C1ByteRead(unsigned char addr, unsigned char subAddr, unsigned char *data)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
int I2C1ByteRead(unsigned char addr, unsigned char subAddr, unsigned char *Data)
{
	unsigned data;

	SMT_WRITE(I2CDATA, ((addr<<1)|0x00));
	data = SMT_READ(I2CSTA);
	if(InterruptPended())
	{
		SMT_WRITE(I2CSTA, (data | (1<<4)));		// Start
		InterruptPendingClear();
	}
	else
		SMT_WRITE(I2CSTA, (data | (1<<4)));		// Start
	InterruptWait();

	// status check
	data = SMT_READ(I2CSTA);
	if(data & (1<<2))
	{
		return ARBIT_LOST;
	}
	else if((data & (1<<1)))		// Not received Ack
	{
		return BUS_ERROR;
	}
    SMT_WRITE(I2CDATA, subAddr);       // Sub Addr Transmitt
	InterruptPendingClear();
	InterruptWait();

	// status check
	data = SMT_READ(I2CSTA);
	if(data & (1<<2))
	{
		return ARBIT_LOST;
	}
	else if((data & (1<<1)))		// Not received Ack
	{
		return BUS_ERROR;
	}

	// Repeated Stop

	SMT_WRITE(I2CDATA, ((addr<<1)|0x01));

	data = SMT_READ(I2CSTA);
	SMT_WRITE(I2CSTA, (data | (1<<4)));		// Start: Read
	InterruptPendingClear();
	InterruptWait();
	data = SMT_READ(I2CSTA);
	if(data & (1<<2))
	{
		return ARBIT_LOST;
	}
	else if((data & (1<<1)))		// Not received Ack
	{
		return BUS_ERROR;
	}

	data = SMT_READ(I2CCON);
	data &= ((~(1UL<<2))&(~(1UL<<1)));	// Rx Mode & NACK 
	SMT_WRITE(I2CCON, data);	// Master RX Mode & NACK enable
	InterruptPendingClear();

	InterruptWait();
	*Data = SMT_READ(I2CDATA);

	data = SMT_READ(I2CSTA);
	SMT_WRITE(I2CSTA, (data & (~(1UL<<4))));		// Stop
	InterruptPendingClear();
	InterruptWait();
	
	data = SMT_READ(I2CCON);
	SMT_WRITE(I2CCON, data | (1<<2));		// back to Master Tx Mode

    return 0;
}

static void InterruptWait(void)
{
	unsigned data;
	while(1)
	{
		data = SMT_READ(I2CCON);
		if(data & (1<<3))
			break;
	}
}

static void InterruptPendingClear(void)
{
	unsigned data;

	data = SMT_READ(I2CCON);
	SMT_WRITE(I2CCON, data | (1<<3));
}
static int InterruptPended(void)
{
	unsigned data;
	data = SMT_READ(I2CCON);
	return (data & (1<<3));
}
