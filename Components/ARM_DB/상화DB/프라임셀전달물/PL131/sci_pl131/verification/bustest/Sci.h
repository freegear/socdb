/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Sci_free.h,v
--  File Revision          : 1.8
--
--  Release Information    : PL130-REL1v1
--
--------------------------------------------------------------------------------
 
----------------------------------------------------------------------------------  Purpose  :  This file contains the register offsets and other definitions
--              for the Sci_free.c free running test code.
--
------------------------------------------------------------------------------*/

/******************************************************************************/

#define ZERO    0x00000000
#define NoMask  0xFFFFFFFF
#define MaskAll 0x00000000

/******************************************************************************/
/******************** TRICKBOX REGISTERS **************************************/
/******************************************************************************/
 
/******************************************************************************/
/*** SMART CARD Trickbox  Registers                                         ***/
/*** ==============================                                         ***/
/*** SCITrDATA      0x00 9/8   R/W Data Read register                       ***/
/*** SCITrCR        0x04 16/16 R/W Trickbox control register                ***/
/*** SCITrFiLCR     0x08  6/6  R/W FIFO Fill level control register         ***/
/*** SCITrSR0       0x0C    6  R   Trickbox flag register                   ***/
/*** SCITrSR1       0x10    13 R   SCI interrupt Status register            ***/
/*** SCITrSR2       0x14    1  R   SCIDEACACK status register               ***/
/*** SCITrTXPC      0x18    4  R/W Trickbox transmit retry register         ***/
/*** SCITrTXPC      0x1C    4  R/W Trickbox receive retry register          ***/
/*** SCITrCTRL      0x20  8/8  R/W Error Message control register           ***/
/*** SCITrAT        0x24 16/16 R/W Reserved                                 ***/
/*** SCITrDT        0x28 16/16 R/W Reserved                                 ***/
/*** SCITrCKICC     0x2C 16/16 R/W SCICLK Register                          ***/
/*** SCITrBAUD      0x30 16/16 R   Trickbox baud Register                   ***/
/*** SCITrVALUE     0x34  8/8  R/W Trickbox value register                  ***/
/*** SCITrTXCHG     0x38  8/8  R/W Trickbox TX CHGUARD register             ***/
/*** SCITrTXBLKG    0x3C  8/8  R/W Trickbox TX BLKGUARD register            ***/
/*** SCITrRXCHG     0x40  8/8  R/W Trickbox RX CHGUARD register             ***/
/*** SCITrRXBLKG    0x44  8/8  R/W Trickbox RX BLKGUARD register            ***/
/*** SCITrRFCK      0x48 16/16 R/W REFCLK register                          ***/
/*** SCITrWV        0x4C  8/8  R/W Error Margin register                    ***/
/*** SCITrJit       0x50 16/16 R/W Jitter value register                    ***/
/*** SCITrJitPat    0x54  9/9  R/W Jitter control register                  ***/
/*** SCITrRFCNTL    0x58  3/3  R/W REFCLK control register                  ***/
/******************************************************************************/
 
#define TB_BASE          0x60000000
#define SCITrDATA      TB_BASE+0x00
#define SCITrCR        TB_BASE+0x04
#define SCITrFiLCR     TB_BASE+0x08
#define SCITrSR0       TB_BASE+0x0C
#define SCITrSR1       TB_BASE+0x10
#define SCITrSR2       TB_BASE+0x14
#define SCITrTXPC      TB_BASE+0x18
#define SCITrRXPC      TB_BASE+0x1C
#define SCITrCTRL      TB_BASE+0x20
#define SCITrAT        TB_BASE+0x24
#define SCITrDT        TB_BASE+0x28
#define SCITrCKICC     TB_BASE+0x2C
#define SCITrBAUD      TB_BASE+0x30
#define SCITrVALUE     TB_BASE+0x34
#define SCITrTXCHG     TB_BASE+0x38
#define SCITrTXBLKG    TB_BASE+0x3C
#define SCITrRXCHG     TB_BASE+0x40
#define SCITrRXBLKG    TB_BASE+0x44
#define SCITrRFCK      TB_BASE+0x48
#define SCITrWV        TB_BASE+0x4C
#define SCITrJit       TB_BASE+0x50
#define SCITrJitPat    TB_BASE+0x54
#define SCITrRFCNTL    TB_BASE+0x58
#define SCITrDMA       TB_BASE+0x5C


/* -----------------------------------------------------------------------------
//                     SCI PL131 Register Map
// ---------------------------------------------------------------------------*/
#define SCI_BASE       0xA0000000
#define SCIDATA        SCI_BASE + 0x000
#define SCICR0         SCI_BASE + 0x004
#define SCICR1         SCI_BASE + 0x008 
#define SCICR2         SCI_BASE + 0x00C
#define SCICLKICC      SCI_BASE + 0x010
#define SCIVALUE       SCI_BASE + 0x014
#define SCIBAUD        SCI_BASE + 0x018
#define SCITIDE        SCI_BASE + 0x01C
#define SCIDMACR       SCI_BASE + 0x020
#define SCISTABLE      SCI_BASE + 0x024
#define SCIATIME       SCI_BASE + 0x028
#define SCIDTIME       SCI_BASE + 0x02C
#define SCIATRSTIME    SCI_BASE + 0x030
#define SCIATRDTIME    SCI_BASE + 0x034
#define SCISTOPTIME    SCI_BASE + 0x038
#define SCISTARTTIME   SCI_BASE + 0x03C
#define SCIRETRY       SCI_BASE + 0x040
#define SCICHTIMELS    SCI_BASE + 0x044
#define SCICHTIMEMS    SCI_BASE + 0x048
#define SCIBLKTIMELS   SCI_BASE + 0x04C
#define SCIBLKTIMEMS   SCI_BASE + 0x050
#define SCICHGUARD     SCI_BASE + 0x054
#define SCIBLKGUARD    SCI_BASE + 0x058
#define SCIRXTIME      SCI_BASE + 0x05C
#define SCIFIFOSTATUS  SCI_BASE + 0x060
#define SCITXCOUNT     SCI_BASE + 0x064
#define SCIRXCOUNT     SCI_BASE + 0x068
#define SCIIMSC        SCI_BASE + 0x06C
#define SCIRIS         SCI_BASE + 0x070
#define SCIMIS         SCI_BASE + 0x074
#define SCIICR         SCI_BASE + 0x078
#define SCISYNCACT     SCI_BASE + 0x07C
#define SCISYNCTX      SCI_BASE + 0x080
#define SCISYNCRX      SCI_BASE + 0x084
#define SCIPeriphID0   SCI_BASE + 0xFE0
#define SCIPeriphID1   SCI_BASE + 0xFE4
#define SCIPeriphID2   SCI_BASE + 0xFE8
#define SCIPeriphID3   SCI_BASE + 0xFEC
#define SCIPCellID0    SCI_BASE + 0xFF0
#define SCIPCellID1    SCI_BASE + 0xFF4
#define SCIPCellID2    SCI_BASE + 0xFF8
#define SCIPCellID3    SCI_BASE + 0xFFC

/* -----------------------------------------------------------------------------
//                         Sci Test Register Map
// ---------------------------------------------------------------------------*/
#define SCITCR         SCI_BASE + 0xF00
#define SCIITIP        SCI_BASE + 0xF04
#define SCIITOP1       SCI_BASE + 0xF08
#define SCIITOP2       SCI_BASE + 0xF0C
#define SCITDR         SCI_BASE + 0xF10



/********** End Of Header File **********************************************/
