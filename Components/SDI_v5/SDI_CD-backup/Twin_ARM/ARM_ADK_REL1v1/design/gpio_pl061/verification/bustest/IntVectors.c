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
--  File Name              : IntVectors.c.rca
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
------------------------------------------------------------------------------*/

/******************************************************************************/
/*************************   Alternate Functionality  *************************/
/*************************     Integration Vectors    *************************/
/******************************************************************************/

void IntVectors()
{

/***----------------------------------------------------------------***/
/*** GPIOITIP1     0x604  8  R/W  Integr. Vect. I/P for GPAFOUT     ***/ 
/***----------------------------------------------------------------***/



/* 1. Checking connection GPAFOUT-GPIOITIP1 */
/*   1.1 Writing patterns from Trickbox and testing that they are read in  */
/*       GPIOITIP1    */
                                                     
  PSW(0x00000000, GPIOITCR, TCR);
  PSR(0x00000000, NoMask, GPIOITCR,TCR_C);/* Exiting integration vectors mode*/
 
  PSW(0x000000AA, GTAOUTR);
  PSR(0x000000AA, NoMask, GTAOUTR, W2nGPAFEN);
  PSR(0x000000AA, NoMask, GPIOITIP1, R2ITIP1);
  
  PSW(0x000000FF, GTAOUTR);
  PSR(0x000000FF, NoMask, GTAOUTR, W2nGPAFEN);
  PSR(0x000000FF, NoMask, GPIOITIP1, RITIP1);

  PSW(0x00000055, GTAOUTR);
  PSR(0x00000055, NoMask, GTAOUTR, W2nGPAFEN);
  PSR(0x00000055, NoMask, GPIOITIP1, R);

  PSW(0x00000000, GTAOUTR);
  PSR(0x00000000, NoMask, GTAOUTR, W2nGPAFEN);
  PSR(0x00000000, NoMask, GPIOITIP1, TIP);

  PSW(0x00000000, GPIOITCR, TCR);
  PSR(0x00000000, NoMask, GPIOITCR,TCR_C);/* Exiting integration vectors mode*/
                                          

/* 2. Checking connection GPIOITIP1-GPOUT  */
/*   2.1 Writing patterns to GPIOITIP1 and testing that they are able to  */
/*       appear in GPOUT so that we will be able to test the PRIMARY PADS.*/

  PSW(0x00000001, GPIOITCR, TCR);
  PSR(0x00000001, NoMask, GPIOITCR,TCR_C); /* Setting mode to integration  */
                                           /* vectors , GPIOMIS = GPIOITOP1*/
  
  PSW(0x000000FF, GPIOAFSEL);              /* Enabling AF lines */
  PSR(0x000000FF, NoMask, GPIOAFSEL);
  

  PSW(0x000000AA, GPIOITIP1);
  PSR(0x000000AA, NoMask, GPIOITIP1, W2ITIP1);
  PSR(0x000000AA, NoMask, GTOUTR, R2GPOUT);
  
  PSW(0x000000FF, GPIOITIP1);
  PSR(0x000000FF, NoMask, GPIOITIP1, W2ITIP1);
  PSR(0x000000FF, NoMask, GPIOITIP1, R2GPOUT);

  PSW(0x00000055, GPIOITIP1);
  PSR(0x00000055, NoMask, GPIOITIP1, W2ITIP1);
  PSR(0x00000055, NoMask, GPIOITIP1, R2GPOUT);

  PSW(0x00000000, GPIOITIP1);
  PSR(0x00000000, NoMask, GPIOITIP1, W2ITIP1);
  PSR(0x00000000, NoMask, GPIOITIP1, R2GPOUT);


  PSW(0x00000000, GPIOAFSEL);              /* Disabling AF lines */
  PSR(0x00000000, NoMask, GPIOAFSEL);

  PSW(0x00000000, GPIOITCR, TCR);
  PSR(0x00000000, NoMask, GPIOITCR,TCR_C); /* Exiting integration vectors mode*/


/***----------------------------------------------------------------***/
/*** GPIOITIP2     0x608  8  R/W  Integr. Vect. O/P for GPAFIN      ***/ 
/***----------------------------------------------------------------***/

/* 1. Checking connection nGPAFEN-GPIOITIP2 */
/*   1.1 Writing patterns from Trickbox and testing that they are read in  */
/*       GPIOITIP2      */
                                                   
  PSW(0x00000000, GPIOITCR, TCR);
  PSR(0x00000000, NoMask, GPIOITCR, TCR_C);/* Exiting integration vectors mode*/
 
  PSW(0x000000AA, GTAENR);
  PSR(0x000000AA, NoMask, GTAENR, W2nGPAFEN);
  PSR(0x000000AA, NoMask, GPIOITIP2, R2ITIP2);
  
  PSW(0x000000FF, GTAENR);
  PSR(0x000000FF, NoMask, GTAENR, W2nGPAFEN);
  PSR(0x000000FF, NoMask, GPIOITIP2);

  PSW(0x00000055, GTAENR);
  PSR(0x00000055, NoMask, GTAENR, W2nGPAFEN);
  PSR(0x00000055, NoMask, GPIOITIP2);

  PSW(0x00000000, GTAENR);
  PSR(0x00000000, NoMask, GTAENR, W2nGPAFEN);
  PSR(0x00000000, NoMask, GPIOITIP2);

  PSW(0x00000000, GPIOITCR, TCR);
  PSR(0x00000000, NoMask, GPIOITCR,TCR_C);/* Exiting integration vectors mode*/
                                          

/* 2. Checking connection GPIOITIP2-nGPEN  */
/*   2.1 Writing patterns to GPIOITIP2 and testing that they are able to  */
/*       appear in nGPEN so that we will be able to test the PRIMARY PADS.*/

  PSW(0x00000001, GPIOITCR, TCR);
  PSR(0x00000001, NoMask, GPIOITCR,TCR_C); /* Setting mode to integration  */
                                           /* vectors , GPIOMIS = GPIOITOP1*/
  
  PSW(0x000000FF, GPIOAFSEL);              /* Enabling AF lines */
  PSR(0x000000FF, NoMask, GPIOAFSEL);
  

  PSW(0x000000AA, GPIOITIP2);
  PSR(0x000000AA, NoMask, GPIOITIP2, W2ITIP2);
  PSR(0x000000AA, NoMask, GTENR, R2nGPEN);
  
  PSW(0x000000FF, GPIOITIP2);
  PSR(0x000000FF, NoMask, GPIOITIP2, W2ITIP2);
  PSR(0x000000FF, NoMask, GTENR, R2nGPEN);

  PSW(0x00000055, GPIOITIP2);
  PSR(0x00000055, NoMask, GPIOITIP2, W2ITIP2);
  PSR(0x00000055, NoMask, GTENR, R2nGPEN);

  PSW(0x00000000, GPIOITIP2);
  PSR(0x00000000, NoMask, GPIOITIP2, W2ITIP2);
  PSR(0x00000000, NoMask, GTENR, R2nGPEN);


  PSW(0x00000000, GPIOAFSEL);              /* Disabling AF lines */
  PSR(0x00000000, NoMask, GPIOAFSEL);

  PSW(0x00000000, GPIOITCR, TCR);
  PSR(0x00000000, NoMask, GPIOITCR,TCR_C); /* Exiting integration vectors mode*/




}
