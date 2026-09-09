/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : Sci.c.rca
--  File Revision          : 1.3
--  
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.                 
--                                                                   
--   Files required for compilation:                                
--     makefile, busheader.h, busmacros.h, busmacros.c,            
--     config.h, addargs_script,                                  
--     Sci.h, SciCommon.h, Sci.c and the following test modules:                          
--                                                              
--     Sci_Reg_Test.c
--     Sci_Debounce_Test.c
--     Sci_Activation_Deactivation_Sequence_Test.c
--     Sci_ATR_Test.c
--     Sci_Receive_Non_Back_to_Back_Test.c
--     Sci_Receive_Back_to_Back_Test.c
--     Sci_Receive_Intr_flag_Test.c
--     Sci_Receive_Parity_Test.c
--     Sci_CHTout_Intr_Test.c
--     Sci_BLKTout_Intr_Test.c
--     Sci_Synchronous_Mode_Transmit_Test.c
--     Sci_Synchronous_Mode_Receive_Test.c
--     Sci_Non_EMV_Test.c
--     Sci_CLKZ1_Test.c
--     Sci_Transmit_non_Back_to_Back_Test.c
--     Sci_Transmit_Back_to_Back_Test.c
--     Sci_Transmit_Intr_flag_Test.c
--     Sci_Transmit_Parity_Test.c
--     Sci_TXERRINTR_Test.c
--     Sci_CHGUARD_Test.c 
--     Sci_DMA_TX_Test.c      
--     Sci_DMA_RX_Test.c
--     Sci_Receive_OverRun_Test.c
--     Sci_State_Test.c
-- 
--   Usage: make <testname> e.g. make REG_TESTS, make ALL_TESTS ...               
--                                                            
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** For more information on the  Sci, please refer to PL130 AMBA  SCI      ***/
/*** Block Specification                                                    ***/
/******************************************************************************/


/******************************************************************************/
/***************** System Clock Defines ***************************************/
/******************************************************************************/

#define SCICLK_PERIOD             10 
#define PCLK_PERIOD               10 
#define Margin 0x09
#define clkmulfactor1 (1 + (SCICLK_PERIOD / PCLK_PERIOD))
#define clkmulfactor2 (1 + (PCLK_PERIOD / SCICLK_PERIOD))
#define clkmulfactor clkmulfactor1 * clkmulfactor2 
#define ErMargin 0x02 
#define DebugOn  0x01 

/******************************************************************************/
/*** Include SCI Common Type Declaration File                                                ***/
/******************************************************************************/

#include "SciCommon.h"

/******************************************************************************/
/************************* Function declarations ******************************/
/******************************************************************************/

void Reg_Test();
void Debounce_Test(int Bypass,int CLKICC_value,int ExtCount_value,
                   int DactCount_value);
void Activation_Deactivation_Sequence_Test(int ActCount_value,
                                   int DactCount_value, int CLKICC_value);
void Initialisation(int BAUD_value,int SCIVALUE_value,
                    int ATIME_value,int DTIME_value);
void ATR_Test(); 
void Receive_Non_Back_to_Back_Test(int DATA_value,int BAUD_value,
                                   int SCIVALUE_value, int SCICR0_value,
                                   int Jitter_value,int Jitter_Pattern);

void Receive_Back_to_Back_Test(int BAUD_value,int SCIVALUE_value,
                               int SCICR0_value, int Jitter_value,
                               int Jitter_Pattern );

void Receive_Intr_flag_Test();

void Receive_Parity_Test(int SCIRETRY_value, int SCITrTXPC_value, 
                         int MODE_value);

void CHTout_Intr_Test(int MODE_value, int SCICHTIME_value,
                      int SCITrTXCHG_value); 

void BLKTout_Intr_Test(int SCIBLKTIME_value,int SCITrTXBLKG_value);

void Synchronous_Mode_Transmit_Test();

void Synchronous_Mode_Receive_Test();

void Non_EMV_Test();

void CLKZ1_Test(int CLKZ1_value);

