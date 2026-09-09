
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
// #define uHAL_PCI                        1	(CSLEE) Block PCI Code
#define	uHAL_PCI						0	// (CSLEE)
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

#ifdef	INTEGRATOR_CASE
#define INTEGRATOR_FLASH_BASE           0x24000000
#define INTEGRATOR_FLASH_SIZE           SZ_32M
#else
#define	INTEGRATOR_FLASH_BASE			0x20400000
	// (CSLEE) = FLASH_BASE, used in memmap.s
#define	INTEGRATOR_FLASH_SIZE			SZ_32M
	// (CSLEE) = FLASH_SIZE, not used
#endif

#define INTEGRATOR_MBRD_SSRAM_BASE      0x28000000
	// (CSLEE) used in memmap.s, but nothing
#define INTEGRATOR_MBRD_SSRAM_SIZE      SZ_512K
	// (CSLEE) used in memmap.s, but nothing

/* 
 *  SDRAM is a SIMM therefore the size is not known.
 * 
 */
#define INTEGRATOR_SDRAM_BASE           0x00040000
	// (CSLEE) not used

#define INTEGRATOR_SDRAM_ALIAS_BASE     0x80000000
	// (CSLEE) used in memmap.s, but nothing
#define INTEGRATOR_HDR0_SDRAM_BASE      0x80000000
	// (CSLEE) used in target.s, but no modification required
#define INTEGRATOR_HDR1_SDRAM_BASE      0x90000000
	// (CSLEE) not used
#define INTEGRATOR_HDR2_SDRAM_BASE      0xA0000000
	// (CSLEE) not used
#define INTEGRATOR_HDR3_SDRAM_BASE      0xB0000000
	// (CSLEE) not used

/* 
 *  Logic expansion modules
 * 
 */
#define INTEGRATOR_LOGIC_MODULES_BASE   0xC0000000
	// (CSLEE) used in memmap.s, but nothing
#define INTEGRATOR_LOGIC_MODULE0_BASE   0xC0000000
	// (CSLEE) not used
#define INTEGRATOR_LOGIC_MODULE1_BASE   0xD0000000
	// (CSLEE) not used
#define INTEGRATOR_LOGIC_MODULE2_BASE   0xE0000000
	// (CSLEE) not used
#define INTEGRATOR_LOGIC_MODULE3_BASE   0xF0000000
	// (CSLEE) not used

/* -------------------------------------------------------------------------------
 *  Integrator header card registers
 * -------------------------------------------------------------------------------
 * (CSLEE) The all register fields except REMAP does not exist in MOON
 * Should modify or block the code that uses these definitions
 */
#define INTEGRATOR_HDR_ID_OFFSET        0x00	// (CSLEE) not used
#define INTEGRATOR_HDR_PROC_OFFSET      0x04	// (CSLEE) target.s, just read, nothing in MOON, block code
#define INTEGRATOR_HDR_OSC_OFFSET       0x08	// (CSLEE) target.s  read and write, nothing in MOON
	// block code macro SETUP_ASYNC_CLOCKS and SETUP_DEFAULT_CLOCKS
#define INTEGRATOR_HDR_CTRL_OFFSET      0x0C	// (CSLEE) target.s, read and write, (REMAP)
	// nothing to be modified, register exists and remap field is valid
#define INTEGRATOR_HDR_STAT_OFFSET      0x10	// (CSLEE) target.s, just read, nothing in MOON
	// block code which contains INTEGRATOR_HDR_STAT_OFFSET
#define INTEGRATOR_HDR_LOCK_OFFSET      0x14	// (CSLEE) target.s, just write, nothing in MOON
	// block code which contains INTEGRATOR_HDR_LOCK_OFFSET
#define INTEGRATOR_HDR_SDRAM_OFFSET     0x20	// (CSLEE) target.s, read and write, nothing in MOON
	// block code which contains INTEGRATOR_HDR_SDRAM_OFFSET
#define INTEGRATOR_HDR_INIT_OFFSET      0x24	 /*  CM9x6 */	// (CSLEE) not used
	// not used
#define INTEGRATOR_HDR_IC_OFFSET        0x40	// (CSLEE) target.s, read and write, interrupt control
	// block code which contains INTEGRATOR_HDR_IC_OFFSET
	// MACRO GETSOURCE(not used), READ_INT, DISABLE_INTS
#define INTEGRATOR_HDR_SPDBASE_OFFSET   0x100	// (CSLEE) target.s, just read SDRAM information
	// block code which contains INTEGRATOR_HDR_SPDBASE_OFFSET
#define INTEGRATOR_HDR_SPDTOP_OFFSET    0x200	// (CSLEE) not used
	// not used

#define INTEGRATOR_HDR_BASE             0x30000000	// (CSLEE)
	// (CSLEE) target.s, read and write, used as base address
#define INTEGRATOR_HDR_ID               (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_ID_OFFSET)
	// (CSLEE) not used
#define INTEGRATOR_HDR_PROC             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_PROC_OFFSET)
	// (CSLEE) used in uHALir_ReadCPUIdFromBoard() (board.c), just reading
#define INTEGRATOR_HDR_OSC              (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_OSC_OFFSET)
	// (CSLEE) not used, only use INTEGRATOR_HDR_OSC_OFFSET
#define INTEGRATOR_HDR_CTRL             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_CTRL_OFFSET)
	// (CSLEE) not used, only use INTEGRATOR_HDR_CTRL_OFFSET
#define INTEGRATOR_HDR_STAT             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_STAT_OFFSET)
	// (CSLEE) used in uHALir_MaskIrq(), uHALir_UnmaskIrq() in board.c
#define INTEGRATOR_HDR_LOCK             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_LOCK_OFFSET)
	// (CSLEE) not used, use only INTEGRATOR_HDR_LOCK_OFFSET, should block code
#define INTEGRATOR_HDR_SDRAM            (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_SDRAM_OFFSET)
	// (CSLEE) used in target.s, should block code
#define INTEGRATOR_HDR_INIT             (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_INIT_OFFSET)
	// (CSLEE) not used
#define INTEGRATOR_HDR_IC               (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_IC_OFFSET)
	// (CSLEE) used in uHALir_MaskIrq(), uHALir_UnmaskIrq() in board.c, but not happen
#define INTEGRATOR_HDR_SPDBASE          (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_SPDBASE_OFFSET)
	// (CSLEE) used in target.s
#define INTEGRATOR_HDR_SPDTOP           (INTEGRATOR_HDR_BASE + INTEGRATOR_HDR_SPDTOP_OFFSET)
	// (CSLEE) not used

#define INTEGRATOR_HDR_CTRL_LED         0x01	// (CSLEE) block code containing this
#define INTEGRATOR_HDR_CTRL_MBRD_DETECH  0x02	// (CSLEE) not used
#define INTEGRATOR_HDR_CTRL_REMAP       0x04	// (CSLEE) no change required
#define INTEGRATOR_HDR_CTRL_RESET       0x08	// (CSLEE) not used
#define INTEGRATOR_HDR_CTRL_HIGHVECTORS  0x10	// (CSLEE) not used
#define INTEGRATOR_HDR_CTRL_BIG_ENDIAN  0x20	// (CSLEE) not used
#define INTEGRATOR_HDR_CTRL_FASTBUS     0x40	// (CSLEE) block code containing this
#define INTEGRATOR_HDR_CTRL_SYNC        0x80	// (CSLEE) not used

#define INTEGRATOR_HDR_OSC_CORE_10MHz   0x102	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_15MHz   0x107	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_20MHz   0x10C	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_25MHz   0x111	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_30MHz   0x116	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_35MHz   0x11B	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_40MHz   0x120
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but This Macro is not used
#define INTEGRATOR_HDR_OSC_CORE_45MHz   0x125	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_50MHz   0x12A
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but This Macro is not used
#define INTEGRATOR_HDR_OSC_CORE_55MHz   0x12F	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_60MHz   0x134	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_65MHz   0x139	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_70MHz   0x13E	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_75MHz   0x143	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_80MHz   0x148	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_85MHz   0x14D	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_90MHz   0x152	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_95MHz   0x157	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_100MHz  0x15C
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but This Macro is not used
#define INTEGRATOR_HDR_OSC_CORE_105MHz  0x161	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_110MHz  0x166	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_115MHz  0x16B	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_120MHz  0x170	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_125MHz  0x175	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_130MHz  0x17A	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_135MHz  0x17F	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_140MHz  0x184	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_145MHz  0x189	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_150MHz  0x18E	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_155MHz  0x193	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_160MHz  0x198	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_CORE_MASK    0x7FF	// (CSLEE) not used

