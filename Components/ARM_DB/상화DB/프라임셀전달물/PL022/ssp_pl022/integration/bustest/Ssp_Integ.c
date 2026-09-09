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
-- File Name              : Ssp_Integ.c.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL022-REL1v2
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Ssp.c, Ssp.h, Ssp_Integ.c
--
--   Usage: make <testname> e.g. make Ssp_Integ
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Ssp_Integ
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/
 
/**********************************************************************/
/*** For more information on the SSP, please refer to the SSP PL022 ***/
/*** Technical Reference Manual                                     ***/
/**********************************************************************/


void ResetRead(void)
{
  PSR(RESET_SSPCR0,     MASK_RESET_SSPCR0,     SSPCR0,     sspcr0_default);
  PSR(RESET_SSPCR1,     MASK_RESET_SSPCR1,     SSPCR1,     sspcr1_default); 
  PSR(RESET_SSPSR,      MASK_RESET_SSPSR,      SSPSR,      sspsr_default);
  PSR(RESET_SSPCPSR,    MASK_RESET_SSPCPSR,    SSPCPSR,    sspcpsr_default);
  PSR(RESET_SSPIMSC,    MASK_RESET_SSPIMSC,    SSPIMSC,    sspimsc_default);
  PSR(RESET_SSPRIS,     MASK_RESET_SSPRIS,     SSPRIS,     sspris_default);
  PSR(RESET_SSPMIS,     MASK_RESET_SSPMIS,     SSPMIS,     sspmis_default);
  PSR(RESET_SSPDMACR,   MASK_RESET_SSPDMACR,   SSPDMACR,   sspdmacr_default);

  PSR(RESET_SSPTCR,     MASK_RESET_SSPTCR,     SSPTCR,      ssptcr_default);
  /* ITEN = 0, therefore Intra-chip output SSP core values are actually read */
  PSR(RESET_SSPITOP,    MASK_RESET_SSPITOP,    SSPITOP,    sspitop_default);

  PSR(RESET_SSPPERIPHID0, MASK_RESET_SSPPERIPHID0, SSPPERIPHID0, sspperiphido_default);
  PSR(RESET_SSPPERIPHID1, MASK_RESET_SSPPERIPHID1, SSPPERIPHID1, sspperiphid1_default);
  PSR(RESET_SSPPERIPHID2, MASK_RESET_SSPPERIPHID2, SSPPERIPHID2, sspperiphid2_default);
  PSR(RESET_SSPPERIPHID3, MASK_RESET_SSPPERIPHID3, SSPPERIPHID3, sspcellid3_default);
  PSR(RESET_SSPPCELLID0,  MASK_RESET_SSPPCELLID0,  SSPPCELLID0,  ssppcellido_default);
  PSR(RESET_SSPPCELLID1,  MASK_RESET_SSPPCELLID1,  SSPPCELLID1,  ssppcellid1_default);
  PSR(RESET_SSPPCELLID2,  MASK_RESET_SSPPCELLID2,  SSPPCELLID2,  ssppcellid2_default);
  PSR(RESET_SSPPCELLID3,  MASK_RESET_SSPPCELLID3,  SSPPCELLID3,  ssppcellid3_default);  
}


