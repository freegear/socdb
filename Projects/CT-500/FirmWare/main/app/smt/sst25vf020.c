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
smtUint32 SST25VF020Test(void)
{
	smtInt8 Check;
	smtSPIInit(0, 0xFF, 0xF);

	SSPinOutputEn(); // GPIO Output Mode for SS pin
	smt2UARTPrint(CFG_UART_CH,"[SPI0 TEST] access SST25VF020 \n");	

	SPISel(0);
	Check = SPI0ReadID();

	if (Check==0x00)// SPIO ID Read
		goto error;

	smt2UARTPrint(CFG_UART_CH,"[SPI0 TEST] Done\n");

	return SMT_SUCCESS;

	error:
	smt2UARTPrint(CFG_UART_CH,"[SPI0 TEST] Error\n");
	return SMT_ERROR;
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
	smtUint8 data;

	SSPinLow(); // Slave Select Low
	smtSPIWrite(0, 0x90);
	smtSPIWrite(0, 0x00);
	smtSPIWrite(0, 0x00);
	smtSPIWrite(0, 0x00);
	smtSPIWrite(0, 0x00);
	smtSPIWrite(0, 0x00);
	smtSPIWrite(0, 0x00);
	smtSPIWrite(0, 0x00);

	while((SMT_READ(SPISTA(0))&0x08)==0x00);	// Rx Full??

	SSPinHigh(); // Slave Select Low
	
	smtSPIRead(0, &data);			/* Dummy Remove */ 
	smtSPIRead(0, &data);			/* Dummy Remove */ 
	smtSPIRead(0, &data);			/* Dummy Remove */ 
	smtSPIRead(0, &data);			/* Dummy Remove */ 

	//SST25VF020 ID is 0xBF 0x43

	smtSPIRead(0, &data);	/* receive byte */
	if (data != 0xbf)
		return 0;
	smtSPIRead(0, &data);	/* receive byte */
	if (data != 0x43)
		return 0;
	smtSPIRead(0, &data);	/* receive byte */
	if (data != 0xbf)
		return 0;
	smtSPIRead(0, &data);	/* receive byte */
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
	smtUint8 data;

	SSPinLow();				// Slave Select Low
	smtSPIWrite(0, 0x06);
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x01);
	SSPinHigh();				// Slave Select Low
	smtSPIRead(0, &data);		/* Dummy Remove */ 
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
	smtUint8 data;

	SSPinLow();
	smtSPIWrite(0, 0x02);	// write command
	smtSPIWrite(0, (StAddr&0xFFFFFF)>>16);	// 1st addr
	smtSPIWrite(0, (StAddr&0xFFFF)>>8);		// 2nd addr
	smtSPIWrite(0, StAddr&0xFF);				// 3rd addr
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x04); // Receive FIFO Level is 4
	smtSPIRead(0, &data);	// Dummy remove
	smtSPIRead(0, &data);	// Dummy remove
	smtSPIRead(0, &data);	// Dummy remove
	smtSPIRead(0, &data);	// Dummy remove
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
	smtUint8 data;

	SSPinLow();
	smtSPIWrite(0, 0x03);	// read command
	smtSPIWrite(0, (StAddr&0xFFFFFF)>>16);	// 1st addr
	smtSPIWrite(0, (StAddr&0xFFFF)>>8);		// 2nd addr
	smtSPIWrite(0, StAddr&0xFF);				// 3rd addr
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x04);
	smtSPIRead(0, &data);	// Dummy Remove
	smtSPIRead(0, &data	);	// Dummy Remove
	smtSPIRead(0, &data);	// Dummy Remove
	smtSPIRead(0, &data);	// Dummy Remove
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
	smtUint8 data;

	SSPinLow();
	smtSPIWrite(0, 0x03);	// read command
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x01);
	smtSPIRead(0, &data);			// Dummy Remove
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
	smtUint8 data;

	SSPinLow();
	smtSPIWrite(0, 0x20); //command
	smtSPIWrite(0, (StAddr&0xFFFF)>>8); // 1st addr
	smtSPIWrite(0, StAddr&0xFF); // 2nd addr
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x03);
	smtSPIRead(0, &data);	// Dummy Remove
	smtSPIRead(0, &data);	// Dummy Remove
	smtSPIRead(0, &data);	// Dummy Remove
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
	smtUint8 data;

	smtSPIWrite(0,0x52);
	smtSPIWrite(0, (StAddr&0xFFFFFF)>>16);	// address 1	
	smtSPIWrite(0, (StAddr&0xFFFF)>>8);		// address 2	
	smtSPIWrite(0, (StAddr&0xFF));			// address 3	
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x04);
	smtSPIRead(0, &data); 		// Dummy Remove
	smtSPIRead(0, &data); 		// Dummy Remove
	smtSPIRead(0, &data); 		// Dummy Remove
	smtSPIRead(0, &data); 		// Dummy Remove
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
	smtUint8 data;

	SSPinLow();
	smtSPIWrite(0, 0x05);	// RDSR command
	smtSPIWrite(0, 0x00);	// Dummy Write
	while ((SMT_READ(SPISTA(0)) &0x3c0)==0x02);
	smtSPIRead(0, &data);			// Dummy Remove
	smtSPIRead(0, &data);			// Dummy Remove
	SSPinHigh();
}
