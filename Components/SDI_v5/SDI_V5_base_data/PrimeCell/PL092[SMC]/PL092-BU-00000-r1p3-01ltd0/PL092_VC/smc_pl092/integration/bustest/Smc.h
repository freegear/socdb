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
--  File Revision          : 1.12
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
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
#define BUnMaskL    0x000000FF
#define BUnMaskB    0xFF000000
#define HWUnMaskL   0x0000FFFF
#define HWUnMaskB   0xFFFF0000
#define NoMask      0xFFFFFFFF
#define MaskAll     0x00000000
#define Data0       0x00000000
#define Data5       0x55555555
#define DataA       0xAAAAAAAA
#define DataF       0xFFFFFFFF

/******************************************************************************/
/************************** GENERIC SLAVE REGISTERS ***************************/
/******************************************************************************/
#define GS_BASE          0x40000000
#define GS_ARRAY1        (GS_BASE + 0x100)
#define GS_ARRAY2        (GS_BASE + 0x500)
#define GS_WCS1          (GS_BASE + 0x000)
#define GS_WCS2          (GS_BASE + 0x004)
#define GS_CR            (GS_BASE + 0x008)
#define GS_TMOUT         (GS_BASE + 0x00C)
#define GS_XRDLY         (GS_BASE + 0x010)

/************************************ End *************************************/
