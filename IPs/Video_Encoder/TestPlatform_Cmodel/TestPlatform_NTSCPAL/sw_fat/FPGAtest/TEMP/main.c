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
#include "./API/apilcd.c"	// By DJKIM 2006/11/16
#include "./API/apii2s.c"
#include "./API/apii2c.c"

// FILE system 
#include "./rfat32_lib/drivers/drivers.c"
#include "./rfat32_lib/fat/fat32_access.c"
#include "./rfat32_lib/fat/fat32_base.c"
#include "./rfat32_lib/file-dir-io/dirsearchbrowse.c"
#include "./rfat32_lib/file-dir-io/fatmisc.c"
#include "./rfat32_lib/file-dir-io/filestring.c"
#include "./rfat32_lib/filelib/filelib.c"
#include "./rfat32_lib/ide/ide_access.c"
#include "./rfat32_lib/ide/ide_base.c"

#define DebugPrint(fmt, args...)	UART_printf(fmt, ##args)
//#define DebugPrint(fmt, args...)	/* NULL */

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



/***************************************************************
 * 16Mbyte   -  0x4100.0000    33Mbyte   -  0x4210.0000
 * 15Mbyte   -  0x40F0.0000    32Mbyte   -  0x4200.0000
 * 14Mbyte   -  0x40E0.0000    31Mbyte   -  0x41F0.0000
 * 13Mbyte   -  0x40D0.0000    30Mbyte   -  0x41E0.0000
 * 12Mbyte   -  0x40C0.0000    29Mbyte   -  0x41D0.0000
 * 11Mbyte   -  0x40B0.0000    28Mbyte   -  0x41C0.0000
 * 10Mbyte   -  0x40A0.0000    27Mbyte   -  0x41B0.0000
 * 9Mbyte    -  0x4090.0000    26Mbyte   -  0x41A0.0000
 * 8Mbyte    -  0x4080.0000    25Mbyte   -  0x4190.0000
 * 7Mbyte    -  0x4070.0000    24Mbyte   -  0x4180.0000
 * 6Mbyte    -  0x4060.0000    23Mbyte   -  0x4170.0000
 * 5Mbyte    -  0x4050.0000    22Mbyte   -  0x4160.0000
 * 4Mbyte    -  0x4040.0000    21Mbyte   -  0x4150.0000
 * 3Mbyte    -  0x4030.0000    20Mbyte   -  0x4140.0000
 * 2Mbyte    -  0x4020.0000    19Mbyte   -  0x4130.0000
 * 1Mbyte    -  0x4010.0000    18Mbyte   -  0x4120.0000
 * 0Mbyte    -  0x4000.0000    17Mbyte   -  0x4110.0000                                    
 ***************************************************************/ 
/*
  DDR RAM 64MB memory map
  
  |-----------|
  |    FAT    | 1MB
  |-----------|
  |           |
  |   Video   | 6.5 MB
  |           |
  |-----------|
  |  Cursor   | 8KB
  |-----------|
  |           |
  |  Graphic  | 26.5MB 4KB
  |           |
  |-----------|
  |  Cursor   | 1MB
  |-----------|
  |   Wave    | Max 29MB
  |           |
  |-----------|
*/


#define DRAM_FAT_START        0x43F00000
#define DRAM_VIDEO_START      0x43880000
#define DRAM_GRAPHIC_START	  0x41E00000     
#define DRAM_CURSOR_START     0x41D00000
#define DRAM_WAVE2_START		  0x40B00000
#define DRAM_WAVE_START		  0x40000000

#define DM_USE_VIDEO_PLANE
#define DM_USE_GRAPHIC_PLANE
//#define DM_USE_CURSOR_PLANE
#define DM_USE_WAVE
//#define DM_USE_CRC

//#define DebugPrint Printf 
#define DebugPrint

#define MAX_VIDEO_LOOP_COUNT	100
#define MAX_GRAPHIC_LOOP_COUNT	100
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void UART_Initial(void);
void DM_Test(void);
void DDR_Test(void);              
void AlphaBlending(int direction, int timeDelay);
void SkinAlphaBlending(int direction, int timeDelay, char *fileName, unsigned int addr);

