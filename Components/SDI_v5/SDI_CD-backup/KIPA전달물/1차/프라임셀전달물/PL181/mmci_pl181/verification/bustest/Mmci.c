/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Mmci.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.

--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Mmci.h, Mmci.c
--
--   Usage: make <testname> e.g. make Mmci
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Mmci
--   This will create testname.bif in the ./invec directory
--
-- --=========================================================================*/

/******************************************************************************/
/***        For more information on the MMCI, please refer to PL181 AMBA    ***/
/***        MMCI Block Specification                                        ***/
/******************************************************************************/

#if defined(regtests) || defined(blocklengthtest) || defined(cpsmdisabletest) || defined(clocktest) || defined(commandfsmtestcall) || defined(dmatest) || defined(dpsmdisabletest) || defined(datacountertest) || defined(dataflagsynctest) || defined(divlevelcpsmstsynctest) || defined(fiforeceivetest) || defined(fifotransmittest) || defined(fifocountertest) || defined(fifoptrcrossovertest) || defined(interrupttests) || defined(pendingmodetest) || defined(powercontroltest) || defined(rxoverruninwaitrtest) || defined(ALL_TESTS) || defined(txdatafsmtestcall) || defined(rxdatafsmtestcall) || defined(Mmci1) || defined(Mmci2) || defined(Mmci3)
#include "MmciCommon.c"
#endif

#if defined(regtests) || defined(ALL_TESTS) || defined(Mmci1)
#include "RegTests.c"
#endif

#if defined(blocklengthtest) || defined(ALL_TESTS) || defined(Mmci1)
#include "BlockLengthTest.c"
#endif

#if defined(cpsmdisabletest) || defined(ALL_TESTS) || defined(Mmci1)
#include "CPSMDisableTest.c"
#endif

#if defined(clocktest) || defined(ALL_TESTS) || defined(Mmci1)
#include "ClockTest.c"
#endif

#if defined(commandfsmtestcall) || defined(ALL_TESTS) || defined(Mmci1)
#include "CommandFSMTestCall.c"
#endif

#if defined(dmatest) || defined(ALL_TESTS) || defined(Mmci1)
#include "DMATest.c"
#endif

#if defined(dpsmdisabletest) || defined(ALL_TESTS) || defined(Mmci1)
#include "DPSMDisableTest.c"
#endif

#if defined(datacountertest) || defined(ALL_TESTS) || defined(Mmci1)
#include "DataCounterTest.c"
#endif

#if defined(dataflagsynctest) || defined(ALL_TESTS) || defined(Mmci1)
#include "DataFlagSyncTest.c"
#endif

#if defined(divlevelcpsmstsynctest) || defined(ALL_TESTS) || defined(Mmci1)
#include "DivlevelCpsmStSyncTest.c"
#endif

#if defined(fiforeceivetest) || defined(ALL_TESTS) || defined(Mmci1)
#include "FIFOReceiveTest.c"
#endif

#if defined(fifotransmittest) || defined(ALL_TESTS) || defined(Mmci1)
#include "FIFOTransmitTest.c"
#endif

#if defined(fifocountertest) || defined(ALL_TESTS) || defined(Mmci1)
#include "FifoCounterTest.c"
#endif

#if defined(fifoptrcrossovertest) || defined(ALL_TESTS) || defined(Mmci1)
#include "FifoPtrCrossOverTest.c"
#endif

#if defined(interrupttests) || defined(ALL_TESTS) || defined(Mmci1)
#include "InterruptTests.c"
#endif

#if defined(pendingmodetest) || defined(ALL_TESTS) || defined(Mmci1)
#include "PendingModeTest.c"
#endif

#if defined(powercontroltest) || defined(ALL_TESTS) || defined(Mmci1)
#include "PowerControlTest.c"
#endif

#if defined(rxoverruninwaitrtest) || defined(ALL_TESTS) || defined(Mmci1)
#include "RxOverruninWaitRTest.c"
#endif

#if defined(rxdatafsmtestcall) || defined(ALL_TESTS) || defined(Mmci3)
#include "RxDataFSMTestCall.c"
#endif

#if defined(txdatafsmtestcall) || defined(ALL_TESTS) || defined(Mmci2)
#include "TxDataFSMTestCall.c"
#endif

