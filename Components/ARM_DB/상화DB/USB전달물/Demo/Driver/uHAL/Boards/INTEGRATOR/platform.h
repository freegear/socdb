
/* DO NOT EDIT!! - this file automatically generated
 *                 from .s file by awk -f s2h.awk
 */
/***************************************************************************
 *  * Copyright © ARM Limited 1998.  All rights reserved.
 *  ***************************************************************************/
/* ************************************************************************
 * 
 *   Integrator address map
 * 
 * 	NOTE: This is a multi-hosted header file for use with uHAL and
 * 	      supported debuggers.
 * 
 * 	$Id: platform.h,v 1.23.2.5 2000/01/21 18:55:07 asims Exp $
 * 
 * ***********************************************************************/

#ifndef __address_h
#define __address_h                     1

#define PLATFORM_ID                     0x00000040

/*  Common modules for uHAL can be included or excluded by changing these
 *  definitions. These can be over-ridden by the makefile/ARM project file
 *  provided the .h file can is rebuilt.
 */

#ifndef USE_C_LIBRARY
#define USE_C_LIBRARY                   0
#endif
#ifndef uHAL_BOOT
#define uHAL_BOOT                       1
#endif
#ifndef uHAL_HEAP
#define uHAL_HEAP                       1
#endif
#ifndef uHAL_TIMERS
#define uHAL_TIMERS                     1
#endif
#ifndef uHAL_INTERRUPTS
#define uHAL_INTERRUPTS                 1
#endif
#ifndef uHAL_COMPLEX_IRQ
#define uHAL_COMPLEX_IRQ                0
#endif

#ifndef uHAL_PCI
#define uHAL_PCI                        1
#endif


/* ===============================================================================
 *  Integrator definitions
 * ===============================================================================
 * -------------------------------------------------------------------------------
 *  Memory definitions
 * -------------------------------------------------------------------------------
 *  Integrator memory map
 * 
 */
#define INTEGRATOR_BOOT_ROM_LO          0x00000000
#define INTEGRATOR_BOOT_ROM_HI          0x20000000
#define INTEGRATOR_BOOT_ROM_BASE        INTEGRATOR_BOOT_ROM_HI	 /*  Normal position */
#define INTEGRATOR_BOOT_ROM_SIZE        SZ_512K

/* 
 *  New Core Modules have different amounts of SSRAM, the amount of SSRAM fitted can
 *  be found in HDR_STAT.
 * 
 *  The symbol INTEGRATOR_SSRAM_SIZE is kept, however this now refers to the minimum
 *  amount of SSRAM fitted on any core module.
 * 
 *  New Core Modules also alias the SSRAM.
 * 
 */
#define INTEGRATOR_SSRAM_BASE           0x00000000
#define INTEGRATOR_SSRAM_ALIAS_BASE     0x10800000
#define INTEGRATOR_SSRAM_SIZE           SZ_256K

#define INTEGRATOR_FLASH_BASE           0x24000000
#define INTEGRATOR_FLASH_SIZE           SZ_32M

#define INTEGRATOR_MBRD_SSRAM_BASE      0x28000000
#define INTEGRATOR_MBRD_SSRAM_SIZE      SZ_512K

/* 
 *  SDRAM is a SIMM therefore the size is not known.
 * 
 */
#define INTEGRATOR_SDRAM_BASE           0x00040000

#define INTEGRATOR_SDRAM_ALIAS_BASE     0x80000000
#define INTEGRATOR_HDR0_SDRAM_BASE      0x80000000
#define INTEGRATOR_HDR1_SDRAM_BASE      0x90000000
#define INTEGRATOR_HDR2_SDRAM_BASE      0xA0000000
#define INTEGRATOR_HDR3_SDRAM_BASE      0xB0000000

/* 
 *  Logic expansion modules
 * 
 */
#define INTEGRATOR_LOGIC_MODULES_BASE   0xC0000000
#define INTEGRATOR_LOGIC_MODULE0_BASE   0xC0000000
#define INTEGRATOR_LOGIC_MODULE1_BASE   0xD0000000
#define INTEGRATOR_LOGIC_MODULE2_BASE   0xE0000000
#define INTEGRATOR_LOGIC_MODULE3_BASE   0xF0000000

/* -------------------------------------------------------------------------------
 *  Integrator header card registers
 * -------------------------------------------------------------------------------
 * 
 */
#define INTEGRATOR_HDR_ID_OFFSET        0x00
#define INTEGRATOR_HDR_PROC_OFFSET      0x04
#define INTEGRATOR_HDR_OSC_OFFSET       0x08
#define INTEGRATOR_HDR_CTRL_OFFSET      0x0C
#define INTEGRATOR_HDR_STAT_OFFSET      0x10
#define INTEGRATOR_HDR_LOCK_OFFSET      0x14
#define INTEGRATOR_HDR_SDRAM_OFFSET     0x20
#define INTEGRATOR_HDR_INIT_OFFSET      0x24	 /*  CM9x6 */
#define INTEGRATOR_HDR_IC_OFFSET        0x40
#define INTEGRATOR_HDR_SPDBASE_OFFSET   0x100
#define INTEGRATOR_HDR_SPDTOP_OFFSET    0x200

#define INTEGRATOR_HDR_BASE             0x10000000
#define INTEGRATOR_HDR_ID               (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_ID_OFFSET)
#define INTEGRATOR_HDR_PROC             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_PROC_OFFSET)
#define INTEGRATOR_HDR_OSC              (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_OSC_OFFSET)
#define INTEGRATOR_HDR_CTRL             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_CTRL_OFFSET)
#define INTEGRATOR_HDR_STAT             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_STAT_OFFSET)
#define INTEGRATOR_HDR_LOCK             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_LOCK_OFFSET)
#define INTEGRATOR_HDR_SDRAM            (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_SDRAM_OFFSET)
#define INTEGRATOR_HDR_INIT             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_INIT_OFFSET)
#define INTEGRATOR_HDR_IC               (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_IC_OFFSET)
#define INTEGRATOR_HDR_SPDBASE          (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_SPDBASE_OFFSET)
#define INTEGRATOR_HDR_SPDTOP           (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_SPDTOP_OFFSET)

