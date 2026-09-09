/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SciCommon.h.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL131-REL1v0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It is a common file which has used by different test
--           cases.
--
-- --=======================================================================--*/
static int     data[16]=    { 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
                              0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF };

static int Exordata[16]=    { 0xFF, 0xEE, 0xDD, 0xCC, 0xBB, 0xAA, 0x99, 0x88, 
                              0x77, 0x66, 0x55, 0x44, 0x33, 0x22, 0x11, 0x00 };

static int Swapdata[16]=    { 0x00, 0x88, 0x44, 0xCC, 0x22, 0xAA, 0x66, 0xEE, 
                              0x11, 0x99, 0x55, 0xDD, 0x33, 0xBB, 0x77, 0xFF };

static int ExorSwapdata[16]= { 0xFF, 0x77, 0xBB, 0x33, 0xDD, 0x55, 0x99, 0x11, 
                              0xEE, 0x66, 0xAA, 0x22, 0xCC, 0x44, 0x88, 0x00 };

static int  Dummyclock  =  Margin * clkmulfactor;

