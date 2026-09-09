/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Kmi_free.c,v
--  File Revision          : 1.8
--
--  Release Information    : PL050-REL1v1
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file verifies Kmi functionality in the free-running mode.   */
/*           The tb_Kmi_free.vhd testbebch needs to be used to run this       */
/*           vector set.                                                      */
/*           The KMIREFCLK and the PCLK frequency in this testbench may be    */
/*           set different.                                                   */
/******************************************************************************/

/******************************************************************************/
/*** This C code file is used to generate BusTalk vectors.                  ***/
/*** BusTalk vectors are applied to the AMBA APB bus.                       ***/
/***                                                                        ***/
/*** Files required for compilation:                                        ***/
/***   makefile, busheader.h, busmacros.h, busmacros.c,                     ***/
/***   config.h, addargs_script,                                            ***/
/***   Kmi_free.h, Kmi_free.c                                               ***/
/***                                                                        ***/
/*** Usage: make <testname> e.g. make Kmi_free                              ***/
/***                                                                        ***/
/*** To create .bif formatted vectors from the BusTalk code (default)       ***/
/***   make <testname> e.g. make  Kmi_free                                  ***/
/*** This will create testname.bif in the ./invec directory                 ***/
/***                                                                        ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the Kmi, refer to the                          ***/
/*** ARM PrimeCell PS2 Keyboard/Mouse Interface PL050                       ***/
/*** Technical Reference Manual                                             ***/
/******************************************************************************/

/******************************************************************************/
/*** Include common BusTalk files                                           ***/
/******************************************************************************/
#include "busmacros.h"
#include "busheader.h"
#include "config.h"
#include <stdio.h>

/******************************************************************************/
/**************************** System Clock Defines ****************************/
/******************************************************************************/

#define KMIREFCLK_PERIOD              20 
#define PCLK_PERIOD                   20
#define DIVISOR                       0

/******************************************************************************/
/*** Include KMI header file                                                ***/
/*** for register offset definitions and mask values                        ***/
/******************************************************************************/
#include "Kmi_free.h"

/******************************************************************************/
/************************* Function declarations ******************************/
/******************************************************************************/
void RegisterTest(void);
void TransmitTest(enum op_mode mode);
void Idle(unsigned long time);
void PollmodeTransmitTest(enum op_mode mode);
void ReceiveTest(void);
void PollmodeReceiveTest(void);
void TxSeriesTest(enum op_mode mode);
void RxSeriesTest(void);
void TxRxAlternateTest(enum op_mode mode);
void TxRxRandomTest(enum op_mode mode);
void TxStateTest(enum op_mode mode);
void RxStateTest();
void WidthMeasurementTest();
void ParityErrorDetectionCheck();
void TimeoutBitTestTx(int BitNumber);
void TimeoutBitTestRx(int BitNumber);
void ScanModeTest();

/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