#define INTEGRATOR_HDR_CTRL_LED         0x01
#define INTEGRATOR_HDR_CTRL_MBRD_DETECH  0x02
#define INTEGRATOR_HDR_CTRL_REMAP       0x04
#define INTEGRATOR_HDR_CTRL_RESET       0x08
#define INTEGRATOR_HDR_CTRL_HIGHVECTORS  0x10
#define INTEGRATOR_HDR_CTRL_BIG_ENDIAN  0x20
#define INTEGRATOR_HDR_CTRL_FASTBUS     0x40
#define INTEGRATOR_HDR_CTRL_SYNC        0x80

#define INTEGRATOR_HDR_OSC_CORE_10MHz   0x102
#define INTEGRATOR_HDR_OSC_CORE_15MHz   0x107
#define INTEGRATOR_HDR_OSC_CORE_20MHz   0x10C
#define INTEGRATOR_HDR_OSC_CORE_25MHz   0x111
#define INTEGRATOR_HDR_OSC_CORE_30MHz   0x116
#define INTEGRATOR_HDR_OSC_CORE_35MHz   0x11B
#define INTEGRATOR_HDR_OSC_CORE_40MHz   0x120
#define INTEGRATOR_HDR_OSC_CORE_45MHz   0x125
#define INTEGRATOR_HDR_OSC_CORE_50MHz   0x12A
#define INTEGRATOR_HDR_OSC_CORE_55MHz   0x12F
#define INTEGRATOR_HDR_OSC_CORE_60MHz   0x134
#define INTEGRATOR_HDR_OSC_CORE_65MHz   0x139
#define INTEGRATOR_HDR_OSC_CORE_70MHz   0x13E
#define INTEGRATOR_HDR_OSC_CORE_75MHz   0x143
#define INTEGRATOR_HDR_OSC_CORE_80MHz   0x148
#define INTEGRATOR_HDR_OSC_CORE_85MHz   0x14D
#define INTEGRATOR_HDR_OSC_CORE_90MHz   0x152
#define INTEGRATOR_HDR_OSC_CORE_95MHz   0x157
#define INTEGRATOR_HDR_OSC_CORE_100MHz  0x15C
#define INTEGRATOR_HDR_OSC_CORE_105MHz  0x161
#define INTEGRATOR_HDR_OSC_CORE_110MHz  0x166
#define INTEGRATOR_HDR_OSC_CORE_115MHz  0x16B
#define INTEGRATOR_HDR_OSC_CORE_120MHz  0x170
#define INTEGRATOR_HDR_OSC_CORE_125MHz  0x175
#define INTEGRATOR_HDR_OSC_CORE_130MHz  0x17A
#define INTEGRATOR_HDR_OSC_CORE_135MHz  0x17F
#define INTEGRATOR_HDR_OSC_CORE_140MHz  0x184
#define INTEGRATOR_HDR_OSC_CORE_145MHz  0x189
#define INTEGRATOR_HDR_OSC_CORE_150MHz  0x18E
#define INTEGRATOR_HDR_OSC_CORE_155MHz  0x193
#define INTEGRATOR_HDR_OSC_CORE_160MHz  0x198
#define INTEGRATOR_HDR_OSC_CORE_MASK    0x7FF

#define INTEGRATOR_HDR_OSC_MEM_10MHz    0x10C000
#define INTEGRATOR_HDR_OSC_MEM_15MHz    0x116000
#define INTEGRATOR_HDR_OSC_MEM_20MHz    0x120000
#define INTEGRATOR_HDR_OSC_MEM_25MHz    0x12A000
#define INTEGRATOR_HDR_OSC_MEM_30MHz    0x134000
#define INTEGRATOR_HDR_OSC_MEM_33MHz    0x13A000
#define INTEGRATOR_HDR_OSC_MEM_40MHz    0x148000
#define INTEGRATOR_HDR_OSC_MEM_50MHz    0x15C000
#define INTEGRATOR_HDR_OSC_MEM_60MHz    0x170000
#define INTEGRATOR_HDR_OSC_MEM_66MHz    0x17C000
#define INTEGRATOR_HDR_OSC_MEM_MASK     0x7FF000

#define INTEGRATOR_HDR_OSC_BUS_MODE_CM7x0  0x0
#define INTEGRATOR_HDR_OSC_BUS_MODE_CM9x0  0x0800000
#define INTEGRATOR_HDR_OSC_BUS_MODE_CM9x6  0x1000000
#define INTEGRATOR_HDR_OSC_BUS_MODE_CM10x00  0x1800000
#define INTEGRATOR_HDR_OSC_BUS_MODE_MASK  0x1800000

#define INTEGRATOR_HDR_SDRAM_SPD_OK     BIT5


/* -------------------------------------------------------------------------------
 *  Integrator system registers
 * -------------------------------------------------------------------------------
 * 
 */

/* 
 *  System Controller
 * 
 */
#define INTEGRATOR_SC_ID_OFFSET         0x00
#define INTEGRATOR_SC_OSC_OFFSET        0x04
#define INTEGRATOR_SC_CTRLS_OFFSET      0x08
#define INTEGRATOR_SC_CTRLC_OFFSET      0x0C
#define INTEGRATOR_SC_DEC_OFFSET        0x10
#define INTEGRATOR_SC_ARB_OFFSET        0x14
#define INTEGRATOR_SC_PCIENABLE_OFFSET  0x18
#define INTEGRATOR_SC_LOCK_OFFSET       0x1C

#define INTEGRATOR_SC_BASE              0x11000000
#define INTEGRATOR_SC_ID                (INTEGRATOR_SC_BASE + INTEGRATOR_SC_ID_OFFSET)
#define INTEGRATOR_SC_OSC               (INTEGRATOR_SC_BASE + INTEGRATOR_SC_OSC_OFFSET)
#define INTEGRATOR_SC_CTRLS             (INTEGRATOR_SC_BASE + INTEGRATOR_SC_CTRLS_OFFSET)
#define INTEGRATOR_SC_CTRLC             (INTEGRATOR_SC_BASE + INTEGRATOR_SC_CTRLC_OFFSET)
#define INTEGRATOR_SC_DEC               (INTEGRATOR_SC_BASE + INTEGRATOR_SC_DEC_OFFSET)
#define INTEGRATOR_SC_ARB               (INTEGRATOR_SC_BASE + INTEGRATOR_SC_ARB_OFFSET)
#define INTEGRATOR_SC_PCIENABLE         (INTEGRATOR_SC_BASE + INTEGRATOR_SC_PCIENABLE_OFFSET)
#define INTEGRATOR_SC_LOCK              (INTEGRATOR_SC_BASE + INTEGRATOR_SC_LOCK_OFFSET)

