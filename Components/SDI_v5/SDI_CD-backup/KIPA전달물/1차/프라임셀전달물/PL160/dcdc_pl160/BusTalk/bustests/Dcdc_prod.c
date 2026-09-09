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
--  File Name              : Dcdc_prod.c,v
--  File Revision          : 1.1
--
--  Release Information    : PL160-REL1v1
--
--------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
--  Purpose  :
--             This file is used to produce BusTalk test vectors for
--             functional verification of the Dcdc using "clock enable control".
--             All tests in this module assume that DCDCCLK is connected to the
--             APB clock PCLK in the testbench.
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** This file verifies Dcdc Register and Test Mode functionality.          ***/
/******************************************************************************/
 
/******************************************************************************/
/*** This C code file is used to generate BusTalk and TicTalk test vectors. ***/
/*** BusTalk vectors are applied to the AMBA APB bus.                       ***/
/*** TicTalk vectors are applied to the AMBA APB via the 'ticbox'.          ***/
/***                                                                        ***/
/*** Files required for compilation:                                        ***/
/***   makefile, busheader.h, busmacros.h, busmacros.c,                     ***/
/***   config.h, addargs_script,                                            ***/
/***   Dcdc_prod.c                                                          ***/
/***                                                                        ***/
/*** Usage: make <testname> e.g. make Dcdc_prod                             ***/
/***                                                                        ***/
/*** To create .bif formatted vectors from the BusTalk code (default)       ***/
/***   make <testname> e.g. make Dcdc_prod                                  ***/
/*** This will create testname.bif in the ./invec directory                 ***/
/***                                                                        ***/
/*** To create .tif formatted vectors from the BusTalk code                 ***/
/***                                                                        ***/
/*** edit the config.h file and include the #define TIF                     ***/
/***   setenv VECT_TYPE TIF from the unix command line                      ***/
/***   make <testname>                                                      ***/
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
/*** Include common BusTalk files                                           ***/
/******************************************************************************/
#include "busmacros.h"
#include "busheader.h"
#include "config.h"

#include <stdio.h>

/* Mask Values */
#define NoMaskCon   0x000000FF
#define NoMaskTCR   0x0000001F
#define NoMaskTISR  0x0000003F
#define MaskAll     0x00000000

/******************************/
/* NORMAL-MODE REGISTERS      */     
/******************************/

#define BASE_ADD      0x84000000

#define PMPCON0       BASE_ADD + 0x00
#define PMPCON1       BASE_ADD + 0x04
#define PMPFREQ       BASE_ADD + 0x08


/************************/
/* TEST  REGISTERS      */     
/************************/

#define PMPTCER       BASE_ADD + 0x40
#define PMPTCR        BASE_ADD + 0x80
#define PMPTMR        BASE_ADD + 0x84
#define PMPTISR       BASE_ADD + 0x88
#define PMPTOCR       BASE_ADD + 0x8C
#define PMPFC0        BASE_ADD + 0x90
#define PMPFC1        BASE_ADD + 0x98
#define PMPDRVCNT     BASE_ADD + 0xA0

/************************/
/* VIRTUAL  REGISTERS   */     
/************************/

#define  DCDCDRIVEIN_reg  R0
#define  DCDCFB_reg       R1
#define  DCDCDRSEL_reg    R2
#define  DCDCDRIVEOUT_reg  R3

/************************/
/* Command Definitions  */     
/************************/
#define   Cmd1800KhzSel1  (0x000 + (DutyCyc * 0x10))
#define   Cmd1800KhzSel0  (0x000 + DutyCyc)
#define   Cmd900KhzSel1   (0x500 + (DutyCyc * 0x10))
#define   Cmd900KhzSel0   (0x500 + DutyCyc)
#define   Cmd225KhzSel1   (0xA00 + (DutyCyc * 0x10))
#define   Cmd225KhzSel0   (0xA00 + DutyCyc)
#define   Cmd95KhzSel1    (0xF00 + (DutyCyc * 0x10))
#define   Cmd95KhzSel0    (0xF00 + DutyCyc)

