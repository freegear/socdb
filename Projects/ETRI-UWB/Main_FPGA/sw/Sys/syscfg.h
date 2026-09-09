/*----------------------------------------------------------
    File Name   : syscfg.h
    Description : System configuration
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#ifndef __SYSCFG_H_
#define __SYSCFG_H__

#define MCLK            60000000

#define EXT_BANK_SIZE    0x04000000
#define EXT_STARTADDR0   0x00000000
#define EXT_STARTADDR1   0x04000000
#define EXT_STARTADDR2   0x08000000
#define EXT_STARTADDR3   0x0C000000

#define INTSRAM_SIZE      0x00010000	// 64KB
#define INTSRAM_STARTADDR 0x10000000

#define APB0_STARTADDR    0x20000000
#define APB1_STARTADDR    0x30000000

#define SDRAM_STARTADDR   0x40000000

// BUSWIDTH : 16/32
#define BUSWIDTH        (16)

//#define _ISR_STARTADDRESS  0x01ff5f60

#endif /* __SYSCFG_H__ */