#define INTEGRATOR_SC_OSC_SYS_10MHz     0x20
#define INTEGRATOR_SC_OSC_SYS_15MHz     0x34
#define INTEGRATOR_SC_OSC_SYS_20MHz     0x48
#define INTEGRATOR_SC_OSC_SYS_25MHz     0x5C
#define INTEGRATOR_SC_OSC_SYS_33MHz     0x7C
#define INTEGRATOR_SC_OSC_SYS_MASK      0xFF

#define INTEGRATOR_SC_OSC_PCI_25MHz     0x100
#define INTEGRATOR_SC_OSC_PCI_33MHz     0x0
#define INTEGRATOR_SC_OSC_PCI_MASK      0x100

#define INTEGRATOR_SC_CTRL_SOFTRST      (1 << 0)
#define INTEGRATOR_SC_CTRL_nFLVPPEN     (1 << 1)
#define INTEGRATOR_SC_CTRL_nFLWP        (1 << 2)
#define INTEGRATOR_SC_CTRL_URTS0        (1 << 4)
#define INTEGRATOR_SC_CTRL_UDTR0        (1 << 5)
#define INTEGRATOR_SC_CTRL_URTS1        (1 << 6)
#define INTEGRATOR_SC_CTRL_UDTR1        (1 << 7)

/* 
 *  External Bus Interface
 * 
 */
#define INTEGRATOR_EBI_BASE             0x12000000 

#define INTEGRATOR_EBI_CSR0_OFFSET      0x00
#define INTEGRATOR_EBI_CSR1_OFFSET      0x04
#define INTEGRATOR_EBI_CSR2_OFFSET      0x08
#define INTEGRATOR_EBI_CSR3_OFFSET      0x0C
#define INTEGRATOR_EBI_LOCK_OFFSET      0x20

#define INTEGRATOR_EBI_CSR0             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_CSR0_OFFSET)
#define INTEGRATOR_EBI_CSR1             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_CSR1_OFFSET)
#define INTEGRATOR_EBI_CSR2             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_CSR2_OFFSET)
#define INTEGRATOR_EBI_CSR3             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_CSR3_OFFSET)
#define INTEGRATOR_EBI_LOCK             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_LOCK_OFFSET)

#define INTEGRATOR_EBI_8_BIT            0x00
#define INTEGRATOR_EBI_16_BIT           0x01
#define INTEGRATOR_EBI_32_BIT           0x02
#define INTEGRATOR_EBI_WRITE_ENABLE     0x04
#define INTEGRATOR_EBI_SYNC             0x08
#define INTEGRATOR_EBI_WS_2             0x00
#define INTEGRATOR_EBI_WS_3             0x10
#define INTEGRATOR_EBI_WS_4             0x20
#define INTEGRATOR_EBI_WS_5             0x30
#define INTEGRATOR_EBI_WS_6             0x40
#define INTEGRATOR_EBI_WS_7             0x50
#define INTEGRATOR_EBI_WS_8             0x60
#define INTEGRATOR_EBI_WS_9             0x70
#define INTEGRATOR_EBI_WS_10            0x80
#define INTEGRATOR_EBI_WS_11            0x90
#define INTEGRATOR_EBI_WS_12            0xA0
#define INTEGRATOR_EBI_WS_13            0xB0
#define INTEGRATOR_EBI_WS_14            0xC0
#define INTEGRATOR_EBI_WS_15            0xD0
#define INTEGRATOR_EBI_WS_16            0xE0
#define INTEGRATOR_EBI_WS_17            0xF0


#define INTEGRATOR_CT_BASE              0x13000000	 /*  Counter/Timers */
#define INTEGRATOR_IC_BASE              0x14000000	 /*  Interrupt Controller */
#define INTEGRATOR_RTC_BASE             0x15000000	 /*  Real Time Clock */
#define INTEGRATOR_UART0_BASE           0x16000000	 /*  UART 0 */
#define INTEGRATOR_UART1_BASE           0x17000000	 /*  UART 1 */
#define INTEGRATOR_KBD_BASE             0x18000000	 /*  Keyboard */
#define INTEGRATOR_MOUSE_BASE           0x19000000	 /*  Mouse */

/* 
 *  LED's & Switches
 * 
 */
#define INTEGRATOR_DBG_ALPHA_OFFSET     0x00
#define INTEGRATOR_DBG_LEDS_OFFSET      0x04
#define INTEGRATOR_DBG_SWITCH_OFFSET    0x08

#define INTEGRATOR_DBG_BASE             0x1A000000
#define INTEGRATOR_DBG_ALPHA            (INTEGRATOR_DBG_BASE + INTEGRATOR_DBG_ALPHA_OFFSET)
#define INTEGRATOR_DBG_LEDS             (INTEGRATOR_DBG_BASE + INTEGRATOR_DBG_LEDS_OFFSET)
#define INTEGRATOR_DBG_SWITCH           (INTEGRATOR_DBG_BASE + INTEGRATOR_DBG_SWITCH_OFFSET)


#define INTEGRATOR_GPIO_BASE            0x1B000000	 /*  GPIO */

/* -------------------------------------------------------------------------------
 *  KMI keyboard/mouse definitions
 * -------------------------------------------------------------------------------
 */
/* PS2 Keyboard interface */

#define KMI0_BASE                       INTEGRATOR_KBD_BASE		
#define KEYB_CR                         (INTEGRATOR_KBD_BASE)
#define KEYB_STAT                       (INTEGRATOR_KBD_BASE + 0x4)
#define KEYB_DATA                       (INTEGRATOR_KBD_BASE + 0x8)
#define KEYB_CLK                        (INTEGRATOR_KBD_BASE + 0xC)

