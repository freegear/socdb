/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Vic.h.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : This file contains the register offsets and other
--           definitions for the Vic.c functional test code.
--
-- --=========================================================================*/
 
/******************************************************************************/
/*** Register          Offset Size Type Function                            ***/
/*** ====================================================================== ***/
/*** VIC Registers                                                          ***/
/*** =============                                                          ***/
/*** VICIRQStatus      0x000  32   R    IRQ Status after masking            ***/
/*** VICFIQStatus      0x004  32   R    FIQ Status after masking            ***/
/*** VICRawIntr        0x008  32   R    Interrupt Status prior to           ***/
/***                                    masking                             ***/
/*** VICIntSelect      0x00C  32   R/W  Select IRQ or FIQ                   ***/
/***                                    interrupts                          ***/
/*** VICIntEnable      0x010  32   R/W  Interrupt Enable                    ***/
/*** VICIntEnClear     0x014  32   W    Interrupt Enable Clear              ***/
/*** VICSoftInt        0x018  32   R/W  To generate Software                ***/
/***                                    interrupts                          ***/
/*** VICSoftIntClear   0x01C  32   W    Software Interrupt Clear            ***/
/*** VICProtection     0x020  1    R/W  Protection Enable Register          ***/
/*** VICSwPriorityMask 0x024  16   R/W  Software Priority Mask Register     ***/
/*** VICVectPriorityDsy0x028  4    R/W  Priority for Daisy Interrupt        ***/
/*** VICVectAddr0-31   0x100- 32   R/W  Interrupt Vector Addresses          ***/
/***                   0x17C            from 0 to 31                        ***/
/*** VICVectPrity0-31  0x200- 6    R/W  Programmbale Priority Register      ***/
/***                   0x27C            from 0 to 31                        ***/
/*** VICAddress        0xF00  32   R/W  Interrupt Vector Address            ***/
/*** VICPeriphID0      0xFE0  8    R    Peripheral ID register              ***/
/***                                    Bits  7:0                           ***/
/*** VICPeriphID1      0xFE4  8    R    Peripheral ID register              ***/
/***                                    Bits 15:8                           ***/
/*** VICPeriphID2      0xFE8  8    R    Peripheral ID register              ***/
/***                                    Bits 23:16                          ***/
/*** VICPeriphID3      0xFEC  8    R    Peripheral ID register              ***/
/***                                    Bits 31:24                          ***/
/*** VICPCellID0       0xFF0  8    R    PrimeCell ID register Bits          ***/
/***                                    Bits  7:0                           ***/
/*** VICPCellID2       0xFF4  8    R    PrimeCell ID register Bits          ***/
/***                                    Bits 15:8                           ***/
/*** VICPCellID3       0xFF8  8    R    PrimeCell ID register Bits          ***/
/***                                    Bits 23:16                          ***/
/*** VICPCellID4       0xFFC  8    R    PrimeCell ID register Bits          ***/
/***                                    Bits 31:24                          ***/
/*** VICITCR           0x300  1    R/W  Integration Test Control            ***/
/***                                    Register                            ***/
/*** VICITIP1          0x304  2    R/W  To monitor and control              ***/
/***                                    nVICIRQIN and nVICFIQIN             ***/
/*** VICITIP2          0x308  32   R/W  To monitor and control              ***/
/***                                    VICVECTADDRIN                       ***/
/*** VICITOP1          0x30C  2    R    To monitor status of FIQ            ***/
/***                                    and IRQ                             ***/
/*** VICITOP2          0x310  32   R    To monitor status of                ***/
/***                                    VICVECTADDROUT                      ***/
/***                                                                        ***/
/*** VIC TrickBox Registers                                                 ***/
/*** ======================                                                 ***/
/*** Vic Mirrored Registers [offsets are from VIC Base address]             ***/
/*** ---------------------------------------------------------------------- ***/
/*** VICTrVectAddr     0xF00  32   R/W  Interrupt Vector Address            ***/
/*** VICTrIntSelect    0x00C  32   R/W  Mirrored VIC IntSelect              ***/
/*** VICTrIntEnable    0x010  32   R/W  Mirrored VIC IntEnable              ***/
/*** VICTrIntEnClear   0x014  32   W    Mirrored VIC IntEnClear             ***/
/*** VICTrSoftInt      0x018  32   R/W  Mirrored VIC SoftInt                ***/
/*** VICTrSoftIntClear 0x01C  32   W    Mirrored VIC SoftIntClear           ***/
/*** VICTrProtection   0x020  1    R/W  Mirrored VIC Protection             ***/
/*** VICTrSwPriMask    0x024  16   R/W  Mirrored VIC Software Priority Mask ***/
/*** VICTrVectPriDsy   0x028  4    R/W  Mirrored VIC Daisy Priority         ***/
/*** VICTrVectAddr     0x030  32   R/W  Mirrored VIC VectAddr               ***/
/*** VICTrVectAddr0-15 0x100- 32   R/W  Mirrored VIC VectAddr0-15           ***/
/***                   0x13C                                                ***/
/*** VICTrVectCntl0-15 0x200- 6    R/W  Mirrored VIC VectCntl0-15           ***/
/***                   0x23C                                                ***/
/***                                                                        ***/
/*** Vic Trickbox-specific Registers [offsets are from Trickbox             ***/
/***                                  Base address]                         ***/
/*** ---------------------------------------------------------------------- ***/
/*** VICTrTCR          0x050  9    R/W  Error Message Enable & Clock Off    ***/
/*** VICTrIntSource    0x054  32   R/W  Interrupt Source                    ***/
/*** VICTrStatus       0x058  2    R    FIQ and IRQ Status                  ***/       
/*** VICTrVectAddrOut  0x05C  32   R    VICVECTADDROUT Status               ***/
/*** VICTrIntIn        0x060  2    R/W  nVICFIQIN and nVICIRQIN             ***/  
/*** VICTrIntInReg     0x064  2    R/W  Register enable FIQ and IRQ         ***/
/*** VICTrVectAddrIn   0x068  32   R/W  VICVECTADDRIN Source                ***/
/*** VicTrSync         0x06C  1    R/W  Sync Enable register                ***/
/*** VicTrAckCnt       0x074  4    R/W  Acknowledge generation Count        ***/
/*** VICTrWaitStReg    0x078  32   R/W  A location accessible with          ***/
/***                                    Non-zero wait states.               ***/
/***                                    Returns 0x55555555                  ***/
/***                                    when read                           ***/
/***                                                                        ***/
/******************************************************************************/

