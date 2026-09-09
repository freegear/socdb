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
--  File Name              : TestGPIOReg.c.rca
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
------------------------------------------------------------------------------*/

void TestGPIOReg()
{  
/*
  Summary: GPIO Registers Test
  ============================
  This test checks the following fuctionalities :

  o  Bit patterns are written into the Read and Write registers, i.e.Data Register,
     Data Direction Register, ..., such that all the bits are toggled at least once 
     from 0 to 1 and from 1 to 0. 
     Data is read back after every write and compared with the written pattern. 

  o  Read only registers GPIORIS, GPIOMIS are read

  o  Write only register GPIOIC are written and it can be seen that it keeps its
     new value just for one PCLK (clock) cycle.

  o  Identification registers are read

 */


   /* Normal R/W Registers */
   /* Writing  1010 1010b = 0xAA and reading back */
   /* Writing  1111 1111b = 0xFF and reading back  */
   /* Writing  0101 0101b = 0x55 and reading back */
   /* Writing  0000 0000b = 0x00 and reading back */

/***----------------------------------------------------------------***/
/*** GPIODIR       0x400  8  R/W  Data Direction register           ***/
/***----------------------------------------------------------------***/
   PSW(0x000000AA, GPIODIR, DIR);
   PSR(0x000000AA, NoMask, GPIODIR);
   PSW(0x000000FF, GPIODIR);
   PSR(0x000000FF, NoMask, GPIODIR);
   PSW(0x00000055, GPIODIR);
   PSR(0x00000055, NoMask, GPIODIR);
   PSW(0x00000000, GPIODIR);
   PSR(0x00000000, NoMask, GPIODIR);
/***----------------------------------------------------------------***/
/*** GPIODATA      0x000  8  R/W  Data register                     ***/
/***----------------------------------------------------------------***/
/***I must set the GPIO Direction Register to all ones for allowing writes into the
    GPIODATA register. No writes can be performed when a bit is in input mode. ***/
   PSW(0x000000FF, GPIODIR);
   PSR(0x000000FF, NoMask, GPIODIR);

/* Now we can write and read different patterns of data to GPIODATA */
   PSW(0x000000AA, GPIODATA+0x3FC, DATA); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x000000AA, NoMask, GPIODATA+0x3FC);
   PSW(0x000000FF, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x000000FF, NoMask, GPIODATA+0x3FC);
   PSW(0x00000055, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x00000055, NoMask, GPIODATA+0x3FC);
   PSW(0x00000000, GPIODATA+0x3FC); /*GPIODATA at offset location +0x3FC, no mask*/ 
   PSR(0x00000000, NoMask, GPIODATA+0x3FC);
/***----------------------------------------------------------------***/
/*** GPIOIS        0x404  8  R/W  Interrupt Sense register          ***/
/***----------------------------------------------------------------***/
   PSW(0x000000AA, GPIOIS, IS);
   PSR(0x000000AA, NoMask, GPIOIS);
   PSW(0x000000FF, GPIOIS);
   PSR(0x000000FF, NoMask, GPIOIS);
   PSW(0x00000055, GPIOIS);
   PSR(0x00000055, NoMask, GPIOIS);
   PSW(0x00000000, GPIOIS);
   PSR(0x00000000, NoMask, GPIOIS);
/***----------------------------------------------------------------***/
/*** GPIOIBE       0x408  8  R/W  Interrupt Both Edges register     ***/
/***----------------------------------------------------------------***/
   PSW(0x000000AA, GPIOIBE, IBE);
   PSR(0x000000AA, NoMask, GPIOIBE);
   PSW(0x000000FF, GPIOIBE);
   PSR(0x000000FF, NoMask, GPIOIBE);
   PSW(0x00000055, GPIOIBE);
   PSR(0x00000055, NoMask, GPIOIBE);
   PSW(0x00000000, GPIOIBE);
   PSR(0x00000000, NoMask, GPIOIBE);
