/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Smc.h.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains the register offsets and other definitions
--           for the Smc.c test code.
--
-- --=========================================================================*/

/******************************************************************************/

#define ZERO        0x00000000
#define BUnMask0    0x000000FF
#define BUnMask1    0x0000FF00
#define BUnMask2    0x00FF0000
#define BUnMask3    0xFF000000
#define HWUnMaskL   0x0000FFFF
#define HWUnMaskB   0xFFFF0000
#define NoMask      0xFFFFFFFF
#define MaskAll     0x00000000
#define Data0       0x00000000
#define Data5       0x55555555
#define DataA       0xAAAAAAAA
#define DataF       0xFFFFFFFF

/******************************************************************************/
/************************** TRICKBOX REGISTERS ********************************/
/******************************************************************************/

/******************************************************************************/
/*** SMC TrickMem  Registers                                                ***/
/*** =========================                                              ***/
/*** SMCTrMEMR   0x0000  32/32  R/W  Memory array                           ***/
/*** SMCTrIDCY   0x2000    6/6  R/W  Memory data bus turn around time       ***/
/*** SMCTrWST1   0x4000    7/7  R/W  Wait state register1                   ***/
/*** SMCTrWST2   0x6000    7/7  R/W  Wait state register2                   ***/
/*** SMCTrMEMT   0x8000    7/7  R/W  Memory type and width config register  ***/
/*** SMCTrMEMB   0xA000  15/15  R/W  Memory base address register           ***/
/*** SMCTrCS2OEN 0xA000    5/5  R/W  CS assertion to nSMOEN assertion wait  ***/
/*** SMCTrCS2WEN 0xA000    5/5  R/W  CS assertion to nSMWEN assertion wait  ***/
/*** SMCTrCSPOL  0xA000    7/7  R/W  CS polarity register                   ***/
/******************************************************************************/
#define TM0_BASE         0x40000000
#define TM1_BASE         0x44000000
#define TM2_BASE         0x48000000
#define TM3_BASE         0x4C000000
#define TM4_BASE         0x50000000
#define TM5_BASE         0x54000000
#define TM6_BASE         0x58000000
#define TM7_BASE         0x5C000000
#define SMCTrMEMR_0      (TM0_BASE + 0x0000)
#define SMCTrIDCY_0      (TM0_BASE + 0x2000)
#define SMCTrWST1_0      (TM0_BASE + 0x4000)
#define SMCTrWST2_0      (TM0_BASE + 0x6000)
#define SMCTrMEMT_0      (TM0_BASE + 0x8000)
#define SMCTrMEMB_0      (TM0_BASE + 0x9000)
#define SMCTrCS2OEN_0    (TM0_BASE + 0xA000)
#define SMCTrCS2WEN_0    (TM0_BASE + 0xB000)
#define SMCTrCSPOL_0     (TM0_BASE + 0xC000)

#define SMCTrMEMR_1      (TM1_BASE + 0x0000)
#define SMCTrIDCY_1      (TM1_BASE + 0x2000)
#define SMCTrWST1_1      (TM1_BASE + 0x4000)
#define SMCTrWST2_1      (TM1_BASE + 0x6000)
#define SMCTrMEMT_1      (TM1_BASE + 0x8000)
#define SMCTrMEMB_1      (TM1_BASE + 0x9000)
#define SMCTrCS2OEN_1    (TM1_BASE + 0xA000)
#define SMCTrCS2WEN_1    (TM1_BASE + 0xB000)
#define SMCTrCSPOL_1     (TM1_BASE + 0xC000)

#define SMCTrMEMR_2      (TM2_BASE + 0x0000)
#define SMCTrIDCY_2      (TM2_BASE + 0x2000)
#define SMCTrWST1_2      (TM2_BASE + 0x4000)
#define SMCTrWST2_2      (TM2_BASE + 0x6000)
#define SMCTrMEMT_2      (TM2_BASE + 0x8000)
#define SMCTrMEMB_2      (TM2_BASE + 0x9000)
#define SMCTrCS2OEN_2    (TM2_BASE + 0xA000)
#define SMCTrCS2WEN_2    (TM2_BASE + 0xB000)
#define SMCTrCSPOL_2     (TM2_BASE + 0xC000)