/******************************************************************************/
/*** The VIC Peripheral ID is a 32-bit value composed of the                ***/
/*** following 4 fields:                                                    ***/
/*** Bits [11:0] -> Part Number used to identify the peripheral             ***/
/***                For the VIC this is 0x192                               ***/
/*** Bits[19:12] -> Designer ID (ARM)                                       ***/
/***                ARM is designated 0x41                                  ***/
/*** Bits[23:20] -> Peripheral Revision Number                              ***/
/***                For the VIC this is 0x00                                ***/
/*** Bits[31:24] -> Peripheral Configuration Options                        ***/
/***                For the VIC this is 0x00                                ***/
/***                                                                        ***/
/*** The 32-bits are readable via 4 separate address locations with         ***/
/*** each location returning 8 valid bits at positions [7:0]. The           ***/
/*** values returned by the 4 Peripheral ID registers are given             ***/
/*** below:                                                                 ***/
/***                                                                        ***/
/*** VICPeriphID0 = 0x90                                                    ***/
/*** VICPeriphID1 = 0x11                                                    ***/
/*** VICPeriphID2 = 0x4                                                     ***/
/*** VICPeriphID3 = 0x00                                                    ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the VIC, please refer to PL192 AMBA            ***/
/*** VIC Block Specification                                                ***/
/******************************************************************************/

/******************************************************************************/
/**************************** VIC REGISTERS ***********************************/
/******************************************************************************/

#define VIC_BASE             (0x50000000)
#define VICIRQStatus         (VIC_BASE + 0x000)
#define VICFIQStatus         (VIC_BASE + 0x004)
#define VICVectAddr          (VIC_BASE + 0xF00)
#define VICRawIntr           (VIC_BASE + 0x008)
#define VICIntSelect         (VIC_BASE + 0x00C)
#define VICIntEnable         (VIC_BASE + 0x010)
#define VICIntEnClear        (VIC_BASE + 0x014)
#define VICSoftInt           (VIC_BASE + 0x018)
#define VICSoftIntClear      (VIC_BASE + 0x01C)
#define VICProtection        (VIC_BASE + 0x020)
#define VICSWPriorityMask    (VIC_BASE + 0x024)
#define VICVectPriorityDaisy (VIC_BASE + 0x028)
#define VICVectAddr_BASE     (VIC_BASE + 0x100)
#define VICVectPriority_BASE (VIC_BASE + 0x200)
#define VICITCR              (VIC_BASE + 0x300)
#define VICITIP1             (VIC_BASE + 0x304)
#define VICITIP2             (VIC_BASE + 0x308)
#define VICITOP1             (VIC_BASE + 0x30C)
#define VICITOP2             (VIC_BASE + 0x310)
#define VICPeriphID0         (VIC_BASE + 0xFE0)
#define VICPeriphID1         (VIC_BASE + 0xFE4)
#define VICPeriphID2         (VIC_BASE + 0xFE8)
#define VICPeriphID3         (VIC_BASE + 0xFEC)
#define VICPCellID0          (VIC_BASE + 0xFF0)
#define VICPCellID1          (VIC_BASE + 0xFF4)
#define VICPCellID2          (VIC_BASE + 0xFF8)
#define VICPCellID3          (VIC_BASE + 0xFFC)