/* PS2 Mouse interface */
#define KMI1_BASE                       INTEGRATOR_MOUSE_BASE
#define MOUSE_CR                        INTEGRATOR_MOUSE_BASE
#define MOUSE_STAT                      (INTEGRATOR_MOUSE_BASE+0x4)
#define MOUSE_DATA                      (INTEGRATOR_MOUSE_BASE+0x8)
#define MOUSE_CLK                       (INTEGRATOR_MOUSE_BASE+0xC)

/* general KMI register macros */
#define KMI_CR(b)	((volatile unsigned int *)b) 
#define KMI_STAT(b)    ((volatile unsigned int *)(b+0x4))
#define KMI_DATA(b)    ((volatile unsigned int *)(b+0x8))
#define KMI_CLK(b)     ((volatile unsigned int *)(b+0xC))

/* KMI constants */
#define KMI_TXEMPTY                     0x40
#define KMI_TXBUSY                      0x20
#define KMI_RXFULL                      0x10
#define KMI_RXBUSY                      0x08
#define KMI_PARITY                      0x04

/* -------------------------------------------------------------------------------
 *  V3 Local Bus to PCI Bridge definitions
 * -------------------------------------------------------------------------------
 *  Registers (these are taken from page 129 of the EPC User's Manual Rev 1.04
 *  All V3 register names are prefaced by V3_ to avoid clashing with any other
 *  PCI definitions.  Their names match the user's manual.
 * 
 *  I'm assuming that I20 is disabled.
 * 
 */
#define V3_PCI_VENDOR                   0x00000000
#define V3_PCI_DEVICE                   0x00000002
#define V3_PCI_CMD                      0x00000004
#define V3_PCI_STAT                     0x00000006
#define V3_PCI_CC_REV                   0x00000008
#define V3_PCI_HDR_CFG                  0x0000000C
#define V3_PCI_IO_BASE                  0x00000010
#define V3_PCI_BASE0                    0x00000014
#define V3_PCI_BASE1                    0x00000018
#define V3_PCI_SUB_VENDOR               0x0000002C
#define V3_PCI_SUB_ID                   0x0000002E
#define V3_PCI_ROM                      0x00000030
#define V3_PCI_BPARAM                   0x0000003C
#define V3_PCI_MAP0                     0x00000040
#define V3_PCI_MAP1                     0x00000044
#define V3_PCI_INT_STAT                 0x00000048
#define V3_PCI_INT_CFG                  0x0000004C 
#define V3_LB_BASE0                     0x00000054
#define V3_LB_BASE1                     0x00000058
#define V3_LB_MAP0                      0x0000005E
#define V3_LB_MAP1                      0x00000062
#define V3_LB_BASE2                     0x00000064
#define V3_LB_MAP2                      0x00000066
#define V3_LB_SIZE                      0x00000068
#define V3_LB_IO_BASE                   0x0000006E
#define V3_FIFO_CFG                     0x00000070
#define V3_FIFO_PRIORITY                0x00000072
#define V3_FIFO_STAT                    0x00000074
#define V3_LB_ISTAT                     0x00000076
#define V3_LB_IMASK                     0x00000077
#define V3_SYSTEM                       0x00000078
#define V3_LB_CFG                       0x0000007A
#define V3_PCI_CFG                      0x0000007C
#define V3_DMA_PCI_ADR0                 0x00000080
#define V3_DMA_PCI_ADR1                 0x00000090
#define V3_DMA_LOCAL_ADR0               0x00000084
#define V3_DMA_LOCAL_ADR1               0x00000094
#define V3_DMA_LENGTH0                  0x00000088
#define V3_DMA_LENGTH1                  0x00000098
#define V3_DMA_CSR0                     0x0000008B
#define V3_DMA_CSR1                     0x0000009B
#define V3_DMA_CTLB_ADR0                0x0000008C
#define V3_DMA_CTLB_ADR1                0x0000009C
#define V3_DMA_DELAY                    0x000000E0
#define V3_MAIL_DATA                    0x000000C0
#define V3_PCI_MAIL_IEWR                0x000000D0
#define V3_PCI_MAIL_IERD                0x000000D2
#define V3_LB_MAIL_IEWR                 0x000000D4
#define V3_LB_MAIL_IERD                 0x000000D6
#define V3_MAIL_WR_STAT                 0x000000D8
#define V3_MAIL_RD_STAT                 0x000000DA
#define V3_QBA_MAP                      0x000000DC

/*  PCI COMMAND REGISTER bits
 */
#define V3_COMMAND_M_FBB_EN             BIT9
#define V3_COMMAND_M_SERR_EN            BIT8
#define V3_COMMAND_M_PAR_EN             BIT6
#define V3_COMMAND_M_MASTER_EN          BIT2
#define V3_COMMAND_M_MEM_EN             BIT1
#define V3_COMMAND_M_IO_EN              BIT0

/*  SYSTEM REGISTER bits
 */
#define V3_SYSTEM_M_RST_OUT             BIT15
#define V3_SYSTEM_M_LOCK                BIT14 

/*  PCI_CFG bits
 */
#define V3_PCI_CFG_M_RETRY_EN           BIT10
#define V3_PCI_CFG_M_AD_LOW1            BIT9
#define V3_PCI_CFG_M_AD_LOW0            BIT8

/*  PCI_BASE register bits (PCI -> Local Bus)
 */
#define V3_PCI_BASE_M_ADR_BASE          0xFFF00000
#define V3_PCI_BASE_M_ADR_BASEL         0x000FFF00
#define V3_PCI_BASE_M_PREFETCH          BIT3
#define V3_PCI_BASE_M_TYPE              BIT2+BIT1
#define V3_PCI_BASE_M_IO                BIT0

/*  PCI MAP register bits (PCI -> Local bus)
 */
#define V3_PCI_MAP_M_MAP_ADR            0xFFF00000
#define V3_PCI_MAP_M_RD_POST_INH        BIT15
#define V3_PCI_MAP_M_ROM_SIZE           BIT11+BIT10
#define V3_PCI_MAP_M_SWAP               BIT9+BIT8
#define V3_PCI_MAP_M_ADR_SIZE           0x000000F0
#define V3_PCI_MAP_M_REG_EN             BIT1	
#define V3_PCI_MAP_M_ENABLE             BIT0

