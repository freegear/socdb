/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Aaci.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.
 
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Header files and C source files for AACI tests
--
--   Usage: make <testname> e.g. make txrx_fspclk_call
--       OR make all        - to compile all tests
--
--       OR make Aaci1      |   to compile selectively so as to avoid
--       OR make Aaci2      |   loading problems during 
--       OR make Aaci3      |   simulation
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Aaci
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the AACI, please refer to PL041 AMBA   ***/
/*** AACI Block Specification                                       ***/
/**********************************************************************/

/**********************************************************************/
/*** Global Variables and common functions                          ***/
/**********************************************************************/
#include "AaciCommon.c"

/**********************************************************************/
/*** Include the files required for the selected test               ***/
/**********************************************************************/
#if defined(tx_call) || defined(rx_call) || defined(txrx_fspclk_call) || defined(ALL_TESTS) || defined(aaci2)
#include "TxRx_FsPCLK_Test.c"
#endif

#if defined(txrx_fspclk_call) || defined(txrx_slpclk_call) || defined(aaci2) || defined(ALL_TESTS)
#include "LoopBack_Test.c"
#endif

#if defined(tx_call) || defined(aaci2) || defined(ALL_TESTS)
#include "Tx_Call.c"
#endif

#if defined(rx_call) || defined(aaci2) || defined(ALL_TESTS)
#include "Rx_Call.c"
#endif

#if defined(txrx_fspclk_call) || defined(aaci2) || defined(ALL_TESTS)
#include "TxRx_FsPCLK_Call.c"
#endif

#if defined(txrx_slpclk_call) || defined(aaci2) || defined(ALL_TESTS)
#include "TxRx_SlPCLK_Test.c"
#include "TxRx_SlPCLK_Call.c"
#endif

#if defined(registertest) || defined(aaci1) || defined(ALL_TESTS)
#include "RegisterTest.c"
#endif

#if defined(forcedsync) || defined(aaci1) || defined(ALL_TESTS)
#include "ForcedSync.c"
#endif

#if defined(forcedreset) || defined(aaci1) || defined(ALL_TESTS)
#include "ForcedReset.c"
#endif

#if defined(coldnwarmreset) || defined(aaci1) || defined(ALL_TESTS)
#include "ColdNWarmReset.c"
#endif

#if defined(txintrtest) || defined(interrupttest) || defined(aaci1) ||      defined(ALL_TESTS)
#include "AACITXINTRTests.c"
#endif

#if defined(rxintrtest) || defined(interrupttest) || defined(aaci1) ||      defined(ALL_TESTS)
#include "AACIRXINTRTests.c"
#endif

#if defined(orintrtest) || defined(interrupttest) || defined(aaci1) ||      defined(ALL_TESTS)
#include "AACIORINTRTests.c"
#endif

#if defined(urintrtest) || defined(interrupttest) || defined(aaci1) ||      defined(ALL_TESTS)
#include "AACIURINTRTests.c"
#endif

#if defined(txcintrtest) || defined(interrupttest) || defined(aaci1) ||     defined(ALL_TESTS)
#include "AACITXCINTRTests.c"
#endif

#if defined(rxtointrtest) || defined(interrupttest) || defined(aaci1) ||    defined(ALL_TESTS)
#include "AACIRXTOINTRTests.c"
#endif

#if defined(wintrtest) || defined(interrupttest) || defined(aaci1) ||       defined(ALL_TESTS)
#include "AACIWINTRTest.c"
#endif

#if defined(gpiointrtest) || defined(interrupttest) || defined(aaci1) ||    defined(ALL_TESTS)
#include "AACIGPIOINTRTest.c"
#endif

#if defined(snrxintrtest) || defined(interrupttest) || defined(aaci1) ||    defined(ALL_TESTS)
#include "AACISnRXINTRTests.c"
#endif

#if defined(sntxintrtest) || defined(interrupttest) || defined(aaci1) ||    defined(ALL_TESTS)
#include "AACISnTXINTRTests.c"
#endif

#if defined(rxtofeintrtest) || defined(interrupttest) || defined(aaci1)     || defined(ALL_TESTS)
#include "AACIRXTOFEINTRTests.c"
#endif

#if defined(fifopointerstest) || defined(aaci1) || defined(ALL_TESTS)
#include "FIFOPointersTest.c"
#endif

