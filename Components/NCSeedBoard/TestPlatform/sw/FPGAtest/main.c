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
#include "irq_toy.c"

//#define SIMUL
//FPGA GCC environment
#include "./API/apigpio.c"
#include "./API/apiuart.c"
#include "./API/apimmc.c"
#include "./API/apidmac.c"
#include "./API/apii2c.c"
#include "./API/apii2s.c"

#ifdef SIMUL
#define DPRINTF(fmt, args...)	/* NULL */
#else
#define DPRINTF(fmt, args...)	UART_printf(fmt, ##args)
#endif

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define FRAME_BASEADDR	SDRAM_STARTADDR
#define FRAME_WIDTH 480
#define FRAME_HEIGHT 272

#define BLACK	0xff000000
#define BLUE	0xffff0000
#define GREEN	0xff00ff00
#define CYAN	0xffffff00
#define RED		0xff0000ff
#define MAGENTA	0xffff00ff
#define YELLOW	0xff00ffff
#define WHITE	0xffffffff

#define LCD_HFP	(2-1)	// Horizontal Front Porch(2 clock)
#define LCD_HSW	(41-1)	// Horizontal Sync Width(41 clock)
#define LCD_HBP	(2-1)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (480-1)	// active clocks per line

#define LCD_VFP (4-1)	// Vertical Front Porch(2 line)
#define LCD_VBP (4-1)	// Vertical Back Porch(41 line)
#define LCD_VSW (10-1)	// Vertical Sync Width(2 line)
#define LCD_LPS (272-1)	// active lines per screen

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void UART_Initial(void);
void DM_Test(void);
void DDR_Test(void);
void InitializeDDRCtrl(void);
void UART_printf(const char *format, ...);

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
	volatile unsigned char *ddram = (volatile unsigned char *)(SDRAM_STARTADDR+FRAME_WIDTH*FRAME_HEIGHT*4);

	SMT_WRITE(GPIO_OUT, 0x00014321);
//	SMT_WRITE(GPIO_OUT, 0x00004321);
	GPIO_OutputEnable(0xffff);
	GPIO_Write(0x4321);

#ifndef SIMUL
	UART_Initial();
#endif
	DPRINTF("Test\n");
	BGM_Start();

	InitializeDDRCtrl();

	DM_Test();

	DDR_Test();

#ifndef SIMUL
	DPRINTF("Proceed MMC Test?(Y/N)...");
	yes_or_no = UART_getch();
	DPRINTF("%c\n", yes_or_no);
	if(yes_or_no == 'Y' || yes_or_no == 'y')
		MMCTest();
#endif

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

void InitializeDDRCtrl(void)
{
	int i;
	unsigned stable_cnt;
	static int initialized = 0;

	if(initialized == 1)
		return;

	DPRINTF("Initializing DDR Controller...");
	SMT_WRITE(DDRTCON, 0x0001b92a);
	SMT_WRITE(DDRDLL,  0x00000024);	// DLL Reset & DDR Cas Latency Setting(Mode Register : 010 or 110)
	SMT_WRITE(DDRREF,  0x00000410);
	SMT_WRITE(DDRCON,  0x00000021);	// 48 MHz Clock
//	SMT_WRITE(DDRCON,  0x000000A1);	// 24 MHz Clock
	do {
		stable_cnt = SMT_READ(DDRREF);
		stable_cnt &= 0x01f00000;
		stable_cnt >>= 20;
	} while(stable_cnt != 0);

	initialized = 1;
	DPRINTF("Done\n");
}

#define DDR_TEST_COUNT 2048		/* 1K WORD */
static unsigned test_temp[DDR_TEST_COUNT];
#define DATA0(x) (((x)&0xff)|((((x+1)&0xff)^0xff)<<8)|((((x+2)&0xff)^0xff)<<16)|(((x+1)&0xff)<<24))
#define DATA1(x) 0x55aaaa55
#define DATA2(x) 0xaa5555aa