/*  9 => 512M window size
 */
#define V3_PCI_MAP_M_ADR_SIZE_512M      0x00000090
/*  A => 1024M window size
 */
#define V3_PCI_MAP_M_ADR_SIZE_1024M     0x000000A0      

/*  LB_BASE register bits (Local bus -> PCI)
 */
#define V3_LB_BASE_M_MAP_ADR            0xFFF00000
#define V3_LB_BASE_M_SWAP               BIT9+BIT8
#define V3_LB_BASE_M_ADR_SIZE           0x000000F0
#define V3_LB_BASE_M_PREFETCH           BIT3
#define V3_LB_BASE_M_ENABLE             BIT0

/*  LB_MAP register bits (Local bus -> PCI)
 */
#define V3_LB_MAP_M_MAP_ADR             0xFFF0
#define V3_LB_MAP_M_TYPE                0x000E
#define V3_LB_MAP_M_AD_LOW_EN           BIT0

/* -------------------------------------------------------------------------------
 *  Where in the memory map does PCI live?
 * -------------------------------------------------------------------------------
 *  This represents a fairly liberal usage of address space.  Even though the V3
 *  only has two windows (therefore we need to map stuff on the fly), we maintain
 *  the same addresses, even if they're not mapped.
 * 
 */
#define PCI_MEM_BASE                    0x40000000   /* 512M to xxx */
/*  unused 256M from A0000000-AFFFFFFF might be used for I2O ???
 */
#define PCI_IO_BASE                     0x60000000   /* 16M to xxx */
/*  unused (128-16)M from B1000000-B7FFFFFF
 */
#define PCI_CONFIG_BASE                 0x61000000   /* 16M to xxx */
/*  unused ((128-16)M - 64K) from XXX
 */
#define PCI_V3_BASE                     0x62000000

#define PCI_DRAMSIZE                    INTEGRATOR_SSRAM_SIZE	

/* 'export' these to UHAL */
#define UHAL_PCI_IO                     PCI_IO_BASE
#define UHAL_PCI_MEM                    PCI_MEM_BASE
#define UHAL_PCI_ALLOC_IO_BASE          0x00004000
#define UHAL_PCI_ALLOC_MEM_BASE         PCI_MEM_BASE
#define UHAL_PCI_MAX_SLOT               20
	
/* -------------------------------------------------------------------------------
 *  From AMBA UART (PL010) Block Specification (ARM-0001-CUST-DSPC-A03)
 * -------------------------------------------------------------------------------
 *  UART Register Offsets.
 *  
 */
#define AMBA_UARTDR                     0x00	 /*  Data read or written from the interface. */
#define AMBA_UARTRSR                    0x04	 /*  Receive status register (Read). */
#define AMBA_UARTECR                    0x04	 /*  Error clear register (Write). */
#define AMBA_UARTLCR_H                  0x08	 /*  Line control register, high byte. */
#define AMBA_UARTLCR_M                  0x0C	 /*  Line control register, middle byte. */
#define AMBA_UARTLCR_L                  0x10	 /*  Line control register, low byte. */
#define AMBA_UARTCR                     0x14	 /*  Control register. */
#define AMBA_UARTFR                     0x18	 /*  Flag register (Read only). */
#define AMBA_UARTIIR                    0x1C	 /*  Interrupt indentification register (Read). */
#define AMBA_UARTICR                    0x1C	 /*  Interrupt clear register (Write). */
#define AMBA_UARTILPR                   0x20	 /*  IrDA low power counter register. */

#define AMBA_UARTRSR_OE                 0x08
#define AMBA_UARTRSR_BE                 0x04
#define AMBA_UARTRSR_PE                 0x02
#define AMBA_UARTRSR_FE                 0x01

#define AMBA_UARTFR_TXFF                0x20
#define AMBA_UARTFR_RXFE                0x10
#define AMBA_UARTFR_BUSY                0x08
#define AMBA_UARTFR_TMSK                (AMBA_UARTFR_TXFF + AMBA_UARTFR_BUSY)
 
#define AMBA_UARTCR_RTIE                0x40
#define AMBA_UARTCR_TIE                 0x20
#define AMBA_UARTCR_RIE                 0x10
#define AMBA_UARTCR_MSIE                0x08
#define AMBA_UARTCR_IIRLP               0x04
#define AMBA_UARTCR_SIREN               0x02
#define AMBA_UARTCR_UARTEN              0x01
 
#define AMBA_UARTLCR_H_WLEN_8           0x60
#define AMBA_UARTLCR_H_WLEN_7           0x40
#define AMBA_UARTLCR_H_WLEN_6           0x20
#define AMBA_UARTLCR_H_WLEN_5           0x00
#define AMBA_UARTLCR_H_FEN              0x10
#define AMBA_UARTLCR_H_STP2             0x08
#define AMBA_UARTLCR_H_EPS              0x04
#define AMBA_UARTLCR_H_PEN              0x02
#define AMBA_UARTLCR_H_BRK              0x01

#define AMBA_UARTIIR_RTIS               0x08
#define AMBA_UARTIIR_TIS                0x04
#define AMBA_UARTIIR_RIS                0x02
#define AMBA_UARTIIR_MIS                0x01

#define ARM_BAUD_460800                 1
#define ARM_BAUD_230400                 3
#define ARM_BAUD_115200                 7
#define ARM_BAUD_57600                  15
#define ARM_BAUD_38400                  23
#define ARM_BAUD_19200                  47
#define ARM_BAUD_14400                  63
#define ARM_BAUD_9600                   95
#define ARM_BAUD_4800                   191
#define ARM_BAUD_2400                   383
#define ARM_BAUD_1200                   767

/* ===============================================================================
 *  Start of uHAL definitions
 * ===============================================================================
 */

/* -------------------------------------------------------------------------------
 *  Integrator Interrupt Controllers
 * -------------------------------------------------------------------------------
 * 
 *  Offsets from interrupt controller base 
 * 
 *  System Controller interrupt controller base is
 * 
 * 	INTEGRATOR_IC_BASE + (header_number << 6)
 * 
 *  Core Module interrupt controller base is
 * 
 * 	INTEGRATOR_HDR_IC 
 * 
 */
