/*----------------------------------------------------------
	File Name   : main.c 
	Description : Application Entry Point File
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"

#include "gpio.h"
#include "uart.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
static void SEIPWriteHalf(unsigned addr, smtUint16 data)
{
	// addr should be halfwaord aligned
//	while((SMT_READ(SEIP_RST) & 0x80UL) == 0);
//	*((volatile unsigned *)(SEIP_BASEADDR+(addr<<1))) = data;
	*((volatile unsigned short*)(SEIP_BASEADDR+addr)) = data;
}

static smtUint16 SEIPReadHalf(unsigned addr)
{
	// addr should be halfwaord aligned
//	while((SMT_READ(SEIP_RST) & 0x80UL) == 0);
//	return *((volatile unsigned *)(SEIP_BASEADDR+(addr<<1)));
	return *((volatile unsigned short*)(SEIP_BASEADDR+addr));
}

static void SEIPDelay(void)
{
	// I cannot determine delay time.
	int count = 100000;

	while(count--);
}

static void SEIPNORWrite(unsigned addr, unsigned char data)
{
	SEIPWriteHalf(0x40, (addr & 0x00FF0000)>>16);	// WMAL
	SEIPDelay();
	SEIPWriteHalf(0x42, (addr & 0x0000FFFF));	// WMAH
	SEIPDelay();
	SEIPWriteHalf(0x44, data);
	SEIPDelay();
}

static unsigned char SEIPNORRead(unsigned addr)
{
	SEIPWriteHalf(0x40, (addr & 0x00FF0000)>>16);	// WMAL
	SEIPDelay();
	SEIPWriteHalf(0x42, (addr & 0x0000FFFF));	// WMAH
	SEIPDelay();
	return SEIPReadHalf(0x44);
}

void SEIPReadWriteTest(void)
{
	int i;
	smtUint32 data;
	smtUint32 expected_data;

	// VERY IMPORTANT NOTICE !!!
	// Shoud write 0x03 to RS_SEIPMUX before test SEIP !!!!
	SMT_WRITE(RS_SEIPMUX, 0x03);		// Wave ROM/Internal SRAM Owner : SEIP
	UartPuts("SEIP Read/Write Test...");

	// SEIP Controller Register Read/Write Test
	SMT_WRITE(SEIP_RXCON,(3<<4)|(1<<2)|(1<<1));
	SMT_WRITE(SEIP_TXCON,(2<<4)|(1<<2)|(1<<1));


	data = SMT_READ(SEIP_RXCON);
	expected_data = (3<<4)|(1<<2)|(1<<1);
	if(data != expected_data)
		goto error;

	data = SMT_READ(SEIP_TXCON);
	expected_data = (2<<4)|(1<<2)|(1<<1);
	if(data != expected_data)
		goto error;

	SMT_WRITE(SEIP_RXCON, 0);
	SMT_WRITE(SEIP_TXCON, 0);

	data = SMT_READ(SEIP_RXCON);
	expected_data = 0;
	if(data != expected_data)
		goto error;

	data = SMT_READ(SEIP_TXCON);
	expected_data = 0;
	if(data != expected_data)
		goto error;

	// SEIP Read/Write Test
	SEIPWriteHalf(0x20, 0x5555);
	SEIPWriteHalf(0x22, 0xaaaa);
	SEIPWriteHalf(0x24, 0x6666);
	SEIPWriteHalf(0x26, 0x9999);
	SEIPDelay();	// Read should be delayed
	
	data = SEIPReadHalf(0x20);
	expected_data = 0x5555;
	if(data != expected_data)
		goto error;

	data = SEIPReadHalf(0x22);
	expected_data = 0xaaaa;
	if(data != expected_data)
		goto error;

	data = SEIPReadHalf(0x24);
	expected_data = 0x6666;
	if(data != expected_data)
		goto error;

	data = SEIPReadHalf(0x26);
	expected_data = 0x9999;
	if(data != expected_data)
		goto error;

	// NOR Read/Write Test : See s29gl-m_00_b6_e.pdf : CFI (page 57)
	SEIPNORWrite(0x55<<1, 0x98);
	data = SEIPNORRead(0x20);
	expected_data = 0x51;
	if(data != expected_data)
		goto error;

	data = SEIPNORRead(0x22);
	expected_data = 0x52;
	if(data != expected_data)
		goto error;

	data = SEIPNORRead(0x24);
	expected_data = 0x59;
	if(data != expected_data)
		goto error;

	//====== ADD Progam =======================================
	SEIPWriteHalf( 0,0 );
	for( i=0; i<64; i++ ){
		data = SEIPNORRead(i);
		UartPrintf("Adr=%04x Data = %02x\n",i,data&0xFF );
	}
	//=========================================================

	UartPuts("Done\n");
	return;
error:
	UartPrintf("Error(Read %08x when %08x expected)\n", data, expected_data);
	return;
}