void Transmit_non_Back_to_Back_Test(int DATA_value, int BAUD_value,
                                    int SCIVALUE_value, int SCICR0_value);

void Transmit_Back_to_Back_Test(int SCICR0_value);

int Receive_Data(int SCICR0_value,int TrRdPtr);

void Transmit_Intr_flag_Test();

void Transmit_Parity_Test(int SCIRETRY_value, int SCITrRXPC_value, 
                          int MODE_value);

void TXERRINTR_Test(int DATA_value, int SCIRETRY_value, int SCITrRXPC_value, 
                    int MODE_value);

void Dma_Tx_Test();

void Dma_Rx_Test();

void CHGUARD_Test();

void ClockStop_Test(int CLKDISVAL);

void RxOverRun_Test();

void State_Test();

/******************************************************************************/
/************************** Include Function Bodies ***************************/
/******************************************************************************/

/* SmartCrd Register reset and write/read tests */
#if defined(ALL_TESTS) || defined(REG_TESTS)
#	include "Sci_Reg_Test.c"
#endif

/* Card Stable Debounce Sequence */
#if defined(ALL_TESTS) || defined(DEBOUNCE_TESTS)
#	include "Sci_Debounce_Test.c"
#endif

/* Card Activation and Deactivation Sequence Tests */
#if defined(ALL_TESTS) || defined(ACT_DEACT_TESTS)
#	include "Sci_Activation_Deactivation_Sequence_Test.c"
#endif

/* Answer-To-Reset (ATR) Sequence Tests */
#if defined(ALL_TESTS) || defined(ATR_TESTS)
#	include "Sci_ATR_Test.c"
#endif

/* Receive Non Back-to-Back Tests */
#if defined(ALL_TESTS) || defined(RX_NON_BACK_TO_BACK_TESTS)
#	include "Sci_Receive_Non_Back_to_Back_Test.c"
#endif

/* Receive Back-to-Back Tests */
#if defined(ALL_TESTS) || defined(RX_BACK_TO_BACK_TESTS)
#	include "Sci_Receive_Back_to_Back_Test.c"
#endif

/* Receive Interrupt Tests */
#if defined(ALL_TESTS) || defined(RX_INTERRUPT_TESTS)
#	include "Sci_Receive_Intr_flag_Test.c"
#endif

/* Receive Partity Tests */
#if defined(ALL_TESTS) || defined(RX_PARITY_TESTS)
#	include "Sci_Receive_Parity_Test.c"
#endif

/* Time between characters time out tests */
#if defined(ALL_TESTS) || defined(CH_TIMEOUT_TESTS)
#	include "Sci_CHTout_Intr_Test.c"
#endif

/* Time to reception of block timeout tests */
#if defined(ALL_TESTS) || defined(BLK_TIMEOUT_TESTS)
#	include "Sci_BLKTout_Intr_Test.c"
#endif

/* Synchronous SmartCard - Transmit Tests */
#if defined(ALL_TESTS) || defined(SYNC_MODE_TX_TESTS)
#	include "Sci_Synchronous_Mode_Transmit_Test.c"
#endif

/* Synchronous SmartCard - Receive Tests */
#if defined(ALL_TESTS) || defined(SYNC_MODE_RX_TESTS)
#	include "Sci_Synchronous_Mode_Receive_Test.c"
#endif

/* Non-EMV Compliant Smart Card Tests */
#if defined(ALL_TESTS) || defined(NON_EMV_TESTS)
#	include "Sci_Non_EMV_Test.c"
#endif

/* Driver configuration tests */
#if defined(ALL_TESTS) || defined(CLKZ1_TESTS)
#	include "Sci_CLKZ1_Test.c"
#endif

/* Transmit Non Back-to-Back Tests */
#if defined(ALL_TESTS) || defined(TX_NON_BACK_TO_BACK_TESTS)
#	include "Sci_Transmit_non_Back_to_Back_Test.c"
#endif