#define IRQ_STATUS                      0
#define IRQ_RAW_STATUS                  0x04
#define IRQ_ENABLE                      0x08
#define IRQ_ENABLE_SET                  0x08
#define IRQ_ENABLE_CLEAR                0x0C
#define IRQ_SOFT_SET                    0x10
#define IRQ_SOFT_CLEAR                  0x14

#define FIQ_STATUS                      0x20
#define FIQ_RAW_STATUS                  0x24
#define FIQ_ENABLE                      0x28
#define FIQ_ENABLE_SET                  0x28
#define FIQ_ENABLE_CLEAR                0x2C


/* -------------------------------------------------------------------------------
 *  Interrupts
 * -------------------------------------------------------------------------------
 * 
 *  
 *  Each Core Module has two interrupts controllers, one on the core module itself
 *  and one in the system controller on the motherboard.  The READ_INT macro in target.s
 *  reads both interrupt controllers and returns a 32 bit bitmask, bits 0 to 23 are
 *  interrupts from the system controller and bits 24 to 31 are from the core module.
 *  
 *  The following definitions relate to the bitmask returned by READ_INT.
 * 
 */

/* 
 *  As the interrupt bit definitions for FIQ/IRQ there is a common
 *  set of definitions prefixed INT/INTMASK.  The FIQ/IRQ definitions
 *  have been left to maintain backwards compatible.
 * 
 */

/* 
 *  Interrupt numbers
 * 
 */
#define INT_SOFTINT                     0
#define INT_UARTINT0                    1
#define INT_UARTINT1                    2
#define INT_KMIINT0                     3
#define INT_KMIINT1                     4
#define INT_TIMERINT0                   5
#define INT_TIMERINT1                   6
#define INT_TIMERINT2                   7
#define INT_RTCINT                      8
#define INT_EXPINT0                     9
#define INT_EXPINT1                     10
#define INT_EXPINT2                     11
#define INT_EXPINT3                     12
#define INT_PCIINT0                     13
#define INT_PCIINT1                     14
#define INT_PCIINT2                     15
#define INT_PCIINT3                     16
#define INT_V3INT                       17
#define INT_CPINT0                      18
#define INT_CPINT1                      19
#define INT_LBUSTIMEOUT                 20
#define INT_APCINT                      21
#define INT_CM_SOFTINT                  24
#define INT_CM_COMMRX                   25
#define INT_CM_COMMTX                   26

/* 
 *  Interrupt bit positions
 * 
 */
#define INTMASK_SOFTINT                 (1 << INT_SOFTINT)
#define INTMASK_UARTINT0                (1 << INT_UARTINT0)
#define INTMASK_UARTINT1                (1 << INT_UARTINT1)
#define INTMASK_KMIINT0                 (1 << INT_KMIINT0)
#define INTMASK_KMIINT1                 (1 << INT_KMIINT1)
#define INTMASK_TIMERINT0               (1 << INT_TIMERINT0)
#define INTMASK_TIMERINT1               (1 << INT_TIMERINT1)
#define INTMASK_TIMERINT2               (1 << INT_TIMERINT2)
#define INTMASK_RTCINT                  (1 << INT_RTCINT)
#define INTMASK_EXPINT0                 (1 << INT_EXPINT0)
#define INTMASK_EXPINT1                 (1 << INT_EXPINT1)
#define INTMASK_EXPINT2                 (1 << INT_EXPINT2)
#define INTMASK_EXPINT3                 (1 << INT_EXPINT3)
#define INTMASK_PCIINT0                 (1 << INT_PCIINT0)
#define INTMASK_PCIINT1                 (1 << INT_PCIINT1)
#define INTMASK_PCIINT2                 (1 << INT_PCIINT2)
#define INTMASK_PCIINT3                 (1 << INT_PCIINT3)
#define INTMASK_V3INT                   (1 << INT_V3INT)
#define INTMASK_CPINT0                  (1 << INT_CPINT0)
#define INTMASK_CPINT1                  (1 << INT_CPINT1)
#define INTMASK_LBUSTIMEOUT             (1 << INT_LBUSTIMEOUT)
#define INTMASK_APCINT                  (1 << INT_APCINT)
#define INTMASK_CM_SOFTINT              (1 << INT_CM_SOFTINT)
#define INTMASK_CM_COMMRX               (1 << INT_CM_COMMRX)
#define INTMASK_CM_COMMTX               (1 << INT_CM_COMMTX)

/* 
 *  IRQ interrupts definitions are the same the INT definitions.
 * 
 */
#define IRQ_SOFTINT                     INT_SOFTINT
#define IRQ_UARTINT0                    INT_UARTINT0
#define IRQ_UARTINT1                    INT_UARTINT1
#define IRQ_KMIINT0                     INT_KMIINT0
#define IRQ_KMIINT1                     INT_KMIINT1
#define IRQ_TIMERINT0                   INT_TIMERINT0
#define IRQ_TIMERINT1                   INT_TIMERINT1
#define IRQ_TIMERINT2                   INT_TIMERINT2
#define IRQ_RTCINT                      INT_RTCINT
#define IRQ_EXPINT0                     INT_EXPINT0
#define IRQ_EXPINT1                     INT_EXPINT1
#define IRQ_EXPINT2                     INT_EXPINT2
#define IRQ_EXPINT3                     INT_EXPINT3
#define IRQ_PCIINT0                     INT_PCIINT0
#define IRQ_PCIINT1                     INT_PCIINT1
#define IRQ_PCIINT2                     INT_PCIINT2
#define IRQ_PCIINT3                     INT_PCIINT3
#define IRQ_V3INT                       INT_V3INT
#define IRQ_CPINT0                      INT_CPINT0
#define IRQ_CPINT1                      INT_CPINT1
#define IRQ_LBUSTIMEOUT                 INT_LBUSTIMEOUT
#define IRQ_APCINT                      INT_APCINT

