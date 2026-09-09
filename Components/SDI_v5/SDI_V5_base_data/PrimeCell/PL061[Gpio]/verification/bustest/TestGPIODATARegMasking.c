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
--  File Name              : TestGPIODATARegMasking.c.rca
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
------------------------------------------------------------------------------*/


void TestGPIODATARegMasking()
{
/* Address Masking of GPIODATA */
/***----------------------------------------------------------------***/
/*** GPIODATA      0x000  8  R/W  Data register                     ***/
/***                                                                ***/
/***----------------------------------------------------------------***/
/***Set the GPIO Direction Register to all ones for allowing writes into the
    GPIODATA register.                                                         ***/
   PSW(0x000000FF, GPIODIR);
   PSR(0x000000FF, NoMask, GPIODIR);
/*                                            ***/
   PSW(0x000000AA, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x000000AA, NoMask, GPIODATA+0x3FC);
   PSW(0x000000FF, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x000000FF, NoMask, GPIODATA+0x3FC);
   PSW(0x00000055, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x00000055, NoMask, GPIODATA+0x3FC);
   PSW(0x00000000, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x00000000, NoMask, GPIODATA+0x3FC);

/* Write 0xAB via writing 0xFF at position 0x2AC  = 0010 1010 1100 -> 
                                            mask:     10 1010 11   = 0xAB*/
   PSW(0x000000FF, GPIODATA+0x2AC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x000000AB, NoMask, GPIODATA+0x3FC);
  
   PI(0x0F);
/* Reading the 0xAB hold in GPIODATA as 0x8A via reading with read mask*/
/* 0x1010 1011 & 0x1101 1110  = 0x1000 1010, that corresponds to the offset  */
/* +0010 0010 1000b in hexadecimal 0x228 */
   PSR(0x0000008A, NoMask, GPIODATA+0x228);


/* WRITE MASK */
/* Write 0xFF to GPIODATA through 4 masks, 0x00, 0x55, 0xFF, 0xAA */
/* Checking we write  0x00, 0x55, 0xFF, 0xAA */

   PSW(0x00000000, GPIODATA+0x3FC); /*CLEAR GPIODATA*/ /*, "CLEARGPIODATA"*/
   PSR(0x00000000, NoMask, GPIODATA+0x3FC);

   PSW(0x000000FF, GPIODATA+0x000); /*GPIODATA at offset location +0x000, mask*/ /*, "MASK0x00"*/
   PSR(0x00000000, NoMask, GPIODATA+0x3FC); 

   PSW(0x00000000, GPIODATA+0x3FC); /*CLEAR GPIODATA*/ /*, "CLEARGPIODATA"*/
   PSR(0x00000000, NoMask, GPIODATA+0x3FC);

   PSW(0x000000FF, GPIODATA+0x154); /*GPIODATA at offset location +0x154, mask*/ /*, "MASK0x55"*/
   PSR(0x00000055, NoMask, GPIODATA+0x3FC);

   PSW(0x00000000, GPIODATA+0x3FC); /*CLEAR GPIODATA*/ /*, "CLEARGPIODATA"*/
   PSR(0x00000000, NoMask, GPIODATA+0x3FC);

   PSW(0x000000FF, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x000000FF, NoMask, GPIODATA+0x3FC);/*, "MASK0xFF"*/

   PSW(0x00000000, GPIODATA+0x3FC); /*CLEAR GPIODATA*/ /*, "CLEARGPIODATA"*/
   PSR(0x00000000, NoMask, GPIODATA+0x3FC);


   PSW(0x000000FF, GPIODATA+0x2A8); /*GPIODATA at offset location +0x2A8, mask*//*, "MASK0xAA"*/ 
   PSR(0x000000AA, NoMask, GPIODATA+0x3FC);

/* READ MASK */
/* Write 0xFF to GPIODATA and read the value obtaining 0x00, 0x55, 0xFF, 0xAA */

   PSW(0x000000FF, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   

   PSR(0x000000AA, NoMask, GPIODATA+0x2A8); /* We read 0xAA at location +0x2A8 *//*,"BBB"*/
  
   PSR(0x00000000, NoMask, GPIODATA+0x000); /* We read 0x00 at location +0x3FC */

   PSR(0x00000055, NoMask, GPIODATA+0x154); /* We read 0x55 at location +0x154 */

   PSR(0x000000FF, NoMask, GPIODATA+0x3FC); /* We read 0xFF at location +0x3FC */


/* When writing to address masked bits those remain unchanged */

  PSW(0x00000000, GPIODATA+0x000); /*GPIODATA at offset location +0x000, mask*/ 
                                   /*GPIODATA must remain with the previous value*/
  
  PSR(0x000000FF, NoMask, GPIODATA+0x3FC); /* We read 0xFF back */

}