/*************************/
/* Function declarations */
/*************************/
void RegResetTest();
void Pos1800KhzDrv0Sel1();
void Pos1800KhzDrv0Sel0();
void Neg1800KhzDrv0Sel0();
void FeedBack0();
void Pos1800KhzDrv1Sel1();
void Pos1800KhzDrv1Sel0();
void Neg1800KhzDrv1Sel0();
void FeedBack1();
void CntrTest();
void Pos900KhzDrv0Sel0();
void Pos225KhzDrv0Sel0();
void Pos95KhzDrv0Sel0();
void Pos900KhzDrv1Sel0();
void Pos225KhzDrv1Sel0();
void Pos95KhzDrv1Sel0();

/********/
/* MAIN */
/********/

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
  C("File Name              : Dcdc_prod.c,v",header);
  C("File Revision          : 1.1",header);
  C(" ",header);
  C("Release Information    : PL160-REL1v1",header);
  C("-----------------------------------------------------------------------------",header);

TestStart();

RES(LOW,0x1,0x1);
PI(0x02);


C("Register Reset Verification");
  RegResetTest();

C("Verify COUNTER Operation");
  CntrTest();
  
C("Verify DRIVE0OUT Operation DRVSEL = '0'");
  Pos1800KhzDrv0Sel0();
  
C("Verify Negative DRIVE0OUT Operation DRVSEL = '0'");
  Neg1800KhzDrv0Sel0();
 
C("Verify DRIVE0OUT Operation DRVSEL = '1'");
  Pos1800KhzDrv0Sel1();
  
C("Verify FEEDBACK0 Operation");
  FeedBack0();
  
C("Verify DRIVE1OUT Operation DRVSEL = '0'");
  Pos1800KhzDrv1Sel0();
  
C("Verify Negative DRIVE1OUT Operation DRVSEL = '0'");
  Neg1800KhzDrv1Sel0();
  
C("Verify DRIVE1OUT Operation DRVSEL = '1'");
  Pos1800KhzDrv1Sel1();
 
C("Verify FEEDBACK1 Operation");
  FeedBack1();
  
C("Verify 900Khz DRIVE0OUT Operation DRVSEL = '0'");
  Pos900KhzDrv0Sel0();
  
C("Verify 225Khz DRIVE0OUT Operation DRVSEL = '0'");
  Pos225KhzDrv0Sel0();

C("Verify 95Khz DRIVE0OUT Operation DRVSEL = '0'");
  Pos95KhzDrv0Sel0();

C("Verify 900Khz DRIVE1OUT Operation DRVSEL = '0'");
  Pos900KhzDrv1Sel0();

C("Verify 225Khz DRIVE1OUT Operation DRVSEL = '0'");
  Pos225KhzDrv1Sel0();

C("Verify 95Khz DRIVE1OUT Operation DRVSEL = '0'");
  Pos95KhzDrv1Sel0();

TestEnd();

return 0;

}


/***********************/
/* Register Reset Test */
/***********************/

void RegResetTest()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;





/* Check Reset values of Registers*/
  C("RESET VALUE TESTS");


/* Reset Dcdc */
  PSR(0x00000000,NoMaskCon,PMPTCR);
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Normal Mode Registers */
  C("Config Reg Reset Tests");
  PSR(0x00000000,NoMaskCon,PMPCON0);
  PSR(0x00000000,NoMaskCon,PMPCON1);
  PSR(0x00000000,NoMaskCon,PMPFREQ);

/* Test Mode Registers */
  C("Test Mode Reg Reset Tests");
  PSR(0x00000000,NoMaskCon,PMPTCER);
  PSR(0x00000000,NoMaskCon,PMPTMR);
  PSR(0x00000000,NoMaskCon,PMPTISR);
  PSR(0x00000000,NoMaskCon,PMPFC0);
  PSR(0x00000000,NoMaskCon,PMPFC1);
  PSR(0x000000,NoMaskCon,PMPDRVCNT);
  PSR(0x00000004,NoMaskCon,PMPTOCR);