#define INTEGRATOR_HDR_OSC_MEM_10MHz    0x10C000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_MEM_15MHz    0x116000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_MEM_20MHz    0x120000
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but This Macro is not used
#define INTEGRATOR_HDR_OSC_MEM_25MHz    0x12A000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_MEM_30MHz    0x134000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_MEM_33MHz    0x13A000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_MEM_40MHz    0x148000
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but This Macro is not used
#define INTEGRATOR_HDR_OSC_MEM_50MHz    0x15C000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_MEM_60MHz    0x170000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_MEM_66MHz    0x17C000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_MEM_MASK     0x7FF000	// (CSLEE) not used

#define INTEGRATOR_HDR_OSC_BUS_MODE_CM7x0  0x0			// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_BUS_MODE_CM9x0  0x0800000
	// (CSLEE) used in SETUP_ASYNC_CLOCKS but This macro is blocked
#define INTEGRATOR_HDR_OSC_BUS_MODE_CM9x6  0x1000000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_BUS_MODE_CM10x00  0x1800000	// (CSLEE) not used
#define INTEGRATOR_HDR_OSC_BUS_MODE_MASK  0x1800000
	// (CSLEE) used in SETUP_ASYNC_CLOCKS but This macro is blocked

#define INTEGRATOR_HDR_SDRAM_SPD_OK     BIT5
	// (CSLEE) block code contains definition


/* -------------------------------------------------------------------------------
 *  Integrator system registers
 * -------------------------------------------------------------------------------
 * 
 */

/* 
 *  System Controller
 * 
 */
#define INTEGRATOR_SC_ID_OFFSET         0x00	// (CSLEE) Not Used
#define INTEGRATOR_SC_OSC_OFFSET        0x04
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but This Macro is not used
#define INTEGRATOR_SC_CTRLS_OFFSET      0x08	// (CSLEE) Not Used
#define INTEGRATOR_SC_CTRLC_OFFSET      0x0C	// (CSLEE) Not Used
#define INTEGRATOR_SC_DEC_OFFSET        0x10
	// (CSLEE) used in CHECK_PRIMARY_CPU but This Macro is not used
#define INTEGRATOR_SC_ARB_OFFSET        0x14	// (CSLEE) Not Used
#define INTEGRATOR_SC_PCIENABLE_OFFSET  0x18	// (CSLEE) Not Used
#define INTEGRATOR_SC_LOCK_OFFSET       0x1C
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but This Macro is not used

#ifdef	INTEGRATOR_CASE
#define INTEGRATOR_SC_BASE              0x11000000
#else
#define	INTEGRATOR_SC_BASE				0xc0000000	// for MOON simulation
#endif

#define INTEGRATOR_SC_ID                (INTEGRATOR_SC_BASE + INTEGRATOR_SC_ID_OFFSET)	// (CSLEE) not used
#define INTEGRATOR_SC_OSC               (INTEGRATOR_SC_BASE + INTEGRATOR_SC_OSC_OFFSET)	// (CSLEE) not used
#define INTEGRATOR_SC_CTRLS             (INTEGRATOR_SC_BASE + INTEGRATOR_SC_CTRLS_OFFSET)	// (CSLEE) not used
#define INTEGRATOR_SC_CTRLC             (INTEGRATOR_SC_BASE + INTEGRATOR_SC_CTRLC_OFFSET)	// (CSLEE) not used
#define INTEGRATOR_SC_DEC               (INTEGRATOR_SC_BASE + INTEGRATOR_SC_DEC_OFFSET)
	// (CSLEE) used in CHECK_PRIMARY_CPU but This Macro is not used
#define INTEGRATOR_SC_ARB               (INTEGRATOR_SC_BASE + INTEGRATOR_SC_ARB_OFFSET)	// (CSLEE) not used
#define INTEGRATOR_SC_PCIENABLE         (INTEGRATOR_SC_BASE + INTEGRATOR_SC_PCIENABLE_OFFSET)
	// (CSLEE) used in SETUP_PCI but this macro is blocked by uHAL_PCI flag
#define INTEGRATOR_SC_LOCK              (INTEGRATOR_SC_BASE + INTEGRATOR_SC_LOCK_OFFSET)
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but this macro is not used

#define INTEGRATOR_SC_OSC_SYS_10MHz     0x20	// (CSLEE) not used
#define INTEGRATOR_SC_OSC_SYS_15MHz     0x34	// (CSLEE) not used
#define INTEGRATOR_SC_OSC_SYS_20MHz     0x48
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but this macro is not used
#define INTEGRATOR_SC_OSC_SYS_25MHz     0x5C	// (CSLEE) not used
#define INTEGRATOR_SC_OSC_SYS_33MHz     0x7C	// (CSLEE) not used
#define INTEGRATOR_SC_OSC_SYS_MASK      0xFF	// (CSLEE) not used

#define INTEGRATOR_SC_OSC_PCI_25MHz     0x100	// (CSLEE) not used
#define INTEGRATOR_SC_OSC_PCI_33MHz     0x0
	// (CSLEE) used in SETUP_DEFAULT_CLOCKS but this macro is not used
#define INTEGRATOR_SC_OSC_PCI_MASK      0x100	// (CSLEE) not used

#define INTEGRATOR_SC_CTRL_SOFTRST      (1 << 0)	// (CSLEE) not used
#define INTEGRATOR_SC_CTRL_nFLVPPEN     (1 << 1)	// (CSLEE) not used
#define INTEGRATOR_SC_CTRL_nFLWP        (1 << 2)	// (CSLEE) not used
#define INTEGRATOR_SC_CTRL_URTS0        (1 << 4)	// (CSLEE) not used
#define INTEGRATOR_SC_CTRL_UDTR0        (1 << 5)	// (CSLEE) not used
#define INTEGRATOR_SC_CTRL_URTS1        (1 << 6)	// (CSLEE) not used
#define INTEGRATOR_SC_CTRL_UDTR1        (1 << 7)	// (CSLEE) not used

/* 
 *  External Bus Interface
 * 
 */

#ifdef	INTEGRATOR_CASE
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
#else	// of INTEGRATOR_CASE
#define	INTEGRATOR_EBI_BASE				0x40000000

#define	INTEGRATOR_EBI_CSR0_OFFSET		0x00	// (CSLEE) not used
#define	INTEGRATOR_EBI_CSR1_OFFSET		0x04	// (CSLEE) not used
#define	INTEGRATOR_EBI_CSR2_OFFSET		0x08	// (CSLEE) not used
#define	INTEGTAROR_EBI_CSR3_OFFSET		0x0c	// (CSLEE) not used
#define	INTEGRATOR_EBI_LOCK_OFFSET		0x20	// (CSLEE) DOES NOT EXIST (RYOO) Modifies

#define INTEGRATOR_EBI_CSR0             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_CSR0_OFFSET)	// (CSLEE) NU
#define INTEGRATOR_EBI_CSR1             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_CSR1_OFFSET)	// (CSLEE) NU
#define INTEGRATOR_EBI_CSR2             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_CSR2_OFFSET)	// (CSLEE) NU
#define INTEGRATOR_EBI_CSR3             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_CSR3_OFFSET)	// (CSLEE) NU
#define INTEGRATOR_EBI_LOCK             (INTEGRATOR_EBI_BASE + INTEGRATOR_EBI_LOCK_OFFSET)	// (CSLEE) NU
#endif