/* Transmit Back-to-Back Tests */
#if defined(ALL_TESTS) || defined(TX_BACK_TO_BACK_TESTS)
#	include "Sci_Transmit_Back_to_Back_Test.c"
#endif

/* Transmit Interrupt Tests */
#if defined(ALL_TESTS) || defined(TX_INTERRUPT_TESTS)
#	include "Sci_Transmit_Intr_flag_Test.c"
#endif

/* Transmit Parity Tests */
#if defined(ALL_TESTS) || defined(TX_PARITY_TESTS)
#	include "Sci_Transmit_Parity_Test.c"
#endif

/* Additional Character Guard Time Tests */
#if defined(ALL_TESTS) || defined(CH_GUARD_TESTS)
#	include "Sci_CHGUARD_Test.c"
#endif

/* Transmit Error Interrupt Tests */
#if defined(ALL_TESTS) || defined(TX_ERROR_INTERRUPT_TESTS)
#	include "Sci_TXERRINTR_Test.c"
#endif


/* DMA Transmit Tests */
#if defined(ALL_TESTS) || defined(DMA_TX_TESTS)
#	include "Sci_DMA_TX_Test.c"
#endif

/* DMA Receive Tests */
#if defined(ALL_TESTS) || defined(DMA_RX_TESTS)
#	include "Sci_DMA_RX_Test.c"
#endif

/* Clock Stop Tests */
#if defined(ALL_TESTS) || defined(CLOCKSTOP_TESTS)
#	include "Sci_ClockStop_Test.c"
#endif

/* Clock Stop Tests */
#if defined(ALL_TESTS) || defined(RXOVERRUN_TESTS)
#	include "Sci_Receive_OverRun_Test.c"
#endif

/* State Transition Tests */
#if defined(ALL_TESTS) || defined(STATE_TESTS)
#	include "Sci_State_Test.c"
#endif


/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