void setCursor(char onOff, unsigned int destAddress);
void viewCursor(unsigned short yPos);
void DrawVideoProgressBar(unsigned int argProgressHeight);
void setVideo(unsigned int startAddress);
void Delay(unsigned int delay);

int sd2Memcpy(char *fileName, unsigned int destAddress, unsigned int length);

void InitializeDDRCtrl(void);
void UART_printf(const char *format, ...);

unsigned int GmGetCRC(volatile unsigned char* buf, unsigned int len);
int changButton(unsigned char *buttonImage, int width, int sx, int sy);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
#ifdef DM_USE_CRC
unsigned int VidCRC[MAX_VIDEO_LOOP_COUNT];                                                
unsigned int RGBCRC[MAX_GRAPHIC_LOOP_COUNT];                                                
#endif

static unsigned int *p_video_start_address   = (unsigned int *)DRAM_VIDEO_START;
static unsigned int *p_graphic_start_address   = (unsigned int *)DRAM_GRAPHIC_START;

#include "audio_skin_play.h"
#include "video_skin_pause.h"

#if 0
// Table used to compute the CRC32 value.
const unsigned int crc_table[256] =
{
  0x00000000, 0x77073096, 0xee0e612c, 0x990951ba, 0x076dc419,
  0x706af48f, 0xe963a535, 0x9e6495a3, 0x0edb8832, 0x79dcb8a4,
  0xe0d5e91e, 0x97d2d988, 0x09b64c2b, 0x7eb17cbd, 0xe7b82d07,
  0x90bf1d91, 0x1db71064, 0x6ab020f2, 0xf3b97148, 0x84be41de,
  0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7, 0x136c9856,
  0x646ba8c0, 0xfd62f97a, 0x8a65c9ec, 0x14015c4f, 0x63066cd9,
  0xfa0f3d63, 0x8d080df5, 0x3b6e20c8, 0x4c69105e, 0xd56041e4,
  0xa2677172, 0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b,
  0x35b5a8fa, 0x42b2986c, 0xdbbbc9d6, 0xacbcf940, 0x32d86ce3,
  0x45df5c75, 0xdcd60dcf, 0xabd13d59, 0x26d930ac, 0x51de003a,
  0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423, 0xcfba9599,
  0xb8bda50f, 0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924,
  0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d, 0x76dc4190,
  0x01db7106, 0x98d220bc, 0xefd5102a, 0x71b18589, 0x06b6b51f,
  0x9fbfe4a5, 0xe8b8d433, 0x7807c9a2, 0x0f00f934, 0x9609a88e,
  0xe10e9818, 0x7f6a0dbb, 0x086d3d2d, 0x91646c97, 0xe6635c01,
  0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e, 0x6c0695ed,
  0x1b01a57b, 0x8208f4c1, 0xf50fc457, 0x65b0d9c6, 0x12b7e950,
  0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3,
  0xfbd44c65, 0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2,
  0x4adfa541, 0x3dd895d7, 0xa4d1c46d, 0xd3d6f4fb, 0x4369e96a,
  0x346ed9fc, 0xad678846, 0xda60b8d0, 0x44042d73, 0x33031de5,
  0xaa0a4c5f, 0xdd0d7cc9, 0x5005713c, 0x270241aa, 0xbe0b1010,
  0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f,
  0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17,
  0x2eb40d81, 0xb7bd5c3b, 0xc0ba6cad, 0xedb88320, 0x9abfb3b6,
  0x03b6e20c, 0x74b1d29a, 0xead54739, 0x9dd277af, 0x04db2615,
  0x73dc1683, 0xe3630b12, 0x94643b84, 0x0d6d6a3e, 0x7a6a5aa8,
  0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1, 0xf00f9344,
  0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb,
  0x196c3671, 0x6e6b06e7, 0xfed41b76, 0x89d32be0, 0x10da7a5a,
  0x67dd4acc, 0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5,
  0xd6d6a3e8, 0xa1d1937e, 0x38d8c2c4, 0x4fdff252, 0xd1bb67f1,
  0xa6bc5767, 0x3fb506dd, 0x48b2364b, 0xd80d2bda, 0xaf0a1b4c,
  0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55, 0x316e8eef,
  0x4669be79, 0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236,
  0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f, 0xc5ba3bbe,
  0xb2bd0b28, 0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31,
  0x2cd99e8b, 0x5bdeae1d, 0x9b64c2b0, 0xec63f226, 0x756aa39c,
  0x026d930a, 0x9c0906a9, 0xeb0e363f, 0x72076785, 0x05005713,
  0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38, 0x92d28e9b,
  0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21, 0x86d3d2d4, 0xf1d4e242,
  0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1,
  0x18b74777, 0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c,
  0x8f659eff, 0xf862ae69, 0x616bffd3, 0x166ccf45, 0xa00ae278,
  0xd70dd2ee, 0x4e048354, 0x3903b3c2, 0xa7672661, 0xd06016f7,
  0x4969474d, 0x3e6e77db, 0xaed16a4a, 0xd9d65adc, 0x40df0b66,
  0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9,
  0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605,
  0xcdd70693, 0x54de5729, 0x23d967bf, 0xb3667a2e, 0xc4614ab8,
  0x5d681b02, 0x2a6f2b94, 0xb40bbe37, 0xc30c8ea1, 0x5a05df1b,
  0x2d02ef8d
};
#endif
                                                                                             
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
	int i, count, loop, cur_pos, pos;
	volatile unsigned int *addr, *dst;
	char fileName[256];
	LCDSTRUCT lcdMode;

	SMT_WRITE(GPIO_OUT, 0x00014321);
	GPIO_OutputEnable(0xffff);
	GPIO_Write(0x4321);

	// UART Initialize
	UART_Initial();
	DebugPrint("Test\n");

	// DDR Initialize
	InitializeDDRCtrl();

