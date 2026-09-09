/*----======================================================================----
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
-- File Name              : EbiMclkEqHclk.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--         Memory clock is kept equal to HCLK.  
--         Different combination of requests generated from the three ports.
--
-- --=======================================================================--*/

/******************************************************************************/
/**************************** EbiMclkEqHclk ***********************************/
/******************************************************************************/
void EbiMclkEqHclk()
{
 /*
  Summary: EbiMclkEqHclk
  ======================
  This test performs the following functionalities:

  o Memory Clock is kept equal to HCLK.

  o Request are raised by each Port independtly.

  o Request are raised by two Ports simultaneously.

  o Request are raised by three Ports simultaneously.

  o Request rasied by two Ports simultaneously, they are made low 
    simultaneously and next time again they are raised simultaneously.
  
  o Request are raised sequentially.

  o Request raised by a Port and at the next clock it is made low.

  o Request raised by a Port at the next clock it is made low and another 
    Port raised request.
  
  o A particular Port has the grant and backoff signal is given to that Port.

  o A Port is being given the grant and at the same clock it is also given a 
    backoff signal.
  
  o The Counter registers of two Ports decrements down to zero simultaneously.

  o Port having the grant receives the backoff signal.

  o Request are kept higher for longer duration of time.

 */ 

/* MemClk is equal to HCLK */
C("MemClk equal to HCLK");
Write(EbiTrClk, 0x00000000, "WRD");

/* Writing data in the address registers */
C("Writing down data in the address registers");
Write(EbiTrAddr1, 0xAA43458D, "WRD");
Write(EbiTrAddr2, 0xCAA3458D, "WRD");
Write(EbiTrAddr3, 0xBB43C588, "WRD");

/* Writing data in the data enable registers */
C("Writing down data in the data enable registers");
Write(nEbiTrDataEn1, 0x0000000B, "WRD");
Write(nEbiTrDataEn1, 0x0000000C, "WRD");
Write(nEbiTrDataEn1, 0x00000003, "WRD");

/* Writing data in the data registers */
C("Writing down data in the data registers");
Write(EbiTrData1, 0xAADD458A, "WRD");
Write(EbiTrData2, 0xAA454582, "WRD");
Write(EbiTrData3, 0xA6D54421, "WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x5, "WRD");
Write(EbiTrTimeOut2, 0x7, "WRD");
Write(EbiTrTimeOut3, 0xA, "WRD");

/* In the following test each Port raises request independtly */
/* Request raised by Port1 */
C("Request raised by Port1");
Write(EbiTrCntl, 0x00000001, "WRD");
                        
/* Request raised  from Port1 is made low */
WaitLoop(0x2);
C("Port1 request made low.");
Write(EbiTrCntl, 0x00000000, "WRD");

/* Request raised by Port2 */
WaitLoop(0x4);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x3);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Request raised by Port3 */ 
WaitLoop(0x5);
C("Request raised by Port3");
Write(EbiTrCntl, 0x00000004,"WRD");

/* Request raised from Port3 is made low */
WaitLoop(0x8);
C("Port3 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* In the following test request are raised by two Ports simultaneously. */
/* Request raised by Port1 and Port2 simultaneously */
WaitLoop(0x4);
C("Request raised by Port1 and Port2 simultaneously");
Write(EbiTrCntl, 0x00000003, "WRD");

/* Port1 request is made low*/
WaitLoop(0x3);
C("Port1 request made low");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Port2 request made low */
WaitLoop(0x4);
C("Request from Port2 is made low");
Write(EbiTrCntl, 0x00000000, "WRD");

/* Request from Port1 and Port3 are raised simultaneously */
WaitLoop(0x6);
C("Request from Port1 and Port3 are raised simultaneously");
Write(EbiTrCntl, 0x00000005, "WRD");

/* Port3 request made low */
WaitLoop(0x5);
C("Port3 request made low");
Write(EbiTrCntl, 0x00000001, "WRD");

WaitLoop(0x3);
C("Port1 request made low");
Write(EbiTrCntl, 0x00000000, "WRD");

/* Request from Port2 and Port3 are raised simultaneously */
WaitLoop(0xA);
C("Request from Port2 and Port3 are raised simultaneously");
Write(EbiTrCntl, 0x00000006, "WRD");

/* Port2 Request made low */
WaitLoop(0x7);
C("Port2 request made low");
Write(EbiTrCntl, 0x00000002, "WRD");

WaitLoop(0x8);
C("Port3 request made low");
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test three Ports raises requests simultaneously. */
/* Request rasied by all the three Ports */
WaitLoop(0x4);
C(" Request rasied by all the three Ports");
Write(EbiTrCntl, 0x00000007, "WRD");

/* Port1 request made low */
WaitLoop(0x6);
C("Port1 request made low");
Write(EbiTrCntl, 0x00000006, "WRD");

/* Port2 request made low */
WaitLoop(0x7);
C("Port2 request made low");
Write(EbiTrCntl, 0x00000002, "WRD");

WaitLoop(0x10);
C("All Request made low");
Write(EbiTrCntl, 0x00000000, "WRD");

/*In the following test request is  raised at the same clock when one Port */ 
/*is being degranted and another Port is being given the grant*/
C("Request raised by Port1");
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request raised by Port2 and Port1 request made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000002, "WRD");

WaitLoop(0x1);
C("Request raised by Port3");
Write(EbiTrCntl, 0x00000006, "WRD");

WaitLoop(0x3);
C("All request are made low");
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test two Ports raises request simultaneously. */
/* They are made low simultaneously and next time again they raise */
/* request simultaneously */
WaitLoop(0x2);
C("Request raised by Port1 and Port3");
Write(EbiTrCntl, 0x00000005, "WRD");

C("Requests are made low");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Request raised by Port1 and Port3");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000005, "WRD");

C("Requests are made low");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test request are raised sequentially. */
C("Request raised by port1");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000003, "WRD");

