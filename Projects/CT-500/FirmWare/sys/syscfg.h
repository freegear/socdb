/*----------------------------------------------------------
    File Name   : syscfg.h
    Description : System configuration
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#ifndef __SYSCFG_H_
#define __SYSCFG_H__
#define __CT500_EVB__

#define MCLK					60000000        // Main clock Further work - 2006/02/27

#define DRAM				1
#define SDRAM				2
#define BDRAMTYPE			SDRAM


/* SDI V5 */
#define DEVICE_ID			0x00105101
#define BOOT_MODE			1       // External boot-mode

// Flash memory
#define FLASH_MAX_SIZE		0x40000     // 256KB

#ifdef  BOOT_MODE
#define FLASH_STARTADDR	0x00100000
#else
#define FLASH_STARTADDR	0x0
#endif

// External SRAM 0 (Max 1MB)
#define EXT_SRAM_MAX_SIZE	0xFA000     // 1MB

#ifdef  BOOT_MODE
#define EXTSRAM_STARTADDR	0x0
#else
#define EXTSRAM_STARTADDR	0x00100000
#endif


// BUSWIDTH : 16/32
#define BUSWIDTH			(16)


/*-----------------------------------------------------------
    PERIPHERAL DEVICE DEFINITION
-----------------------------------------------------------*/
#ifdef __CT500_EVB__
#define CFG_UART_CH			0x3
#else
#define CFG_UART_CH			0x0
#endif

/*-----------------------------------------------------------
    BASE ADDRESS DEFINITION
-----------------------------------------------------------*/
#define APB0_STARTADDR		0x40000000
#define APB1_STARTADDR		0x50000000
#define DDR_STARTADDR		0x60000000


#define EXT_BANK_SIZE		0x08000000
#define EXT_STARTADDR0		0x00000000
#define EXT_STARTADDR1		0x08000000
#define EXT_STARTADDR2		0x10000000
#define EXT_STARTADDR3		0x18000000
#define EXT_STARTADDR4		0x1C000000

#define INTSRAM_SIZE		0x00020000	// 128KB
#define INTSRAM_STARTADDR	0x20000000

#define PSRAM_STARTADDR	0x30000000

#define DDR_CLK				(100*1000*1000) // 100 MHz
#define BUS_CLK				(50*1000*1000) // 50 MHz
#define APB0_CLK			(50*1000*1000) // 50 MHz
#ifdef __CT500_EVB__
#define APB1_CLK			(50*1000*1000)
#else
#define APB1_CLK			(25*1000*1000)
#endif
/*-----------------------------------------------------------
    DDR ADDRESS DEFINITION
-----------------------------------------------------------*/

#define DDRRAM_STARTADDR (0x62000000)

#define DDRRAM_USER		(DDRRAM_STARTADDR+2*1024*1024)	// lower 2MB used as code/data
#define DDR_TESTREGION 	(DDRRAM_USER+4*1024*1024)		// 4MB as Frame buffer
#define AUDIO_TESTADDR 	(DDRRAM_USER+12*1024*1024)		// 8MB as Frame buffer

#define USB_FIFOBUF_STARTADDR	(FRAME_BASEADDR-1024*1024)	//
#define USB_FIFOBUF_ENDADDR		(FRAME_BASEADDR)	// 1MB
// start : DDRRAM_USER+16M ~ 1MBw

#define FRAME_BASEADDR		(0x63000000)
#define CURSOR_BASEADDR		(FRAME_BASEADDR)					// 2MB for Cursor plane 
#define GRAPHIC_BASEADDR	(CURSOR_BASEADDR     +2*1024*1024)	// 2MB for Graphic plane	
#define VIDEO_BASEADDR		(GRAPHIC_BASEADDR	 +2*1024*1024)	// 4MB for Video plane	
#define VIDEO_SRC0_BASEADDR (VIDEO_BASEADDR		 +4*1024*1024)	// 4MB for Video panorama0	
#define VIDEO_SRC1_BASEADDR (VIDEO_SRC0_BASEADDR +4*1024*1024)	// 4MB for Video panorama1	

#endif /* __SYSCFG_H__ */
