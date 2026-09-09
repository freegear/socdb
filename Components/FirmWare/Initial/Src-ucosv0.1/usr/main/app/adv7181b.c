/*----------------------------------------------------------
	File Name   : adv7181b.c 
	Description : ADV7181B Test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#include "sysinc.h"
#include "commonmacro.h"

#include "i2c_pre_drv.h"

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/
#define ADV7181B_ADDR					(0x40>>1)
#define ADV7181B_IDENT_ADDR			0x11
#define ADV7181B_AUTODETECT_ADDR		0x07


/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/

/*-----------------------------------------------------------------------
    Function name	: ADV7181BTest(void)
    Prototype		: void ADV7181BTest(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
smtUint32 ADV7181BTest(void)
{
	smtUint8 data;
	smtUint8 data_expected;
	smtUint8 data_temp;

	smtI2CInit(0xff); // 11 is 400k. 39 is 100k

	SMT_WRITE(GPIO1_OUT, 0x80000000);	// release reset
	smt2UartPrint(11,"[ADV7181 I2C TEST] Register Read/Write test...\n");

	data = 0;
	data_expected = 0x13;
	smtI2CRead(ADV7181B_ADDR, ADV7181B_IDENT_ADDR, &data);
	if(data != data_expected)
		goto error;

	smtI2CRead(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, &data_temp);

	smtI2CWrite(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, 0x55);

	data_expected = 0x55;
	smtI2CRead(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, &data);
	if(data != data_expected)
		goto error;

	smtI2CWrite(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, 0xaa);
	data_expected = 0xaa;

	smtI2CRead(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, &data);
	if(data != data_expected)
		goto error;

	smtI2CWrite(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, data_temp);

	data_expected = data_temp;
	smtI2CRead(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, &data);
	if(data != data_expected)
		goto error;

	smt2UartPrint(11,"[ADV7181 I2C TEST] Register Read/Write OK!!!\n");
	return SMT_SUCCESS;

	error:
	smt2UartPrint(11,"[ADV7181 I2C TEST] Error : read 0x%02x when 0x%02x expected\n", data, data_expected);
	return SMT_ERROR;
}

/*----------------------------------------------------------
	Function name	: ISRI2C()
	Prototype		: static void ISRI2C(smtUint32 irq)
	Return		: 
	Argument	:
	Comments	: I2C interrupt handler
-----------------------------------------------------------*/
static void ISRI2C(smtUint32 irq)
{
	DisableIRQ(irq);
	SMT_WRITE(I2CCON, SMT_READ(I2CCON) & (~0x1) );		// I2C interrupt disable

	smt2UartPrint(11, "I2C ISR\n");
}