#ifdef	INTEGRATOR_CASE
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
#else
#define	INTEGRATOR_EBI_8_BIT			0x00000000	// Not Used
#define	INTEGRATOR_EBI_16_BIT			0x01000000	// Not Used
#define	INTEGRATOR_EBI_32_BIT			0x02000000	// Not Used
#define	INTEGRATOR_EBI_WRITE_ENABLE		0x00		// Not Used
#define	INTEGRATOR_EBI_SYNC				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_2				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_3				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_4				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_5				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_6				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_7				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_8				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_9				0x00		// Not Used
#define	INTEGRATOR_EBI_WS_10			0x00		// Not Used
#define	INTEGRATOR_EBI_WS_11			0x00		// Not Used
#define	INTEGRATOR_EBI_WS_12			0x00		// Not Used
#define	INTEGRATOR_EBI_WS_13			0x00		// Not Used
#define	INTEGRATOR_EBI_WS_14			0x00		// Not Used
#define	INTEGRATOR_EBI_WS_15			0x00		// Not Used
#define	INTEGRATOR_EBI_WS_16			0x00		// Not Used
#define	INTEGRATOR_EBI_WS_17			0x00		// Not Used
#endif


#define INTEGRATOR_CT_BASE              0x33000000	 /*  Counter/Timers */
#define INTEGRATOR_IC_BASE              0x34000000	 /*  Interrupt Controller */
#define INTEGRATOR_RTC_BASE             0x35000000	 /*  Real Time Clock */
#define INTEGRATOR_UART0_BASE           0x36000000	 /*  UART 0 */
#define INTEGRATOR_UART1_BASE           0x37000000	 /*  UART 1 */
#define INTEGRATOR_KBD_BASE             0x38000000	 /*  Keyboard */
#define INTEGRATOR_MOUSE_BASE           0x39000000	 /*  Mouse */

/* 
 *  LED's & Switches
 * 
 */
#define INTEGRATOR_DBG_ALPHA_OFFSET     0x00
	// used in SET_LEDS macro, but that macro is blocked
#define INTEGRATOR_DBG_LEDS_OFFSET      0x04
	// used in SET_LEDS macro, but that macro is blocked
#define INTEGRATOR_DBG_SWITCH_OFFSET    0x08
	// used in CHECK_PRIMARY_CPU macro, but that macro is blocked

#define INTEGRATOR_DBG_BASE             0x1A000000
	// used in SET_LEDS and CHECK_PRIMARY_CPU macro, but that macro is blocked
#define INTEGRATOR_DBG_ALPHA            (INTEGRATOR_DBG_BASE + INTEGRATOR_DBG_ALPHA_OFFSET)
	// used in uHALr_WriteLED() and uHALir_SetLEDs(), the function is blocked
#define INTEGRATOR_DBG_LEDS             (INTEGRATOR_DBG_BASE + INTEGRATOR_DBG_LEDS_OFFSET)
	// redefined as LED_BANK
#define INTEGRATOR_DBG_SWITCH           (INTEGRATOR_DBG_BASE + INTEGRATOR_DBG_SWITCH_OFFSET)
	// not used


#define INTEGRATOR_GPIO_BASE            0x3B000000	 /*  GPIO */

/* -------------------------------------------------------------------------------
 *  KMI keyboard/mouse definitions
 * -------------------------------------------------------------------------------
 */
/* PS2 Keyboard interface */

#define KMI0_BASE                       INTEGRATOR_KBD_BASE			// (CSLEE) NU
#define KEYB_CR                         (INTEGRATOR_KBD_BASE)		// (CSLEE) NU
#define KEYB_STAT                       (INTEGRATOR_KBD_BASE + 0x4)	// (CSLEE) NU
#define KEYB_DATA                       (INTEGRATOR_KBD_BASE + 0x8)	// (CSLEE) NU
#define KEYB_CLK                        (INTEGRATOR_KBD_BASE + 0xC)	// (CSLEE) NU

/* PS2 Mouse interface */
#define KMI1_BASE                       INTEGRATOR_MOUSE_BASE		// (CSLEE) NU
#define MOUSE_CR                        INTEGRATOR_MOUSE_BASE		// (CSLEE) NU
#define MOUSE_STAT                      (INTEGRATOR_MOUSE_BASE+0x4)	// (CSLEE) NU
#define MOUSE_DATA                      (INTEGRATOR_MOUSE_BASE+0x8)	// (CSLEE) NU
#define MOUSE_CLK                       (INTEGRATOR_MOUSE_BASE+0xC)	// (CSLEE) NU

/* general KMI register macros */
#define KMI_CR(b)	((volatile unsigned int *)b) 			// (CSLEE) NU
#define KMI_STAT(b)    ((volatile unsigned int *)(b+0x4))	// (CSLEE) NU
#define KMI_DATA(b)    ((volatile unsigned int *)(b+0x8))	// (CSLEE) NU
#define KMI_CLK(b)     ((volatile unsigned int *)(b+0xC))	// (CSLEE) NU

/* KMI constants */
#define KMI_TXEMPTY                     0x40	// (CSLEE) NU
#define KMI_TXBUSY                      0x20	// (CSLEE) NU
#define KMI_RXFULL                      0x10	// (CSLEE) NU
#define KMI_RXBUSY                      0x08	// (CSLEE) NU
#define KMI_PARITY                      0x04	// (CSLEE) NU

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
#define V3_PCI_VENDOR                   0x00000000	// (CSLEE) NU
#define V3_PCI_DEVICE                   0x00000002	// (CSLEE) NU
#define V3_PCI_CMD                      0x00000004
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_STAT                     0x00000006	// (CSLEE) NU
#define V3_PCI_CC_REV                   0x00000008	// (CSLEE) NU
#define V3_PCI_HDR_CFG                  0x0000000C	// (CSLEE) NU
#define V3_PCI_IO_BASE                  0x00000010	// (CSLEE) NU
#define V3_PCI_BASE0                    0x00000014
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_BASE1                    0x00000018
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_SUB_VENDOR               0x0000002C	// (CSLEE) NU
#define V3_PCI_SUB_ID                   0x0000002E	// (CSLEE) NU
#define V3_PCI_ROM                      0x00000030	// (CSLEE) NU
#define V3_PCI_BPARAM                   0x0000003C	// (CSLEE) NU
#define V3_PCI_MAP0                     0x00000040
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_MAP1                     0x00000044	// (CSLEE) NU
#define V3_PCI_INT_STAT                 0x00000048	// (CSLEE) NU
#define V3_PCI_INT_CFG                  0x0000004C 	// (CSLEE) NU
#define V3_LB_BASE0                     0x00000054
	// used in ft _V3CloseConfigWindow() and _V3OpenConfigWindow()
	// The caller fts uHALr_PCICfgWriteXX and uHALr_PCICfgReadXX are not used
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_LB_BASE1                     0x00000058
	// used in ft _V3CloseConfigWindow() and _V3OpenConfigWindow()
	// The caller fts uHALr_PCICfgWriteXX and uHALr_PCICfgReadXX are not used
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_LB_MAP0                      0x0000005E
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_LB_MAP1                      0x00000062
	// used in ft uHALir_PCIMakeConfigAddress()
	// The caller fts uHALr_PCICfgWriteXX and uHALr_PCICfgReadXX are not used
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_LB_BASE2                     0x00000064
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_LB_MAP2                      0x00000066
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_LB_SIZE                      0x00000068	// (CSLEE) NU
#define V3_LB_IO_BASE                   0x0000006E
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_FIFO_CFG                     0x00000070	// (CSLEE) NU
#define V3_FIFO_PRIORITY                0x00000072	// (CSLEE) NU
#define V3_FIFO_STAT                    0x00000074	// (CSLEE) NU
#define V3_LB_ISTAT                     0x00000076	// (CSLEE) NU
#define V3_LB_IMASK                     0x00000077	// (CSLEE) NU
#define V3_SYSTEM                       0x00000078
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_LB_CFG                       0x0000007A
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_CFG                      0x0000007C
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_DMA_PCI_ADR0                 0x00000080	// (CSLEE) NU
#define V3_DMA_PCI_ADR1                 0x00000090	// (CSLEE) NU
#define V3_DMA_LOCAL_ADR0               0x00000084	// (CSLEE) NU
#define V3_DMA_LOCAL_ADR1               0x00000094	// (CSLEE) NU
#define V3_DMA_LENGTH0                  0x00000088	// (CSLEE) NU
#define V3_DMA_LENGTH1                  0x00000098	// (CSLEE) NU
#define V3_DMA_CSR0                     0x0000008B	// (CSLEE) NU
#define V3_DMA_CSR1                     0x0000009B	// (CSLEE) NU
#define V3_DMA_CTLB_ADR0                0x0000008C	// (CSLEE) NU
#define V3_DMA_CTLB_ADR1                0x0000009C	// (CSLEE) NU
#define V3_DMA_DELAY                    0x000000E0	// (CSLEE) NU
#define V3_MAIL_DATA                    0x000000C0
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_MAIL_IEWR                0x000000D0	// (CSLEE) NU
#define V3_PCI_MAIL_IERD                0x000000D2	// (CSLEE) NU
#define V3_LB_MAIL_IEWR                 0x000000D4	// (CSLEE) NU
#define V3_LB_MAIL_IERD                 0x000000D6	// (CSLEE) NU
#define V3_MAIL_WR_STAT                 0x000000D8	// (CSLEE) NU
#define V3_MAIL_RD_STAT                 0x000000DA	// (CSLEE) NU
#define V3_QBA_MAP                      0x000000DC	// (CSLEE) NU