C("Request raised by Port3");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000007, "WRD");

/*In the following test request is raised by a Port it is made low and after */
/*some clock cycles the request is again made high. */ 

C("Port2 raises request");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000002, "WRD");

C("Port2 request made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Port2 request is raised again");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000007, "WRD");

C("All request are made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test Request raised by a Port at the next clock */
/* the request is made low and another Port raises request */
C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request raised by Port2 and Port1 request made low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000002, "WRD");

C("Request raised by Port3 and Port2 request made low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000004, "WRD");

C("All Request are made low");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test Request are raised by different Ports and at */
/* the very next clock cycle request are made low */
C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request made low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000002, "WRD");

C("Request made low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Request raised by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000004, "WRD");

C("Request made low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test a particular Port has the grant and backoff signal */
/* is generated to the Port */
C(" Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000001, "WRD");

C(" Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000003, "WRD");

C(" All Request are made low");
WaitLoop(0xB);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test backoff signal is given to a Port at the same clock */
/* when it is being given the grant */
C("Request raised by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000003, "WRD");

C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000005, "WRD");

C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000007, "WRD");

C("All Request made low");
WaitLoop(0x6); 
Write(EbiTrCntl, 0x00000000, "WRD");


/* In the following test  Counter register of Port2 and Port3 are */
/* loaded with same value both the Port raises the request at the same time */
/* so that the backoff signal are generated at the same time. */
C("Counters of Port2 and Port3 are loaded with the same values");
Write(EbiTrTimeOut1, 0x4,  "WRD");
Write(EbiTrTimeOut2, 0x8,  "WRD");
Write(EbiTrTimeOut3, 0x8,  "WRD");

C("Request raised by Port1");
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request raised by Port2 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x00000007, "WRD");

C("Request of Port1 and Port2 are made low");
WaitLoop(0xE);
Write(EbiTrCntl, 0x00000004, "WRD");

C("Port3 request is made low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test  Counter register of Port2 and Port3 are */
/* loaded with same value both the Port raises the request at the same time */
/* so that the backoff signal are generated at the same time. */
C("Counters of Port1 and Port2 are loaded with the same values");
Write(EbiTrTimeOut1, 0x8,  "WRD");
Write(EbiTrTimeOut2, 0x8,  "WRD");
Write(EbiTrTimeOut3, 0x4,  "WRD");

C("Request rasied by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000004, "WRD");

C("Request raised by Port1 and Port2");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000007, "WRD");

C("Port1 and Port3 request are made low");
WaitLoop(0xA);
Write(EbiTrCntl, 0x00000002, "WRD");

C("Port2 request is made low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test  Counter register of Port2 and Port3 are */
/* loaded with same value both the Port raises the request at the same time */
/* so that the backoff signal are generated at the same time. */
C("Counters of Port1 and Port3 are loaded with the same values");
Write(EbiTrTimeOut1, 0x8,  "WRD");
Write(EbiTrTimeOut2, 0x4,  "WRD");
Write(EbiTrTimeOut3, 0x8,  "WRD");

C("Request rasied by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000002, "WRD");

C("Request raised by Port1 and Port3");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000007, "WRD");

C("Port1 and Port2 request are made low");
WaitLoop(0xA);
Write(EbiTrCntl, 0x00000004, "WRD");

C("Port3 request is made low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test Counter registers are loaded with different value */
/* but the request are raised in such a fashion that the backoff signal are */
/* generated at same time */ 

C("Counters are loaded with different values");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x8, "WRD");
Write(EbiTrTimeOut3, 0xC, "WRD");

C("Request raised by Port1");
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request raised by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000005, "WRD");

C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000007, "WRD");

C("All Request are made low");
WaitLoop(0xE);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test backoff signals are generated */

C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request raised by Port2");
WaitLoop(0xA);
Write(EbiTrCntl, 0x00000003, "WRD");

C("All Request are made low");
WaitLoop(0xE);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request raised by Port3");
WaitLoop(0xB);
Write(EbiTrCntl, 0x00000005, "WRD");

C("All Request are made low");
WaitLoop(0xF);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000002, "WRD");

C("Request raised by Port3");
WaitLoop(0xA);
Write(EbiTrCntl, 0x00000006, "WRD");

C("All Request are made low");
WaitLoop(0xD);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000001, "WRD");

