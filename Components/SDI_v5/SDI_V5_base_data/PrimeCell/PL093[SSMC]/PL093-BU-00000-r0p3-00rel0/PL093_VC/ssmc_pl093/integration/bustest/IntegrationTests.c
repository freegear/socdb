/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : IntegrationTests.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           Describe block function here
--
-- --=======================================================================--*/
void IntegrationTests()
{
  /* Summary : IntegrationTest
     =========================
     When the SSMC is used in an AMBA system, it must be ensured that
     all of its intra chips signals are correctly connected. Integration 
     vectors allow the user to verify that the SSMC has been wired into the
     system correctly.
  */

  /* Testing of Intra-Chip input (SSMCSREFREQ) :
     The procedure is given below.

     - Write a 1 to the T bit in the Control register. This selects
       the test path from the SSMCITIP[0] register bit to the internal
       SSMCSREFREQ signal.

     - Write a 1 and then a 0 to the SSMCITIP[0] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the SSMCITIP[1] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the SSMCITIP[2] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the SSMCITIP[3] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the SSMCITIP[4] register bit and read
       the same register bit to ensure that the value written is read
       out.

      - Write a 1 and then a 0 to the SSMCITIP[5] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the SSMCITIP[6] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the SSMCITIP[7] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Write a 1 and then a 0 to the SSMCITOP[0] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Similarly toggle SSMCITOP[1] register bit and read
       the same register bit to ensure that the value written is read
       out.

     - Try different combinations of nRPVHHOUT and SREFACK by writing in to 
       SSMCITIOP register and read accordingly from SSMCITIP register.

     When integration tests are run in an integrated system '1' and '0'
     are actually written into internal registers and the connection is 
     verified by reading out from SSMCITIP[0], SSMCITOP[0] register bit.
  */

  C("INTEGRATION TESTS FOR THE SSMC");

  C("TESTING INTRA CHIP INPUT CONNECTION");

  /** Enable Integration testing of the SSMC by setting the T
     bit in the SSMCITCR register **/

  HSA(SSMCITCR, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000001);

  C("WRITE READ TEST ON THE SMBIGENDIAN BIT");
  /** Set the SMBIGENDIAN input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SSMCSREFREQ input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000001); 
  /** Read the value on SMBIGENDIAN input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000001, ,0x00000001); 

  /** Reset the SMBIGENDIAN input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMBIGENDIAN input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000); 
  /** Read the value on SMBIGENDIAN input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000001);

  C("WRITE READ TEST ON THE SMMEMCLKRATIO[0] BIT");
  /** Set the SMMEMCLKRATIO[0] input through SSMCITIP register **/
  /** NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMMEMCLKRATIO[0] input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000002);
  /** Read the value on SMMEMCLKRATIO[0] input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000002, ,0x00000002);

  /** Reset the SMMEMCLKRATIO[0] input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMMEMCLKRATIO[0] input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /** Read the value on SMMEMCLKRATIO[0] input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000002);

  C("WRITE READ TEST ON THE SMMEMCLKRATIO[1] BIT");
  /** Set the SMMEMCLKRATIO[1] input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMMEMCLKRATIO[1] input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000004);
  /** Read the value on SMMEMCLKRATIO[1] input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000004, ,0x00000004);

  /** Reset the SMMEMCLKRATIO[1] input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMMEMCLKRATIO[1] input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /** Read the value on SMMEMCLKRATIO[1] input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000004);


  C("WRITE READ TEST ON THE SMEXTBUSMUX BIT");
  /** Set the SMEXTBUSMUX input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMEXTBUSMUX input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000008);
  /** Read the value on SMEXTBUSMUX input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000008, ,0x00000008);

  /** Reset the SMEXTBUSMUX input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMEXTBUSMUX input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /** Read the value on SMEXTBUSMUX input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000008);

  C("WRITE READ TEST ON THE SMBUSGNTEBI BIT");
  /** Set the SMBUSGNTEBI input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMBUSGNTEBI input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000010);
  /** Read the value on SMBUSGNTEBI input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000010, ,0x00000010);

  /** Reset the SMBUSGNTEBI input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMBUSGNTEBI input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /** Read the value on SMBUSGNTEBI input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000010);


  C("WRITE READ TEST ON THE SMTICBUSGNTEBI BIT");
  /** Set the SMTICBUSGNTEBI input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMTICBUSGNTEBI input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000020);
  /** Read the value on SMTICBUSGNTEBI input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000020, ,0x00000020);

  /** Reset the SMTICBUSGNTEBI input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMTICBUSGNTEBI input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /** Read the value on SMTICBUSGNTEBI input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000020);

  C("WRITE READ TEST ON THE SMBUSBACKOFFEBI BIT");
  /** Set the SMBUSBACKOFFEBI input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMBUSBACKOFFEBI input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000040);
  /** Read the value on SMBUSBACKOFFEBI input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000040, ,0x00000040);

  /** Reset the SMBUSBACKOFFEBI input through SSMCITIP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMBUSBACKOFFEBI input of the SSMC
            to the SSMCITIP register is selected.
  */
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /** Read the value on SMBUSBACKOFFEBI input **/
  HSA(SSMCITIP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000040);

  
  C("WRITE READ TEST ON THE SMBUSREQEBI BIT");
  /** Set the SMBUSREQEBI through SSMCITOP register **/
  /*  NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMBUSREQEBI output of the SSMC
            to the SSMCITOP register is selected.
  */
  HSA(SSMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000001); 
  /** Read the value on SMBUSREQEBI **/
  HSA(SSMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000001, ,0x00000001);

  /** Reset the SMBUSREQEBI through SSMCITOP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMBUSREQEBI input of the SSMC
            to the SSMCITOP register is selected.
  */
  HSA(SSMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000); 
  /** Read the value on SMBUSREQEBI input **/
  HSA(SSMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000001);

  C("WRITE READ TEST ON THE SMTICBUSREQEBI BIT");
  /** Set the SMTICBUSREQEBI through SSMCITOP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMTICBUSREQEBI output of the SSMC
            to the SSMCITOP register is selected.
  */
  HSA(SSMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000002);
  /** Read the value on SMTICBUSREQEBI **/
  HSA(SSMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000002, ,0x00000002);

  /** Reset the SMTICBUSREQEBI through SSMCITOP register **/
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following HSW command. This is
            to ensure that the path from the SMTICBUSREQEBI input of the SSMC
            to the SSMCITOP register is selected.
  */
  HSA(SSMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /** Read the value on SMTICBUSREQEBI input **/
  HSA(SSMCITOP, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000002);

}
/*-- --================================ End ================================--*/
