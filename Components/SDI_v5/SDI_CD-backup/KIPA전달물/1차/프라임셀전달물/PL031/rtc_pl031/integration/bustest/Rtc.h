/*--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Rtc.h.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL031-REL1v0
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose  :  This file contains the register offsets and other definitions
--              for the Rtc.c free running test code.
--
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** Register  Offset Width Type Function                                   ***/
/*** ====================================================================== ***/
/*** RTC Normal Registers                                                   ***/
/*** ====================                                                   ***/
/*** RTCDR      0x00   32   R    Data Register                              ***/
/*** RTCMR      0x04   32   R/W  Match Register                             ***/
/*** RTCLR      0x08   32   R/W  Load Register                              ***/
/*** RTCCR      0x0C    1   R/W  Control Register                           ***/
/*** RTCIMSC    0x10    1   R/W  Interrupt Mask Set/Clear Register          ***/
/*** RTCRIS     0x14    1   R    Raw Interrupt Status Register              ***/
/*** RTCMIS     0x18    1   R    Masked Interrupt Status Register           ***/
/*** RTCICR     0x1C    1     W  Interrupt Clear Register                   ***/
/***                                                                        ***/
/*** RTC Test Registers                                                     ***/
/*** ==================                                                     ***/
/*** RTCITCR    0x80    2  R/W  Test Control Register                       ***/
/*** RTCITIP    0x84    1  R/W  Integration Test InPut register             ***/
/*** RTCITOP    0x88    1  R/W  Integration Test OutPut register            ***/
/*** RTCTOFFSET 0x8C    32 R/W  Test Offset Register                        ***/
/*** RTCTCOUNT  0x90    32 R/W  Test Count Register                         ***/
/***                                                                        ***/
/*** RTC Trickbox Registers                                                 ***/
/*** ======================                                                 ***/
/*** RTCR       0x00    2  R/W  Control Register                            ***/
/*** RTSR       0x04    1  R    CLK1HZ Status Register                      ***/
/*** RTCLK1HZH  0x08   16  R/W  CLK1HZ High Phase Control Register          ***/
/*** RTCLK1HZL  0x0C   16  R/W  CLK1HZ Low Phase Control Register           ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the Rtc, please refer to PL031 AMBA RTC        ***/
/*** Block Specification                                                    ***/
/******************************************************************************/


/******************************************************************************/
/******************** RTC NORMAL-MODE REGISTERS *******************************/
/******************************************************************************/

#define RTCBASE_ADD     0x84000000
#define RTCDR           RTCBASE_ADD + 0x00
#define RTCMR           RTCBASE_ADD + 0x04
#define RTCLR           RTCBASE_ADD + 0x08
#define RTCCR           RTCBASE_ADD + 0x0c
#define RTCIMSC         RTCBASE_ADD + 0x10
#define RTCRIS          RTCBASE_ADD + 0x14
#define RTCMIS          RTCBASE_ADD + 0x18
#define RTCICR          RTCBASE_ADD + 0x1c

#define PeripheralID0   RTCBASE_ADD + 0xFE0
#define PeripheralID1   RTCBASE_ADD + 0xFE4
#define PeripheralID2   RTCBASE_ADD + 0xFE8
#define PeripheralID3   RTCBASE_ADD + 0xFEC
#define PrimeCellID0    RTCBASE_ADD + 0xFF0
#define PrimeCellID1    RTCBASE_ADD + 0xFF4
#define PrimeCellID2    RTCBASE_ADD + 0xFF8
#define PrimeCellID3    RTCBASE_ADD + 0xFFC

/******************************************************************************/
/********************* RTC TEST-MODE REGISTERS ********************************/
/******************************************************************************/

#define RTCITCR         RTCBASE_ADD + 0x80
#define RTCITIP         RTCBASE_ADD + 0x84
#define RTCITOP         RTCBASE_ADD + 0x88
#define RTCTOFFSET      RTCBASE_ADD + 0x8C
#define RTCTCOUNT       RTCBASE_ADD + 0x90

/******************************************************************************/
/******************** TRICKBOX REGISTERS **************************************/
/******************************************************************************/

#define RTBASE_ADD      0x60000000
#define RTCR            RTBASE_ADD + 0x00
#define RTSR            RTBASE_ADD + 0x04
#define RTCLK1HZH       RTBASE_ADD + 0x08
#define RTCLK1HZL       RTBASE_ADD + 0x0C

/******************************************************************************/
/****************** MISCELLANEOUS *********************************************/
/******************************************************************************/

#define NoMask          0xFFFFFFFF
#define MaskTst         0x0000000F
#define MaskAll         0x00000000

#define MaskClk         0x00000001
#define MASK_IDREG      0x0FF

#define DATA_As         0xAAAAAAAA
#define DATA_5s         0x55555555

/**************************** End of Rtc.h ************************************/

