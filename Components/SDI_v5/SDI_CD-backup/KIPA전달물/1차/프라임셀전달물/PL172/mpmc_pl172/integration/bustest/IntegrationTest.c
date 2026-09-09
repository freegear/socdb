/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : IntegrationTest.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           Test to make sure that all the intra chips signals are correctly
--           connected.
--
-- --=======================================================================--*/
void IntegrationTest()
{
  /* Summary : IntegrationTest
     =========================
     When the MPMC is used in an AMBA system, it must be ensured that
     all of its intra chips signals are correctly connected. Integration 
     vectors allow the user to verify that the MPMC has been wired into the
     system correctly.
  */
  /* Testing of Intra-Chip input  :
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register. This selects
       the test path from the MPMCITIP[0] register bit to the internal
       MPMCSREFREQ signal.
     - Write a 1 and then a 0 to the MPMCITIP[0] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the MPMCITIP[1] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the MPMCITIP[2] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the MPMCITIP[3] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the MPMCITIP[4] register bit and read
       the same register bit to ensure that the value written is read
       out.

      - Write a 1 and then a 0 to the MPMCITIP[5] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the MPMCITIP[6] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the MPMCITIP[7] register bit and read
       the same register bit to ensure that the value written is read
       out.
    
     - Write a 1 and then a 0 to the MPMCITIP[8] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the MPMCITIP[9] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the MPMCITOP[0] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Similarly toggle MPMCITOP[1] register bit and read
       the same register bit to ensure that the value written is read
       out.

     When integration tests are run in an integrated system '1' and '0'
     are actually written into internal registers and the connection is 
     verified by reading out from MPMCITIP[0], MPMCITOP[0] register bit.
  */
  C("Integration Tests for the MPMC");

  C("Testing Intra Chip Input connection");

  /* Enable Integration testing of the MPMC by setting the ITEN
     bit in the MPMCITCR register 
  */

  /** NOTE: When the tests are run in an integrated system, the user **/
  /**       is expected to comment out the following HSW command.    **/
  /**       This is to ensure that the path from the intra-chip      **/
  /**       input of the MPMC to the MPMCITIP register is selected.  **/
  HSA(MPMCITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000001);
  /** Set the MPMCSREFREQ input                                      **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the MPMCSREFREQ input of the MPMC.       **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000001); 
  /* Read the value on MPMCSREFREQ input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,);
  HSR(,0x00000001, ,0x00000001, ,Read_1); 

  /** Reset the MPMCSREFREQ input                                    **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a           **/
  /**        suitable command to clear the MPMCSREFREQ input of the  **/
  /**        MPMC.                                                   **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000000); 
  /* Read the value on MPMCSREFREQ input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,);
  HSR(,0x00000000, ,0x00000001, ,Read_2);

  /** Set the MPMCBIGENDIAN input                                    **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the MPMCBIGENDIAN input of the MPMC.     **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000002);
  /* Read the value on MPMCBIGENDIAN input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000002, ,0x00000002, ,Read_3);

  /** Reset the MPMCBIGENDIAN input                                  **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a           **/
  /**        suitable command to clear the MPMCBIGENDIAN input of    **/
  /**        the MPMC.                                               **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on MPMCBIGENDIAN input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000002, ,Read_4);

  /** Set the MPMCSTCS1MW[0] input                                   **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a           **/
  /**        suitable command to set the MPMCSTCS1MW[0] input of the **/
  /**        MPMC.                                                   **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000004);
  /* Read the value on MPMCSTCS1MW[0] input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000004, ,0x00000004, ,Read_5);

  /** Reset the MPMCSTCS1MW[0] input                                 **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a           **/
  /**        suitable command to clear the MPMCSTCS1MW[0] input of   **/
  /**        the MPMC.                                               **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on MPMCSTCS1MW[0] input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000004, ,Read_6);

  /** Set the MPMCSTCS1MW[1] input                                   **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the MPMCSTCS1MW[1] input of the MPMC.    **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000008);
  /* Read the value on MPMCSTCS1MW[1] input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000008, ,0x00000008, ,Read_7);

  /** Reset the MPMCSTCS1MW[1] input                                 **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to clear the MPMCSTCS1MW[1] input of the MPMC.  **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on MPMCSTCS1MW[1] input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000008, ,Read_8);

  /** Set the nMPMCSTCSPOL0 input                                    **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the nMPMCSTCSPOL0 input of the MPMC.     **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000010);
  /* Read the value on nMPMCSTCSPOL0 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000010, ,0x00000010, ,Read_9);

  /** Reset the nMPMCSTCSPOL0 input                                  **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to clear the nMPMCSTCSPOL0 input of the MPMC.   **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on nMPMCSTCSPOL0 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000010, ,Read_10);

  /** Set the nMPMCSTCSPOL1 input                                    **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the nMPMCSTCSPOL1 input of the MPMC.     **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000020);
  /* Read the value on nMPMCSTCSPOL1 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000020, ,0x00000020, ,Read_11);

  /** Reset the nMPMCSTCSPOL1 input                                  **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to clear the nMPMCSTCSPOL1 input of the MPMC.   **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on nMPMCSTCSPOL1 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000020, ,Read_12);

  /** Set the nMPMCSTCSPOL2 input                                    **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the nMPMCSTCSPOL2 input of the MPMC.     **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000040);
  /* Read the value on nMPMCSTCSPOL2 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000040, ,0x00000040, ,Read_13);

  /** Reset the nMPMCSTCSPOL2 input                                  **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to clear the nMPMCSTCSPOL2 input of the MPMC.   **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on nMPMCSTCSPOL2 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000040, ,Read_14);

  /** Set the nMPMCSTCSPOL3 input                                    **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the nMPMCSTCSPOL3 input of the MPMC.     **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000080);
  /* Read the value on nMPMCSTCSPOL3 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000080, ,0x00000080, ,Read_15);

  /** Reset the nMPMCSTCSPOL3 input                                  **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to clear the nMPMCSTCSPOL3 input of the MPMC.   **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on nMPMCSTCSPOL3 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000080, ,Read_16);

  /** Set the MPMCSTCS1PB input                                      **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the MPMCSTCS1PB input of the MPMC.       **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000100);
  /* Read the value on nMPMCSTCSPOL3 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000100, ,0x00000100, ,Read_17);

  /** Reset the MPMCSTCS1PB input                                    **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to clear the MPMCSTCS1PB input of the MPMC.     **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on MPMCSTCS1PB input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000100, ,Read_18);

  /** Set the MPMCREL1CONFIG input                                   **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to set the MPMCREL1CONFIG input of the MPMC.    **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000200);
  /* Read the value on nMPMCSTCSPOL3 input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000200, ,0x00000200, ,Read_19);

  /** Reset the MPMCREL1CONFIG input                                 **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this write with a suitable  **/
  /**        command to clear the MPMCREL1CONFIG input of the MPMC.  **/
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on MPMCREL1CONFIG input */
  HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000200, ,Read_20);

  /** Set the MPMCSREFACK through MPMCITOP register                  **/
  HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000001); 
  /* Read the value on MPMCSREFACK */
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this read with a suitable  **/
  /**        command to read the values on this line.                **/
  HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000001, ,0x00000001, ,Read_21);

  /** Reset the MPMCSREFACK output                                   **/
  HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000); 
  /** Read the value on MPMCSREFACK output                           **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this read with a suitable  **/
  /**        command to read the values on this line.                **/
  HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000001, ,Read_22);

  /** Set the nRPVHHOUT output                                       **/
  HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000002);
  /** Read the value on nRPVHHOUT                                    **/
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this read with a suitable  **/
  /**        command to read the values on this line.                **/
  HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000002, ,0x00000002, ,Read_23);

  /* Reset the nRPVHHOUT through MPMCITOP register */
  HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on nRPVHHOUT output */
  /** NOTE : When the tests are run in an integrated system, the     **/
  /**        user is expected to replace this read with a suitable  **/
  /**        command to read the values on this line.                **/
  HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000002, ,Read_24);

  /* Exit from test mode */
  HSA(MPMCITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000000);
}
/*-- --================================ End ================================--*/