int main()
{
  
  C("-----------------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 1999 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("-----------------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Kmi_free.c,v",header);
  C("File Revision          : 1.8",header);
  C(" ",header);
  C("Release Information    : PL050-REL1v1",header);
  C("-----------------------------------------------------------------------------",header);

  /* The start of the Compliance test program */

  TestStart();

  RES(LOW,0x1,0x1);
  PI(0x10);
 
  PSW(KMIREFCLK_PERIOD, TB_REFCLK_PERIOD);
  PI(0x02);

  PSW(REFCLKEn, RSTMODE_REG);
  PI(0x02); 
  
  /* Setting The Synchronisation Bit*/ 
  if( KMIREFCLK_PERIOD == PCLK_PERIOD )
  {
    PSW( PCLKEn, RSTMODE_REG);
    PI(0x02); 
    PO(TB_PCLKOn, TB_PCLKOn, TB_STAT,,test_sync);
    PI(0x02);
    PSW(PCLKEn|PCLK_ENABLE, RSTMODE_REG);
    PI(4);
    PSW( RSTMODE_ENABLE|PCLKEn|PCLK_ENABLE, RSTMODE_REG);
  }
  else
  {
    PSW(REFCLKEn|PCLK_ENABLE, RSTMODE_REG);
    PI(0x02); 
    PO(TB_REFCLKOn, TB_REFCLKOn, TB_STAT,,test_sync);
    PI(0x02);
    PSW(REFCLKEn, RSTMODE_REG);
    PI(4);
    PSW(RSTMODE_ENABLE|REFCLKEn, RSTMODE_REG);
  } 

  C("Register Test");
  RegisterTest();

  /* Configure the Trick Box */
  Tb_ck_h =  40;
  Tb_ck_l = Tb_ck_h;
  Equiv_One = 8*KMIREFCLK_PERIOD*(DIVISOR + 1);
  DSO_Time  = (Tb_ck_l/8 -1) *  Equiv_One;

  PSW(DIVISOR, TB_CLKDIV);
  PSW(DIVISOR, KMIClkDiv);
  PSW(Tb_ck_h, TB_CK_H);
  PSW(Tb_ck_l, TB_CK_L);
  PSW(Equiv_One, TB_DSI);
  PSW(DSO_Time, TB_DSO);
  PSW(50, TB_DHO);
  PSW(Equiv_One, TB_RG);
 
  tx_byte_cycles =((KMIREFCLK_PERIOD * 1000) * TXBITS_WITH_MARGIN +
                           RQS_TO_SEND_TIME_WITH_MARGIN ) / PCLK_PERIOD;
 
  rx_byte_cycles = ((KMIREFCLK_PERIOD * 1000) * RXBITS_WITH_MARGIN)
                    / PCLK_PERIOD;
  
  kclk_h_cycles = (Tb_ck_h * KMIREFCLK_PERIOD * (DIVISOR + 1))/PCLK_PERIOD;

  start_pulse_cycles = ( RQS_TO_SEND_TIME * 1000) / PCLK_PERIOD;

  C("Transmit Test: PS2/AT mode");
  TransmitTest(PS2_AT_MODE);

  C("Transmit Test: LEGACY mode");
  TransmitTest(LEGACY_MODE);
  
  C("Poll Mode Transmit Test: PS2/AT mode");
  PollmodeTransmitTest(PS2_AT_MODE);

  C("Poll Mode Transmit Test: LEGACY mode");
  PollmodeTransmitTest(LEGACY_MODE);

  C("Receive Test");
  ReceiveTest();

  C("Poll Mode Receive  Test");
  PollmodeReceiveTest();

  C("Transmit Series Test: PS2/AT mode");
  TxSeriesTest(PS2_AT_MODE);

  C("Transmit Series Test: LEGACY mode");
  TxSeriesTest(LEGACY_MODE);

  C("Receive Series Test");
  RxSeriesTest();

  C("Transmit Receive Alternate Test: PS2/AT mode");
  TxRxAlternateTest(PS2_AT_MODE);
 
  C("Transmit Receive Alternate Test: LEGACY mode");
  TxRxAlternateTest(LEGACY_MODE);

  C("Transmit Receive Random Test: PS2/AT mode");
  TxRxRandomTest(PS2_AT_MODE);

  C("Transmit Receive Random Test: LEGACY mode");
  TxRxRandomTest(LEGACY_MODE);
 
  C("Transmit State Test: PS2/AT mode");
  TxStateTest(PS2_AT_MODE);

  C("Transmit State Test: LEGACY mode");
  TxStateTest(LEGACY_MODE);

  C("Receive State Test");
  RxStateTest();

  C("Parity Error Detection Check");
  ParityErrorDetectionCheck();

  C("Width Measurement Test");
  WidthMeasurementTest();
 
  C("Timeout Check during Start Bit: Receive mode");
  TimeoutBitTestRx(1);
  
  C("Timeout Check during Stop Bit: Receive mode");
  TimeoutBitTestRx(10);
  
  C("Timeout Check during Start Bit: Transmit mode");
  TimeoutBitTestTx(1);
  
  C("Timeout Check during fourth Bit: Transmit mode");
  TimeoutBitTestTx(4);
 
  C("ScanMode Pin Test");
  ScanModeTest();

  TestEnd();
  return 0;
}

/******************************************************************************/
/************************** RegisterTests *************************************/
/******************************************************************************/

void RegisterTest(void)
{
  /*
   Summary: Register Test
   ======================
   This test checks the following functionalities :
 
   o  All KMI registers are read immediately after reset to verify
      that they initialise to values mentioned in the specification.
 
   o  The KMI status registers is written with a compliment pattern of its 
      reset value . Data is read back and compared with its reset value.

   o  The Read / Writeable registers are written with patterns of 0x55, 0xAA,
      0xFF and 0xAA. Data is read back and compared with the expected pattern.
  */

  C("Reset Value Test");

  PSR(0x00, KMICR_MASK, KMICR,kbdcr);
  PSR( KMISTAT_RESET , KMISTAT_MASK, KMISTAT,kbdstat);
  PSR(0x00, KMIDATA_MASK, KMIDATA,kbddata);
  PSR(0x00, KMIClkDiv_MASK, KMIClkDiv,kbdclkdiv);

  C("Keyboard Controller Register R/O Test");
  PSW(~KMISTAT_RESET , KMISTAT_MASK, KMISTAT,kbdstatR_only);
  PSR( KMISTAT_RESET , KMISTAT_MASK, KMISTAT,kbdstatR_only);

  C("Keyboard Controller Register R/W Test");

  PSW(DATA_As, KMICR);
  PSW(DATA_As, KMIClkDiv);
  PSR(DATA_As & KMICR_MASK, KMICR_MASK, KMICR,kbdcr);
  PSR(DATA_As & KMIClkDiv_MASK, KMIClkDiv_MASK, KMIClkDiv,kbdclkdiv);

  PSW(DATA_5s, KMICR);
  PSW(DATA_5s, KMIClkDiv);
  PSR(DATA_5s & KMICR_MASK, KMICR_MASK, KMICR,kbdcr);
  PSR(DATA_5s & KMIClkDiv_MASK, KMIClkDiv_MASK, KMIClkDiv,kbdclkdiv);

  PSW(DATA_Fs, KMICR);
  PSW(DATA_Fs, KMIClkDiv);
  PSR(DATA_Fs & KMICR_MASK, KMICR_MASK, KMICR,kbdcr);
  PSR(DATA_Fs & KMIClkDiv_MASK, KMIClkDiv_MASK, KMIClkDiv,kbdclkdiv);

  PSW(DATA_0s, KMICR);
  PSW(DATA_0s, KMIClkDiv);
  PSR(DATA_0s & KMICR_MASK, KMICR_MASK, KMICR,kbdcr);
  PSR(DATA_0s & KMIClkDiv_MASK, KMIClkDiv_MASK, KMIClkDiv,kbdclkdiv);
}

/******************************************************************************/
/********************************  TRANSMIT TEST  *****************************/
/******************************************************************************/

void TransmitTest(enum op_mode mode)
{
  /*
   Summary: Transmit Test
   ======================
 
   In this test, a byte is written to the data register of the KMI.
   KMITXINTR is polled for to ascertain data transmission. 
   The received date is checked for error free reception.
  */

  int cword;

  if(mode == LEGACY_MODE)
    cword = TB_TYPE_BIT;
  else
    cword = 0x00;
 
  /* Enable the Trickbox */
  PSW(cword | TB_ENABLE, TB_CR);

  if(mode == LEGACY_MODE)
    cword = KMI_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Keyboard Controller */
  PSW(cword | KMI_ENABLE | KMI_TXINTR_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);

  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

  /* write a byte to the data register of the keyboard controller */
  PSW(0x55, KMIDATA);

  /* Check the interrupts in the trick box status register */
  PO(0x00,TB_TXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_after_write);
  PI(0x02); 

  /* Check the flags in the status register */
  PO(KMI_TXB, KMI_TXE | KMI_TXB, KMISTAT, SyncDelay,flags_after_write);
  PI(0x02); 

  /* Wait for the byte to be transmitted by polling interrupts */
  PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_INTR, TB_CHECK_PINS, tx_byte_cycles,kbd_tx_poll);

  /* Check flags now */
  PSR(KMI_TXE, KMI_TXE | KMI_TXB, KMISTAT,flags_after);

  /* Check KMITXINTR flag in KMIIR Register */
  PSR(KMITXINTR, KMIIR_MASK, KMIIR,kmiir_tx);

  /* Check the data byte */
  PSR(0x55, masks[8], TB_DR,tb_dr);

  /* Check for errors */
  PSR(0x00, TB_PARITY_ERROR, TB_STAT,tb_dr);

  PO(0x00, TB_RXBUSY, TB_STAT, 2*kclk_h_cycles,TXBUSY);

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);

}

void Idle(unsigned long time)
{
  /*
  Summary: Idle cycle insertion
  =============================
 
  Utility function to insert predetermined number of Idle cycles.
 
  */
  unsigned long i;
 
  if (time <= 2)
  {
    PI(0x02);
  }
  else
  {
   for(i=0; i< ((unsigned long)(time/2) - 1); i++)
   {
     PI(0x02);
   }
   if ((unsigned long)time % 2)
   {
     PI(0x03);
   }
   else
   {
     PI(0x02);
   }
  }
}

