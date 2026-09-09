/*----------------------------------------------------------
    File Name   : syscfg.h
    Description : System configuration
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#ifndef __SYSCFG_H_
#define __SYSCFG_H__

#define EXT_BANK_SIZE    0x08000000
#define EXT_STARTADDR0   0x00000000
#define EXT_STARTADDR1   0x08000000
#define EXT_STARTADDR2   0x10000000
#define EXT_STARTADDR3   0x18000000
#define EXT_STARTADDR4   0x1C000000

#define INTSRAM_SIZE      0x00020000	// 128KB
#define INTSRAM_STARTADDR 0x20000000

#define APB0_STARTADDR    0x40000000
#define APB1_STARTADDR    0x50000000

#define AHB0_STARTADDR    0x70000000
#define AHB1_STARTADDR    0x78000000

#define PCI_MEM_ADDR      0x80000000
#define PCI_IO_ADDR       0x88000000
#define PCI_CONF_ADDR     0x90000000
#define PCI_CONF_DATA     0x98000000

#define DDRRAM_STARTADDR  0x60000000

#define DDR_CLK			(100*1000*1000) // 100 MHz
#define BUS_CLK			(50*1000*1000) // 50 MHz
#define APB0_CLK		(50*1000*1000) // 50 MHz
#define APB1_CLK		(25*1000*1000) // 25 MHz

#endif /* __SYSCFG_H__ */