void IntegrationTest(void)
{
  C("Integration Test");
  
    /* IntegrationTest:
     ================
     When the SSP is used in an AMBA system, it must be ensured that
     all of its pins are correctly connected. Integration vectors
     allow the user to verify that the SSP has been wired into the
     system correctly.
    */

  /* Testing of Intra-Chip inputs (SSPTXDMACLR, SSPRXDMACLR) :
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register. This selects
       the test path from the SSPITIP[4:6] register bit to the internal
       SSPTXDMACLR and SSPRXDMACLR signals.
     - Write a 1 and then a 0 to the SSPITIP[7:6] register bits and read
       the same register bit to ensure that the value written is read
       out.

     When integration tests are run in an integrated system, the ITEN bit
     is cleared to 0, then  '1' and '0' are written into internal output 
     registers of DMA controller so as to toggle the SSPTXDMACLR signal 
     connection between the DMA controller and the SSP.
     Read from location SSPITIP[4] to verfiy the connectivity, noting that this
     is a read from the output of the internal test mux and not the actual
     register output.
     Similarly a '1' and '0' are written to the DMA Contrlolers internal 
     output register to toggle the SSPRXDMACLR signal connection between 
     theh DMAC and the SSP.
     Read from the location SSPITIP[3] to verify conectivity.
  */ 

  C("Integration Tests for the SSP");

  C("Testing Intra Chip Input connection");
  
  /* Enable Integration testing of the SSP by setting the ITEN
     bit in the SSPTCR register */
  PSW(0x0001, SSPTCR);
  
  /* Set the SSPTXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the SSPTXDMACLR output signal within the DMA controller,
            whilst the ITEN bit is cleared to zero. */

  PSW(0x10, SSPITIP); 

  /* Read the value on the SSPTXDMACLR input */ 
  PSR(0x10, MASK_SSPITIP_4_3, SSPITIP,int1);

  /* Clear the SSPTXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            clear the SSPTXDMACLR output signal within the DMA controller,
            whilst the ITEN bit is cleared to zero. */
  PSW(0x00000000, SSPITIP); 

  /* Read the value on the SSPTXDMACLR input */ 
  PSR(0x00000000, MASK_SSPITIP_4_3, SSPITIP,int2);

  
  /* Set the SSPRXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the SSPRXDMACLR output signal within the DMA controller 
            whilst the ITEN bit is cleared to zero. */
  PSW(0x40, SSPITIP); 

  /* Read the value on the SSPRXDMACLR input */ 
  PSR(0x40, MASK_SSPITIP_4_3, SSPITIP,int3);

  /* Clear the SSPRXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            clear the SSPRXDMACLR output signal within DMA controller,
            whilst the ITEN bit is cleared to zero. */
  PSW(0x00000000, SSPITIP); 

  /* Read the value on the SSPRXDMACLR input */ 
  PSR(0x00000000, MASK_SSPITIP_4_3, SSPITIP,int4);

  /* Testing primary inputs and primary outputs :
     
     using the Integration vector trickbox by looping back the primary
     outputs( nSIROUT, SSPTXD, nSSPDTR, nSSPRTS, nSSPOut1 and nSSPOut2.
     '1's and '0's are driven onto the primary output lines via the SSPITOP
     register bits[5:0] and read back via the SSPITIP register bits[5:0].
     When the SSPITOP register is written to, a read is performed to check
     the contents.
  */
  
  C("Testing Primary Input and Primary Output connections");

  PSW(0x0001, SSPTCR);
 
  /*
  The SSPTXD and SSPCLKOUT signals are connected to three
  state drivers controlled by nSSPOE and nSSPCTLOE respectively.
  These control signals will be programmed to enable the
  outputs i.e. bits SSPITOP[4:3] are cleared low.

  To fully test that the signals nSSPOE and nSSPCTLOE are
  connected to the pads internally, it will be necessary
  to attach a weak pullup or pulldown to the SSPTXD and
  SSPCLKOUT signals respectively.
  
  In the absence of this, only the SSPITOP register bits
  for nSSPOE and nSSPCTLOE can be written then read.
  */

  /* SSPTXD and SSPRXD */
   
  PSW(0x0001, SSPITOP);
  PSR(0x0001, MASK_SSPITOP_4_0, SSPITOP, read1);
  PSR(0x0001, MASK_SSPITIP_2_0, SSPITIP,int5);

  PSW(0x0000, SSPITOP); 
  PSR(0x0000, MASK_SSPITOP_4_0, SSPITOP, read2);
  PSR(0x0000, MASK_SSPITIP_2_0, SSPITIP,int6);

  /* SSPFSSOUT and SSPFSSIN */

  PSW(0x0002, SSPITOP); 
  PSR(0x0002, MASK_SSPITOP_4_0, SSPITOP, read3);
  PSR(0x0002, MASK_SSPITIP_2_0, SSPITIP,int7);

  PSW(0x0000, SSPITOP); 
  PSR(0x0000, MASK_SSPITOP_4_0, SSPITOP, read4);
  PSR(0x0000, MASK_SSPITIP_2_0, SSPITIP,int8);

  /* SSPCLKOUT and SSPCLKIN */

  PSW(0x0004, SSPITOP);
  PSR(0x0004, MASK_SSPITOP_4_0, SSPITOP, read5);
  PI(2);
  PSR(0x0004, MASK_SSPITIP_2_0, SSPITIP,int9);

  PSW(0x0000, SSPITOP); 
  PSR(0x0000, MASK_SSPITOP_4_0, SSPITOP, read6);
  PI(2);
  PSR(0x0000, MASK_SSPITIP_2_0, SSPITIP,int10);

  /* nSSPOE and nSSPCTLOE */

  PSW(0x0018, SSPITOP); 
  PSR(0x0018, MASK_SSPITOP_4_0, SSPITOP, read7);
  PI(2);

  PSW(0x0000, SSPITOP); 
  PSR(0x0000, MASK_SSPITOP_4_0, SSPITOP, read8);
  PI(2);

  
  /* Testing of Intra-Chip Outputs:
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register. This selects 
       the test path from the SSPITOP[13:5] register bits.
     - Write a 1 and then a 0 to the SSPITOP[13:5] register bit and read 
       the same register bit to ensure that the value written is read 
       out.

       When integration tests are run in an integrated system '1' and '0'
       are written to the SSPITOP[13:5] register bits so as to toggle the 
       signal connections between the SSP and the DMA Controller/ 
       Interrupt controller. Read from the DMA Controller/ Interrupt 
       controller's internal registers to verify that the value written 
       into the SSPITOP[13:5] register bits is read out through the 
       DMA controller/ Interrupt Controller.
  */ 
 
  C("Testing Intra Chip Output connections");
  PSW(0x00000001, SSPTCR); 

  /* Set the SSPTXDMASREQ bit (13) */
  PSW(0x2000, SSPITOP);

  PSR(0x2000, MASK_SSPITOP_13_5, SSPITOP,int17);

  /* Clear the SSPTXDMASREQ bit (13) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int18);

  
  /* Set the SSPTXDMABREQ bit (12) */
  PSW(0x1000, SSPITOP);

  /* Read the value on the intra-chip outputs of the SSP */
  PSR(0x1000, MASK_SSPITOP_13_5, SSPITOP,int19);

  /* Clear the SSPTXDMABREQ bit (12) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int20);
 

  /* Set the SSPRXDMASREQ bit (11) */
  PSW(0x0800, SSPITOP);

  /* Read the value on the intra-chip outputs of the SSP */
  PSR(0x0800, MASK_SSPITOP_13_5, SSPITOP,int21);

  /* Clear the SSPRXDMASREQ bit (11) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int22);


  /* Set the SSPRXDMABREQ bit (10) */
  PSW(0x0400, SSPITOP);

  /* Read the value on the intra-chip outputs of the SSP */
  PSR(0x0400, MASK_SSPITOP_13_5, SSPITOP,int23);

  /* Clear the SSPRXDMABREQ bit (10) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int24);


  /* Set the SSPMSINTR bit (9) */
  PSW(0x0200, SSPITOP);

  /* Read the value on the intra-chip outputs of the SSP */
  PSR(0x0200, MASK_SSPITOP_13_5, SSPITOP,int25);

  /* Clear the SSPMSINTR bit (9) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int26);


  /* Set the SSPTXINTR bit (8) */
  PSW(0x0100, SSPITOP);

  /* Read the value on the intra-chip outputs of the SSP */
  PSR(0x0100, MASK_SSPITOP_13_5, SSPITOP,int27);

  /* Clear the SSPTXINTR bit (8) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int28);


  /* Set the SSPRXINTR bit (7) */
  PSW(0x0080, SSPITOP);

  /* Read the value on the intra-chip outputs of the SSP */
  PSR(0x0080, MASK_SSPITOP_13_5, SSPITOP,int29);

  /* Clear the SSPRXINTR bit (7) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int30);


  /* Set the SSPRTINTR bit (6) */
  PSW(0x0040, SSPITOP);

  /* Read the value on the intra-chip outputs of the SSP */
  PSR(0x0040, MASK_SSPITOP_13_5, SSPITOP,int31);

  /* Clear the SSPRTINTR bit (6) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int32);


  /* Set the SSPRORINTR bit (5) */
  PSW(0x0020, SSPITOP);

  /* Read the value on the intra-chip outputs of the SSP */
  PSR(0x0020, MASK_SSPITOP_13_5, SSPITOP,int33);

  /* Clear the SSPRORINTR bit (5) */
  PSW(0x0000, SSPITOP);

  PSR(0x0000, MASK_SSPITOP_13_5, SSPITOP,int34);



  PSW(0x0000,SSPTCR);

  
}