/******************************************************************************/
/*****************************  POLLMODE TRANSMIT TEST  ***********************/
/******************************************************************************/
void PollmodeTransmitTest(enum op_mode mode)
{
  /*
   Summary: Pollmode Transmit Test
   ===============================
 
   In this test, a byte is written to the data register of the KMI.
   KMI_TXE flag  is polled for complete data transmission. 
   The received date is checked for error free reception.
  */

  int cword;

  if(mode == LEGACY_MODE)
    cword = TB_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Trickbox */
  PSW(cword | TB_ENABLE, TB_CR);

  if(mode == LEGACY_MODE)
    cword = KMI_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Keyboard Controller */
  PSW(cword | KMI_ENABLE , KMICR);
  PI(10);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);

  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

  /* write a byte to the data register of the keyboard controller */
  PSW(0xAA, KMIDATA);

  /* Check the flags in the status register */
  PO(KMI_TXB, KMI_TXE | KMI_TXB, KMISTAT, SyncDelay,flags_after_write);
  PI(0x02);

  /* Wait for the byte to be transmitted by polling interrupts */
  PO(KMI_TXE , KMI_TXE | KMI_TXB, KMISTAT, tx_byte_cycles,kbd_tx_poll);

  /* Check flags now */
  PSR(KMI_TXE, KMI_TXE | KMI_TXB, KMISTAT,flags_after);

  /* Check the data byte */
  PSR(0xAA, masks[8], TB_DR,tb_dr);

  /* Check for errors */
  PSR(0x00, TB_PARITY_ERROR, TB_STAT,tb_dr);

  PO(0x00, TB_RXBUSY, TB_STAT, 2*kclk_h_cycles,txbusy);

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
}

/******************************************************************************/
/********************************  RECEIVE  TEST  *****************************/
/******************************************************************************/

void ReceiveTest(void)
{
  /*
   Summary: Receive  Test
   ======================
 
   In this test, a byte is written to the data register of the TrickBox.
   KMIRXINTR is polled for to ascertain data transmission. 
   The received date is checked for error free reception.
  */

  int i;

  /* Enable the Trickbox */
  PSW(TB_ENABLE, TB_CR);

  /* Enable the Keyboard Controller */
  PSW(KMI_ENABLE | KMI_TXINTR_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);
 
  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);
 
  /* Write 1 word to the Trick Box */
  PSW(DATA_5s, TB_DR);

  PO(KMI_RXB, KMI_RXB | KMI_RXF, KMISTAT, SyncDelay,Kbdstatbefore);
  PSR(KMI_RXB, KMI_RXB | KMI_RXF, KMISTAT,Kbdstatbefore);
  PI(0x02);

  /* Wait for one byte to be received */
  PO(TB_TXINTR | TB_RXINTR | TB_INTR, TB_TXINTR | TB_RXINTR | TB_INTR, TB_CHECK_PINS, rx_byte_cycles,kbd_rx_poll);
  PI(0x02);

  /* Check in KMIIR register for KMIRXINTR bit */
  PSR(KMIRXINTR | KMITXINTR, KMIIR_MASK, KMIIR,kmiir_rx);

  /* Wait for RXF flag to set */
  PO(KMI_RXF , KMI_RXF | KMI_KBC | KMI_RXB, KMISTAT, SyncDelay,flags_after);

  for(i=0; i < 100; i++)
  {
    PSR(0x00,KMI_KBC,KMISTAT,kbdstatloop);
  }

  /* Check the data byte */
  PSR(DATA_5s & masks[8], masks[8], KMIDATA,kbdata);

  /* Check  for KMIRXINTR bit to be  reset  */
  PSR(KMITXINTR , KMIIR_MASK, KMIIR,kmiir_rx);

  PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_RXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_last);
  PI(0x02);
  PO(KMI_KBC | KMI_PXD,KMI_KBC | KMI_PXD | KMI_RXF,KMISTAT, SyncDelay,kbdstatlast);

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);

}

/******************************************************************************/
/**************************  POLL MODE RECEIVE  TEST  *************************/
/******************************************************************************/
void PollmodeReceiveTest(void)
{
  /*
   Summary: Pollmode Receive Test
   ==============================
 
   In this test, a byte is written to the data register of the TrickBox.
   KMI_RXF flag  is polled for complete data transmission. 
   The received date is checked for error free reception.
  */

  int i;

  /* Enable the Trickbox */
  PSW(TB_ENABLE, TB_CR);

  /* Enable the Keyboard Controller */
  PSW(KMI_ENABLE , KMICR);
  PI(10);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);
 
  /* Check flags in the trick box status register */
  PSR(TB_KCLK | TB_KDATA , TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);
 
  /* Write 1 word to the Trick Box */
  PSW(DATA_As, TB_DR);

  /* Poll for RXB bit */
   PO(KMI_RXB, KMI_RXB | KMI_RXF, KMISTAT, SyncDelay,Kbdstatbefore);
   PSR(KMI_RXB, KMI_RXB | KMI_RXF, KMISTAT,Kbdstatbefore);
   PI(0x02);

  /* Wait for one byte to be received */
  PO(KMI_RXF , KMI_RXF | KMI_KBC | KMI_RXB, KMISTAT, rx_byte_cycles,poll_rxf_flag);
  PI(0x02);

  for(i=0; i < 100; i++)
  {
    PSR(0x00,KMI_KBC,KMISTAT,kbdstatloop);
  }

  /* Check the data byte */
  PSR(DATA_As & masks[8], masks[8], KMIDATA,kbdata);
  PI(0x02);

  /* Check for the parity error */
  PO(KMI_KBC | KMI_PXD,KMI_KBC | KMI_PXD | KMI_RXF,KMISTAT, SyncDelay,kbdstatlast);

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);

}

