/*---========================================================================---
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiMclk2Eq2Hclk.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
--
-- -----------------------------------------------------------------------------
-- Purpose :
--         Memory clock2 is equal to twice HCLK. 
--        Different combination of requests generated fromt the three ports.   
--
--
-- --=======================================================================--*/

/******************************************************************************/
/***************************** EbiMclk2Eq2Hclk ********************************/
/******************************************************************************/
void EbiMclk2Eq2Hclk()
{
 /*
  Summary: EbiMclk2Eq2Hclk
  ========================
  This test performs the following funtionalities:

  o Memory clock2 is made equal to twice that of HCLK.

  o EbiReqPos2 bit is set in the EbiTrCntl register.
  
  o Request raised by Port2.
  
  o Request raised by Port1 and Port2 simultaneously.

  o Request raised by Port2 and Port3 simultaneously.

  o Request raised by all the three Ports simultaneously.
  
  o Requests are raised sequentially.

  o Port2 raises request and after one clock cycle it is pulled low.
  
  o Port has a grant and backoff signal is given to that Port.

  o Port is being given the grant and at the same clock it is also given a
    backoff signal.
 
  o Couters of two Ports are loaded with same values so that they genrate
    backoffsignal at the same time.
 */
 
/* MemClk2 equal to HCLK*2 */
C("MemClk2 equal to HCLK");
Write(EbiTrClk, 0x2, "WRD");

/* Writing data in the address registers */
C("Writing down data in the address registers");
Write(EbiTrAddr1, 0xABCADAFF, "WRD");
Write(EbiTrAddr2, 0xACCADAEE, "WRD");
Write(EbiTrAddr3, 0xABCADB44, "WRD");

/* Writing data in the data registers */
C("Writing down data in the data registers");
Write(EbiTrData1, 0xAAEEFF8A, "WRD");
Write(EbiTrData2, 0x1133AA44, "WRD");
Write(EbiTrData3, 0x8AA234CC, "WRD");

/* Writing data in the data enable registers */
C("Writing down data in the data enable registers");
Write(nEbiTrDataEn1, 0x7, "WRD");
Write(nEbiTrDataEn2, 0x5, "WRD");
Write(nEbiTrDataEn3, 0xA, "WRD");

/* Writing data in the Counter registers. */
C("Writing data in the Counter registes");
Write(EbiTrTimeOut1, 0x5, "WRD");
Write(EbiTrTimeOut2, 0x8, "WRD");
Write(EbiTrTimeOut3, 0xA, "WRD");

/* In the following test request is raised by Port2 */
/* EbiReqPos2 bit is enabled */
C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000012, "WRD");

C("Port2 request is made low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000010, "WRD");

/* In the following test requests are raised by Port1 and Port2 */
/* EbiReqPos2 bit is enabled */
C("Request raised by Port1 and Port2");
Write(EbiTrCntl, 0x00000013, "WRD");

C("All Request are made low");
Write(EbiTrCntl, 0x00000010, "WRD");

/* In the following test request raised by Port2 and Port3 */
/* EbiReqPos2 bit is enabled */
C("Request raised by Port2 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000016, "WRD");

C("All Request are made low");
Write(EbiTrCntl, 0x00000010, "WRD");

/* In the following test requests are raised by all the three Ports */
/* EbiTrPos2 is enabled */
C("Request raised by all the three Port");
WaitLoop(0x7);
Write(EbiTrCntl, 0x00000017, "WRD");

C("All Request are made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000010, "WRD");

/* In the following test request are raised sequentially */
/* EbiReqPos2 bit is enabled */
C("Request raised by Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000012, "WRD");

C("Request raised by Port1");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000013, "WRD");

C("Request raised by Port3");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000017, "WRD");

C("All Request are made low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000010, "WRD");

/* In the following test Port2 raises request and is pulled low after a */
/* delay of one clock cycle. */
C("Request raised by Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000012, "WRD");

C("Port2 request is pulled low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000010, "WRD");

/* In the following test Port has got the grant and backoff signal is given */
/* to the Port */
C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000012, "WRD");

C("Request raised by Port1");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000013, "WRD");

C("All Request are made low");
WaitLoop(0x9);
Write(EbiTrCntl, 0x00000010, "WRD");

/* In the following test Port2 gets the grant and the backoff signal at the */
/* same clock */
C("Request raised by Port1");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000011, "WRD");

C("Request raised by Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000015, "WRD");

C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000017, "WRD");

C("All Request are made low");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000010, "WRD");

/* In the following test backoffsignal are generated by two Ports */
/* simultaneously */
C("Counters are loaded with the same values");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x8, "WRD");
Write(EbiTrTimeOut3, 0x4, "WRD");

C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000012, "WRD");

C("Request raised by Port1 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000017, "WRD");

C("All request are made low");
WaitLoop(0x8);
Write(EbiTrCntl, 0x00000010, "WRD");

}

/*----=============================END====================================----*/