/* Check Reads and Writes to Configuration Registers */
  C("CONFIG REG's R/W TESTS");

/* Reset Dcdc */
  PSW(0x19,PMPTCR);
  PSW(0X13,PMPTCR);

  PSW(0x55,PMPCON0);
  PSW(0x55,PMPCON1);
  PSW(0x55,PMPFREQ);

  PSR(0x55,NoMaskCon,PMPCON0); 
  PSR(0x55,NoMaskCon,PMPCON1); 
  PSR(0x55,NoMaskCon,PMPFREQ); 

  PSW(0xAA,PMPCON0);
  PSW(0xAA,PMPCON1);
  PSW(0xAA,PMPFREQ);

  PSR(0xAA,NoMaskCon,PMPCON0); 
  PSR(0xAA,NoMaskCon,PMPCON1); 
  PSR(0xAA,NoMaskCon,PMPFREQ); 

  PSW(0xFF,PMPCON0);
  PSW(0xFF,PMPCON1);
  PSW(0xFF,PMPFREQ);

  PSR(0xFF,NoMaskCon,PMPCON0); 
  PSR(0xFF,NoMaskCon,PMPCON1);  
  PSR(0xFF,NoMaskCon,PMPFREQ);  

/* Check R/W  Test Input Stimulus Register */
  C("Test Input Stimulus Reg R/W TESTS");


  /*Reset and  Configure to read from internal TISR Reg */
  PSW(0x17,PMPTCR); 
  PSW(0x00,PMPFREQ);
  PSW(0x13,PMPTCR); 


  /* Write to and Read from TISR Reg */
  C("Write to and Read from TISR Reg");
  PSW(0x00,PMPTISR); 
  PSW(0x00,PMPTCER); 
  PSR(0x00,NoMaskTISR,PMPTISR); 

  PSW(0x15,PMPTISR); 
  PSW(0x00,PMPTCER); 
  PSR(0x15,NoMaskTISR,PMPTISR); 

  PSW(0x2A,PMPTISR); 
  PSW(0x00,PMPTCER); 
  PSR(0x2A,NoMaskTISR,PMPTISR); 

  PSW(0x33,PMPTISR); 
  PSW(0x00,PMPTCER); 
  PSR(0x33,NoMaskTISR,PMPTISR); 
 
 

}



/******************************************************************************/
/*                         COUNTER TESTS                                      */
/******************************************************************************/


