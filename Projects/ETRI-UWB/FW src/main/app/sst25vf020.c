/*----------------------------------------------------------
	File Name   : sst25vf020.c
	Description : SST25VF020 Test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#include "spi_pre_drv.h"
#include "uart_post_drv.h"
#include "commonmacro.h"
//#include "uart.h"

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void SSPinOutputEn(void);
static void SSPinLow(void);
static void SSPinHigh(void);
static void SPISel(smtUint32 ch);


static smtInt8 SPI0ReadID(void);
static void SPI0WRENSet(void);
static void SPI0ByteWrite(smtUint32 StAddr);
static void SPI0DataRead(smtUint32 StAddr);
static void SPI0ChipErase(void);
static void SPI0SectorErase(smtUint16 StAddr);
static void SPI0BlockErase(smtUint32 StAddr);
static smtInt8 SPI0StatusCheck(void);


static smtInt8 SPI1ReadID(void);
static void SPI1WRENSet(void);
static void SPI1ByteWrite(smtUint32 StAddr, smtUint8 WData);
static void SPI1DataRead(smtUint32 StAddr);
static void SPI1ChipErase(void);
static void SPI1SectorErase(smtUint16 StAddr);
static void SPI1BlockErase(smtUint32 StAddr);
static smtInt8 SPI1StatusCheck(void);


/*-----------------------------------------------------------------------
    Function name	: SST25VF010ATest(void)
    Prototype		: void SST25VF010ATest(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
// SST25VF010 1 Mbit (128K X 8)
void SST25VF020Test(void)
{
	smtInt8 Check;
	smtSPIInit(0, 0xFF, 0xF);

	SSPinOutputEn(); // GPIO Output Mode for SS pin
	smt2UartPrint(11,"SPI0 Test.. access SST25VF020 ");	

	SPISel(0);
	Check = SPI0ReadID();

	if (Check==0x00)// SPIO ID Read
		goto error;

	smt2UartPrint(11,"Done\n");

	return;

	error:
	smt2UartPrint(11,"SPI Error");
}

/*-----------------------------------------------------------------------
    Function name	: SSPinOutputEn(void)
    Prototype		: static void SSPinOutputEn(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SSPinOutputEn(void)
{
	SMT_WRITE(GPIO1_OE, SMT_READ(GPIO1_OE)|0x00000001); // /SS pin is GPIO0 
}

/*-----------------------------------------------------------------------
    Function name	: SSPinLow(void)
    Prototype		: static void SSPinLow(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SSPinLow(void)
{
	SMT_WRITE(GPIO1_OUT, (SMT_READ(GPIO1_OUT)&0xFFFFFFFE));  //
}

/*-----------------------------------------------------------------------
    Function name	: SSPinHigh(void)
    Prototype		: static void SSPinHigh(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SSPinHigh(void)
{
	SMT_WRITE(GPIO1_OUT, SMT_READ(GPIO1_OUT)|0x00000001);  //HIGH
}

/*-----------------------------------------------------------------------
    Function name	: SPISel(void)
    Prototype		: static void SPISel(unsigned ch)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SPISel(unsigned ch)
{
	SMT_WRITE(GPIO1_OE, SMT_READ(GPIO1_OE)|0x00000002); 
	if (ch == 1)
	{
		SMT_WRITE(GPIO1_OUT, SMT_READ(GPIO1_OUT)&0xFFFFFFFD);  //LOW
	}	
	else
	{
		SMT_WRITE(GPIO1_OUT, SMT_READ(GPIO1_OUT)|0x00000002);  //HIGH
	}
}

//--------------channel 0 test-----------------------
/*-----------------------------------------------------------------------
    Function name	: SPI0ReadID(void)
    Prototype		: static smtInt8 SPI0ReadID(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static smtInt8 SPI0ReadID(void)
{
	smtUint32 data;

	SSPinLow(); // Slave Select Low
	smtSPIOnebyteWrite(0, 0x90);
	smtSPIOnebyteWrite(0, 0x00);
	smtSPIOnebyteWrite(0, 0x00);
	smtSPIOnebyteWrite(0, 0x00);
	smtSPIOnebyteWrite(0, 0x00);
	smtSPIOnebyteWrite(0, 0x00);
	smtSPIOnebyteWrite(0, 0x00);
	smtSPIOnebyteWrite(0, 0x00);

	while((SMT_READ(SPISTA(0))&0x08)==0x00);	// Rx Full??

	SSPinHigh(); // Slave Select Low
	
	smtSPIOnebyteRead(0);			/* Dummy Remove */ 
	smtSPIOnebyteRead(0);			/* Dummy Remove */ 
	smtSPIOnebyteRead(0);			/* Dummy Remove */ 
	smtSPIOnebyteRead(0);			/* Dummy Remove */ 

	//SST25VF020 ID is 0xBF 0x43

	data = smtSPIOnebyteRead(0);	/* receive byte */
	if (data != 0xbf)
		return 0;
	data = smtSPIOnebyteRead(0);	/* receive byte */
	if (data != 0x43)
		return 0;
	data = smtSPIOnebyteRead(0);	/* receive byte */
	if (data != 0xbf)
		return 0;
	data = smtSPIOnebyteRead(0);	/* receive byte */
	if (data != 0x43)
		return 0;
	return 1;
}