/******************************************************************************/
/********************************  TX SERIES TEST  ****************************/
/******************************************************************************/
void TxSeriesTest(enum op_mode mode)
{
  /*
  Summary: TxSeries Tests 
  ===========================

  These are the series of tests which test transmission  of data by the
  KMI. After completion of  transmission, this byte is read from the
  TrickBox and checked for error free reception.
  These tests are conducted using different data patterns. 
  */

  int i, reg_val;
  int cword;

  if(mode == LEGACY_MODE)
    cword = TB_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Trick box */
  PSW(cword | TB_ENABLE, TB_CR);

  if(mode == LEGACY_MODE)
    cword = KMI_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Keyboard Controller */
  PSW(cword | KMI_ENABLE | KMI_TXINTR_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  for( i = 0; i < 0x0f; i++)
  {
   /* Check the flags in the status register */
   PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);

   /* Check the interrupts in the trick box status register */
   PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

   reg_val = i | (i << 4);

   /* write a byte to the data register of the keyboard controller */
   PSW(reg_val, KMIDATA);

   /* Check the interrupts in the trick box status register */
   PO(0x00,TB_TXINTR| TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_after_write);
   PI(0x02);

   /* Check the flags in the status register */
   PO(KMI_TXB, KMI_TXE | KMI_TXB, KMISTAT, SyncDelay,flags_after_write);
   PI(0x02);

   /* Wait for the byte to be transmitted */
   PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_INTR, TB_CHECK_PINS, tx_byte_cycles,kbd_tx_poll);

   /* Check flags now */
   PSR(KMI_TXE, KMI_TXE | KMI_TXB, KMISTAT,flags_after);

   /* Check the data byte */
   PSR(reg_val, masks[8], TB_DR,tb_dr);

   /* Check for errors */
   PSR(0x00, TB_PARITY_ERROR, TB_STAT,tb_dr);

   Idle(2*kclk_h_cycles);
  }

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
}

/******************************************************************************/
/********************************  RX SERIES TEST  ****************************/
/******************************************************************************/

void RxSeriesTest(void)
{
   /*
   Summary: RxSeries Tests 
   ===========================
 
   These are the series of tests which test receiver logic of the KMI.
   The data is transmitted by the Trickbox and the received data is 
   checked for error free reception.
   These tests are conducted using different data patterns. 
   */
  int i,j, reg_val,parity;

  /* Enable the Trick box */
  PSW(TB_ENABLE, TB_CR);

  /* Enable the Keyboard Controller */
  PSW(KMI_ENABLE | KMI_TXINTR_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  for(i = 0; i < 0x0f; i++)
  {
   /* Check the flags in the status register */
   PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);

   /* Check the interrupts in the trick box status register */
   PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

   /* write a byte to the data register of the Trick box */
   PSW(i, TB_DR);

   /* Wait for one byte to be received */
   PO(TB_RXINTR | TB_TXINTR | TB_INTR, TB_RXINTR | TB_TXINTR | TB_INTR, TB_CHECK_PINS, rx_byte_cycles,poll_interrupts);
   PI(0x02);
 
   /* Check the flags in the status register */
   PO(KMI_RXF,KMI_RXF|KMI_RXB | KMI_KBC, KMISTAT, SyncDelay,flags_after_write);

   reg_val = i;
   parity = 0;
   for (j=0; j < 8; j++)
   {
    parity ^= (reg_val & 0x01) ? 1 : 0; 
    reg_val = reg_val >> 1;
   }
   parity = !parity;
   parity = parity << 2;
   PSR(parity, KMI_PXD, KMISTAT,parity_check);

   /* Check the Data byte */
   PSR(i, masks[8], KMIDATA,kbddata);

   PO(TB_TXINTR | TB_INTR, TB_RXINTR | TB_TXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_last);
   PI(0x02);
   PO(KMI_KBC | parity, KMI_KBC | KMI_RXB | KMI_PXD, KMISTAT, SyncDelay,poll1);
 
   /* Dont idle after the last byte */
   if (i < 0x0f) 
     Idle(i);
  }

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);

}

/******************************************************************************/
/**************************   TX / RX ALTERNATE TEST  *************************/
/******************************************************************************/

void TxRxAlternateTest(enum op_mode mode)
{
  /*
   Summary: TxRxAlternate Series Tests 
   ===================================
 
   o  These are the series of tests which test transmission  and receive 
   logic of the KMI. The Kmi first transmits data and subsequently it
   receives data. The KMI transmits and then receives data alternately.
   These tests are conducted for different combinations of data values. 
  */
  int i,j, reg_val,parity;
  int cword;

  if(mode == LEGACY_MODE)
    cword = TB_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Trick box */
  PSW(cword | TB_ENABLE, TB_CR);

  if(mode == LEGACY_MODE)
    cword = KMI_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Keyboard Controller */
  PSW(cword | KMI_ENABLE | KMI_TXINTR_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  for( i = 0; i < 0x0f; i++)
  {
   /* Check the flags in the status register */
   PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);

   /* Check the interrupts in the trick box status register */
   PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

   reg_val = i | (i << 4);

   /* write a byte to the data register of the keyboard controller */
   PSW(reg_val, KMIDATA);

   /* Check the interrupts in the trick box status register */
   PO(0x00,TB_TXINTR|TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_after_write);
   PI(0x02);

   /* Check the flags in the status register */
   PO(KMI_TXB, KMI_TXE | KMI_TXB, KMISTAT, SyncDelay,flags_after_write);
   PI(0x02);

   /* Wait for the byte to be transmitted */
   PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_INTR, TB_CHECK_PINS, tx_byte_cycles,kbd_tx_poll);

   /* Check flags now */
   PSR(KMI_TXE, KMI_TXE | KMI_TXB, KMISTAT,flags_after);

   /* Check the data byte */
   PSR(reg_val, masks[8], TB_DR,tb_dr);

   /* Check for errors */
   PSR(0x00, TB_PARITY_ERROR, TB_STAT,tb_dr);

   Idle(reg_val);

   /* Check the flags in the status register */
   PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);

   /* Check the interrupts in the trick box status register */
   PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

   /* write a byte to the data register of the Trick box */
   PSW(i, TB_DR);

   /* Wait for one byte to be received */
   PO(TB_RXINTR | TB_TXINTR | TB_INTR, TB_RXINTR | TB_TXINTR | TB_INTR, TB_CHECK_PINS, rx_byte_cycles,poll_interrupts);
   PI(0x02);
 
   /* Check the flags in the status register */
   PO(KMI_RXF,KMI_RXF | KMI_RXB | KMI_KBC,KMISTAT, SyncDelay,flags_after_write);
 
   reg_val = i;
   parity = 0;
   for (j=0; j < 8; j++)
   {
    parity ^= (reg_val & 0x01) ? 1 : 0; 
    reg_val = reg_val >> 1;
   }
   parity = !parity;
   parity = parity << 2;
   PSR(parity, KMI_PXD, KMISTAT,parity_check);

   /* Check the Data byte */
   PSR(i, masks[8], KMIDATA,kbddata);

   PO(TB_TXINTR | TB_INTR, TB_RXINTR | TB_TXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_last);
   PI(0x02);
   PO(KMI_KBC | parity, KMI_KBC | KMI_RXB | KMI_PXD, KMISTAT, SyncDelay,poll1);
 
   /* Dont idle after the last byte */
   if (i < 0x0f) 
     Idle(i);
  }

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
}

