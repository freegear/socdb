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

/*-----------------------------------------------------------
    BASE ADDRESS DEFINITION
-----------------------------------------------------------*/
#define FLASH_BASE_ADDR        0x01FF8000

#define SRAM_BASE_ADDR        0x01FF8100

#define SDRAM_BASE_ADDR        0x01FF8100

#define UART0_BASE_ADDR        0x80004000
#define UART1_BASE_ADDR        0x80008000


#define I2C_BASE_ADDR        0x01FF8300

#define VIF_BASE_ADDR		0x01FF8300

#define TIMER_BASE_ADDR        0x01FF8400

#define PWM0_0_BASE_ADDR        0x01FF8500
#define PWM1_0_BASE_ADDR        0x01FF8600
#define PWM2_0_BASE_ADDR        0x01FF8700
#define PWM3_0_BASE_ADDR        0x01FF8800

#define WDT_BASE_ADDR        0x01FF8900
#define GPIO_BASE_ADDR        0x01FF8A00
#define VIC_BASE_ADDR        0x01FF8B00
#define ADC_BASE_ADDR        0x01FF8C00
#define POWER_BASE_ADDR        0x01FF8D00


#define APB0_STARTADDR    0x20000000
#define APB1_STARTADDR    0x30000000

#endif /* __SYSCFG_H__ */