/*-----------------------------------------------------------------------
    Function name	: SPI0WRENSet(void)
    Prototype		: static void SPI0WRENSet(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SPI0WRENSet(void)
{
	SSPinLow();				// Slave Select Low
	smtSPIOnebyteWrite(0, 0x06);
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x01);
	SSPinHigh();				// Slave Select Low
	smtSPIOnebyteRead(0);		/* Dummy Remove */ 
}

/*-----------------------------------------------------------------------
    Function name	: SPI0ByteWrite(void)
    Prototype		: static void SPI0ByteWrite(smtUint32 StAddr)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SPI0ByteWrite(smtUint32 StAddr)
{
	SSPinLow();
	smtSPIOnebyteWrite(0, 0x02);	// write command
	smtSPIOnebyteWrite(0, (StAddr&0xFFFFFF)>>16);	// 1st addr
	smtSPIOnebyteWrite(0, (StAddr&0xFFFF)>>8);		// 2nd addr
	smtSPIOnebyteWrite(0, StAddr&0xFF);				// 3rd addr
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x04); // Receive FIFO Level is 4
	smtSPIOnebyteRead(0);	// Dummy remove
	smtSPIOnebyteRead(0);	// Dummy remove
	smtSPIOnebyteRead(0);	// Dummy remove
	smtSPIOnebyteRead(0);	// Dummy remove
	SSPinHigh();
}

/*-----------------------------------------------------------------------
    Function name	: SPI0DataRead(void)
    Prototype		: static void SPI0DataRead(smtUint32 StAddr)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SPI0DataRead(smtUint32 StAddr)
{
	SSPinLow();
	smtSPIOnebyteWrite(0, 0x03);	// read command
	smtSPIOnebyteWrite(0, (StAddr&0xFFFFFF)>>16);	// 1st addr
	smtSPIOnebyteWrite(0, (StAddr&0xFFFF)>>8);		// 2nd addr
	smtSPIOnebyteWrite(0, StAddr&0xFF);				// 3rd addr
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x04);
	smtSPIOnebyteRead(0);	// Dummy Remove
	smtSPIOnebyteRead(0);	// Dummy Remove
	smtSPIOnebyteRead(0);	// Dummy Remove
	smtSPIOnebyteRead(0);	// Dummy Remove
	SSPinHigh();
}

/*-----------------------------------------------------------------------
    Function name	: SPI0ChipErase(void)
    Prototype		: static void SPI0ChipErase(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SPI0ChipErase(void)
{
	SSPinLow();
	smtSPIOnebyteWrite(0, 0x03);	// read command
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x01);
	smtSPIOnebyteRead(0);			// Dummy Remove
	SSPinHigh();
}

/*-----------------------------------------------------------------------
    Function name	: SPI0SectorErase(void)
    Prototype		: static void SPI0SectorErase(smtUint16 StAddr)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SPI0SectorErase(smtUint16 StAddr)
{
	SSPinLow();
	smtSPIOnebyteWrite(0, 0x20); //command
	smtSPIOnebyteWrite(0, (StAddr&0xFFFF)>>8); // 1st addr
	smtSPIOnebyteWrite(0, StAddr&0xFF); // 2nd addr
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x03);
	smtSPIOnebyteRead(0);	// Dummy Remove
	smtSPIOnebyteRead(0);	// Dummy Remove
	smtSPIOnebyteRead(0);	// Dummy Remove
	SSPinHigh();
}

/*-----------------------------------------------------------------------
    Function name	: SPI0BlockErase(void)
    Prototype		: static void SPI0BlockErase(smtUint32 StAddr)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static void SPI0BlockErase(smtUint32 StAddr)
{
	smtSPIOnebyteWrite(0,0x52);
	smtSPIOnebyteWrite(0, (StAddr&0xFFFFFF)>>16);	// address 1	
	smtSPIOnebyteWrite(0, (StAddr&0xFFFF)>>8);		// address 2	
	smtSPIOnebyteWrite(0, (StAddr&0xFF));			// address 3	
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x04);
	smtSPIOnebyteRead(0); 		// Dummy Remove
	smtSPIOnebyteRead(0); 		// Dummy Remove
	smtSPIOnebyteRead(0); 		// Dummy Remove
	smtSPIOnebyteRead(0); 		// Dummy Remove
}

/*-----------------------------------------------------------------------
    Function name	: SPI0StatusCheck(void)
    Prototype		: static smtInt8 SPI0StatusCheck(void)
    Return			: void
    Argument		:
    Comments		:
-----------------------------------------------------------------------*/
static smtInt8 SPI0StatusCheck(void)
{
	SSPinLow();
	smtSPIOnebyteWrite(0, 0x05);	// RDSR command
	smtSPIOnebyteWrite(0, 0x00);	// Dummy Write
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x02);
	smtSPIOnebyteRead(0);			// Dummy Remove
	smtSPIOnebyteRead(0);			// Dummy Remove
	SSPinHigh();
}