/******************************************************************************/
/**************************   TX / RX RANDOM TEST  ****************************/
/******************************************************************************/

void TxRxRandomTest(enum op_mode mode)
{
  /*
   Summary: TxRxRandom Series Tests 
   ================================
 
   o  These are the series of tests which test the transmit and receive 
   logic of the KMI. The Kmi first transmits one or more data and 
   thereafter it receives one or more data.

   o These tests are conducted for different combinations of data values. 

      The whole test is performed four times as follows :
      1. Tx with different data once and Rx with different data 5 times.
      2. Tx with different data 2 times and Rx with different data 4 times.
      3. Tx with different data 3 times and Rx with different data 3 times.
      4. Tx with different data 4 times and Rx with different data 2 times.
  */

  int i,j,k, reg_val,parity;
  int cword;

  if(mode == LEGACY_MODE)
    cword = TB_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Trick box */
  PSW(cword | TB_ENABLE, TB_CR);

  if(mode == LEGACY_MODE)
    cword = KMI_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Keyboard Controller */
  PSW(cword | KMI_ENABLE | KMI_TXINTR_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  for( i = 1; i < 5; i++)
  {
    for (k=0; k < i; k++)
    {
    /* Check the flags in the status register */
    PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);

    /* Check the interrupts in the trick box status register */
    PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

    reg_val = i | (i << 4);

    /* write a byte to the data register of the keyboard controller */
    PSW(reg_val, KMIDATA);

    /* Check the interrupts in the trick box status register */
    PO(0x00, TB_TXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_after_write);
    PI(0x02);

    /* Check the flags in the status register */
    PO(KMI_TXB, KMI_TXE | KMI_TXB, KMISTAT, SyncDelay,flags_after_write);
    PI(0x02);

    /* Wait for the byte to be transmitted */
    PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_INTR, TB_CHECK_PINS, tx_byte_cycles,kbd_tx_poll);

    /* Check flags now */
    PSR(KMI_TXE, KMI_TXE | KMI_TXB, KMISTAT,flags_after);

    /* Check the data byte */
    PSR(reg_val, masks[8], TB_DR,tb_dr);

    /* Check for errors */
    PSR(0x00, TB_PARITY_ERROR, TB_STAT,tb_dr);

    Idle(reg_val);
    }


    for(k = 5-i; k >= 0; k--)
    {
    /* Check the flags in the status register */
    PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);

    /* Check the interrupts in the trick box status register */
    PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

    /* write a byte to the data register of the Trick box */
    PSW(i, TB_DR);

    /* Wait for one byte to be received */
    PO(TB_RXINTR | TB_TXINTR | TB_INTR, TB_RXINTR | TB_TXINTR | TB_INTR, TB_CHECK_PINS, rx_byte_cycles,poll_interrupts);
    PI(0x02);
 
    /* Check the flags in the status register */
    PO(KMI_RXF, KMI_RXF | KMI_RXB | KMI_KBC, KMISTAT, SyncDelay,flags_after_write); 

    reg_val = i;
    parity = 0;
    for (j=0; j < 8; j++)
    {
      parity ^= (reg_val & 0x01) ? 1 : 0; 
      reg_val = reg_val >> 1;
    }
    parity = !parity;
    parity = parity << 2;
    PSR(parity, KMI_PXD, KMISTAT,parity_check);

    /* Check the Data byte */
    PSR(i, masks[8], KMIDATA,kbddata);

    PO(TB_TXINTR | TB_INTR, TB_RXINTR | TB_TXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_last);
    PI(0x02);
    PO(KMI_KBC | parity, KMI_KBC | KMI_RXB | KMI_PXD, KMISTAT, SyncDelay,poll1);
 
    /* Dont idle after the last byte */
    if (i < 0x0f) 
      Idle(i);
    }
  }

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
}

/******************************************************************************/
/*********************************  TX STATE TEST  ****************************/
/******************************************************************************/

void TxStateTest(enum op_mode mode)
{
   /*
   Summary: TxState Tests 
   ======================
 
   o  In this test a data 0x55 is written to the KMI. This is immediately
   followd by another write to the Tx register with another pattern 0xAA
   The Trickbox interrupt status bits are polled until they indicate
   that a byte has been received . It is verified that the 0x55 pattern
   is received by the Trickbox. A third data pattern 0xFF is written to
   the KMI and waited until received by the Trickbox.The data pattern
   received by the Trickbox is 0xFF and not 0xAA. This indicates that the
   KMI transmit register ignores any write to it once the register is full.
   */
  int i,j, reg_val,parity;
  int cword;

  if(mode == LEGACY_MODE)
    cword = TB_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Trick box */
  PSW(cword | TB_ENABLE, TB_CR);

  if(mode == LEGACY_MODE)
    cword = KMI_TYPE_BIT;
  else
    cword = 0x00;

  /* Enable the Keyboard Controller */
  PSW(cword | KMI_ENABLE | KMI_TXINTR_ENABLE, KMICR);
  PI(10);

  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);

  /* write a byte to the data register of the Keyboard Controller */
  PSW(DATA_5s, KMIDATA);
  PO(0x00, TB_TXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,txint0);

  PSW(DATA_As, KMIDATA);

  /* Wait for one byte to be transmitted */
  PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_INTR, TB_CHECK_PINS, tx_byte_cycles,poll_interrupts);
  PI(0x02);

  /* Write one more byte to be transmitted */
  PSW(0xff, KMIDATA);

  /* Check the previously transmitted data byte */
  PSR(DATA_5s & masks[8], masks[8], TB_DR ,tb_data);

  PO(0x00, TB_TXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,txint0);
  PI(0x02);

  /* Wait for one byte to be transmitted */
  PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_INTR, TB_CHECK_PINS, tx_byte_cycles,poll_interrupts);
  PI(0x02);

  /* Check the 2nd data byte */
  PSR(0xff, masks[8], TB_DR ,tb_data2);

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
  Idle(30*KMIREFCLK_PERIOD);
}

/******************************************************************************/
/*********************************  RX STATE TEST  ****************************/
/******************************************************************************/

