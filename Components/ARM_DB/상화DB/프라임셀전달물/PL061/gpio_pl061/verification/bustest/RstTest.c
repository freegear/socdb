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
--  File Name              : RstTest.c.rca
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
------------------------------------------------------------------------------*/

/******************************************************************************/
/**************************** Reset Test **************************************/
/******************************************************************************/

void RstTest()
{
  /*
   Summary: Reset Test
   ===================
   This test reads all the GPIO registers a/fter reset to verify that they
   initialise to their reset value of zero. The Data Register and GPIORIS are
   not read during this test as the pins are set as inputs on reset.
   Hence the contents of the GPIODATA register will reflect the status
   of the input pins and and the GPIORIS will react to the values driven by 
   external devices.
  */

  /* PSR(0x00000000, NoMask, GPIODATA);*/ /*It depends on GPIN */
  PSR(0x00000000, NoMask, GPIODIR, RstTest_start);
  PSR(0x00000000, NoMask, GPIOIS,  IS);
  PSR(0x00000000, NoMask, GPIOIBE, IBE);
  PSR(0x00000000, NoMask, GPIOIEV, IEV);
  PSR(0x00000000, NoMask, GPIOIE,  IE);

  PSR(0x00000000, NoMask, GPIOMIS,   MIS);
  PSR(0x00000000, NoMask, GPIOAFSEL, AFSEL); 

  PSR(0x00000000, NoMask, GPIOITCR, ITCR);
  PSR(0x00000000, NoMask, GPIOITIP1, ITIP1); 
  PSR(0x00000000, NoMask, GPIOITIP2, ITIP2);
  PSR(0x00000000, NoMask, GPIOITOP1, ITOP1); 
  PSR(0x00000000, NoMask, GPIOITOP2, ITOP2); 
  PSR(0x00000000, NoMask, GPIOITOP3, ITOP3);

  PSR(0x00000061, NoMask, GPIOPeriphID0,P_ID0);
  PSR(0x00000010, NoMask, GPIOPeriphID1,P_ID1);
  PSR(0x00000004, NoMask, GPIOPeriphID2,P_ID2);
  PSR(0x00000000, NoMask, GPIOPeriphID3,P_ID3);

  PSR(0x0000000D, NoMask, GPIOPCellID0,O_ID1);
  PSR(0x000000F0, NoMask, GPIOPCellID1,O_ID2);
  PSR(0x00000005, NoMask, GPIOPCellID2,O_ID3);
  PSR(0x000000B1, NoMask, GPIOPCellID3,O_ID4);

 /*****************************************************/
 /******************* Interrupts **********************/
 /*****************************************************/
 /* Checking that they do not trigger interrupts check GPIOINTR */
  /* Perform a reset */
  PI(0x0F);
  RES(LOW,0x01,0x01);

  /*GPIOINTR and GPIOMIS should be = 0 at reset.*/
  PSR(0x00000000, NoMask, GTINT);
  PSR(0x00000000, NoMask, GTMIS);

  /* The GPIO after reset is set to detect falling edges : */
  /* GPIOIS=0,GPIOIEV=0, GPIOIEV=0 .                         */

  /* Set conditions to trigger interrupt using Trickbox to FALLING EDGE,  on the */
  /* appropriate pins: GTINR = 0xFF AND THEN GTINR = 0x00 (FALLING EDGE)         */
  PSW(0x00000000, GTINR);           /* GPIN Pins to LOW (by default in the t.box)*/
  PSR(0x00000000, NoMask, GTINR,a);   /* Checking writing performed */
 
  PSR(0x00000000, NoMask, GPIORIS,b); /* GPIORIS has not sensed any falling edge  */

  PSW(0x000000FF, GTINR);           /* GPIN Pins to HIGH (RISING EDGE)*/
  PSR(0x000000FF, NoMask, GTINR,c);   /* Checking writing performed */

  PSR(0x00000000, NoMask, GPIORIS,d); /* GPIORIS has not sensed any falling edge  */

  PSW(0x00000000, GTINR);           /* GPIN Pins to LOW (FALLING EDGE)*/
  PSR(0x00000000, NoMask, GTINR,e);   /* Checking writing performed */

  PSR(0x000000FF, NoMask, GPIORIS,f); /* GPIORIS is detecting the falling edge */
                                    /* and showing ones: expected 0xFF       */

  PSR(0x00000000, NoMask, GTMIS,g);   /* GPIOMIS bits and on-chip signals are still unactive LOW*/ 
  PSR(0x00000000, NoMask, GTINT,h);   /* GPIOINTR is still unactive LOW*/
  /* Therefore Interrupt don't trigger at */
  /* RESET. VERIFICATION PERFORMED */
 
  PSW(0x000000FF, GPIOIE);          /* Only enabling interrupt triggering GPIOIE =1 */
  PSR(0x000000FF, NoMask, GPIOIE,i);
  
  PSR(0x000000FF, NoMask, GTMIS,j);   /* GPIOMIS pins become active HIGH*/ 
  PSR(0x00000001, NoMask, GTINT,k);   /* GPIOINTR becomes active HIGH*/

  PSW(0x000000FF, GPIOIC);          /* GPIO Interrupt Clear Edge logic  */  

  PSR(0x00000000, NoMask, GTMIS,l);   /* GPIOMIS pins become unactive LOW */ 
  PSR(0x00000000, NoMask, GTINT,m);   /* GPIOINTR becomes unactive LOW again. */  

  PSW(0x00000000, GPIOIE);          /* Disable Interrupt Generation GPIOIE = 0 */
  PSR(0x00000000, NoMask, GPIOIE,n);
 
  PSR(0x00000000, NoMask, GTMIS,o);   /* GPIOMIS pins remain unactive LOW */ 
  PSR(0x00000000, NoMask, GTINT,p);   /* GPIOINTR remain unactive LOW */  

  /*Therefore Interrupt don't trigger at */
  /*RESET . VERIFICATION PERFORMED*/

}