/*
#ifdef DM_USE_WAVE	
	BGM_Init();
#endif
*/

	// 1) LCD Setting
	LCDInitialize();

	// Initialize FAT
	IDE_Reset();							// Reset IDE device 	
	IDE_InitDrive();						// Send initialise commands to drive. SD/MMC initialize
	FAT32_FindFAT32Details(DRAM_FAT_START);	// Load FAT Table
	ShowFATDetails();						// Mount info show
	//ListDirectory(2);

#ifdef DM_USE_GRAPHIC_PLANE
    addr = (unsigned int *)DRAM_GRAPHIC_START;
    for(i=0; i<0xFF00*4; i++) /* Init 255 Kbyte */
    {
        *addr = 0x1F1F1F1F;
        addr++;
    }
#endif

#ifdef DM_USE_VIDEO_PLANE
    // Video memory area
    addr = (unsigned int *)DRAM_VIDEO_START;
    for(i=0; i<0x4104*4; i++) /* init 65.1 Kbyte */
    {
        *addr = 0x0;
        addr++;
    }
#endif                                              
    
#ifdef DM_USE_CURSOR_PLANE    
    addr = (unsigned int *)DRAM_CURSOR_START;// Video area DDR start addr
    for(i=0; i<1024/4; i++)      // 1MB area 
    {
        *addr = 0xFFFFFFFF;
        addr++;
    }
#endif    
                    
	DebugPrint("\n\nInitialize ");                  
#ifdef DM_USE_GRAPHIC_PLANE
	DebugPrint("Graphic Module ");
	
	lcdMode.pixelFMT = 0x2; // RGB 565
	lcdMode.width = FRAME_WIDTH;
	lcdMode.height = FRAME_HEIGHT;
	lcdMode.frameAddr = (unsigned)DRAM_GRAPHIC_START;
	LCDSetMode(lcdMode); 
#endif 

    /*                 
    Printf("\n\n[enter]\n\n");
    UART_getch();                           
    */
     
#ifdef DM_USE_GRAPHIC_PLANE
     addr = p_graphic_start_address;
     for(i=1;i<MAX_GRAPHIC_LOOP_COUNT;i++)
     {
       addr += 0xFF00; /* 255 Kbyte*/                

	   if((unsigned int)addr>=DRAM_VIDEO_START)
	   {                               
	   		Printf("G-Addr:V-Base=0x%08X:0x%08X [enter]\n", (unsigned int)addr, DRAM_VIDEO_START);
	   		UART_getch();
	   }
	          
	   sprintf(fileName, "%03d_slide.raw", i);
       DebugPrint("Graphic Frame = 0%s address = 0x%08X:", fileName, addr);
       sd2Memcpy(fileName, (unsigned int)addr, 1024*1024);
	   
	   #ifdef DM_USE_CRC
	   RGBCRC[i]=GmGetCRC((unsigned char *)addr, 0xFF00*4);
	   DebugPrint("CRC32: 0x%08x\n", RGBCRC[i]);
	   #else
	   DebugPrint("\n");
	   #endif
	   
     }
