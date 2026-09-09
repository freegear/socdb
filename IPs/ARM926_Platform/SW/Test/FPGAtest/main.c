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

//FPGA GCC environment
#include "./API/apigpio.c"
#include "./API/apiuart.c"
#include "./API/apimmc.c"
#include "./API/apidmac.c"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define FRAME_BASEADDR	SDRAM_STARTADDR
#define FRAME_WIDTH 480
#define FRAME_HEIGHT 272

#define BLACK	0xff000000
#define BLUE	0xff0000ff
#define GREEN	0xff00ff00
#define CYAN	0xff00ffff
#define RED		0xffff0000
#define MAGENTA	0xffff00ff
#define YELLOW	0xffffff00
#define WHITE	0xffffffff

#define LCD_HFP	(2-1)	// Horizontal Front Porch(2 clock)
#define LCD_HSW	(41-1)	// Horizontal Sync Width(41 clock)
#define LCD_HBP	(2-1)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (480-1)	// active clocks per line

#define LCD_VFP (2-1)	// Vertical Front Porch(2 line)
#define LCD_VBP (2-1)	// Vertical Back Porch(41 line)
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

int TEST_MODE1(void);

//void rd_cp15r0(void);

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

    UART_Initial();
	//UART_printf("Test\n");

	GPIO_OutputEnable(0xffff);
	GPIO_Write(0x4321);

	// Read CP15 C0 B,C
	//rd_cp15r0();

	while(1); // ARM926 FPGA test


	DDR_Test();

	
/*
	count = 0;
	while(1)
	{
		for(i = 0; i < 10000; i++);
		GPIO_Write(count++);
	}
*/
/*
    smtUint32 errorCode = 0;	// Valid only last 4 bit
    smtUint32 getchar = 0;

    // 1. VIC Initialization
    EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);

 //   UART_Initial();
	MMCcheck();
	while(1); 
   

  while(1)
    {
        UART_printf("_______________SMT AXI_MMCPlatform Test_____________________________\n");
        UART_printf("\n");
        UART_printf("_______________      MODE Number       _____________________________\n");
        UART_printf("_______________1. FPGA MODE : GENERAL TEST MODE___________________\n");
        UART_printf("__________________________________________________________________\n");
        UART_printf("\n");
        
        getchar = UART_getch();
        switch(getchar)
        {
            case 0x31: while (TEST_MODE1()!=1);
                    break;
                    
        }
    }
*/
    while(1);
//___________________FPGA test end

	return 0;
}

/*-----------------------------------------------------------------------
    Function name   : TEST_MODE1()
    Prototype           : int TEST_MODE1(void)
    Return              : int
    Argument        :
    Comments        : TEST function for FPGA MODE1
-----------------------------------------------------------------------*/
int TEST_MODE1(void)
{
    
    smtUint32 getchar = 0;
    while(1)
        {   
        UART_printf("_____________AXI Platform Test__________________\n");
        UART_printf("_______________Press Test Number_____________________\n");
        UART_printf("\n");
        UART_printf("1. MMC TEST \n");
    	UART_printf("0. RETURN PREVIOUS MENU\n");
        UART_printf("\n");
        UART_printf("______________________________________________________\n");
        UART_printf("\n");
        UART_printf("\n");

    
        getchar = UART_getch();
   
        switch(getchar)
        {
        
		case 0x31:// MMC TEST
	        UART_printf("MMC TEST\n");
            	MMCTest();
				break;

		case 0x30:
                UART_printf("RETURN PREVIOUS MENU\n");
                UART_printf("\n");
                return 1;

            
        }
    }
}

void InitializeDDRCtrl(void)
{
	int i;
	unsigned stable_cnt;
	static int initialized = 0;

	if(initialized == 1)
		return;

	UART_printf("Initializing DDR Controller...");
//	SMT_WRITE(DDRTCON, 0x0000b91a);
	SMT_WRITE(DDRTCON, 0x0000b92a);
	SMT_WRITE(DDRCON,  0x00000011);
//	SMT_WRITE(DDRCON,  0x00008091);
	SMT_WRITE(DDRREF,  0x00000820);
	do {
		stable_cnt = SMT_READ(DDRREF);
		stable_cnt &= 0x01f00000;
		stable_cnt >>= 20;
	} while(stable_cnt != 0);

	initialized = 1;
	UART_printf("Done\n");
}

