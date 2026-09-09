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
-- File Name              : EbiMck1Mck3Eq2Hck.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--         MemClk1 & MemClk3 is equal to twice HCLK. 
--         Different combination of requests generated fromt the three ports.
--
--==========================================================================--*/

/******************************************************************************/
/***************************** EbiMck1Mck3Eq2Hck ******************************/
/******************************************************************************/
void EbiMck1Mck3Eq2Hck()
{
 /*
   Summary: EbiMck1Mck3Eq2Hck
   ==========================
   This test performs the following functionalities:

   o Memory Clock1 and Clock3 are made equal to twice that of HCLK.

   o EbiReqPos1  and EbiReqPos3 bit is set in the EbiTrCntl register.   

   o Request raised by Port1 and Port3 simultaneously.

   o Request raised by Port1 and Port2 simultaneously.

   o Request raised by Port2 and Port3 simultaneously.

   o Request raised by all the three Ports simultaneously.

   o Request raised sequentially.
   
   o Port has a got the grant and a backoff signal is given to the Port.

   o Request raised by Port1 and Port3 and after a delay of one clock cycle
     they are pulled low.

   o Counter registers of Port1 and Port3 are loaded with the same values
     and they decrement down to zero at the same time.

 */

/* MemClk1 and MemClk3 is equal to HCLK*2 */
C("MemClk1 and MemClk2 is equal to HCLK");
Write(EbiTrClk, 0x5, "WRD");

/* Writing data in the address registers */
C("Writing down data in the address registers");
Write(EbiTrAddr1, 0xBB434E8D, "WRD");
Write(EbiTrAddr2, 0xCAA3123E, "WRD");
Write(EbiTrAddr3, 0x1143C544, "WRD");

/* Writing data in the data enable registers */
C("Writing down data in the data enable registers");
Write(nEbiTrDataEn1, 0x00000003, "WRD");
Write(nEbiTrDataEn1, 0x0000000A, "WRD");
Write(nEbiTrDataEn1, 0x0000000E, "WRD");

/* Writing data in the data registers */
C("Writing down data in the data registers");
Write(EbiTrData1, 0xAADD458A, "WRD");
Write(EbiTrData2, 0xAA454582, "WRD");
Write(EbiTrData3, 0xA6D54421, "WRD");

/* Writing data in the Counter registers.
C("Writing down data in the Counter registers");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x6, "WRD");
Write(EbiTrTimeOut3, 0xC, "WRD");

/* In the following test request are raised by Port1 and Port3 */
/* EbiReqPos1 and EbiReqPos3 is enabled */
C("Request raised by Port1 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000002D, "WRD");

C(" Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000028, "WRD");

/* In the following test Request are raised by Port1 and Port2 */
/* EbiReqPos1 and EbiReqPos3 is enabled */
C("Request are raised by Port1 and Port2");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000002B, "WRD");

C(" Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000028, "WRD");

/* In the following test Request are raised by Port2 and Port3 */
/* EbiReqPos1 and EbiReqPos3 is enabled */
C("Request are raised by Port2 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000002E, "WRD");

C(" Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000028, "WRD");


/* In the following test Request are  raised by all the three Ports */
/* EbiReqPos1 and EbiReqPos3 is enabled */
C("Request raised by all the three Port");
WaitLoop(0x7);
Write(EbiTrCntl, 0x0000002F, "WRD");

C("All Request are pulled low");
WaitLoop(0x4);
Write(EbiTrCntl, 0x00000028, "WRD");

/* In the following test Request are raised sequentially */
/* EbiReqPos1 and EbiReqPos3 is enabled */
C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000029, "WRD");

C("Request raised by Port2");
WaitLoop(0x1);
Write(EbiTrCntl, 0x0000002B, "WRD");

C("Request raised by Port3");
WaitLoop(0x1);
Write(EbiTrCntl, 0x0000002F, "WRD");

C("All request are pulled low");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000028, "WRD");

/* In the following test Port1 has the grant and a backoff signal is */
/* given to it */
C("Request raised by Port1");
WaitLoop(0x2);
Write(EbiTrCntl, 0x00000029, "WRD");

C("Request raised by Port3");
WaitLoop(0x2);
Write(EbiTrCntl, 0x0000002D, "WRD");

C("All request are pulled low");
WaitLoop(0xA);
Write(EbiTrCntl, 0x00000028, "WRD");

/* In the following test request are raised by Port1 and Port3 */
/* After one clock cycle they are pulled low. */
/* EbiReqPos1 and EbiReqPos3 is enabled */
C("Request raised by Port1 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000002D, "WRD");

C("Request are pulled low");
WaitLoop(0x1);
Write(EbiTrCntl, 0x00000028, "WRD");

/* In the following test Counter registers of Port1 and Port3 are */
/* loaded with same values and they decrements down to zero simultaneously */
C("Counters are loaded with same values");
Write(EbiTrTimeOut1, 0x4, "WRD");
Write(EbiTrTimeOut2, 0x8, "WRD");
Write(EbiTrTimeOut3, 0x4, "WRD");

C("Request raised by Port2");
WaitLoop(0x2);
Write(EbiTrCntl, 0x0000002A, "WRD");

C("Request raised by Port1 and Port3");
WaitLoop(0x3);
Write(EbiTrCntl, 0x0000002F, "WRD");

C("All Request are pulled low");
WaitLoop(0xC);
Write(EbiTrCntl, 0x00000028, "WRD");

}
/*---==============================END=====================================---*/
