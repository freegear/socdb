/*----========================================================================--
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
-- File Name              : EbiMclk1Eq2Hclk.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--          Memory clock1 is  equal to twice HCLK. 
--          Different combination of requests generated from the three ports.
--
--==========================================================================--*/

/******************************************************************************/
/*************************** EbiMclk1Eq2Hclk **********************************/
/******************************************************************************/
void EbiMclk1Eq2Hclk()
{
 /*
  Summary: EbiMclk1Eq2Hclk
  ========================
  This test performs the following funtionalities:

  o Memory Clock is made equal to twice that of HCLK.

  o EbiReqPos1 bit is set in the EbiTrCntl register.

  o Reqest raised by Port1.

  o Request raised by Port1 and port2 simultaneously.

  o Request raised by Port1 and Port3 simultaneously.

  o Request raised by Port2 and Port 3 simultaneously.

  o Request raised by all the three Ports simultaneously.

  o Request raised sequentially.

  o Port1 raises request and after one clock cycle it is pulled low.

  o Port has a grant and backoff signal is given to that Port.

  o Counter registers of two Ports are loaded with the same values and they
    raises the backoffsignal simultaneously 
 */ 

/* MemClk1 equal to HCLK*2 */
C("MemClk equal to HCLK");
Write(EbiTrClk, 0x00000001, "WRD");

/* Writing data in the address registers */
C("Writing down data in the address registers");
Write(EbiTrAddr1, 0x20008888, "WRD");
Write(EbiTrAddr2, 0xA0D0200A, "WRD");
Write(EbiTrAddr3, 0xA0B020C0, "WRD");

/* Writing data in the data registers */
C("Writing down data in the data registers");
Write(EbiTrData1, 0xCCC0200B, "WRD");
Write(EbiTrData2, 0xCE00200E, "WRD");
Write(EbiTrData3, 0xAAACCCBB, "WRD");

/* Writing data in the data enable registers */
C("Writing down data in the data enable registers");
Write(nEbiTrDataEn1, 0x0000000A, "WRD");
Write(nEbiTrDataEn2, 0x00000005, "WRD");
Write(nEbiTrDataEn3, 0x00000002, "WRD");

/* Writing data in the Counter registers */
C("Writing down data in the data registers");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x5, "WRD");
Write(EbiTrTimeOut3, 0x6, "WRD");

/* In the following test request is raised by Port1 */
/* EbiReqPos1 bit is enabled */
C("Request raised by Port1");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000009, "WRD");

C("Port1 request is made low");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000008, "WRD");

/* In the following test request are raised by Port1 and Port2 simultaneously */
/* EbiReqPos1 bit is enabled */
C("Request raised by Port1 and Port2");
Write(EbiTrCntl, 0x0000000B, "WRD");

C("All request are made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000008, "WRD");

/* In the following test Request are raised by Port1 and Port3 simulatneously */
/* EbiReqPos1 bit is enabled */

WaitLoop(0x4);
C("Request raised by Port1 and Port3");
Write(EbiTrCntl, 0x0000000D, "WRD");

WaitLoop(0x4);
C("All requests are made low");
Write(EbiTrCntl, 0x00000008, "WRD");

/*In the following test requests are raised by Port2 and Port3 simultaneouly */
/* EbiReqPos1 bit is enabled */

WaitLoop(0x2);
Write(EbiTrCntl, 0x0000000E, "WRD");

/* Request are made low */
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000008, "WRD");

/* In the following test Request are raised by all the three Ports */
/* simultaneously */
/* EbiReqPos1 bit is enabled */
C("Request raised by all the three Ports");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000000F, "WRD");

C("All Request are made low");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000008, "WRD");

/* In the following test request are raised simultaneously */
/* EbiReqPos1 bit is enabled */
C("Request raised by port1");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000009, "WRD");

C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x0000000B, "WRD");

C("Request raised by Port3");
WaitLoop(0x1);
Write(EbiTrCntl, 0x0000000F, "WRD");

C("All Request are made low");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000008, "WRD");

/* In the following test Port1 raises request and after one clock cycle */
/* it is pulled low */
C("Request raised by Port1");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000009, "WRD");

C("Port1 request is made low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000008, "WRD");

/* In the following test Port1 has the grant and a backoff signal is */
/* being generated to it */
C("Request raised by Port1");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000009, "WRD");

C("Request raised by Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000000B, "WRD");

C("All Request are made low");
WaitLoop(0x9);
Write(EbiTrCntl, 0x00000008, "WRD");

/* In the following test Counters of two Ports are loaded with the same  */ 
/* and they generate the backoff signal at the same clock */
C("Request raised by Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000000A, "WRD");

C("Request raised by Port1 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000000F, "WRD");

C("All Request are made low");
WaitLoop(0x9);
Write(EbiTrCntl, 0x00000008, "WRD");

}
/*-- --================================ End ===============================-- */