int main()
{
C("-----------------------------------------------------------------------------",header);
C("  This confidential and proprietary software may be used only",header);
C("  as authorised by a licensing agreement from ARM Limited",header);
C("    (C) COPYRIGHT 2001 ARM Limited",header);
C("        ALL RIGHTS RESERVED",header);
C("  The entire notice above must be reproduced on all authorised copies",header);
C("  and copies may only be made to the extent permitted by a",header);
C("  licensing agreement from ARM Limited.",header);
C("-----------------------------------------------------------------------------",header);
C(" ",header);
C("Version and Release Control Information:",header);
C(" ",header);
C("File Name              : Sci.c.rca",header);
C("File Revision          : 1.3",header);
C(" ",header);
C("Release Information    : PrimeCell(TM)-PL131-REL1v0",header);
C("-----------------------------------------------------------------------------",header);
 

TestStart(0x0);

RES(LOW,0x1,0x1);
PI(0x10);

#if defined(ALL_TESTS) || defined(REG_TESTS)
  C(" Register_Test ");
  Reg_Test();
#endif

/* Program the trickbox SCITrRFCK register. It is using for the REFCLK 
   generation. Also program the error margin which is required for the timing 
   calculation. 
*/  
PSW(SCICLK_PERIOD,SCITrRFCK);
PSW(ErMargin,SCITrWV);
PSW(0x00,SCITrRFCNTL);
PI(Dummyclock);
PSW(0x04,SCITrRFCNTL);
PI(Dummyclock);
PI(0x60);

/* Function declaration reproduced here for reference
   Debounce_Test(int Bypass,int CLKICC_value, int ExtCount_value,
   int DactCount_value) 
   Bypass = 0x00, internal counter will be bypassed 
*/

#if defined(ALL_TESTS) || defined(DEBOUNCE_TESTS)
  C(" Debounce_Test ");
  Debounce_Test(0x00,0x01,0x20,0x20);
  Debounce_Test(0x00,0x01,0x10,0x05);
  Debounce_Test(0x00,0x01,0x00,0x05);
#endif

/* Function declaration reproduced here for reference
   Activation_Deactivation_Sequence_Test(int ActCounter_value,
   int DactCounter_value, int CLKICC_value);  
*/

#if defined(ALL_TESTS) || defined(ACT_DEACT_TESTS)
  C(" Activation_Deactivation_Sequence_Test ");
  Activation_Deactivation_Sequence_Test(0x10,0x05,0x03);  
#endif

#if defined(ALL_TESTS) || defined(ATR_TESTS)
  C("ATR_Test");
  ATR_Test(); 
#endif

/* Function declaration reproduced here for reference
   Receive_Non_Back_to_Back_Test(int DATA_value,int BAUD_value,
   int SCIVALUE_value, int SCICR0_value, 
   int Jitter_value, int Jitter_Pattern);  
*/

#if defined(ALL_TESTS) || defined(RX_NON_BACK_TO_BACK_TESTS)
  C(" Receive_Non_Back_to_Back_Test with SENSE = 0 and ORDER = 0 ");
  Receive_Non_Back_to_Back_Test(0x55,0x04,0x05,0x00,0x0001,0x101);

  C(" Receive_Non_Back_to_Back_Test with SENSE = 1 and ORDER = 0 ");
  Receive_Non_Back_to_Back_Test(0x55,0x03,0x06,0x03,0x0000,0x000);

  C(" Receive_Non_Back_to_Back_Test with SENSE = 0 and ORDER = 1 ");
  Receive_Non_Back_to_Back_Test(0x55,0x02,0x07,0x02,0x0000,0x000); 

  C(" Receive_Non_Back_to_Back_Test with SENSE = 1 and ORDER = 1 ");
  Receive_Non_Back_to_Back_Test(0x55,0x01,0x08,0x01,0x0000,0x000);
#endif

/* Function declaration reproduced here for reference
   Receive_Back_to_Back_Test(int BAUD_value,SCIVALUE_value,int SCICR0_value,
   int Jitter_value,int Jitter_Pattern );
*/

#if defined(ALL_TESTS) || defined(RX_BACK_TO_BACK_TESTS)
  C(" Receive_Back_to_Back_Test with SENSE = 0 and ORDER = 0 ");
  Receive_Back_to_Back_Test(0x01,0x05,0x00,0x0001,0x311);

  C(" Receive_Back_to_Back_Test with SENSE = 1 and ORDER = 0 ");
  Receive_Back_to_Back_Test(0x01,0x05,0x01,0x0001,0x00F);

  C(" Receive_Back_to_Back_Test with SENSE = 0 and ORDER = 1 ");
  Receive_Back_to_Back_Test(0x01,0x05,0x03,0x0004,0x300);

  C(" Receive_Back_to_Back_Test with SENSE = 1 and ORDER = 1 ");
  Receive_Back_to_Back_Test(0x02,0x06,0x02,0x0004,0x210);
#endif

#if defined(ALL_TESTS) || defined(RX_INTERRUPT_TESTS)
  C(" Receive_Intr_flag_Test ");
  Receive_Intr_flag_Test();
#endif

/* Function declaration reproduced here for reference
   Receive_Parity_Test(int SCIRETRY_value, int SCITrTXPC_value);
*/

#if defined(ALL_TESTS) || defined(RX_PARITY_TESTS)
  C(" Receive_Parity_Test ");
  Receive_Parity_Test(0x01,0x02,0x00); 
#endif

/* Function declaration reproduced here for reference
   CHTout_Intr_Test(int MODE_value, int SCICHTIME_value,
   int SCITrTXCHG_value);  
*/

#if defined(ALL_TESTS) || defined(CH_TIMEOUT_TESTS)
  CHTout_Intr_Test(0x00,0x02,0x3);  
  C(" CHTout_Intr_Test ");
  CHTout_Intr_Test(0x01,0x02,0x3);  
#endif

/* Function declaration reproduced here for reference
   BLKTout_Intr_Test(SCIBLKTIME_value,SCITrTXBLKG_value);  
*/

#if defined(ALL_TESTS) || defined(BLK_TIMEOUT_TESTS)
  C( "BLKTout_Intr_Test" );
  BLKTout_Intr_Test(0x02,0x08);
#endif

#if defined(ALL_TESTS) || defined(SYNC_MODE_TX_TESTS)
  C(" Synchronous_Mode_Transmit_Test ");
  Synchronous_Mode_Transmit_Test();
#endif

#if defined(ALL_TESTS) || defined(SYNC_MODE_RX_TESTS)
  C( "Synchronous_Mode_Receive_Test ");
  Synchronous_Mode_Receive_Test();
#endif

#if defined(ALL_TESTS) || defined(NON_EMV_TESTS)
  C(" Non_EMV_Test ");
  Non_EMV_Test();
#endif

/* Function declaration reproduced here for reference
   CLKZ1_Test(CLKZ1_value); 
*/

#if defined(ALL_TESTS) || defined(CLKZ1_TESTS)
  C("CLKZ1_Test - Pull down mode" );
  CLKZ1_Test(0x01);
  C("CLKZ1_Test - Buffered mode" );
  CLKZ1_Test(0x00);
#endif

/* Function declaration reproduced here for reference
   Transmit_non_Back_to_Back_Test(int DATA_value, int BAUD_value,
   int SCIVALUE_value, int SCICR0_value);
*/

#if defined(ALL_TESTS) || defined(TX_NON_BACK_TO_BACK_TESTS)
  C("Transmit_non_Back_to_Back_Test with SENSE = 1 and ORDER = 0 ");
  Transmit_non_Back_to_Back_Test(0x55,0x03,0x0C,0x01);

  C("Transmit_non_Back_to_Back_Test with SENSE = 1 and ORDER = 1 ");
  Transmit_non_Back_to_Back_Test(0x55,0x0A,0x05,0x03);

  C("Transmit_non_Back_to_Back_Test with SENSE = 0 and ORDER = 1 ");
  Transmit_non_Back_to_Back_Test(0x55,0x0F,0x0F,0x02);

  C("Transmit_non_Back_to_Back_Test with SENSE = 0 and ORDER = 0 ");
  Transmit_non_Back_to_Back_Test(0x55,0x01,0x05,0x00);
#endif

/* Function declaration reproduced here for reference
   Transmit_Back_to_Back_Test(int SCICR0_value);
*/

#if defined(ALL_TESTS) || defined(TX_BACK_TO_BACK_TESTS)
  C(" Transmit_Back_to_Back_Test  with SENSE = 0 and ORDER = 0");
  Transmit_Back_to_Back_Test(0x00);

  C(" Transmit_Back_to_Back_Test  with SENSE = 1 and ORDER = 0");
  Transmit_Back_to_Back_Test(0x01);

  C(" Transmit_Back_to_Back_Test  with SENSE = 0 and ORDER = 1");
  Transmit_Back_to_Back_Test(0x02);

  C(" Transmit_Back_to_Back_Test  with SENSE = 1 and ORDER = 1");
  Transmit_Back_to_Back_Test(0x03);
#endif

#if defined(ALL_TESTS) || defined(TX_INTERRUPT_TESTS)
  C("Transmit_Intr_flag_Test");
  Transmit_Intr_flag_Test();
#endif

/* Function declaration reproduced here for reference
   Transmit_Parity_Test(SCIRETRY_value, SCITrRXPC_value, MODE_value);
*/

#if defined(ALL_TESTS) || defined(TX_PARITY_TESTS)
  C("Transmit_Parity_Test");
  Transmit_Parity_Test(0x01, 0x01, 0x01);

  C(" Transmit_Parity_Test in T0 mode ");
  Transmit_Parity_Test(0x02, 0x01, 0x01);

  C(" Transmit_Parity_Test in T1 mode ");
  Transmit_Parity_Test(0x01, 0x02, 0x00);
#endif

#if defined(ALL_TESTS) || defined(CH_GUARD_TESTS)
  C( " CHGUARD_Test ");
  CHGUARD_Test();
#endif

/* Function declaration reproduced here for reference
   TXERRINTR_Test(DATA_value, SCIRETRY_value, SCITrRXPC_value, MODE_value);
*/

#if defined(ALL_TESTS) || defined(TX_ERROR_INTERRUPT_TESTS)
  C("TXERRINTR_Test_TO_mode");
  TXERRINTR_Test(0x55, 0x07, 0x08,0x01);

  C("TXERRINTR_Test_T1_mode ");
  TXERRINTR_Test(0x1C, 0x03, 0x01,0x00);
#endif

#if defined(ALL_TESTS) || defined(DMA_TX_TESTS)
  C("DMA Transmit Test");
  Dma_Tx_Test();
#endif

#if defined(ALL_TESTS) || defined(DMA_RX_TESTS)
  C("DMA Receive Test");
  DMA_Rx_Test();
#endif

#if defined(ALL_TESTS) || defined(CLOCKSTOP_TESTS)
  C("Clock Stop Test - Clock held low  when not active");
  ClockStop_Test(0x0);
  C("Clock Stop Test - Clock held high when not active");
  ClockStop_Test(0x80);
#endif

#if defined(ALL_TESTS) || defined(RXOVERRUN_TESTS)
  C("Receive OverRun Test");
  RxOverRun_Test();
#endif

#if defined(ALL_TESTS) || defined(STATE_TESTS)
  C("State Transition Test");
  State_Test();
#endif


/* End of Tests */

TestEnd();
return 0;
}

