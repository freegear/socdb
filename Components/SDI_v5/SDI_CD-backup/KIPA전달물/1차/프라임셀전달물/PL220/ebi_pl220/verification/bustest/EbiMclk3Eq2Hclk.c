/* --=========================================================================--
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
-- File Name              : EbiMclk3Eq2Hclk.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
--
-- -----------------------------------------------------------------------------
-- Purpose :
--          Memory clock3 is equal to twice HCLK. 
--         Different combination of requests generated fromt the three ports.
--
-- --=======================================================================--*/

/******************************************************************************/
/***************************** EbiMclk3Eq2Hclk ********************************/
/******************************************************************************/
void EbiMclk3Eq2Hclk()
{
 /*
  Summary: EbiMclk3Eq2Hclk
  ========================
  This test performs the following funtionalities:

  o Memory clock3 is equal to twice HCLK.
  
  o EbiReqPos3  bit is set in the EbiTrCntl register.

  o Request raised by Port3.

  o Request raised by Port1 and Port3.

  o Request raised by Port2 and Port3.

  o Request raised by Port1 and Port2.

  o Request raised by all the three Ports.

  o Request raised sequentially.

  o Port3 raises request and after one clock cyle it is pulled low.
  
  o Port has a grant and backoff signal is given to that Port.
  
  o Port is being given the grant and at the same clock it is also given a
    backoff signal.
  
  o Counter registers of two Ports are loaded with the same values and they
    raises the backoffsignal simultaneously.

  */

/* MemClk3 equal to HCLK*2 */
C("MemClk3 equal to HCLK");
Write( EbiTrClk, 0x4, "WRD");

/* Writing data in the address registers */
C("Writing down data in the address registers");
Write(EbiTrAddr1, 0xABCADAFF, "WRD");
Write(EbiTrAddr2, 0xACDADA33, "WRD");
Write(EbiTrAddr3, 0xAB3256FF, "WRD");

/* Writing data in the data enable registers */
C("Writing down data in the data enable registers");
Write(nEbiTrDataEn1, 0x7, "WRD");
Write(nEbiTrDataEn2, 0x8, "WRD");
Write(nEbiTrDataEn3, 0x1, "WRD");

/* Writing data in the data registers */
C("Writing down data in the data registers");
Write(EbiTrData1, 0xAAEEFF8A, "WRD");
Write(EbiTrData2, 0x1133AA44, "WRD");
Write(EbiTrData1, 0x8AA234CC, "WRD");

/* Writing data in the Counter registers */
C("Writing data in the Counter registers");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x6, "WRD");
Write(EbiTrTimeOut3, 0x8, "WRD");

/* In the following test request is raised by Port3 */
/* EbiReqPos3 bit is enabled */
C("Request raised by Port3 ");
Write(EbiTrCntl, 0x00000024, "WRD");

C("Port3 request made low");
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test request are raised by Port1 and Port3 */
/* EbiReqPos3 bit is enabled */
C("Request raised by Port1 and Port3");
Write(EbiTrCntl, 0x00000025, "WRD");

C("All Request are made low");
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test request are raised by Port2 and Port3 */
/* EbiReqPos3 bit is enabled */
C("Request raised from Port2 and Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000026, "WRD");

C("All Request are made low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test request are raised by Port1 and Port2 */
/* EbiReqPos3 bit is enabled */
C("Request raised from Port1 and Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000023, "WRD");

C("All Request are made low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test request are  raised by all the three Ports */
/* EbiTrPos3 is enabled */
C("Request raised by all the three Port");
WaitLoop(0x7);
Write(EbiTrCntl, 0x00000027, "WRD");

C("All Request are made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test request are raised sequentially */
/* EbiTrPos3 is enabled */
C("Request raised by Port3");
Write(EbiTrCntl, 0x00000024, "WRD");

WaitLoop(0x1);
C("Request raised by Port1");
Write(EbiTrCntl, 0x00000025, "WRD");

WaitLoop(0x1);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000027, "WRD");

WaitLoop(0x1);
C("All Request are made low ");
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test request is raised by Port3 and after a one clock */
/* cycle it is made low */
/* EbiTrPos3 is enabled */
WaitLoop(0x1);
C("Request raised by Port3");
Write(EbiTrCntl, 0x00000024, "WRD");

WaitLoop(0x1);
C("Port3 request is made low");
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test a Port has a grant and backoff signal is generated */
/* EbiTrPos3 is enabled */
WaitLoop(0x3);
C("Request raised by Port1");
Write(EbiTrCntl, 0x00000021, "WRD");

WaitLoop(0x2);
C("Request raised by Port3");
Write(EbiTrCntl, 0x00000025, "WRD");

WaitLoop(0xA);
C("All Request are made low");
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test Port is given the grant and the backoff signal */
/* at the same clock. */
/* EbiTrPos3 is enabled */
C("Request raised by Port1 ");
Write(EbiTrCntl, 0x00000021, "WRD");

C("Request raised by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000025, "WRD");

C("Request raised by Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000027, "WRD");

C("All Request are made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test Counter register of two Ports decrements downto */
/* zero simultaneously */
/* EbiTrPos3 is enabled */
C("Counters of Port1 and Port3 are loaded with the same values");
Write(EbiTrTimeOut1, 0x8,  "WRD");
Write(EbiTrTimeOut2, 0x4,  "WRD");
Write(EbiTrTimeOut3, 0x8,  "WRD");

C("Request rasied by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000022, "WRD");

C("Request raised by Port1 and Port3");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000027, "WRD");

C("All Request are made low");
WaitLoop(0x8);
Write(EbiTrCntl, 0x00000020, "WRD");

/* In the following test Counter registers are loaded with different value */
/* but the request are raised in such a fashion that the backoff signal are */
/* generated at same time */

C("Counters are loaded with different values");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x8, "WRD");
Write(EbiTrTimeOut3, 0xC, "WRD");

C("Request raised by Port1");
Write(EbiTrCntl, 0x00000021, "WRD");

C("Request raised by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000025, "WRD");

C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000027, "WRD");

C("All Request are made low");
WaitLoop(0xE);
Write(EbiTrCntl, 0x00000020, "WRD");

}

/*---=================================END=================================----*/
