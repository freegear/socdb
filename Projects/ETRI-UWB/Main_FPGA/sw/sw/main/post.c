/*----------------------------------------------------------
	File Name   : main.c 
	Description : Application Entry Point File
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#define  __GCC_ARM__  1
#include "sysinc.h"
#include "Commonmacro.h"

#include "gpio.h"
#include "uart.h"
#include "dmac.h"

#include "memorymap.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void DDRTest(void);
void EthernetReadWriteTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
void DDRInit(void)		// Do not call this function, DDR was initialized already in start.S
{
	unsigned stable_cnt;
	static int initialized = 0;

	if(initialized == 1)
		return;

//	SMT_WRITE(DDRTCON, 0x0001b92a);
	SMT_WRITE(DDRTCON, 0x0001b93a);
//	SMT_WRITE(DDRDLL,  0x00000025);	// DLL Reset & DDR Cas Latency Setting(Mode Register : 010 or 110)
	SMT_WRITE(DDRDLL,  0x00000024);	// DLL Reset & DDR Cas Latency Setting(Mode Register : 010 or 110)
	SMT_WRITE(DDRREF,  0x00000410);
//	SMT_WRITE(DDRCON,  0x00000021);	// 48 MHz Clock(64MB)
	SMT_WRITE(DDRCON,  0x000000A1);	// 24 MHz Clock(64MB)
	do {
		stable_cnt = SMT_READ(DDRREF);
		stable_cnt &= 0x01f00000;
		stable_cnt >>= 20;
	} while(stable_cnt != 0);

	initialized = 1;
}

#define DDR_TEST_COUNT 2048		/* 1K WORD */
//volatile unsigned *test_temp = ((volatile unsigned *)0x20000000);
static unsigned test_temp[DDR_TEST_COUNT];
#define DATA0(x) (((x)&0xff)|((((x+1)&0xff)^0xff)<<8)|((((x+2)&0xff)^0xff)<<16)|(((x+1)&0xff)<<24))
#define DATA1(x) 0x55aaaa55
#define DATA2(x) 0xaa5555aa

void DDRTest(void)
{
	int i;
	volatile smtUint32 * ddram_testregion = (volatile smtUint32 *)(DDR_TESTREGION);
	volatile smtUint8 * ddram_testregion_byte = (volatile smtUint8 *)(DDR_TESTREGION);
	unsigned data;
	unsigned expected_data;

	DPRINTF("DDR Test...");

	//DDRInit();

	// PHASE 0 : single write => single/burst read
	// single write
	for(i = 0; i < DDR_TEST_COUNT; i++)
		ddram_testregion[i] = DATA0(i);

	// single read
	for(i = 0; i < DDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != DATA0(i))
		{
			expected_data = DATA0(i);
			goto error;
		}
	}

	// burst read using DMA
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, DDR_TEST_COUNT*4);
	for(i = 0; i < DDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
		if(data != DATA0(i))
		{
			expected_data = DATA0(i);
			goto error;
		}
	}


	// PHASE 1 : burst write => single/burst read
	// burst write DDR region
	for(i = 0; i < DDR_TEST_COUNT; i++)
		test_temp[i] = DATA1(i);
	DMACMemCopy(0, (unsigned char *)ddram_testregion, (unsigned char *)test_temp, DDR_TEST_COUNT*4);

	// single read
	for(i = 0; i < DDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != DATA1(i))
		{
			expected_data = DATA1(i);
			goto error;
		}
	}

	// burst read
	for(i = 0; i < DDR_TEST_COUNT; i++)
		test_temp[i] = 0xffffffff;
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, DDR_TEST_COUNT*4);
	for(i = 0; i < DDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
		if(data != DATA1(i))
		{
			expected_data = DATA1(i);
			goto error;
		}
	}


	// PHASE 2 : single write => single/burst read
	// single write
	for(i = 0; i < DDR_TEST_COUNT; i++)
		ddram_testregion[i] = DATA2(i);

	// single read
	for(i = 0; i < DDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != DATA2(i))
		{
			expected_data = DATA2(i);
			goto error;
		}
	}

	// burst read using DMA
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, DDR_TEST_COUNT*4);
	for(i = 0; i < DDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
		if(data != DATA2(i))
		{
			expected_data = DATA2(i);
			goto error;
		}
	}

	// PHASE 3 : single write => single/burst read(byte)
	// single write(byte)
	for(i = 0; i < DDR_TEST_COUNT*4; i++)
		ddram_testregion_byte[i] = i&0xff;

	// single read
	for(i = 0; i < DDR_TEST_COUNT*4; i++)
	{
		data = ddram_testregion_byte[i];
		if(data != (i & 0xff))
		{
			expected_data = i & 0xff;
			goto error;
		}
	}
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, DDR_TEST_COUNT*4);
	for(i = 0; i < DDR_TEST_COUNT*4; i++)
	{
		data = ((smtUint8*)test_temp)[i];
		if(data != (i & 0xff))
		{
			expected_data = i & 0xff;
			goto error;
		}
	}

	DPRINTF("Done\n");
	return;

