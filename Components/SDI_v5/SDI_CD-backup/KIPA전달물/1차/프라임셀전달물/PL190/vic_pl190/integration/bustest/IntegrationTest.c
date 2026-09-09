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
-- File Name              : IntegrationTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           Routines to perform Integration Tests on the Intra-Chip 
--           signals of the VIC. 
--
-- --=================================================================*/

/**********************************************************************/
/************************* Integration Test ***************************/
/**********************************************************************/
 
void IntegrationTest()
{
  /*
    Summary: Integration Test
    =========================
    When the VIC is used in an AMBA system, it must be ensured that all
    of its pins are correctly connected. Integration vectors allow the
    user to verify that the VIC has been wired into the system
    correctly.

    Testing of Intra-Chip inputs (nVICFIQIN, nVICIRQIN, VICVECTADDRIN
    and VICINTSOURCE) :

    Test Procedure in Standalone mode
    ---------------------------------
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

    - For the VICINTSOURCE inputs
      These sources typically are other Interrupt capable peripherals in
      the system. The integrator will have to suitably program these
      peripherals and read back the expected values from the VICITIP0-1
      registers. 
  */

  long interrupt;
  int i;

  C("Testing Intra Chip Input connections");

  /** Enable Integration testing of the VIC by setting the ITEN bit  **/
  /** in the VICITCR register.                                       **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to comment out the following HSW command.    **/
  /**       This is to ensure that the path from the intra-chip      **/
  /**       input of the VIC to the VICITIP register is selected.    **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000001);

  /** Set the nVICFIQIN and nVICIRQIN inputs.                        **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this write with a suitable        **/
  /**       command to set the nVICFIQ and nVICIRQ output signals    **/
  /**       from the previous VIC in the Daisy Chain.                **/
  HSA(VICITIP1, NSEQ, INCR,, WRD,, 0x1,,);
  HSW(, 0x000000C0);

  /** Read the value on the nVICFIQIN and nVICIRQIN inputs. **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x000000C0, , 0x000000C0);

  /** Clear the nVICFIQIN and nVICIRQIN inputs.                      **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this write with a suitable        **/
  /**       command to clear the nVICFIQ and nVICIRQ output signals  **/
  /**       from the previous VIC in the Daisy Chain.                **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000000);

  /** Read the value on the nVICFIQIN and nVICIRQIN inputs. **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0x000000C0);

  /** Set the VICVECTADDRIN input.                                   **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this write with a suitable        **/
  /**        command to set the VICVECTADDROUT output signal from    **/
  /**        the previous VIC in the Daisy Chain.                    **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);

  /** Read the value on the VICVECTADDRIN input. **/
  HSA(VICITIP2, NSEQ, INCR,, WRD,, 0x1,,);
  HSR( , 0xFFFFFFFF, , 0xFFFFFFFF);

  /** Clear the VICVECTADDRIN input.                                 **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this write with a suitable        **/
  /**       command to clear the VICVECTADDROUT output signal from   **/
  /**       the previous VIC in the Daisy Chain.                     **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000000);

  /** Read the value on the VICVECTADDRIN input. **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, ,);
  HSR( , 0x00000000, , 0xFFFFFFFF);

  /** Testing Intra Chip VICINTSOURCE inputs. **/
  
  /** Set the VICINTSOURCE input.                                    **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this write with a suitable        **/
  /**       command to set the Interrupt Source signals from the     **/
  /**       Interrupt raising Peripherals.                           **/
  HSA(VICSoftInt, NSEQ, INCR,, WRD,, 0x1,,);
  HSW( , 0xFFFFFFFF);

  /** Read the value in the VICRawInterrupt register. **/
  HSA(VICRawIntr, NSEQ, INCR,, WRD,, 0x1,,);
  HSR( , 0xFFFFFFFF, , 0xFFFFFFFF);

  /** Clear the VICINTSOURCE input.                                  **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this write with a suitable        **/
  /**       command to clear the Interrupt Source signals from the   **/
  /**       Interrupt raising Peripherals.                           **/
  HSA(VICSoftIntClear, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);

  /** Read the value in the VICRawInterrupt register. **/
  HSA(VICRawIntr, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0xFFFFFFFF);

  C("Testing Intra Chip Output connections");

  /** Testing Intra Chip outputs nVICIRQ and nVICFIQ **/
  /** Set the nVICIRQ and nVICFIQ bits to '1'.       **/

  /** Enabling all Interrupts. **/
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);

  /** Configure SoftInt0 as FIQ and SoftInt1 as IRQ. **/
  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFD);

  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000003);

  /** Read the value on nVICFIQ and the nVICIRQ outputs.             **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this read with suitable commands  **/
  /**       to read the values on these lines through the            **/
  /**       destination peripherals (VICITIP1 register of the next   **/
  /**       VIC in the Daisy Chain).                                 **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x000000C0, , 0x000000C0);

  /** Testing Intra Chip outputs nVICIRQ and nVICFIQ **/
  /** Set the nVICIRQ and nVICFIQ bits to '0'.       **/

  /** Disabling all Interrupts. **/
  HSA(VICIntEnClear, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);

  /** Read the value on nVICFIQ and the nVICIRQ outputs.             **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this read with suitable commands  **/
  /**       to read the values on these lines through the            **/
  /**       destination peripherals (VICITIP1 register of the next   **/
  /**       VIC in the Daisy Chain).                                 **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0x000000C0);

  /** Testing Intra Chip output VICVECTADDROUT **/
  /** Set all VICVECTADDROUT bits to '0'.      **/
  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x00000000);

  /** Read the value on the intra-chip outputs of the VIC.           **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this read with suitable commands  **/
  /**       to read the values on these lines through the            **/
  /**       destination peripherals (VICITIP2 register of the next   **/
  /**       VIC in the Daisy Chain).                                 **/
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0x00000000, , 0xFFFFFFFF);

  /** Set all VICVECTADDROUT bits to '1'. **/
  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0xFFFFFFFF);

  /** Read the value on the intra-chip outputs of the VIC.           **/
  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to replace this read with suitable commands  **/
  /**       to read the values on these lines through the            **/
  /**       destination peripherals (VICITIP2 register of the next   **/
  /**       VIC in the Daisy Chain).                                 **/
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , 0xFFFFFFFF, , 0xFFFFFFFF);
}

/******************************** End *********************************/
