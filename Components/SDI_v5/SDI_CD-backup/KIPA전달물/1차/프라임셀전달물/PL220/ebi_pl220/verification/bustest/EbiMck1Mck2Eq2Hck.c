/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
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
-- File Name              : EbiMck1Mck2Eq2Hck.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--         MemClk1 & MemClk2 is equal to twice HCLK. 
--        Different combination of requests generated fromt the three ports.
--
--==========================================================================--*/

/******************************************************************************/
/***************************** EbiMck1Mck2Eq2Hck ******************************/
/******************************************************************************/
void EbiMck1Mck2Eq2Hck()
{
 /*
  Summary: EbiMck1Mck2Eq2Hck
  ==========================

  o Memory Clock1 and Clock2 are made equal to twice that of HCLK.

  o EbiReqPos1 and EbiReqPos2 are set in the EbiTrCntl register.
  
  o Request raised by Port1 and Port2.

  o Request raised by Port1 and Port3.

  o Request raised by Port2 and Port3.

  o Request raised by all three Ports simultaneously.

  o Request raised sequentially.

  o Port1 has the grant and backoff signal is given to it.

  o Request are raised by two Ports and after one clock cycle they
    are pulled low.

  o The Counter registers of two Ports decrements down to zero simultaneously.  
 */ 


/* MemClk1 and MemClk2 is equal to HCLK*2 */
C("MemClk1 and MemClk2 is equal to HCLK*2");
Write(EbiTrClk, 0x3, "WRD");

/* Writing data in the address registers */
C("Writing down data in the address registers");
Write(EbiTrAddr1, 0xABCADAFF, "WRD");
Write(EbiTrAddr2, 0xACCADAEE, "WRD");
Write(EbiTrAddr3, 0xABCADB44, "WRD");

/* Wrting data in the data enable registers */
C("Writing down data in the data enable registers");
Write(nEbiTrDataEn1, 0x7, "WRD");
Write(nEbiTrDataEn2, 0x5, "WRD");
Write(nEbiTrDataEn3, 0xA, "WRD");

/* Writing data in the data registers */
C("Writing down data in the data registers");
Write(EbiTrData1, 0xAAEEFF8A, "WRD");
Write(EbiTrData2, 0x1133AA44, "WRD");
Write(EbiTrData1, 0x8AA234CC, "WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x5, "WRD");
Write(EbiTrTimeOut2, 0x7, "WRD");
Write(EbiTrTimeOut3, 0xA, "WRD");

/* In the following test  Requests are raised by Port1 and Port2 */
/* EbiReqPos1 and EbiReqPos2 is enabled */
C("Request raised by Port1 and Port2");
Write(EbiTrCntl, 0x0000001B, "WRD");

C("All Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000018, "WRD");

/* In the following test Requests are raised by Port1 and Port3 */
/* EbiReqPos1 and EbiReqPos2 is enabled */
C("Request raised by Port1 and Port3");
Write(EbiTrCntl, 0x0000001D, "WRD");

C("All Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000018, "WRD");

/* In the following test Requests are raised by Port2 and Port3 */
/* EbiReqPos1 and EbiReqPos2 is enabled */
C("Request raised by Port2 and Port3");
Write(EbiTrCntl, 0x0000001E, "WRD");

C("All Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000018, "WRD");

/* In the following test Requests are raised by all the three Ports */
/* EbiReqPos1 and EbireqPos2 is enabled */
C("Request raised by all the three Port");
WaitLoop(0x7);
Write(EbiTrCntl, 0x0000001F, "WRD");

C("All Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000018, "WRD");

/* In the following test request are raised sequentially */
/* EbiReqPos1 and EbireqPos2 is enabled */
C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000019, "WRD");

C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x0000001B, "WRD");

C("Request raised by Port3");
WaitLoop(0x1);
Write(EbiTrCntl, 0x0000001F, "WRD");

C("All Request are pulled low");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000018, "WRD");

/* In the following test Port1 has the grant and a backoff signal is given */
/* to Port1 */
/* EbiReqPos1 and EbireqPos2 is enabled */
C("Request raised by Port1");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000019, "WRD");

C("Request raised by Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000001B, "WRD");

C("All Request are pulled low");
WaitLoop(0xB);
Write(EbiTrCntl, 0x00000018, "WRD");

/* In the following test Request raised by Port1 and Port2 simultaneously */
/* they are pulled low after one clock cycle. */
/* EbiReqPos1 and EbireqPos2 is enabled */
C("Request raised by Port1 and Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x0000001B, "WRD");

C("Request are pulled low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000018, "WRD");

/* In the following test Counter register of Port1 and Port2 are loaded */
/* with same values and they decrement down to zero simultaneously */
/* EbiReqPos1 and EbiReqPos2 is enabled */
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
/* ---====================================END==============================---*/