#define SMCTrMEMR_3      (TM3_BASE + 0x0000)
#define SMCTrIDCY_3      (TM3_BASE + 0x2000)
#define SMCTrWST1_3      (TM3_BASE + 0x4000)
#define SMCTrWST2_3      (TM3_BASE + 0x6000)
#define SMCTrMEMT_3      (TM3_BASE + 0x8000)
#define SMCTrMEMB_3      (TM3_BASE + 0x9000)
#define SMCTrCS2OEN_3    (TM3_BASE + 0xA000)
#define SMCTrCS2WEN_3    (TM3_BASE + 0xB000)
#define SMCTrCSPOL_3     (TM3_BASE + 0xC000)

#define SMCTrMEMR_4      (TM4_BASE + 0x0000)
#define SMCTrIDCY_4      (TM4_BASE + 0x2000)
#define SMCTrWST1_4      (TM4_BASE + 0x4000)
#define SMCTrWST2_4      (TM4_BASE + 0x6000)
#define SMCTrMEMT_4      (TM4_BASE + 0x8000)
#define SMCTrMEMB_4      (TM4_BASE + 0x9000)
#define SMCTrCS2OEN_4    (TM4_BASE + 0xA000)
#define SMCTrCS2WEN_4    (TM4_BASE + 0xB000)
#define SMCTrCSPOL_4     (TM4_BASE + 0xC000)

#define SMCTrMEMR_5      (TM5_BASE + 0x0000)
#define SMCTrIDCY_5      (TM5_BASE + 0x2000)
#define SMCTrWST1_5      (TM5_BASE + 0x4000)
#define SMCTrWST2_5      (TM5_BASE + 0x6000)
#define SMCTrMEMT_5      (TM5_BASE + 0x8000)
#define SMCTrMEMB_5      (TM5_BASE + 0x9000)
#define SMCTrCS2OEN_5    (TM5_BASE + 0xA000)
#define SMCTrCS2WEN_5    (TM5_BASE + 0xB000)
#define SMCTrCSPOL_5     (TM5_BASE + 0xC000)

#define SMCTrMEMR_6      (TM6_BASE + 0x0000)
#define SMCTrIDCY_6      (TM6_BASE + 0x2000)
#define SMCTrWST1_6      (TM6_BASE + 0x4000)
#define SMCTrWST2_6      (TM6_BASE + 0x6000)
#define SMCTrMEMT_6      (TM6_BASE + 0x8000)
#define SMCTrMEMB_6      (TM6_BASE + 0x9000)
#define SMCTrCS2OEN_6    (TM6_BASE + 0xA000)
#define SMCTrCS2WEN_6    (TM6_BASE + 0xB000)
#define SMCTrCSPOL_6     (TM6_BASE + 0xC000)

#define SMCTrMEMR_7      (TM7_BASE + 0x0000)
#define SMCTrIDCY_7      (TM7_BASE + 0x2000)
#define SMCTrWST1_7      (TM7_BASE + 0x4000)
#define SMCTrWST2_7      (TM7_BASE + 0x6000)
#define SMCTrMEMT_7      (TM7_BASE + 0x8000)
#define SMCTrMEMB_7      (TM7_BASE + 0x9000)
#define SMCTrCS2OEN_7    (TM7_BASE + 0xA000)
#define SMCTrCS2WEN_7    (TM7_BASE + 0xB000)
#define SMCTrCSPOL_7     (TM7_BASE + 0xC000)