void CntrTest()
{

int h = 0;
int i = 0;
int j = 0;


/* Configure the Non-AMBA Inputs */
  PSW(0x33,PMPTISR);

/* Reset Dcdc */
  PSW(0x03,PMPTMR);
  PSW(0x19,PMPTCR);
  PSW(0X13,PMPTCR);

/* Configure the Frequency*/
  PSW(0xFF,PMPFREQ);
  PNR(PMPFC0);
  PNR(PMPFC0);

/* Read Frequency Counter 0 */
  PSR(0x00,0x007,PMPFC0);
  PSR(0x00,0x007,PMPFC0);
  PSR(0x11,0x007,PMPFC0);
  PSR(0x02,0x007,PMPFC0);
  PSR(0x13,0x007,PMPFC0);
  PSR(0x04,0x007,PMPFC0);
  PSR(0x15,0x007,PMPFC0);
  PSR(0x06,0x007,PMPFC0);
  PSR(0x17,0x007,PMPFC0);
  PSR(0x08,0x007,PMPFC0);
  PSR(0x19,0x007,PMPFC0);
  PSR(0x0A,0x007,PMPFC0);
  PSR(0x1B,0x007,PMPFC0);
  PSR(0x0C,0x007,PMPFC0);
  PSR(0x1D,0x007,PMPFC0);
  PSR(0x0E,0x007,PMPFC0);
  PSR(0x1F,0x007,PMPFC0);


/* Configure the Non-AMBA Inputs */
  PSW(0x33,PMPTISR);

/* Reset Dcdc */
  PSW(0x03,PMPTMR);
  PSW(0x19,PMPTCR);
  PSW(0X13,PMPTCR);

/* Configure the Frequency*/
  PSW(0xFF,PMPFREQ);
  PNR(PMPFC1);
  PNR(PMPFC1);

/* Read Frequency Counter 1 */
  PSR(0x00,0x007,PMPFC1);
  PSR(0x00,0x007,PMPFC1);
  PSR(0x11,0x007,PMPFC1);
  PSR(0x02,0x007,PMPFC1);
  PSR(0x13,0x007,PMPFC1);
  PSR(0x04,0x007,PMPFC1);
  PSR(0x15,0x007,PMPFC1);
  PSR(0x06,0x007,PMPFC1);
  PSR(0x17,0x007,PMPFC1);
  PSR(0x08,0x007,PMPFC1);
  PSR(0x19,0x007,PMPFC1);
  PSR(0x0A,0x007,PMPFC1);
  PSR(0x1B,0x007,PMPFC1);
  PSR(0x0C,0x007,PMPFC1);
  PSR(0x1D,0x007,PMPFC1);
  PSR(0x0E,0x007,PMPFC1);
  PSR(0x1F,0x007,PMPFC1);


/* Configure the Non-AMBA Inputs */
  PSW(0x33,PMPTISR);

/* Reset Dcdc */
  PSW(0x03,PMPTMR);
  PSW(0x19,PMPTCR);
  PSW(0X13,PMPTCR);
  PNR(PMPFC1);
  PNR(PMPFC1);

/* Configure the Frequency*/
  PSW(0xFF,PMPFREQ);
  PNR(PMPFC1);
  PNR(PMPFC1);
 
/* Read Drive Counter  */
  PSR(0x00,0x007,PMPDRVCNT);
  PSR(0x11,0x007,PMPDRVCNT);
  PSR(0x22,0x007,PMPDRVCNT);
  PSR(0x33,0x007,PMPDRVCNT);
  PSR(0x44,0x007,PMPDRVCNT);
  PSR(0x55,0x007,PMPDRVCNT);
  PSR(0x66,0x007,PMPDRVCNT);
  PSR(0x77,0x007,PMPDRVCNT);
  PSR(0x88,0x007,PMPDRVCNT);
  PSR(0x99,0x007,PMPDRVCNT);
  PSR(0xAA,0x007,PMPDRVCNT);
  PSR(0xBB,0x007,PMPDRVCNT);
  PSR(0xCC,0x007,PMPDRVCNT);
  PSR(0xDD,0x007,PMPDRVCNT);
  PSR(0xEE,0x007,PMPDRVCNT);
  PSR(0xFF,0x007,PMPDRVCNT);

  /* Clear Nibble Advancement of counters */
  PSW(0x00,PMPTMR);

}


/******************************************************************/
/* Positive Polarity Drive 0  1800Khz Functional Test DRV0SEL = 0 */
/******************************************************************/

void Pos1800KhzDrv0Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE0OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 1800Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x32,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0xF; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON0); 
            PSW(0x00,PMPCON0);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON0); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x2; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 0xD; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 4       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 5; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 13; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}





/******************************************************************/
/* Negative Polarity Drive 0  1800Khz Functional Test DRV0SEL = 0 */
/******************************************************************/

void Neg1800KhzDrv0Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE0OUT with Neg Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for Negative 1800Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x3E,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between */
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0xF; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON0); 
            PSW(0x00,PMPCON0);
            PSR(0x07,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON0); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x2; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 0xD; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 4       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 5; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 13; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}





/******************************************************************/
/* Positive Polarity Drive 0  1800Khz Functional Test DRV0SEL = 1 */
/******************************************************************/