#if defined(addrrangetest) || defined(aaci1) || defined(ALL_TESTS)
#include "AddrRangeTest.c"
#endif

#if defined(datawidthcheck) || defined(aaci1) || defined(ALL_TESTS)
#include "DataWidthCheck.c"
#endif

#if defined(dmatest) || defined(aaci3) || defined(ALL_TESTS)
#include "DMATest.c"
#endif

#if defined(fifotest) || defined(aaci3) || defined(ALL_TESTS)
#include "FIFOTest.c"
#endif

/**********************************************************************/
/********************************  MAIN  ******************************/
/**********************************************************************/
int main()
{
  C("------------------------------------------------------------------ ---",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2000 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("------------------------------------------------------------------ ---",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Aaci.c.rca",header);
  C("File Revision          : 1.4",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL041-REL1v0",header);
  C("------------------------------------------------------------------ ---",header);
 
  TestStart();
  printf("-- -----------------------------------------------------------\n");
  printf("-- ** TESTS FOR AACI WITH THE AACIBITCLK PERIOD = %d ns \n",AACIBITCLK_PERIOD);
  printf("-- ** TESTS FOR AACI WITH THE PCLK PERIOD   = %d ns \n",PCLK_PERIOD);
  printf("-- ** Ensure that the PCLK period in the tbench/timing.v \n");
  printf("-- ** or timing.vhd file ..... Tclkl + Tclkh = %d ns \n",PCLK_PERIOD);
  printf("-- -----------------------------------------------------------\n");
 
  RES(LOW,0x1,0x2);
  PI(0x03);

  #if defined(registertest) || defined(aaci1) || defined(ALL_TESTS)
  RegisterTest();
  #endif

  /* Assert and negate nAACIBITCLKRST */
  nBITCLKRST();

  /* Enable AACIBITCLK */
  /* Route PCLK or Internal BITCLK from trickbox to AACIBITCLK  */
  ClockSelect();

  #if defined(forcedsync) || defined(aaci1) || defined(ALL_TESTS)
  ForcedSync();
  #endif

  #if defined(forcedreset) || defined(aaci1) || defined(ALL_TESTS)
  ForcedReset();
  #endif

  #if defined(coldnwarmreset) || defined(aaci1) || defined(ALL_TESTS)
  ColdNWarmReset();
  #endif

  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(orintrtest)
  AACIORINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(rxintrtest)
  AACIRXINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(rxtointrtest)
  AACIRXTOINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(rxtofeintrtest)
  AACIRXTOFEINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(txintrtest)
  AACITXINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(txcintrtest)
  AACITXCINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(urintrtest)
  AACIURINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(snrxintrtest)
  AACISnRXINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(sntxintrtest)
  AACISnTXINTRTests();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(gpiointrtest)
  AACIGPIOINTRTest();
  #endif
 
  #if defined(interrupttest) || defined(aaci1) || defined(ALL_TESTS) || defined(wintrtest)
  AACIWINTRTest();
  #endif
 
  #if defined(fifopointerstest) || defined(aaci1) || defined(ALL_TESTS)
  FIFOPointersTest();
  #endif

  #if defined(addrrangetest) || defined(aaci1) || defined(ALL_TESTS)
  AddrRangeTest();
  #endif

  #if defined(datawidthcheck) || defined(aaci1) || defined(ALL_TESTS)
  DataWidthCheck();
  #endif
   
  #if defined(dmatest) || defined(aaci3) || defined(ALL_TESTS)
  DMATest();
  #endif

  #if defined(fifotest) || defined(aaci3) || defined(ALL_TESTS)
  FIFOTest();
  #endif

  /* To calculate TimeOut value */
  CalculateTimeOut();

  /* AACI Transmit-only tests */
  #if defined(tx_call) || defined(aaci2) || defined(ALL_TESTS)
  if (PCLK_PERIOD <= AACIBITCLK_PERIOD)
  {
    C("AACI TRANSMIT-ONLY TESTS");
    TxSize[1] = AACI_TSIZE12;
    TxSize[2] = AACI_TSIZE16;
    TxSize[3] = AACI_TSIZE18;
    TxSize[4] = AACI_TSIZE20;
    Tx_Call(0x0);

    C("AACI TRANSMIT-ONLY TESTS IN COMPACT MODE");
    TxSize[1] = AACI_TSIZE12;
    TxSize[2] = AACI_TSIZE16;
    TxSize[3] = AACI_TSIZE12;
    TxSize[4] = AACI_TSIZE16;
    Tx_Call(AACI_CM);
  }
  #endif

  /* AACI Receive-only tests */
  #if defined(rx_call) || defined(aaci2) || defined(ALL_TESTS)
  if (PCLK_PERIOD <= AACIBITCLK_PERIOD)
  {
    C("AACI RECEIVE-ONLY TESTS");
    RxSize[1] = AACI_RSIZE12;
    RxSize[2] = AACI_RSIZE16;
    RxSize[3] = AACI_RSIZE18;
    RxSize[4] = AACI_RSIZE20;
    Rx_Call(0x0);

    C("AACI RECEIVE-ONLY TESTS IN COMPACT MODE");
    RxSize[1] = AACI_RSIZE12;
    RxSize[2] = AACI_RSIZE16;
    RxSize[3] = AACI_RSIZE12;
    RxSize[4] = AACI_RSIZE16;
    Rx_Call(AACI_CM);
  }
  #endif

  /* AACI Simultaneous Transmit-Receive tests */
  #if defined(txrx_fspclk_call) || defined(aaci2) || defined(ALL_TESTS)
  if (PCLK_PERIOD <= AACIBITCLK_PERIOD)
  {
    C("AACI SIMULTANEOUS TRANSMIT-RECEIVE TESTS");
    TxSize[1] = AACI_TSIZE12;
    TxSize[2] = AACI_TSIZE16;
    TxSize[3] = AACI_TSIZE18;
    TxSize[4] = AACI_TSIZE20;
    RxSize[1] = AACI_RSIZE12;
    RxSize[2] = AACI_RSIZE16;
    RxSize[3] = AACI_RSIZE18;
    RxSize[4] = AACI_RSIZE20;
    TxRx_FsPCLK_Call(0x0);

    C("AACI SIMULTANEOUS TRANSMIT-RECEIVE TESTS IN COMPACT MODE");
    TxSize[1] = AACI_TSIZE12;
    TxSize[2] = AACI_TSIZE16;
    TxSize[3] = AACI_TSIZE12;
    TxSize[4] = AACI_TSIZE16;
    RxSize[1] = AACI_RSIZE12;
    RxSize[2] = AACI_RSIZE16;
    RxSize[3] = AACI_RSIZE12;
    RxSize[4] = AACI_RSIZE16;
    TxRx_FsPCLK_Call(AACI_CM);
  }
  #endif

  /* AACI Simultaneous Transmit-Receive tests for the case when
     PCLK is slower than AACIBITCLK */
  #if defined(txrx_slpclk_call) || defined(aaci2) || defined(ALL_TESTS)
  if (PCLK_PERIOD > AACIBITCLK_PERIOD)
  {
    C("AACI SIMULTANEOUS TRANSMIT-RECEIVE TESTS");
    TxSize[1] = AACI_TSIZE12;
    TxSize[2] = AACI_TSIZE16;
    TxSize[3] = AACI_TSIZE18;
    TxSize[4] = AACI_TSIZE20;
    RxSize[1] = AACI_RSIZE12;
    RxSize[2] = AACI_RSIZE16;
    RxSize[3] = AACI_RSIZE18;
    RxSize[4] = AACI_RSIZE20;
    TxRx_SlPCLK_Call(0x0);

    C("AACI SIMULTANEOUS TRANSMIT-RECEIVE TESTS IN COMPACT MODE");
    TxSize[1] = AACI_TSIZE12;
    TxSize[2] = AACI_TSIZE16;
    TxSize[3] = AACI_TSIZE12;
    TxSize[4] = AACI_TSIZE16;
    RxSize[1] = AACI_RSIZE12;
    RxSize[2] = AACI_RSIZE16;
    RxSize[3] = AACI_RSIZE12;
    RxSize[4] = AACI_RSIZE16;
    TxRx_SlPCLK_Call(AACI_CM);
  }
  #endif
 
  TestEnd();
  return 0;
}
/***************************** End of MAIN ****************************/

