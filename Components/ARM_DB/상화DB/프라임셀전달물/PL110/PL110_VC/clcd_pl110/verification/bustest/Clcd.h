/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : ClcdCommon.h,v
--  File Revision          : 1.1.1.1
--
--  Release Information    : PrimeCell(TM)-PL110-REL1v1
--
------------------------------------------------------------------------------*/
#define ZERO       0x00000000
#define NoMask     0xFFFFFFFF
#define MaskAll    0x00000000

/**************     BASE ADDRESS DEFINITION  ************/
#define CLcd_base  0x50000000
#define CLTr_base  0xA0000000

/***********REGISTER ADDRESSES OF CLCD TRICKBOX***********/
#define DelayReg   CLTr_base+0x00000004


/***********REGISTER ADDRESSES OF CLCD CONTROLLER *********/ 
#define Tim0       CLcd_base+0x00000000
#define Tim1       CLcd_base+0x00000004
#define Tim2       CLcd_base+0x00000008
#define Tim3       CLcd_base+0x0000000C
#define UpBase     CLcd_base+0x00000010
#define LpBase     CLcd_base+0x00000014 
#define Imsc       CLcd_base+0x00000018
#define CntrlReg   CLcd_base+0x0000001C
#define Ris        CLcd_base+0x00000020
#define Mis        CLcd_base+0x00000024
#define Icr        CLcd_base+0x00000028
#define UpCrntAddr CLcd_base+0x0000002C
#define LpCrntAddr CLcd_base+0x00000030
#define Pal        CLcd_base+0x00000200
#define DMAFifo    CLcd_base+0x00000400

/*********** PrimeCell Integration Test Registers **********/
#define LcdTCR     CLcd_base+0x00000F00
#define LcdITOP1   CLcd_base+0x00000F04
#define LcdITOP2   CLcd_base+0x00000F08

/*********** Peripheral Identification Registers **********/
#define PeriphID0  CLcd_base+0x00000FE0
#define PeriphID1  CLcd_base+0x00000FE4
#define PeriphID2  CLcd_base+0x00000FE8
#define PeriphID3  CLcd_base+0x00000FEC
 
/*********** PrimeCell Identification Registers **********/
#define PCellID0   CLcd_base+0x00000FF0
#define PCellID1   CLcd_base+0x00000FF4
#define PCellID2   CLcd_base+0x00000FF8
#define PCellID3   CLcd_base+0x00000FFC
 