/******************************************************************************/
/************************* TRICKBOX REGISTERS *********************************/
/******************************************************************************/
 
#define VICTR_BASE       (0xA0000000)
#define VICTrWaitStReg   (VICTR_BASE + 0x038)
#define VICTrTCR         (VICTR_BASE + 0x050)
#define VICTrIntSource   (VICTR_BASE + 0x054)
#define VICTrStatus      (VICTR_BASE + 0x058)
#define VICTrVectAddrOut (VICTR_BASE + 0x05C)
#define VICTrIntIn       (VICTR_BASE + 0x060)
#define VICTrIntInReg    (VICTR_BASE + 0x064)
#define VICTrVectAddrIn  (VICTR_BASE + 0x068)
#define VICTrSync        (VICTR_BASE + 0x06C)
#define VICTrAckCnt      (VICTR_BASE + 0x074)
 
/******************************************************************************/
/**************************** DATA VALUES *************************************/
/******************************************************************************/

#define Data0            0x00000000
#define Data1            0x11111111
#define Data2            0x22222222
#define Data3            0x33333333
#define Data4            0x44444444
#define Data5            0x55555555
#define Data8            0x88888888 
#define Data9            0x99999999 
#define DataA            0xAAAAAAAA 
#define DataC            0xCCCCCCCC 
#define DataF            0xFFFFFFFF 
#define Data80           0x80808080 
#define DataD            0xDDDDDDDD 

#define NoExtInt         0x00000003 
#define LSB1             0x00000001 
#define LSB4             0x0000000F 

#define INT1             1 
#define INT2             2 
#define INT3             3 

/******************************************************************************/
/**************************** INTERRUPT COUNTS ********************************/
/******************************************************************************/
#define INT_COUNT        32 

/******************************************************************************/
/**************************** MASK VALUES *************************************/
/******************************************************************************/

#define ZERO             0x00000000
#define NoMask           0xFFFFFFFF
#define MaskAll          0x00000000
#define UnMaskFIQ        0x00000040
#define UnMaskIRQ        0x00000080
#define FIQnIRQ          0x000000C0
#define ADDRV            0x00000100
#define VICIRQACKOUT     0x00000200
#define VICITOP1_MASK    0x000003C0
#define VICITCR_MASK     0x00000003

/******************************************************************************/
/*************************** RESET VALUES *************************************/
/******************************************************************************/
 
#define RST_VICIRQStatus              0x00000000   
#define RST_VICFIQStatus              0x00000000   
#define RST_VICRawIntr                0x00000000   
#define RST_VICIntSelect              0x00000000   
#define RST_VICIntEnable              0x00000000  
#define RST_VICSoftInt                0x00000000   
#define RST_VICProtection             0x00000000    
#define RST_VICVectAddr               0x00000000   
#define RST_VICSWPriorityMask         0x0000FFFF 
#define RST_VICVectPriorityDaisy      0x0000000F 
#define RST_VICVectBankAddr           0x00000000 
#define RST_VICVectBankSWPrio         0x0000000F 
#define RST_VICITCR                   0x00000000   
#define RST_VICITIP1                  0x000000C0 
#define RST_VICITIP2                  0x00000000 
#define RST_VICITOP1                  0x00000000 
#define RST_VICITOP2                  0x00000000 
#define RST_VICPeriphID0              0x00000092
#define RST_VICPeriphID1              0x00000011
#define RST_VICPeriphID2              0x00000004
#define RST_VICPeriphID3              0x00000000
#define RST_VICPCellID0               0x0000000D
#define RST_VICPCellID1               0x000000F0
#define RST_VICPCellID2               0x00000005
#define RST_VICPCellID3               0x000000B1

/******************************************************************************/
/************************* MACRO DEFINITION ***********************************/
/******************************************************************************/

#define D_VICRawIntr     (D_TrIntSource | D_VICSoftInt)
#define D_VICIRQStatus   ((D_VICRawIntr & D_VICIntEnable) &                                       (~D_VICIntSelect))
#define D_VICFIQStatus   ((D_VICRawIntr & D_VICIntEnable) &                                       (D_VICIntSelect))

/******************************************************************************/
/********************* DEFAULT DATA CONSTANTS *********************************/
/******************************************************************************/


/*** #define D_VICTrTCR       0x7 ***/

/******************************************************************************/
/********     MACRO DEFINITION FOR BYPASSING THE ITIP/ITOP    *****************/
/******** REGISTER REGISTER ACCESSES DURING NETLIST SIMLATION *****************/
/******************************************************************************/

#define VICrtl_sim     1

/******************************** End *****************************************/
