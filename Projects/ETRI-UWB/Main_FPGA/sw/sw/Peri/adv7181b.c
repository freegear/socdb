/*----------------------------------------------------------
	File Name   : adv7181b.c 
	Description : ADV7181B Test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#include "Commonmacro.h"
#include "i2c.h"
#include "uart.h"
/*-----------------------------------------------------------------------
    Function name   : ADV7181BTest(void)
    Prototype       : void ADV7181BTest(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
#define ADV7181B_ADDR (0x40>>1)
#define ADV7181B_IDENT_ADDR	0x11
#define ADV7181B_AUTODETECT_ADDR	0x07
void ADV7181BTest(void)
{
	unsigned char data;
	unsigned char data_expected;
	unsigned char data_temp;
    I2CInit(0xff);//11 is 400k 39 is 100k
   
	SMT_WRITE(GPIO1_OUT, 0x80000000);	// release reset
    DPRINTF("ADV7181 I2C Register Read/Write test...");

	data = 0;
	data_expected = 0x13;
	I2C1ByteRead(ADV7181B_ADDR, ADV7181B_IDENT_ADDR, &data);
	if(data != data_expected)
		goto error;

	I2C1ByteRead(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, &data_temp);

	I2C1ByteWrite(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, 0x55);

	data_expected = 0x55;
	I2C1ByteRead(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, &data);
	if(data != data_expected)
		goto error;

	I2C1ByteWrite(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, 0xaa);
	data_expected = 0xaa;
	I2C1ByteRead(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, &data);
	if(data != data_expected)
		goto error;

	I2C1ByteWrite(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, data_temp);

	data_expected = data_temp;
	I2C1ByteRead(ADV7181B_ADDR, ADV7181B_AUTODETECT_ADDR, &data);
	if(data != data_expected)
		goto error;

	DPRINTF("Done\n");
	return;

error:
	DPRINTF("Error : read 0x%02x when 0x%02x expected\n", data, data_expected);
}

static void I2C1ByteWriteAndCheck(unsigned char addr, unsigned char subaddr, unsigned char data)
{
	if(I2C1ByteWrite(addr, subaddr, data))
		DPRINTF("I2C Byte Write Error\n");
}

void ADV7181BInitComposite(void)
{
//	unsigned count = 100000;
//	unsigned char data;

	// Recomendation Setting
	I2CInit(0xff);

	SMT_WRITE(GPIO1_OUT, 0x80000000);	// release reset
//	I2C1ByteWrite(ADV7181B_ADDR, 0x0F, 0x08);	// Chip Reset
//	while(count--) ;

//	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x07, 0x7F);	// Composite
//	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x00, 0x00);	// Composite

//	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x37, 0x00);	// Invert PCLK pol.
//	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x0C, 0x00);	// disable Auto Free Run

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

void ADV7181BInitCompositeAltera(void)
{
	int count = 1000000;

	SMT_WRITE(GPIO1_OUT, 0x80000000);	// release reset
	// Recomendation Setting
	I2CInit(0xff);

//	I2C1ByteWrite(ADV7181B_ADDR, 0x0F, 0x08);	// Chip Reset
//	while(count--) ;

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

//	I2C1ByteWriteAndCheck(ADV7181B_ADDR, 0x00, 0x00);	// Composite
}

void ADV7181BInitSVideo(void)
{
	I2CInit(0xff);
	// Recommendation Setting
	I2C1ByteWrite(ADV7181B_ADDR, 0x00, 0x06);	// SVideo

	I2C1ByteWrite(ADV7181B_ADDR, 0x15, 0x00);
	I2C1ByteWrite(ADV7181B_ADDR, 0x3A, 0x12);
	I2C1ByteWrite(ADV7181B_ADDR, 0x50, 0x04);
	I2C1ByteWrite(ADV7181B_ADDR, 0xC3, 0xD4);	// AIN4(Y) to ADC0, AIN5(C) to ADC1
	I2C1ByteWrite(ADV7181B_ADDR, 0xC4, 0x80);
	I2C1ByteWrite(ADV7181B_ADDR, 0x0E, 0x80);
	I2C1ByteWrite(ADV7181B_ADDR, 0x50, 0x20);
	I2C1ByteWrite(ADV7181B_ADDR, 0x52, 0x18);
	I2C1ByteWrite(ADV7181B_ADDR, 0x58, 0xED);
	I2C1ByteWrite(ADV7181B_ADDR, 0x77, 0xC5);
	I2C1ByteWrite(ADV7181B_ADDR, 0x7C, 0x93);
	I2C1ByteWrite(ADV7181B_ADDR, 0x7D, 0x00);
	I2C1ByteWrite(ADV7181B_ADDR, 0xD0, 0x48);
	I2C1ByteWrite(ADV7181B_ADDR, 0xD5, 0xA0);
	I2C1ByteWrite(ADV7181B_ADDR, 0xD7, 0xEA);
	I2C1ByteWrite(ADV7181B_ADDR, 0xE4, 0x3E);
	I2C1ByteWrite(ADV7181B_ADDR, 0xEA, 0x0F);
	I2C1ByteWrite(ADV7181B_ADDR, 0xE9, 0x3E);
	I2C1ByteWrite(ADV7181B_ADDR, 0x0E, 0x00);
}

void ADV7181BStatusPrint(void)
{
	unsigned char status1, status2, status3;
	I2C1ByteRead(ADV7181B_ADDR, 0x10, &status1);
	I2C1ByteRead(ADV7181B_ADDR, 0x12, &status2);
	I2C1ByteRead(ADV7181B_ADDR, 0x13, &status3);

	UartPrintf("Status1: %02x Status2: %02x Status3: %02x\n", status1, status2, status3);
}
