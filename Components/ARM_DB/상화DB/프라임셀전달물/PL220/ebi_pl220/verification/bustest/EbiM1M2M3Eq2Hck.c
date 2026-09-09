/*-- ========================================================================---
--This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiM1M2M3Eq2Hck.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--         MemClk1,MemClk2,MemClk3 is equal to twice HCLK. 
--         Different combination of requests generated fromt the three ports.
--
--==========================================================================--*/

/******************************************************************************/
/***************************** EbiM1M2M3Eq2Hck ********************************/
/******************************************************************************/
void EbiM1M2M3Eq2Hck()
{
 /*
  Summary: EbiM1M2M3Eq2Hck
  ========================

  o Memory Clock1,Clock2 and Clock3 are made equal to twice that ofHCLK.
  
  o EbiReqPos1, EbiReqPos2 and EbiReqPos3 bit is set in the EbiTrCntl register.

  o Request raised by Port1.

  o Request raised by Port2.

  o Request raised by Port3.

  o Request raised by all the three Ports simultaneously.

  o Request raised sequentially.

  o Request raised by all the three Ports and are made low after one clock
    cycle.

  o Counter Registers of Port1 and Port2 are loaded with same values and 
    they raise the backoff signal simultaneously.
 */ 

/* MemClk1,MemClk2 and MemClk3 is equal to HCLK*2 */
C("MemClk1 and MemClk2 is equal to HCLK");
Write(EbiTrClk, 0x7, "WRD");

/* Writing data in the address registers */
C("Writing down data in the address registers");
Write(EbiTrAddr1, 0x11FFEE44, "WRD");
Write(EbiTrAddr2, 0x2244CCAA, "WRD");
Write(EbiTrAddr3, 0x44332211, "WRD");

/*Writing data in the data enable registers */
C("Writing down data in the data enable registers");
Write(nEbiTrDataEn1, 0x00000002, "WRD");
Write(nEbiTrDataEn2, 0x00000004, "WRD");
Write(nEbiTrDataEn3, 0x0000000C, "WRD");

/* Writing data in the data registers */
C("Writing down data in the data registers");
Write(EbiTrData1, 0xAACC3388, "WRD");
Write(EbiTrData2, 0x33CCAAEE, "WRD");
Write(EbiTrData3, 0x222333AA, "WRD");

/* Writing data in the Counter registers */
C("Writing data in the Counter registers.");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x7, "WRD");
Write(EbiTrTimeOut3, 0x8, "WRD");

/* In the following test request raised by Port1 */
C("Request raised by Port1");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000039, "WRD");

C("Request pulled low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000038, "WRD");

/* In the following test request raised by Port2 */
C("Request raised by Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000003A, "WRD");

C("Request pulled low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000038, "WRD");

/* In the following test request raised by Port3 */
C("Request raised by Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000003C, "WRD");

C("Request pulled low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000038, "WRD");

/* In the following test  requests are raised by all the three Ports */
/* EbiReqPos1,EbiReqPos2 and EbiReqPos3 is enabled */
C("Request raised by all the three Port");
WaitLoop(0x7);
Write(EbiTrCntl, 0x0000003F, "WRD");

C("All Request are made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test request are raised sequentially */
/* EbiReqPos1,EbiReqPos2 and EbiReqPos3 is enabled */
C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000029, "WRD");

C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x0000002B, "WRD");

C("Request raised by Port3");
WaitLoop(0x1);
Write(EbiTrCntl, 0x0000002F, "WRD");

C("All Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000028, "WRD");

/* In the following test request are raised by all three ports */
/* Request are pulled low after a delay of one clock cycle */
C("Request raised by all the three Ports");
WaitLoop(0x4);
Write(EbiTrCntl, 0x0000002F, "WRD");

C("All Request are pulled low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000028, "WRD");

/* In the following test Counter registers of Port1 and Port2 are loaded with*/
/* same values and they generate the backoff signal simultaneously. */
C("Counters are loaded with same values");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x4, "WRD");
Write(EbiTrTimeOut3, 0x8, "WRD");

C("Request raised by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x0000001C, "WRD");

C("Request raised by Port1 and Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000001F, "WRD");

C("All Request are pulled low");
WaitLoop(0xC);
Write(EbiTrCntl, 0x00000018, "WRD");
}

/* --=============================END=======================================--*/