void Initialisation(int BAUD_value,  int SCIVALUE_value, 
                    int ATIME_value, int DTIME_value)
 
{

/*
  Summary : Initialisation 
  =========================
 
  o This function Initialise SCI.
 
  o Keeping the SCIDETECT signal high for a time which is sufficient to
    generate SCICARDININTR and check whether the interrupt is generated.
 
  o Start the Card activation sequence by enabling the Start bit and check
    whether the SCICARDUPINTR is generated.
 
*/
 
int Poll_value;

/* Program the SCICLKICC register. It is used for SCICLK width calculation */
PSW(0x03,SCICLKICC);
PSW(0x03,SCITrCKICC);

/* Clear all SCI interrupts */
PSW(0x1FFF,SCIICR);
 
/* Unmask all SCI interrupts */
PSW(0x7FFF,SCIIMSC);
 
/* Enable the Bypass mode. Also write a value to the SCISTABLE register */
PSW(0x05,SCISTABLE);
PSW(0x20,SCICR1);

/* Write programmed value into the BAUD register */ 
PSW(BAUD_value,SCIBAUD);
PSW(BAUD_value,SCITrBAUD);

/* Write  programmed value into the SCIVALUE register */ 
PSW(SCIVALUE_value,SCIVALUE);
PSW(SCIVALUE_value,SCITrVALUE);

/* Write the Card activation time in SCIATIME register */ 
PSW(ATIME_value,SCIATIME);
PSW(ATIME_value,SCITrAT);
 
/* Write the Card deactivation time in SCIDTIME register */ 
PSW(DTIME_value,SCIDTIME);
PSW(DTIME_value,SCITrDT);

/* Enable the trickbox also make SCIDETECT signal to '1' */
PSW(0x2011,SCITrCR);
PI(Dummyclock);
 
/* Poll for the SCICARDININTR. 0x05 is STABLE register value */
Poll_value = 0x05 * clkmulfactor + Margin;
PO(0x1000,0x00001000,SCITrSR1,Poll_value,SCICARDININTR failed);

/* Initiate the activation sequence by writing  '1' to the Start bit */
PSW(0x01,SCICR2);
PI(Dummyclock);

/*  Poll for the  SCICARDUPINTR */
Poll_value = (ATIME_value + 1) * (0x03 + 0x01) * 0x02 * 0x03 * clkmulfactor 
             + Margin;
PO(0x0400,0x00000400,SCITrSR1,Poll_value,SCICARDUPINTR failed);

}/* End Function */
