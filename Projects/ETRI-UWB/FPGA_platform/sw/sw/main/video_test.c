/*----------------------------------------------------------
	File Name   : video_test.c 
	Description : Video Test Code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "memorymap.h"

//FPGA GCC environment
#include "gpio.h"
#include "uart.h"


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define NTSC 
#define IMAGE_TEST //only ntsc
//#define LOGO_MOV   //only ntsc (IMAGE test sub function)
//#define COLORBAR //undefine --> 565COLORBAR mode
//#define SIMUL
//#define USE_PALETTE


/* NTSC image */
#ifdef LOGO_MOV
#include "./test_interlace0.c"
#include "./test_interlace1.c"
#else
#include "./test565_interlace0.c"
#include "./test565_interlace1.c"
#endif

#define BLACK	0xff000000
#define RED	    0xffff0000
#define GREEN	0xff00ff00
#define MAGENTA	0xffffff00
#define BLUE    0xff0000ff
#define CYAN	0xffff00ff
#define YELLOW	0xff00ffff
#define WHITE	0xffffffff

#define BLACK565	0x00000000
#define RED565	    0xF800F800
#define GREEN565	0x07E007E0
#define MAGENTA565	0xFFE0FFE0
#define BLUE565		0x001f001f
#define CYAN565	    0xf81ff81f
#define YELLOW565	0x07ff07ff
#define WHITE565	0xffffffff

#define LUMA_FILTER_SEL     0
#define CHRO_FILTER_SEL     3
#define EN_COLOR_KILL       0
#define EN_REST_SCH         1
#define EN_INTERNAL_PATTERN 0
#define COLOR_PATTERN_MODE  0
#define CHRO_DELAY          0
#define LUMA_DELAY          0
#define BURST_WID           0
#define HSYNC_WID           0
#define SUB_PHASE           0
#define SUB_REQ             0
#define EN_DAC0             1
#define EN_DAC1             1
#define EN_DAC2             1
#define EN_SQPIXEL          0
#define EN_NONINTERLACE     0


#ifdef NTSC

#define MODE         0
#define FRAME_WIDTH  720
#define FRAME_HEIGHT 240
#define LCD_HFP	(31)	        // Horizontal Front Porch(2 clock)
#define LCD_HSW	(122)	        // Horizontal Sync Width(41 clock)
#define LCD_HBP	((122*2)-121)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (720 *2)	    // active clocks per line

#define LCD_VSW (3)	    // Vertical Sync Width(10 line)
#define LCD_LPS (240)	// active lines per screen
#define LCD_VBP (16)	// Vertical Back Porch(4 line)
#define LCD_VFP (3)	    // Vertical Front Porch(4 line)

#define LCD_IVS (1)	    
#define LCD_IHS (1)	    
#define LCD_IEO (0)	    
#define LCD_BCD (1)	    
#define LCD_BPP (2)	    
#define LCD_BGR (0)	    
#define LCD_IPS (1)

#else

#define MODE         4
#define FRAME_WIDTH  720
#define FRAME_HEIGHT 288

#define LCD_HFP	(23)	        // Horizontal Front Porch(2 clock)
#define LCD_HSW	(132)	        // Horizontal Sync Width(41 clock)
#define LCD_HBP	((132*2)-131)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (720 *2)	    // active clocks per line

#define LCD_VSW (2)	    // Vertical Sync Width(10 line)
#define LCD_LPS (288)	// active lines per screen
#define LCD_VBP (20)	// Vertical Back Porch(4 line)
#define LCD_VFP (2)	    // Vertical Front Porch(4 line)

#define LCD_IVS (1)	    
#define LCD_IHS (1)	    
#define LCD_IEO (0)	    
#define LCD_BCD (1)	    
#define LCD_BPP (2)	    
#define LCD_BGR (0)	    
#define LCD_IPS (1)

