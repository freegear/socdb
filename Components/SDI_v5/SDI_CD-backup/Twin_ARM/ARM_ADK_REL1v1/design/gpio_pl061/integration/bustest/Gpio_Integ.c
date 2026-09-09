/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Gpio_Integ.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL061-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--           BusTalk vectors are applied to the AMBA APB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Gpio.h, Gpio_Integ.c
--
--   Usage: make <testname> e.g. make Integ
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Integ
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/
 
/**********************************************************************/
/*** For more information on the GPIO, please refer to PL061 AMBA   ***/
/*** GPIO Block Specification                                       ***/
/**********************************************************************/


void Gpio_Integ(void)
{
  C("Gpio Integration Test");
  
  /* IntegrationTest:
     ================
     ================
     When the GPIO is used in an AMBA system, it must be ensured that
     all of its pins are correctly connected. Integration vectors
     allow the user to verify that the GPIO has been wired into the
     system correctly.
  */




  C("Testing Primary Input/Output Pad connections");
  /*
     A. Pad signals nGPEN[7:0], GPOUT[7:0] and GPIN[7:0]
     ================================================================
     Testing of Pad connections (nGPEN[7:0], GPOUT[7:0] and GPIN[7:0]) :

     The procedure is given below.
     - Write 0xFF to the Alternate Functionality Control register GPIOAFSEL and 1 to
       the ITEN bit in the Integration Control register. This selects
       the test path from the GPIOITIP2[7:0], GPIOITIP1[7:0] to the internal 
       nGPEN[7:0], GPOUT[7:0] PAD signals respectively.
     - Make sure the GPIO is in input mode by writing 0x00 to GPIODIR, otherwise
       the data path from GPIN[7:0] to GPIODATA would be broken and no data
       could be read.
     - Write a 1 and then a 0 to the GPIOITIP2[7:0] and GPIOITIP1[7:0]. 
     - The TrickBox will generate the input signals for the GPIN(7:0) pins of the 
       GPIO as a XOR logical operation of the GPIO output lines nGPEN(7:0) 
       and GPOUT(7:0).

          -- XOR
          -- --------------------------------
          -- nGPEN[i]   GPOUT[i]   |  GPIN[i]
          -- --------------------------------
          --     0         0       |    0
          --     0         1       |    1
          --     1         0       |    1
          --     1         1       |    0
          -- --------------------------------

     - Allow a time period of twice PCLK for the data to go through the synchroniza
       tion stage in th GpioAfm block.
     - Read GPIODATA+0x3FC and verify that the result is the expected.
  */

  /*-------------------------------------------------------------------------------*/
  /* Enable Integration testing of the GPIO primary inputs and outputs  by setting 
     the ITEN bit in the GPIOITCR register and writing 0xFF to GPIOAFSEL            
     In order to read in GPIODATA, GPIODIR must be set to INPUTS: GPIODIR = 0x00.  */

    PSW(0x01, GPIOITCR);
    PSW(0xFF, GPIOAFSEL);
    PSW(0x00, GPIODIR);

  /*1. Verifying primary input/output                                              */
  /*----------------------------------                                             */
  /*
    -- XOR
    -- --------------------------------    -- ------------------------------------
    -- nGPEN[i]   GPOUT[i]   |  GPIN[i]    -- GPIOITIP2[i] GPIOITIP1[i] |  GPIN[i]
    -- -------------------------------- =  -- ------------------------------------
    --     0         0       |    0        --       0           0       |    0
    -- --------------------------------    -- ------------------------------------
  */
  
    PSW(0x00, GPIOITIP2);       
    PSW(0x00, GPIOITIP1);
    PI(3);
    PSR(0x00, NoMask, GPIODATA+0x3FC,xor_0);

  /*
    -- XOR
    -- --------------------------------    -- ------------------------------------
    -- nGPEN[i]   GPOUT[i]   |  GPIN[i]    -- GPIOITIP2[i] GPIOITIP1[i] |  GPIN[i]
    -- -------------------------------- =  -- ------------------------------------
    --     0         1       |    1        --       0           1       |    1
    -- --------------------------------    -- ------------------------------------
  */
  
    PSW(0x00, GPIOITIP2);       
    PSW(0x00, GPIOITIP1);
    PI(3);
    PSR(0x00, NoMask, GPIODATA+0x3FC,xor_1);

  /*The Walking One in GPOUT[7:0]*/

    PSW(0x01, GPIOITIP1);
    PI(3);
    PSR(0x01, NoMask, GPIODATA+0x3FC,xor_1a);

    PSW(0x02, GPIOITIP1);
    PI(3);
    PSR(0x02, NoMask, GPIODATA+0x3FC,xor_1b);

    PSW(0x04, GPIOITIP1);
    PI(3);
    PSR(0x04, NoMask, GPIODATA+0x3FC,xor_1c);

    PSW(0x08, GPIOITIP1);
    PI(3);
    PSR(0x08, NoMask, GPIODATA+0x3FC,xor_1d);


    PSW(0x10, GPIOITIP1);
    PI(3);
    PSR(0x10, NoMask, GPIODATA+0x3FC,xor_1e);

    PSW(0x20, GPIOITIP1);
    PI(3);
    PSR(0x20, NoMask, GPIODATA+0x3FC,xor_1f);

    PSW(0x40, GPIOITIP1);
    PI(3);
    PSR(0x40, NoMask, GPIODATA+0x3FC,xor_1g);

    PSW(0x80, GPIOITIP1);
    PI(3);
    PSR(0x80, NoMask, GPIODATA+0x3FC,xor_1h);

  /*End of The Walking One in GPOUT[7:0]*/

    PSW(0x00, GPIOITIP1);
    PI(3);
    PSR(0x00, NoMask, GPIODATA+0x3FC,xor_1i);

  /*
    -- XOR
    -- --------------------------------    -- ------------------------------------
    -- nGPEN[i]   GPOUT[i]   |  GPIN[i]    -- GPIOITIP2[i] GPIOITIP1[i] |  GPIN[i]
    -- -------------------------------- =  -- ------------------------------------
    --     1         0       |    1        --       1           0       |    1
    -- --------------------------------    -- ------------------------------------
  */
  
    PSW(0x00, GPIOITIP2);       
    PSW(0x00, GPIOITIP1);
    PI(3);
    PSR(0x00, NoMask, GPIODATA+0x3FC,xor_2);

  /*The Walking One in nGPEN[7:0]*/

    PSW(0x01, GPIOITIP2);
    PI(3);
    PSR(0x01, NoMask, GPIODATA+0x3FC,xor_2);

    PSW(0x02, GPIOITIP2);
    PI(3);
    PSR(0x02, NoMask, GPIODATA+0x3FC,xor_2);

    PSW(0x04, GPIOITIP2);
    PI(3);
    PSR(0x04, NoMask, GPIODATA+0x3FC,xor_2);

    PSW(0x08, GPIOITIP2);
    PI(3);
    PSR(0x08, NoMask, GPIODATA+0x3FC,xor_2);


    PSW(0x10, GPIOITIP2);
    PI(3);
    PSR(0x10, NoMask, GPIODATA+0x3FC,xor_2);

    PSW(0x20, GPIOITIP2);
    PI(3);
    PSR(0x20, NoMask, GPIODATA+0x3FC,xor_2);

    PSW(0x40, GPIOITIP2);
    PI(3);
    PSR(0x40, NoMask, GPIODATA+0x3FC,xor_2);

    PSW(0x80, GPIOITIP2);
    PI(3);
    PSR(0x80, NoMask, GPIODATA+0x3FC,xor_2);

  /*End of The Walking One in nGPEN[7:0]*/
    PSW(0x00, GPIOITIP2);
    PI(3);
    PSR(0x00, NoMask, GPIODATA+0x3FC,xor_2);

  /*
    -- XOR
    -- --------------------------------    -- ------------------------------------
    -- nGPEN[i]   GPOUT[i]   |  GPIN[i]    -- GPIOITIP2[i] GPIOITIP1[i] |  GPIN[i]
    -- -------------------------------- =  -- ------------------------------------
    --     1         1       |    0        --       1           1       |    0
    -- --------------------------------    -- ------------------------------------
  */
  
    PSW(0xFF, GPIOITIP2);       
    PSW(0xFF, GPIOITIP1);
    PI(3);
    PSR(0x00, NoMask, GPIODATA+0x3FC,xor_3);

 
    PSW(0x00, GPIOAFSEL);                        /*Disabling Alternate Functionality*/
    

   /*-------------------------------------------------------------------------------*/
   /*--------------------  Primary Lines Integration Verified   --------------------*/
   /*-------------------------------------------------------------------------------*/




  C("Testing Alternate Functionality Intra Chip Input connection");
  /*
     B. Intra-Chip signals nGPAFEN[7:0], GPAFOUT[7:0] and GPAFIN[7:0]
     ================================================================
     Testing of Intra-Chip connections (nGPAFEN[7:0], GPAFOUT[7:0] and GPAFIN[7:0]) :
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Integration Control register. This selects
       the test path from the GPIOITIP2[7:0], GPIOITIP1[7:0] and GPIOITOP3[7:0] 
       register bits to the internal nGPAFEN[7:0], GPAFOUT[7:0] and GPAFIN[7:0]
       signals respectively.
     - Write a 1 and then a 0 to the GPIOITIP2[7:0], GPIOITIP1[7:0] and
       GPIOITOP3[7:0] register bits and read the same register bit to ensure 
       that the value written is read out.

     When integration tests are run in an integrated system '1' and '0'
     are actually written into internal registers of the device connected to 
     the Alternate Functionality lines so as to toggle the nGPAFEN, GPAFOUT
     from the Generic peripheral.
     
     GPAFIN signal will be controlled from the Gpio via writing to GPIOITOP3 and
     the value written must be read from the peripheral connected to the Alternate
     Functionality lines to verify connectivity.
  */

  /*-------------------------------------------------------------------------------*/
  /* Enable Integration testing of the GPIO by setting the ITEN
     bit in the GPIOITCR register                                                  */

     PSW(0x01, GPIOITCR);

  /*1. Verifying connectivity of nGPAFEN                                           */
  /*------------------------------------                                           */

  /*-------------------------------------------------------------------------------*/ 
  /* Set the nGPAFEN Intra-chip input 

     NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the peripheral Alternate Functionality output enable signal
            from the peripheral itself.                                            */

     PSW(0xFF, GPIOITIP2); 

  /* Read the value on the nGPAFEN Intra-chip input */ 

     PSR(0xFF, NoMask, GPIOITIP2, itip2);
  /*-------------------------------------------------------------------------------*/
  /* Clear the nGPAFEN Intra-chip input 

     NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the peripheral Alternate Functionality output enable signal
            from the peripheral itself.                                            */

     PSW(0x00, GPIOITIP2); 

  /* Read the value on the nGPAFEN Intra-chip input                                */ 
     PSR(0x00, NoMask, GPIOITIP2, itip2);
  /*-------------------------------------------------------------------------------*/
  /* Set particular nGPAFEN input pins to one and read to verify that they can carry
     information independently : The Walking "1".                                  

     NOTE : When the tests are run in an integrated system, the user is
            expected to replace these PSW write with a suitable command to 
            set the peripheral Alternate Functionality output enable signal
            from the peripheral itself.                                            */
     
     PSW(0x00000000, GPIOITIP2); 
     PSR(0x00000000, NoMask, GPIOITIP2,itip2_1a);

     PSW(0x00000001, GPIOITIP2); 
     PSR(0x00000001, NoMask, GPIOITIP2,itip2_1b);

     PSW(0x00000002, GPIOITIP2); 
     PSR(0x00000002, NoMask, GPIOITIP2,itip2_1c);

     PSW(0x00000004, GPIOITIP2); 
     PSR(0x00000004, NoMask, GPIOITIP2,itip2_1d);

     PSW(0x00000008, GPIOITIP2); 
     PSR(0x00000008, NoMask, GPIOITIP2,itip2_1e);

     PSW(0x00000010, GPIOITIP2); 
     PSR(0x00000010, NoMask, GPIOITIP2,itip2_1f);

     PSW(0x00000020, GPIOITIP2); 
     PSR(0x00000020, NoMask, GPIOITIP2,itip2_1g);

     PSW(0x00000040, GPIOITIP2); 
     PSR(0x00000040, NoMask, GPIOITIP2,itip2_1h);

     PSW(0x00000080, GPIOITIP2); 
     PSR(0x00000080, NoMask, GPIOITIP2,itip2_1i);

     PSW(0x00000000, GPIOITIP2); 
     PSR(0x00000000, NoMask, GPIOITIP2,itip2_1j);

 
  /*2. Verifying connectivity of GPAFOUT                                           */
  /*------------------------------------                                           */

  /*-------------------------------------------------------------------------------*/ 
  /* Set the GPAFOUT Intra-chip input 

     NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the peripheral Alternate Functionality output signal
            from the peripheral itself.                                            */

     PSW(0xFF, GPIOITIP1); 

  /* Read the value on the GPAFOUT Intra-chip input */ 

     PSR(0xFF, NoMask, GPIOITIP1,itip1_1);
  /*-------------------------------------------------------------------------------*/
  /* Clear the GPAFOUT Intra-chip input 

     NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the peripheral Alternate Functionality output signal
            from the peripheral itself.                                            */

     PSW(0x00, GPIOITIP1); 

  /* Read the value on the GPAFOUT Intra-chip input                                */ 
     PSR(0x00, NoMask, GPIOITIP1,itip1_2);
  /*-------------------------------------------------------------------------------*/
  /* Set particular GPAFOUT input pins to one and read to verify that they can carry
     information independently : The Walking "1".                                  
 
     NOTE : When the tests are run in an integrated system, the user is
            expected to replace these PSW write with a suitable command to 
            set the peripheral Alternate Functionality output signal
            from the peripheral itself.                                            */
     
     PSW(0x00000000, GPIOITIP1); 
     PSR(0x00000000, NoMask, GPIOITIP1,itip1_1a);

     PSW(0x00000001, GPIOITIP1); 
     PSR(0x00000001, NoMask, GPIOITIP1,itip1_1b);

     PSW(0x00000002, GPIOITIP1); 
     PSR(0x00000002, NoMask, GPIOITIP1,itip1_1d);

     PSW(0x00000004, GPIOITIP1); 
     PSR(0x00000004, NoMask, GPIOITIP1,itip1_1d);

     PSW(0x00000008, GPIOITIP1); 
     PSR(0x00000008, NoMask, GPIOITIP1,itip1_1e);

     PSW(0x00000010, GPIOITIP1); 
     PSR(0x00000010, NoMask, GPIOITIP1,itip1_1f);

     PSW(0x00000020, GPIOITIP1); 
     PSR(0x00000020, NoMask, GPIOITIP1,itip1_1g);

     PSW(0x00000040, GPIOITIP1); 
     PSR(0x00000040, NoMask, GPIOITIP1,itip1_1h);

     PSW(0x00000080, GPIOITIP1); 
     PSR(0x00000080, NoMask, GPIOITIP1,itip1_1i);

     PSW(0x00000000, GPIOITIP1); 
     PSR(0x00000000, NoMask, GPIOITIP1,itip1_1j);


  /*3. Verifying connectivity of GPAFIN                                            */
  /*-----------------------------------                                            */

  /*-------------------------------------------------------------------------------*/ 
  /* Set the GPAFIN Intra-chip output                                              */

     PSW(0xFF, GPIOITOP3);

  /* Read the value on the GPAFIN Intra-chip output 

     NOTE : When the tests are run in an integrated system, the user is
            expected to replace this read with a suitable command to 
            read the peripheral Alternate Functionality input signal
            from the peripheral itself.                                            */

     PSR(0xFF, NoMask, GPIOITOP3,itip1_3);
  /*-------------------------------------------------------------------------------*/
  /* Clear the GPAFIN Intra-chip output                                            */

     PSW(0x00, GPIOITOP3); 

  /* Read the value on the GPAFOUT Intra-chip input  

     NOTE : When the tests are run in an integrated system, the user is
            expected to replace this read with a suitable command to 
            read the peripheral Alternate Functionality input signal
            from the peripheral itself.                                            */
     PSR(0x00, NoMask, GPIOITOP3,itop3_4);
  /*-------------------------------------------------------------------------------*/
  /* Set particular GPAFIN input pins to one and read to verify that they can carry
     information independently : The Walking "1".                                  

     NOTE : When the tests are run in an integrated system, the user is
            expected to replace these PSR read with a suitable command to 
            read the peripheral Alternate Functionality input signal
            from the peripheral itself.                                            */
     
     PSW(0x00000000, GPIOITOP3); 
     PSR(0x00000000, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000001, GPIOITOP3); 
     PSR(0x00000001, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000002, GPIOITOP3); 
     PSR(0x00000002, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000004, GPIOITOP3); 
     PSR(0x00000004, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000008, GPIOITOP3); 
     PSR(0x00000008, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000010, GPIOITOP3); 
     PSR(0x00000010, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000020, GPIOITOP3); 
     PSR(0x00000020, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000040, GPIOITOP3); 
     PSR(0x00000040, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000080, GPIOITOP3); 
     PSR(0x00000080, NoMask, GPIOITOP3,itop_3);

     PSW(0x00000000, GPIOITOP3); 
     PSR(0x00000000, NoMask, GPIOITOP3,itop_3);


   /*-------------------------------------------------------------------------------*/
   /*----------  Alternate Functionality Lines Integration Verified   --------------*/
   /*-------------------------------------------------------------------------------*/

   C("Testing  Intra Chip Output connections");
   /*
     C. Intra-chip outputs GPIOINTR and GPIOMIS[7:0]
     ===============================================
     Testing of Pad connections GPIOINTR and GPIOMIS[7:0] :

     The procedure is given below.
     - Write 1 to the ITEN bit in the Integration Control register. This selects
       the test path from the GPIOITOP1[7:0] to the internal GPIOMIS[7:0], the value
       driven externally to the GPIOMIS[7:0] can be read via reading to the GPIOMIS
       register.

     - GPIOINTR is a combined output resulting from the OR-logical operator on the
       particular bits of GPIOMIS:

            GPIOINTR = GPIOMIS[7] + GPIOMIS[6] + GPIOMIS[5] + GPIOMIS[4] +
                       GPIOMIS[3] + GPIOMIS[2] + GPIOMIS[1] + GPIOMIS[0] 

     - Write a 1 and then a 0 to the GPIOITOP1[7:0] and read from the
       GPIOMIS register. This will toggle both GPIOMIS[i] and GPIOINTR lines between
       the Gpio and the Interrupt Controller. 
     - The status value of GPIOINTR can be obtained from the APB interface via reading
       to the read-only 1-bit register GPIOITOP2.
 
     When integration tests are run in an integrated system '1' and '0'
     are written to the GPIOITOP1[7:0] register bits so as to toggle the 
     signal connections between the GPIO and the Interrupt controller. 
     Read from the Interrupt controller's internal registers to verify that the 
     value written into the GPIOITOP1[7:0] register bits is read out through the 
     Interrupt Controller.

  */ 
 
  PSW(0x00000001, GPIOITCR); 

  /* Set bits in GPIOITOP1 to assert directly GPIOMIS[i] bits  */
  PSW(0x00, GPIOITOP1);

  /* Read the value on the intra-chip outputs of the GPIO                              
     NOTE : When the tests are run in an integrated system, the user is
            expected to replace this read(and the following reads with
	    suitable commands to read the values on these lines through
	    the destination peripherals (Interrupt Controller)                */

  PSR(0x00, NoMask, GPIOMIS,itop1mis);
  PSR(0x00, NoMask, GPIOITOP2,itop_2);


  PSW(0x01, GPIOITOP1);

  PSR(0x01, NoMask, GPIOMIS,itop1mis);
  PSR(0x01, NoMask, GPIOITOP2,itop_2);



  PSW(0x02, GPIOITOP1);

  PSR(0x02, NoMask, GPIOMIS,itop1mis);
  PSR(0x01, NoMask, GPIOITOP2,itop_2);


  PSW(0x04, GPIOITOP1);

  PSR(0x04, NoMask, GPIOMIS,itop1mis);
  PSR(0x01, NoMask, GPIOITOP2,itop_2);


  PSW(0x08, GPIOITOP1);

  PSR(0x08, NoMask, GPIOMIS,itop1mis);
  PSR(0x01, NoMask, GPIOITOP2,itop_2);


  PSW(0x10, GPIOITOP1);

  PSR(0x10, NoMask, GPIOMIS,itop1mis);
  PSR(0x01, NoMask, GPIOITOP2,itop_2);


  PSW(0x20, GPIOITOP1);

  PSR(0x20, NoMask, GPIOMIS,itop1mis);
  PSR(0x01, NoMask, GPIOITOP2,itop_2);


  PSW(0x40, GPIOITOP1);

  PSR(0x40, NoMask, GPIOMIS,itop1mis);
  PSR(0x01, NoMask, GPIOITOP2,itop_2);


  PSW(0x80, GPIOITOP1);

  PSR(0x80, NoMask, GPIOMIS,itop1mis);
  PSR(0x01, NoMask, GPIOITOP2,itop_2);

/* END OF C. Intra-chip outputs GPIOINTR and GPIOMIS[7:0] */

  PSW(0x0000,GPIOITCR);
}