#endif

    
#ifdef DM_USE_VIDEO_PLANE    
    
    /* DRAM_VIDEO_START + 0x4014 = V-frameBuffer */
    addr = p_video_start_address;
    for(i=0;i<MAX_VIDEO_LOOP_COUNT; i++)
    {
       addr += 0x4104; /* 65.1 Kbyte*/
	   sprintf(fileName, "%03d_video.yuv", i);
       DebugPrint("Loading Video Frame = 0%s address = 0x%08X -- ", fileName, addr);
       sd2Memcpy(fileName, (unsigned int)addr, 1024*1024);
	   
	   #ifdef DM_USE_CRC
	   VidCRC[i]=GmGetCRC((unsigned char *)addr, 0x4104*4);
	   DebugPrint("CRC32: 0x%08x\n", VidCRC[i]);
	   #else
	   DebugPrint("\n");
	   #endif	   	         
    }
#endif
      
    setVideo((unsigned int)DRAM_VIDEO_START);
    //setCursor(1, DRAM_CURSOR_START);

  sd2Memcpy("00000test0.snd", DRAM_WAVE2_START, (5)*0x100000);
  sd2Memcpy("00000test.snd", DRAM_WAVE_START, (10)*0x100000);
restart_position:
	#ifdef DM_USE_WAVE	
	BGM_Init();
	#endif
	
#ifdef DM_USE_GRAPHIC_PLANE
	// 1. Introduction Skin
    sd2Memcpy("0001_main.raw", DRAM_GRAPHIC_START, 1024*1024);
 
	// 2. Menu Skin
    sd2Memcpy("0002_menu.raw", DRAM_GRAPHIC_START, 1024*1024);
                 
	SkinAlphaBlending(0, 5000, "001_slide.raw", DRAM_GRAPHIC_START);
	
    addr = dst = p_graphic_start_address;    
    for(count=1;count<MAX_GRAPHIC_LOOP_COUNT;count++)
    {
        addr += 0xFF00;
        
        #ifdef DM_USE_CRC                  		
		if(RGBCRC[count] != GmGetCRC((unsigned char *)addr, 0xFF00*4)) 
		{		
				DebugPrint("[Frame Num : %d] src:dst -- 0x%08x:0x%08x\n",
							count, 
							RGBCRC[count], 
							GmGetCRC((unsigned char *)addr, 0xFF00*4));
							
        		UART_getch();
        }
        else
        {
        	DebugPrint("current Graphic Frame = %d\n", count);
        }                
        #endif
        
        //Printf("Graphic test\n", UART_getch());
        
        for(i=0;i<0xFF00;i++)
           dst[i] =  addr[i]; 
	}

	SkinAlphaBlending(0, 5000, "0003_audio_skin.raw", DRAM_GRAPHIC_START);

	// 4. Audio Skin
    sd2Memcpy("0003_audio_skin.raw", DRAM_GRAPHIC_START, 1024*1024);
    changButton(audio_skin_play, 36, 63, 118);
    
	#ifdef DM_USE_WAVE    
    //sd2Memcpy("00000test.snd", DRAM_WAVE_START, (10)*0x100000);
	BGM_MusicPlay(DRAM_WAVE_START, (10)*0x100000); 
	BGM_MusicPlayWait();
	#endif       
    
	SkinAlphaBlending(0, 5000, "0004_video_skin.raw", DRAM_GRAPHIC_START);  

	// 5. Slide & Audio Skin
    sd2Memcpy("0004_video_skin.raw", DRAM_GRAPHIC_START, 1024*1024);
    changButton( video_skin_pause, 40, 76, 115); 
#endif


	// Video plane alpha 0%
	SMT_WRITE(VBLND, 0xFFFFFFFF); // Video blending 0%