/*  PCI COMMAND REGISTER bits
 */
#define V3_COMMAND_M_FBB_EN             BIT9	// (CSLEE) NU
#define V3_COMMAND_M_SERR_EN            BIT8	// (CSLEE) NU
#define V3_COMMAND_M_PAR_EN             BIT6	// (CSLEE) NU
#define V3_COMMAND_M_MASTER_EN          BIT2	// (CSLEE) NU
#define V3_COMMAND_M_MEM_EN             BIT1
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_COMMAND_M_IO_EN              BIT0
	// used in macro SETUP_PCI, but this macro is blocked

/*  SYSTEM REGISTER bits
 */
#define V3_SYSTEM_M_RST_OUT             BIT15
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_SYSTEM_M_LOCK                BIT14
	// used in macro SETUP_PCI, but this macro is blocked

/*  PCI_CFG bits
 */
#define V3_PCI_CFG_M_RETRY_EN           BIT10
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_CFG_M_AD_LOW1            BIT9
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_CFG_M_AD_LOW0            BIT8
	// used in macro SETUP_PCI, but this macro is blocked

/*  PCI_BASE register bits (PCI -> Local Bus)
 */
#define V3_PCI_BASE_M_ADR_BASE          0xFFF00000	// (CSLEE) NU
#define V3_PCI_BASE_M_ADR_BASEL         0x000FFF00	// (CSLEE) NU
#define V3_PCI_BASE_M_PREFETCH          BIT3
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_BASE_M_TYPE              BIT2+BIT1	// (CSLEE) NU
#define V3_PCI_BASE_M_IO                BIT0		// (CSLEE) NU

/*  PCI MAP register bits (PCI -> Local bus)
 */
#define V3_PCI_MAP_M_MAP_ADR            0xFFF00000	// (CSLEE) NU
#define V3_PCI_MAP_M_RD_POST_INH        BIT15		// (CSLEE) NU
#define V3_PCI_MAP_M_ROM_SIZE           BIT11+BIT10	// (CSLEE) NU
#define V3_PCI_MAP_M_SWAP               BIT9+BIT8	// (CSLEE) NU
#define V3_PCI_MAP_M_ADR_SIZE           0x000000F0	// (CSLEE) NU
#define V3_PCI_MAP_M_REG_EN             BIT1
	// used in macro SETUP_PCI, but this macro is blocked
#define V3_PCI_MAP_M_ENABLE             BIT0
	// used in macro SETUP_PCI, but this macro is blocked

/*  9 => 512M window size
 */
#define V3_PCI_MAP_M_ADR_SIZE_512M      0x00000090
	// used in macro SETUP_PCI, but this macro is blocked
/*  A => 1024M window size
 */
#define V3_PCI_MAP_M_ADR_SIZE_1024M     0x000000A0
	// used in macro SETUP_PCI, but this macro is blocked   

/*  LB_BASE register bits (Local bus -> PCI)
 */
#define V3_LB_BASE_M_MAP_ADR            0xFFF00000	// (CSLEE) NU
#define V3_LB_BASE_M_SWAP               BIT9+BIT8	// (CSLEE) NU
#define V3_LB_BASE_M_ADR_SIZE           0x000000F0	// (CSLEE) NU
#define V3_LB_BASE_M_PREFETCH           BIT3		// (CSLEE) NU
#define V3_LB_BASE_M_ENABLE             BIT0
	// used in macro SETUP_PCI, but this macro is blocked
	// used in ft _V3CloseConfigWindow() and _V3OpenConfigWindow()
	// The caller fts uHALr_PCICfgWriteXX and uHALr_PCICfgReadXX are not used

/*  LB_MAP register bits (Local bus -> PCI)
 */
#define V3_LB_MAP_M_MAP_ADR             0xFFF0		// (CSLEE) NU
#define V3_LB_MAP_M_TYPE                0x000E		// (CSLEE) NU
#define V3_LB_MAP_M_AD_LOW_EN           BIT0		// (CSLEE) NU

/* -------------------------------------------------------------------------------
 *  Where in the memory map does PCI live?
 * -------------------------------------------------------------------------------
 *  This represents a fairly liberal usage of address space.  Even though the V3
 *  only has two windows (therefore we need to map stuff on the fly), we maintain
 *  the same addresses, even if they're not mapped.
 * 
 */
#define PCI_MEM_BASE                    0x40000000   /* 512M to xxx */
	// used in macro SETUP_PCI, but this macro is blocked
	// used in ft _V3CloseConfigWindow() and _V3OpenConfigWindow()
	// The caller fts uHALr_PCICfgWriteXX and uHALr_PCICfgReadXX are not use
	// used in memmap.s
/*  unused 256M from A0000000-AFFFFFFF might be used for I2O ???
 */
#define PCI_IO_BASE                     0x60000000   /* 16M to xxx */
	// used in macro SETUP_PCI, but this macro is blocked
	// used in memmap.s
/*  unused (128-16)M from B1000000-B7FFFFFF
 */
#define PCI_CONFIG_BASE                 0x61000000   /* 16M to xxx */
	// used in memmap.s
	// used in fts _V3CloseConfigWindow(), uHALr_PCICfgWriteXX, and uHALr_PCICfgReadXX
	// These functions is not used
/*  unused ((128-16)M - 64K) from XXX
 */
#define PCI_V3_BASE                     0x62000000
	// used in macros and memmap.s but is not used
	// used in macro SETUP_PCI, but this macro is blocked

#define PCI_DRAMSIZE                    INTEGRATOR_SSRAM_SIZE
	// used before macro SETUP_PCI, but this macro is blocked

/* 'export' these to UHAL */
#define UHAL_PCI_IO                     PCI_IO_BASE
	// used in macro _MapIOAddress, but this macro is blocked
#define UHAL_PCI_MEM                    PCI_MEM_BASE	// (CSLEE) NU
#define UHAL_PCI_ALLOC_IO_BASE          0x00004000		// (CSLEE) NU
#define UHAL_PCI_ALLOC_MEM_BASE         PCI_MEM_BASE	// (CSLEE) NU
#define UHAL_PCI_MAX_SLOT               20				// (CSLEE) NU
	
/* -------------------------------------------------------------------------------
 *  From AMBA UART (PL010) Block Specification (ARM-0001-CUST-DSPC-A03)
 * -------------------------------------------------------------------------------
 *  UART Register Offsets.
 *  
 */