void Pos1800KhzDrv0Sel1()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE0OUT with Pos Drive Polarity   */
/* DRV0SEL = 1                            */
/******************************************/

  C("Config for 1800Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x33,PMPTISR);

/* Reset Dcdc Counters and Registers*/
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */  
/* access to TCER */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between */
/* BusTalk and TicTalk environments */
   PSW(0x00,PMPCON0); 
   PSW(0x00,PMPCON0); 
   PSW(0x00,PMPCON0); 



  /* ------ FOR DUTY CYCLE 0 ----------------*/
   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0xF; h++) {
            PSW(0x00,PMPCON0); 
            PSW(0x00,PMPCON0); 
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);
          }
        }

  /* ------ FOR DUTY CYCLE 1 ----------------*/
   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x10,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x2; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             }
             else {
               for (h = 0; h < 0xD; h++) {
               PSW(0x00,PMPTCER);
               }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 2 ----------------*/
   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x20,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0xB; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);



          } else {
             for (h = 0; h < 0xC; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);


          }

        }

  /* ------ FOR DUTY CYCLE 3 THRU 13 ----------------*/

     for (DutyCyc = 3; DutyCyc < 14; DutyCyc++ ) {

   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(Cmd1800KhzSel1,PMPCON0); 
     PSW(0X17,PMPTCR);

             
        for ( j = 0; j <= 0x4; j++ ) {
        
          if (j ==0){  
             for (h = 0; h < (0xD - DutyCyc); h++) {
               PSW(0x00,PMPTCER);
             }
	  } else {
             for (h = 0; h < (0xE - DutyCyc); h++) {
               PSW(0x00,PMPTCER);
	     }
          }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < DutyCyc; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);


        }

     }

  /* ------ FOR DUTY CYCLE 14 ----------------*/
   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(Cmd1800KhzSel1,PMPCON0); 
     PSW(0X17,PMPTCR);


        for ( j = 0; j <= 0x4; j++ ) {

             for (i = 0; i < 14; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }
	
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);


        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;

   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(Cmd1800KhzSel1,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if (j==0){
             for (i = 0; i < 13; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }
	  } else {
             for (i = 0; i < 15; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }
          }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);


         

        }

}


/******************************************************************/
/* Feedback Test Drive 0                                          */
/******************************************************************/

void FeedBack0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/* Configure the Non-AMBA Inputs */
  PSW(0x23,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0xF; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON0); 
            PSW(0x00,PMPCON0);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON0); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x2; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 0xD; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 4       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 5; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 13; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}







/******************************************************************/
/* Positive Polarity Drive 1  1800Khz Functional Test DRV0SEL = 0 */
/******************************************************************/

void Pos1800KhzDrv1Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE0OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 1800Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x31,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0xF; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON1); 
            PSW(0x00,PMPCON1);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON1); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x2; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 0xD; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 4       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 5; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 13; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}





/******************************************************************/
/* Negative Polarity Drive 1  1800Khz Functional Test DRV0SEL = 0 */
/******************************************************************/

void Neg1800KhzDrv1Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE01UT with Neg Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for Negative 1800Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x3D,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between */
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0xF; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON1); 
            PSW(0x00,PMPCON1);
            PSR(0x07,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON1); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x2; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 0xD; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 4       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 5; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 13; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x07,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}





/******************************************************************/
/* Positive Polarity Drive 1  1800Khz Functional Test DRV0SEL = 1 */
/******************************************************************/

