/*----------------------------------------------------------
    File Name   : syscfg.h
    Description : System configuration
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#ifndef __SYSCFG_H_
#define __SYSCFG_H__

#define MCLK            60000000        // Main clock Further work - 2006/02/27

#define DRAM                1
#define SDRAM               2
#define BDRAMTYPE       SDRAM


/* SDI V5 */
#define DEVICE_ID       0x00105101
#define BOOT_MODE       1       // External boot-mode

// Flash memory
#define FLASH_MAX_SIZE       0x40000     // 256KB

#ifdef  BOOT_MODE
#define FLASH_STARTADDR     0x00100000
#else
#define FLASH_STARTADDR     0x0
#endif

// External SRAM 0 (Max 1MB)
#define EXT_SRAM_MAX_SIZE   0xFA000     // 1MB

#ifdef  BOOT_MODE
#define EXTSRAM_STARTADDR   0x0
#else
#define EXTSRAM_STARTADDR   0x00100000
#endif


// BUSWIDTH : 16/32
#define BUSWIDTH        (16)

#define _RAM_STARTADDRESS   0x01ff0000
#define _ISR_STARTADDRESS  0x01ff5f60

#endif /* __SYSCFG_H__ */