#ifdef	INTEGRATOR_CASE
#define AMBA_UARTDR                     0x00	/*  Data read or written from the interface. 	*/
#define AMBA_UARTRSR                    0x04	/*  Receive status register (Read). 			*/
#define AMBA_UARTECR                    0x04	/*  Error clear register (Write). 				*/
#define AMBA_UARTLCR_H                  0x08	/*  Line control register, high byte. 			*/
#define AMBA_UARTLCR_M                  0x0C	/*  Line control register, middle byte. 		*/
#define AMBA_UARTLCR_L                  0x10	/*  Line control register, low byte. 			*/
#define AMBA_UARTCR                     0x14	/*  Control register. 							*/
#define AMBA_UARTFR                     0x18	/*  Flag register (Read only). 					*/
#define AMBA_UARTIIR                    0x1C	/*  Interrupt indentification register (Read). 	*/
#define AMBA_UARTICR                    0x1C	/*  Interrupt clear register (Write). 			*/
#define AMBA_UARTILPR                   0x20	/*  IrDA low power counter register. 			*/
#else
#define	AMBA_UARTDR						0x00	/*  MOON UART Data Register					*/
	// used in MACRO GET_CHAR() and PUT_CHAR()
#define	AMBA_UARTRSR					0x10	/*  MOON UART Line Status Register			*/
	// not used
#define	AMBA_UARTECR					0x10	/*  MOON UART Error Clear Register			*/
	// not used
#define	AMBA_UARTLCR_H					0x0C	/*  MOON UART Line Control Register			*/
	// modify code(uHALir_InitSerial) accessing this register, register definition is changed
#define	AMBA_UARTLCR_M					0x09	/*  MOON UART Baud Rate Register				*/
	// modify code(uHALir_InitSerial) accessing this register, parameter definition is changed
#define	AMBA_UARTLCR_L					0x08	/*  MOON UART Baud Rate Register				*/
	// modify code(uHALir_InitSerial) accessing this register, parameter definition is changed
#define	AMBA_UARTCR						0x18	/*  MOON UART Interrupt Enable Register		*/
	// used in macro DISABLE_INT and ft uHALir_InitSerial, definition changed
#define	AMBA_UARTFR						0x10	/*  MOON UART Line Status Register			*/
	// used in macro GET_STATUS, field position changed
#define	AMBA_UARTIIR					0x14	/*  MOON UART Interrupt Status Register		*/
	// not used, use polling mode
#define	AMBA_UARTICR					0x1C	/*  MOON UART Interrupt Clear Register		*/
	// not used, use polling mode
#define	AMBA_UARTILPR					0x24	/*  MOON UART IrDA Low Power Count			*/
	// not used
#define	AMBA_UARTCFG					0x04	/*  MOON UART Configuration Register			*/
	// newly added
#define	AMBA_UARTBAUDF					0x28	/*  MOON UART Baud Rate Fration Register		*/
	// newly added
#endif

#ifndef	INTEGRATOR_CASE					// of AMBA_UARTRSR
#define AMBA_UARTRSR_OE                 0x08	/* AMBA_UARTRSR Bit3	*/	// not used
#define AMBA_UARTRSR_BE                 0x04	/* AMBA_UARTRSR Bit2	*/	// not used
#define AMBA_UARTRSR_PE                 0x02	/* AMBA_UARTRSR	Bit1	*/	// not used
#define AMBA_UARTRSR_FE                 0x01	/* AMBA_UARTRSR	Bit0	*/	// not used
#endif

#ifdef	INTEGRATOR_CASE					// of AMBA_UARTFR
#define AMBA_UARTFR_TXFF                0x20
#define AMBA_UARTFR_RXFE                0x10
#define AMBA_UARTFR_BUSY                0x08
#define AMBA_UARTFR_TMSK                (AMBA_UARTFR_TXFF + AMBA_UARTFR_BUSY)
#else
#define AMBA_UARTFR_TXFF                0x0020	// used in macro TX_READY
#define AMBA_UARTFR_RXFE                0x0010	// used in macro RX_DATA
#define AMBA_UARTFR_BUSY                0x0100	// used in definition AMBA_UARTFR_TMSK
#define AMBA_UARTFR_TMSK                (AMBA_UARTFR_TXFF + AMBA_UARTFR_BUSY)	// used in macro TX_EMPTY
#endif

#ifdef	INTEGRATOR_CASE		// of AMBA_UARTCR
#define AMBA_UARTCR_RTIE                0x40
#define AMBA_UARTCR_TIE                 0x20
#define AMBA_UARTCR_RIE                 0x10
#define AMBA_UARTCR_MSIE                0x08
#define AMBA_UARTCR_IIRLP               0x04
#define AMBA_UARTCR_SIREN               0x02
#define AMBA_UARTCR_UARTEN              0x01
#else
#define	AMBA_UARTCR_RTIE				0x04	// not used, use polling mode
#define	AMBA_UARTCR_TIE					0x02	// not used, use polling mode
#define	AMBA_UARTCR_RIE					0x01	// not used, use polling mode
#define	AMBA_UARTCR_MSIE				0x0780	// not used, use polling mode
#define	AMBA_UARTCR_IIRLP				0x00	// not used, use polling mode
#define	AMBA_UARTCR_SIREN				0x00	// not used, use polling mode
#define	AMBA_UARTCR_UARTEN				0x01	// (moved to AMBA_UARTCFG)
#endif

#ifdef	INTEGRATOR_CASE		// of AMBA_UARTLCR_H
#define AMBA_UARTLCR_H_WLEN_8           0x60
#define AMBA_UARTLCR_H_WLEN_7           0x40
#define AMBA_UARTLCR_H_WLEN_6           0x20
#define AMBA_UARTLCR_H_WLEN_5           0x00
#define AMBA_UARTLCR_H_FEN              0x10
#define AMBA_UARTLCR_H_STP2             0x08
#define AMBA_UARTLCR_H_EPS              0x04
#define AMBA_UARTLCR_H_PEN              0x02
#define AMBA_UARTLCR_H_BRK              0x01
#else	// of INTEGRATOR_CASE
#define AMBA_UARTLCR_H_WLEN_8           0x03	// used in uHALir_InitSerial(), definition changed
#define AMBA_UARTLCR_H_WLEN_7           0x02	// not used
#define AMBA_UARTLCR_H_WLEN_6           0x01	// not used
#define AMBA_UARTLCR_H_WLEN_5           0x00	// not used
#define AMBA_UARTLCR_H_FEN              0x00	// MOON FIFO Enable (changed to AMBA_UARTCFG_FEN)
#define AMBA_UARTLCR_H_STP2             0x04	// not used, MOON UART Stop Bit Length
#define AMBA_UARTLCR_H_EPS              0x10	// not used, MOON UART Even Parity
#define AMBA_UARTLCR_H_PEN              0x08	// not used, MOON UART Parity Enable
#define AMBA_UARTLCR_H_BRK              0x40	// not used, MOON UART Break
#endif

#ifndef	INTEGRATOR_CASE		// of AMBA_UARTCFG
#define	AMBA_UARTCFG_FEN				0x04	// (CSLEE) replace AMBA_UARTLCR_H_FEN
#define	AMBA_UARTCFG_LPBK				0x02	// (CSLEE) Add New Definition
#define	AMBA_UARTCFG_ENB				0x01	// (CSLEE) Add New Definition
#define	AMBA_UARTCFG_TENB				0x100	// (CSLEE) Add New Definition
#define	AMBA_UARTCFG_RENB				0x200	// (CSLEE) Add New Definition
#endif

#ifdef	INTEGRATOR_CASE
#define AMBA_UARTIIR_RTIS               0x08
#define AMBA_UARTIIR_TIS                0x04
#define AMBA_UARTIIR_RIS                0x02
#define AMBA_UARTIIR_MIS                0x01
#else	// of INTEGRATOR_CASE
#define	AMBA_UARTIIR_RTIS				0x04	// not used, use polling mode
#define	AMBA_UARTIIR_TIS				0x02	// not used, use polling mode
#define	AMBA_UARTIIR_RIS				0x01	// not used, use polling mode
#define	AMBA_UARTIIR_MIS				0x780	// not used, use polling mode
#endif