//	SMT_WRITE(CBLND, 0xFFFFFFFF); // Cursor blending 0%
	Delay(0x10000);		
    
#ifdef DM_USE_VIDEO_PLANE 
    
    #ifdef DM_USE_WAVE    
    //sd2Memcpy("00000test0.snd", DRAM_WAVE2_START, (5)*0x100000);                                                                                    
    BGM_MusicPlay0(DRAM_WAVE2_START, (5)*0x100000);     
    #endif       	
    
    cur_pos = 0;
          	
	for(loop=0;loop<5;loop++)
	{		
		addr = dst = p_video_start_address;	       
	    for(count=0;count<MAX_VIDEO_LOOP_COUNT;count++)
	    {                    
	    	
	        addr += 0x4104;
	        
	        #ifdef DM_USE_CRC
			if(VidCRC[count] != GmGetCRC((unsigned char *)addr, 0x4104*4)) 
			{		
					DebugPrint("[Frame Num : %d] src:dst -- 0x%08x:0x%08x\n",
								count, 
								VidCRC[count], 
								GmGetCRC((unsigned char *)addr, 0x4104*4));
								
	        		UART_getch();
	        }
	        else
	        {
	        	DebugPrint("current video Frame = %d\n", count);
	        } 
			#endif
			
	        for(i=0;i<0x4104;i++)
	           dst[i] =  addr[i];
	        
	        Delay(0x10000);Delay(0x10000);Delay(0x10000);Delay(0x10000);
	           
			#ifdef DM_USE_CURSOR_PLANE
				pos = MAX_VIDEO_LOOP_COUNT * loop;
				pos += count;
				if((pos%3)==0)
					cur_pos++;
					
					viewCursor((unsigned int)(cur_pos*1.2));				
			#else
				pos = MAX_VIDEO_LOOP_COUNT * loop;
				pos += count;
				DrawVideoProgressBar(pos+1);							
			#endif
		}           
	}
#endif
    
    #ifdef DM_USE_WAVE 
	BGM_MusicPlayWait();
	#endif

	// Video/Cursor plane alpha 100%
	SMT_WRITE(VBLND, 0x00FFFFFF); // Video blending 100%
	//SMT_WRITE(CBLND, 0x00FFFFFF); // Cursor blending 100%
	Delay(0x10000);	

#ifdef DM_USE_GRAPHIC_PLANE
	AlphaBlending(0, 5000);
#endif

    goto restart_position;

	while(1);

	return 0;
}

/*-----------------------------------------------------------------------
    Function name   : InitializeDDRCtrl()
    Prototype       : void InitializeDDRCtrl(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void InitializeDDRCtrl(void)
{
	int i;
	unsigned stable_cnt;
	static int initialized = 0;

	if(initialized == 1)
		return;

	DebugPrint("Initializing DDR Controller...");
	SMT_WRITE(DDRTCON, 0x0001b92a);
	SMT_WRITE(DDRDLL,  0x00000024);	// DLL Reset & DDR Cas Latency Setting(Mode Register : 010 or 110)
	SMT_WRITE(DDRREF,  0x00000410);
	SMT_WRITE(DDRCON,  0x00000021);	// 48 MHz Clock
	//SMT_WRITE(DDRCON,  0x00000091); // 24 MHz Clock
	do {
		stable_cnt = SMT_READ(DDRREF);
		stable_cnt &= 0x01f00000;
		stable_cnt >>= 20;
	} while(stable_cnt != 0);

	initialized = 1;
	DebugPrint("Done\n");
}

#define DDR_TEST_COUNT 1024		/* 1K WORD */
static unsigned test_temp[DDR_TEST_COUNT];
#define DATA0(x) (((x)&0xff)|((((x+1)&0xff)^0xff)<<8)|((((x+2)&0xff)^0xff)<<16)|(((x+1)&0xff)<<24))
#define DATA1(x) 0x55aaaa55
#define DATA2(x) 0xaa5555aa