#define IRQMASK_SOFTINT                 INTMASK_SOFTINT
#define IRQMASK_UARTINT0                INTMASK_UARTINT0
#define IRQMASK_UARTINT1                INTMASK_UARTINT1
#define IRQMASK_KMIINT0                 INTMASK_KMIINT0
#define IRQMASK_KMIINT1                 INTMASK_KMIINT1
#define IRQMASK_TIMERINT0               INTMASK_TIMERINT0
#define IRQMASK_TIMERINT1               INTMASK_TIMERINT1
#define IRQMASK_TIMERINT2               INTMASK_TIMERINT2
#define IRQMASK_RTCINT                  INTMASK_RTCINT
#define IRQMASK_EXPINT0                 INTMASK_EXPINT0
#define IRQMASK_EXPINT1                 INTMASK_EXPINT1
#define IRQMASK_EXPINT2                 INTMASK_EXPINT2
#define IRQMASK_EXPINT3                 INTMASK_EXPINT3
#define IRQMASK_PCIINT0                 INTMASK_PCIINT0
#define IRQMASK_PCIINT1                 INTMASK_PCIINT1
#define IRQMASK_PCIINT2                 INTMASK_PCIINT2
#define IRQMASK_PCIINT3                 INTMASK_PCIINT3
#define IRQMASK_V3INT                   INTMASK_V3INT
#define IRQMASK_CPINT0                  INTMASK_CPINT0
#define IRQMASK_CPINT1                  INTMASK_CPINT1
#define IRQMASK_LBUSTIMEOUT             INTMASK_LBUSTIMEOUT
#define IRQMASK_APCINT                  INTMASK_APCINT

/* 
 *  FIQ interrupts definitions are the same the INT definitions.
 * 
 */
#define FIQ_SOFTINT                     INT_SOFTINT
#define FIQ_UARTINT0                    INT_UARTINT0
#define FIQ_UARTINT1                    INT_UARTINT1
#define FIQ_KMIINT0                     INT_KMIINT0
#define FIQ_KMIINT1                     INT_KMIINT1
#define FIQ_TIMERINT0                   INT_TIMERINT0
#define FIQ_TIMERINT1                   INT_TIMERINT1
#define FIQ_TIMERINT2                   INT_TIMERINT2
#define FIQ_RTCINT                      INT_RTCINT
#define FIQ_EXPINT0                     INT_EXPINT0
#define FIQ_EXPINT1                     INT_EXPINT1
#define FIQ_EXPINT2                     INT_EXPINT2
#define FIQ_EXPINT3                     INT_EXPINT3
#define FIQ_PCIINT0                     INT_PCIINT0
#define FIQ_PCIINT1                     INT_PCIINT1
#define FIQ_PCIINT2                     INT_PCIINT2
#define FIQ_PCIINT3                     INT_PCIINT3
#define FIQ_V3INT                       INT_V3INT
#define FIQ_CPINT0                      INT_CPINT0
#define FIQ_CPINT1                      INT_CPINT1
#define FIQ_LBUSTIMEOUT                 INT_LBUSTIMEOUT
#define FIQ_APCINT                      INT_APCINT

#define FIQMASK_SOFTINT                 INTMASK_SOFTINT
#define FIQMASK_UARTINT0                INTMASK_UARTINT0
#define FIQMASK_UARTINT1                INTMASK_UARTINT1
#define FIQMASK_KMIINT0                 INTMASK_KMIINT0
#define FIQMASK_KMIINT1                 INTMASK_KMIINT1
#define FIQMASK_TIMERINT0               INTMASK_TIMERINT0
#define FIQMASK_TIMERINT1               INTMASK_TIMERINT1
#define FIQMASK_TIMERINT2               INTMASK_TIMERINT2
#define FIQMASK_RTCINT                  INTMASK_RTCINT
#define FIQMASK_EXPINT0                 INTMASK_EXPINT0
#define FIQMASK_EXPINT1                 INTMASK_EXPINT1
#define FIQMASK_EXPINT2                 INTMASK_EXPINT2
#define FIQMASK_EXPINT3                 INTMASK_EXPINT3
#define FIQMASK_PCIINT0                 INTMASK_PCIINT0
#define FIQMASK_PCIINT1                 INTMASK_PCIINT1
#define FIQMASK_PCIINT2                 INTMASK_PCIINT2
#define FIQMASK_PCIINT3                 INTMASK_PCIINT3
#define FIQMASK_V3INT                   INTMASK_V3INT
#define FIQMASK_CPINT0                  INTMASK_CPINT0
#define FIQMASK_CPINT1                  INTMASK_CPINT1
#define FIQMASK_LBUSTIMEOUT             INTMASK_LBUSTIMEOUT
#define FIQMASK_APCINT                  INTMASK_APCINT


/* 
 *  Misc. interrupt definitions
 * 
 */
#define IRQ_KEYBDINT                    INT_KMIINT0
#define IRQ_MOUSEINT                    INT_KMIINT1

#define IRQMASK_KEYBDINT                INTMASK_KMIINT0
#define IRQMASK_MOUSEINT                INTMASK_KMIINT1

/* 
 *  INTEGRATOR_CM_INT0      - Interrupt number of first CM interrupt
 *  INTEGRATOR_SC_VALID_INT - Mask of valid system controller interrupts
 * 
 */
#define INTEGRATOR_CM_INT0              INT_CM_SOFTINT
#define INTEGRATOR_SC_VALID_INT         0x003FFFFF

#define MAXIRQNUM                       31
#define MAXFIQNUM                       31
#define MAXSWINUM                       31
 
#define NR_IRQS                         (MAXIRQNUM + 1)

/* -------------------------------------------------------------------------------
 *  LED's - The header LED is not accessable via the uHAL API
 * -------------------------------------------------------------------------------
 * 
 */
#define uHAL_LED_ON                     1
#define uHAL_LED_OFF                    0
#define uHAL_NUM_OF_LEDS                4

#define GREEN_LED                       0x01
#define YELLOW_LED                      0x02
#define RED_LED                         0x04
#define GREEN_LED_2                     0x08
#define ALL_LEDS                        0x0F

#define LED_BANK                        INTEGRATOR_DBG_LEDS

