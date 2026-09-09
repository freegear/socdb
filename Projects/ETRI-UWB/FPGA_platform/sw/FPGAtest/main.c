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
#include "lib.h"
// #include "irq_toy.c"

//#define SIMUL
//FPGA GCC environment
#include "./API/apigpio.c"
#include "./API/apiuart.c"
#include "./API/apidmac.c"
#include "../Peri/nand.c"

#ifdef SIMUL
#define DPRINTF(fmt, args...)	/* NULL */
#else
#define DPRINTF(fmt, args...)	UART_printf(fmt, ##args)
#endif

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void UART_Initial(void);
void SDR_Test(void);
void InitializeSDRCtrl(void);
void UART_printf(const char *format, ...);
void NandTest();
/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */




/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name   : main()
    Prototype           : void main(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
int main(void)
{
	int i, count;
	int yes_or_no;
	int sum;
	unsigned data;

	GPIO_OutputEnable(0xffff);
	GPIO_Write(0x1357);

#ifndef SIMUL
	UART_Initial();
#endif
	DPRINTF("Test\n");
/*	
	InitializeSDRCtrl();
	GPIO_Write(0x4323);

	SDR_Test();
	GPIO_Write(0x4325);
*/
    NandTest();

	i = 0;
	while(1)
	{
		count = 1000;
		GPIO_Write(i);
		i++;
		while(count--);
	}
    while(1);
//___________________FPGA test end

	return 0;
}

void InitializeSDRCtrl(void)
{
	int i;
	unsigned stable_cnt;
	static int initialized = 0;

	if(initialized == 1)
		return;

	DPRINTF("Initializing SDR Controller...");
//	SMT_WRITE(DDRTCON, 0x00000000);
//	SMT_WRITE(DDRREF,  0x00200820); // default value (SDRAM mode CAS)
	SMT_WRITE(DDRTCON, 0x001A70A); // CAS latency default setting (tcl_s/tcl)
	//SMT_WRITE(DDRTCON, 0x000A72A); // CAS latency CL3 setting
	SMT_WRITE(DDRREF, 0x00200820); // REFRESH Counter setting (SDRAM setting)


	//SMT_WRITE(DDRCON, 0x00000A3); // 16bit SDR
	SMT_WRITE(DDRCON, 0x0000023); // 32bit SDR
	DPRINTF("SDR Status Register : 0x%08x\n ",SMT_READ(DDRDLL));
/*
	do {
		stable_cnt = SMT_READ(DDRREF);
		stable_cnt &= 0x01f00000;
		stable_cnt >>= 20;
	} while(stable_cnt != 0);
*/

	DPRINTF("SDR Status Register : 0x%08x\n ",SMT_READ(DDRDLL));
	DPRINTF("SDR Status Register : 0x%08x\n ",SMT_READ(DDRDLL));
	DPRINTF("SDR Status Register : 0x%08x\n ",SMT_READ(DDRDLL));
	initialized = 1;
	DPRINTF("Done\n");
}

//#define SDR_TEST_COUNT 2048		/* 1K WORD */
#define SDR_TEST_COUNT 2048		/* 1K WORD */
static unsigned test_temp[SDR_TEST_COUNT];
#define DATA0(x) (((x)&0xff)|((((x+1)&0xff)^0xff)<<8)|((((x+2)&0xff)^0xff)<<16)|(((x+1)&0xff)<<24))
#define DATA1(x) 0x55aaaa55
#define DATA2(x) 0xaa5555aa

void SDR_Test(void)
{
	int i;
	volatile smtUint32 * ddram_testregion = (volatile smtUint32 *)(SDRAM_STARTADDR);
	unsigned data;
	unsigned expected_data;

	InitializeSDRCtrl();

	DPRINTF("SDR Test...\n");

	// PHASE 0 : single write => single/burst read
	// single write
	//
	//
	//
	DPRINTF("SDR Single Write All Region..");
	for(i = 0; i < ((2*64*1024*1024)/4); i++)
		ddram_testregion[i] = i;

	DPRINTF("   Done!..\n");
	DPRINTF("SDR Single Read All Region.. ");
	for(i = 0; i < ((2*64*1024*1024)/4); i++)
	{
		data = ddram_testregion[i];

		if(data != i)
		{
		DPRINTF("SDR READ Error address 0x%08x \n", i);

			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");
	DPRINTF("---------------------------------------------------------\n");

	DPRINTF("SDR Single Write..");
	for(i = 0; i < SDR_TEST_COUNT; i++)
		ddram_testregion[i] = i;//DATA0(i);

	DPRINTF("   Done!..\n");
	DPRINTF("SDR Single Read.. ");
	// single read
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
	//	DPRINTF("read 0x%08x when 0x%08x expected\n", data, i);//DATA0(i));
		if(data != i)//DATA0(i))
		{
		DPRINTF("SDR READ Error address 0x%08x \n", i);

			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");

	DPRINTF("SDR Burst Read Test");
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
	//		DPRINTF("Bread 0x%08x when 0x%08x expected\n", data, DATA0(i));
		if(data != i)
		{
			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");
	DPRINTF("---------------------------------------------------------\n");


	DPRINTF("SDR Burst Write ");
	for(i = 0; i < SDR_TEST_COUNT; i++)
	test_temp[i] = i;
	DMACMemCopy(0, (unsigned char *)ddram_testregion, (unsigned char *)test_temp, SDR_TEST_COUNT*4);
	DPRINTF("   Done!..\n");

	DPRINTF("SDR Single Read Test");
	// single read
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != i)
		{
			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");

	DPRINTF("SDR Burst Read Test");
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
	//		DPRINTF("Bread 0x%08x when 0x%08x expected\n", data, DATA0(i));
		if(data != i)
		{
			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");
	DPRINTF("---------------------------------------------------------\n");



/*
	// burst read using DMA
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
			DPRINTF("Bread 0x%08x when 0x%08x expected\n", data, DATA0(i));
	if(data != DATA0(i))
		{
			expected_data = DATA0(i);
			goto error;
		}
	}
*/

#if 0
	// PHASE 1 : burst write => single/burst read
	// burst write SDR region
	for(i = 0; i < SDR_TEST_COUNT; i++)
		test_temp[i] = DATA1(i);
	DMACMemCopy(0, (unsigned char *)ddram_testregion, (unsigned char *)test_temp, SDR_TEST_COUNT*4);

	// single read
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != DATA1(i))
		{
			expected_data = DATA1(i);
			goto error;
		}
	}

	// burst read
	for(i = 0; i < SDR_TEST_COUNT; i++)
		test_temp[i] = 0xffffffff;
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
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
	for(i = 0; i < SDR_TEST_COUNT; i++)
		ddram_testregion[i] = DATA2(i);

	// single read
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != DATA2(i))
		{
			expected_data = DATA2(i);
			goto error;
		}
	}

	// burst read using DMA
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
		if(data != DATA2(i))
		{
			expected_data = DATA2(i);
			goto error;
		}
	}
#endif

	DPRINTF("Done\n");
	return;

error:
	DPRINTF("Error(Read %08x when expected %08x)\n", data, expected_data);
	GPIO_Write(0xdead);
	while(1);
}