void RxStateTest(void)
{
  /*
   Summary: RxState Tests 
   ======================
 
   o  In this test a data 0x55 is written to the Trickbox. The KMI status
   register is polled till data reception is detected. Now wait for
   sufficient long time without reading the data. Then a data is written
   to the KMI. The KMI should leave the intermediate wait state and
   commence transmission of the written byte The KMI status register
   is polled to ensure that it returns to the wait state after the 
   transmission is over. The data transmitted by the KMI is verified by
   reading it out of the trickbox.
  */
  int i;

  /* Enable the Trickbox */
  PSW(TB_ENABLE, TB_CR);

  /* Enable the Keyboard Controller */
  PSW(KMI_ENABLE | KMI_RXINTR_ENABLE | KMI_TXINTR_ENABLE, KMICR);
  PI(10);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstat1);
 
  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,ints1);
 
  /* Write 1 word to the Trick Box */
  PSW(DATA_5s, TB_DR);

  PO(KMI_RXB, KMI_RXB | KMI_RXF, KMISTAT, SyncDelay,kbdstat2);
  PI(0x02);

  /* Wait for one byte to be received */
  PO(TB_TXINTR | TB_RXINTR | TB_INTR, TB_TXINTR | TB_RXINTR | TB_INTR, TB_CHECK_PINS, rx_byte_cycles,kbd_rx_poll);
  PI(0x02);
  PO(KMI_RXF , KMI_RXF | KMI_KBC | KMI_RXB, KMISTAT, SyncDelay,flags_after);

  /* check that the keyboard controller stays in the wait state */
  for(i=0; i < 100; i++)
  {
    PSR(0x00,KMI_KBC,KMISTAT,kbdstatloop);
  }

  /* Write one byte of data to the keyboard controller */
  PSW(DATA_As, KMIDATA);

  /* Check whether the transmission starts */
  PO(0x00, KMI_KMI, KMISTAT, start_pulse_cycles,kbdkbd);
  PI(0x02);

  /* Wait till transmission is over */
  PO(TB_TXINTR | TB_RXINTR | TB_INTR, TB_TXINTR | TB_RXINTR | TB_INTR, TB_CHECK_PINS, tx_byte_cycles,intr);

  PI(0x02);
  PO(KMI_RXF , KMI_RXF | KMI_KBC | KMI_RXB, KMISTAT, SyncDelay,flags_after);

  /* Check that keyboard controller returns to the wait state */
  for(i=0; i < 100; i++)
  {
    PSR(0x00,KMI_KBC,KMISTAT,kbdstatloop);
  }

  /* Read out the data byte */
  PSR(DATA_5s, masks[8], KMIDATA,kbdata);
  PO(0x00, TB_RXINTR, TB_CHECK_PINS, SyncDelay,interrupts_last);
  PI(0x02);
  PO(KMI_KBC | KMI_PXD,KMI_KBC | KMI_PXD | KMI_RXF,KMISTAT, SyncDelay,kbdstatlast);
    
 /* Check the data byte */
  PSR(DATA_As, masks[8], TB_DR,tb_dr);

  /* Check for errors */
  PSR(0x00, TB_PARITY_ERROR, TB_STAT,tb_dr);

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
}

/******************************************************************************/
/*****************************   WIDTH MEASUREMENT TEST   *********************/
/******************************************************************************/

void WidthMeasurementTest(void)
{
  /*
  Summary: Width Measurement  tests
  =================================
 
  In this test different clock divisor values are written to the KMI and 
  the Trickbox. In the Trickbox KMI_DATA_WIDTH and KMI_KCLK_WIDTH bits are
  enabled to measure the width of KCLK and KDATA. If the widths are not in 
  the specified limits then corresponding errors flags are set in the 
  Trickbox status register.
 
  */
  int i;
  int32 tx_byte_cycles ;
  int clkdiv_value[] = {0xf, 0xc , 8, 4, 1, 0};

  for (i=0; i< 6; i++)
  {
   
    tx_byte_cycles =(clkdiv_value[i] + 1) *
          ((KMIREFCLK_PERIOD * 1000) * TXBITS_WITH_MARGIN +
                 RQS_TO_SEND_TIME_WITH_MARGIN ) / PCLK_PERIOD ;
  
    /* Write the value into the register */
    Equiv_One = 8*KMIREFCLK_PERIOD*(clkdiv_value[i] + 1);
    DSO_Time  = (Tb_ck_l/8 -1) *  Equiv_One;
 
    PSW(Equiv_One, TB_DSI);
    PSW(DSO_Time, TB_DSO);
    PSW(Equiv_One, TB_RG);
 
    PSW(clkdiv_value[i], KMIClkDiv);
    PSW(clkdiv_value[i], TB_CLKDIV);
    PI(10);

    /* Enable the Trick box with the width measurement */
    PSW(TB_ENABLE | TB_KDATA_WIDTH, TB_CR);

    /* Enable the Keyboard Controller */
    PSW(KMI_ENABLE | KMI_TXINTR_ENABLE , KMICR);
    PI(0x02);

    PSW(0x76, TB_STAT);

    /* Check the flags in the status register */
    PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);
  
    /* Check the interrupts in the trick box status register */
    PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);
  
    /* write a byte to the data register of the keyboard controller */
    PSW(0x55, KMIDATA);
  
    /* Check the interrupts in the trick box status register */
    PO(0x00, TB_TXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_after_write);
    PI(0x02);
  
    /* Check the flags in the status register */
    PO(KMI_TXB, KMI_TXE | KMI_TXB, KMISTAT, SyncDelay,flags_after_write);
    PI(0x02);
  
    /* Wait for the byte to be transmitted by polling interrupts */
    PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_INTR, TB_CHECK_PINS, tx_byte_cycles,kbd_tx_poll);
     
    PI(0x02);
 
    /* Check flags now */
    PO(KMI_TXE, KMI_TXE | KMI_TXB, KMISTAT,SyncDelay,flags_after);
  
    /* Check the data byte */
    PSR(0x55, masks[8], TB_DR,tb_dr);
  
    /* Check for errors */
    PO(0x00, TB_PARITY_ERROR| TB_FRAMING_ERROR| TB_KDATA_ERROR, TB_STAT,SyncDelay,TB_dr);
    PSR(0x00, TB_PARITY_ERROR| TB_FRAMING_ERROR|TB_KDATA_ERROR, TB_STAT,TB_dr);
    PI(0x01);
    
    /* Clear the error bits in the TrickBox */
    PSW(0x0f,TB_STAT);
    PI(0x01) ;

    /* Disable the Keyboard Controller */
    PSW(0x00, KMICR);
    
    /* Disable the Trick box */
    PSW(0x00, TB_CR);
    PI(10) ;
  }

  Equiv_One = 8*KMIREFCLK_PERIOD*(DIVISOR + 1);
  DSO_Time  = (Tb_ck_l/8 -1) *  Equiv_One;
 
  PSW(Equiv_One, TB_DSI);
  PSW(DSO_Time, TB_DSO);
  PSW(Equiv_One, TB_RG);

  /* Write the clock divisor value */
  PSW(DIVISOR, KMIClkDiv);
  PSW(DIVISOR, TB_CLKDIV);
  PI(10);
  Idle(tx_byte_cycles/12);

}



