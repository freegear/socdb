/*----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : IntTests.c.rca
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
------------------------------------------------------------------------------*/

/******************************************************************************/
/***************************   Interrupt Test   *******************************/
/******************************************************************************/

void IntTests()
{
/*
   Summary : Interrupt Detection Capabilities Test
*/

/********************************************************************************************/
/********************************************************************************************/
/********************************************************************************************/
/***                                                                                      ***/
/***                   Summary : Interrupt Detection Capabilities Test                    ***/
/***                   ===============================================                    ***/
/***                                                                                      ***/
/***                                                                                      ***/
/********************************************************************************************/
/********************************************************************************************/
/********************************************************************************************/

/* SIGNAL SOURCE XP[7:0] either externally applied or through Alternate Functionality lines */

      /* Setting configuration to trigger interrupts from data coming from the XP[7:0] pins*/
      PSW(0x000000FF, GPIOAFSEL);           /* either driven directly or through the       */ 
      PSR(0x000000FF, NoMask, GPIOAFSEL,b); /* Alternate Functionality port interface      */
      PSW(0x00000000, GPIODIR);             /* Signals must go through the synchronizers   */
      PSR(0x00000000, NoMask, GPIODIR,b)    /* in the GpioAfm block, before driving the    */  
                                            /* signals into the interrupt detections logic.*/ 
                                        
      PSW(0x00000000, GPIOITCR);             /* Make sure that integration vectors are      */
      PSR(0x00000000, NoMask, GPIOITCR);     /* disabled.                                   */
/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o LEVEL : HIGH                                               **/
/**                   =================                                             **/
/**                                                                                 **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/


     /* Disable Interrupt Triggering*/
      PSW(0x00000000, GPIOIE);           /*GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE );  /* Verification that GPIO Interrupt Enable = 0*/
     /* Initialize to detect LEVEL conditions*/
      PSW(0x000000FF, GPIOIS);           /* GPIO Interrupt Sense(i) = 1 */ 
      PSR(0x000000FF, NoMask, GPIOIS);   /* Verification */

     /* Initialize to detect HIGH levels  */
      PSW(0x000000FF, GPIOIEV);         /* GPIO Interrupt EVent = 1 */ 
      PSR(0x000000FF, NoMask, GPIOIEV); /* Verification */

     /* Drive LOW levels to GPIN pins, so that do not match triggering conditions*/
      PSW(0x00000000, GTINR);           /* GTINR = 0 ==> GPIN = LOW */ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = 0 */
  
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is inactive also*/
      PSR(0x00000000, NoMask, GTMIS);   /* and GPIOMIS is inactive also, Trickbox*/

     /* Drive HIGH levels to GPIN pins, so that DO match triggering conditions*/
      PSW(0x000000FF, GTINR);           /* GTINR = 0xFF ==> GPIN = HIGH (all pins =1)*/ 
      PSR(0x000000FF, NoMask, GTINR);   /* Verification that GTINR = 0xFF */  

      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
                                        /* Because of the value of GPIOIE */
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF (active), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is inactive*/
      PSR(0x00000000, NoMask, GTMIS);   /* and GPIOMIS is inactive also, Trickbox*/
     /* Enable interrupts  */
      PSW(0x000000FF, GPIOIE);          /* GPIO Interrupt Enabled in all GPIN pins*/ 
      PSR(0x000000FF, NoMask, GPIOIE);  /* Verification that GPIO Interrupt Enable = 0xFF*/

      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF (active), */
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is active also*/
      PSR(0x000000FF, NoMask, GTMIS);   /* and GPIOMIS read from the Trickbox*/

      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */
     
     /* Disable Interrupt Triggering*/
      PSW(0x00000000, GPIOIE);           /*GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE );  /* Verification that GPIO Interrupt Enable = 0*/     

/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o LEVEL : LOW                                                **/
/**                   =================                                             **/
/**                                                                                 **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/


   /* Disable Interrupt Triggering*/
      PSW(0x00000000, GPIOIE);           /*GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE );  /* Verification that GPIO Interrupt Enable = 0*/
   /* Initialize to detect LEVEL conditions*/
      PSW(0x000000FF, GPIOIS);           /*GPIO Interrupt Sense(i) = 1 */ 
      PSR(0x000000FF, NoMask, GPIOIS);   /* Verification  */
   /* Initialize to detect LOW levels  */
      PSW(0x00000000, GPIOIEV);         /* GPIO Interrupt EVent = 0 */ 
      PSR(0x00000000, NoMask, GPIOIEV); /* Verification */

   /* Drive HIGH levels to GPIN pins, so that do not match triggering conditions*/
      PSW(0x000000FF, GTINR);           /* GTINR = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GTINR);   /* Verification that GTINR = all ones */

      PSR(0x00000000, NoMask, GTINT, levLow);   /* Verification that GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is inactive also*/
      PSR(0x00000000, NoMask, GTMIS);   /* and GPIOMIS is inactive also, Trickbox*/

   /* Drive LOW levels to GPIN pins, so that DO match triggering conditions*/
      PSW(0x00000000, GTINR);           /* GTINR = 0x00 ==> GPIN = LOW (all pins =0)*/ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = 0x00 */  

      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
                                        /* Because of the value of GPIOIE */

      PSR(0x000000FF, NoMask, GPIORIS); /* but GPIORIS = 0xFF (active), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is inactive*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
   /* Enable interrupts  */
      PSW(0x000000FF, GPIOIE);          /* GPIO Interrupt Enabled in all GPIN pins*/ 
      PSR(0x000000FF, NoMask, GPIOIE);  /* Verification that GPIO Interrupt Enable = 0xFF*/

      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF (active), */
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is active also*/
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      PSR(0x00000001, NoMask, GTINT, levLow);   /* Verification that GPIOINTR = 1 (active), */

    /* Disable Interrupt Triggering */
      PSW(0x00000000, GPIOIE);           /*GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE );  /* Verification that GPIO Interrupt Enable = 0*/



/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o EDGE : RISING                                              **/
/**                   =================                                             **/
/**                                                                                 **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/


      /* Disable Interrupt Triggering */
      PSW(0x00000000, GPIOIE);           /* GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE );  /* Verification that GPIO Interrupt Enable=0  */
   
      PSR(0x00000000, NoMask, GTINT);    /* Verification that GPIOINTR = 0 (inactive), */
                                       
      PSR(0x00000000, NoMask, GPIOMIS);  /* and GPIOMIS is also inactive*/    
      PSR(0x00000000, NoMask, GTMIS);    /* GPIOMIS read from the Trickbox*/
      /* Drive HIGH levels to GPIN pins */
      /* When we drive it back to HIGH, we will expect then and*/
      /* only then to trigger the interrupt in GPIOINTR */
      PSW(0x000000FF, GTINR);           /* GTINR = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GTINR);   /* Verification that GTINR = all ones */
           
      /* Initialize to detect EDGE conditions*/
      /* From this moment the RAW Edge detection capabilities of the GPIO are activated*/
      /* on pins selected as LOW */
      PSW(0x00000000, GPIOIS);           /* GPIO Interrupt Sense(i) = 0 */ 
      PSR(0x00000000, NoMask, GPIOIS);   /* Verification */    
      /* Initialize to detect RISING EDGE conditions */
      PSW(0x00000000, GPIOIBE);         /* GPIO Interrupt Both Edges = 0 (No) */ 
      PSR(0x00000000, NoMask, GPIOIBE); /* Verification */
      PSW(0x000000FF, GPIOIEV);         /* GPIO Interrupt EVent(i) = 1 (Rising) */ 
      PSR(0x000000FF, NoMask, GPIOIEV); /* Verification */

      /* Circuit  activated */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PSW(0x000000FF, GPIOIE);          /* we allow interrupts to trigger */   
      PSR(0x000000FF, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=1*/   

      /* Verifying that no inmediate triggering exists */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
   
      /* Drive LOW levels to GPIN pins, so that do not match triggering conditions*/
      /* When we drive it back to HIGH, we will expect then and*/
      /* only then to trigger the interrupt in GPIOINTR */
      PSW(0x00000000, GTINR);           /* GTINR = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = all ZEROS */

      /* Verifying that no interrupts have triggered due to the falling edge*/
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */ 
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */   
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/  
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /* Drive HIGH levels to GPIN pins, so that, DO match triggering condition */
      /* we expect GPIOINTR to trigger */
      PSW(0x000000FF, GTINR);           /* GTINR = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GTINR);   /* Verification that GTINR = all ones */ 

      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF(active), */
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      PSW(0x00000000, GPIOIE);          /* until we disable it of triggering */   
      PSR(0x00000000, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=0*/
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (disabled), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is LOW 0x00*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      
      /* The logic will keep signalling that conditions were met until we clear the edge-logic*/ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF(active), */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */

      PSR(0x00000000, NoMask, GPIORIS,timetoclear); /* GPIORIS = 0x00(inactive),  */
 
      PSR(0x00000000, NoMask, GTINT);   /* GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS inactive*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /*Edge interrupt cleared succesfully*/

   

/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o EDGE : FALLING                                             **/
/**                   ==================                                            **/
/**                                                                                 **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/

    /* Disable Interrupt Triggering */
      PSW(0x00000000, GPIOIE);          /* GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=0*/
  
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
                                       
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/    
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /* Drive LOW levels to GPIN pins */
      /* When we drive it back to HIGH, we will expect then and*/
      /* only then to trigger the interrupt in GPIOINTR */
      PSW(0x00000000, GTINR);           /* GTINR = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = all ZEROS */
           
      /* Initialize to detect EDGE conditions*/
      /* From this moment the Raw Edge detection capabilities of the GPIO are activated */
      /* on pins selected as HIGH */
      PSW(0x00000000, GPIOIS);          /* GPIO Interrupt Sense(i) = 0 */ 
      PSR(0x00000000, NoMask, GPIOIS);  /* Verification */
      /* Initialize to detect FALLING EDGE conditions */
      PSW(0x00000000, GPIOIBE);         /* GPIO Interrupt Both Edges = 0 (No) */ 
      PSR(0x00000000, NoMask, GPIOIBE); /* Verification */
      PSW(0x00000000, GPIOIEV);         /* GPIO Interrupt EVent(i) = 0 (Falling) */ 
      PSR(0x00000000, NoMask, GPIOIEV); /* Verification */

      /* Circuit  activated */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PSW(0x000000FF, GPIOIE);          /* we allow interrupts to trigger */   
      PSR(0x000000FF, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=1*/   
   
      /* Verifying that no inmediate triggering exists */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */

      /* Drive HIGH levels to GPIN pins, so that do not match triggering conditions*/
      /* When we drive it back to LOW, we will expect then and*/
      /* only then to trigger the interrupt in GPIOINTR */
      PSW(0x000000FF, GTINR);           /* GTINR = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GTINR);   /* Verification that GTINR = all ones */

      /* Verifying that no interrupts have triggered due to the rising edge*/
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */ 
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */   
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/  
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /* Drive LOW levels to GPIN pins, so that, DO match triggering condition */
      /* we expect GPIOINTR to trigger */
      PSW(0x00000000, GTINR);           /* GTINR = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = all ZEROS */ 

      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF(active), */
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      PSW(0x00000000, GPIOIE);          /* until we disable it of triggering */   
      PSR(0x00000000, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=0*/
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (disabled), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is LOW 0x00*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/   
  
      /* The logic will keep signalling that conditions were met until we clear the edge-logic*/ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF(active), */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */

      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0x00(inactive),  */
 
      PSR(0x00000000, NoMask, GTINT);   /* GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS inactive*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /*Edge interrupt cleared succesfully*/




/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o EDGE : BOTH EDGES (EITHER RISING OR FALLING)               **/
/**                   ================================================              **/
/**                                                                                 **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/

      /* Disable Interrupt Triggering */
      PSW(0x00000000, GPIOIE);          /* GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=0*/
  
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
                                       
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/  
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/  

      /* Drive LOW levels to GPIN pins */
      /* When we drive it back to HIGH, we will expect an interrupt to occur in GPIOINTR, */
      /* the same will happen when we drive GPIN LOW */
      PSW(0x00000000, GTINR);           /* GTINR = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = all ZEROS */
           
      /* Initialize to detect EDGE conditions*/
      /* From this moment the Raw Edge detection capabilities of the GPIO are activated */
      /* on pins selected as HIGH */
      PSW(0x00000000, GPIOIS);          /* GPIO Interrupt Sense(i) = 0 */ 
      PSR(0x00000000, NoMask, GPIOIS);  /* Verification */
      /* Initialize to detect BOTH FALLING AND RISING EDGE conditions */
      PSW(0x000000FF, GPIOIBE);         /* GPIO Interrupt Both Edges = 1 (yes) */ 
      PSR(0x000000FF, NoMask, GPIOIBE); /* Verification */
      PSW(0x0000000F, GPIOIEV);         /* GPIO Interrupt EVent = 0x0F to show that GPIOIEV */ 
      PSR(0x0000000F, NoMask, GPIOIEV); /* does not affect the state of BOTH detection */
      /* Circuit  activated */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PSW(0x000000FF, GPIOIE);          /* we allow interrupts to trigger */   
      PSR(0x000000FF, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=1*/   
   
      /* Verifying that no inmediate triggering exists */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      
      /* Drive HIGH levels to GPIN pins, so that do match triggering conditions*/
  
      PSW(0x000000FF, GTINR);           /* GTINR = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GTINR);   /* Verification that GTINR = all ones */

      /* Verifying that interrupts have triggered due to the rising edge*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS(i) = 1(active), */   
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is also active*/  
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* The logic will keep signalling that conditions were met until we clear the edge-logic*/ 
      
      /**********************************************************************/
      /*** GPIOIC        0x41C  8  W    Interrupt Clear register          ***/
      /**********************************************************************/
      PSW(0x00000000, GPIOIC);          /* Writing zeros does not affect the register*/
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (still active), */ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS(i) = 1(still active), */   
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is also still active*/ 
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /**********************************************************************/
      /*** GPIOIC  Interrupt Clear register : Verified that only writing  ***/
      /*** ones to GPIOIC affects the Hold-Edge Detected circuitry        ***/
      /**********************************************************************/

      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */           
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/    
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* Drive LOW levels to GPIN pins */
      PSW(0x00000000, GTINR);           /* GTINR = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = all ZEROS */ 

      /*PI(0x01); */                        /* Wait for one cycle for the detection latency */

      /* Verifying that interrupts have triggered due to the falling edge*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 1(active), */   
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is also active*/
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* The logic will keep signalling that conditions were met until we clear the edge-logic*/ 
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */    
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/    
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/



/********************************************************************************************/
/********************************************************************************************/
/********************************************************************************************/
/***                                                                                      ***/
/***            SIGNAL SOURCE  internally applied through the APB interface               ***/
/***            ===========================================================               ***/
/***                                                                                      ***/
/***                                                                                      ***/
/********************************************************************************************/
/********************************************************************************************/
/********************************************************************************************/

      /* Setting configuration to trigger interrupts from data coming the APB interface    */
      PSW(0x000000FF, GPIODIR);             /*GPIO Data Direction Register(i) = 1(output)  */
      PSR(0x000000FF, NoMask, GPIODIR,a);   /*in this case data is already synchronized.   */ 
      PSW(0x00000000, GPIOAFSEL);           /*data from GPIODATA can be driven directly    */ 
      PSR(0x00000000, NoMask, GPIOAFSEL,b); /*into the interrupt detections logic bypassing*/ 
                                            /*the synchronizers in the GpioAfm block.      */ 
                                            /*Hence reducing interrupt latency             */


/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o EDGE : RISING                                              **/
/**                   =================                                             **/
/**                                                                                 **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/


      /* Disable Interrupt Triggering */
      PSW(0x00000000, GPIOIE);           /* GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE);  /* Verification that GPIO Interrupt Enable=0  */
   
      PSR(0x00000000, NoMask, GTINT);    /* Verification that GPIOINTR = 0 (inactive), */
                                       
      PSR(0x00000000, NoMask, GPIOMIS);  /* and GPIOMIS is also inactive*/    
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* Drive HIGH levels to GPIN pins */
      /* When we drive it back to HIGH, we will expect then and*/
      /* only then to trigger the interrupt in GPIOINTR */
      PSW(0x000000FF, GPIODATA+0x3FC);           /* GPIODATA = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ones */
           
      /* Initialize to detect EDGE conditions*/
      /* From this moment the RAW Edge detection capabilities of the GPIO are activated*/
      /* on pins selected as LOW */
      PSW(0x00000000, GPIOIS);           /* GPIO Interrupt Sense(i) = 0 */ 
      PSR(0x00000000, NoMask, GPIOIS);   /* Verification */    
      /* Initialize to detect RISING EDGE conditions */
      PSW(0x00000000, GPIOIBE);         /* GPIO Interrupt Both Edges = 0 (No) */ 
      PSR(0x00000000, NoMask, GPIOIBE); /* Verification */
      PSW(0x000000FF, GPIOIEV);         /* GPIO Interrupt EVent(i) = 1 (Rising) */ 
      PSR(0x000000FF, NoMask, GPIOIEV); /* Verification */

      /* Circuit  activated */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PSW(0x000000FF, GPIOIE);          /* we allow interrupts to trigger */   
      PSR(0x000000FF, NoMask, GPIOIE); /* Verification that GPIO Interrupt Enable=1*/   

      /* Verifying that no inmediate triggering exists */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
   
      /* Drive LOW levels to GPIN pins, so that do not match triggering conditions*/
      /* When we drive it back to HIGH, we will expect then and*/
      /* only then to trigger the interrupt in GPIOINTR */
      PSW(0x00000000, GPIODATA+0x3FC);           /* GPIODATA = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ZEROS */

      /* Verifying that no interrupts have triggered due to the falling edge*/
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */ 
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */   
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/  
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* Drive HIGH levels to GPIN pins, so that, DO match triggering condition */
      /* we expect GPIOINTR to trigger */
      PSW(0x000000FF, GPIODATA+0x3FC);           /* GPIODATA = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ones */ 

      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF(active), */
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      PSW(0x00000000, GPIOIE);          /* until we disable it of triggering */   
      PSR(0x00000000, NoMask, GPIOIE); /* Verification that GPIO Interrupt Enable=0*/
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (disabled), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is LOW 0x00*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/     
      /* The logic will keep signalling that conditions were met until we clear the edge-logic*/ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF(active), */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */

      PSR(0x00000000, NoMask, GPIORIS,timetoclear); /* GPIORIS = 0x00(inactive),  */
 
      PSR(0x00000000, NoMask, GTINT);   /* GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS inactive*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /*Edge interrupt cleared succesfully*/

 

/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o EDGE : FALLING                                             **/
/**                   ==================                                            **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/
  
    /* Disable Interrupt Triggering */
      PSW(0x00000000, GPIOIE);          /* GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=0*/
  
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
                                       
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/    
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* Drive LOW levels to GPIN pins */
      /* When we drive it back to HIGH, we will expect then and*/
      /* only then to trigger the interrupt in GPIOINTR */
      PSW(0x00000000, GPIODATA+0x3FC);           /* GPIODATA = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ZEROS */
           
      /* Initialize to detect EDGE conditions*/
      /* From this moment the Raw Edge detection capabilities of the GPIO are activated */
      /* on pins selected as HIGH */
      PSW(0x00000000, GPIOIS);          /* GPIO Interrupt Sense(i) = 0 */ 
      PSR(0x00000000, NoMask, GPIOIS);  /* Verification */
      /* Initialize to detect FALLING EDGE conditions */
      PSW(0x00000000, GPIOIBE);         /* GPIO Interrupt Both Edges = 0 (No) */ 
      PSR(0x00000000, NoMask, GPIOIBE); /* Verification */
      PSW(0x00000000, GPIOIEV);         /* GPIO Interrupt EVent(i) = 0 (Falling) */ 
      PSR(0x00000000, NoMask, GPIOIEV); /* Verification */

      /* Circuit  activated */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PSW(0x000000FF, GPIOIE);          /* we allow interrupts to trigger */   
      PSR(0x000000FF, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=1*/   
   
      /* Verifying that no inmediate triggering exists */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */

      /* Drive HIGH levels to GPIN pins, so that do not match triggering conditions*/
      /* When we drive it back to LOW, we will expect then and*/
      /* only then to trigger the interrupt in GPIOINTR */
      PSW(0x000000FF, GPIODATA+0x3FC);           /* GPIODATA = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ones */

      /* Verifying that no interrupts have triggered due to the rising edge*/
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */ 
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */   
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/  
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* Drive LOW levels to GPIN pins, so that, DO match triggering condition */
      /* we expect GPIOINTR to trigger */
      PSW(0x00000000, GPIODATA+0x3FC);           /* GPIODATA = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ZEROS */ 

      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF(active), */
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      PSW(0x00000000, GPIOIE);          /* until we disable it of triggering */   
      PSR(0x00000000, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=0*/
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (disabled), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is LOW 0x00*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      
      /* The logic will keep signalling that conditions were met until we clear the edge-logic*/ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 0xFF(active), */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */

      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0x00(inactive),  */
 
      PSR(0x00000000, NoMask, GTINT);   /* GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS inactive*/
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /*Edge interrupt cleared succesfully*/




/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o EDGE : BOTH EDGES (EITHER RISING OR FALLING)               **/
/**                   ================================================              **/
/**                                                                                 **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/

      /* Disable Interrupt Triggering */
      PSW(0x00000000, GPIOIE);          /* GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=0*/
  
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
                                       
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/ 
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* Drive LOW levels to GPIN pins */
      /* When we drive it back to HIGH, we will expect an interrupt to occur in GPIOINTR, */
      /* the same will happen when we drive GPIN LOW */
      PSW(0x00000000, GPIODATA+0x3FC);           /* GPIODATA = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ZEROS */
           
      /* Initialize to detect EDGE conditions*/
      /* From this moment the Raw Edge detection capabilities of the GPIO are activated */
      /* on pins selected as HIGH */
      PSW(0x00000000, GPIOIS);          /* GPIO Interrupt Sense(i) = 0 */ 
      PSR(0x00000000, NoMask, GPIOIS);  /* Verification */
      /* Initialize to detect BOTH FALLING AND RISING EDGE conditions */
      PSW(0x000000FF, GPIOIBE);         /* GPIO Interrupt Both Edges = 1 (yes) */ 
      PSR(0x000000FF, NoMask, GPIOIBE); /* Verification */
      PSW(0x0000000F, GPIOIEV);         /* GPIO Interrupt EVent = 0x0F to show that GPIOIEV */ 
      PSR(0x0000000F, NoMask, GPIOIEV); /* does not affect the state of BOTH detection */
      /* Circuit  activated */
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PSW(0x000000FF, GPIOIE);          /* we allow interrupts to trigger */   
      PSR(0x000000FF, NoMask, GPIOIE ); /* Verification that GPIO Interrupt Enable=1*/   
   
      /* Verifying that no inmediate triggering exists */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      
      /* Drive HIGH levels to GPIN pins, so that do match triggering conditions*/
  
      PSW(0x000000FF, GPIODATA+0x3FC);           /* GPIODATA = 0xFF ==> GPIN = ALL HIGH */ 
      PSR(0x000000FF, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ones */

      /* Verifying that interrupts have triggered due to the rising edge*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS(i) = 1(active), */   
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is also active*/ 
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/


      /* The logic will keep signalling that conditions were met until we clear the edge-logic*/ 
      
      /**********************************************************************/
      /*** GPIOIC        0x41C  8  W    Interrupt Clear register          ***/
      /**********************************************************************/
      PSW(0x00000000, GPIOIC);          /* Writing zeros does not affect the register*/
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (still active), */ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS(i) = 1(still active), */   
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is also still active*/ 
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/
      /**********************************************************************/
      /*** GPIOIC  Interrupt Clear register : Verified that only writing  ***/
      /*** ones to GPIOIC affects the Hold-Edge Detected circuitry        ***/
      /**********************************************************************/

      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */           
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/    
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* Drive LOW levels to GPIN pins */
      PSW(0x00000000, GPIODATA+0x3FC);           /* GPIODATA = 0x00 ==> GPIN = ALL LOW */ 
      PSR(0x00000000, NoMask, GPIODATA+0x3FC);   /* Verification that GPIODATA = all ZEROS */ 

      /*PI(0x01); */                        /* Wait for one cycle for the detection latency */

      /* Verifying that interrupts have triggered due to the falling edge*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */ 
      PSR(0x000000FF, NoMask, GPIORIS); /* GPIORIS = 1(active), */   
      PSR(0x000000FF, NoMask, GPIOMIS); /* and GPIOMIS is also active*/
      PSR(0x000000FF, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/

      /* The logic will keep signalling that conditions were met until we clear the edge-logic*/ 
      PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */ 
      PI(0x01);                         /* Wait for one cycle for the Interrupt to clear */
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */    
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is also inactive*/    
      PSR(0x00000000, NoMask, GTMIS);   /* GPIOMIS read from the Trickbox*/


/* Functionally the Interrupt Detection Logic's specification has been verified */
/* However, in order to increase the percentage value of Focused Expression     */
/* Coverage in the combinatorial process of GPIOINTR generation the following   */
/* test has been added to ensure that every input to the expression has taken   */
/* both true and false values under conditions which allow that input to control*/
/* the output to control the the output. (The output has been sensitized to the */
/* inputs)                                                                      */

/* In High Level triggering conditions a walking one will be driven in the GPIO */
/* port. */

/* SIGNAL SOURCE XP[7:0] either externally applied or through Alternate Functionality lines */

      /* Setting configuration to trigger interrupts from data coming from the XP[7:0] pins*/
      PSW(0x000000FF, GPIOAFSEL);           /* either driven directly or through the       */ 
      PSR(0x000000FF, NoMask, GPIOAFSEL,b); /* Alternate Functionality port interface      */
      PSW(0x00000000, GPIODIR);             /* Signals must go through the synchronizers   */
      PSR(0x00000000, NoMask, GPIODIR,b)    /* in the GpioAfm block, before driving the    */  
                                            /* signals into the interrupt detections logic.*/ 
                                         
      PSW(0x00000000, GPIOITCR);             /* Make sure that integration vectors are      */
      PSR(0x00000000, NoMask, GPIOITCR);     /* disabled.                                   */

/*************************************************************************************/
/*************************************************************************************/
/**                                                                                 **/
/**                    o LEVEL : HIGH                                               **/
/**                   =================                                             **/
/**                                                                                 **/
/*************************************************************************************/
/*************************************************************************************/


     /* Disable Interrupt Triggering*/
      PSW(0x00000000, GPIOIE);           /*GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE );  /* Verification that GPIO Interrupt Enable = 0*/
     /* Initialize to detect LEVEL conditions*/
      PSW(0x000000FF, GPIOIS);           /* GPIO Interrupt Sense(i) = 1 */ 
      PSR(0x000000FF, NoMask, GPIOIS);   /* Verification */

     /* Initialize to detect HIGH levels  */
      PSW(0x000000FF, GPIOIEV);         /* GPIO Interrupt EVent = 1 */ 
      PSR(0x000000FF, NoMask, GPIOIEV); /* Verification */

     /* Drive LOW levels to GPIN pins, so that do not match triggering conditions*/
      PSW(0x00000000, GTINR);           /* GTINR = 0 ==> GPIN = LOW */ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = 0 */
  
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is inactive also*/
      PSR(0x00000000, NoMask, GTMIS);   /* and GPIOMIS is inactive also, Trickbox*/

     /* Enable interrupts  */
      PSW(0x000000FF, GPIOIE);          /* GPIO Interrupt Enabled in all GPIN pins*/ 
      PSR(0x000000FF, NoMask, GPIOIE);  /* Verification that GPIO Interrupt Enable = 0xFF*/

     /* Drive HIGH levels to GPIN pins, so that DO match triggering conditions*/

      /*0000 0001*/
      PSW(0x00000001, GTINR);           /* GTINR = 0000 0001 */ 
      PSR(0x00000001, NoMask, GTINR);   /* Verification that GPIN = 0x01 */  

      PSR(0x00000001, NoMask, GPIORIS); /* GPIORIS = 0x01 (active), */
      PSR(0x00000001, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */

      /*0000 0010*/
      PSW(0x00000002, GTINR);           /* GTINR = 0000 0010 */ 
      PSR(0x00000002, NoMask, GTINR);   /* Verification that GPIN = 0x02 */  

      PSR(0x00000002, NoMask, GPIORIS); /* GPIORIS = 0x02 (active), */
      PSR(0x00000002, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */

      /*0000 0100*/
      PSW(0x00000004, GTINR);           /* GTINR = 0000 0100 */ 
      PSR(0x00000004, NoMask, GTINR);   /* Verification that GPIN = 0x04 */  

      PSR(0x00000004, NoMask, GPIORIS); /* GPIORIS = 0x04 (active), */
      PSR(0x00000004, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */

      /*0000 1000*/
      PSW(0x00000008, GTINR);           /* GTINR = 0000 1000 */ 
      PSR(0x00000008, NoMask, GTINR);   /* Verification that GPIN = 0x08 */  

      PSR(0x00000008, NoMask, GPIORIS); /* GPIORIS = 0x08 (active), */
      PSR(0x00000008, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */




      /*0001 0000*/
      PSW(0x00000010, GTINR);           /* GTINR = 0001 0000 */ 
      PSR(0x00000010, NoMask, GTINR);   /* Verification that GPIN = 0x10 */  

      PSR(0x00000010, NoMask, GPIORIS); /* GPIORIS = 0x01 (active), */
      PSR(0x00000010, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */

      /*0010 0000*/
      PSW(0x00000020, GTINR);           /* GTINR = 0010 0000*/ 
      PSR(0x00000020, NoMask, GTINR);   /* Verification that GPIN = 0x20 */  

      PSR(0x00000020, NoMask, GPIORIS); /* GPIORIS = 0x02 (active), */
      PSR(0x00000020, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */

      /*0100 0000*/
      PSW(0x00000040, GTINR);           /* GTINR =0100  0000 */ 
      PSR(0x00000040, NoMask, GTINR);   /* Verification that GPIN = 0x40 */  

      PSR(0x00000040, NoMask, GPIORIS); /* GPIORIS = 0x04 (active), */
      PSR(0x00000040, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */

      /*1000 0000*/
      PSW(0x00000080, GTINR);           /* GTINR = 1000 0000*/ 
      PSR(0x00000080, NoMask, GTINR);   /* Verification that GPIN = 0x80 */  

      PSR(0x00000080, NoMask, GPIORIS); /* GPIORIS = 0x08 (active), */
      PSR(0x00000080, NoMask, GPIOMIS); /* and GPIOMIS is active*/
      PSR(0x00000001, NoMask, GTINT);   /* Verification that GPIOINTR = 1 (active), */


     /* Drive LOW levels to GPIN pins, so that do not match triggering conditions*/
      PSW(0x00000000, GTINR);           /* GTINR = 0 ==> GPIN = LOW */ 
      PSR(0x00000000, NoMask, GTINR);   /* Verification that GTINR = 0 */
  
      PSR(0x00000000, NoMask, GTINT);   /* Verification that GPIOINTR = 0 (inactive), */
      PSR(0x00000000, NoMask, GPIORIS); /* GPIORIS = 0(inactive), */
      PSR(0x00000000, NoMask, GPIOMIS); /* and GPIOMIS is inactive also*/
      PSR(0x00000000, NoMask, GTMIS);   /* and GPIOMIS is inactive also, Trickbox*/

     
     /* Disable Interrupt Triggering*/
      PSW(0x00000000, GPIOIE);           /*GPIO Interrupt Enable = 0 */ 
      PSR(0x00000000, NoMask, GPIOIE );  /* Verification that GPIO Interrupt Enable = 0*/     

}