C("Request raised by Port2");
WaitLoop(0xA);
Write(EbiTrCntl, 0x00000003, "WRD");

C("Request raised by Port3");
WaitLoop(0xA);
Write(EbiTrCntl, 0x00000007, "WRD");

C("All Request are made low");
WaitLoop(0xE);
Write(EbiTrCntl, 0x00000000, "WRD");

/* In the following test request are raised by individual ports and */
/* are kept high for a longer duration of time. */

C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000001, "WRD");

C("Port1 Request is made low");
WaitLoop(0xE);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000002, "WRD");

C("Port2 Request is made low");
WaitLoop(0xA);
Write(EbiTrCntl, 0x00000000, "WRD");

C("Request raised by Port3");
WaitLoop(0x5);
Write(EbiTrCntl, 0x00000001, "WRD");

C("Port3 Request is made low");
WaitLoop(0xF);
Write(EbiTrCntl, 0x00000000, "WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x3FF, "WRD");
Write(EbiTrTimeOut2, 0x3FF, "WRD");
Write(EbiTrTimeOut3, 0x3FF, "WRD");

/* In the following test each Port raises request independtly */
/* Request raised by Port1 */
C("Request raised by Port1");
Write(EbiTrCntl, 0x00000001, "WRD");
                        
/* Request raised  from Port1 is made low */
WaitLoop(0x100);
WaitLoop(0x100);
WaitLoop(0x100);
WaitLoop(0x100);
C("Port1 request made low.");
Write(EbiTrCntl, 0x00000000, "WRD");

/* Request raised by Port2 */
WaitLoop(0x4);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x100);
WaitLoop(0x100);
WaitLoop(0x100);
WaitLoop(0x100);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Request raised by Port3 */ 
WaitLoop(0x5);
C("Request raised by Port3");
Write(EbiTrCntl, 0x00000004,"WRD");