/******************************************************************************/
/*** SMC Trickbox  Registers                                                ***/
/*** =========================                                              ***/
/*** SMCTrMWCS    0x0000    2/2  R/W  Boot Memory Width register            ***/
/*** SMCTrREMAP   0x2000    1/1  R/W  Remap register                        ***/
/*** SMCTrEndian  0x4000    1/1  R/W  Endianness register                   ***/
/*** SMCTrCS2WTRx         26/26  R/W  CS to SMWAIT assertion control for    ***/
/***                                  Bank x                                ***/
/*** SMCTrCEWTRx          24/24  R/W  CancelSMWAIT assertion control for    ***/
/***                                  Bank x                                ***/
/******************************************************************************/
#define TB_BASE          0x60000000
#define SMCTrMWCS        (TB_BASE + 0x0000)
#define SMCTrREMAP       (TB_BASE + 0x0004)
#define SMCTrEndian      (TB_BASE + 0x0008)
#define SMCTrCS2WTR0     (TB_BASE + 0x000C)
#define SMCTrCEWTR0      (TB_BASE + 0x0010)
#define SMCTrCS2WTR1     (TB_BASE + 0x0014)
#define SMCTrCEWTR1      (TB_BASE + 0x0018)
#define SMCTrCS2WTR2     (TB_BASE + 0x001C)
#define SMCTrCEWTR2      (TB_BASE + 0x0020)
#define SMCTrCS2WTR3     (TB_BASE + 0x0024)
#define SMCTrCEWTR3      (TB_BASE + 0x0028)
#define SMCTrCS2WTR4     (TB_BASE + 0x002C)
#define SMCTrCEWTR4      (TB_BASE + 0x0030)
#define SMCTrCS2WTR5     (TB_BASE + 0x0034)
#define SMCTrCEWTR5      (TB_BASE + 0x0038)
#define SMCTrCS2WTR6     (TB_BASE + 0x003C)
#define SMCTrCEWTR6      (TB_BASE + 0x0040)
#define SMCTrCS2WTR7     (TB_BASE + 0x0044)
#define SMCTrCEWTR7      (TB_BASE + 0x0048)
#define SMCTrMCREQD      (TB_BASE + 0x004C)
#define SMCTrGNT2RMREQ   (TB_BASE + 0x0050)
#define SMCTrMCADDR      (TB_BASE + 0x0054)
#define SMCTrMCBUSR      (TB_BASE + 0x0058)

/******************************************************************************/
/******************************* SMC Register *********************************/
/******************************************************************************/
#define SMCCR_BASE       0x20000000
#define Memory_BASE      0x00000000
#define SMCMEM_0         (Memory_BASE + 0x00000000)
#define SMCMEM_1         (Memory_BASE + 0x04000000)
#define SMCMEM_2         (Memory_BASE + 0x08000000)
#define SMCMEM_3         (Memory_BASE + 0x0C000000)
#define SMCMEM_4         (Memory_BASE + 0x10000000)
#define SMCMEM_5         (Memory_BASE + 0x14000000)
#define SMCMEM_6         (Memory_BASE + 0x18000000)
#define SMCMEM_7         (Memory_BASE + 0x1C000000)

#define SMBIDCYR0        (SMCCR_BASE + 0x00)
#define SMBIDCYR1        (SMCCR_BASE + 0x1C)
#define SMBIDCYR2        (SMCCR_BASE + 0x38)
#define SMBIDCYR3        (SMCCR_BASE + 0x54)
#define SMBIDCYR4        (SMCCR_BASE + 0x70)
#define SMBIDCYR5        (SMCCR_BASE + 0x8C)
#define SMBIDCYR6        (SMCCR_BASE + 0xA8)
#define SMBIDCYR7        (SMCCR_BASE + 0xC4)

#define SMBWST1R0        (SMCCR_BASE + 0x04)
#define SMBWST1R1        (SMCCR_BASE + 0x20)
#define SMBWST1R2        (SMCCR_BASE + 0x3C)
#define SMBWST1R3        (SMCCR_BASE + 0x58)
#define SMBWST1R4        (SMCCR_BASE + 0x74)
#define SMBWST1R5        (SMCCR_BASE + 0x90)
#define SMBWST1R6        (SMCCR_BASE + 0xAC)
#define SMBWST1R7        (SMCCR_BASE + 0xC8)

#define SMBWST2R0        (SMCCR_BASE + 0x08)
#define SMBWST2R1        (SMCCR_BASE + 0x24)
#define SMBWST2R2        (SMCCR_BASE + 0x40)
#define SMBWST2R3        (SMCCR_BASE + 0x5C)
#define SMBWST2R4        (SMCCR_BASE + 0x78)
#define SMBWST2R5        (SMCCR_BASE + 0x94)
#define SMBWST2R6        (SMCCR_BASE + 0xB0)
#define SMBWST2R7        (SMCCR_BASE + 0xCC)

