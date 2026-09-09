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
--  File Name              : Dcdc_free.c,v
--  File Revision          : 1.1
--  
--  Release Information    : PL160-REL1v1
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose : This C code file is used to generate BusTalk vectors.
--            BusTalk vectors are applied to the AMBA APB bus.                 
--                                                                  
--  Files required for compilation:                                
--    makefile, busheader.h, busmacros.h, busmacros.c,            
--    config.h, addargs_script,                                  
--    Dcdc_free.c                                  
--                                                             
--  Usage: make <testname> e.g. make Dcdc_free                
--                                                           
--  To create .bif formatted vectors from the BusTalk code (default)  
--    make <testname> e.g. make Dcdc_free                            
--  This will create testname.bif in the ./invec directory          
--                                                                 
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** For more information on the Dcdc, refer to the                         ***/
/*** ARM PrimeCell DCDC Converter Interface PL160                           ***/
/*** Technical Reference Manual                                             ***/
/******************************************************************************/

/******************************************************************************/
/*** This file verifies Dcdc Drive Outputs functionality.                   ***/
/******************************************************************************/

/******************************************************************************/
/*** Include common BusTalk files                                           ***/
/******************************************************************************/
#include "busmacros.h"
#include "busheader.h"
#include "config.h"

#include <stdio.h>

/* Mask Values */
#define NoMaskCon   0x0000FFF
#define NoMaskTCR   0x0000001F
#define NoMaskTISR  0x0000003F
#define MaskAll     0x00000000

/******************************/
/* NORMAL-MODE REGISTERS      */     
/******************************/

/* Dcdc Internal Register addresses */
#define BASE_ADD  0x00000000

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

#define  DCDCDRIVEIN_reg   R0
#define  DCDCFB_reg        R1
#define  DCDCDRSEL_reg     R2
#define  DCDCDRIVEOUT_reg  R3
             

/************************/
/* Command Definitions  */     
/************************/

#define   CmdSel1  (0x00 + (DutyCyc * 0x10))
#define   CmdSel0  (0x00 + DutyCyc)


/*************************/
/* Function declarations */
/*************************/
void RegResetTest();

void Pos1800KhzDrv0Sel0();
void Pos1800KhzDrv0Sel1();
void Pos1800KhzDrv1Sel0();
void Pos1800KhzDrv1Sel1();

void Neg1800KhzDrv0Sel1();
void Neg1800KhzDrv1Sel1();

void FB0Check();
void FB1Check();

void Drv0900Khz();
void Drv1900Khz();

void Drv0225Khz();
void Drv1225Khz();

void Drv095KHZ();
void Drv195KHZ();


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
  C("File Name              : Dcdc_free.c,v",header);
  C("File Revision          : 1.1",header);
  C(" ",header);
  C("Release Information    : PL160-REL1v1",header);
  C("-----------------------------------------------------------------------------",header);

TestStart();

  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x0,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x0,0x3,HIGH,1);

  RES(LOW,0x1,0x1);
  PI(0x02);
 
C("Register Reset Verification");
  RegResetTest();
  
C("Positive Polarity Drive 0 1800Khz Functional Test DRV0SEL = 1");
  Pos1800KhzDrv0Sel1();
       
C("Positive Polarity Drive 0 1800Khz Functional Test DRV0SEL = 0");
  Pos1800KhzDrv0Sel0();

C("Positive Polarity Drive 1 1800Khz Functional Test DRV1SEL = 1");
  Pos1800KhzDrv1Sel1();
     
C("Positive Polarity Drive 1 1800Khz Functional Test DRV1SEL = 0");
  Pos1800KhzDrv1Sel0();
      
C("Negative Polarity Drive 0 1800Khz Functional Test DRV0SEL = 1");
  Neg1800KhzDrv0Sel1();
  
C("Negative Polarity Drive 1 1800Khz Functional Test DRV1SEL = 1");
  Neg1800KhzDrv1Sel1();
  
C("FeedBack0 Check");
  FB0Check();

C("FeedBack1 Check");
  FB1Check();
  
C("Drive 0 900Khz Functional Test ");
  Drv0900Khz();  
  