void Pos1800KhzDrv1Sel1()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE1OUT with Pos Drive Polarity   */
/* DRV0SEL = 1                            */
/******************************************/

  C("Config for 1800Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x33,PMPTISR);

/* Reset Dcdc Counters and Registers*/
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */  
/* access to TCER */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between */
/* BusTalk and TicTalk environments */
   PSW(0x00,PMPCON1); 
   PSW(0x00,PMPCON1); 
   PSW(0x00,PMPCON1); 



  /* ------ FOR DUTY CYCLE 0 ----------------*/
   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0xF; h++) {
            PSW(0x00,PMPCON1); 
            PSW(0x00,PMPCON1); 
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);
          }
        }

  /* ------ FOR DUTY CYCLE 1 ----------------*/
   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x10,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x2; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             }
             else {
               for (h = 0; h < 0xD; h++) {
               PSW(0x00,PMPTCER);
               }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 2 ----------------*/
   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x20,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0xB; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);



          } else {
             for (h = 0; h < 0xC; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);


          }

        }

  /* ------ FOR DUTY CYCLE 3 THRU 13 ----------------*/

     for (DutyCyc = 3; DutyCyc < 14; DutyCyc++ ) {

   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(Cmd1800KhzSel1,PMPCON1); 
     PSW(0X17,PMPTCR);

             
        for ( j = 0; j <= 0x4; j++ ) {
        
          if (j ==0){  
             for (h = 0; h < (0xD - DutyCyc); h++) {
               PSW(0x00,PMPTCER);
             }
	  } else {
             for (h = 0; h < (0xE - DutyCyc); h++) {
               PSW(0x00,PMPTCER);
	     }
          }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < DutyCyc; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);


        }

     }

  /* ------ FOR DUTY CYCLE 14 ----------------*/
   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(Cmd1800KhzSel1,PMPCON1); 
     PSW(0X17,PMPTCR);


        for ( j = 0; j <= 0x4; j++ ) {

             for (i = 0; i < 14; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }
	
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);


        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;

   /* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(Cmd1800KhzSel1,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if (j==0){
             for (i = 0; i < 13; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }
	  } else {
             for (i = 0; i < 15; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }
          }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);


         

        }

}


/******************************************************************/
/* Feedback Test Drive 1                                          */
/******************************************************************/

void FeedBack1()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/* Configure the Non-AMBA Inputs */
  PSW(0x13,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0xF; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON1); 
            PSW(0x00,PMPCON1);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON1); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x2; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 0xD; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 4       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 5; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 13; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}





/******************************************************************/
/* Positive Polarity Drive 0  900Khz Functional Test DRV0SEL = 0  */
/******************************************************************/

void Pos900KhzDrv0Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 900Khz Operation  */
/* On DRIVE0OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 900Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x32,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Frequency and Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON0); 
     PSW(0x01,PMPFREQ); 
     PNR(PMPFREQ);
     PNR(PMPFREQ);
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0x1E; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON0); 
            PSW(0x00,PMPCON0);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON0); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x4; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 0x1C; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 4       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 28; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}




/******************************************************************/
/* Positive Polarity Drive 0  225Khz Functional Test DRV0SEL = 0  */
/******************************************************************/

void Pos225KhzDrv0Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 225Khz Operation  */
/* On DRIVE0OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 225Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x32,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Frequency and Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON0); 
     PSW(0x02,PMPFREQ); 
     PNR(PMPFREQ);
     PNR(PMPFREQ);
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0x7E; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON0); 
            PSW(0x00,PMPCON0);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON0); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 120; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 8; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 118; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 8; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 5       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 102; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 8; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 118; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 8; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}



/******************************************************************/
/* Positive Polarity Drive 0  95Khz Functional Test DRV0SEL = 0  */
/******************************************************************/

void Pos95KhzDrv0Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 95Khz Operation  */
/* On DRIVE0OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 95Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x32,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 
  PSW(0x00,PMPCON0); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Frequency and Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON0); 
     PSW(0x03,PMPFREQ); 
     PNR(PMPFREQ);
     PNR(PMPFREQ);
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 304; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON0); 
            PSW(0x00,PMPCON0);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON0); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 264; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 283; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON0); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 5       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
          for (i = 0; i < 16; i++) {
               PSW(0x00,PMPTCER);
	     }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 245; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 283; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON0); 
               PSW(0x00,PMPCON0); 
               PSR(0x05,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}



/******************************************************************/
/* Positive Polarity Drive 1  900Khz Functional Test DRV0SEL = 0  */
/******************************************************************/

