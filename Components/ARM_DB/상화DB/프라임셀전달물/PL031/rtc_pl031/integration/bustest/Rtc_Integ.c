/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Rtc_Integ.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL031-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Rtc.h, Rtc.c, Rtc_Integ.c
--
--   Usage: make <testname> e.g. make Rtc_Integ
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Rtc_Integ
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the RTC, please refer to PL031 AMBA    ***/
/*** RTC Block Specification                                        ***/
/**********************************************************************/

void IntegrationTest(void)
{
  C("Integration Test");

    /* IntegrationTest:
     ================
     When the RTC is used in an AMBA system, it must be ensured that
     all of its pins are correctly connected. Integration vectors
     allow the user to verify that the RTC has been wired into the
     system correctly.
  */

  C("Integration Tests for the UART");

  /* Enable Integration testing of the RTC by setting the ITEN
     bit in the RTCITCR register */
  PSW(0x00000001, RTCITCR,rtcitcr);

  C("Testing Intra Chip Output connections");

  /* Set the RTCINTR bit */
  PSW(0x00000001, RTCITOP,rtcitop);

  /* Read the value on the intra-chip outputs of the RTC */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this read(and the following reads with
            suitable commands to read the values on these lines through
            the destination peripherals Interrupt Controller) */

  PSR(0x00000001, 0x00000001, RTCITOP,rtcintr);

  /* Clear the RTCINTR bit */
  PSW(0x00000000, RTCITOP);

  PSR(0x00000000, 0x00000000, RTCITOP,rtcintr);

  /* End of tests - Disable integration testing of the Rtc */

  PSW(0x00000000,RTCITCR);

}



