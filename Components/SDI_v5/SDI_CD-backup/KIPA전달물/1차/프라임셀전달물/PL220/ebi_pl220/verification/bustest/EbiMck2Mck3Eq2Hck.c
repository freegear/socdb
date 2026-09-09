/* -- --======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be pulled to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiMck2Mck3Eq2Hck.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--         MemClk2 & MemClk3 is equal to twice HCLK. 
--         Different combination of requests generated fromt the three ports.
--
--==========================================================================--*/

/******************************************************************************/
/*************************** EbiMck2Mck3Eq2Hck ********************************/
/******************************************************************************/
void EbiMck2Mck3Eq2Hck()
{
 /*
   Summary: EbiMck2Mck3Eq2Hck
   ==========================
   This test performs the following functionalities:

   o Memory Clock2 and Clock3 are pulled equal to twice that of HCLK.

   o EbiReqPos2  and EbiReqPos3 bit is set in the EbiTrCntl register. 

   o Request raised by Port2 and Port3 simultaneously.

   o Request raised by Port1 and Port2 simultaneously.

   o Request raised by Port1 and Port3 simultaneously.

   o Request raised by all the three Ports simultaneously.

   o Request raised sequentially.

   o Port2 has the grant and backoff signal is given to it.

   o Request are raised by two Ports and after one clock cycle they 
     are pulled low.
   
   o The Counter registers of two Ports decrements down to zero simultaneously.
  */ 

/* MemClk2 and MemClk3 is equal to HCLK*3 */
C("MemClk1 and MemClk2 is equal to HCLK");
Write(EbiTrClk, 0x6, "WRD");

/* Writing data in the address registers */
C("Writing down data in the address registers");
Write(EbiTrAddr1, 0xAA444445, "WRD");
Write(EbiTrAddr2, 0xAAA34CCC, "WRD");
Write(EbiTrAddr3, 0xBB333588, "WRD");

/* Writing data in the data enable registers */
C("Writing down data in the data enable registers");
Write(nEbiTrDataEn1, 0x00000002, "WRD");
Write(nEbiTrDataEn1, 0x00000001, "WRD");
Write(nEbiTrDataEn1, 0x00000013, "WRD");

/* Writing data in data registers */
C("Writing down data in the data registers");
Write(EbiTrData1, 0xAADD458A, "WRD");
Write(EbiTrData2, 0xAA454582, "WRD");
Write(EbiTrData3, 0xA6D54421, "WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x5, "WRD");
Write(EbiTrTimeOut2, 0x6, "WRD");
Write(EbiTrTimeOut3, 0x8, "WRD");

/* In the following test requests are raised by Port2 and Port3 */
/* simultaneously */
/* EbiReqPos2  and EbiReqPos3 bit is set */
C("Request raised by Port2 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000036, "WRD");

C("All request are pulled low");
WaitLoop(0x5);
Write(EbiTrCntl, 0x00000030, "WRD");

/* In the following test request are raised by Port1 and Port2 */
C("Request raised by Port1 and Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000033, "WRD");

C("All request are pulled low");
WaitLoop(0x5);
Write(EbiTrCntl, 0x00000030, "WRD");

/* In the following test request raised by Port1 and Port3 */
C("Request raised by Port1 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000035, "WRD");

C("All request are pulled low");
WaitLoop(0x5);
Write(EbiTrCntl, 0x00000030, "WRD");

/* In the following test Request raised by all the three ports */
/* EbiReqPos2 and EbiReqPos3 is enabled */
C("Request raised by all the three Port");
WaitLoop(0x7);
Write(EbiTrCntl, 0x00000037, "WRD");

C("Request from Port1 is pulled low");
WaitLoop(0x8);
Write(EbiTrCntl, 0x00000036, "WRD");

C("Request from Port3 is pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000034, "WRD");

C("All Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000030, "WRD");

/* In the following test request are raised sequentially. */
/* EbiReqPos2 and EbiReqPos3 is enabled */
C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000031, "WRD");

C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000033, "WRD");

C("Request raised by Port3");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000037, "WRD");

C("All Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000030, "WRD");

/* In the following test a Port2 has the grant and backoff signal is given */
/* to Port2 */
C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000032, "WRD");

C("Request raised by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000036, "WRD");

C("All Request are pulled low");
WaitLoop(0xE);
Write(EbiTrCntl, 0x00000030, "WRD");

/* In the following test request are raised by Port2 and Port3 */
/* after one clock cycle the requests are pulled low */
C("Request raised by Port2 and Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000036, "WRD");

C("Request are pulled low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000030 , "WRD");

/* In the following test Counter register of Port2 and Port3 are loaded */
/* with same values and they decrement down to zero simultaneously */
/* EbiReqPos2 and EbiReqPos3 is enabled */
C("Counters are loaded with same values");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x8, "WRD");
Write(EbiTrTimeOut3, 0x8, "WRD");

C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000031, "WRD");

C("Request raised by Port2 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000037, "WRD");

C("All Request are pulled low");
WaitLoop(0xC);
Write(EbiTrCntl, 0x00000030, "WRD");

}

/*---===============================END====================================---*/