error:
	DPRINTF("Error(Read %08x when expected %08x)\n", data, expected_data);
	GPIOWrite(0x5dead);
	while(1);
}

void EthernetReadWriteTest(void)
{
	unsigned short data;
	unsigned short data_expected;
#define DEFAULT_LAN91C111_BASE		0x0300
#define LAN91C111_BANK_REG	(*(volatile unsigned short *)(EXT_STARTADDR2+DEFAULT_LAN91C111_BASE+0x0e))
#define LAN91C111_IA0_REG	(*(volatile unsigned short *)(EXT_STARTADDR2+DEFAULT_LAN91C111_BASE+0x04))
#define LAN91C111_IA1_REG	(*(volatile unsigned short *)(EXT_STARTADDR2+DEFAULT_LAN91C111_BASE+0x06))
#define LAN91C111_IA2_REG	(*(volatile unsigned short *)(EXT_STARTADDR2+DEFAULT_LAN91C111_BASE+0x08))
#define LAN91C111_GPR_REG	(*(volatile unsigned short *)(EXT_STARTADDR2+DEFAULT_LAN91C111_BASE+0x0a))

	// Ethernet Connected at Extenral SMC ChipSelect 1)
	DPRINTF("LAN91C111 Register Read/Write Test...");
	SMT_WRITE(ESMC_B2_CON,
			0xfffffff0			// extremely slow timing
			| (1 << 2)			// 16bit
			| 0					// address shift : 0
	);

	data_expected = 0x3300;
	data = SMT_READ(LAN91C111_BANK_REG);
	if((data & 0xff00) != 0x3300)
	{
		data &= 0xff00;
		goto error;
	}
	SMT_WRITE(LAN91C111_BANK_REG, 0x01);

	SMT_WRITE(LAN91C111_IA0_REG, 0xAAAA);
	SMT_WRITE(LAN91C111_IA1_REG, 0x5555);
	SMT_WRITE(LAN91C111_IA2_REG, 0xAAAA);
	SMT_WRITE(LAN91C111_GPR_REG, 0x5555);

	data_expected = 0xaaaa;
	data = SMT_READ(LAN91C111_IA0_REG);
	if(data != 0xaaaa)
		goto error;
	data_expected = 0x5555;
	data = SMT_READ(LAN91C111_IA1_REG);
	if(data != 0x5555)
		goto error;
	data_expected = 0xaaaa;
	data = SMT_READ(LAN91C111_IA2_REG);
	if(data != 0xaaaa)
		goto error;
	data_expected = 0x5555;
	data = SMT_READ(LAN91C111_GPR_REG);
	if(data != 0x5555)
		goto error;

	DPRINTF("Done\n");
	return;
error:
	DPRINTF("Error : Read 0x%04x when 0x%04x expected\n", data , data_expected);
	return;
}

static unsigned char NORRead(int addr)
{
	return *((volatile unsigned char *)(EXT_STARTADDR1+addr));
}

static void NORWrite(int addr, unsigned char data)
{
	*((volatile unsigned char *)(EXT_STARTADDR1+addr)) = data;
}

void NORTest(void)
{
	int i;
	unsigned char data;
	unsigned char expected_data;

	UartPuts("NOR Test...");
	SMT_WRITE(ESMC_B1_CON,
			0xfffffff0			// extremely slow timing
			| (0 << 2)			// 8bit
			| 0					// No address shift
	);

	NORWrite(0x55<<1, 0x98);

	data = NORRead(0x20);
	expected_data = 0x51;
	if(data != expected_data)
		goto error;

	data = NORRead(0x22);
	expected_data = 0x52;
	if(data != expected_data)
		goto error;

	data = NORRead(0x24);
	expected_data = 0x59;
	if(data != expected_data)
		goto error;

	UartPuts("Done\n");
	return;
error:
	UartPrintf("Error(Read %02x when %02x expected)\n", data, expected_data);
	return;
}
