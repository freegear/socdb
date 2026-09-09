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
--  File Name              : Kmi_prod.c,v
--  File Revision          : 1.6
--  
--  Release Information    : PL050-REL1v1
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose  :
--             This file is used to produce BusTalk test vectors for            
--             functional verification of the Keyboard/Mouse Interface 
--             (Kmi) block using "clock enable control".
--
--             All tests in this module assume that KMIREFCLK is connected to 
--             the APB clock PCLK in the testbench.
--
--             Here, there are three parameters viz DIVVAL, DivBypass and TYPE.
--             DIVVAL and DivBypass modify the period of the internal Pulse8MHz
--             signal. 
--             TYPE selects the type of the keyboard (PS2/AT or Legacy) under 
--             test. By default, it is set to PS2/AT keyboard type ( for which 
--             TYPE = 0 ).
--             DIVVAL (Clock Divider Value) changes the period of the Pulse8MHz 
--             signal and is significant only when DivBypass is set to zero
--             When DivBypass is set to one, Pulse8MHz is held continuously
--             high and DIVVAL becomes insignificant.
-- 
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** This C code file is used to generate BusTalk and TicTalk test vectors. ***/
/*** BusTalk vectors are applied to the AMBA APB bus.                       ***/
/*** TicTalk vectors are applied to the AMBA APB via the 'ticbox'.          ***/
/***                                                                        ***/
/*** Files required for compilation:                                        ***/
/***   makefile, busheader.h, busmacros.h, busmacros.c,                     ***/
/***   config.h, addargs_script,                                            ***/
/***   Kmiheader.h, Kmi_prod.c                                              ***/
/***                                                                        ***/
/*** Usage: make <testname> e.g. make Kmi_prod                              ***/
/***                                                                        ***/
/*** To create .bif formatted vectors from the BusTalk code (default)       ***/
/***   make <testname> e.g. make Kmi_prod                                   ***/
/*** This will create testname.bif in the ./invec directory                 ***/
/***                                                                        ***/
/*** To create .tif formatted vectors from the BusTalk code                 ***/
/***                                                                        ***/
/*** edit the config.h file and include the #define TIF                     ***/
/*** setenv VECT_TYPE TIF from the unix command line                        ***/
/*** make <testname>                                                        ***/
/***                                                                        ***/
/*** This will create testname.tif in the ./invec directory                 ***/
/***                                                                        ***/
/*** Now, to return to .bif generation mode                                 ***/
/***   comment out the #define TIF in config.h                              ***/
/***   unsetenv VECT_TYPE                                                   ***/
/***   make <testname>                                                      ***/
/***                                                                        ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the Kmi, please refer to the                   ***/
/*** ARM PrimeCell PS2/AT Keyboard/Mouse Interface PL050                    ***/
/*** Technical Reference Manual                                             ***/
/******************************************************************************/

/******************************************************************************/
/* Include common BusTalk files                                               */
/******************************************************************************/

#include "busmacros.h"
#include "busheader.h"
#include "config.h"

/******************************************************************************/
/*** Include Kmi header file                                                ***/
/*** for register offset definitions and mask values                        ***/
/******************************************************************************/
#include "Kmi_prod.h"

/******************************************************************************/
/*********************** Function declarations ********************************/
/******************************************************************************/

void L(int , int32 , int32 , int32 );
void RegTest();
void CounterTest(int DIVVAL,int DivBypass);
void TX_RX(int DIVVAL,int DivBypass,int TYPE);
void TX(int DIVVAL,int DivBypass,int TYPE);
void RX(int DIVVAL,int DivBypass);

/******************************************************************************/
/****************************** MAIN ******************************************/
/******************************************************************************/

int main()