/*-----------------------------------------------------------------------
    Function name   : DDR_Test()
    Prototype       : void DDR_Test(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void DDR_Test(void)
{
	int i;
	volatile smtUint32 * ddram_testregion = (volatile smtUint32 *)(SDRAM_STARTADDR+FRAME_WIDTH*FRAME_HEIGHT*4);
	unsigned data;
	unsigned expected_data;

	InitializeDDRCtrl();

	DebugPrint("DDR Test...");

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

	DebugPrint("Done\n");
	return;

error:
	DebugPrint("Error(Read %08x when expected %08x)\n", data, expected_data);
	GPIO_Write(0xdead);
	while(1);
}

// #define COLORBAR
// #define USE_PALETTE
/*-----------------------------------------------------------------------
    Function name   : DM_Test()
    Prototype       : void DM_Test(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void DM_Test(void)
{
	int i, j;
	unsigned *frame = (unsigned *)FRAME_BASEADDR;

	LCDSTRUCT lcdMode;

	DebugPrint("DM Test...");

	extern unsigned rgbdata[];
	for(i = 0; i < FRAME_HEIGHT*FRAME_WIDTH; i++)
		*(frame+i) = rgbdata[i];

	LCDInitialize();
	//LCDEnable(1);

	lcdMode.pixelFMT = 0x5; // 8bit-alpha + 24bit RGB
	lcdMode.width = FRAME_WIDTH;
	lcdMode.height = FRAME_HEIGHT;
	lcdMode.frameAddr = (unsigned)frame;
	LCDSetMode(lcdMode);

	DebugPrint("Done\n");
}

void Delay(unsigned int delay)
{
    int i=0;

    for(i=0;i<delay;i++);    
}
/*-----------------------------------------------------------------------
    Function name   : AlphaBlending()
    Prototype       : void AlphaBlending(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void AlphaBlending(int direction, int timeDelay)
{                            
	volatile int i,j;

	SMT_WRITE(GBMOD, 0x10000000);
            
	switch(direction)
	{
		case 1:
			for(i=0; i<0xff; i++)
			{       
				SMT_WRITE(GBLND, (0x00ffffff | i<<24));
				for(j=0; j<timeDelay; j++);
			}      
		break;
              
        default:
			for(i=0xff; i>0; i--)
			{
				SMT_WRITE(GBLND, (0x00ffffff | i<<24));
				for(j=0; j<timeDelay; j++);
			}       
		break;
	}
}

/*-----------------------------------------------------------------------
    Function name   : SkinAlphaBlending()
    Prototype       : void SkinAlphaBlending()
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void SkinAlphaBlending(int direction, int timeDelay, char *fileName, unsigned int addr)
{
	unsigned int tempclus;
	int readCount; 
                
	AlphaBlending(direction, timeDelay);
	tempclus = fOpen(fileName);	// File statrt clust number

	readCount = fRead(addr, 1024*1024); //fRead(TargetAddr, Length);

	AlphaBlending(1-direction, timeDelay);
}
  

/*-----------------------------------------------------------------------
    Function name   : setCursor()
    Prototype       : void setCursor(char onOff)
    Return          : void
    Argument        :
    Comments        :
    	- C plane position setting
    	- C plane alpha disable/color key 0x0 set
    	- C plane global alpha set
-----------------------------------------------------------------------*/  
void setCursor(char onOff, unsigned int destAddress)
{	                   
	unsigned short *psrc = (unsigned short *)destAddress;
	int i;
	
	for(i=0;i<(64*64);i++)
		*psrc++ = 0x5586;
				
		SMT_WRITE(CPOS, ((164<<11)|38)); // Cursor Position Set   		
		SMT_WRITE(CBLND, 0x00000000);
		SMT_WRITE(CBMOD, 0x10000000); // Cursor plane global alpha
		SMT_WRITE(CADDR, destAddress>>2);
		SMT_WRITE(CBASE, 0);
		SMT_WRITE(CBLINK, 0x00000000);	                          
		
		if(onOff==1)
		{
			SMT_WRITE(CCON, 0x90000000); 
		}
		else
		{
			SMT_WRITE(CCON, 0x0);
		}
	
} 