/***----------------------------------------------------------------***/
/*** GPIOIEV       0x40C  8  R/W  Interrupt EVent register          ***/
/***----------------------------------------------------------------***/
   PSW(0x000000AA, GPIOIEV, IEV);
   PSR(0x000000AA, NoMask, GPIOIEV);
   PSW(0x000000FF, GPIOIEV);
   PSR(0x000000FF, NoMask, GPIOIEV);
   PSW(0x00000055, GPIOIEV);
   PSR(0x00000055, NoMask, GPIOIEV);
   PSW(0x00000000, GPIOIEV);
   PSR(0x00000000, NoMask, GPIOIEV);
/***----------------------------------------------------------------***/
/*** GPIOIE        0x410  8  R/W  Interrupt Enable register         ***/
/***----------------------------------------------------------------***/
   PSW(0x000000AA, GPIOIE, IE);
   PSR(0x000000AA, NoMask, GPIOIE);
   PSW(0x000000FF, GPIOIE);
   PSR(0x000000FF, NoMask, GPIOIE);
   PSW(0x00000055, GPIOIE);
   PSR(0x00000055, NoMask, GPIOIE);
   PSW(0x00000000, GPIOIE);
   PSR(0x00000000, NoMask, GPIOIE);
/***----------------------------------------------------------------***/
/*** GPIOAFSEL     0x420  8  R/W  Alternate Functionality reg.      ***/
/***----------------------------------------------------------------***/
   PSW(0x000000AA, GPIOAFSEL, AFSEL);
   PSR(0x000000AA, NoMask, GPIOAFSEL);
   PSW(0x000000FF, GPIOAFSEL);
   PSR(0x000000FF, NoMask, GPIOAFSEL);
   PSW(0x00000055, GPIOAFSEL);
   PSR(0x00000055, NoMask, GPIOAFSEL);
   PSW(0x00000000, GPIOAFSEL);
   PSR(0x00000000, NoMask, GPIOAFSEL);

/***----------------------------------------------------------------***/
/*** GPIOITCR       0x600  8  R/W  Integration Test Control reg.    ***/
/***----------------------------------------------------------------***/
   PSW(0x000000AA, GPIOITCR, TCR);
   PSR(0x00000000, NoMask, GPIOITCR,TCR_0);
   PSW(0x000000FF, GPIOITCR);
   PSR(0x00000001, NoMask, GPIOITCR,TCR_A);
   PSW(0x00000055, GPIOITCR);
   PSR(0x00000001, NoMask, GPIOITCR,TCR_B));
   PSW(0x00000000, GPIOITCR);
   PSR(0x00000000, NoMask, GPIOITCR,TCR_0);


/***----------------------------------------------------------------***/
/*** GPIOITIP1     0x604  8  R/W  Integr. Vect. I/P for GPAFOUT     ***/ 
/***----------------------------------------------------------------***/

   PSW(0x00000001, GPIOITCR, TCR);
   PSR(0x00000001, NoMask, GPIOITCR,TCR_C);/* Setting mode to integration  */
                                           /* vectors , GPIOMIS = GPIOITOP1*/
/*It can be written to/read from*/
   PSW(0x000000AA, GPIOITIP1, itip1);
   PSR(0x000000AA, NoMask, GPIOITIP1, r2itip1);
   PSW(0x000000FF, GPIOITIP1, ITOP3);
   PSR(0x000000FF, NoMask, GPIOITIP1, r2itip1);
   PSW(0x00000055, GPIOITIP1, ITOP3);
   PSR(0x00000055, NoMask, GPIOITIP1, r2itip1);
   PSW(0x00000000, GPIOITIP1, ITOP3);
   PSR(0x00000000, NoMask, GPIOITIP1, r2itip1);

   PSW(0x00000000, GPIOITCR, TCR);
   PSR(0x00000000, NoMask, GPIOITCR,TCR_C);/* Exiting mode to integration  */
                                           /* vectors , GPIOMIS = GPIOITOP1*/