void Pos900KhzDrv1Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 900Khz Operation  */
/* On DRIVE1OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 900Khz Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x31,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Frequency and Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON1); 
     PSW(0x10,PMPFREQ); 
     PNR(PMPFREQ);
     PNR(PMPFREQ);
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0x1E; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON1); 
            PSW(0x00,PMPCON1);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON1); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 0x4; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 0x1C; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 4       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 28; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Two dummy Writes, Read Output Status */
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}




/******************************************************************/
/* Positive Polarity Drive 1  225Khz Functional Test DRV0SEL = 0  */
/******************************************************************/

void Pos225KhzDrv1Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 225Khz Operation  */
/* On DRIVE1OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 225Khz Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x31,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Frequency and Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON1); 
     PSW(0x20,PMPFREQ); 
     PNR(PMPFREQ);
     PNR(PMPFREQ);
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 0x7E; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON1); 
            PSW(0x00,PMPCON1);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON1); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 120; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 8; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 118; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 8; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 5       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
               PSW(0x00,PMPTCER);
 
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 102; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 8; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 118; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 8; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}



/******************************************************************/
/* Positive Polarity Drive 1  95Khz Functional Test DRV0SEL = 0  */
/******************************************************************/

void Pos95KhzDrv1Sel0()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 95Khz Operation  */
/* On DRIVE1OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 95Khz Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  PSW(0x31,PMPTISR);

/* Reset Dcdc Counters and Registers */
/* with a Test Reset and place in Clock */
/* Enabled mode with advance only on */
/* access to TCER  */
  PSW(0x19,PMPTCR);
  PSW(0X17,PMPTCR);

/* Advance system clock with dummy writes */
/* to assure proper counter alignment between*/
/* BusTalk and TicTalk environments */
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 
  PSW(0x00,PMPCON1); 


  /* ------ FOR DUTY CYCLE 0 ----------------*/

/* Configure the Dcdc Frequency and Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x00,PMPCON1); 
     PSW(0x30,PMPFREQ); 
     PNR(PMPFREQ);
     PNR(PMPFREQ);
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
   
          for (h = 0; h < 304; h++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
            PSW(0x00,PMPCON1); 
            PSW(0x00,PMPCON1);
            PSR(0x04,0x07,PMPTOCR);
            PSW(0x00,PMPTCER);     
          }
        }


  /* ------ FOR DUTY CYCLE 1 ----------------*/
/* Configure the Dcdc Duty Cycle */
     PSW(0X13,PMPTCR);
     PSW(0x01,PMPCON1); 
     PSW(0X17,PMPTCR);
        for ( j = 0; j <= 0x4; j++ ) {
          
          if ( j == 0 ) {
             for (h = 0; h < 264; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (h = 0; h < 283; h++) {
               PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

  /* ------ FOR DUTY CYCLE 15 ----------------*/
     DutyCyc = DutyCyc + 1;
     PSW(0X13,PMPTCR);
     PSW(0x0F,PMPCON1); 
     PSW(0X17,PMPTCR);

        for ( j = 0; j <= 0x4; j++ ) {
          if ( j == 0 ) {
           /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 5       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
          for (i = 0; i < 16; i++) {
               PSW(0x00,PMPTCER);
	     }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 245; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          } else {
             for (i = 0; i < 283; i++) {
                PSW(0x00,PMPTCER);
             }
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

             for (i = 0; i < 19; i++) {
            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x04,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);
             }

            /* Two dummy Writes, Read Output Status */
            /* Then advance the counters by 1       */
               PSW(0x00,PMPCON1); 
               PSW(0x00,PMPCON1); 
               PSR(0x06,0x07,PMPTOCR);
               PSW(0x00,PMPTCER);

          }

        }

}