/* Request raised from Port3 is made low */
WaitLoop(0x100);
WaitLoop(0x100);
WaitLoop(0x100);
WaitLoop(0x100);
C("Port3 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x1FF, "WRD");
Write(EbiTrTimeOut2, 0x1FF, "WRD");
Write(EbiTrTimeOut3, 0x1FF, "WRD");

/* Request raised by Port3 */ 
WaitLoop(0x5);
C("Request raised by Port3");
Write(EbiTrCntl, 0x00000004,"WRD");

/* Request raised from Port3 is made low */
WaitLoop(0x8);
C("Port3 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0xFF, "WRD");
Write(EbiTrTimeOut2, 0xFF, "WRD");
Write(EbiTrTimeOut3, 0xFF, "WRD");

/* Request raised by Port3 */ 
WaitLoop(0x5);
C("Request raised by Port3");
Write(EbiTrCntl, 0x00000004,"WRD");

/* Request raised from Port3 is made low */
WaitLoop(0x8);
C("Port3 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x7F, "WRD");
Write(EbiTrTimeOut2, 0x7F, "WRD");
Write(EbiTrTimeOut3, 0x7F, "WRD");

/* Request raised by Port2 */
WaitLoop(0x4);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x3);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x3F, "WRD");
Write(EbiTrTimeOut2, 0x3F, "WRD");
Write(EbiTrTimeOut3, 0x3F, "WRD");

/* Request raised by Port2 */
WaitLoop(0x4);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x3);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x1F, "WRD");
Write(EbiTrTimeOut2, 0x1F, "WRD");
Write(EbiTrTimeOut3, 0x1F, "WRD");

/* In the following test each Port raises request independtly */
/* Request raised by Port1 */
C("Request raised by Port1");
Write(EbiTrCntl, 0x00000001, "WRD");
                        
/* Request raised  from Port1 is made low */
WaitLoop(0x2);
C("Port1 request made low.");
Write(EbiTrCntl, 0x00000000, "WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0xF, "WRD");
Write(EbiTrTimeOut2, 0xF, "WRD");
Write(EbiTrTimeOut3, 0xF, "WRD");

/* Request raised by Port2 */
WaitLoop(0x4);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x3);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x7, "WRD");
Write(EbiTrTimeOut2, 0x7, "WRD");
Write(EbiTrTimeOut3, 0x7, "WRD");

/* Request raised by Port2 */
WaitLoop(0x4);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x3);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x3, "WRD");
Write(EbiTrTimeOut2, 0x3, "WRD");
Write(EbiTrTimeOut3, 0x3, "WRD");

/* Request raised by Port2 */
WaitLoop(0x4);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x3);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x2, "WRD");
Write(EbiTrTimeOut2, 0x2, "WRD");
Write(EbiTrTimeOut3, 0x2, "WRD");

/* Request raised by Port2 */
WaitLoop(0x4);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000002, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x3);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

/* Writing data in the Counter registers */
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x4, "WRD");
Write(EbiTrTimeOut3, 0x4, "WRD");

/* Request raised by Port2 */
WaitLoop(0x2);
C("Request raised by Port2");
Write(EbiTrCntl, 0x00000003, "WRD");

/* Request raised from Port2 is made low */
WaitLoop(0x3);
C("Port2 request made low.");
Write(EbiTrCntl, 0x00000000,"WRD");

}
/*------===============================END================================----*/