/***----------------------------------------------------------------***/
/*** GPIOITIP2     0x608  8  R/W  Integr. Vect. O/P for GPAFIN      ***/ 
/***----------------------------------------------------------------***/

   PSW(0x00000001, GPIOITCR, TCR);
   PSR(0x00000001, NoMask, GPIOITCR,TCR_C);/* Setting mode to integration  */
                                           /* vectors , GPIOMIS = GPIOITOP1*/
/*It can be written to/read from*/
   PSW(0x000000AA, GPIOITIP2, ITOP3);
   PSR(0x000000AA, NoMask, GPIOITIP2, ITOP3);
   PSW(0x000000FF, GPIOITIP2, ITOP3);
   PSR(0x000000FF, NoMask, GPIOITIP2, ITOP3);
   PSW(0x00000055, GPIOITIP2, ITOP3);
   PSR(0x00000055, NoMask, GPIOITIP2, ITOP3);
   PSW(0x00000000, GPIOITIP2, ITOP3);
   PSR(0x00000000, NoMask, GPIOITIP2, ITOP3);


   PSW(0x00000000, GPIOITCR, TCR);
   PSR(0x00000000, NoMask, GPIOITCR,TCR_C);/* Exiting mode to integration  */
                                          /* vectors , GPIOMIS = GPIOITOP1 */

/***----------------------------------------------------------------***/
/*** GPIOITOP1     0x60C  8  W    Integration MIS Test O/P Set reg. ***/
/***----------------------------------------------------------------***/

   PSW(0x00000001, GPIOITCR, TCR);
   PSR(0x00000001, NoMask, GPIOITCR,TCR_C);/* Setting mode to integration  */
                                           /* vectors , GPIOMIS = GPIOITOP1*/
/*GPIOITOP1 must be read after the multiplexer, which in fact is */
/*GPIOMIS, reading to a non-existent register location should   */
/*Return zeros*/
   PSW(0x000000AA, GPIOITOP1, TOP);
   PSR(0x00000000, NoMask, GPIOITOP1, TOP1);
   PSW(0x000000FF, GPIOITOP1);
   PSR(0x00000000, NoMask, GPIOITOP1);
   PSW(0x00000055, GPIOITOP1);
   PSR(0x00000000, NoMask, GPIOITOP1);
   PSW(0x00000000, GPIOITOP1);
   PSR(0x00000000, NoMask, GPIOITOP1);

/* Setting GPIOITCR to '1' it will be possible to read the effects of */
/* GPIOITOP1 in GPIOMIS, this is the desired behaviour and sense of   */
/* having GPIOITOP1. */
 

   PSW(0x000000AA, GPIOITOP1, TOP);
   PSR(0x000000AA, NoMask, GPIOMIS, TOP);
   PSW(0x000000FF, GPIOITOP1);
   PSR(0x000000FF, NoMask, GPIOMIS);
   PSW(0x00000055, GPIOITOP1);
   PSR(0x00000055, NoMask, GPIOMIS);
   PSW(0x00000000, GPIOITOP1);
   PSR(0x00000000, NoMask, GPIOMIS);

   PSW(0x00000000, GPIOITCR, TCR);
   PSR(0x00000000, NoMask, GPIOITCR,TCR_C);/* Exiting mode to integration  */
                                          /* vectors , GPIOMIS = GPIOITOP1 */
/***----------------------------------------------------------------***/
/*** GPIOITOP2     0x610  1  R    Integr. Interrupt Test O/P Read r.***/
/***----------------------------------------------------------------***/

/* GPIOITOP2 reflects the status of the GPIOINTR interrupt output pin  */
/* GPIOINTR is a combined output or-function of GPIOMIS[7:0]. Hence   */
/* in order to write to GPIOINTR we use GPIOITOP1, and in order to read*/
/* the status of GPIOINTR we read GPIOITOP2                            */
/* GPIOITOP1, as we saw above is read as GPIOMIS */