#define SMBWSTOENR0      (SMCCR_BASE + 0x0C)
#define SMBWSTOENR1      (SMCCR_BASE + 0x28)
#define SMBWSTOENR2      (SMCCR_BASE + 0x44)
#define SMBWSTOENR3      (SMCCR_BASE + 0x60)
#define SMBWSTOENR4      (SMCCR_BASE + 0x7C)
#define SMBWSTOENR5      (SMCCR_BASE + 0x98)
#define SMBWSTOENR6      (SMCCR_BASE + 0xB4)
#define SMBWSTOENR7      (SMCCR_BASE + 0xD0)

#define SMBWSTWENR0      (SMCCR_BASE + 0x10)
#define SMBWSTWENR1      (SMCCR_BASE + 0x2C)
#define SMBWSTWENR2      (SMCCR_BASE + 0x48)
#define SMBWSTWENR3      (SMCCR_BASE + 0x64)
#define SMBWSTWENR4      (SMCCR_BASE + 0x80)
#define SMBWSTWENR5      (SMCCR_BASE + 0x9C)
#define SMBWSTWENR6      (SMCCR_BASE + 0xB8)
#define SMBWSTWENR7      (SMCCR_BASE + 0xD4)

#define SMBCR0           (SMCCR_BASE + 0x14)
#define SMBCR1           (SMCCR_BASE + 0x30)
#define SMBCR2           (SMCCR_BASE + 0x4C)
#define SMBCR3           (SMCCR_BASE + 0x68)
#define SMBCR4           (SMCCR_BASE + 0x84)
#define SMBCR5           (SMCCR_BASE + 0xA0)
#define SMBCR6           (SMCCR_BASE + 0xBC)
#define SMBCR7           (SMCCR_BASE + 0xD8)

#define SMBSR0           (SMCCR_BASE + 0x18)
#define SMBSR1           (SMCCR_BASE + 0x34)
#define SMBSR2           (SMCCR_BASE + 0x50)
#define SMBSR3           (SMCCR_BASE + 0x6C)
#define SMBSR4           (SMCCR_BASE + 0x88)
#define SMBSR5           (SMCCR_BASE + 0xA4)
#define SMBSR6           (SMCCR_BASE + 0xC0)
#define SMBSR7           (SMCCR_BASE + 0xDC)

#define SMBEWS           (SMCCR_BASE + 0xE0)

#define SMCPeriphID0     (SMCCR_BASE + 0xFE0)
#define SMCPeriphID1     (SMCCR_BASE + 0xFE4)
#define SMCPeriphID2     (SMCCR_BASE + 0xFE8)
#define SMCPeriphID3     (SMCCR_BASE + 0xFEC)

#define SMCPCellID0      (SMCCR_BASE + 0xFF0)
#define SMCPCellID1      (SMCCR_BASE + 0xFF4)
#define SMCPCellID2      (SMCCR_BASE + 0xFF8)
#define SMCPCellID3      (SMCCR_BASE + 0xFFC)

/******************************************************************************/
/*************************** SMC Register Reset Values ************************/
/******************************************************************************/
#define RST_SMBIDCYR     0x0000000F
#define RST_SMBWST1R     0x0000001F
#define RST_SMBWST2R     0x0000001F
#define RST_SMBWSTOENR   0x00000000
#define RST_SMBWSTWENR   0x00000001

#define RST_SMBCR0       0x00000080
#define RST_SMBCR1       0x00000000
#define RST_SMBCR2       0x00000040
#define RST_SMBCR3       0x00000000
#define RST_SMBCR4       0x00000080
#define RST_SMBCR5       0x00000080
#define RST_SMBCR6       0x00000040
#define RST_SMBCR7       0x00000080

#define RST_SMBSR0       0x00000000
#define RST_SMBSR1       0x00000000
#define RST_SMBSR2       0x00000000
#define RST_SMBSR3       0x00000000
#define RST_SMBSR4       0x00000000
#define RST_SMBSR5       0x00000000
#define RST_SMBSR6       0x00000000
#define RST_SMBSR7       0x00000000

#define RST_SMBEWS       0x00000000

#define RST_SMCPeriphID0 0x00000092
#define RST_SMCPeriphID1 0x00000010
#define RST_SMCPeriphID2 0x00000004
#define RST_SMCPeriphID3 0x00000000

#define RST_SMCPCellID0  0x0000000D
#define RST_SMCPCellID1  0x000000F0
#define RST_SMCPCellID2  0x00000005
#define RST_SMCPCellID3  0x000000B1

/************************************ End *************************************/