#define ARM_BAUD_460800                 1		// not used
#define ARM_BAUD_230400                 3		// not used
#define ARM_BAUD_115200                 7		// not used
#define ARM_BAUD_57600                  15		// not used
#define ARM_BAUD_38400                  23		// not used (DEFAULT_OS_BAUD is redefined)
#define ARM_BAUD_19200                  47		// not used
#define ARM_BAUD_14400                  63		// not used
#define ARM_BAUD_9600                   95		// not used
#define ARM_BAUD_4800                   191		// not used
#define ARM_BAUD_2400                   383		// not used
#define ARM_BAUD_1200                   767		// not used

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
#define IRQ_STATUS                      0		// used in macro GET_SOURCE and READ_INT
#define IRQ_RAW_STATUS                  0x04	// not used
#define IRQ_ENABLE                      0x08	// not used
#define IRQ_ENABLE_SET                  0x08	// used in uHALir_UnmaskIrq()
#define IRQ_ENABLE_CLEAR                0x0C	// used in uHALir_MaskIrq() and macro DISABLE_INTs
#define IRQ_SOFT_SET                    0x10	// not used
#ifdef	INTEGRATOR_CASE
#define IRQ_SOFT_CLEAR                  0x14
#else
#define	IRQ_SOFT_CLEAR					0x800010	/* MOON Simulation Model	*/	// not used
#endif

#ifdef	INTEGRATOR_CASE
#define FIQ_STATUS                      0x20
#define FIQ_RAW_STATUS                  0x24
#define FIQ_ENABLE                      0x28
#define FIQ_ENABLE_SET                  0x28
#define FIQ_ENABLE_CLEAR                0x2C
#else
#define	FIQ_STATUS						0x800000	/* MOON Simulation Model	*/
	// used in macro GET_SOURCE
#define	FIQ_RAW_STATUS					0x800004	/* MOON Simulation Model	*/
	// not used
#define	FIQ_ENABLE						0x800008	/* MOON Simulation Model	*/
	// not used in macro DISABLE_INTS
#define	FIQ_ENABLE_SET					0x800008	/* MOON Simulation Model	*/
	// not used
#define	FIQ_ENABLE_CLEAR				0x80000c	/* MOON Simulation Model	*/
#define	INTEGRATOR_IC_FIQBASE			0x34800000	/* Newly Defined			*/
	// used in macro DISABLE_INTS
#endif



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
#ifdef	INTEGRATOR_CASE
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
#else
#define	INT_UARTINT0					0	// (CSLEE) redefined as other definition
#define	INT_UARTINT1					1	// not used
#define	INT_CM_COMMTX					2	// not used
#define	INT_CM_COMMRX					3	// not used
#define	INT_RTCINT						4	// not used
#define	INT_TIMERINT0					5	// not used
#define	INT_TIMERINT1					6	// redefined as OS_TIMERINT and used in TIMER_VECTORS
#define	INT_TIMERINT2					7	// used in TIMER_VECTORS
#define	INT_EXPINT0						8	// not used
#define	INT_EXPINT1						9	// not used
#define	INT_GPIOINT						10	// not used
#define INT_PCIINT0                     13	// not used
#define INT_PCIINT1                     14	// not used
#define INT_PCIINT2                     15	// not used
#define INT_PCIINT3                     16	// not used
#define	INT_CM_SOFTINT					24	// redefined as INTEGRATOR_CM_INT0
#define	INT_SOFTINT						31	// not used
#endif

/* 
 *  Interrupt bit positions
 * 
 */
#ifdef	INTEGRATOR_CASE
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
#else
#define	INTMASK_SOFTINT					(1 << INT_SOFTINT)
#define INTMASK_UARTINT0                (1 << INT_UARTINT0)
#define INTMASK_UARTINT1                (1 << INT_UARTINT1)
#define INTMASK_TIMERINT0               (1 << INT_TIMERINT0)
#define INTMASK_TIMERINT1               (1 << INT_TIMERINT1)
#define INTMASK_TIMERINT2               (1 << INT_TIMERINT2)
#define INTMASK_RTCINT                  (1 << INT_RTCINT)
#define INTMASK_EXPINT0                 (1 << INT_EXPINT0)
#define INTMASK_EXPINT1                 (1 << INT_EXPINT1)
#define INTMASK_CM_COMMRX               (1 << INT_CM_COMMRX)
#define INTMASK_CM_COMMTX               (1 << INT_CM_COMMTX)
#define	INTMASK_GPIOINT					(1 << INT_GPIOINT)
#endif

/* 
 *  IRQ interrupts definitions are the same the INT definitions.
 * 
 */
#ifdef	INTEGRATOR_CASE
#define IRQ_SOFTINT                     INT_SOFTINT		// not used
#define IRQ_UARTINT0                    INT_UARTINT0	// not used
#define IRQ_UARTINT1                    INT_UARTINT1	// not used
#define IRQ_KMIINT0                     INT_KMIINT0		// not used
#define IRQ_KMIINT1                     INT_KMIINT1		// not used
#define IRQ_TIMERINT0                   INT_TIMERINT0	// not used
#define IRQ_TIMERINT1                   INT_TIMERINT1	// not used
#define IRQ_TIMERINT2                   INT_TIMERINT2	// not used
#define IRQ_RTCINT                      INT_RTCINT		// not used
#define IRQ_EXPINT0                     INT_EXPINT0		// not used
#define IRQ_EXPINT1                     INT_EXPINT1		// not used
#define IRQ_EXPINT2                     INT_EXPINT2		// not used
#define IRQ_EXPINT3                     INT_EXPINT3		// not used
#define IRQ_PCIINT0                     INT_PCIINT0		// used in uHALir_PCIMapInterrupt()
#define IRQ_PCIINT1                     INT_PCIINT1		// used in uHALir_PCIMapInterrupt()
#define IRQ_PCIINT2                     INT_PCIINT2		// used in uHALir_PCIMapInterrupt()
#define IRQ_PCIINT3                     INT_PCIINT3		// used in uHALir_PCIMapInterrupt()
#define IRQ_V3INT                       INT_V3INT		// not used
#define IRQ_CPINT0                      INT_CPINT0		// not used
#define IRQ_CPINT1                      INT_CPINT1		// not used
#define IRQ_LBUSTIMEOUT                 INT_LBUSTIMEOUT	// not used
#define IRQ_APCINT                      INT_APCINT		// not used
#else
#define IRQ_SOFTINT                     INT_SOFTINT
#define IRQ_UARTINT0                    INT_UARTINT0
#define IRQ_UARTINT1                    INT_UARTINT1
#define IRQ_TIMERINT0                   INT_TIMERINT0
#define IRQ_TIMERINT1                   INT_TIMERINT1
#define IRQ_TIMERINT2                   INT_TIMERINT2
#define IRQ_RTCINT                      INT_RTCINT
#define IRQ_EXPINT0                     INT_EXPINT0
#define IRQ_EXPINT1                     INT_EXPINT1
#define	IRQ_GPIOINT						INT_GPIOINT
#define IRQ_PCIINT0                     INT_PCIINT0
#define IRQ_PCIINT1                     INT_PCIINT1			// 
#define IRQ_PCIINT2                     INT_PCIINT2			// 
#define IRQ_PCIINT3                     INT_PCIINT3			// 
#endif

