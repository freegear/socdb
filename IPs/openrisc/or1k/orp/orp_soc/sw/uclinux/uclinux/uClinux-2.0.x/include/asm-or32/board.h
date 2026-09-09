
#ifndef _ASM_OR32_BOARH_H
#define _ASM_OR32_BOARH_H 

/* System clock frequecy */
#define SYS_CLK		100000000

/* Memory organization */
#define SRAM_BASE_ADD   0x00000000
#define FLASH_BASE_ADD  0xf0000000

/* Devices base address */
#define UART_BASE_ADD   0x90000000
#define MC_BASE_ADD     0x93000000
#define CRT_BASE_ADD    0x97000000
#define FBMEM_BASE_ADD  0xa8000000
#define ETH_BASE_ADD    0x92000000
#define KBD_BASE_ADD	  0x94000000

/* Define this if you want to use I and/or D cache */
#define ICACHE          1
#define DCACHE          1

#define IC_SIZE         8192
#define IC_LINE         16
#define DC_SIZE         8192
#define DC_LINE         16

/* Define this if you want to use I and/or D MMU */
#define IMMU                        0
#define DMMU                        0

#define DMMU_SET_NB                 64
#define DMMU_PAGE_ADD_BITS          13      /* 13 for 8k, 12 for 4k page size */
#define DMMU_PAGE_ADD_MASK          0x3fff  /* 0x3fff for 8k, 0x1fff for 4k page size */
#define DMMU_SET_ADD_MASK           0x3f    /* 0x3f for, 64 0x7f for 128 nuber of sets */
#define IMMU_SET_NB                 64
#define IMMU_PAGE_ADD_BITS          13      /* 13 for 8k, 12 for 4k page size */
#define IMMU_PAGE_ADD_MASK          0x3fff  /* 0x3fff for 8k, 0x1fff for 4k page size */
#define IMMU_SET_ADD_MASK           0x3f    /* 0x3f for, 64 0x7f for 128 nuber of sets */

/* Uart definitions */
#define UART_DLL        0       /* Out: Divisor Latch Low (DLAB=1) */
#define UART_DLM        1       /* Out: Divisor Latch High (DLAB=1) */

/* You have to set console baud rate manually in drivers/char/console.c line 350 (function rs_init()) */
#define OR32_CONSOLE_BAUD  115200
#define UART_DEVISOR       SYS_CLK/(16*OR32_CONSOLE_BAUD)

#define CONFIG_OETH_UNKNOWN_TX_NEXT 1
/* Define this if you are using MC */
#define MC_INIT         1

/* Memory controller initialize values */
#if 0
// 25MHz
#define MC_CSR_VAL      0x0B000300
#define MC_MASK_VAL     0x000003f0
#define FLASH_TMS_VAL   0x00000103
#define SDRAM_BASE_ADD  0x00000000
#define SDRAM_TMS_VAL   0x19220057
#else
// 100MHz
#define MC_CSR_VAL      0x0B000300
#define MC_MASK_VAL     0x000003f0
#define FLASH_TMS_VAL   0x0000010c
#define SDRAM_BASE_ADD  0x00000000
#define SDRAM_TMS_VAL   0x2a5a0300
#endif

/* Define ethernet MAC address */
#define MACADDR0	0x00
#define MACADDR1	0x01
#define MACADDR2	0x02
#define MACADDR3	0x03
#define MACADDR4	0x04
#define MACADDR5	0x05

#endif
