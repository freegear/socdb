/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Ssp_RegTests.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function RegTests
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void RegTests()

{

  /*
   Summary: Register Test
   ======================
   This test checks the following functionalities :
 
   o  All SSP registers are read immediately after reset to verify
      that they initialise to values mentioned in the specification.
 
   o  The SSP status registers is written with a compliment pattern of its 
      reset value. Data is read back and compared with its reset value.

   o  The Read/Writeable registers are written with patterns of 0x55, 0xAA,
      0xFF and 0x00. Data is read back and compared with the expected pattern.
   */

  /* Default  Value Test */

  C( "SSP REG DEFAULT VALUE TEST" );

  PSR(RESET_SSPCR0,     MASK_RESET_SSPCR0,     SSPCR0,     sspcr0_default);
  PSR(RESET_SSPCR1,     MASK_RESET_SSPCR1,     SSPCR1,     sspcr1_default); 
  PSR(RESET_SSPSR,      MASK_RESET_SSPSR,      SSPSR,      sspsr_default);
  PSR(RESET_SSPCPSR,    MASK_RESET_SSPCPSR,    SSPCPSR,    sspcpsr_default);
  PSR(RESET_SSPIMSC,    MASK_RESET_SSPIMSC,    SSPIMSC,    sspimsc_default);
  PSR(RESET_SSPRIS,     MASK_RESET_SSPRIS,     SSPRIS,     sspris_default);
  PSR(RESET_SSPMIS,     MASK_RESET_SSPMIS,     SSPMIS,     sspmis_default);
  PSR(RESET_SSPDMACR,   MASK_RESET_SSPDMACR,   SSPDMACR,   sspdmacr_default);

  PSR(RESET_SSPTCR,     MASK_RESET_SSPTCR,     SSPTCR,      ssptcr_default);
  PSR(RESET_SSPITOP,    MASK_RESET_SSPITOP,    SSPITOP,    sspitop_default);

  PSR(RESET_SSPPERIPHID0, MASK_RESET_SSPPERIPHID0, SSPPERIPHID0, sspperiphido_default);
  PSR(RESET_SSPPERIPHID1, MASK_RESET_SSPPERIPHID1, SSPPERIPHID1, sspperiphid1_default);
  PSR(RESET_SSPPERIPHID2, MASK_RESET_SSPPERIPHID2, SSPPERIPHID2, sspperiphid2_default);
  PSR(RESET_SSPPERIPHID3, MASK_RESET_SSPPERIPHID3, SSPPERIPHID3, sspcellid3_default);
  PSR(RESET_SSPPCELLID0,  MASK_RESET_SSPPCELLID0,  SSPPCELLID0,  ssppcellido_default);
  PSR(RESET_SSPPCELLID1,  MASK_RESET_SSPPCELLID1,  SSPPCELLID1,  ssppcellid1_default);
  PSR(RESET_SSPPCELLID2,  MASK_RESET_SSPPCELLID2,  SSPPCELLID2,  ssppcellid2_default);
  PSR(RESET_SSPPCELLID3,  MASK_RESET_SSPPCELLID3,  SSPPCELLID3,  ssppcellid3_default);

  C("SSP REG READ ONLY TEST");

  PSW(~RESET_SSPSR, SSPSR, sspsr_r/only);
  PSR(RESET_SSPSR , MASK_RESET_SSPSR , SSPSR,sspsr_r/only); 

  PSW(~RESET_SSPRIS, SSPRIS, sspris_r/only);
  PSR(RESET_SSPRIS , MASK_RESET_SSPRIS , SSPRIS,sspris_r/only); 

  PSW(~RESET_SSPMIS, SSPMIS, sspmis_r/only);
  PSR(RESET_SSPMIS , MASK_RESET_SSPMIS , SSPMIS,sspmis_r/only); 

  PSW(~RESET_SSPPERIPHID0, SSPPERIPHID0, sspperiphid0_r/only);
  PSR(RESET_SSPPERIPHID0 , MASK_RESET_SSPPERIPHID0 , SSPPERIPHID0,sspperiphid0_r/only); 

  PSW(~RESET_SSPPERIPHID1, SSPPERIPHID1, sspperiphid1_r/only);
  PSR(RESET_SSPPERIPHID1 , MASK_RESET_SSPPERIPHID1 , SSPPERIPHID1,sspperiphid1_r/only); 

  PSW(~RESET_SSPPERIPHID2, SSPPERIPHID2, sspperiphid2_r/only);
  PSR(RESET_SSPPERIPHID2 , MASK_RESET_SSPPERIPHID2 , SSPPERIPHID2,sspperiphid2_r/only); 

  PSW(~RESET_SSPPERIPHID3, SSPPERIPHID3, sspperiphid3_r/only);
  PSR(RESET_SSPPERIPHID3 , MASK_RESET_SSPPERIPHID3 , SSPPERIPHID3,sspperiphid3_r/only); 

  PSW(~RESET_SSPPCELLID0, SSPPCELLID0, ssppcellid0_r/only);
  PSR(RESET_SSPPCELLID0 , MASK_RESET_SSPPCELLID0 , SSPPCELLID0,ssppcellid0_r/only); 

  PSW(~RESET_SSPPCELLID1, SSPPCELLID1, ssppcellid1_r/only);
  PSR(RESET_SSPPCELLID1 , MASK_RESET_SSPPCELLID1 , SSPPCELLID1,ssppcellid1_r/only); 

  PSW(~RESET_SSPPCELLID2, SSPPCELLID2, ssppcellid2_r/only);
  PSR(RESET_SSPPCELLID2 , MASK_RESET_SSPPCELLID2 , SSPPCELLID2,ssppcellid2_r/only); 

  PSW(~RESET_SSPPCELLID3, SSPPCELLID3, ssppcellid3_r/only);
  PSR(RESET_SSPPCELLID3 , MASK_RESET_SSPPCELLID3 , SSPPCELLID3,ssppcellid3_r/only); 

  C( "SSP REG R/W TEST" );

  PSW(DATA_As, SSPCR0, sspcr0A);
  PSR(DATA_As & MASK_SSPCR0, MASK_SSPCR0, SSPCR0,sspcr0_A_r/w);
  Idle(4 * (SSPCLK_PERIOD / PCLK_PERIOD));

  PSW(DATA_5s, SSPCR0, sspcr05);
  PSR(DATA_5s & MASK_SSPCR0, MASK_SSPCR0, SSPCR0,sspcr0_r/w_5);
  Idle(4 * (SSPCLK_PERIOD / PCLK_PERIOD));

  PSW(DATA_Fs, SSPCR0, sspcr0F);
  PSR(DATA_Fs & MASK_SSPCR0, MASK_SSPCR0, SSPCR0,sspcr0_r/w_F);
  Idle(4 * (SSPCLK_PERIOD / PCLK_PERIOD));

  PSW(DATA_0s, SSPCR0, sspcr0_0 );
  PSR(DATA_0s & MASK_SSPCR0, MASK_SSPCR0, SSPCR0,sspcr0_r/w_0);
  Idle(4 * (SSPCLK_PERIOD / PCLK_PERIOD));


  PSW(DATA_As & MASK_SSPCR1, SSPCR1, sspcr1A);
  PSR(DATA_As & MASK_SSPCR1, MASK_SSPCR1, SSPCR1,sspcr1_r/w_A);

  PSW(DATA_5s & MASK_SSPCR1, SSPCR1, sspcr15);
  PSR(DATA_5s & MASK_SSPCR1, MASK_SSPCR1, SSPCR1,sspcr1_r/w_5);

  PSW(DATA_Fs & MASK_SSPCR1, SSPCR1, sspcr1F);
  PSR(DATA_Fs & MASK_SSPCR1, MASK_SSPCR1, SSPCR1,sspcr1_r/w_F);

  PSW(DATA_0s & MASK_SSPCR1, SSPCR1, sspcr10);
  PSR(DATA_0s & MASK_SSPCR1, MASK_SSPCR1, SSPCR1,sspcr1_r/w_0);


  PSW(DATA_As & MASK_SSPCPSR , SSPCPSR, sspcpsrA );
  PSR(DATA_As & MASK_SSPCPSR, MASK_SSPCPSR, SSPCPSR,sspcpsr_r/w_A );
  Idle(4 * (SSPCLK_PERIOD / PCLK_PERIOD));

  PSW(DATA_5s & MASK_SSPCPSR , SSPCPSR, sspcpsr5 );
  PSR(DATA_5s & MASK_SSPCPSR, MASK_SSPCPSR, SSPCPSR,sspcpsr_r/w_5 );
  Idle(4 * (SSPCLK_PERIOD / PCLK_PERIOD));

  PSW(DATA_Fs & MASK_SSPCPSR , SSPCPSR, sspcpsrF );
  PSR(DATA_Fs & MASK_SSPCPSR, MASK_SSPCPSR, SSPCPSR,sspcpsr_r/w_F );
  Idle(4 * (SSPCLK_PERIOD / PCLK_PERIOD));

  PSW(DATA_0s & MASK_SSPCPSR , SSPCPSR, sspcpsr0 );
  PSR(DATA_0s & MASK_SSPCPSR, MASK_SSPCPSR, SSPCPSR,sspcpsr_r/w_0 );
  Idle(4 * (SSPCLK_PERIOD / PCLK_PERIOD));


  PSW(DATA_As & MASK_SSPIMSC, SSPIMSC, sspimscA);
  PSR(DATA_As & MASK_SSPIMSC, MASK_SSPIMSC, SSPIMSC,sspimsc_r/w_A);

  PSW(DATA_5s & MASK_SSPIMSC, SSPIMSC, sspimsc5);
  PSR(DATA_5s & MASK_SSPIMSC, MASK_SSPIMSC, SSPIMSC,sspimsc_r/w_5);

  PSW(DATA_Fs & MASK_SSPIMSC, SSPIMSC, sspimscF);
  PSR(DATA_Fs & MASK_SSPIMSC, MASK_SSPIMSC, SSPIMSC,sspimsc_r/w_F);

  PSW(DATA_0s & MASK_SSPIMSC, SSPIMSC, sspimsc0);
  PSR(DATA_0s & MASK_SSPIMSC, MASK_SSPIMSC, SSPIMSC,sspimsc_r/w_0);


  PSW(DATA_As & MASK_SSPDMACR, SSPDMACR, sspdmacrA);
  PSR(DATA_As & MASK_SSPDMACR, MASK_SSPDMACR, SSPDMACR,sspdmacr_r/w_A);

  PSW(DATA_5s & MASK_SSPDMACR, SSPDMACR, sspdmacr5);
  PSR(DATA_5s & MASK_SSPDMACR, MASK_SSPDMACR, SSPDMACR,sspdmacr_r/w_5);

  PSW(DATA_Fs & MASK_SSPDMACR, SSPDMACR, sspdmacrF);
  PSR(DATA_Fs & MASK_SSPDMACR, MASK_SSPDMACR, SSPDMACR,sspdmacr_r/w_F);

  PSW(DATA_0s & MASK_SSPDMACR, SSPDMACR, sspdmacr0);
  PSR(DATA_0s & MASK_SSPDMACR, MASK_SSPDMACR, SSPDMACR,sspdmacr_r/w_0);

  /* Only write operations to the SSPITIP[4:3] Test Register are       */
  /* performed to improve code coverage. The SSPRXD line is undefined, */
  /*  hence a read from this register would result in unknown data     */
  /* entering the peripheral.                                          */

  PSW(DATA_As & MASK_SSPITIP_4_3, SSPITIP, sspitipA);
  PSW(DATA_5s & MASK_SSPITIP_4_3, SSPITIP, sspitip5);
  PSW(DATA_Fs & MASK_SSPITIP_4_3, SSPITIP, sspitipF);
  PSW(DATA_0s & MASK_SSPITIP_4_3, SSPITIP, sspitip0);

  /* Write-read operations can be performed to the SSPITOP[13:0] Test  */
  /* Register when ITEN is set to 1. ITEN must be cleared to return to */
  /* normal operation.                                                 */

  PSW(0x1, SSPTCR, ssptcr);

  PSW(DATA_As & MASK_SSPITOP, SSPITOP, sspitopA);
  PSR(DATA_As & MASK_SSPITOP, MASK_SSPITOP, SSPITOP,sspitop_r/w_A);

  PSW(DATA_5s & MASK_SSPITOP, SSPITOP, sspitop5);
  PSR(DATA_5s & MASK_SSPITOP, MASK_SSPITOP, SSPITOP,sspitop_r/w_5);

  PSW(DATA_Fs & MASK_SSPITOP, SSPITOP, sspitopF);
  PSR(DATA_Fs & MASK_SSPITOP, MASK_SSPITOP, SSPITOP,sspitop_r/w_F);

  PSW(DATA_0s & MASK_SSPITOP, SSPITOP, sspitop0);
  PSR(DATA_0s & MASK_SSPITOP, MASK_SSPITOP, SSPITOP,sspitop_r/w_0);

  PSW(0x0, SSPTCR, ssptcr);

  C( "END OF REG TEST" );

}/* End Function */