#ifdef	INTEGRATOR_CASE
#define IRQMASK_SOFTINT                 INTMASK_SOFTINT		// not used
#define IRQMASK_UARTINT0                INTMASK_UARTINT0	// not used
#define IRQMASK_UARTINT1                INTMASK_UARTINT1	// not used
#define IRQMASK_KMIINT0                 INTMASK_KMIINT0		// not used
#define IRQMASK_KMIINT1                 INTMASK_KMIINT1		// not used
#define IRQMASK_TIMERINT0               INTMASK_TIMERINT0	// not used
#define IRQMASK_TIMERINT1               INTMASK_TIMERINT1	// not used
#define IRQMASK_TIMERINT2               INTMASK_TIMERINT2	// not used
#define IRQMASK_RTCINT                  INTMASK_RTCINT		// not used
#define IRQMASK_EXPINT0                 INTMASK_EXPINT0		// not used
#define IRQMASK_EXPINT1                 INTMASK_EXPINT1		// not used
#define IRQMASK_EXPINT2                 INTMASK_EXPINT2		// not used
#define IRQMASK_EXPINT3                 INTMASK_EXPINT3		// not used
#define IRQMASK_PCIINT0                 INTMASK_PCIINT0		// not used
#define IRQMASK_PCIINT1                 INTMASK_PCIINT1		// not used
#define IRQMASK_PCIINT2                 INTMASK_PCIINT2		// not used
#define IRQMASK_PCIINT3                 INTMASK_PCIINT3		// not used
#define IRQMASK_V3INT                   INTMASK_V3INT		// not used
#define IRQMASK_CPINT0                  INTMASK_CPINT0		// not used
#define IRQMASK_CPINT1                  INTMASK_CPINT1		// not used
#define IRQMASK_LBUSTIMEOUT             INTMASK_LBUSTIMEOUT	// not used
#define IRQMASK_APCINT                  INTMASK_APCINT		// not used
#else
#define IRQMASK_SOFTINT                 INTMASK_SOFTINT
#define IRQMASK_UARTINT0                INTMASK_UARTINT0
#define IRQMASK_UARTINT1                INTMASK_UARTINT1
#define IRQMASK_TIMERINT0               INTMASK_TIMERINT0
#define IRQMASK_TIMERINT1               INTMASK_TIMERINT1
#define IRQMASK_TIMERINT2               INTMASK_TIMERINT2
#define IRQMASK_RTCINT                  INTMASK_RTCINT
#define IRQMASK_EXPINT0                 INTMASK_EXPINT0
#define IRQMASK_EXPINT1                 INTMASK_EXPINT1
#define	IRQMASK_GPIOINT					INTMASK_GPIOINT
#endif

/* 
 *  FIQ interrupts definitions are the same the INT definitions.
 * 
 */
#ifdef	INTEGRATOR_CASE
#define FIQ_SOFTINT                     INT_SOFTINT		// not used
#define FIQ_UARTINT0                    INT_UARTINT0	// not used
#define FIQ_UARTINT1                    INT_UARTINT1	// not used
#define FIQ_KMIINT0                     INT_KMIINT0		// not used
#define FIQ_KMIINT1                     INT_KMIINT1		// not used
#define FIQ_TIMERINT0                   INT_TIMERINT0	// not used
#define FIQ_TIMERINT1                   INT_TIMERINT1	// not used
#define FIQ_TIMERINT2                   INT_TIMERINT2	// not used
#define FIQ_RTCINT                      INT_RTCINT		// not used
#define FIQ_EXPINT0                     INT_EXPINT0		// not used
#define FIQ_EXPINT1                     INT_EXPINT1		// not used
#define FIQ_EXPINT2                     INT_EXPINT2		// not used
#define FIQ_EXPINT3                     INT_EXPINT3		// not used
#define FIQ_PCIINT0                     INT_PCIINT0		// not used
#define FIQ_PCIINT1                     INT_PCIINT1		// not used
#define FIQ_PCIINT2                     INT_PCIINT2		// not used
#define FIQ_PCIINT3                     INT_PCIINT3		// not used
#define FIQ_V3INT                       INT_V3INT		// not used
#define FIQ_CPINT0                      INT_CPINT0		// not used
#define FIQ_CPINT1                      INT_CPINT1		// not used
#define FIQ_LBUSTIMEOUT                 INT_LBUSTIMEOUT	// not used
#define FIQ_APCINT                      INT_APCINT		// not used
#else
#define FIQ_SOFTINT                     INT_SOFTINT
#define FIQ_UARTINT0                    INT_UARTINT0
#define FIQ_UARTINT1                    INT_UARTINT1
#define FIQ_TIMERINT0                   INT_TIMERINT0
#define FIQ_TIMERINT1                   INT_TIMERINT1
#define FIQ_TIMERINT2                   INT_TIMERINT2
#define FIQ_RTCINT                      INT_RTCINT
#define FIQ_EXPINT0                     INT_EXPINT0
#define FIQ_EXPINT1                     INT_EXPINT1
#define	FIQ_GPIOINT						INT_GPIOINT
#endif

#ifdef	INTEGRATOR_CASE
#define FIQMASK_SOFTINT                 INTMASK_SOFTINT		// not used
#define FIQMASK_UARTINT0                INTMASK_UARTINT0	// not used
#define FIQMASK_UARTINT1                INTMASK_UARTINT1	// not used
#define FIQMASK_KMIINT0                 INTMASK_KMIINT0		// not used
#define FIQMASK_KMIINT1                 INTMASK_KMIINT1		// not used
#define FIQMASK_TIMERINT0               INTMASK_TIMERINT0	// not used
#define FIQMASK_TIMERINT1               INTMASK_TIMERINT1	// not used
#define FIQMASK_TIMERINT2               INTMASK_TIMERINT2	// not used
#define FIQMASK_RTCINT                  INTMASK_RTCINT		// not used
#define FIQMASK_EXPINT0                 INTMASK_EXPINT0		// not used
#define FIQMASK_EXPINT1                 INTMASK_EXPINT1		// not used
#define FIQMASK_EXPINT2                 INTMASK_EXPINT2		// not used
#define FIQMASK_EXPINT3                 INTMASK_EXPINT3		// not used
#define FIQMASK_PCIINT0                 INTMASK_PCIINT0		// not used
#define FIQMASK_PCIINT1                 INTMASK_PCIINT1		// not used
#define FIQMASK_PCIINT2                 INTMASK_PCIINT2		// not used
#define FIQMASK_PCIINT3                 INTMASK_PCIINT3		// not used
#define FIQMASK_V3INT                   INTMASK_V3INT		// not used
#define FIQMASK_CPINT0                  INTMASK_CPINT0		// not used
#define FIQMASK_CPINT1                  INTMASK_CPINT1		// not used
#define FIQMASK_LBUSTIMEOUT             INTMASK_LBUSTIMEOUT	// not used
#define FIQMASK_APCINT                  INTMASK_APCINT		// not used
#else
#define FIQMASK_SOFTINT                 INTMASK_SOFTINT
#define FIQMASK_UARTINT0                INTMASK_UARTINT0
#define FIQMASK_UARTINT1                INTMASK_UARTINT1
#define FIQMASK_TIMERINT0               INTMASK_TIMERINT0
#define FIQMASK_TIMERINT1               INTMASK_TIMERINT1
#define FIQMASK_TIMERINT2               INTMASK_TIMERINT2
#define FIQMASK_RTCINT                  INTMASK_RTCINT
#define FIQMASK_EXPINT0                 INTMASK_EXPINT0
#define FIQMASK_EXPINT1                 INTMASK_EXPINT1
#define	FIQMASK_GPIOINT					INTMASK_GPIOINT
#endif


/* 
 *  Misc. interrupt definitions
 * 
 */
#define IRQ_KEYBDINT                    INT_KMIINT0		// not used
#define IRQ_MOUSEINT                    INT_KMIINT1		// not used

#define IRQMASK_KEYBDINT                INTMASK_KMIINT0	// not used
#define IRQMASK_MOUSEINT                INTMASK_KMIINT1	// not used

/* 
 *  INTEGRATOR_CM_INT0      - Interrupt number of first CM interrupt
 *  INTEGRATOR_SC_VALID_INT - Mask of valid system controller interrupts
 * 
 */
#define INTEGRATOR_CM_INT0              INT_CM_SOFTINT
	// used in macro GET_SOURCE and READ_INT and ft uHALir_UnmaskIrq() and uHALir_MaskIrq()
#define INTEGRATOR_SC_VALID_INT         0x003FFFFF
	// Valid Interrupt Masking (CSLEE) FFS

#define MAXIRQNUM                       31
	// used in uHALr_InitInterrupts() and uHALir_DispatchIRQ()
#define MAXFIQNUM                       31		// not used
#define MAXSWINUM                       31		// not used
 
#define NR_IRQS                         (MAXIRQNUM + 1)

/* -------------------------------------------------------------------------------
 *  LED's - The header LED is not accessable via the uHAL API
 * -------------------------------------------------------------------------------
 * 
 */
#define uHAL_LED_ON                     1
	// used in ft uHALr_ReadLED() but this function is not used
#define uHAL_LED_OFF                    0
	// used in ft uHALr_ReadLED() but this function is not used
#define uHAL_NUM_OF_LEDS				4
	// used in led related function, but not used