#define uHAL_LED_MASKS	{0, GREEN_LED, YELLOW_LED, RED_LED, GREEN_LED_2}
#define uHAL_LED_OFFSETS	{0, (void *)LED_BANK, (void *)LED_BANK, (void *)LED_BANK, (void *)LED_BANK}


/* 
 *  Memory definitions - run uHAL out of SSRAM.
 * 
 */
#define uHAL_MEMORY_SIZE                INTEGRATOR_SSRAM_SIZE

/* 
 *  Application Flash
 * 
 */
#define FLASH_BASE                      INTEGRATOR_FLASH_BASE
#define FLASH_SIZE                      INTEGRATOR_FLASH_SIZE
#define FLASH_END                       (FLASH_BASE + FLASH_SIZE - 1)
#define FLASH_BLOCK_SIZE                SZ_128K

/* 
 *  Boot Flash
 * 
 */
#define EPROM_BASE                      INTEGRATOR_BOOT_ROM_HI
#define EPROM_SIZE                      INTEGRATOR_BOOT_ROM_SIZE
#define EPROM_END                       (EPROM_BASE + EPROM_SIZE - 1)

/* 
 *  Clean base - dummy
 * 
 */
#define CLEAN_BASE                      EPROM_BASE

/* 
 *  UART definitions
 * 
 */

/* 
 *  Which com port can the OS use?
 * 
 */
/* Default port to talk to host (via debugger) */
#define HOST_COMPORT                    INTEGRATOR_UART0_BASE
#define HOST_IRQBIT_NUMBER              INT_UARTINT0
#define HOST_IRQBIT_MASK                INTMASK_UARTINT0
#define HOST_IRQBIT                     HOST_IRQBIT_MASK

/* Default port for use by Operating System or program */
#define OS_COMPORT                      INTEGRATOR_UART0_BASE
#define OS_IRQBIT_NUMBER                INT_UARTINT0
#define OS_IRQBIT_MASK                  INTMASK_UARTINT0
#define OS_IRQBIT                       OS_IRQBIT_MASK

#define DEBUG_COMPORT                   OS_COMPORT
#define DEBUG_IRQBIT                    OS_IRQBIT

/* Values to set given baud rates */
#define DEFAULT_HOST_BAUD               ARM_BAUD_9600
#define DEFAULT_OS_BAUD                 ARM_BAUD_38400

#define GET_STATUS(p)		(IO_READ((p) + AMBA_UARTFR) & 0xFF)
#define GET_CHAR(p)		(IO_READ((p) + AMBA_UARTDR))
#define PUT_CHAR(p, c)		(IO_WRITE(((p) + AMBA_UARTDR), (c)))
#define IO_READ(p)             (*(volatile unsigned char *)(p))
#define IO_WRITE(p, c)         (*(unsigned char *)(p) = (unsigned char)(c))
#define RX_DATA(s)		(((s) & AMBA_UARTFR_RXFE) == 0)
#define TX_READY(s)		(((s) & AMBA_UARTFR_TXFF) == 0)
#define TX_EMPTY(p)		((GET_STATUS(p) & AMBA_UARTFR_TMSK) == 0)

/* 
 *  Timer definitions
 * 
 *  Only use timer 1 & 2
 *  (both run at 24MHz and will need the clock divider set to 16).
 * 
 *  Timer 0 runs at bus frequency and therefore could vary and currently
 *  uHAL can't handle that.
 * 
 */

#define INTEGRATOR_TIMER0_BASE          INTEGRATOR_CT_BASE
#define INTEGRATOR_TIMER1_BASE          (INTEGRATOR_CT_BASE + 0x100)
#define INTEGRATOR_TIMER2_BASE          (INTEGRATOR_CT_BASE + 0x200)

#define MAX_TIMER                       2
#define MAX_PERIOD                      699050
#define TICKS_PER_uSEC                  24

/* Interrupt Flags */
#define SEMIHOSTED_INTS                 0


/* 
 *  These are useconds NOT ticks.  
 * 
 */
#define mSEC_1                          1000
#define mSEC_5                          (mSEC_1 * 5)
#define mSEC_10                         (mSEC_1 * 10)
#define mSEC_25                         (mSEC_1 * 25)
#define SEC_1                           (mSEC_1 * 1000)

#define OS_TIMER                        1
#define OS_TIMERINT                     INT_TIMERINT1
#define HOST_TIMER                      MAX_TIMER


/*  Timer definitions.		
 *  The irq numbers of the individual timers
 */
#define TIMER_VECTORS	{ 0, INT_TIMERINT1, INT_TIMERINT2}
/*  
 */

/*  Number of Level2 table entries in uHAL_AddressTable
 */
#define L2_TABLE_ENTRIES                1


/* macros to map from PCI memory/IO addresses to local bus addresses
 */
#define _MapAddress(a)		(a)
#define _MapIOAddress(a)	((U32)UHAL_PCI_IO + (U32)(a))
#define _MapMemAddress(a)	(a)


#define ALLBITS                         0xffffffff


#define INTEGRATOR_CSR_BASE             0x10000000
#define INTEGRATOR_CSR_SIZE             0x10000000


/*  Purely for compatability with SEMIHOSTED (defined in uart.h in uHAL):
 */
#define InterruptId                     2
/*  Purely for compatability with uHAL (defined in superio_h.s in SEMIHOSTED):
 */
#define EnableInt                       0x04
#define CntlModem                       0x10

#ifdef uHAL_HEAP
#if USE_C_LIBRARY != 0
#define uHAL_HEAP_BASE                  (INTEGRATOR_SSRAM_BASE + SZ_1M)
#define uHAL_HEAP_SIZE                  (SZ_32M - SZ_1M - SZ_1M - 4)
#define uHAL_STACK_BASE                 SZ_32M
#define uHAL_STACK_SIZE                 SZ_1M
#else
#define uHAL_HEAP_BASE                  (INTEGRATOR_SSRAM_BASE + INTEGRATOR_SSRAM_SIZE - SZ_64K)
#define uHAL_HEAP_SIZE                  SZ_16K
#define uHAL_STACK_SIZE                 SZ_16K
#define uHAL_STACK_BASE                 (uHAL_HEAP_BASE + SZ32K)
#endif
#endif

#endif

/* 	END */
