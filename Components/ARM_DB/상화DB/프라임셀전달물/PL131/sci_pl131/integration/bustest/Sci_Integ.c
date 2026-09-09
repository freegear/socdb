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
-- File Name              : Sci_Integ.c.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL131-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Sci.c, Sci.h, Sci_Integ.c
--
--   Usage: make <testname> e.g. make Sci_Integ
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Sci_Integ
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/
 
/**********************************************************************/
/*** For more information on the SCI, please refer to the SCI PL022 ***/
/*** Technical Reference Manual                                     ***/
/**********************************************************************/


void ResetRead(void)
{
C("Reset value tests");

PSR(0x00000000, 0x0000FFFF, SCIDATA,       scidata);
PSR(0x00000000, 0x0000FFFF, SCICR0,        scicr0);
PSR(0x00000000, 0x0000FFFF, SCICR1,        scicr1);
PSR(0x00000000, 0x0000FFFF, SCICR2,        scicr2);
PSR(0x00000000, 0x0000FFFF, SCICLKICC,     sciclkicc);
PSR(0x00000000, 0x0000FFFF, SCIVALUE,      scivalue);
PSR(0x00000000, 0x0000FFFF, SCIBAUD,       scibaud);
PSR(0x00000000, 0x0000FFFF, SCITIDE,       scitide);
PSR(0x00000000, 0x0000FFFF, SCIDMACR,      scidmacr);
PSR(0x00000000, 0x0000FFFF, SCISTABLE,     scistable);
PSR(0x00000000, 0x0000FFFF, SCIATIME,      sciatime);
PSR(0x00000000, 0x0000FFFF, SCIDTIME,      scidtime);
PSR(0x00000000, 0x0000FFFF, SCIATRSTIME,   sciatrstime);
PSR(0x00000000, 0x0000FFFF, SCIATRDTIME,   sciatrdtime);
PSR(0x00000000, 0x0000FFFF, SCISTOPTIME,   scistoptime);
PSR(0x00000000, 0x0000FFFF, SCISTARTTIME,  scistarttime);
PSR(0x00000000, 0x0000FFFF, SCIRETRY,      sciretry);
PSR(0x00000000, 0x0000FFFF, SCICHTIMELS,   scichtimels);
PSR(0x00000000, 0x0000FFFF, SCICHTIMEMS,   scichtimems);
PSR(0x00000000, 0x0000FFFF, SCIBLKTIMELS,  sciblktimels);
PSR(0x00000000, 0x0000FFFF, SCIBLKTIMEMS,  sciblktimems);
PSR(0x00000000, 0x0000FFFF, SCICHGUARD,    scichguard);
PSR(0x00000000, 0x0000FFFF, SCIBLKGUARD,   sciblkguard);
PSR(0x00000000, 0x0000FFFF, SCIRXTIME,     scirxtime);
PSR(0x0000000A, 0x0000FFFF, SCIFIFOSTATUS, scififostatus);
PSR(0x00000000, 0x0000FFFF, SCITXCOUNT,    scitxcount);
PSR(0x00000000, 0x0000FFFF, SCIRXCOUNT,    scirxcount);
PSR(0x00000000, 0x0000FFFF, SCIIMSC,       sciimsc);
PSR(0x0000400A, 0x0000FFFF, SCIRIS,        sciris);
PSR(0x00000000, 0x0000FFFF, SCIMIS,        scimis);
PSR(0x00000000, 0x0000FFFF, SCIICR,        sciicr);
PSR(0x00000000, 0x0000FFFF, SCISYNCACT,    scisyncact);
PSR(0x00000000, 0x0000FFFF, SCISYNCTX,     scisynctx);
PSR(0x00000000, 0x0000FFFF, SCISYNCRX,     scisyncrx);

PSR(0x00000031, 0x0000FFFF, SCIPeriphID0,  sciperiphid0);
PSR(0x00000011, 0x0000FFFF, SCIPeriphID1,  sciperiphid1);
PSR(0x00000004, 0x0000FFFF, SCIPeriphID2,  sciperiphid2);
PSR(0x00000000, 0x0000FFFF, SCIPeriphID3,  sciperiphid3);
PSR(0x0000000D, 0x0000FFFF, SCIPCellID0,   scipcellid0);
PSR(0x000000F0, 0x0000FFFF, SCIPCellID1,   scipcellid1);
PSR(0x00000005, 0x0000FFFF, SCIPCellID2,   scipcellid2);
PSR(0x000000B1, 0x0000FFFF, SCIPCellID3,   scipcellid3);

PSR(0x00000000, 0x0000FFFF, SCITCR);
  }