#define GREEN_LED                       0x01	// block led related ft
#define YELLOW_LED                      0x02	// block led related ft
#define RED_LED                         0x04	// block led related ft
#define GREEN_LED_2                     0x08	// not used
#define ALL_LEDS                        0x0F	// not used

#define LED_BANK                        INTEGRATOR_DBG_LEDS

#define uHAL_LED_MASKS	{0, GREEN_LED, YELLOW_LED, RED_LED, GREEN_LED_2}
	// used in the definition of uHALiv_LedMasks, but not used
#define uHAL_LED_OFFSETS	{0, (void *)LED_BANK, (void *)LED_BANK, (void *)LED_BANK, (void *)LED_BANK}
	// used in the definition of uHALiv_LedHomes, but not used


/* 
 *  Memory definitions - run uHAL out of SSRAM.
 * 
 */
#define uHAL_MEMORY_SIZE                INTEGRATOR_SSRAM_SIZE
	// used before calling uHALir_InitTargetMem, but not used
	// used in macro INITMMU, but not used

/* 
 *  Application Flash
 * 
 */
#define FLASH_BASE                      INTEGRATOR_FLASH_BASE
	// (CSLEE) Used In memmap.s
#define FLASH_SIZE                      INTEGRATOR_FLASH_SIZE
	// (CSLEE) Not Used
#define FLASH_END                       (FLASH_BASE + FLASH_SIZE - 1)
	// (CSLEE) Not Used
#define FLASH_BLOCK_SIZE                SZ_128K
	// (CSLEE) Not Used

/* 
 *  Boot Flash
 * 
 */
#define EPROM_BASE                      INTEGRATOR_BOOT_ROM_HI			// Not Used
#define EPROM_SIZE                      INTEGRATOR_BOOT_ROM_SIZE		// Not Used
#define EPROM_END                       (EPROM_BASE + EPROM_SIZE - 1)	// Not Used

/* 
 *  Clean base - dummy
 * 
 */
#define CLEAN_BASE                      EPROM_BASE		// Not Used

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
	// only used when SEMIHOSTED option is used
#define HOST_IRQBIT_NUMBER              INT_UARTINT0		// Not Used
#define HOST_IRQBIT_MASK                INTMASK_UARTINT0	// Not Used
#define HOST_IRQBIT                     HOST_IRQBIT_MASK	// Not Used

/* Default port for use by Operating System or program */
#define OS_COMPORT                      INTEGRATOR_UART0_BASE	// Used(OK)
#define OS_IRQBIT_NUMBER                INT_UARTINT0			// Not Used
#define OS_IRQBIT_MASK                  INTMASK_UARTINT0		// Not Used
#define OS_IRQBIT                       OS_IRQBIT_MASK			// Not Used

#define DEBUG_COMPORT                   OS_COMPORT		// Not Used
#define DEBUG_IRQBIT                    OS_IRQBIT		// Not Used

/* Values to set given baud rates */
#define DEFAULT_HOST_BAUD               ARM_BAUD_9600
// #define DEFAULT_OS_BAUD                 ARM_BAUD_38400	// ARM_BAUD_38400 = 23
#ifdef	RYOO	// (SPEED UP FOR SIMULATION)
#define DEFAULT_OS_BAUD					0x61	// (CSLEE)	XTAL/(16*Baud)
#define	DEFAULT_OS_BAUD_F				0x3E	// (CSLEE)	(XTAL*4)/Baud
	// XTAL = UART Reference Clock = System Clock = 60MHz (RYOO)
#else
#define DEFAULT_OS_BAUD					0x01	// (CSLEE)	XTAL/(16*Baud)
#define	DEFAULT_OS_BAUD_F				0x40	// (CSLEE)	(XTAL*4)/Baud
	// XTAL = UART Reference Clock = System Clock = 60MHz (RYOO)
	// BaudRate = 3750000
#endif

#ifdef	RYOO	// (Word Access)
#define GET_STATUS(p)		(IO_READ((p) + AMBA_UARTFR) & 0xFF)
	// (CSLEE) AMBA_UARTFR : Address Changed 0x18 -> 0x10
#define GET_CHAR(p)			(IO_READ((p) + AMBA_UARTDR))
	// (CSLEE) No Change
#else
#define	GET_STATUS(p)		(IO_READ((p) + AMBA_UARTFR) & 0xFFFFFFFF)
	// (CSLEE) AMBA_UARTFR : Address Changed 0x18 -> 0x10
#define GET_CHAR(p)			(IO_READ((p) + AMBA_UARTDR) & 0xFF)
	// (CSLEE) No Change
#endif

#define PUT_CHAR(p, c)		(IO_WRITE(((p) + AMBA_UARTDR), (c)))
	// (CSLEE) No Change
	
#ifdef	RYOO		// (CSLEE) (Word Access)
#define IO_READ(p)          (*(volatile unsigned char *)(p))
#define IO_WRITE(p, c)      (*(unsigned char *)(p) = (unsigned char)(c))
#else
#define	IO_READ(p)			(*(volatile unsigned int *)(p))
#define	IO_WRITE(p, c)		(*(unsigned int *)(p) = (unsigned int)(c))
#endif

#define RX_DATA(s)			(((s) & AMBA_UARTFR_RXFE) == 0)
	// (CSLEE) No Change, Different Address But Same Bit Position
#define TX_READY(s)			(((s) & AMBA_UARTFR_TXFF) == 0)
	// (CSLEE) No Change, Different Address But Same Bit Position
#define TX_EMPTY(p)			((GET_STATUS(p) & AMBA_UARTFR_TMSK) == 0)
	// (CSLEE) No Change, Not Used

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

#define INTEGRATOR_TIMER0_BASE          INTEGRATOR_CT_BASE				// Not Used
#define INTEGRATOR_TIMER1_BASE          (INTEGRATOR_CT_BASE + 0x100)
	// used in the definition(initialization) of TimerBase[]
#define INTEGRATOR_TIMER2_BASE          (INTEGRATOR_CT_BASE + 0x200)
	// used in the definition(initialization) of TimerBase[]

#define MAX_TIMER                       2
	// used in timer function, valid value
#define MAX_PERIOD                      699050
	// used in uHALr_SetTimerInterval()
#define TICKS_PER_uSEC                  24
	// used in uHALir_PlatformEnableTimer()

/* Interrupt Flags */
#define SEMIHOSTED_INTS                 0	// Not Used


/* 
 *  These are useconds NOT ticks.  
 * 
 */
#define mSEC_1                          1000	// used in uHALr_SetTimerInterval()
#define mSEC_5                          (mSEC_1 * 5)		// not used
#define mSEC_10                         (mSEC_1 * 10)		// not used
#define mSEC_25                         (mSEC_1 * 25)		// not used
#define SEC_1                           (mSEC_1 * 1000)		// not used

#define OS_TIMER                        1
	// system timer, valid definition
#define OS_TIMERINT                     INT_TIMERINT1		// not used
#define HOST_TIMER                      MAX_TIMER
	// used in the SEMIHOSTED condition


/*  Timer definitions.		
 *  The irq numbers of the individual timers
 */
#define TIMER_VECTORS	{ 0, INT_TIMERINT1, INT_TIMERINT2}
	// used in the definition of uHALiv_TimerVectors[], valid definition
/*  
 */

/*  Number of Level2 table entries in uHAL_AddressTable
 */
#define L2_TABLE_ENTRIES                1
	// used in macro INIT_PGTABLE


/* macros to map from PCI memory/IO addresses to local bus addresses
 */
#define _MapAddress(a)		(a)
#define _MapIOAddress(a)	((U32)UHAL_PCI_IO + (U32)(a))
#define _MapMemAddress(a)	(a)


#define ALLBITS                         0xffffffff


#define INTEGRATOR_CSR_BASE             0x10000000	// used in memmap.s
#define INTEGRATOR_CSR_SIZE             0x10000000	// used in memmap.s


/*  Purely for compatability with SEMIHOSTED (defined in uart.h in uHAL):
 */
#define InterruptId                     2			// not used
/*  Purely for compatability with uHAL (defined in superio_h.s in SEMIHOSTED):
 */
#define EnableInt                       0x04		// not used
#define CntlModem                       0x10		// not used

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