/* Setting GPIOITCR to '1' it will be possible to read the effects of */
/* GPIOITOP1 in GPIOMIS, this is the desired behaviour and sense of   */
/* having GPIOITOP1. */
   PSW(0x00000001, GPIOITCR, TCR);
   PSR(0x00000001, NoMask, GPIOITCR,TCR_C);/* Setting mode to integration  */
                                          /* vectors , GPIOMIS = GPIOITOP1 */
   PSW(0x000000AA, GPIOITOP1, TOP);
   PSR(0x000000AA, NoMask, GPIOMIS, TOP);
   PSR(0x00000001, NoMask, GPIOITOP2, TOP2);

   PSW(0x000000FF, GPIOITOP1);
   PSR(0x000000FF, NoMask, GPIOMIS);
   PSR(0x00000001, NoMask, GPIOITOP2, TOP2);

   PSW(0x00000055, GPIOITOP1);
   PSR(0x00000055, NoMask, GPIOMIS);
   PSR(0x00000001, NoMask, GPIOITOP2, TOP2);

   PSW(0x00000000, GPIOITOP1);
   PSR(0x00000000, NoMask, GPIOMIS);        /* Verified the status of GPIOINTR*/
   PSR(0x00000000, NoMask, GPIOITOP2, TOP2);/* using GPIOITOP2 Read-only reg.  */

   PSW(0x00000000, GPIOITCR, TCR);
   PSR(0x00000000, NoMask, GPIOITCR,TCR_C);/* Exiting mode to integration  */
                                          /* vectors , GPIOMIS = GPIOITOP1 */

/***----------------------------------------------------------------***/
 /*** GPIOITOP3     0x614  8  R/W  Integr. Vect. I/P for nGPAFEN    ***/
/***----------------------------------------------------------------***/
   PSW(0x00000001, GPIOITCR, TCR);
   PSR(0x00000001, NoMask, GPIOITCR,TCR_C);/* Setting mode to integration  */
                                           /* vectors , GPIOMIS = GPIOITOP1*/


/*It can be written to/read from*/
   PSW(0x000000AA, GPIOITOP3, ITOP3);
   PSR(0x000000AA, NoMask, GPIOITOP3, ITOP3);
   PSW(0x000000FF, GPIOITOP3, ITOP3);
   PSR(0x000000FF, NoMask, GPIOITOP3, ITOP3);
   PSW(0x00000055, GPIOITOP3, ITOP3);
   PSR(0x00000055, NoMask, GPIOITOP3, ITOP3);
   PSW(0x00000000, GPIOITOP3, ITOP3);
   PSR(0x00000000, NoMask, GPIOITOP3, ITOP3);

   PSW(0x00000000, GPIOITCR, TCR);
   PSR(0x00000000, NoMask, GPIOITCR,TCR_C);/* Exiting mode to integration  */
                                           /* vectors , GPIOMIS = GPIOITOP1*/

/*** GPIOPeriphID0 0xFE0  8  R    Identification(0) register        ***/
  PSR(0x00000061, NoMask, GPIOPeriphID0, PH0);
/*** GPIOPeriphID1 0xFE4  8  R    Identification(1) register        ***/
  PSR(0x00000010, NoMask, GPIOPeriphID1);
/*** GPIOPeriphID2 0xFE8  8  R    Identification(2) register        ***/
  PSR(0x00000004, NoMask, GPIOPeriphID2);
/*** GPIOPeriphID3 0xFEC  8  R    Identification(3) register        ***/
  PSR(0x00000000, NoMask, GPIOPeriphID3);


/*** GPIOPCellID0    0xFF0  8  R    Octopus Identification(0) reg.    ***/
  PSR(0x0000000D, NoMask, GPIOPCellID0, OCT0);
/*** GPIOPCellID1    0xFF4  8  R    Octopus Identification(1) reg.    ***/
  PSR(0x000000F0, NoMask, GPIOPCellID1);
/*** GPIOPCellID2    0xFF8  8  R    Octopus Identification(2) reg.    ***/
  PSR(0x00000005, NoMask, GPIOPCellID2);
/*** GPIOPCellID3    0xFFC  8  R    Octopus Identification(3) reg.    ***/
  PSR(0x000000B1, NoMask, GPIOPCellID3);

}