/******************************************************************************/
/*************************  PARITY ERROR DETECTION  TEST  *********************/
/******************************************************************************/

void ParityErrorDetectionCheck(void)
{
  /*
  Summary: Parity Error Check tests
  =================================

  In this a data frame with a parity error is sent to the KMI  from the 
  TrickBox. The parity error can be introduced by setting the PARITY_ERROR 
  bit in the KMI_FORCED_ERR register of the trickbox.
  Then the Status register is checked to see if the parity error bit is set 
  or not. If not, then the test fails.

  */
  int i;

  /* Enable the Trickbox */
  PSW(TB_ENABLE | TB_FORCED_PARITY_ERR, TB_CR);

  /* Enable the Keyboard Controller */
  PSW(KMI_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);
 
  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_before);
 
  /* Write 1 word to the Trick Box */
  PSW(DATA_5s, TB_DR);

  PO(KMI_RXB, KMI_RXB | KMI_RXF, KMISTAT, SyncDelay,kbdstatbefore);
  PI(0x02);

  /* Wait for one byte to be received */
  PO(TB_RXINTR | TB_INTR, TB_RXINTR | TB_INTR, TB_CHECK_PINS, rx_byte_cycles,kbd_rx_poll);
  PI(0x02);
  PO(KMI_RXF , KMI_RXF | KMI_KBC | KMI_RXB, KMISTAT, SyncDelay,flags_after);

  PSR(DATA_5s & masks[8], masks[8], KMIDATA,kbdata);
  PO(KMI_KBC,KMI_KBC | KMI_PXD | KMI_RXF,KMISTAT, SyncDelay,kbdstatlast);

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
}

/******************************************************************************/
/********************** TIME OUT TEST DURING RECEPTION ************************/
/******************************************************************************/

void TimeoutBitTestRx(int BitNumber)
{
  /*
  Summary: Time Out Function 
  ==========================

  A timeout condition is forced during the bit in Receive Mode.
  The KMI's timeout recovery logic is verified by this test.

  */
  int i;
  int tx_bit_time, StartTimeOut, CyclesforTimeOut;

  tx_bit_time = ((Tb_ck_h + Tb_ck_l) * KMIREFCLK_PERIOD * (DIVISOR +1 ))
                       / PCLK_PERIOD;

  StartTimeOut = tx_bit_time * BitNumber;

  PSW(0x00, TB_CLKDIV);
  PSW(0x00, KMIClkDiv);
  PI(0x02);

  /* Enable the Trickbox */
  PSW(TB_ENABLE, TB_CR);
  PSW(TIMEOUT_EN | BitNumber, TB_TIMOUT); 

  /* Enable the Keyboard Controller */
  PSW(KMI_ENABLE | KMI_TXINTR_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);
 
  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,INTERRUPTS_before);
 
  /* Write 1 word to the Trick Box */
  PSW(DATA_5s, TB_DR);

  PO(KMI_RXB, KMI_RXB | KMI_RXF, KMISTAT, SyncDelay,kbdstat2);
  PI(0x02);

  Idle(StartTimeOut);

  /* Program in bypass mode */
  PSW(STAGE_2_BYPASS_MODE | STAGE_1_BYPASS_MODE, KMITMR);
  PI(10);

  /* wait till timeout cycles are over */
  CyclesforTimeOut =(256 * KMIREFCLK_PERIOD)/ PCLK_PERIOD;

  Idle(CyclesforTimeOut);

  /* Programm in normal mode */
  PSW(0x0 , KMITMR);
  PI(10);

  PSW(0x00, TB_TIMOUT);
  PI(20);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kBDSTatbefore);

  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,interrupts_BEFORE);
    
  /* Write 1 word to the Trick Box */
  PSW(DATA_5s, TB_DR);

  PO(KMI_RXB, KMI_RXB | KMI_RXF, KMISTAT, SyncDelay,kbdstatBEFORE);
  PI(0x02);

  /* Wait for one byte to be received */
  PO(TB_TXINTR | TB_RXINTR | TB_INTR, TB_TXINTR | TB_RXINTR | TB_INTR, TB_CHECK_PINS, rx_byte_cycles,kbd_rx_poll);
  PI(0x02);
  PO(KMI_RXF , KMI_RXF | KMI_KBC | KMI_RXB, KMISTAT, SyncDelay,flags_after);

  for(i=0; i < 100; i++)
  {
    PSR(0x00,KMI_KBC,KMISTAT,kbdstatloop);
  }
  PSR(DATA_5s & masks[8], masks[8], KMIDATA,kbdata);
  PO(TB_TXINTR | TB_INTR, TB_TXINTR | TB_RXINTR | TB_INTR, TB_CHECK_PINS, SyncDelay,interrupts_last);
  PI(0x02);
  PO(KMI_KBC | KMI_PXD,KMI_KBC | KMI_PXD | KMI_RXF,KMISTAT, SyncDelay,kbdstatlast);

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
  PSW(DIVISOR, TB_CLKDIV);
  PSW(DIVISOR, KMIClkDiv);
}

/******************************************************************************/
/********************** TIME OUT TEST DURING TRANSMISSION *********************/
/******************************************************************************/