void DDR_Test(void)
{
	int i;
	volatile smtUint32 * ddram_testregion = (volatile smtUint32 *)(SDRAM_STARTADDR+FRAME_WIDTH*FRAME_HEIGHT*4);
	unsigned data;
	unsigned expected_data;

	InitializeDDRCtrl();

	DPRINTF("DDR Test...");

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

	DPRINTF("Done\n");
	return;

error:
	DPRINTF("Error(Read %08x when expected %08x)\n", data, expected_data);
	GPIO_Write(0xdead);
	while(1);
}
//#define COLORBAR
//#define USE_PALETTE
void DM_Test(void)
{
	int i, j;
	unsigned *frame = (unsigned *)FRAME_BASEADDR;

	DPRINTF("Back Ground Image Setting...");
	// Colorbar generation
#ifdef COLORBAR
#ifdef USE_PALETTE
	SMT_WRITE(GPALA, 0x00);
	SMT_WRITE(GPALM, BLACK);
	SMT_WRITE(GPALA, 0x01);
	SMT_WRITE(GPALM, BLUE);
	SMT_WRITE(GPALA, 0x02);
	SMT_WRITE(GPALM, GREEN);
	SMT_WRITE(GPALA, 0x03);
	SMT_WRITE(GPALM, CYAN);
	SMT_WRITE(GPALA, 0x04);
	SMT_WRITE(GPALM, RED);
	SMT_WRITE(GPALA, 0x05);
	SMT_WRITE(GPALM, MAGENTA);
	SMT_WRITE(GPALA, 0x06);
	SMT_WRITE(GPALM, YELLOW);
	SMT_WRITE(GPALA, 0x07);
	SMT_WRITE(GPALM, WHITE);
#ifdef SIMUL
	for(i = 0; i < 2; i++)
#else
	for(i = 0; i < FRAME_HEIGHT; i++)
#endif
	{
		GPIO_Write(i);
		for(j = 0; j < FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x00000000;
		for(; j < 2*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x01010101;
		for(; j < 3*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x02020202;
		for(; j < 4*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x03030303;
		for(; j < 5*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x04040404;
		for(; j < 6*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x05050505;
		for(; j < 7*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x06060606;
		for(; j < FRAME_WIDTH/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x07070707;
	}
#else
#ifdef SIMUL
	for(i = 0; i < 2; i++)
#else
	for(i = 0; i < FRAME_HEIGHT; i++)
#endif
	{
		GPIO_Write(i);

		for(j = 0; j < FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = BLACK;
		for(; j < 2*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = BLUE;
		for(; j < 3*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = GREEN;
		for(; j < 4*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = CYAN;
		for(; j < 5*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = RED;
		for(; j < 6*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = MAGENTA;
		for(; j < 7*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = YELLOW;
		for(; j < FRAME_WIDTH; j++)
			*(frame+i*FRAME_WIDTH+j) = WHITE;
	}
#endif
#else
	extern unsigned rgbdata[];
#ifdef SIMUL
	for(i = 0; i < FRAME_WIDTH*2; i++)
#else
	for(i = 0; i < FRAME_HEIGHT*FRAME_WIDTH; i++)
#endif
		*(frame+i) = rgbdata[i];
#endif

	SMT_WRITE(DMCON, 0x00000006);
	SMT_WRITE(BGCOL, 0xfffdfcfb);

	SMT_WRITE(GPOS, 0x00000000);	// Gplane position : (0,0)

	SMT_WRITE(CCON, 0x00000000);	// Disable Cursor Plane
	SMT_WRITE(VCON, 0x00000000);	// Disable Video Plane

//	SMT_WRITE(GCON, 0x80000000|((FRAME_WIDTH-8)<<11)|(FRAME_HEIGHT-8));
#ifdef USE_PALETTE
	SMT_WRITE(GCON, 0x80000000|((FRAME_WIDTH)<<11)|(FRAME_HEIGHT));
	SMT_WRITE(GBMOD, 0x10000000);
#else
	SMT_WRITE(GCON, 0xA8000000|((FRAME_WIDTH)<<11)|(FRAME_HEIGHT));
	SMT_WRITE(GBMOD, 0x18000000);
#endif
//	SMT_WRITE(GBLND, 0x80ffffff);
	SMT_WRITE(GBLND, 0xffffffff);
//	SMT_WRITE(GBASE, ((FRAME_WIDTH/4)<<22)|(8<<11)|8);
	SMT_WRITE(GBASE, ((FRAME_WIDTH/4)<<22));
	SMT_WRITE(GADDR, ((unsigned)frame)>>2);
	SMT_WRITE(SCON, 0x00000000);	// Scaler disable

	SMT_WRITE(LECON, 0);
	SMT_WRITE(HSYNC0, (LCD_HBP<<8)|LCD_HFP);
	SMT_WRITE(HSYNC1, (LCD_HSW<<11)|LCD_CPL);
	SMT_WRITE(VSYNC0, (LCD_VBP<<8)|LCD_VFP);
	SMT_WRITE(VSYNC1, (LCD_VSW<<11)|LCD_LPS);
	SMT_WRITE(LCDCON, 0xC0000230);
	DPRINTF("Done\n");
}