C("Drive 1 900Khz Functional Test ");
  Drv1900Khz();  
  
C("Drive 0 225Khz Functional Test ");
  Drv0225Khz();
  
C("Drive 1 225Khz Functional Test ");
  Drv1225Khz();
 
C("Drive 0 95KHZ Functional Test ");
  Drv095KHZ();
  
C("Drive 1 95KHZ Functional Test ");
  Drv195KHZ();
 
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


/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x0,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x0,0x3,HIGH,1);


/* Reset Dcdc */
  RES(LOW,0x1,0x1);
  PI(0x02);


/* Check Reset values of Registers*/
  C("RESET VALUE TESTS");

/* Normal Mode Registers */
  C("Config Reg Reset Tests");
  PSR(0x00000000,NoMaskCon,PMPCON0);
  PSR(0x00000000,NoMaskCon,PMPCON1);
  PSR(0x00000000,NoMaskCon,PMPFREQ);

/* Test Mode Registers */
  C("Test Mode Reg Reset Tests");
  PSR(0x00000000,NoMaskCon,PMPTCER);
  PSR(0x00000000,NoMaskCon,PMPTCR);
  PSR(0x00000000,NoMaskCon,PMPTMR);
  PSR(0x00000000,NoMaskCon,PMPTISR);
  PSR(0x00000004,NoMaskCon,PMPTOCR);

/* Virtual Registers */
  C("Virtual Reg Reset Test");
  VR(DCDCDRIVEOUT_reg,0x4,0x07,rising,1); 


/* Check Reads and Writes to Configuration Registers */
  C("CONFIG REG's R/W TESTS");

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

  /* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x3,0x3,HIGH,1);
  VW (DCDCFB_reg,0x0,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x0,0x3,HIGH,1);


  /* Reset Dcdc */
  PSW(0x00,PMPCON0);
  RES(LOW,0x1,0x1);
  PI(0x02);


  /* Configure to read from internal TISR Reg */
  PSW(0x10,PMPTCR); 

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

  PSW(0x3F,PMPTISR); 
  PSW(0x00,PMPTCER);
  PSR(0x3F,NoMaskTISR,PMPTISR); 
  PI(0x0F);

 }


/*****************************************************/
/* Positive Polarity Drive 0  900Khz Functional Test */
/*****************************************************/