/*-----------------------------------------------------------------------
    Function name   : viewCursor()
    Prototype       : void viewCursor(unsigned short yPos)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void viewCursor(unsigned short yPos)                     
{                                   
	SMT_WRITE(CPOS, ((164<<11)|(38+(unsigned int)(yPos))));	
	SMT_WRITE(CCON, 0x90000000 | (12<<11) | 12); 	
	SMT_WRITE(CBLND, (0xFF<<24));
	Printf("viewCursor : yPos = %d\n", (38+yPos));
}


/*-----------------------------------------------------------------------
    Function name   : setVideo()
    Prototype       : void setVideo()
    Return          : void
    Argument        :
    Comments        :            
    	- V plane position setting
    	- V plane image size setting
    	- alpha disable / color key 0xFFFFFF set
-----------------------------------------------------------------------*/  
void setVideo(unsigned int startAddress)
{	                   
	SMT_WRITE(VPOS, (190<<11) | 22 );
	SMT_WRITE(VCON, 0x90000000|(146<<11)|(228));
	SMT_WRITE(VBMOD, 0x10000000); // Color key disable, Global alpha
	SMT_WRITE(VBLND, 0x00FFFFFF); // No alpha, Color key 0xFFFFFF
	SMT_WRITE(VBASE, (36<<22) |0);
	SMT_WRITE(VADDR,  startAddress>>2);
	SMT_WRITE(VADDR2, startAddress>>2);
} 


/*-----------------------------------------------------------------------
    Function name   : int sd2Memcpy()
    Prototype       : int sd2Memcpy(char *fileName, unsigned int *destAddress)
    Return          : int 
    Argument        : 0 == read failure
    Comments        :
-----------------------------------------------------------------------*/  
int sd2Memcpy(char *fileName, unsigned int destAddress, unsigned int length)
{
	int readCount; 
	unsigned int tempclus;

	tempclus = fOpen(fileName);	// File statrt clust number
	
	if(tempclus==0)
    {
	    DebugPrint("\n\nraw fail %d, %s\n\n", tempclus, fileName);
        while(1);
    }
                            
	return readCount = fRead(destAddress, length); //fRead(TargetAddr, Length);
}


unsigned int GmGetCRC(volatile unsigned char* buf, unsigned int len)
{

	unsigned int crc32 = 0xffffffff;

	if (buf == 0 || len == 0) return;

	do{

		crc32 = crc_table[(crc32 ^ (*buf++)) & 0xff] ^ (crc32 >> 8);

	} while (--len);

	return crc32;
}

/*-----------------------------------------------------------------------
    Function name   : int sd2Memcpy()
    Prototype       : int sd2Memcpy(char *fileName, unsigned int *destAddress)
    Return          : int 
    Argument        : 0 == read failure
    Comments        :
-----------------------------------------------------------------------*/  
int changButton(unsigned char *buttonImage, int width, int sx, int sy)
{
    int i, j;
	volatile unsigned short *dst;
	volatile unsigned char *src;

    dst = (unsigned short *)DRAM_GRAPHIC_START;
    src = (unsigned char *)buttonImage;

    for(i=0;i<width;i++)
    {
        dst = (unsigned short*)(DRAM_GRAPHIC_START + (480*(i+sy))*2 + (sx*2)); 

        for(j=0;j<width;j++)
        {
            *dst++ = src[0] | src[1]<<8;
            src += 2;
        }
    }
    
}
/*-----------------------------------------------------------------------
	Function name: void DrawVideoProgressBar()
	Prototype		: void DrawVideoProgressBar(unsigend int argProgressHeight)
	Return		: void  
	Argument	: 
	Comments	:
-----------------------------------------------------------------------*/  
void DrawVideoProgressBar(unsigned int argProgressHeight)
{   
	unsigned short i,j,progressHeight;
	unsigned short *destAddr;
	static unsigned int prevProgressHeight; // save progress bar height before
	
	progressHeight = (unsigned int)(argProgressHeight*0.392);
	
	if (prevProgressHeight == progressHeight)
		return;		
	
	//Printf("ProgressBar height = [%d]\n",progressHeight);
		          
	for(i = prevProgressHeight ; i < progressHeight ; i++)
	{
		destAddr =  (unsigned short*)(DRAM_GRAPHIC_START) + (480*(i + 38) )+164 ;
	  	for(j = 0; j < 12; j++)
			*destAddr++ = 0xED2B;
			//*destAddr++ = 0xED35; 
	}
	prevProgressHeight =  progressHeight;   
	if( prevProgressHeight >= 196)
		prevProgressHeight =0;
}