#endif

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void DMColorBar(void);
static void VideoEncoderEnable(void);
static void DMVideoEncImage(void);
static void DMVideoEncImageMov(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

//#include "audio_skin_play.h"
//#include "video_skin_pause.h"

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : VideoEncoderEnable()
    Prototype       : void VideoEncoderEnable(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void VideoEncoderEnable(void)
{

    SMT_WRITE(VIDEOENC_CONTROL  ,((MODE << 29) 
                                 |(EN_NONINTERLACE <<26)
                                 |(EN_SQPIXEL << 25) 
                                 |(EN_DAC2 << 2)
                                 |(EN_DAC1 << 1)
                                 |(EN_DAC0     )) 
                                 ); 


    SMT_WRITE(VIDEOENC_INTERNAL ,  (LUMA_FILTER_SEL << 4)
                                  |(CHRO_FILTER_SEL << 6) 
                                  |(EN_REST_SCH << 12)
                                  |(EN_COLOR_KILL << 11)
                                  |(COLOR_PATTERN_MODE << 13)
                                  |(EN_INTERNAL_PATTERN << 15)
                                  |(CHRO_DELAY  << 18)
                                  |(LUMA_DELAY  << 21)
                                  |(BURST_WID   << 24)
                                  |(HSYNC_WID   << 26)
                                 ); 


	SMT_WRITE(VIDEOENC_STATUS	, 0x80000000); //Encoder enable

//	data = (SMT_READ(VIDEOENC_CONTROL)) & 0xFFFFFFFF; 
 //   sprintf(OutString, "VideoControl->%x\n", data);
//	DebugPrint(OutString);
}

/*-----------------------------------------------------------------------
    Function name   : DMTest()
    Prototype       : void DMTest(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void DMColorBar(void)
{
	int i, j;
	unsigned *frame = (unsigned *)FRAME_BASEADDR;

	// Colorbar generation
#ifdef COLORBAR
#ifdef USE_PALETTE
	SMT_WRITE(GPALM, (0x00<<24)|(BLACK & 0x00ffffff));
	SMT_WRITE(GPALM, (0x01<<24)|(BLUE & 0x00ffffff));
	SMT_WRITE(GPALM, (0x02<<24)|(GREEN & 0x00ffffff));
	SMT_WRITE(GPALM, (0x03<<24)|(CYAN & 0x00ffffff));
	SMT_WRITE(GPALM, (0x04<<24)|(RED & 0x00ffffff));
	SMT_WRITE(GPALM, (0x05<<24)|(MAGENTA & 0x00ffffff));
	SMT_WRITE(GPALM, (0x06<<24)|(YELLOW & 0x00ffffff));
	SMT_WRITE(GPALM, (0x07<<24)|(WHITE & 0x00ffffff));

	for(i = 0; i < FRAME_HEIGHT; i++)
	{
		GPIOWrite(i);
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

	for(i = 0; i < FRAME_HEIGHT; i++)
	{
		GPIOWrite(i);
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

	for(i = 0; i < FRAME_HEIGHT; i++)
    {
		//*(frame+i) = rgbdata[i];
		for(j = 0; j < FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 2*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;//BLUE565;
		for(; j < 3*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 4*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 5*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 6*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 7*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < FRAME_WIDTH; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;

    }

#endif

	SMT_WRITE(DMCON, 0x00000006);
	SMT_WRITE(BGCOL, 0xff00fcfb);

	SMT_WRITE(CCON, 0x00000000);	// Disable Cursor Plane
	SMT_WRITE(VCON, 0x00000000);	// Disable Video Plane

	SMT_WRITE(GBLND, (0xff<<24)		// Global Alpha
				    |(0xffffff));		// Chroma Key Value(not used)

	SMT_WRITE(GBASE, 0);	// stide : 0
	//SMT_WRITE(GADDR, ((unsigned)frame+(100+ (50*720)) *4));	// frame address
	SMT_WRITE(GADDR, ((unsigned)frame));	// frame address
	//SMT_WRITE(GADDR, 0x54400000);	// frame address

	SMT_WRITE(SCON, 0x00000000);	// Scaler disable

	SMT_WRITE(HSYNC0, (LCD_HBP<<8)|LCD_HFP);
	SMT_WRITE(HSYNC1, (LCD_HSW<<11)|LCD_CPL);
	SMT_WRITE(VSYNC0, (LCD_VBP<<8)|LCD_VFP);
	SMT_WRITE(VSYNC1, (LCD_VSW<<11)|LCD_LPS);
	SMT_WRITE(LCDCON, (0<<31) //Video Encoder 
                      |(1<<30) 
                      |(LCD_BPP<<9)
                      |(LCD_BGR<<8)
                      |(LCD_IEO<<6)
                      |(LCD_IVS<<5)
                      |(LCD_IHS<<4)
                      |(LCD_IPS<<3)
             );
#ifdef USE_PALETTE
	SMT_WRITE(GCON, (1 << 31)	// Enable Plane
				| (0 << 27)		// Pixel Format : 8bit(00), 16bit(2,3), 32bit(4)
				| (0 << 26)		// disable gamma
				| ((FRAME_WIDTH)<<11)
				| (FRAME_HEIGHT));

	SMT_WRITE(GBMOD, (0 << 30)	// disalbe colorkeying
				| (2 << 27)		// Global Alpha bleding
				| (0 << 11)		// X Start Posision : 0
				| (0));			// Y Start Position : 0
#else
	SMT_WRITE(GBMOD, (0 << 30)	// disalbe colorkeying
				| (2 << 27)		// Global Alpha bleding
				| (0 << 11)		// X Start Posision : 0
				| (0));			// Y Start Position : 0

#ifdef DM_COLORBAR
	SMT_WRITE(GCON, (1 << 31)	// Enable Plane
                | (1<< 30)
				| (5 << 27)		// Pixel Format : ARGB(32bit)
				| (0 << 26)		// diable gamma
				| ((FRAME_WIDTH)<<11)
				| (FRAME_HEIGHT));
	GPIOWrite(0x4444);

#else
	SMT_WRITE(GCON, (1 << 31)	// Enable Plane
                | (0<< 30)
				| (2 << 27)		// Pixel Format : RGB(16bit)
				| (1 << 26)		// diable gamma
				| ((FRAME_WIDTH)<<11)
				| (FRAME_HEIGHT));


	GPIOWrite(0x4441);
#endif

#endif
}

static void DMVideoEncImage(void)
{
#ifdef IMAGE_TEST
	int i;
	int count, bcount, bcount1;
	short *frame0 = (short *)FRAME_BASEADDR;
	short *frame1 = (short *)(FRAME_BASEADDR+(FRAME_HEIGHT*FRAME_WIDTH*2));

	for(i = 0; i < FRAME_HEIGHT*FRAME_WIDTH; i++)
		*(frame0+i) = image_odd[i];

	for(i = 0; i < FRAME_HEIGHT*FRAME_WIDTH; i++)
		*(frame1+i) = image_even[i];

	SMT_WRITE(DMCON, 0x00000006);
	SMT_WRITE(BGCOL, 0xff00fcfb);

	SMT_WRITE(CCON, 0x00000000);	// Disable Cursor Plane
	SMT_WRITE(VCON, 0x00000000);	// Disable Video Plane

	SMT_WRITE(GBLND, (0xff<<24)		// Global Alpha
				    |(0xffffff));		// Chroma Key Value(not used)

	SMT_WRITE(GBASE, 0);	// stide : 0
	SMT_WRITE(GADDR, ((unsigned)(frame1)));	// frame address

	SMT_WRITE(SCON, 0x00000000);	// Scaler disable

	SMT_WRITE(HSYNC0, (LCD_HBP<<8)|LCD_HFP);
	SMT_WRITE(HSYNC1, (LCD_HSW<<11)|LCD_CPL);
	SMT_WRITE(VSYNC0, (LCD_VBP<<8)|LCD_VFP);
	SMT_WRITE(VSYNC1, (LCD_VSW<<11)|LCD_LPS);
	SMT_WRITE(LCDCON, (0<<31) //Video Encoder 
                      |(1<<30) 
                      |(LCD_BPP<<9)
                      |(LCD_BGR<<8)
                      |(LCD_IEO<<6)
                      |(LCD_IVS<<5)
                      |(LCD_IHS<<4)
                      |(LCD_IPS<<3)
             );

#if 0
#if 0
	SMT_WRITE(GGAMMA00,  0  );
	SMT_WRITE(GGAMMA01,  35  << 16 | 35 << 8 |35 );
	SMT_WRITE(GGAMMA02,  57  << 16 | 57 << 8 |57);
	SMT_WRITE(GGAMMA03,  48  << 16 | 48 <<8 |48 );
	SMT_WRITE(GGAMMA04,  64  << 16 | 64 << 8 |64);
    SMT_WRITE(GGAMMA05,  80  << 16 | 80 << 8 |80);
	SMT_WRITE(GGAMMA06,  96  << 16 | 96 << 8 |96);
	SMT_WRITE(GGAMMA07,  112 << 16 | 112 << 8 |112);
	SMT_WRITE(GGAMMA08,  128 << 16 | 128 << 8 |128);
	SMT_WRITE(GGAMMA09,  144 << 16 | 144<<8 |114);
	SMT_WRITE(GGAMMA0A,  160 << 16 | 160 <<8 |160);
	SMT_WRITE(GGAMMA0B,  176 << 16 | 176 << 8 |176);
	SMT_WRITE(GGAMMA0C,  192 << 16 | 192 << 8 |192);
	SMT_WRITE(GGAMMA0D,  208 << 16 | 208<<8 | 208);
	SMT_WRITE(GGAMMA0E,  224 << 16 | 224<<8 | 224);
	SMT_WRITE(GGAMMA0F,  240 << 16 | 240<<8 | 240);
	SMT_WRITE(GGAMMA10,  255 << 16 | 255<<8 | 255);

#else

	SMT_WRITE(GGAMMA00,  0  );
	SMT_WRITE(GGAMMA01,  35 << 16 |35 << 8 |35 );
	SMT_WRITE(GGAMMA02,  57 << 16 |57 << 8 |57);
	SMT_WRITE(GGAMMA03,  77 << 16 |77 <<8 |77 );
	SMT_WRITE(GGAMMA04,  95 << 16 |95 << 8 |95);
    SMT_WRITE(GGAMMA05,  111 << 16 |111 << 8 |111);
	SMT_WRITE(GGAMMA06,  127 << 16 |127 << 8 |127);
	SMT_WRITE(GGAMMA07,  141 << 16 |141 << 8 |141);
	SMT_WRITE(GGAMMA08,  156 << 16 |156 << 8 |156);
	SMT_WRITE(GGAMMA09,  169<<16 |169<<8 |169);
	SMT_WRITE(GGAMMA0A,  182 << 16 |182 <<8 |182);
	SMT_WRITE(GGAMMA0B,  195 << 16 |195 << 8 |195);
	SMT_WRITE(GGAMMA0C,  208 << 16 |208 << 8 |208);
	SMT_WRITE(GGAMMA0D,  220<<16 | 220<<8 | 220);
	SMT_WRITE(GGAMMA0E,  232<<16 | 232<<8 | 232);
	SMT_WRITE(GGAMMA0F,  244<<16 | 244<<8 | 244);

#endif
#endif


	SMT_WRITE(GCON, (1 << 31)	// Enable Plane
                | (0<< 30)
				| (2 << 27)		// Pixel Format : RGB(16bit)
				| (0 << 26)		// diable gamma
				| ((FRAME_WIDTH)<<11)
				| (FRAME_HEIGHT));

	GPIOWrite(0x2441);

	while(1)
    {
		char uart_input;
	    count = (SMT_READ(VIDEOENC_STATUS)); 
        count = (count>>19) & 0x3ff; //Horizontal counter read

        //Field Address switch
	    GPIOWrite(count);
        if(count == 10 && bcount == 9) {
            bcount = count;
	        SMT_WRITE(GADDR, ((unsigned)(FRAME_BASEADDR+(FRAME_HEIGHT*FRAME_WIDTH*2))));	// frame address
        } else {
            bcount = count;
        }

        //Field Address switch
        if(count == 300 && bcount1 == 299) {
            bcount1 = count;
	        SMT_WRITE(GADDR, ((unsigned)FRAME_BASEADDR));	// frame address
        } else {
            bcount1 = count;
        }

		if(UartDataAvailable())
		{
			uart_input = UartGetch();
			if(uart_input == '0')
				break;
		}
    }

#endif
}

static void MEMCPY(short *in, short *out, int X, int Y)
{
	int i, j, k, p;

    k = 0;
    p = 0;
	for(i = 0; i < FRAME_HEIGHT; i++) {
	    for(j = 0; j < FRAME_WIDTH; j++){

            if((j >= X && j < (X+560)) && (i >= Y && i < (Y+155))) {
		        *(out+p) = in[k++];
                p++;
            } else {
                *(out+p) = 65535;
                p++;
            }

        }
    }
}

#define VIEWTAP  3
#define MEMBLANK (FRAME_HEIGHT*FRAME_WIDTH*2)

static void DMVideoEncImageMove(void)
{
    unsigned int NextAddressEven;
    unsigned int NextAddressOdd;
	int i, count, bcount, bcount1, ViewCnt;
    int FlagLeftRight;

    FlagLeftRight = 0;
    ViewCnt = 0;
    i = 0;
    NextAddressEven = (FRAME_BASEADDR+(FRAME_HEIGHT*FRAME_WIDTH*2));
    NextAddressOdd  = (FRAME_BASEADDR);

	while(1)
    {
	    count = (SMT_READ(VIDEOENC_STATUS)); 
        count = (count>>19) & 0x3ff; //Horizontal counter read

        if(ViewCnt == VIEWTAP) {

            if(FlagLeftRight == 0) i++;
            else                   i--;
            if(i == 16) FlagLeftRight = 1;
            if(i == 0)  FlagLeftRight = 0;
            
            NextAddressEven = (FRAME_BASEADDR+(MEMBLANK*((i*2)+1))); 
            NextAddressOdd  = (FRAME_BASEADDR+(MEMBLANK*(i*2)));
            ViewCnt = 0;
        }

        //Field Address switch
	    GPIOWrite(count);
        if(count == 10 && bcount == 9) {
            bcount = count;
            ViewCnt++;
	        SMT_WRITE(GADDR, ((unsigned)NextAddressEven));	// frame address
        } else {
            bcount = count;
        }

        //Field Address switch
        if(count == 300 && bcount1 == 299) {
            bcount1 = count;
	        SMT_WRITE(GADDR, ((unsigned)NextAddressOdd));	// frame address
        } else {
            bcount1 = count;
        }
    }
}

static void DMVideoEncImageMov(void)
{
#ifdef IMAGE_TEST
	short *frame0 = (short *)FRAME_BASEADDR;
	short *frame1 = (short *)(FRAME_BASEADDR+(FRAME_HEIGHT*FRAME_WIDTH*2));

	short *frame1_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*2));
	short *frame1_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*3));
	short *frame2_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*4));
	short *frame2_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*5));
	short *frame3_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*6));
	short *frame3_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*7));
	short *frame4_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*8));
	short *frame4_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*9));

	short *frame5_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*10));
	short *frame5_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*11));
	short *frame6_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*12));
	short *frame6_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*13));
	short *frame7_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*14));
	short *frame7_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*15));
	short *frame8_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*16));
	short *frame8_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*17));

	short *frame9_0  = (short *)(FRAME_BASEADDR+(MEMBLANK*18));
	short *frame9_1  = (short *)(FRAME_BASEADDR+(MEMBLANK*19));
	short *frame10_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*20));
	short *frame10_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*21));
	short *frame11_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*22));
	short *frame11_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*23));
	short *frame12_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*24));
	short *frame12_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*25));

	short *frame13_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*26));
	short *frame13_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*27));
	short *frame14_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*28));
	short *frame14_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*29));
	short *frame15_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*30));
	short *frame15_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*31));
	short *frame16_0 = (short *)(FRAME_BASEADDR+(MEMBLANK*32));
	short *frame16_1 = (short *)(FRAME_BASEADDR+(MEMBLANK*33));

    MEMCPY((short *)image_odd,  frame0, 0, 40);
    MEMCPY((short *)image_even, frame1, 0, 40);
    MEMCPY((short *)image_odd,  frame1_0, 20, 40);
    MEMCPY((short *)image_even, frame1_1, 20, 40);
    MEMCPY((short *)image_odd,  frame2_0, 40, 40);
    MEMCPY((short *)image_even, frame2_1, 40, 40);
    MEMCPY((short *)image_odd,  frame3_0, 60, 40);
    MEMCPY((short *)image_even, frame3_1, 60, 40);
    MEMCPY((short *)image_odd,  frame4_0, 80, 40);
    MEMCPY((short *)image_even, frame4_1, 80, 40);
    MEMCPY((short *)image_odd,  frame5_0, 80, 30);
    MEMCPY((short *)image_even, frame5_1, 80, 30);
    MEMCPY((short *)image_odd,  frame6_0, 80, 20);
    MEMCPY((short *)image_even, frame6_1, 80, 20);
    MEMCPY((short *)image_odd,  frame7_0, 80, 10);
    MEMCPY((short *)image_even, frame7_1, 80, 10);
    MEMCPY((short *)image_odd,  frame8_0, 80, 00);
    MEMCPY((short *)image_even, frame8_1, 80, 00);
    MEMCPY((short *)image_odd,  frame9_0, 85, 00);
    MEMCPY((short *)image_even, frame9_1, 85, 00);
    MEMCPY((short *)image_odd,  frame10_0, 95, 00);
    MEMCPY((short *)image_even, frame10_1, 95, 00);
    MEMCPY((short *)image_odd,  frame11_0, 120, 00);
    MEMCPY((short *)image_even, frame11_1, 120, 00);
    MEMCPY((short *)image_odd,  frame12_0, 130, 20);
    MEMCPY((short *)image_even, frame12_1, 130, 20);
    MEMCPY((short *)image_odd,  frame13_0, 110, 40);
    MEMCPY((short *)image_even, frame13_1, 110, 40);
    MEMCPY((short *)image_odd,  frame14_0, 100, 60);
    MEMCPY((short *)image_even, frame14_1, 100, 60);
    MEMCPY((short *)image_odd,  frame15_0, 100, 80);
    MEMCPY((short *)image_even, frame15_1, 100, 80);
    MEMCPY((short *)image_odd,  frame16_0, 80, 80);
    MEMCPY((short *)image_even, frame16_1, 80, 80);

	SMT_WRITE(DMCON, 0x00000006);
	SMT_WRITE(BGCOL, 0xff00fcfb);

	SMT_WRITE(CCON, 0x00000000);	// Disable Cursor Plane
	SMT_WRITE(VCON, 0x00000000);	// Disable Video Plane

	SMT_WRITE(GBLND, (0xff<<24)		// Global Alpha
				    |(0xffffff));		// Chroma Key Value(not used)

	SMT_WRITE(GBASE, 0);	// stide : 0
	SMT_WRITE(GADDR, ((unsigned)(frame1)));	// frame address

	SMT_WRITE(SCON, 0x00000000);	// Scaler disable

	SMT_WRITE(HSYNC0, (LCD_HBP<<8)|LCD_HFP);
	SMT_WRITE(HSYNC1, (LCD_HSW<<11)|LCD_CPL);
	SMT_WRITE(VSYNC0, (LCD_VBP<<8)|LCD_VFP);
	SMT_WRITE(VSYNC1, (LCD_VSW<<11)|LCD_LPS);
	SMT_WRITE(LCDCON, (0<<31) //Video Encoder 
                      |(1<<30) 
                      |(LCD_BPP<<9)
                      |(LCD_BGR<<8)
                      |(LCD_IEO<<6)
                      |(LCD_IVS<<5)
                      |(LCD_IHS<<4)
                      |(LCD_IPS<<3)
             );

	SMT_WRITE(GGAMMA00,  0  );
	SMT_WRITE(GGAMMA01,  35 << 16 |35 << 8 |35 );
	SMT_WRITE(GGAMMA02,  57 << 16 |57 << 8 |57);
	SMT_WRITE(GGAMMA03,  77 << 16 |77 <<8 |77 );
	SMT_WRITE(GGAMMA04,  95 << 16 |95 << 8 |95);
    SMT_WRITE(GGAMMA05,  111 << 16 |111 << 8 |111);
	SMT_WRITE(GGAMMA06,  127 << 16 |127 << 8 |127);
	SMT_WRITE(GGAMMA07,  141 << 16 |141 << 8 |141);
	SMT_WRITE(GGAMMA08,  156 << 16 |156 << 8 |156);
	SMT_WRITE(GGAMMA09,  169<<16 |169<<8 |169);
	SMT_WRITE(GGAMMA0A,  182 << 16 |182 <<8 |182);
	SMT_WRITE(GGAMMA0B,  195 << 16 |195 << 8 |195);
	SMT_WRITE(GGAMMA0C,  208 << 16 |208 << 8 |208);
	SMT_WRITE(GGAMMA0D,  220<<16 | 220<<8 | 220);
	SMT_WRITE(GGAMMA0E,  232<<16 | 232<<8 | 232);
	SMT_WRITE(GGAMMA0F,  244<<16 | 244<<8 | 244);

	SMT_WRITE(GCON, (1 << 31)	// Enable Plane
                | (0<< 30)
				| (2 << 27)		// Pixel Format : RGB(16bit)
				| (0 << 26)		// enable gamma
				| ((FRAME_WIDTH)<<11)
				| (FRAME_HEIGHT));

	GPIOWrite(0x8441);

#endif

    DMVideoEncImageMove();
}

static void DMDisable(void)
{
	SMT_WRITE(GCON, 0x00000000);
	SMT_WRITE(VCON, 0x00000000);
	SMT_WRITE(CCON, 0x00000000);
}

static void VideoEncoderDisable(void)
{
	SMT_WRITE(VIDEOENC_STATUS	, 0x00000000);
}

void VideoTest(void)
{
	VideoEncoderEnable();
//	DMColorBar();
	DMVideoEncImage();
	DMDisable();
	VideoEncoderDisable();
}

static void DMVPlane(void)
{
	int i, j;
	SMT_WRITE(DMCON, 0x00000006);
	SMT_WRITE(BGCOL, 0xfffafcfb);

	SMT_WRITE(CCON, 0x00000000);	// Disable Cursor Plane
	SMT_WRITE(GCON, 0x00000000);	// Disable graphic Plane

	SMT_WRITE(GBLND, (0xff<<24)		// Global Alpha
				    |(0xffffff));		// Chroma Key Value(not used)

	SMT_WRITE(VBLND, (0xff<<24)		// Global Alpha
				    |(0xffffff));		// Chroma Key Value(not used)

	SMT_WRITE(VBASE, 0);	// stide : 0
	SMT_WRITE(VBMOD, (0<<30)		// Disable Color Key
				| (2 << 27)			// Global Alpha
				| (0 << 11)			// XPos : 0
				| (0 << 0));		// YPos 0

	SMT_WRITE(VADDR, ((unsigned)(FRAME_BASEADDR)));	// frame address
	SMT_WRITE(VADDR2, ((unsigned)(FRAME_BASEADDR)));	// frame address
	SMT_WRITE(VADDR20, ((unsigned)(FRAME_BASEADDR)));	// frame address

	SMT_WRITE(HSYNC0, (LCD_HBP<<8)|LCD_HFP);
	SMT_WRITE(HSYNC1, (LCD_HSW<<11)|LCD_CPL);
	SMT_WRITE(VSYNC0, (LCD_VBP<<8)|LCD_VFP);
	SMT_WRITE(VSYNC1, (LCD_VSW<<11)|LCD_LPS);
	SMT_WRITE(LCDCON, (0<<31) //Video Encoder 
                      |(1<<30) 
                      |(LCD_BPP<<9)
                      |(LCD_BGR<<8)
                      |(LCD_IEO<<6)
                      |(LCD_IVS<<5)
                      |(LCD_IHS<<4)
                      |(LCD_IPS<<3)
             );

	SMT_WRITE(VCON, (1 << 31)	// Enable Plane
                | (0<< 30)
				| (2 << 27)		// Pixel Format : Y0UY1V
				| (0 << 26)		// diable gamma
				| ((FRAME_WIDTH)<<11)
				| (FRAME_HEIGHT));

	GPIOWrite(0x2441);
}

static void VIFEnable(void)
{
//	ADV7181BInitCompositeAltera();
	ADV7181BInitComposite();

	SMT_WRITE(VIFSIZ, (720<<11)|240);
	SMT_WRITE(VIFADDR, FRAME_BASEADDR);
	SMT_WRITE(VIFCON, (2<<4)		// YCryCb order
				| (1<<2)			// StartIntEn
				| (1<<1)			// EndIntEn
				| (1<<0)			// DMA Enable
				);
}

void VideoInputTest(void)
{
//	ADV7181BInitCompositeAltera();
//	while(1)
//	{
//		int count = 100000;
//		ADV7181BStatusPrint();
//		while(count--);
//	}
		
	VideoEncoderEnable();
	VIFEnable();
//	DMVideoEncImage();
	DMVPlane();
	while(1) ;
}