/*-----------------------------------------------------------------------
    Function name	: ADV7181BI2CIntrTest(void)
    Prototype		: void ADV7181BI2CIntrTest(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
void ADV7181BI2CIntrTest(void)
{
	smtUint32 rdData;

	smtI2CInterruptPendingClear();
	smtI2CInit(0xff); // 11 is 400k. 39 is 100k

	smt2UartPrint(11,"ADV7181 I2C Interrupt test\n");
	RequestIRQ(IRQ_I2C, ISRI2C);

	SMT_WRITE(I2CDATA, ((ADV7181B_ADDR<<1)|0x00));	// I2C write

	if( smtI2CInterruptPended() )							// Interrupt pended
	{
		smtI2CEnable(0x1);
		smtI2CInterruptPendingClear();
	}
	else
		smtI2CEnable(0x1);

	// Wait until I2C interrupt occur
	while(1)
	{
		rdData = SMT_READ(I2CCON);
		if(rdData & (1<<3))
			break;
	}

	smtI2CInterruptPendingClear();
	smt2UartPrint(11, "I2C Tx interrupt 0x%x\n", rdData & (0x1<<3));

	//smtI2CSWReset();	// Initialize state machine. Don't work
	SMT_WRITE(I2CCON, SMT_READ(I2CCON) | 0x1 );		// I2C interrupt enable
	SMT_WRITE(I2CDATA, ((ADV7181B_ADDR<<1)|0x01));	// I2C Read

	if( smtI2CInterruptPended() )						// Interrupt pended
	{
		smtI2CEnable(0x1);
		smtI2CInterruptPendingClear();
	}
	else
		smtI2CEnable(0x1);

	// Wait until I2C interrupt occur
	while(1)
	{
		rdData = SMT_READ(I2CCON);
		if(rdData & (1<<3))
			break;
	}

	ReleaseIRQ(20);
	//smtI2CSWReset();

	smt2UartPrint(11, "I2C Rx interrupt 0x%x\n", rdData & (0x1<<3));	
	smt2UartPrint(11,"I2C interrupt test Done\n");
}

/*-----------------------------------------------------------------------
    Function name	: I2C1ByteWriteAndCheck(void)
    Prototype		: static void I2C1ByteWriteAndCheck(smtUint8 addr, smtUint8 subaddr, smtUint8 data)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void I2C1ByteWriteAndCheck(smtUint8 addr, smtUint8 subaddr, smtUint8 data)
{
	if (smtI2CWrite(addr, subaddr, data))
		smt2UartPrint(11,"I2C Byte Write Error\n");
}

/*-----------------------------------------------------------------------
    Function name	: ADV7181BInitComposite(void)
    Prototype		: void ADV7181BInitComposite(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
void ADV7181BInitComposite(void)
{
	// Recomendation Setting
	smtI2CInit(0xff);

	SMT_WRITE(GPIO1_OUT, 0x80000000);	// release reset
	//I2C1ByteWrite(ADV7181B_ADDR, 0x0F, 0x08);	// Chip Reset
	//while(count--) ;

	//I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x07, 0x7F);	// Composite
	//I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x00, 0x00);	// Composite

	//I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x37, 0x00);	// Invert PCLK pol.
	//I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x0C, 0x00);	// disable Auto Free Run

	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x15, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x17, 0x41);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x3A, 0x16);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x50, 0x04);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xC3, 0x05);	// AIN1 to ADC0
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xC4, 0x80);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x0E, 0x80);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x50, 0x20);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x52, 0x18);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x58, 0xED);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x77, 0xC5);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x7C, 0x93);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x7D, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xD0, 0x48);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xD5, 0xA0);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xD7, 0xEA);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xE4, 0x3E);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xEA, 0x0F);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xE9, 0x3E);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x0E, 0x00);
}

/*-----------------------------------------------------------------------
    Function name	: ADV7181BInitCompositeAltera(void)
    Prototype		: void ADV7181BInitCompositeAltera(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
void ADV7181BInitCompositeAltera(void)
{
	smtInt32 count = 1000000;

	SMT_WRITE(GPIO1_OUT, 0x80000000);	// release reset
	// Recomendation Setting
	smtI2CInit(0xff);

	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x37, 0x00);	// Invert PCLK pol.
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x15, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x17, 0x41);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x3A, 0x16);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x50, 0x04);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xC3, 0x05);	// AIN6 to ADC0
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xC4, 0x80);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x0E, 0x80);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x50, 0x20);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x52, 0x18);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x58, 0xED);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x77, 0xC5);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x7C, 0x93);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x7D, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xD0, 0x48);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xD5, 0xA0);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xD7, 0xEA);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xE4, 0x3E);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xEA, 0x0F);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x31, 0x12);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x32, 0x81);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x33, 0x84);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x37, 0xA0);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xE5, 0x80);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xE6, 0x03);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0xE7, 0x85);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x50, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x51, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x00, 0x50);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x10, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x04, 0x02);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x08, 0x60);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x0a, 0x18);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x11, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x2B, 0x00);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x2C, 0x8C);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x2D, 0xF8);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x2D, 0xFC);	
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x2E, 0xEE);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x2F, 0xF4);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x30, 0xD2);
	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x0E, 0x05);

	//I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x00, 0x00);	// Composite
}

/*-----------------------------------------------------------------------
    Function name	: ADV7181BInitSVideo(void)
    Prototype		: void ADV7181BInitSVideo(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
void ADV7181BInitSVideo(void)
{
	smtI2CInit(0xff);
	// Recommendation Setting
	smtI2CWrite(ADV7181B_ADDR, 0x00, 0x06);	// SVideo

	smtI2CWrite(ADV7181B_ADDR, 0x15, 0x00);
	smtI2CWrite(ADV7181B_ADDR, 0x3A, 0x12);
	smtI2CWrite(ADV7181B_ADDR, 0x50, 0x04);
	smtI2CWrite(ADV7181B_ADDR, 0xC3, 0xD4);	// AIN4(Y) to ADC0, AIN5(C) to ADC1
	smtI2CWrite(ADV7181B_ADDR, 0xC4, 0x80);
	smtI2CWrite(ADV7181B_ADDR, 0x0E, 0x80);
	smtI2CWrite(ADV7181B_ADDR, 0x50, 0x20);
	smtI2CWrite(ADV7181B_ADDR, 0x52, 0x18);
	smtI2CWrite(ADV7181B_ADDR, 0x58, 0xED);
	smtI2CWrite(ADV7181B_ADDR, 0x77, 0xC5);
	smtI2CWrite(ADV7181B_ADDR, 0x7C, 0x93);
	smtI2CWrite(ADV7181B_ADDR, 0x7D, 0x00);
	smtI2CWrite(ADV7181B_ADDR, 0xD0, 0x48);
	smtI2CWrite(ADV7181B_ADDR, 0xD5, 0xA0);
	smtI2CWrite(ADV7181B_ADDR, 0xD7, 0xEA);
	smtI2CWrite(ADV7181B_ADDR, 0xE4, 0x3E);
	smtI2CWrite(ADV7181B_ADDR, 0xEA, 0x0F);
	smtI2CWrite(ADV7181B_ADDR, 0xE9, 0x3E);
	smtI2CWrite(ADV7181B_ADDR, 0x0E, 0x00);
}

/*-----------------------------------------------------------------------
    Function name	: ADV7181BStatusPrint(void)
    Prototype		: void ADV7181BStatusPrint(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
void ADV7181BStatusPrint(void)
{
	smtUint8 status1, status2, status3;

	smtI2CRead(ADV7181B_ADDR, 0x10, &status1);
	smtI2CRead(ADV7181B_ADDR, 0x12, &status2);
	smtI2CRead(ADV7181B_ADDR, 0x13, &status3);

	smt2UartPrint(11,"Status1: %02x Status2: %02x Status3: %02x\n", status1, status2, status3);
}