#define DDR_COUNT 16
void DDR_Test(void)
{
	int i;
	volatile smtUint32 * ddram = (volatile smtUint32 *)SDRAM_STARTADDR;
	volatile smtUint16 * us_ddram = (volatile smtUint16 *)SDRAM_STARTADDR;
	unsigned data;
	unsigned short data16;

	InitializeDDRCtrl();

	UART_printf("Writing Data into DDR ...");
	for(i = 0; i < DDR_COUNT; i++)
		ddram[i] = (i)|((i+1)<<8)|((i+2)<<16)|((i+3)<<24);
	UART_printf("Done\n");

	for(i = 0; i < DDR_COUNT; i++)
	{
		data = ddram[i];
		GPIO_Write(data);
		UART_printf("0x%08x\n", data);
	}
}
//#define USE_PALETTE
void DM_Test(void)
{
	int i, j;
	unsigned *frame = (unsigned *)FRAME_BASEADDR;

	// Colorbar generation
#ifdef USE_PALETTE
	SMT_WRITE(GPALM, (0x00<<24)|(BLACK&0x00ffffff));
	SMT_WRITE(GPALM, (0x01<<24)|(BLUE&0x00ffffff));
	SMT_WRITE(GPALM, (0x02<<24)|(GREEN&0x00ffffff));
	SMT_WRITE(GPALM, (0x03<<24)|(CYAN&0x00ffffff));
	SMT_WRITE(GPALM, (0x04<<24)|(RED&0x00ffffff));
	SMT_WRITE(GPALM, (0x05<<24)|(MAGENTA&0x00ffffff));
	SMT_WRITE(GPALM, (0x06<<24)|(YELLOW&0x00ffffff));
	SMT_WRITE(GPALM, (0x07<<24)|(WHITE&0x00ffffff));
//	for(i = 0; i < FRAME_HEIGHT; i++)
	for(i = 0; i < 1; i++)
	{
		GPIO_Write(i);
		for(j = 0; j < FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH+j) = 0x00000000;
		for(; j < 2*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH+j) = 0x01010101;
		for(; j < 3*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH+j) = 0x02020202;
		for(; j < 4*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH+j) = 0x03030303;
		for(; j < 5*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH+j) = 0x04040404;
		for(; j < 6*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH+j) = 0x05050505;
		for(; j < 7*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH+j) = 0x06060606;
		for(; j < FRAME_WIDTH/4; j++)
			*(frame+i*FRAME_WIDTH+j) = 0x07070707;
	}
#else
//	for(i = 0; i < FRAME_HEIGHT; i++)
	for(i = 0; i < 1; i++)
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

	SMT_WRITE(DMCON, 0x00000006);
	SMT_WRITE(BGCOL, 0xfffdfcfb);

	SMT_WRITE(GPOS, 0x00000000);	// Gplane position : (0,0)

	SMT_WRITE(CCON, 0x00000000);	// Disable Cursor Plane
	SMT_WRITE(VCON, 0x00000000);	// Disable Video Plane

//	SMT_WRITE(GCON, 0x80000000|((FRAME_WIDTH-8)<<11)|(FRAME_HEIGHT-8));
#ifdef USE_PALETTE
	SMT_WRITE(GCON, 0x80000000|((FRAME_WIDTH)<<11)|(FRAME_HEIGHT));
#else
	SMT_WRITE(GCON, 0xA8000000|((FRAME_WIDTH)<<11)|(FRAME_HEIGHT));
#endif
	SMT_WRITE(GBLND, 0x80ffffff);
	SMT_WRITE(GBMOD, 0x18000000);
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
}
