/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : IntegrationTest.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Routines to perform Integration Tests on the Intra-Chip 
--           signals of the VIC. 
--
-- --=======================================================================--*/

/******************************************************************************/
/**************************** Integration Test ********************************/
/******************************************************************************/
 
void IntegrationTest()
{
  /*
    Summary: Integration Test
    =========================
    When the VIC is used in an AMBA system, it must be ensured that all
    of its pins are correctly connected. Integration vectors allow the
    user to verify that the VIC has been wired into the system
    correctly.

    Testing of Intra-Chip inputs (VICIRQACK, nVICFIQIN, nVICIRQIN,
    VICVECTADDRIN, VICVECTADDRV, VICIRQ, VICFIQ, VICVECTADDROUT, VICIRQACKOUT
    and VICINTSOURCE) :

    Test Procedure in Stand alone mode
    ----------------------------------
    - Write a 1 to the ITEN bit in the VICITCR register. This selects
      the test path from the VICITIP registers to the internal VIC
      signals.
    - Write 1's and then 0's to the VICITIP registers and read the same
      register to ensure that the value written is read out.

    Test Procedure post Integration 
    -------------------------------
    When integration tests are run in an integrated system '1's and '0's
    are made to appear on these inputs by programming their sources
    appropriately. 

    - For the nVICFIQIN, nVICIRQIN and VICVECTADDRIN inputs
      In a system where multiple VICs are connected in a Daisy Chain,
      these signals are controlled by writing into the internal
      registers of the first VIC in the Daisy Chain and the connection
      is verified by reading out from the VICITIP0-1 registers. In case
      the source of these signals is not another VIC, the integrator
      will have to suitably program the relevant controller.

  */

  long interrupt;
  int i;

  C("Testing Intra Chip Input connections");

  /** Enable Integration testing of the VIC by setting the ITEN bit          **/
  /** in the VICITCR register.                                               **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to comment out the following HSW command.            **/
  /**       This is to ensure that the path from the intra-chip              **/
  /**       input of the VIC to the VICITIP register is selected.            **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000001);

  /** Set the nVICFIQIN and nVICIRQIN inputs.                                **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this write with a suitable                **/
  /**       command to set the nVICFIQ and nVICIRQ output signals            **/
  /**       from the previous VIC in the Daisy Chain.                        **/
  HSA(VICITIP1, NSEQ, INCR,, WRD,, 0x1,,);
  HSW(, 0x000000C0);

  WaitLoop(0x2);
  /** Read the value on the nVICFIQIN and nVICIRQIN inputs.                  **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x000000C0, , 0x000000C0);

  /** Clear the nVICFIQIN and nVICIRQIN inputs.                              **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this write with a suitable                **/
  /**       command to clear the nVICFIQ and nVICIRQ output signals          **/
  /**       from the previous VIC in the Daisy Chain.                        **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000000);

  WaitLoop(0x2);
  /** Read the value on the nVICFIQIN and nVICIRQIN inputs.                  **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0x000000C0);

  /** Enable Integration testing of the VIC by setting the ITEN bit          **/
  /** in the VICITCR register.                                               **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to comment out the following HSW command.            **/
  /**       This is to ensure that the path from the intra-chip              **/
  /**       input of the VIC to the VICITIP register is selected.            **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000001);

  /** Set the VICIRQACK inputs                                               **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this write with a suitable                **/
  /**       command.                                                         **/
  HSA(VICITIP1, NSEQ, INCR,, WRD,, 0x1,,);
  HSW(, 0x00000100);

  WaitLoop(0x2);
  /** Read the value on the VICIRQACK inputs.                                **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000100, , 0x00000100);

  /** Clear the VICIRQACK inputs.                                            **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this write with a suitable                **/
  /**       command.                                                         **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000000);

  WaitLoop(0x2);
  /** Read the value on the VICIRQACK inputs.                                **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0x00000100);


  /** Set the VICVECTADDRIN input.                                           **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this write with a suitable                **/
  /**        command to set the VICVECTADDROUT output signal from            **/
  /**        the previous VIC in the Daisy Chain.                            **/

  /* IRQINREG check */

  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW(, 0x080);

  /** Read the VICIRQINREG                                                   **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR(, 0x200, , 0x200);

  /* FIQINREG check */
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW(, 0x040);

  /** Read the VICFIQINREG                                                   **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR(, 0x400, , 0x400);

  /* IRQINREG check */

  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW(, 0x000);

  /** Read the VICIRQINREG                                                   **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR(, 0x0000, , 0x200);

  /* FIQINREG check */
  /** Check the connectivity of the VICFIQINREG                              **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW(, 0x000);

  /** Read the VICFIQINREG                                                   **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR(, 0x000, , 0x400);
 

  /** Clear the VICVECTADDRIN input.                                         **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this write with a suitable                **/
  /**       command to clear the VICVECTADDROUT output signal from           **/
  /**       the previous VIC in the Daisy Chain.                             **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000000);

  /** Read the value on the VICVECTADDRIN input.                             **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, ,);
  HSR( , 0x00000000, , 0xFFFFFFFF);

  /** Testing Intra Chip VICINTSOURCE inputs.                                **/
  
  /** Set the Interrupt sampled status(ISS)                                  **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000003);

  /** Enable all the interrupt sources                                       **/
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);
  
  WaitLoop(0x3);
  /** Set the VICINTSOURCE input.                                            **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this write with a suitable                **/
  /**       command to set the Interrupt Source signals from the             **/
  /**       Interrupt raising Peripherals.                                   **/
  HSA(VICITOP2, NSEQ, INCR,, WRD,, 0x1,,);
  HSW( , 0x00000000);

  /** Clear the contents of VICIntSStatus register                           **/
  HSA(VICIntSStatusClr, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);
 
  WaitLoop(0x3);

  /** Read the value of the VICIntSStatus register                           **/
  HSA(VICIntSStatus, NSEQ, INCR,, WRD,, 0x1,,);
  HSR( , 0xFFFFFFFF, , 0xFFFFFFFF);

  /** Deassert the upper 16 interrupts                                       **/
  HSA(VICITOP2, NSEQ, INCR,, WRD,, 0x1,,);
  HSW( , 0xFFFF0000);
 
  /** Read the value of the VICIntSStatus register                           **/
  HSA(VICIntSStatus, NSEQ, INCR,, WRD,, 0x1,,);
  HSR( , 0xFFFFFFFF, , 0xFFFFFFFF);

  /** Clear the VICIntSStatus register                                       **/
  HSA(VICIntSStatusClr, NSEQ, INCR,, WRD,, 0x1,,);
  HSW( , 0xFFFF0000);

  /** Read the value of the VICIntSStatus register                           **/
  HSA(VICIntSStatus, NSEQ, INCR,, WRD,, 0x1,,);
  HSR( , 0x0000FFFF, , 0xFFFFFFFF);

  HSA(VICITOP2, NSEQ, INCR,, WRD,, 0x1,,);
  HSW( , 0x00000000);

  /** Clear the contents of VICIntSStatus register                           **/
  HSA(VICIntSStatusClr, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);
 
  WaitLoop(0x3);

  /** Read the value of the VICIntSStatus register                           **/
  HSA(VICIntSStatus, NSEQ, INCR,, WRD,, 0x1,,);
  HSR( , 0xFFFFFFFF, , 0xFFFFFFFF);

  /** Deassert the lower 16 interrupts                                       **/
  HSA(VICITOP2, NSEQ, INCR,, WRD,, 0x1,,);
  HSW( , 0x0000FFFF);
 
  /** Read the value of the VICIntSStatus register                           **/
  HSA(VICIntSStatus, NSEQ, INCR,, WRD,, 0x1,,);
  HSR( , 0xFFFFFFFF, , 0xFFFFFFFF);

  /** Clear the VICIntSStatus register                                       **/
  HSA(VICIntSStatusClr, NSEQ, INCR,, WRD,, 0x1,,);
  HSW( , 0x0000FFFF);
  
 /** Read the value of the VICIntSStatus register                           **/
  HSA(VICIntSStatus, NSEQ, INCR,, WRD,, 0x1,,);
  HSR( , 0xFFFF0000, , 0xFFFFFFFF);

  C("Testing Intra Chip Output connections");

  /** Testing Intra Chip outputs VICIRQ and VICFIQ                           **/
  /** Set the VICIRQ and VICFIQ bits to '1'.                                 **/

  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x000000C0);

  WaitLoop(0x2);

  /** Read the value on VICFIQ and the VICIRQ outputs.                       **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this read with suitable commands          **/
  /**       to read the values on these lines through the                    **/
  /**       destination peripherals (VICITIP1 register of the next           **/
  /**       VIC in the Daisy Chain).                                         **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x000000C0, , 0x000000C0);

  /** Testing Intra Chip outputs nVICIRQ and nVICFIQ                         **/
  /** Set the nVICIRQ and nVICFIQ bits to '0'.                               **/

  /** Disabling all Interrupts.         **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000000);

  WaitLoop(0x2);

  /** Read the value on nVICFIQ and the nVICIRQ outputs.                     **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this read with suitable commands          **/
  /**       to read the values on these lines through the                    **/
  /**       destination peripherals (VICITIP1 register of the next           **/
  /**       VIC in the Daisy Chain).                                         **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0x000000C0);

  /** Testing the VICVECTADDRV output                                        **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x100);
  WaitLoop(0x2);
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000100, , 0x00000100);

  /** Reset the VICVECTADDRV                                                 **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x000);
  WaitLoop(0x2);
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0x00000000);

  /** Testing Intra Chip output VICVECTADDROUT                               **/

  /** Read the value on the intra-chip outputs of the VIC.                   **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this read with suitable commands          **/
  /**       to read the values on these lines through the                    **/
  /**       destination peripherals (VICITIP2 register of the next           **/
  /**       VIC in the Daisy Chain).                                         **/
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000000);

  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0xFFFFFFFF);

  /** Set all VICVECTADDROUT bits to '1'.                                    **/
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);

  /** Read the value on the intra-chip outputs of the VIC.                   **/
  /** NOTE: When the tests are run in an integrated system, the user         **/
  /**       is expected to replace this read with suitable commands          **/
  /**       to read the values on these lines through the                    **/
  /**       destination peripherals (VICITIP2 register of the next           **/
  /**       VIC in the Daisy Chain).                                         **/
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0xFFFFFFFF, , 0xFFFFFFFF);
}

/*********************************** End **************************************/
