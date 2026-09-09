/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Clcd.h.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
------------------------------------------------------------------------------*/
#define ZERO       0x00000000
#define NoMask     0xFFFFFFFF
#define MaskAll    0x00000000

/**************     BASE ADDRESS DEFINITION  ************/
#define Clcd_base  0x40000000
#define CLTr_base  0xA0000000

/***********REGISTER ADDRESSES OF CLCD TRICKBOX***********/
#define DelayReg   CLTr_base+0x00000004

/***********REGISTER ADDRESSES OF CLCD CONTROLLER *********/
#define Tim0       Clcd_base+0x00000000
#define Tim1       Clcd_base+0x00000004
#define Tim2       Clcd_base+0x00000008
#define Tim3       Clcd_base+0x0000000C
#define UpBase     Clcd_base+0x00000010
#define LpBase     Clcd_base+0x00000014
#define Imsc       Clcd_base+0x00000018
#define CntrlReg   Clcd_base+0x0000001C
#define Ris        Clcd_base+0x00000020
#define Mis        Clcd_base+0x00000024
#define Icr        Clcd_base+0x00000028
#define UpCrntAddr Clcd_base+0x0000002C
#define LpCrntAddr Clcd_base+0x00000030
#define Pal        Clcd_base+0x00000200
#define DMAFifo    Clcd_base+0x00000400

/*********** PrimeCell Integration Test Registers **********/
#define ClcdITCR   Clcd_base+0x00000F00
#define ClcdITOP1  Clcd_base+0x00000F04
#define ClcdITOP2  Clcd_base+0x00000F08

#define MASK_ClcdITOP1 0x0000003F
#define MASK_ClcdITOP2 0x3FFFFFFF

/*********** Peripheral Identification Registers **********/
#define PeriphID0  Clcd_base+0x00000FE0
#define PeriphID1  Clcd_base+0x00000FE4
#define PeriphID2  Clcd_base+0x00000FE8
#define PeriphID3  Clcd_base+0x00000FEC

/*********** PrimeCell Identification Registers **********/
#define PCellID0   Clcd_base+0x00000FF0
#define PCellID1   Clcd_base+0x00000FF4
#define PCellID2   Clcd_base+0x00000FF8
#define PCellID3   Clcd_base+0x00000FFC