{

int DIVVAL;  
int DivBypass;  
int TYPE; 

/*********************** Programmable Parameters  *****************************/

/* DIVVAL (Clock Divider Value) changes the period of the Pulse8MHz */ 
/* signal and is significant only when DivBypass is set to zero     */

/* When DivBypass is set to one, Pulse8MHz is held continuously     */ 
/* high and DIVVAL becomes insignificant.                           */  

/* TYPE decides which type of the keyboard is being tested.         */  
/* By default, it is set to PS2/AT keyboard for which TYPE = 0      */  

DIVVAL    = 0x01;  
DivBypass = 0; 
TYPE      = 0;  
/******************************************************************************/

 C("-----------------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 1998 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("-----------------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Kmi_prod.c,v",header);
  C("File Revision          : 1.6",header);
  C(" ",header);
  C("Release Information    : PL050-REL1v1",header);
  C("-----------------------------------------------------------------------------",header);

TestStart();
RES(LOW,0x1,0x1);
PI(0x02);

C(" REGISTER TEST ");
RegTest();

C(" COUNTER TEST ");
CounterTest(DIVVAL,DivBypass);

C("TX_RX TEST");
TX_RX(DIVVAL,DivBypass,TYPE);

C("TX TEST FOR PS2/AT MODE");
TX(DIVVAL,DivBypass,0);

C("TX TEST FOR LEGACY MODE");
TX(DIVVAL,DivBypass,1);

C("RX TEST");
RX(DIVVAL,DivBypass);

TestEnd();
return 0;

}

/******************************************************************************/
/*****************************  Loop Read  ************************************/
/******************************************************************************/

void L(int n_reads, int32 expvalue, int32 Maskvalue, int32 address )
  /* Multiple read, loops for n_reads */
  /* This can be used to apply dummy reads for synchronisation purposes */
  /* by applying MaskAll for Maskvalue. */
{ 
  int i;
  for (i = 0 ;i < n_reads; i++) 
   {
     PSR(expvalue,Maskvalue,address); 
   } 
} 

/******************************************************************************/
/***************************  Register Tests   ********************************/
/******************************************************************************/
void RegTest()
{

  /*  
    Summary: Register Test  
    ====================== 
    This test checks the following functionalities:

    o  All KMI registers are read immediately after reset to verify
       that they initialise to values mentioned in the specification.
 
    o  The Read/Writeable registers are written with patterns of 0x55
       and 0xAA. Data is read back and compared with the expected pattern.
 
    o  All read only registers are written with patterns that are different
       from the reset value and then read back. An error is flagged if
       the read data is different from the reset value.
 
    o  A test value different from the reset value is written to all
       writeable registers. A reset is caused using Test Reset.
       All test registers should return the test value when read,
       but other normal registers should return reset values mentioned
       in the specifications.
  */
   
   /* Check the reset values of the registers */  

   /* Functional mode registers   */  
   PSR(0x00,NoMask,KMICR,KMICR);     
   PSR(TXE, TXB | TXE | RXB | RXF,KMISTAT,KMISTAT);     
   PSR(0x00,NoMask,KMIDATA,KMIDATA);     
   PSR(0x00,NoMask,KMICLKDIV,KMICLKDIV);     
   PSR(0x00, TXINTR | RXINTR, KMIIR, KMIIR);     

   /* Test mode registers   */  
   PSR(0x00,NoMask,KMITCR,KMITCR);     
   PSR(0x00,NoMask,KMITMR,KMITMR);     
   PSR(0x00,NoMask,KMITISR,KMITISR);     
   PSR(KMIDATAEN | KMICLKEN, KMIDATAEN | KMICLKEN | KMIINTR,KMITOCR,KMITOCR);   
   PSR(0x00,NoMask,KMISTG1,KMISTG1);     
   PSR(0x00,NoMask,KMISTG2,KMISTG2);     
   PSR(0x00,NoMask,KMISTG3,KMISTG3);     
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     

   /* Read only register test                      */ 
   /* Write a value different from the reset value */
   PSW(0xFF,KMISTAT,KMISTAT);
   PSW(0xFF,KMIIR,KMIIR);
   PSW(0xFF,KMITOCR,KMITOCR);
   PSW(0xFF,KMISTG1,KMISTG1);
   PSW(0xFF,KMISTG2,KMISTG2);
   PSW(0xFF,KMISTG3,KMISTG3);
   PSW(0xFF,KMISTATE,KMISTATE);

   /* A read should still return the reset value and not the previously */
   /* written value                                                     */
   PSR(TXE, TXB | TXE | RXB | RXF,KMISTAT,KMISTAT);     
   PSR(0x00, TXINTR | RXINTR, KMIIR, KMIIR);     
   PSR(KMIDATAEN | KMICLKEN, KMIDATAEN | KMICLKEN | KMIINTR,KMITOCR,KMITOCR);
   PSR(0x00,NoMask,KMISTG1,KMISTG1);     
   PSR(0x00,NoMask,KMISTG2,KMISTG2);     
   PSR(0x00,NoMask,KMISTG3,KMISTG3);     
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     
 
   /* Read / Write test for normal registers */ 
   PSW(0x55,KMICR,KMICR);
   PSR(0x55,0x3F,KMICR,KMICR);
   PSW(0xAA,KMICR,KMICR);
   PSR(0xAA,0x3F,KMICR,KMICR);
   PSW(0x55,KMICLKDIV,KMICLKDIV);
   /* Dummy cycles to synchronise to REFCLK domain */ 
   L(8,MaskAll,MaskAll,KMITCER); 
   PSR(0x55,CLKDIV,KMICLKDIV,KMICLKDIV);
   PSW(0xAA,KMICLKDIV,KMICLKDIV);
   /* Dummy cycles to synchronise to REFCLK domain */ 
   L(8,MaskAll,MaskAll,KMITCER); 
   PSR(0xAA,CLKDIV,KMICLKDIV,KMICLKDIV);

   /* Assert TESTRST. This should reset all normal-mode registers.    */
 
   PSW(TESTRST,KMITCR,KMITCR);
   PSW(0x00,KMITCR,KMITCR);
   PSR(0x00,NoMask,KMICR,KMICR);     
   PSR(TXE,TXB | TXE | RXB | RXF,KMISTAT,KMISTAT);     
   PSR(0x00,NoMask,KMIDATA,KMIDATA);     
   PSR(0x00,NoMask,KMIDATA,KMIDATA);     
   PSR(0x00,NoMask,KMICLKDIV,KMICLKDIV);     
   PSR(0x00, TXINTR |  RXINTR, KMIIR, KMIIR);     
    
   /* Read / Write test for Test registers */
   PSW(0x55,KMITCR,KMITCR);  
   PSR(0x55,0x1F,KMITCR,KMITCR);  
   PSW(0xAA,KMITCR,KMITCR);  
   PSR(0xAA,0x1F,KMITCR,KMITCR);  
   PSW(0x55,KMITMR,KMITMR);  
   PSR(0x55,0x0F,KMITMR,KMITMR);  
   PSW(0xAA,KMITMR,KMITMR);  
   PSR(0xAA,0x0F,KMITMR,KMITMR);  
   PSW(0x55,KMITISR,KMITISR);  
   PSR(0x55,0x03,KMITISR,KMITISR);  
   PSW(0xAA,KMITISR,KMITISR);  
   PSR(0xAA,0x03,KMITISR,KMITISR);  
 
   /* Assert TESTRST.                                          */
   /* Note that the Test registers should be unaffected by the */
   /* assertion of TESTRST                                     */
 
   PSW(0xFF,KMITCR,KMITCR);  
   PSW(0xFF,KMITMR,KMITMR);  
   PSW(0xFF,KMITISR,KMITISR);  

   /* Apply the TESTRST for one PCLK period */ 
   PSW(TESTRST,KMITCR,KMITCR); 
   PSW(0x00,KMITCR,KMITCR); 

   /* Test registers return only previously written values */ 
   /* not the reset values of the test registers           */ 

   PSR(0x00,0x1F,KMITCR,KMITCR);  
   PSR(0xFF,0x0F,KMITMR,KMITMR);  
   PSR(0xFF,0x03,KMITISR,KMITISR);  
   
  /* Register Tests complete. */

  /* Clean up and ensure that the control state machine is in the  */
  /* Reset State when exiting from this test                       */
    
  /* Set TESTINPSEL to drive KmiClkIn from the KMITISR register */  
     
  PSW(TESTINPSEL,KMITCR,KMITCR); 
  PSW(0x00,KMITISR,KMITISR);

  /* Apply TESTRST for one PCLK period */ 
  PSW(TESTINPSEL | TESTRST,KMITCR,KMITCR); 
  PSW(TESTINPSEL,KMITCR,KMITCR); 
 
  /* Assert KmiClkIn for three EightMHz Pulse periods            */
  /* so that it is detected as a valid pulse and disable the Kmi */ 
  L(5,MaskAll,MaskAll,KMITCER);  
  PSW(0x00,KMICR,KMICR);
  
}

/******************************************************************************/
/************************ Timer - Counter Tests *******************************/
/******************************************************************************/

void CounterTest(int DIVVAL,int DivBypass)
{
   /*   
     Summary:Timer-Counter Test    
     ==========================
     This following test checks the timers / counters both in normal and 
     nibble mode.  
    
     o The KMISTG2 counter is tested by bypassing the KMISTG1. 

     o The KMISTG3 counter is tested by bypassing both KMISTG2 and KMISTG2. 

     o Prior to starting of test, all counters are placed in nibble mode. 

     o The test is conducted in the REG CLK mode.  

     o The counters are initialised by test reset and incremented by accessing 
       the KMITCER register.
 
     o The value of the counter is read from KMISTG1, KMISTG2 and KMISTG3 
       registers.

     o During the test, the 64 usec and 16 msec taps of the counter are 
       checked from KMISTG2 register.
  
     o All the counters are checked in normal mode as well. 

   */
   
   int EightMHz;
   
   EightMHz = (DIVVAL & 0x0F) + 1;

   /* Put CounterStg1 and CounterStg3 in nibble mode.         */
   /* All three counter stages count individually with their  */
   /* count enable inputs asserted continuously high.         */
   /* Switch to REGCLK Mode and set the TESTINPSEL bit to     */ 
   /* drive KmiClkIn and KmiDataIn from the KMITISR register. */ 
   /* Drive the KmiClkIn and KmiDataIn line low to keep the   */
   /* state M/c in the Reset state.                           */ 
   PSW(TESTINPSEL | TESTRST | TESTCLKEN | TESTEN,KMITCR,KMITCR); 
   PSW(TESTINPSEL | TESTCLKEN | TESTEN,KMITCR,KMITCR); 
   PSW(Stg2Bypass | S3NIB | Stg1Bypass | S1NIB ,KMITMR,KMITMR);  
    
   /* Dummy cycles for synchronisation */
   L(5,MaskAll,MaskAll,KMITCER);

   /* Load a Clock Divider value into the KMICLKDIV register and  */ 
   /* apply dummy cycles to synchronise                           */
   if (DivBypass == 0)
     {  
      PSW(DIVVAL,KMICLKDIV,KMICLKDIV)
      L(3,MaskAll,MaskAll,KMITCER);  
     } 

   /* Enable the Kmi */    
   PSW(KMIEN,KMICR,KMICR);   

   /* Dummy cycles for synchronisation */
   L(2,MaskAll,MaskAll,KMITCER);

   PSW(TESTINPSEL | TESTEN | TESTCLKEN | REGCLK,KMITCR);  

   /* Increment all the three counter stages by accessing the KMITCER       */ 
   /* register and check the counter values and 64us & 16ms timeout signals */
    
   /* Dummy cycles for synchronisation */ 
   if(DivBypass == 0 && DIVVAL == 1)  
      L(2*EightMHz  - 3,MaskAll,MaskAll,KMITCER);

   if(DivBypass == 0 && DIVVAL > 2) 
     L(EightMHz    - 3 ,MaskAll,MaskAll,KMITCER);


   PSR(0x11,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x01,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x11,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x01,KMITCER + 0x04,KMITCER);   
   PSR(0x22,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x02,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x22,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x02,KMITCER + 0x08,KMITCER);   
   PSR(0x33,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x03,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x33,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x03,KMITCER + 0x0C,KMITCER);   
   PSR(0x04,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x04,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x44,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x04,KMITCER + 0x10,KMITCER);   
   PSR(0x15,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x05,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x55,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x05,KMITCER + 0x14,KMITCER);   
   PSR(0x26,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x06,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x66,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x06,KMITCER + 0x18,KMITCER);   
   PSR(0x37,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x07,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x77,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x07,KMITCER + 0x1C,KMITCER);   
   PSR(0x08,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(us_64 | 0x00,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x88,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x08,KMITCER + 0x20,KMITCER);   
   PSR(0x01,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x99,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x09,KMITCER + 0x24,KMITCER);   
   PSR(0x2A,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x02,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xAA,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x0A,KMITCER + 0x28,KMITCER);   
   PSR(0x3B,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x03,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xBB,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x0B,KMITCER + 0x2C,KMITCER);   
   PSR(0x0C,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x04,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xCC,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x0C,KMITCER + 0x30,KMITCER);   
   PSR(0x1D,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x05,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xDD,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x0D,KMITCER + 0x34,KMITCER);   
   PSR(0x2E,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x06,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xEE,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x0E,KMITCER + 0x38,KMITCER);   
   PSR(0x3F,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x07,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xFF,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0x0F,KMITCER + 0x3C,KMITCER);   
   PSR(0x00,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(ms_16 | us_64 | 0x00,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2)
   PSR(0x00,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x00,KMITCER);   
   PSR(0x11,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x01,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x11,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x04,KMITCER);   
   PSR(0x22,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x02,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2); 
   PSR(0x22,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x08,KMITCER);   
   PSR(0x33,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x03,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);
   PSR(0x33,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x0C,KMITCER);   
   PSR(0x04,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x04,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x44,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x10,KMITCER);   
   PSR(0x15,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x05,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x55,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x14,KMITCER);   
   PSR(0x26,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x06,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x66,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x18,KMITCER);   
   PSR(0x37,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x07,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x77,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x1C,KMITCER);   
   PSR(0x08,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(us_64 | 0x00,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x88,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x20,KMITCER);   
   PSR(0x19,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x01,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x99,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x24,KMITCER);   
   PSR(0x2A,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x02,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xAA,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x28,KMITCER);   
   PSR(0x3B,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x03,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xBB,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x2C,KMITCER);   
   PSR(0x0C,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x04,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xCC,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x30,KMITCER);   
   PSR(0x1D,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x05,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xDD,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x34,KMITCER);   
   PSR(0x2E,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x06,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xEE,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x38,KMITCER);   
   PSR(0x3F,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x07, ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0xFF,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSR(MaskAll,MaskAll,KMITCER + 0x3C,KMITCER);   
   PSR(0x00,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(ms_16 | us_64 | 0x00,ms_16 | us_64 | COUNTERSTG2,KMISTG2);
   PSR(0x00,COUNTERSTG3,KMISTG3,KMISTG3);   

   /* Checking the Counters in the Normal Mode */ 
 
   /* All three counter stages count individually with their  */
   /* count enable inputs asserted continuously high.         */
   /* Switch to REGCLK Mode and set the TESTINPSEL bit to     */ 
   /* drive KmiClkIn and KmiDataIn from the KMITISR register. */ 
   /* Drive the KmiClkIn and KmiDataIn line low to keep the   */
   /* state M/c in the Reset state.                           */ 
   PSW(TESTINPSEL | TESTRST | TESTCLKEN | TESTEN,KMITCR,KMITCR); 
   PSW(TESTINPSEL | TESTCLKEN | TESTEN,KMITCR,KMITCR); 
   PSW(Stg2Bypass | Stg1Bypass,KMITMR,KMITMR);  
    
   /* Dummy cycles for sychronisation */ 
   L(5,MaskAll,MaskAll,KMITCER);

   /* Load a  Clock Divider value into the CLKDIV register and */ 
   /* apply dummy cycles to synchronise                        */
   if (DivBypass == 0)
     {  
      PSW(DIVVAL,KMICLKDIV,KMICLKDIV)
      L(3 ,MaskAll,MaskAll,KMITCER);  
     } 

   /* Enable the Kmi */    
   PSW(KMIEN,KMICR,KMICR);   

   /* Dummy cycle for synchronisation */
   L(2,MaskAll,MaskAll,KMITCER);

   PSW(TESTINPSEL | TESTEN | TESTCLKEN | REGCLK,KMITCR);  

   /* Increment all the three counter stages by accessing the KMITCER       */ 
   /* register. Check the counter values and 64us & 16ms timeout signals    */
    
   /* Dummy cycles for synchronisation */ 
   if(DivBypass == 0 && DIVVAL == 1)  
      L(2*EightMHz  - 3 ,MaskAll,MaskAll,KMITCER);

   if(DivBypass == 0 && DIVVAL > 2) 
     L(EightMHz  - 3 ,MaskAll,MaskAll,KMITCER);

   PSR(0x01,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x01,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x01,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF1,KMITCER);
   PSR(0x02,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x02,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x02,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF2,KMITCER);
   PSR(0x03,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x03,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x03,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF3,KMITCER);
   PSR(0x04,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x04,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x04,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF4,KMITCER);
   PSR(0x05,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x05,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x05,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF5,KMITCER);
   PSR(0x06,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x06,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x06,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF6,KMITCER);
   PSR(0x07,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x07,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x07,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF7,KMITCER);
   PSR(0x08,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(us_64 | 0x00,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x08,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF8,KMITCER);
   PSR(0x09,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x01,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x09,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xF9,KMITCER);
   PSR(0x0A,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x02,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x0A,COUNTERSTG3,KMISTG3,KMISTG3);   

   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xFA,KMITCER);
   PSR(0x0B,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x03,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x0B,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xFB,KMITCER);
   PSR(0x0C,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x04,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x0C,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xFC,KMITCER);
   PSR(0x0D,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x05,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x0D,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xFD,KMITCER);
   PSR(0x0E,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x06,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x0E,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xFE,KMITCER);
   PSR(0x0F,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(0x07,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x0F,COUNTERSTG3,KMISTG3,KMISTG3);   
 
   if(DivBypass == 0) 
   L(EightMHz - 1,MaskAll,MaskAll,KMITCER);
   PSW(0xFF,KMITCER);
   PSR(0x10,COUNTERSTG1,KMISTG1,KMISTG1);   
   PSR(us_64 | 0x00,ms_16 | us_64 | COUNTERSTG2,KMISTG2,KMISTG2);   
   PSR(0x10,COUNTERSTG3,KMISTG3,KMISTG3);   

  /* Counter Tests complete. */

  /* Clean up and ensure that the control state machine is in the  */
  /* Reset State when exiting from this test                       */
    
  /* Set TESTINPSEL to drive KmiClkIn from the KMITISR register */  
     
  PSW(TESTINPSEL,KMITCR,KMITCR); 
  PSW(0x00,KMITISR,KMITISR);

  /* Apply the TESTRST for one PCLK period */ 
  PSW(TESTINPSEL | TESTRST,KMITCR,KMITCR); 
  PSW(TESTINPSEL,KMITCR,KMITCR); 
 
  /* Assert KmiClkIn for three EightMHz Pulse periods */
  /* so that it is detected as a valid pulse          */ 
  L(5,MaskAll,MaskAll,KMITCER);  
}

/******************************************************************************/
/************************* Transmitter - Receiver Tests ***********************/
/******************************************************************************/

void TX_RX(int DIVVAL,int DivBypass,int TYPE) 
{

  /* 
     Summary: Transmit and Receive Test 
     ================================== 
     This following test checks the operation of transmitter and receiver 
     state machine. 
 
     The follwing checks have been done during the course of this test.
   
     o Simultaneous reception and transmission was simulated to verify that the
       transmission takes priority by reading state of the state machine via
       the KMISTATE register. 
    
     o Correct transmission is verified via the nKMIDATAEN bit of the KMITOCR
       register after a valid KMICLKIN is supplied via the KMITISR register. 

     o After the transmission, the reception of a byte is simulated. 
     
     o At the end of the reception, it is verified that the state machine 
       remains in the LOCK state until the received data is read out of 
       the KMIDATA register.   

     o After the reception, transmit one more byte. 

     o At the end of the transmission, check that the state machine once again 
       enters the LOCK state, since the previously received byte has not yet 
       been read. Now, read the received byte to check whether the state machine       goes to RESET state. Then, the KMICLKIN line is pulled high to bring the 
       state machine from RESET to IDLE state.

     o In the IDLE state, simulate the condition of a byte from the keyboard
       with a wrong stop bit and wrong parity bit to check whether the byte is
       discarded and the wrong parity bit still stored in the KMISTAT register.
 
     o At end of the reception, the state machine should return to RECOVER state
       ( rather than the LOCK state ) and then goes to IDLE state to start 
       another reception after the KMICLKIN line has been pulled high.
  
     o Simulate the conditions for another byte reception, but data byte is not 
       read immeadiately from KMIDATA register after the reception.  
  
     o Place the KMISTG3 counter in bypass mode prior to conducting the TX and
       RX timeout.
       
     o Pull the KMICLKIN line low for a pre-determined period so that the 
       timeout conditon occurs at TXDONE state and read the KMISTATE register  
       to confirm that the state machine is at RECOVER state after the timeout 
       condition. Then, pull the KMICLKIN to high to bring the state machine 
       to LOCK state, since the previously received byte has not yet been 
       read from KMIDATA register.     

     o Read the previously received byte from the KMISTATE register to bring 
       the state machine from the LOCK state to the RESET state . 

     o Create Timeout condition at all possible states.

     o Disable Kmi at all states to check whether it returns to RESET state. 

  */

   int EightMHz;
   int i;
   
   if(DivBypass == 0)
     EightMHz = (DIVVAL & 0x0F) + 1;
   else
     EightMHz = 1;

   /* Assert TESTRST and switch to non-REGCLK mode. Bypass      */
   /* stage1 counter.                                           */
   /* Set the TESTINPSEL bit in the KMITCR register to drive    */ 
   /* KmiClkIn and KmiDataIn from the Test register(KMITISR)    */ 
   PSW(Stg1Bypass,KMITMR,KMITMR);
   PSW(TESTINPSEL | TESTRST , KMITCR,KMITCR);
   PSW(0x00, KMITISR,KMITISR);
   PSW(TESTINPSEL | TESTCLKEN | TESTEN , KMITCR,KMITCR);

   /* Check the TXINTR and RXINTR outputs and their    */
   /* respective Busy signals.                         */ 
   /* Ensure that the state M/C is in the Reset state. */ 
   PSR(TXE,TXE | TXB | RXB | RXF,KMISTAT,KMISTAT);    
   PSR(RESETST,STATE,KMISTATE,KMISTATE); 
   
   /* Enable the KMI, KMITXINTR and KMIRXINTR */ 
   if(DivBypass == 1)
     {  
       if(TYPE == 0)    
          PSW(KMIEN | KMITXEEN | KMIRXFEN,KMICR,KMICR); 
       else  
          PSW(KMIEN | KMITYPE | KMITXEEN | KMIRXFEN,KMICR,KMICR); 
     }

   /* Load a Clock Divider value into the CLKDIV register and  */ 
   /* apply dummy cycles to synchronise                        */
   if(DivBypass == 0)
     {
       PSW(DIVVAL,KMICLKDIV,CLKDIV);
       L(1,MaskAll,MaskAll,KMITCER);

       if(TYPE == 0) 
          PSW(KMIEN | KMITXEEN | KMIRXFEN,KMICR,KMICR); 
       else 
          PSW(KMIEN | KMITYPE | KMITXEEN | KMIRXFEN,KMICR,KMICR); 

       L(1,MaskAll,MaskAll,KMITCER);
     }   

   /* Pull KmiClkIn high to force the state M/C into the Idle state */ 
   PSW(KMICLKIN,KMITISR,KMITISR);
   
   /* Dummy cycles to synchronise the KmiClkIn  */       
   L(2,MaskAll,MaskAll,KMITCER); 

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 )
     {
       if(DIVVAL != 1) 
         L(3*EightMHz - 2 ,MaskAll,MaskAll,KMITCER); 
       else   
         L(3*EightMHz,MaskAll,MaskAll,KMITCER); 
     }

   if (DivBypass == 1)
      L(3,MaskAll,MaskAll,KMITCER); 
   
   /* Drive KmiClkIn low as well as load data into the KMIDATA register to */
   /* check that Transmission takes higher priority over Reception if both */
   /* occur at the same time                                               */ 
   PSW(0x00,KMITISR,KMITISR);

   /* Check whether the state M/C is in the idle state */
   PSR(IDLEST,STATE,KMISTATE,KMISTATE); 

   /* Keep KmiClkIn low for some more time so that a valid low on KmiClkIn */
   /* is detected.                                                         */   
   if(DivBypass == 0 && DIVVAL != 1) 
     L(3*EightMHz - 6,MaskAll,MaskAll,KMITCER); 
   else   
     L(3*EightMHz - 4,MaskAll,MaskAll,KMITCER); 

   /* Write a data into the KMIDATA register  */ 
   PSW(0x55,KMIDATA,KMIDATA);  
  
   /* Check for TXINTR getting cleared after a Data has been written into */
   /* the KMIDATA register.                                               */  
   PSR(0x00,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Write another data into KMIDATA to check whether it gets ignored */
   PSW(0x00,KMIDATA,KMIDATA);  
    
   /* Dummy cycles to synchronise to REFCLK domain  */ 
   L(2,MaskAll,MaskAll,KMITCER); 
     
   /* Check whether the FSM is in the Transmitter state (TX64US)         */  
   /* to confirm that Transmission takes higher priority over Reception  */  
   /* when both conditions occur simultaneously                          */
   PSR(TX64USST,STATE,KMISTATE,KMISTATE); 

   /* Check whether KmiClkEn is low */
   PSR(0x00,KMICLKEN,KMITOCR,KMITOCR);

   /* Check for TXBUSY after it enters into the TXU64 state */  
   PSR(TXB,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Drive KmiClkIn to its default value  */ 
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiClkEn signal to be low for 64 usec */   
   if(DivBypass == 0 )
     L(9*EightMHz - 6,0x00,KMICLKEN,KMITOCR);
   else   
     L(9*EightMHz - 5,0x00,KMICLKEN,KMITOCR);

   /* Pull KmiClkIn low for the first bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn and KMIClkEn lines for start bit */ 
   L(2,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);

   /* Check whether the state machine is in the TX state */
   PSR(TXST,STATE,KMISTATE,KMISTATE);

   /* Check TX and RX status */ 
   PSR(TXB,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the first bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(4*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(4*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the second bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the first bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(5*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(5*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the second bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(6*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(6*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the third bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the second bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the third bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);
   
   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fourth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the third bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the fourth bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fifth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the fourth bit */ 
   L(3,KMICLKEN ,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Keep KmiClkIn low for one Pulse8MHz period              */  
   /* to check that it is ignored as a valid low pulse        */ 
   if(DivBypass == 0 )
     L(EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Check the KmiDataEn line for the fourth bit rather than for the */
   /* fifth bit                                                       */ 
   PSR(KMICLKIN,KMICLKEN | KMIDATAEN,KMITOCR);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the fifth bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the sixth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the fifth bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the sixth bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the seventh bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the sixth bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the seventh bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the eigth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the seventh bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the eigth bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the parity bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the eigth bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the parity bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
  
   /* Pull KmiClkIn low for the stop bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the current state of the State M/C */    
   PSR(TXDONEST,STATE,KMISTATE,KMISTATE);

   /* Check the KmiDataEn line for the parity bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 6,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 

   if(TYPE == 0)   
     {   
       /* Pull KmiClkIn high */
       PSW(KMICLKIN,KMITISR,KMITISR);

       /* Check the KmiClkEn line for the stop bit */ 
       L(3,KMICLKEN|KMIDATAEN, KMICLKEN,KMITOCR);
  
       /* Check TX and RX status  */ 
       PSR(TXB, RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

       /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
       if(DivBypass == 0 && DIVVAL != 1)
         L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
       else
         L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
 
       /* Pull KmiClkIn low for waiting to acknowledge signal send by  */ 
       /* Keyboard in the case of AT                                   */ 
       PSW(0x00,KMITISR,KMITISR);
   
       /* Check the KmiDataEn line for the stop bit */ 
       L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
   
       /* Check TX and RX status  */ 
       PSR(TXB, RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);
 
       /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
       if(DivBypass == 0 && DIVVAL != 1)
         L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
       else
         L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
     }

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the stop bit for PS2 type or */ 
   /* Wait for the Acknowledge period for AT type               */  
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   /* and drive KmiDataIn high for the case of AT TYPE Keyboard to bring */  
   /* the st m/c to WAIT state                                           */ 
   if(DivBypass == 0)
     { 
        if (DIVVAL  > 1) 
           L(3*EightMHz - 4,MaskAll,MaskAll,KMITCER); 
        else 
           L(2*EightMHz,MaskAll,MaskAll,KMITCER); 
     } 
   else
     { 
        L(2,MaskAll,MaskAll,KMITCER); 

        if(TYPE == 0)   
          PSW(KMIDATAIN | KMICLKIN,KMITISR,KMITISR); 
        else
          PSR(WAITST,STATE,KMISTATE,KMISTATE); 
     } 

   if(DivBypass == 0)  
     {
        L(2*EightMHz - 2,MaskAll,MaskAll,KMITCER); 

        if(TYPE == 0)   
          PSW(KMIDATAIN | KMICLKIN,KMITISR,KMITISR); 
        else
          PSR(WAITST,STATE,KMISTATE,KMISTATE); 
     }

    if(TYPE == 0)
      { 
        if(DivBypass == 0)    
          L(2*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
        else
          L(3,MaskAll,MaskAll,KMITCER); 

        /* Check the current state of the State M/C */  
        PSR(WAITST,STATE,KMISTATE,KMISTATE); 
      }

   /* Simulate the conditions for Reception  */   

   /* Pull KmiClkIn low to move into the Receive state */
   PSW(0x00,KMITISR,KMITISR);

   /* Dummy cycle to move the state m/c */
   PSR(MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(IDLEST,STATE,KMISTATE,KMISTATE);

   /* Drive KmiDataIn for the start bit   */   
   PSW(0x00,KMITISR);   
     
   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 4,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);
       
   /* Check TX and RX Interrupt status */
   PSR(TXINTR ,TXINTR | RXINTR, KMIIR, KMIIR);  

   /* Check the State of the State M/C */  
   PSR(RXST,STATE,KMISTATE,KMISTATE);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(4*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(4*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the first receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the first bit   */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(5*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(5*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the second receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the second bit   */   
   PSW(0x00,KMITISR,KMITISR);   
   
   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the third receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the third bit */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fourth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for fourth bit   */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fifth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the fifth bit  */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the sixth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the sixth bit */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the seventh receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the seventh bit  */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the eigth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the eigth bit  */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the parity bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the parity bit  */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the stop bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the stop bit */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB | RXP,TXE | TXB | RXB | RXF | RXP,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 
    
   /* Dummy cycle for synchronisation */ 
   L(EightMHz + 1,MaskAll,MaskAll,KMITCER); 
 
   /* Check the current state of the State M/C */  
   PSR(LOCKST,STATE,KMISTATE,KMISTATE);     

   /* Dummy cycle for synchronisation */
   L(2,MaskAll,MaskAll,KMITCER);  
   
   /* Check the RXF Flag */ 
   PSR(RXINTR, RXINTR, KMIIR,KMIIR);

   if ((DIVVAL == 1) && (DivBypass == 0))
     PSR(MaskAll,MaskAll,KMITCER,KMITCER);
 
   if(DivBypass == 0 && DIVVAL != 1) 
     {
        if(DIVVAL == 2) 
          PSR(MaskAll,MaskAll,KMITCER); 

        if(DIVVAL == 3 && DivBypass == 0 )
          L(EightMHz - 1,MaskAll,MaskAll,KMITCER); 

        if(DIVVAL == 5 ) 
          L(EightMHz + 1,MaskAll,MaskAll,KMITCER); 

        if(DIVVAL > 5 )  
          L(EightMHz - 5,MaskAll,MaskAll,KMITCER); 

     }

   /* Write a data for another transmission    */   
   PSW(0xAA,KMIDATA,KMIDATA); 

   /* Check for the Transmit Interrupt to be cleared */ 
   PSR(0x00,TXE,KMISTAT,KMISTAT);

   /* Check for the Transmit Interrupt to be cleared through Interrupt reg */ 
   PSR(0x00, TXINTR ,KMIIR ,KMIIR);

   /* Dummy cycle for synchronisation */
   PSR(MaskAll,MaskAll,KMITCER); 

   if ((DIVVAL == 1) && (DivBypass == 0))
     PSR(MaskAll,MaskAll,KMITCER); 

   /* Dummy cycles for synchronisation */ 
   PSR(MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(TX64USST,STATE,KMISTATE,KMISTATE);     

   if ((DIVVAL == 1) && (DivBypass == 0))
     L(EightMHz, 0x00,KMICLKEN,KMITOCR);

   if(DivBypass == 0 && DIVVAL != 1) 
     {
        if(DIVVAL > 3)  
          L(EightMHz - 3,0x00,KMICLKEN,KMITOCR); 
     }       

   /* Drive KmiClkIn to the default value  */ 
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check for TXBUSY after it enters into the TXU64 state */  
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Check the  KmiClkEn signal to be low for 64 usec */   
   if(DivBypass == 0) 
     L(8*EightMHz - 5,0x00,KMICLKEN,KMITOCR);
   else   
     L(9*EightMHz - 4,0x00,KMICLKEN,KMITOCR);
   
   if ((DIVVAL == 2 || DIVVAL == 3) && (DivBypass == 0)) 
     L(EightMHz ,0x00,KMICLKEN,KMITOCR);
 
   if ((DIVVAL == 3) && (DivBypass == 0)) 
    PSR(0x00,KMICLKEN,KMITOCR);

   /* Pull KmiClkIn low for the first bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn and KMIClkEn lines for the start bit and KMIINTR */ 
   L(2,KMICLKEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);

   /* Check whether the state machine is in the TX state */
   PSR(TXST,STATE,KMISTATE,KMISTATE);

   /* Check TX and RX status */ 
   PSR(TXB | RXF,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the first bit and KMIINTR */ 
   L(3,KMICLKEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the second bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the first bit and KMIINTR */ 
   L(3, KMICLKEN | KMIINTR ,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the second bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the third bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the second bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the third bit and KMIINTR */ 
   L(3,KMICLKEN | KMIINTR, KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fourth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the third bit and KMIINTR */ 
   L(3,KMICLKEN | KMIINTR, KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);

   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the fourth bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fifth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the fourth bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the fifth bit and KMIINTR */ 
   L(3,KMICLKEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the sixth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the fifth bit and KMIINTR */ 
   L(3,KMICLKEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the sixth bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the seventh bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the sixth bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the seventh bit and KMIINTR */ 
   L(3,KMICLKEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the eigth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the seventh bit and KMIINTR */ 
   L(3,KMICLKEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the eigth bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the parity bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the eigth bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the parity bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
  
   /* Pull KmiClkIn low for the stop bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the State of the State M/C */    
   PSR(TXDONEST,STATE,KMISTATE,KMISTATE);

   /* Check the KmiDataEn line for the parity bit and KMIINTR */ 
   L(3,KMICLKEN | KMIDATAEN | KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 6,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 

   if(TYPE == 0)   
     {   
       /* Pull KmiClkIn high */
       PSW(KMICLKIN,KMITISR,KMITISR);

       /* Check the KmiClkEn line for the stop bit and KMIINTR */ 
       L(3,KMICLKEN|KMIDATAEN|KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
  
       /* Check TX and RX status  */ 
       PSR(TXB | RXF, RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

       /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
       if(DivBypass == 0 && DIVVAL != 1)
         L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
       else
         L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
 
       /* Pull KmiClkIn low for waiting to acknowledge signal send by  */ 
       /* Keyboard in the case of AT                                   */ 
       PSW(0x00,KMITISR,KMITISR);
   
       /* Check the KmiDataEn line for the stop bit and KMIINTR */ 
       L(3,KMICLKEN|KMIDATAEN|KMIINTR,KMICLKEN | KMIDATAEN | KMIINTR ,KMITOCR);
   
       /* Check TX and RX status  */ 
       PSR(TXB | RXF , RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);
 
       /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
       if(DivBypass == 0 && DIVVAL != 1)
         L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
       else
         L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
     }

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the stop bit for PS2 type or */ 
   /* Wait for the Acknowledge period for AT type               */  
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF, RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   /* and drive KmiDataIn high for the case of AT TYPE Keyboard to bring */  
   /* the st m/c to WAIT state                                           */ 
   if(DivBypass == 0)
     { 
        if (DIVVAL  > 1) 
           L(3*EightMHz - 4,MaskAll,MaskAll,KMITCER); 
        else 
           L(2*EightMHz,MaskAll,MaskAll,KMITCER); 
     } 
   else
     { 
        L(2,MaskAll,MaskAll,KMITCER); 

        if(TYPE == 0)   
          PSW(KMIDATAIN | KMICLKIN,KMITISR,KMITISR); 
        else
          PSR(WAITST,STATE,KMISTATE,KMISTATE); 
     } 

   if(DivBypass == 0)  
     {
        L(2*EightMHz - 2,MaskAll,MaskAll,KMITCER); 

        if(TYPE == 0)   
          PSW(KMIDATAIN | KMICLKIN,KMITISR,KMITISR); 
        else
          PSR(WAITST,STATE,KMISTATE,KMISTATE); 
     }

    if(TYPE == 0)
      { 
        if(DivBypass == 0)    
          L(2*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
        else
          L(3,MaskAll,MaskAll,KMITCER); 

        /* Check the current state of the State M/C */  
        PSR(WAITST,STATE,KMISTATE,KMISTATE); 
      }

   /* Dummy cycle to move to the next state */ 
   PSR(MaskAll,MaskAll,KMITCER,KMITCER); 
  
   /* check the current state of the State M/C */  
   PSR(LOCKST,STATE,KMISTATE,KMISTATE);

   if(DivBypass == 0 && DIVVAL == 2)
     L(EightMHz - 2,MaskAll,MaskAll,KMITCER);

   if(DivBypass == 0 && DIVVAL > 2 )
     L(EightMHz - 2,MaskAll,MaskAll,KMITCER); 
     
   /* Read the received data from the KMIDATA register */ 
   PSR(0x55,DATA,KMIDATA,KMIDATA);
 
   /* Dummy cycles for synchronisation and to get the next Pulse8MHz pulse */ 
   L(8,MaskAll,MaskAll,KMITCER); 

   if ((DIVVAL == 1) && (DivBypass == 0))
      PSR(MaskAll,MaskAll,KMITCER); 

   if ((DIVVAL == 3) && (DivBypass == 0))  
      L(3*EightMHz - 9 ,MaskAll,MaskAll,KMITCER); 

   if ((DivBypass == 0) && (DIVVAL > 3) && (DIVVAL < 8))
       L(2*EightMHz  - 9,MaskAll,MaskAll,KMITCER);

   if(DivBypass == 0 && DIVVAL > 8) 
     L(EightMHz - 9,MaskAll,MaskAll,KMITCER);

   /* Simulate the condition to receive a DATA with a wrong STOP BIT */ 
   /* to check whether the DATA gets discarded.                      */ 

   /* Pull the clock line Low so that the state machine moves into the */
   /* Receive state                                                    */ 
   PSW(0x00,KMITISR,KMITISR);

   /* Check the current state of the State M/C */  
   PSR(RESETST,STATE,KMISTATE,KMISTATE);
 
   /* Check the current state of the State M/C */  
   PSR(IDLEST,STATE,KMISTATE,KMISTATE);

   /* Drive KmiDataIn for the start bit   */   
   PSW(0x00,KMITISR);   
     
   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 4,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);
       
   /* Check TX and RX status */
   PSR(TXE,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Check the State of the State M/C */  
   PSR(RXST,STATE,KMISTATE,KMISTATE);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the first receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the first bit   */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the second receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the second bit   */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the third receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the third bit */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fourth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the fourth bit   */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fifth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the fifth bit  */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the sixth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the sixth bit */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the seventh receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the seventh bit  */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the Eighth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the fifth bit  */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low to simulate reception of the parity bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the wrong parity bit  */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low to receive the stop bit          */
   /* to ignore this reception                           */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the (wrong) stop bit */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF | RXP,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 
    
   /* Dummy cycle for synchronisation */ 
   L(EightMHz + 1,MaskAll,MaskAll,KMITCER); 
 
   /* Check the current state of the State M/C */  
   PSR(RECOVERST,STATE,KMISTATE,KMISTATE);     

   /* Dummy cycles for synchronisation */ 
   if(DivBypass == 0 && DIVVAL > 1)  
     L(EightMHz - 2,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low to move into the Receive state */
      PSW(0x00,KMITISR,KMITISR); 
 
   /* Dummy cycle to go to IDLEST */ 
      PSR(MaskAll,MaskAll,KMITCER,KMITCER);  
   
   /* Simulate condition to receive one byte */

   /* Check the current state of the State M/C */  
   PSR(IDLEST,STATE,KMISTATE,KMISTATE);

   /* Drive KmiDataIn for the start bit   */   
   PSW(0x00,KMITISR);   
     
   /* Check RX Flag */ 
   PSR(0x00,RXF,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);
       
   /* Check TX and RX status */
   PSR(TXE,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Check the State of the State M/C */  
   PSR(RXST,STATE,KMISTATE,KMISTATE);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(4*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(4*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the first receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the first bit   */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(5*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(5*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the second receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the second bit   */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   
   
   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN ,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the third receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the third bit */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fourth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for fourth bit   */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fifth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the fifth bit  */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the sixth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the sixth bit */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the seventh receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the seventh bit  */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the eigth receive bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the eigth bit  */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the parity bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the parity bit  */   
   PSW(0x00,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the stop bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB,TXE | TXB | RXB | RXF,KMISTAT);  

   /* Drive KmiDataIn for the stop bit */   
   PSW(KMIDATAIN,KMITISR,KMITISR);   

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);

   /* Check TX and RX status */
   PSR(TXE | RXB, TXE | TXB | RXB | RXF | RXP,KMISTAT);  

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz,MaskAll,MaskAll,KMITCER); 
    
   /* Dummy cycle for synchronisation */ 
   L(EightMHz + 1,MaskAll,MaskAll,KMITCER); 
 
   /* Check the current state of the State M/C */  
   PSR(LOCKST,STATE,KMISTATE,KMISTATE);     

   /* Dummy cycle for synchronisation */
   L(2,MaskAll,MaskAll,KMITCER);  
   
   /* Check the RXF Flag */ 
   PSR(RXF,RXF,KMISTAT,KBSTAT);

   if ((DIVVAL == 1) && (DivBypass == 0))
     PSR(MaskAll,MaskAll,KMITCER,KMITCER);
 
   if(DivBypass == 0 && DIVVAL != 1) 
     {
        if(DIVVAL == 2) 
          PSR(MaskAll,MaskAll,KMITCER); 

        if(DIVVAL == 3 && DivBypass == 0 )
          L(EightMHz - 1,MaskAll,MaskAll,KMITCER); 

        if(DIVVAL == 5 ) 
          L(EightMHz + 1,MaskAll,MaskAll,KMITCER); 

        if(DIVVAL > 5 )  
          L(EightMHz - 5,MaskAll,MaskAll,KMITCER); 

     }

   /* Check for TX and RX Timeout      */

   /* Write a data for another transmission    */   
   PSW(0xAA,KMIDATA,KMIDATA); 

   /* Check for the Transmit Interrupt to be cleared */ 
   PSR(0x00,TXE,KMISTAT,KMISTAT);
   
   /* Dummy cycle for synchronisation */
   L(2,MaskAll,MaskAll,KMITCER); 
   
   if ((DIVVAL == 1) && (DivBypass == 0))
     PSR(MaskAll,MaskAll,KMITCER); 

   /* Dummy cycles for synchronisation */ 
   PSR(MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(TX64USST,STATE,KMISTATE,KMISTATE);     

   if ((DIVVAL == 1) && (DivBypass == 0))
     L(EightMHz, 0x00,KMICLKEN,KMITOCR);

   if(DivBypass == 0 && DIVVAL != 1) 
     {
        if(DIVVAL > 3)  
          L(EightMHz - 3,0x00,KMICLKEN,KMITOCR); 
      }       

   /* Drive KmiClkIn to the default value  */ 
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check for TXBUSY after it enters into the TXU64 state */  
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Check the  KmiClkEn signal to be low for 64 usec */   
   if(DivBypass == 0) 
     L(8*EightMHz - 5,0x00,KMICLKEN,KMITOCR);
   else   
     L(9*EightMHz - 4,0x00,KMICLKEN,KMITOCR);
   
   if ((DIVVAL == 2 || DIVVAL == 3) && (DivBypass == 0)) 
     L(EightMHz ,0x00,KMICLKEN,KMITOCR);
 
   if ((DIVVAL == 3) && (DivBypass == 0)) 
    PSR(0x00,KMICLKEN,KMITOCR);

   /* Pull KmiClkIn low for the first bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn and KMIClkEn lines for the start bit */ 
   L(2,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);

   /* Check whether the state machine is in the TX state */
   PSR(TXST,STATE,KMISTATE,KMISTATE);

   /* Check TX and RX status */ 
   PSR(TXB | RXF,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Put the third stage of the Counter in the Nibble mode */ 
   /* and bypass the previous stages                        */
   if (DivBypass == 0 && DIVVAL == 1) 
     {  
        PSW(Stg2Bypass | S3NIB | Stg1Bypass, KMITMR,KMITMR);
        L(6*EightMHz, MaskAll,MaskAll,KMITCER); 
     } 

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the first bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the second bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the first bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the second bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the third bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the second bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the third bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fourth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the third bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the fourth bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the fifth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the fourth bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the fifth bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the sixth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the fifth bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF| TXE | TXB,KMISTAT,KMISTAT);

   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the sixth bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the seventh bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the sixth bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
 
   /* Check the KmiDataEn line for the seventh bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the eigth bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the seventh bit */ 
   L(3,KMICLKEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Check the KmiDataEn line for the eigth bit */ 
   L(3,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn low for the parity bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the KmiDataEn line for the eigth bit */ 
   L(3,KMICLKEN | KMIDATAEN, KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid low pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Put the third stage of the Counter in the Nibble mode */ 
   /* and bypass the previous stages                        */
   if (DivBypass == 0 && DIVVAL != 1) 
      PSW(Stg2Bypass | S3NIB | Stg1Bypass, KMITMR,KMITMR);

   /* Check the KmiDataEn line for the parity bit */ 
   L(2,KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR);
  
   /* Check TX and RX status  */ 
   PSR(TXB | RXF ,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(3*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(3*EightMHz - 1,MaskAll,MaskAll,KMITCER); 
  
   /* Pull KmiClkIn low for the stop bit */
   PSW(0x00,KMITISR,KMITISR);

   /* Check the State of the State M/C */    
   PSR(TXDONEST,STATE,KMISTATE,KMISTATE);

   /* Put the third stage of the Counter in the Nibble mode */ 
   /* and bypass the previous stages                        */
   if(DivBypass == 1) 
     {
       PSW(Stg2Bypass | S3NIB | Stg1Bypass, KMITMR,KMITMR);
       L(3*EightMHz ,MaskAll,MaskAll,KMITCER); 
     }

   /* Dummy cycle to timeout occur */     
   if((DivBypass ==  0 && DIVVAL != 1) || (DivBypass == 1)) 
     L(12*EightMHz ,MaskAll,MaskAll,KMITCER); 
 
   /* Put the third stage of the Counter in the Normal mode */ 
   /* and bypass the previous stages                        */
   PSW(Stg2Bypass | Stg1Bypass, KMITMR,KMITMR);

   /* Dummy cycle to timeout occur */     
   L(5*EightMHz - 2 ,MaskAll,MaskAll,KMITCER);  
  
   /* Dummy cycle to timeout occur */     
   if(DivBypass == 0 && DIVVAL == 1) 
     L(7*EightMHz, MaskAll,MaskAll,KMITCER);  

   /* Check the State of the State M/C */    
   PSR(RECOVERST,STATE,KMISTATE,KMISTATE);

   /* Pull KmiClkIn  high */
   PSW(KMICLKIN,KMITISR,KMITISR);
  
   /* Dummy cycles for synchornisation */
   L(3, MaskAll,MaskAll,KMITCER); 

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1)
     L(5*EightMHz - 5,MaskAll,MaskAll,KMITCER); 
   else
     L(5*EightMHz - 1,MaskAll,MaskAll,KMITCER); 

   /* Check the State of the State M/C */    
   PSR(LOCKST,STATE,KMISTATE,KMISTATE);

   /* Check TX and RX status  */ 
   PSR(RXF | TXE, RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);
 
   /* Read the received data */  
   PSR(0x57,DATA,KMIDATA,KMIDATA);

   /* Check TX and RX status  */ 
   PSR(TXE,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles for synchronisation */
   if(DivBypass == 0 && DIVVAL > 4)
      L(EightMHz - 4,MaskAll,MaskAll,KMITCER); 

   /* Dummy cycle to go to IDLEST */
   L(2,MaskAll,MaskAll,KMITCER); 

   /* Extra Dummy cycle to go to IDLEST */
     if(DivBypass == 0)
       L(10,MaskAll,MaskAll,KMITCER); 
     else    
       L((10-DIVVAL)*EightMHz,MaskAll,MaskAll,KMITCER); 
   
   /* Check the State of the State M/C */    
   PSR(IDLEST,STATE,KMISTATE,KMISTATE);

   /* Put the third stage of the Counter in the Nibble mode */ 
   /* and bypass the previous stages                        */
   PSW(Stg2Bypass | S3NIB | Stg1Bypass, KMITMR,KMITMR);

   /* Pull KmiClkIn and DataIn low to enter into the RX state */ 
   PSW(0x00,KMITISR,KMITISR);  
    
   /* Dummy cycles for the state machine to go to the RX state */
   if(DivBypass == 0)
   L(4*EightMHz + 2,MaskAll,MaskAll,KMITCER); 
   else 
   L(3*EightMHz + 4,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RXST,STATE,KMISTATE,KMISTATE);     
  
   /* Dummy cycles to time out from Reception */ 
   L(17*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RECOVERST,STATE,KMISTATE,KMISTATE);     

   /* Pull KmiClkIn high so that the State M/C returns to the IDLE state */     
   PSW(KMICLKIN,KMITISR,KMITISR);  

   /* Dummy cycles to go to the IDLE state */
   if(DivBypass == 0)
     L(4*EightMHz + 2,MaskAll,MaskAll,KMITCER); 
   else 
     L(4*EightMHz + 4,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(IDLEST,STATE,KMISTATE,KMISTATE);     

   /* Load a Byte into the KMIDATA register */ 
   PSW(0xFF,KMIDATA,KMIDATA);     
   
   /* Check the Transmit interrupt */ 
   PSR(0x00,TXE,KMISTAT,KMISTAT);     

   /* Dummy cycles to synchronise */
   L(2,MaskAll,MaskAll,KMITCER);     
  
   /* Dummy cycles to synchronise */ 
   L(EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Check the KmiClkEn line for 64 usec */  
   L(7*EightMHz,0x00,KMICLKEN,KMITOCR); 

   /* Dummy cycles for the state machine to go to the TX state  */
   L(2*EightMHz,MaskAll,MaskAll,KMITCER); 
   
   /* Check the current state of the State M/C */  
   PSR(TXST,STATE,KMISTATE,KMISTATE);     

   /* Pull the KmiClkIn Low  */  
   PSW(0x00,KMITISR,KMITISR);  
 
   /* Dummy cycles for time out to occur during the Transmission  */
   L(7*EightMHz,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RECOVERST,STATE,KMISTATE,KMISTATE);     

   /* Disable the KMI */   
   PSW(0x00,KMICR,KMICR);  

   /* Dummy cycles for synchronisation */ 
   L(3,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     

   /* Enable the KMI */   
   PSW(KMIEN,KMICR,KMICR);  

   /* Put the third stage of the Counter in the Normal mode */ 
   /* and bypass the previous stages                        */
   PSW(Stg2Bypass | Stg1Bypass, KMITMR,KMITMR);

   /* Pull the KmiClkIn high  */  
   PSW(KMICLKIN,KMITISR,KMITISR);  
 
   /* Write a byte into KMIDATA */  
   PSW(0x00,KMIDATA,KMIDATA);  
  
   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   L(3*EightMHz+5,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(TX64USST,STATE,KMISTATE,KMISTATE);     

   /* Disable the KMI at TX64US State */   
   PSW(0x00,KMICR,KMICR);  

   /* Dummy cycles for synchronisation */ 
   if(DivBypass == 1)
     L(8,MaskAll,MaskAll,KMITCER); 
   else 
     L(5,MaskAll,MaskAll,KMITCER); 
    
   /* Check the current state of the State M/C */  
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     

   /* Enable the KMI */   
   PSW(KMIEN,KMICR,KMICR);  

   /* Pull the KmiClkIn high */  
   PSW(KMICLKIN,KMITISR,KMITISR);  
 
   /* Dummy cycles to go to TX st */ 
   L(12*EightMHz,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(TXST,STATE,KMISTATE,KMISTATE);     
 
   /* Disable the KMI at TX State */   
   PSW(0x00,KMICR,KMICR);  

   /* Dummy cycles for synchronisation */ 
   L(3,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     

   /* Enable the KMI */   
   PSW(KMIEN,KMICR,KMICR);  

   /* Pull the KmiClkIn high */  
   PSW(KMICLKIN,KMITISR,KMITISR);  
 
   /* Dummy cycles to go to TX st */ 
   L(12*EightMHz,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(TXST,STATE,KMISTATE,KMISTATE);     
 
   /* Supply KMICLK to force the st m/c to go to TXDONE state */   
   for( i = 0; i < 9; i++)  
     {
       PSW(0x00,KMITISR,KMITISR); 
       L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);
       PSW(KMICLKIN,KMITISR,KMITISR); 
       L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);
     }
  
   /* Check the current state of the State M/C */  
   PSR(TXDONEST,STATE,KMISTATE,KMISTATE);     
 
   /* Disable the KMI at TXDONE state */   
   PSW(0x00,KMICR,KMICR);  

   /* Dummy cycles for synchronisation */ 
   L(3,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     

   /* Enable the KMI */   
   PSW(KMIEN,KMICR,KMICR);  

   /* Dummy cycles for synchronisation */ 
   L(EightMHz,MaskAll,MaskAll,KMITCER);

   /* Write another byte into the KMIDATA */ 
   PSW(0x25,KMIDATA,KMIDATA);

   /* Pull the KmiClkIn high */  
   PSW(KMICLKIN,KMITISR,KMITISR);  
 
   /* Dummy cycles to go to TX st */ 
   L(12*EightMHz,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(TXST,STATE,KMISTATE,KMISTATE);     

   /* Supply KMICLK to force the st m/c to go to WAIT state */   
  for( i = 0; i < 10; i++)  
     {
       PSW(0x00,KMITISR,KMITISR); 
       L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);
       PSW(KMICLKIN,KMITISR,KMITISR); 
       L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);
     }

   PSW(KMIDATAIN,KMITISR,KMITISR); 
   L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);

   PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR); 
   L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);
  
   /* Dummy cycles to go to WAIT state */ 
   L(EightMHz,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(WAITST,STATE,KMISTATE,KMISTATE);     

   /* Disable the KMI at WAIT state */   
   PSW(0x00,KMICR,KMICR);  

   /* Dummy cycles for synchronisation */ 
   L(3,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     

   /* Enable the KMI */   
   PSW(KMIEN,KMICR,KMICR);  

   /* Dummy cycle for synchoronisation */ 
   L(3,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(IDLEST,STATE,KMISTATE,KMISTATE);     

   /* Pull KMICLKIN low to go to RX state */  
   PSW(0x00,KMITISR,KMITISR); 
   L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);

   /* Pull KMICLKIN high */  
   PSW(KMICLKIN,KMITISR,KMITISR); 
   L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(RXST,STATE,KMISTATE,KMISTATE);     

   /* Disable the KMI at RX state */   
   PSW(0x00,KMICR,KMICR);  

   /* Dummy cycles for synchronisation */ 
   L(3,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     

   /* Enable the KMI */   
   PSW(KMIEN,KMICR,KMICR);  

   /* Dummy cycle for synchoronisation */ 
   L(3,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(IDLEST,STATE,KMISTATE,KMISTATE);     

   /* Pull KMICLKIN low to go to RX state */  
   PSW(0x00,KMITISR,KMITISR); 
   L(4*EightMHz+2,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(RXST,STATE,KMISTATE,KMISTATE);     

   /* Supply KMICLK to force the st m/c to go to LOCK state */   
   for( i = 0; i < 10; i++)  
     {
       PSW(0x00,KMITISR,KMITISR); 
       L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);
       PSW(KMICLKIN,KMITISR,KMITISR); 
       L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);
     }

   /* Driving stop bit to bring the state m/c to LOCK state */
   PSW(KMIDATAIN,KMITISR,KMITISR); 
   L(3*EightMHz+2,MaskAll,MaskAll,KMITCER);

   PSW(KMICLKIN|KMIDATAIN,KMITISR,KMITISR); 
   L(4*EightMHz+2,MaskAll,MaskAll,KMITCER);

   /* Check the current state of the State M/C */  
   PSR(LOCKST,STATE,KMISTATE,KMISTATE);     

   /* Disable the KMI at RX state */   
   PSW(0x00,KMICR,KMICR);  

   /* Dummy cycles for synchronisation */ 
   L(3,MaskAll,MaskAll,KMITCER); 

   /* Check the current state of the State M/C */  
   PSR(RESETST,STATE,KMISTATE,KMISTATE);     

   /* Forcing KMICLKEN and KMIDATAEN to check their functionalities */ 

   /* Force KMICLKEN and KMIDATAEN by writing to the KMICR register */
   PSW(FKMIC | FKMID,KMICR,KMICR);
       
   /* Dummy cycles for synchronisation */ 
   L(3,MaskAll,MaskAll,KMITCER);

   /* Read the KMICLKEN and KMIDATAEN lines through the KMITOCR register */  
   PSR(0x00,KMICLKEN | KMIDATAEN,KMITOCR,KMITOCR);

   /* Force KMICLKEN and KMIDATAEN to zero by writing to the KMICR register */  
   PSW(0x00,KMICR,KMICR);
       
   /* Dummy cycles for synchronisation */ 
   L(3,MaskAll,MaskAll,KMITCER);

   /* Read the KMICLKEN and KMIDATAEN lines through the KMITOCR register */  
   PSR(KMICLKEN | KMIDATAEN,KMICLKEN | KMIDATAEN,KMITOCR,KMITOCR);

  /* Transmitter and Receiver Tests complete. */

  /* Clean up and ensure that the control state machine is in the  */
  /* Reset State when exiting from this test                       */
    
  /* Set TESTINPSEL to drive KmiClkIn from the KMITISR register */  
     
  PSW(TESTINPSEL,KMITCR,KMITCR); 
  PSW(0x00,KMITISR,KMITISR);

  /* Apply TESTRST for one PCLK period */ 
  PSW(TESTINPSEL | TESTRST,KMITCR,KMITCR); 
  PSW(TESTINPSEL,KMITCR,KMITCR); 
 
  /* Assert KmiClkIn for three EightMHz Pulse periods */
  /* so that it is detected as a valid pulse          */ 
  L(3*EightMHz,MaskAll,MaskAll,KMITCER);  

}

/******************************************************************************/
/*********************** Transmitter Tests ************************************/
/******************************************************************************/

void TX(int DIVVAL,int DivBypass,int TYPE) 
{
    
  /* 
     Summary: Transmit Test 
     ======================
     This following test checks the transmit functionality of the Kmi.    

     o The KMISTG2 counter is fed straight from pre-scaler, bypassing KMISTG1
       counter.   

     o This test starts by checking whether nKMICLKEN signal remains low for a
       duration of 64 us via the KMITOCR register. 

     o Each bit is then checked via the KMIDATAEN bit of the KMITOCR register
       after a valid KMICLKIN is supplied via the KMITISR register. 

     o This test checks the transmission of start bit, the 8-bit data, parity 
       and the stop bit for four data patterns. 
      
     o This test also checks the relevant flags during the course of 
       transmission via the KMISTAT register.
     
   */

   int EightMHz; 
   int TXBit; 
   int Data[4];
   int BitOnes; 
   char Display[80];
   int i;    
   int j;    

   /* Data to be transmitted */ 
   Data[0] = 0x00;  
   Data[1] = 0xFF;  
   Data[2] = 0x1F;  
   Data[3] = 0xF0;  

   if(DivBypass == 0)
     EightMHz = (DIVVAL & 0x0F) + 1;
   else
     EightMHz = 1;

   /* Assert TESTRST and switch to non-REGCLK mode. Bypass      */
   /* stage1 counter.                                           */
   /* Set the TESTINPSEL bit in the KMITCR register to drive    */ 
   /* KmiClkIn and KmiDataIn from the Test register(KMITISR)    */ 

   PSW(Stg1Bypass,KMITMR,KMITMR);
   PSW(TESTINPSEL | TESTRST , KMITCR,KMITCR);
   PSW(0x00, KMITISR,KMITISR);
   PSW(TESTINPSEL | TESTCLKEN | TESTEN , KMITCR,KMITCR);

   /* Check the TXINTR and RXINTR outputs and their    */
   /* respective Busy signals.                         */ 
   /* Ensure that the state M/C is in the Reset state. */ 

   PSR(TXE,TXE | TXB | RXB | RXF,KMISTAT,KMISTAT);    
   PSR(RESETST,STATE,KMISTATE,KMISTATE); 
   
   /* Enable the KMI, KMITXINTR and KMIRXINTR */ 
   if(DivBypass == 1)
     {  
       if(TYPE == 0)    
          PSW(KMIEN | KMITXEEN | KMIRXFEN,KMICR,KMICR); 
       else  
          PSW(KMIEN | KMITYPE | KMITXEEN | KMIRXFEN,KMICR,KMICR); 
     }

   /* Load a Clock Divider value into the CLKDIV register and  */ 
   /* apply dummy cycles to synchronise                        */
   if(DivBypass == 0)
     {
       PSW(DIVVAL,KMICLKDIV,CLKDIV);
       L(1,MaskAll,MaskAll,KMITCER);
       if(TYPE == 0) 
          PSW(KMIEN | KMITXEEN | KMIRXFEN,KMICR,KMICR); 
       else 
          PSW(KMIEN | KMITYPE | KMITXEEN | KMIRXFEN,KMICR,KMICR); 
       L(1,MaskAll,MaskAll,KMITCER);
     }   

   /* Pull KmiClkIn high to force the state M/C into the IDLE state */ 
   PSW(KMICLKIN,KMITISR,KMITISR);
   
   /* Dummy cycle to synchronise KmiClkIn i/p */       
   L(1,MaskAll,MaskAll,KMITCER); 

   /* Check KMIINTR */
   PSR(KMIINTR,KMIINTR,KMITOCR,KMITOCR);

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1) 
     L(3*EightMHz - 1 ,MaskAll,MaskAll,KMITCER); 
   else   
     L(3*EightMHz + 1,MaskAll,MaskAll,KMITCER); 
   
   for(i = 0; i < 4 ; i++) 
   {
   /* Check whether the state M/C is in the IDLE state */
   PSR(IDLEST,STATE,KMISTATE,KMISTATE); 

   if(DivBypass == 0 && DIVVAL == 1)   
      PSR(MaskAll,MaskAll,KMITCER);

   if(DivBypass == 0 && DIVVAL > 2)   
     L(EightMHz - 3 ,MaskAll,MaskAll,KMITCER); 
 
   /* Write a data into KMIDATA  */ 
   PSW(Data[i],KMIDATA,KMIDATA);  

   /* Checking for TXINTR cleared after a Data has written into the KMIDATA */  
   PSR(0x00,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

   /* Dummy cycles to Synchronise to see the TXINTR clear */ 
   L(3, MaskAll, MaskAll, KMITCER);

   /* Check the current state of the State M/C */  
   PSR(TX64USST,STATE,KMISTATE,KMISTATE); 

   if(DivBypass == 1)
    L(8*EightMHz, 0x00 , KMICLKEN | KMIINTR, KMITOCR);

   if(DivBypass == 0 && DIVVAL == 1)    
    L(9*EightMHz - 1, 0x00 , KMICLKEN | KMIINTR, KMITOCR);

   if(DivBypass == 0 && DIVVAL == 2)    
     L(9*EightMHz - 2, 0x00, KMICLKEN | KMIINTR, KMITOCR);

   if(DivBypass == 0 && DIVVAL == 3)    
     L(9*EightMHz - 1, 0x00, KMICLKEN | KMIINTR, KMITOCR);

  if(DivBypass == 0 && DIVVAL > 3)    
    L(9*EightMHz - 5, 0x00, KMICLKEN | KMIINTR, KMITOCR);

  PSR(0x00,KMIDATAEN,KMITOCR,KMITOCR); 

  /* Check for TXBUSY after the state machine enters into the TXU64 state */  
  PSR(TXB,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

  if(DivBypass == 0 && DIVVAL == 1) 
    PSR(0x00 ,KMIDATAEN | KMIINTR,KMITOCR); 

  if(DivBypass == 0 && DIVVAL > 2) 
    L(EightMHz - 3,0x00 ,KMIDATAEN | KMIINTR,KMITOCR); 

  TXBit     = 0 ; 
  BitOnes   = 0 ; 
  
  for(j = 0 ; j < (11 - TYPE) ; j++) 
    { 

      TXBit = Data[i] & 0x01;   
   
      if(TXBit == 1 && j < 8)
        BitOnes++; 

      if(j ==  8)
        TXBit = (BitOnes + 3) % 2; 

      if(j ==  9 || j == 10) 
        TXBit = 1; 

      /* Pull KmiClkIn low */ 
      PSW(KMIDATAIN,KMITISR,KMITISR); 
          
      /* Check for TXBUSY */  
      PSR(TXB,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);
           
      /* Dummy cycles for a valid low to be detected on KmiClkIn */
      if(DivBypass == 1)
        L(4*EightMHz,MaskAll,MaskAll,KMITCER);  
 
      if(DivBypass == 0)
        {
          if(DIVVAL == 1)      
             L(4*EightMHz - 2,MaskAll,MaskAll,KMITCER);  
          else 
             L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER);  
        }

      /* Pull KmiClkIn high */ 
      PSW(KMICLKIN | KMIDATAIN,KMITISR,KMITISR);
 
      /* Check for TXBUSY */  
      PSR(TXB,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

      /* Check TXBit */
      L(EightMHz,TXBit,KMIDATAEN | KMIINTR,KMITOCR);
           
      /* Dummy cycles for a valid low to be detected on KmiClkIn */
      if(DivBypass == 1)
        L(3*EightMHz,MaskAll,MaskAll,KMITCER);  
 
      if(DivBypass == 0)
        {
          if(DIVVAL == 1)      
             L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER);  
          else
            L(2*EightMHz - 2,MaskAll,MaskAll,KMITCER);  
        }

     if(j < 8)
       Data[i] = Data[i] >> 1;

     } 
 
      L(3*EightMHz + 2,MaskAll,MaskAll,KMITOCR); 

   }

   /* Transmitter Tests complete. */

   /* Clean up and ensure that the control state machine is in the  */
   /* Reset State when exiting from this test                       */
    
   /* Set TESTINPSEL to drive KmiClkIn from the KMITISR register */  
     
   PSW(TESTINPSEL,KMITCR,KMITCR); 
   PSW(0x00,KMITISR,KMITISR);

   /* Apply TESTRST for one PCLK period */ 
   PSW(TESTINPSEL | TESTRST,KMITCR,KMITCR); 
   PSW(TESTINPSEL,KMITCR,KMITCR); 
 
   /* Assert KmiClkIn for three EightMHz Pulse periods */
   /* so that it is detected as a valid pulse          */ 
   L(3*EightMHz,MaskAll,MaskAll,KMITCER);  

 } 

/******************************************************************************/
/*************************** Receiver Tests ***********************************/
/******************************************************************************/

void RX(int DIVVAL,int DivBypass)
{
  /* 
     Summary: Transmit Test 
     ======================
     This following test checks the receive functionality of the Kmi.    

     o The KMISTG2 counter is fed straight from pre-scaler, bypassing KMISTG1
       counter.   

     o The receive data - start, 8-bit data, parity, stop bit - is simulated   
       by toggling the KMIDATAIN bit of the KMITISR register. 

     o After reception, the data and its corresponding parity bit is read from 
       the KMIDATA and the KMISTAT registers respectively.
 
     o This test simulates reception of four data patterns. 
     
  */

   int EightMHz; 
   int RXBit; 
   int Parity; 
   int Data[4];
   int RdData;
   int BitOnes; 
   int i;    
   int j;    

   /* Data to be Received */ 
   Data[0] = 0x00;  
   Data[1] = 0xFF;  
   Data[2] = 0x0F;  
   Data[3] = 0xF1;  

   if(DivBypass == 0)
     EightMHz = (DIVVAL & 0x0F) + 1;
   else
     EightMHz = 1;

   /* Assert TESTRST and switch to non-REGCLK mode. Bypass      */
   /* stage1 counter.                                           */
   /* Set the TESTINPSEL bit in the KMITCR register to drive    */ 
   /* KmiClkIn and KmiDataIn from the Test register(KMITISR)    */ 

   PSW(Stg1Bypass,KMITMR,KMITMR);
   PSW(TESTINPSEL | TESTRST , KMITCR,KMITCR);
   PSW(0x00, KMITISR,KMITISR);
   PSW(TESTINPSEL | TESTCLKEN | TESTEN , KMITCR,KMITCR);

   /* Check the TXINTR and RXINTR outputs and their    */
   /* respective Busy signals.                         */ 
   /* Ensure that the state M/C is in the Reset state. */ 

   PSR(TXE,TXE | TXB | RXB | RXF,KMISTAT,KMISTAT);    
   PSR(RESETST,STATE,KMISTATE,KMISTATE); 
   
   /* Enable the KMI, KMITXINTR and KMIRXINTR */ 
   if(DivBypass == 1)
     PSW(KMIEN | KMITXEEN | KMIRXFEN,KMICR,KMICR); 

   /* Load a Clock Divider value into the CLKDIV register and  */ 
   /* apply dummy cycles for synchronisation                   */
   if(DivBypass == 0)
     {
       PSW(DIVVAL,KMICLKDIV,CLKDIV);
       L(1,MaskAll,MaskAll,KMITCER);
       PSW(KMIEN | KMITXEEN | KMIRXFEN,KMICR,KMICR); 
       L(1,MaskAll,MaskAll,KMITCER);
     }   
   /* Pull KmiClkIn high to force the state M/C into the IDLE state */ 
   PSW(KMICLKIN,KMITISR,KMITISR);
   
   /* Dummy cycles to synchronise KmiClkIn */       
   L(2,MaskAll,MaskAll,KMITCER); 

   /* Dummy cycles to make KmiClkIn to be detected as a valid high pulse */
   if(DivBypass == 0 && DIVVAL != 1) 
     L(3*EightMHz - 1 ,MaskAll,MaskAll,KMITCER); 
   else   
     L(3*EightMHz + 1,MaskAll,MaskAll,KMITCER); 
   
   for(i = 0; i < 4 ; i++) 
   {

    RdData = Data [i]; 

    /* Check whether the state machine is in the IDLE state */
    PSR(IDLEST,STATE,KMISTATE,KMISTATE); 

    if(DivBypass == 0 && DIVVAL == 1)   
      PSR(MaskAll,MaskAll,KMITCER);

    if(DivBypass == 0 && DIVVAL > 2)   
      L(EightMHz - 3 ,MaskAll,MaskAll,KMITCER); 

   RXBit   = 0; 
   BitOnes = 0; 

   for(j = 0 ; j < 11 ; j++) 
     { 
        RXBit = Data[i] & 0x01 & KMIDATAIN;   
   
        if(RXBit == 1 && j < 8 && j > 0)
          BitOnes++; 

        if(j == 0)
           RXBit = 0; 
        if(j ==  9)
          {
             RXBit   = ((BitOnes + 3) % 2) & KMIDATAIN; 
             Parity  = RXBit;
           }
       
        if(j ==  10) 
          RXBit = 1 & KMIDATAIN; 

        /* Pull KmiClkIn Low */ 
        PSW(0x00,KMITISR,KMITISR); 
          
        /* Drive RXBit */ 
        PSW(RXBit,KMITISR,KMITISR); 

        /* Check for RXBUSY */  
        if(j == 0 )
          PSR(MaskAll,MaskAll,KMITCER);  
        else 
          PSR(RXB | TXE,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

        /* Dummy cycles for a valid low to be detected on KmiClkIn */
        if(DivBypass == 1)
           L(3*EightMHz,MaskAll,MaskAll,KMITCER);  
 
        if(DivBypass == 0)
          {
            if(DIVVAL == 1)      
               L(4*EightMHz - 3,MaskAll,MaskAll,KMITCER);  
            else 
               L(3*EightMHz - 3,MaskAll,MaskAll,KMITCER);  
          }

        PSW(KMICLKIN | RXBit,KMITISR,KMITISR);
 
        /* Check for RXBUSY */  
        if(j == 0 )
          PSR(MaskAll,MaskAll,KMITCER);  
        else 
           PSR(RXB | TXE,RXB | RXF | TXE | TXB,KMISTAT,KMISTAT);

        /* Dummy cycles for a valid low to be detected on KmiClkIn */
        if(DivBypass == 1)
           L(4*EightMHz,MaskAll,MaskAll,KMITCER);  
 
        if(DivBypass == 0)
          {
            if(DIVVAL == 1)      
               L(4*EightMHz - 2,MaskAll,MaskAll,KMITCER);  
            else
               L(3*EightMHz - 2,MaskAll,MaskAll,KMITCER);  
           }

     if(j > 0 && j < 8)
        Data[i] = Data[i] >> 1;
    } 
  
    /* Dummy cycle to go to LOCK state */ 
    PSR(MaskAll,MaskAll,KMITCER);

   /* Dummy cycles to read the RXF flag and received Data */
    L(3,MaskAll,MaskAll,KMITCER);
    
   if(DIVVAL < 5 && DivBypass == 0)
     L(3*EightMHz - 4,MaskAll,MaskAll,KMITOCR);
   else
     L(2*EightMHz - 4,MaskAll,MaskAll,KMITOCR);

   /* Check the RXF & KMIINTR flags and read the received data */
   PSR(RXF,RXF,KMISTAT,KMISTAT);
   PSR(KMIINTR,KMIINTR,KMITOCR);
   PSR(RdData,DATA,KMIDATA,KMIDATA);

   if(Parity == 1) 
     PSR(RXP,RXP,KMISTAT,KMISTAT);
   else 
     PSR(0x00,RXP,KMISTAT,KMISTAT);

    /* Additional Dummy cycles to go to IDLE state */
    if(DIVVAL < 2 && DivBypass == 0)
      L(3*EightMHz ,MaskAll,MaskAll,KMITOCR);

    /* Dummy cycle to go to IDLE state */
    if(DIVVAL < 4 && DivBypass == 0)
       L(4*EightMHz - 2,MaskAll,MaskAll,KMITOCR);
    else
       L(3*EightMHz - 2,MaskAll,MaskAll,KMITOCR);

    if(DivBypass == 1) 
       L(10,MaskAll,MaskAll,KMITOCR);
  }

   /* Receiver Tests complete. */

   /* Clean up and ensure that the control state machine is in the  */
   /* Reset State when exiting from this test                       */
    
   /* Set TESTINPSEL to drive KmiClkIn from the KMITISR register */  
     
   PSW(TESTINPSEL,KMITCR,KMITCR); 
   PSW(0x00,KMITISR,KMITISR);

   /* Apply TESTRST for one PCLK period */ 
   PSW(TESTINPSEL | TESTRST,KMITCR,KMITCR); 
   PSW(TESTINPSEL,KMITCR,KMITCR); 
 
   /* Assert KmiClkIn for three EightMHz Pulse periods */
   /* so that it is detected as a valid pulse          */ 
   L(3*EightMHz,MaskAll,MaskAll,KMITCER);  
   
 }