/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{

  C("-----------------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2000 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C(" and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("-----------------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Mmci.c.rca",header);
  C("File Revision          : 1.3",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL181-REL1v0",header);
  C("-----------------------------------------------------------------------------",header);
   TestStart();

   RES(LOW,0x1,0x2);
   PI(0x01);
   PI(10);

   /* Calculate the number of PIs per MCLK cycle */
   if (MCLK_PERIOD < PCLK_PERIOD)
     DELAY = 1;
   else
     DELAY = MCLK_PERIOD/PCLK_PERIOD;

#if defined(regtests) || defined(ALL_TESTS) || defined(Mmci1)
  C("REGISTER TESTS");
  RegTests();
#endif

   /* Program the trickbox for the period of MCLK to be generated */
   PSW(MCLK_PERIOD , MMCITBMCLKPeriod);

   /* Assert nMCLKRST */
   PSW(MCLKRESETASSERT, MMCITBCLKRSTCntl);

   /* Wait for 2 MCLK periods */
   PI(DELAY * 0x2);

   /* De-assert nMCLKRST */
   PSW(0x00000000, MMCITBCLKRSTCntl);
   Idle(0xA * DELAY);

   if(PCLK_PERIOD == MCLK_PERIOD )
     {
      /* Route PCLK onto MCLK input of the MMCI */
      PCLKOn();
     }
   else
     {
   /* Route MCLK generated by the trickbox onto MCLK input of the MMCI */
      MCLKOn();
     }

   /* Wait for the clocks to stabilise */
   Idle(0xA * DELAY);

   /* Write operational values into the MMCIPower register and the
      MMCIClock register
   */
   PSW(0x0000003F, MMCIPower);
   PSW(0x00000101, MMCIClock);

   /* Wait for synchronisation to complete */
   Idle(0xA * DELAY);

#if defined(fifocountertest) || defined(ALL_TESTS) || defined(Mmci1)
   if (MCLK_PERIOD == PCLK_PERIOD)
   {
     C("FIFOCOUNTER TEST WHEN TRANSMITTING");
     FifoCounterTest(0x1000, 0x3, 1);
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

     C("FIFOCOUNTER TEST WHEN TRANSMITTING");
     FifoCounterTest(0x100, 0x2, 1);
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

     C("FIFOCOUNTER TEST WHEN TRANSMITTING");
     FifoCounterTest(0x1700, 0x1, 1);
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

     C("FIFOCOUNTER TEST WHEN TRANSMITTING");
     FifoCounterTest(0x1770, 0x0, 1);
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

     C("FIFOCOUNTER TEST WHEN RECEIVING");
     FifoCounterTest(0x1000, 0x3, 0);
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

     C("FIFOCOUNTER TEST WHEN RECEIVING");
     FifoCounterTest(0x100, 0x2, 0);
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

     C("FIFOCOUNTER TEST WHEN RECEIVING");
     FifoCounterTest(0x1700, 0x1, 0);
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

     C("FIFOCOUNTER TEST WHEN RECEIVING");
     FifoCounterTest(0x1770, 0x0, 0);
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
   }
#endif

#if defined(fifotransmittest) || defined(ALL_TESTS) || defined(Mmci1)
   C("FIFOTRANSMIT TEST");
   FIFOTransmitTest();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(fiforeceivetest) || defined(ALL_TESTS) || defined(Mmci1)
   C("FIFORECEIVE TEST");
   FIFOReceiveTest();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(interrupttests) || defined(ALL_TESTS) || defined(Mmci1)
   C("INTERRUPT TESTS");
   InterruptTests();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(cpsmdisabletest) || defined(ALL_TESTS) || defined(Mmci1)
   PSW(0x00010000,MMCITBPCDisable);
   C("CPSM DISABLE TESTS");
   CPSMDisableTest();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(rxoverruninwaitrtest) || defined(ALL_TESTS) || defined(Mmci1)
   C("RXOVERRUN IN WAIT_R STATE");
   RxOverruninWaitRTest();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(powercontroltest) || defined(ALL_TESTS) || defined(Mmci1)
   C("POWER CONTROL TEST");
   PowerControlTest();
#endif

#if defined(pendingmodetest) || defined(ALL_TESTS) || defined(Mmci1)
   C("PENDING MODE TESTS");
   PendingModeTest();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(divlevelcpsmstsync) || defined(ALL_TESTS) || defined(Mmci1)
   /*
   This test contains hard-coded delays to sync up two independent
   signals - DivLevel and CPSMStPulse, hence it can be run only in the
   case when the frequencies of PCLK and MCLK are equal.
   */
   if (MCLK_PERIOD == PCLK_PERIOD)
   {
     C("DIVLEVEL AND CPSM START PULSE SYNC TEST");
     DivlevelCpsmStSyncTest();
     PSW(CLEARALL, MMCIClear);
     PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
   }
#endif

#if defined(blocklengthtest) || defined(ALL_TESTS) || defined(Mmci1)
  C("DPSM TESTS FOR LARGE VALUES OF BLOCK LENGTHS");
  BlockLengthTest();
#endif

#if defined(dataflagsynctest) || defined(ALL_TESTS) || defined(Mmci1)
   C("DPSM TESTS FOR SIMULTANEOUS ASSERTION OF MULTIPLE STATUS FLAGS");
   DataFlagSyncTest();
#endif

#if defined(dpsmdisabletest) || defined(ALL_TESTS) || defined(Mmci1)
   PSW(0x00000440,MMCITBPCDisable);
   C("DPSM DISABLE TESTS");
   DPSMDisableTest();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
   PSW(0x00000000,MMCITBPCDisable);
#endif

#if defined(clocktest) || defined(ALL_TESTS) || defined(Mmci1)
   C("CLOCK CONTROL TEST");
   PSW(0x00010000,MMCITBPCDisable);
   C("CLOCK TEST WITH CLKDIV VALUE OF 3");
   ClockTest(3,0,0);

   PSW(0x00010000,MMCITBPCDisable);
   C("CLOCK CONTROL TEST WITH CLKDIV VALUE OF 4");
   ClockTest(4,0,0);

   PSW(0x00010000,MMCITBPCDisable);
   C("CLOCK CONTROL TEST IN BYPASS MODE");
   ClockTest(4,0,1);
#endif

#if defined(commandfsmtestcall) || defined(ALL_TESTS) || defined(Mmci1)
   PSW(0x00010000,MMCITBPCDisable);
   C("COMMAND FSM TESTS");
   CommandFSMTestCall();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(dmatest) || defined(ALL_TESTS) || defined(Mmci1)
   C("DMA TESTS");
   DMATest();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(datacountertest) || defined(ALL_TESTS) || defined(Mmci1)
   PSW(0x00000440,MMCITBPCDisable);

   C("DATACOUNTER TEST WITH DATACRC FAIL INDUCED WHEN TRANSMITTING");
   DataCounterTest(1, 0, 0, 0, 0, 0, 0x8);
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

   C("DATACOUNTER TEST WITH DATACRC FAIL INDUCED WHEN RECEIVING");
   DataCounterTest(0, 1, 0, 0, 0, 0, 0x20);
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

   C("DATACOUNTER TEST WITH DATATIMEOUT INDUCED WHEN TRANSMITTING");
   DataCounterTest(0, 0, 1, 0, 0, 0, 0x30);
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

   C("DATACOUNTER TEST WITH DATATIMEOUT INDUCED WHEN RECEIVING");
   DataCounterTest(0, 0, 0, 1, 0, 0, 0x34);
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

   C("DATACOUNTER TEST WITH TXUNDERRUN INDUCED");
   DataCounterTest(0, 0, 0, 0, 1, 0, 0);
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

   C("DATACOUNTER TEST WITH RXOVERRUN INDUCED");
   DataCounterTest(0, 0, 0, 0, 0, 1, 0);
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

#endif

#if defined(fifoptrcrossovertest) || defined(ALL_TESTS) || defined(Mmci1)
   C("FIFO POINTER CROSS OVER TEST");
   FifoPtrCrossOverTest();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(txdatafsmtestcall) || defined(ALL_TESTS) || defined(Mmci2)
   PSW(0x00010000,MMCITBPCDisable);
   C("DPSM TESTS WITH MMCI IN TRANSMIT MODE");
   TxDataFSMTestCall();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

#if defined(rxdatafsmtestcall) || defined(ALL_TESTS) || defined(Mmci3)
   PSW(0x00010000,MMCITBPCDisable);
   C("DPSM TESTS WITH MMCI IN RECEIVE MODE");
   RxDataFSMTestCall();
   PSW(CLEARALL, MMCIClear);
   PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
#endif

   PI(20);
   TestEnd();
   return 0;
}


/********************************* End of MAIN ********************************/