void Drv0900Khz()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/*****************************************/
/* Configure for normal 900Khz Operation */
/* On DRIVE0OUT with Pos Drive Polarity  */
/*****************************************/

  C("Config for 900Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x00,PMPCON0);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x05,PMPFREQ);
  PSW(0x05,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0x4; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON0); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x41; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x3E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= ((0x2 * 0x10) - 1) ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }
		
	       else if ((j == ((0x2 * DutyCyc) - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == ((0x2 * DutyCyc) - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (0x2 * DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == (0x2 * 0xF)){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }
 PI(0x1);

}

/*****************************************************/
/* Positive Polarity Drive 1  900Khz Functional Test */
/*****************************************************/

void Drv1900Khz()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/*****************************************/
/* Configure for normal 900Khz Operation */
/* On DRIVE1OUT with Pos Drive Polarity  */
/*****************************************/

  C("Config for 900Khz Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x000,PMPCON1);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x50,PMPFREQ);
  PSW(0x50,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0x4; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON1); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x41; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x3E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= ((0x2 * 0x10) - 1) ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }
		
	       else if ((j == ((0x2 * DutyCyc) - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == ((0x2 * DutyCyc) - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (0x2 * DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == (0x2 * 0xF)){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }
 PI(0x1);

}


/*****************************************************/
/* Positive Polarity Drive 0  225Khz Functional Test */
/*****************************************************/

void Drv0225Khz()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/*****************************************/
/* Configure for normal 225Khz Operation */
/* On DRIVE0OUT with Pos Drive Polarity  */
/*****************************************/

  C("Config for 225Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x00,PMPCON0);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x0A,PMPFREQ);
  PSW(0x0A,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0x4; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON0); 
      
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x101; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0xFE; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

 
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= ((0x8 * 0x10) - 1) ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }
		
	       else if ((j == ((0x8 * DutyCyc) - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == ((0x8 * DutyCyc) - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (0x8 * DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == (0x8 * 0xF)){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }
  PI(0x1);
}

/*****************************************************/
/* Positive Polarity Drive 1  225Khz Functional Test */
/*****************************************************/

void Drv1225Khz()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/*****************************************/
/* Configure for normal 225Khz Operation */
/* On DRIVE1OUT with Pos Drive Polarity  */
/*****************************************/

  C("Config for 225Khz Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x000,PMPCON1);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0xA0,PMPFREQ);
  PSW(0xA0,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0x4; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON1); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x101; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0xFE; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= ((0x8 * 0x10) - 1) ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }
		
	       else if ((j == ((0x8 * DutyCyc) - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == ((0x8 * DutyCyc) - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (0x8 * DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == (0x8 * 0xF)){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }
  PI(0x1);
}


/*****************************************************/
/* Positive Polarity Drive 0  95KHZ Functional Test */
/*****************************************************/

void Drv095KHZ()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/*****************************************/
/* Configure for normal 95KHZ Operation */
/* On DRIVE0OUT with Pos Drive Polarity  */
/*****************************************/

  C("Config for 95KHZ Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x00,PMPCON0);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x0F,PMPFREQ);
  PSW(0x0F,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0x4; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON0); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x261; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x25E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= ((0x13 * 0x10) - 1) ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }
		
	       else if ((j == ((0x13 * DutyCyc) - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == ((0x13 * DutyCyc) - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (0x13 * DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == (0x13 * 0xF)){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }
            PI(0x1);
}


/*****************************************************/
/* Positive Polarity Drive 1  95KHZ Functional Test */
/*****************************************************/

void Drv195KHZ()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/*****************************************/
/* Configure for normal 95KHZ Operation */
/* On DRIVE1OUT with Pos Drive Polarity  */
/*****************************************/

  C("Config for 95KHZ Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x000,PMPCON1);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0xF0,PMPFREQ);
  PSW(0xF0,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0x4; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON1); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x261; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x25E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= ((0x13 * 0x10) - 1) ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }
		
	       else if ((j == ((0x13 * DutyCyc) - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == ((0x13 * DutyCyc) - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (0x13 * DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == (0x13 * 0xF)){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }
            PI(0x1);
}



/******************************************************************/
/* Feedback 1 Check to verify Drive1Out is shutdown               */
/******************************************************************/

void FB1Check()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE1OUT with Pos Drive Polarity   */
/* DRV1SEL = 1    FB1 = 0                 */
/******************************************/

  C("Config for FB=0 Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x1,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x000,PMPCON1);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x00,PMPFREQ);
  PSW(0x00,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0xF; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON1); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x20; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x1E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= 0xF ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == 0xF){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }
   PI(0x1);
}



/******************************************************************/
/* Feedback 0 Check to verify Drive0Out is shutdown               */
/******************************************************************/

void FB0Check()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE0OUT with Pos Drive Polarity   */
/* DRV0SEL = 1    FB0 = 0                 */
/******************************************/

  C("Config for FB=0 Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x2,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x00,PMPCON0);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x00,PMPFREQ);
  PSW(0x00,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0xF; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON0); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x20; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x1E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= 0xF ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == 0xF){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

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
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x00,PMPCON0);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x00,PMPFREQ);
  PSW(0x00,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0xF; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON0); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x20; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x1E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
     
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {

	           for(j = 0; j <= 0xF ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == 0xF){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }

}



/******************************************************************/
/* Negative Polarity Drive 0  1800Khz Functional Test DRV0SEL = 1 */
/******************************************************************/

void Neg1800KhzDrv0Sel1()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE0OUT with Neg Drive Polarity   */
/* DRV0SEL = 1                            */
/******************************************/

  C("Config for 1800Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x1,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x00,PMPCON0);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x00,PMPFREQ);
  PSW(0x00,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0xF; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON0); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x20; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x1E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= 0xF ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }      

	       else if (j == (DutyCyc )){		     
                      C("Leading EdgeCheck 1");
                       VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }

	       else if (j == 0xF){		      
                      C("Trailing EdgeCheck 1");
                      VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }     
		    

             }

	  } 
    }

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
/* DRV0SEL = 1                            */
/******************************************/

  C("Config for 1800Khz Drive 0 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x0,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x00,PMPCON0);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x00,PMPFREQ);
  PSW(0x00,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0xF; DutyCyc++)
   {
       PSW(CmdSel0,PMPCON0); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x20; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x1E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= 0xF ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x5,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == 0xF){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }

}



/******************************************************************/
/* Positive Polarity Drive 1  1800Khz Functional Test DRV1SEL = 1 */
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

  C("Config for 1800Khz Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x000,PMPCON1);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x00,PMPFREQ);
  PSW(0x00,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0xF; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON1); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x20; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x1E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= 0xF ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == 0xF){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }

}



/******************************************************************/
/* Negative Polarity Drive 1  1800Khz Functional Test DRV0SEL = 1 */
/******************************************************************/

void Neg1800KhzDrv1Sel1()
{ 
int DutyCyc = 0;
int h = 0;
int i = 0;
int j = 0;


/******************************************/
/* Configure for normal 1800Khz Operation */
/* On DRIVE1OUT with Neg Drive Polarity   */
/* DRV0SEL = 1                            */
/******************************************/

  C("Config for 1800Khz Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x2,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x3,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x000,PMPCON1);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x00,PMPFREQ);
  PSW(0x00,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0xF; DutyCyc++)
   {
       PSW(CmdSel1,PMPCON1); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x20; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x1E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= 0xF ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }      

	       else if (j == (DutyCyc )){		     
                      C("Leading EdgeCheck 1");
                       VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }

	       else if (j == 0xF){		      
                      C("Trailing EdgeCheck 1");
                      VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }     
		    

             }

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
/* On DRIVE1OUT with Pos Drive Polarity   */
/* DRV0SEL = 0                            */
/******************************************/

  C("Config for 1800Khz Drive 1 Tests");

/* Configure the Non-AMBA Inputs */
  VW (DCDCDRIVEIN_reg,0x0,0x3,HIGH,1);
  VW (DCDCFB_reg,0x3,0x3,HIGH,1);
  VW (DCDCDRSEL_reg,0x0,0x3,HIGH,1);


/* Reset Dcdc */
  PSW(0x000,PMPCON1);
  RES(LOW,0x1,0x1);
  PI(0x02);

  PSW(0x00,PMPFREQ);
  PSW(0x00,PMPFREQ);

/* For loop for Duty Cycle Increment */ 
  for(DutyCyc = 0; DutyCyc <= 0xF; DutyCyc++)
   {
       PSW(CmdSel0,PMPCON1); 
 
       if (DutyCyc == 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x20; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }

       else if (DutyCyc > 0){
       C("Begining Initialization Delay"); 
       for(i = 0; i < 0x1E; i++)
           {  
            PI(0x1);
           }
       C("Ending Initialization Delay");
       }
       
      /* For loop for Number of cycles */
       for(h = 0; h < 4 ; h++)
          {
 
	           for(j = 0; j <= 0xF ; j++)
	     {
                       PI(0x1);
                       PI(0x1);

	       if ((j == 0) & (DutyCyc > 0)){  
                       C("Leading EdgeCheck 1");
	               VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc > 0) ){		     
                      C("Trailing EdgeCheck 1");
	              VR(DCDCDRIVEOUT_reg,0x6,0x7,falling,1);
	       }      

	       else if ((j == 0) & (DutyCyc == 0)){  
                       C("Leading EdgeCheck 0");
	               VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }
		
	       else if ((j == (DutyCyc - 1)) & (DutyCyc == 0) ){		     
                      C("Trailing EdgeCheck 0");
	              VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }      

	       else if (j == (DutyCyc )){		     
                      C("Leading EdgeCheck 0");
                       VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }

	       else if (j == 0xF){		      
                      C("Trailing EdgeCheck 0");
                      VR(DCDCDRIVEOUT_reg,0x4,0x7,falling,1);
	       }     
		    

             }

	  } 
    }
}



