void IntegrationTest(void)
{
  C("Integration Tests for the SCI PL131");
  
    /* IntegrationTest:
     ================
     When the SCI is used in an AMBA system, it must be ensured that
     all of its pins are correctly connected. Integration vectors
     allow the user to verify that the SCI has been wired into the
     system correctly.
    */

  /* Testing of Intra-Chip inputs:
     o SCITXDMACLR
     o SCITXDMACLR

     When used in isolation:

     - Write a 1 to the ITEN bit in the Control register. This selects
       the path from the internal SCIITIP[5:4] register bits to the 
       internal SCITXDMACLR, SCIRXDMACLR signals through the test mux.

     - Write a 1 and then a 0 to the SCIITIP[5:4] register bits.
       
     - A read from this location will be that of internal mux output
       mimicing that of the SCITXDMACLR and SCIRXDMACLR external signals.

     When used with a system. 

     - Write a 0 to the ITEN bit in the Control register. This selects
       the path from the external SCITXDMACLR and SCIRXDMACLR signals to
       the internal SCITXDMACLR and SCIRXDMACLR signals through the
       test mux. The former signals are fed from the respective signals
       on the DMA controller, which are in turn controlled by its
       internal output integration test registers.

     - Write a 1 to the ITEN bit within the DMA controller.

     - Write a 1 and then a 0 to the DMA controller internal output 
       integration test register bits so as to toggle the SCITXDMACLR
       and SCIRXDMACLR signal connections between the DMA controller
       and the SCI.

     - A read from this location will verify the connections between
       DMA controller and the SCI.
     
  */ 


  C("Testing Intra Chip Input connections");
  
  /* Enable Integration testing of the SCI by setting the ITEN
     bit in the SCITCR register */
  PSW(0x1, SCITCR);
  
  /* Set the SCITXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the SCITXDMACLR output signal within the DMA controller,
            whilst the ITEN bit is cleared to zero. */

  PSW(0x20, SCIITIP); 

  /* Read the value on the SCITXDMACLR input */ 
  PSR(0x20, 0x30, SCIITIP, SCITXDMACLR_set);

  /* Clear the SCITXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            clear the SCITXDMACLR output signal within the DMA controller,
            whilst the ITEN bit is cleared to zero. */
  PSW(0x00, SCIITIP); 

  /* Read the value on the SCITXDMACLR input */ 
  PSR(0x00, 0x30, SCIITIP, SCITXDMACLR_cleared);

  
  /* Set the SCIRXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the SCIRXDMACLR output signal within the DMA controller 
            whilst the ITEN bit is cleared to zero. */
  PSW(0x10, SCIITIP); 

  /* Read the value on the SCIRXDMACLR input */ 
  PSR(0x10, 0x30, SCIITIP, SCIRXDMACLR_set);

  /* Clear the SCIRXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            clear the SCIRXDMACLR output signal within DMA controller,
            whilst the ITEN bit is cleared to zero. */
  PSW(0x00, SCIITIP); 

  /* Read the value on the SCIRXDMACLR input */ 
  PSR(0x00, 0x30, SCIITIP, SCIRXDMACLR_cleared);

  C("Testing Primary Output and  Primary Output connections");
  
  /* Suitable pad configurations for driving the bidirection
     clock and data signals, coupled with a Trickbox to provide
     direct loop back and logical operations on signals allows
     integration testing of the primary outputs and inputs
     of the SCI PL131.    

      o Bidirctional Primary Outputs

        - The SCICLOCKOUTEN, nSCICLKEN signals are used to control
          the SCICLKOUT signal. The SCICLOKOUT signal is the only
          clock signal of the three to be directly tested in this
          manner through the Trickbox.
          To fully test the nSCICLKEN signal, a weak pullup or
          pulldown would be required to be connected to the 
          SCICLKOUT pad. Note, the SCICLOCKOUTEN cannot be fully
          tested as it controls an inaccessible node within the
          clock path.
        - The nSCIDATAEN enable provide the control to the
          off-chip pad, which is fed data through the nSCIDATAOUTEN
          signal. The latter signal is is the only data  signal of 
          the two to be directly tested in this manner through the
          Trickbox.
          To fully test the nSCIDATAEN signal, a weak pullup or
          pulldown would be required to be connected to the 
 
        In the absence of pullup or pulldowns, only the SCIITOP2 
        register bits for SCICLKOUT and nSCIDATAOUTEN can be written 
        then read.

      o Unidirectional Primary Outputs.

        - The SCIDEACACK output is looped back to the SCIDEACREQ input
          through the Trickbox.
        - The SCIVCCEN, nSCICARDRST and SCIFCB are Xor'd and the
          resultant output fed to the SCIDETECT input.

  */

  /* Bidirectional Primary Outputs
  /* Set the ITEN bit within the SCITCR register */
  PSW(0x1, SCITCR);

  /* Test the SCICLKOUT to SCICLKIN path through the Trickbox */
  /* Write/read a 1, then a 0  to the SCICLKOUT bit within SCIITOP2 */
  /* Read the SCICLKIN bit within SCIITIP */
  PSW(0x0100, SCIITOP2);
  PSR(0x0100, 0x1FFF, SCIITOP2);
  PSR(0x08, 0x0F, SCIITIP); 
 
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0x1FFF, SCIITOP2);
  PSR(0x00, 0x0F, SCIITIP); 
 
  /* Test the nSCIDATAOUTEN to SCIDATAIN path through the Trickbox */
  /* Write/read a 1, then a 0  to the nSCIDATAOUTEN bit within SCIITOP2 */
  /* Read the SCIDATAIN bit within SCIITIP */
  PSW(0x0020, SCIITOP2);
  PSR(0x0020, 0x1FFF, SCIITOP2);
  PSR(0x04, 0x0F, SCIITIP); 
 
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0x1FFF, SCIITOP2);
  PSR(0x00, 0x0F, SCIITIP); 
 
  /* Unidirectional Primary Outputs */

  /* Test the SCIDEACACK output to SCIDEACREQ input */
  /* Write/read a 1, then a 0  to the SCIDEACACK bit within SCIITOP2 */
  /* Read the SCIDEACREQ bit within SCIITIP */
  PSW(0x0001, SCIITOP2);
  PSR(0x0001, 0x1FFF, SCIITOP2);
  PSR(0x01, 0x0F, SCIITIP); 
 
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0x1FFF, SCIITOP2);
  PSR(0x00, 0x0F, SCIITIP); 
 
  /* Test the nSCICARDRST output to SCIDETECT input */
  /* Write/read a 1, then a 0  to the nSCICARDRST bit within SCIITOP2 */
  /* Read the SCIDETECT bit within SCIITIP */
  PSW(0x0002, SCIITOP2);
  PSR(0x0002, 0x1FFF, SCIITOP2);
  PSR(0x02, 0x0F, SCIITIP); 
 
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0x1FFF, SCIITOP2);
  PSR(0x00, 0x0F, SCIITIP); 
 
  /* Test the SCIFCB output to SCIDETECT input */
  /* Write/read a 1, then a 0  to the SCIFCB bit within SCIITOP2 */
  /* Read the SCIDETECT bit within SCIITIP */
  PSW(0x0004, SCIITOP2);
  PSR(0x0004, 0x1FFF, SCIITOP2);
  PSR(0x02, 0x0F, SCIITIP); 
 
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0x1FFF, SCIITOP2);
  PSR(0x00, 0x0F, SCIITIP); 
 
  /* Test the SCIVCCEN output to SCIDETECT input */
  /* Write/read a 1, then a 0  to the SCIVCCEN bit within SCIITOP2 */
  /* Read the SCIDETECT bit within SCIITIP */
  PSW(0x0008, SCIITOP2);
  PSR(0x0008, 0x1FFF, SCIITOP2);
  PSR(0x02, 0x0F, SCIITIP); 
 
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0x1FFF, SCIITOP2);
  PSR(0x00, 0x0F, SCIITIP); 
  
  /* Testing of Intra-Chip Outputs:
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register. This selects 
       the test path from the SCIITOP[13:5] register bits.
     - Write a 1 and then a 0 to the SCIITOP[13:5] register bit and read 
       the same register bit to ensure that the value written is read 
       out.

       When integration tests are run in an integrated system '1' and '0'
       are written to the SCIITOP[13:5] register bits so as to toggle the 
       signal connections between the SCI and the DMA Controller/ 
       Interrupt controller. Read from the DMA Controller/ Interrupt 
       controller's internal registers to verify that the value written 
       into the SCIITOP[13:5] register bits is read out through the 
       DMA controller/ Interrupt Controller.
  */ 
 
  C("Testing Intra Chip Output connections");
  PSW(0x1, SCITCR); 

  /* Set the SCITXDMASREQ bit (15) */
  PSW(0x8000, SCIITOP1);
  PSR(0x8000, 0xFFFF, SCIITOP1, SCITXDMASREQ_set);
  /* Clear the SCITXDMASREQ bit (15) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCITXDMASREQ_cleared);

  /* Set the SCITXDMABREQ bit (14) */
  PSW(0x4000, SCIITOP1);
  PSR(0x4000, 0xFFFF, SCIITOP1, SCITXDMABREQ_set);
  /* Clear the SCITXDMABREQ bit (14) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCITXDMABREQ_cleared);

  /* Set the SCIRXDMASREQ bit (13) */
  PSW(0x2000, SCIITOP1);
  PSR(0x2000, 0xFFFF, SCIITOP1, SCIRXDMASREQ_set);
  /* Clear the SCIRXDMASREQ bit (13) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCIRXDMASREQ_cleared);

  /* Set the SCIRXDMABREQ bit (12) */
  PSW(0x1000, SCIITOP1);
  PSR(0x1000, 0xFFFF, SCIITOP1, SCIRXDMABREQ_set);
  /* Clear the SCITXDMABREQ bit (12) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCIRXDMABREQ_cleared);

  /* Set the SCITXTIDEINTR bit (11) */
  PSW(0x0800, SCIITOP1);
  PSR(0x0800, 0xFFFF, SCIITOP1, SCITXTIDEINTR_set);
  /* Clear the SCITXTIDEINTR bit (11) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCITXTIDEINTR_cleared);

  /* Set the SCIRXTIDEINTR bit (10) */
  PSW(0x0400, SCIITOP1);
  PSR(0x0400, 0xFFFF, SCIITOP1, SCIRXTIDEINTR_set);
  /* Clear the SCIRXTIDEINTR bit (10) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCIRXTIDEINTR_cleared);

  /* Set the SCIRTOUTINTR bit (9) */
  PSW(0x0200, SCIITOP1);
  PSR(0x0200, 0xFFFF, SCIITOP1, SCIRTOUTINTR_set);
  /* Clear the SCIRTOUTINTR bit (9) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCIRTOUTINTR_cleared);

  /* Set the SCICHTOUTINTR bit (8) */
  PSW(0x0100, SCIITOP1);
  PSR(0x0100, 0xFFFF, SCIITOP1, SCICHTOUTINTR_set);
  /* Clear the SCICHTOUTINTR bit (8) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCICHTOUTINTR_cleared);

  /* Set the SCIBLKTOUTINTR bit (7) */
  PSW(0x0080, SCIITOP1);
  PSR(0x0080, 0xFFFF, SCIITOP1, SCIBLKTOUTINTR_set);
  /* Clear the SCIBLKTOUTINTR bit (7) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCIBLKTOUTINTR_cleared);

  /* Set the SCIATRDTOUTINTR bit (6) */
  PSW(0x0040, SCIITOP1);
  PSR(0x0040, 0xFFFF, SCIITOP1, SCIATRDTOUTINTR_set);
  /* Clear the SCIATRDTOUTINTR bit (6) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCIATRDTOUTINTR_cleared);

  /* Set the SCIATRSTOUTINTR bit (5) */
  PSW(0x0020, SCIITOP1);
  PSR(0x0020, 0xFFFF, SCIITOP1, SCIATRSTOUTINTR_set);
  /* Clear the SCIATRSTOUTINTR bit (5) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCIATRSTOUTINTR_cleared);

  /* Set the SCITXERRINTR bit (4) */
  PSW(0x0010, SCIITOP1);
  PSR(0x0010, 0xFFFF, SCIITOP1, SCITXERRINTR_set);
  /* Clear the SCITXERRINTR bit (4) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCITXERRINTR_cleared);

  /* Set the SCICARDDNINTR bit (3) */
  PSW(0x0008, SCIITOP1);
  PSR(0x0008, 0xFFFF, SCIITOP1, SCICARDDNINTR_set);
  /* Clear the SCICARDDNINTR bit (3) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCICARDDNINTR_cleared);

  /* Set the SCICARDUPINTR bit (2) */
  PSW(0x0004, SCIITOP1);
  PSR(0x0004, 0xFFFF, SCIITOP1, SCICARDUPINTR_set);
  /* Clear the SCICARDUPINTR bit (2) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCICARDUPINTR_cleared);

  /* Set the SCICARDOUTINTR bit (1) */
  PSW(0x0002, SCIITOP1);
  PSR(0x0002, 0xFFFF, SCIITOP1, SCICARDOUTINTR_set);
  /* Clear the SCICARDOUTINTR bit (1) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCICARDOUTINTR_cleared);

  /* Set the SCICARDININTR bit (0) */
  PSW(0x0001, SCIITOP1);
  PSR(0x0001, 0xFFFF, SCIITOP1, SCICARDININTR_set);
  /* Clear the SCICARDININTR bit (1) */
  PSW(0x0000, SCIITOP1);
  PSR(0x0000, 0xFFFF, SCIITOP1, SCICARDININTR_cleared);

  /* SCIITOP Register */

  /* Set the SCIINTR bit (12) */
  PSW(0x1000, SCIITOP2);
  PSR(0x1000, 0xFFFF, SCIITOP2, SCIINTR_set);
  /* Clear the SCIINTR bit (12) */
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0xFFFF, SCIITOP2, SCIINTR_cleared);

  /* Set the SCIRORINTR bit (11) */
  PSW(0x0800, SCIITOP2);
  PSR(0x0800, 0xFFFF, SCIITOP2, SCIRORINTR_set);
  /* Clear the SCIRORINTR bit (11) */
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0xFFFF, SCIITOP2, SCIRORINTR_cleared);

  /* Set the SCICLKACTINTR bit (10) */
  PSW(0x0400, SCIITOP2);
  PSR(0x0400, 0xFFFF, SCIITOP2, SCICLKACTINTR_set);
  /* Clear the SCICLKACTINTR bit (10) */
  PSW(0x0000, SCIITOP2);
  PSR(0x0000, 0xFFFF, SCIITOP2, SCICLKACTINTR_cleared);


  /* Set the SCICLKSTPINTR bit (9) */
  PSW(0x0200, SCIITOP2);
  PSR(0x0200, 0xFFFF, SCIITOP2, SCICLKSTPINTR_set);
  /* Clear the SCICLKSTPINTR bit (9) */
  PSW(0x0100, SCIITOP2);
  PSR(0x0100, 0xFFFF, SCIITOP2, SCICLKSTPINTR_cleared);

  /* Revert back to normal mode. */
  PSW(0x0000,SCITCR);

  
}