void TimeoutBitTestTx(int BitNumber)
{
  /*
  Summary: Time Out Function 
  ==========================

  A timeout condition is forced during the bit in Transmit Mode.
  The KMI's timeout recovery logic is verified by this test.

  */
  int i;
  int tx_bit_time, StartTimeOut, CyclesforTimeOut;

  tx_bit_time = ((Tb_ck_h + Tb_ck_l) * KMIREFCLK_PERIOD * (DIVISOR +1 ))
                       / PCLK_PERIOD;

  StartTimeOut = tx_bit_time * BitNumber;

  PSW(0x00, TB_CLKDIV);
  PSW(0x00, KMIClkDiv);
  PI(0x02);
 
  /* Enable the Trickbox */
  PSW(TB_ENABLE, TB_CR);
  PSW(TIMEOUT_EN | BitNumber, TB_TIMOUT); 

  /* Enable the Keyboard Controller */
  PSW(KMI_ENABLE | KMI_TXINTR_ENABLE | KMI_RXINTR_ENABLE, KMICR);
  PI(10);

  /* Check the flags in the status register */
  PSR(KMI_TXE | KMI_KMI | KMI_KBC, KMISTAT_MASK, KMISTAT,kbdstatbefore);
 
  /* Check the interrupts in the trick box status register */
  PSR(TB_KCLK | TB_KDATA | TB_TXINTR | TB_INTR, TB_CHECK_PINS_MASK, TB_CHECK_PINS,INTERRUPTS_before);
 
  /* Write 1 word to the Trick Box */
  PSW(DATA_5s, KMIDATA);
  Idle(512*KMIREFCLK_PERIOD/PCLK_PERIOD);

  PO(TB_RXBUSY, TB_RXBUSY, TB_STAT, SyncDelay,kbdstat2);
  PI(0x02);

  Idle(StartTimeOut);

  /* Program in bypass mode */
  PSW(STAGE_2_BYPASS_MODE | STAGE_1_BYPASS_MODE, KMITMR);
  PI(10);

  /* wait till timeout cycles are over */
  CyclesforTimeOut =(256 * KMIREFCLK_PERIOD)/ PCLK_PERIOD;

  PO(0x00, KMI_TXB, KMISTAT, CyclesforTimeOut,flags_after);
  
  /* Program in normal mode */
  PSW(0x0 , KMITMR);
  PI(0x02);

  PSW(0x00, TB_TIMOUT);
  PI(0x02);

  /* Check the flags in the status register */
  PSR(KMI_KMI, KMI_KMI, KMISTAT,kBDSTAtbefore);
  Idle(64*Equiv_One/PCLK_PERIOD);

  PO(TB_RXBUSY, TB_RXBUSY, TB_STAT, SyncDelay,kbdstat2);
  PI(0x02);

  /* Wait for one byte to be received */
  PO(0x00, TB_RXBUSY, TB_STAT, rx_byte_cycles,kbd_rx_poll);
  PI(0x02);
  
  PSR(DATA_5s & masks[8], masks[8], TB_DR,kbdata);
  PI(0x02);
  
  PO(KMI_TXE , KMI_TXE | KMI_TXB, KMISTAT, SyncDelay,flags_after);
  PI(0x02); 

  /* Disable the Keyboard Controller */
  PSW(0x00, KMICR);
  PI(10);

  /* Disable the Trick box */
  PSW(0x00, TB_CR);
  PSW(DIVISOR, TB_CLKDIV);
  PSW(DIVISOR, KMIClkDiv);
}

/******************************************************************************/
/*************************** SCANMODE PIN TEST ********************************/
/******************************************************************************/
 
void ScanModeTest(void)
{
  /*
  Summary: Scan Mode Test
  =======================
 
  This test is for validating the KMI scan test hold input. In this, Two
  known data patterns are written into two wriatable register. A test reset
  is asserted by setting and clearing the TESTRST bit in the KMITCR of the
  KMI. After this test reset, the two writable registers should be reset to
  their reset values. Now the same test is conducted with SCANMODE pin,
  driven HIGH. This time the two register should retain the two known data
  patterns.
 
  */

  /* Checking PCLK Domain */
 
  /* Write some data to two r/w registers */
  PSW(DATA_As, KMICR);
  PSW(DATA_5s, KMIClkDiv);
 
  /* Assert Test reset */
  PSW(TESTRST, KMITCR);
 
  /* Deassert Test reset in next cycle */
  PSW(0x00, KMITCR);

  /* Check for expected values */ 
  PSR(0x00, KMICR_MASK, KMICR,kmicr1);
  PSR(0x00, KMIClkDiv_MASK, KMIClkDiv,kmiclkdiv1);
 
  /* Now conduct the same test with scanmode asserted */
 
  /* Assert Scanmode pin */
  PSW(TB_SCANMODE, TB_CR);
 
  /* Write some data to two r/w registers */
  PSW(DATA_As, KMICR);
  PSW(DATA_5s, KMIClkDiv);
 
  /* Assert Test reset */
  PSW(TESTRST, KMITCR);
 
  /* Deassert test reset in next cycle */
  PSW(0x00, KMITCR);

  /* Check for expected values */ 
  PSR(DATA_As & KMICR_MASK, KMICR_MASK, KMICR,kmicr2);
  PSR(DATA_5s & KMIClkDiv_MASK, KMIClkDiv_MASK, KMIClkDiv,kmiclkdiv2);
  
  /* Clean Up */

  PSW(0x00, KMICR);
  PSW(0x00, TB_CR);
  PSW(0x00, KMIClkDiv);

  /* Checking REFCLK Domain */

  PSW( KMI_ENABLE | KMI_TXINTR_ENABLE |  KMI_RXINTR_ENABLE, KMICR);
  PI(0x02);

  /* Creating an event for changing the REFCLK Domain Register */
  PSW(0x55, KMIDATA);
  PI(0x02);

  PO(0x00, KMITXINTR, KMIIR, SyncDelay,InterruptPoll);
  PI(0x02);

   /* Assert Test reset */
  PSW(TESTRST, KMITCR);
 
  /* Deassert test reset in next cycle */
  PSW(0x00, KMITCR);
  PI(0x02);

  PSW( KMI_ENABLE | KMI_TXINTR_ENABLE |  KMI_RXINTR_ENABLE, KMICR);
  PI(0x02);
 
  /* Checking for expected results */ 
  PSR(KMITXINTR, KMITXINTR, KMIIR,kmiir);
  PSW(0x00, KMICR);

  /* Assert Scanmode pin */
  PSW(TB_SCANMODE, TB_CR);

  PSW( KMI_ENABLE | KMI_TXINTR_ENABLE |  KMI_RXINTR_ENABLE, KMICR);
  PI(0x02);

  /* Creating event for changing the REFCLK Domain Register */ 
  PSW(0x55, KMIDATA);
  PI(0x02);
 
  PO(0x00, KMITXINTR, KMIIR, SyncDelay,InterruptPoll);
  PI(0x02);
 
  /* Assert Test reset */
  PSW(TESTRST, KMITCR);
 
  /* Deassert test reset in next cycle */
  PSW(0x00, KMITCR);
  PI(0x02);

  /* Checking for expected results */ 
  PSR(0x00, KMITXINTR, KMIIR,kmiir);
 
  /* Clean Up */ 
  PSW(0x00, KMICR);
  PSW(0x00, TB_CR);
}

