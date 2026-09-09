/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- --------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : RegisterTest.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
--  Purpose : This C code file is used to generate BusTalk vectors.
--            BusTalk vectors are applied to the AMBA APB bus.
--
--  Files required for compilation:
--  makefile, busheader.h, busmacros.h, busmacros.c, config.h, 
--  addargs_script, Aaci.h
--
--   Usage: make <testname> e.g. make RegisterTest
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make RegisterTest
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/
 
/**********************************************************************/
/* For more information on the Aaci, please refer to PL041 AMBA AACI **/
/* Block Specification                                                */
/**********************************************************************/

/**********************************************************************/
/************************* Function declarations **********************/
/**********************************************************************/
void ResetValueTest();
void RegisterRdWrTest(void);

/**********************************************************************/
/*************************** Register Tests ***************************/
/**********************************************************************/
void RegisterTest(void)
{
 /*
   Summary : RegisterTest
   ======================
   Reset Value Test
   ----------------
   PRESETn is asserted and then de-asserted. All registers are checked
   for their reset values after the reset. The registers in PCLK domain
   should reflect their reset values as defined in the specs.
   Then nAACIBITCLKRST is asserted and then de-asserted. The registers
   are then read back to verify the reset values. This is tested for all
   the PCLK-domain registers as well as the AACIBITCLK domain registers.
   Then AACIBITCLK from the trickbox is then enabled and then
   nAACIBITCLKRST is asserted and then de-asserted. The registers are
   then read back to verify the reset values.

   Read/Write Test
   ---------------
   Read-only registers are checked by writing a value
   other than their reset values and reading back to check whether they
   return the reset values.
   Read-write registers are checked by writing data patterns of
   0x00000000, 0xAAAAAAAA, 0x55555555 and 0xFFFFFFFF and reading back to
   verify that the data that was written is returned.

   Read/Write Test for hardware masked registers
   ---------------------------------------------
   The AACITXCRn [n = 1-4] registers have hardware protection against
   writes during the synchronisation period. These registers are tested
   with RegTest bit in the AACITCR register set.
   For verifying that the hardware masking is in place, for these
   registers the RegTest bit is cleared and the Read/Write test is
   repeated.

 */

 RES(LOW,0x1,0x2);
 PI(0x03);

 ResetValueTest();

 RegisterRdWrTest();

 /* Changing to normal mode */
 PSW(NORMALMODE, AACITCR);
 PSW(0x0, AACIMAINCR);

}

/**********************************************************************/
/******************** ResetValueTest for registers ********************/
/**********************************************************************/
void ResetValueTest(void)
{
 /*
   Summary: Reset value tests
   ==========================
     PRESETn is asserted and then de-asserted. All registers are checked
  for their reset values after the reset. The registers in PCLK domain
  should reflect their reset values as defined in the specs.
     The BtclkRst argument indicate whether the AACI has been reset
  with nAACIBITCLKRST before this function is called. If yes, then this
  function checks the reset values of all registers including those in
  the AACIBITCLK domain. Else, only those registers in the PCLK domain
  are checked for correct reset values.

 */
 
 C("CHECKING RESET VALUES OF REGISTERS");

 /* if the reset had been applied then only to test these registers */
 C("CHECKING RESET VALUES OF STATUS REGISTERS");
 PSR(RESET_AACISR, MASK_ALL, AACISR1,AACI1_T26);
 PSR(RESET_AACISR, MASK_ALL, AACISR2,AACI1_T27);
 PSR(RESET_AACISR, MASK_ALL, AACISR3,AACI1_T28);
 PSR(RESET_AACISR, MASK_ALL, AACISR4,AACI1_T29);
 PSR(RESET_AACIRESET, MASK_ALL, AACIRESET,AACI1_T30);
 PSR(RESET_AACISLFR, MASK_ALL, AACISLFR,AACI1_T31);

 /* Check Reset Value of All Channel Tx Control Reg */

 C("CHECKING RESET VALUES OF CHANNEL Tx CONTROL REGISTERS");
 PSR(0x0, MASK_ALL, AACITXCR1,AACI1_T32);
 PSR(0x0, MASK_ALL, AACITXCR2,AACI1_T33);
 PSR(0x0, MASK_ALL, AACITXCR3,AACI1_T34);
 PSR(0x0, MASK_ALL, AACITXCR4,AACI1_T35);

 /* Check Reset Value of All Channel Rx Control Reg */

 C("CHECKING RESET VALUES OF CHANNEL Rx CONTROL REGISTERS");
 PSR(0x0, MASK_ALL, AACIRXCR1,AACI1_T36);
 PSR(0x0, MASK_ALL, AACIRXCR2,AACI1_T37);
 PSR(0x0, MASK_ALL, AACIRXCR3,AACI1_T38);
 PSR(0x0, MASK_ALL, AACIRXCR4,AACI1_T39);

 /* Check Reset Value of All Channel interrupt Status  Reg */

 C("CHECKING RESET VALUES OF INTERRUPT STATUS REGISTERS");
 PSR(0x0, MASK_ALL, AACIISR1,AACI1_T40);
 PSR(0x0, MASK_ALL, AACIISR2,AACI1_T41);
 /* Note - Check Expected value */
 PSR(0x0, MASK_ALL, AACIISR3,AACI1_T42);
 PSR(0x0, MASK_ALL, AACIISR4,AACI1_T43);

 /* Check Reset Value of All Channel Interrupt Enable  Reg */
 C("CHECKING RESET VALUES OF INTERRUPT ENABLE REGISTERS");
 PSR(0x0, MASK_ALL, AACIIE1,AACI1_T44);
 PSR(0x0, MASK_ALL, AACIIE2,AACI1_T45);
 PSR(0x0, MASK_ALL, AACIIE3,AACI1_T46);
 PSR(0x0, MASK_ALL, AACIIE4,AACI1_T47);

 /* Check Reset Value of All Slot Reg */

 C("CHECKING RESET VALUES OF SLOT REGISTERS");
 PSR(0x0, MASK_ALL, AACISL1TX,AACI1_T48);
 PSR(0x0, MASK_ALL, AACISL2TX,AACI1_T49);
 PSR(0x0, MASK_ALL, AACISL12TX,AACI1_T50);
 PSR(0x0, MASK_ALL, AACISL1RX,AACI1_T51);
 PSR(0x0, MASK_ALL, AACISL2RX,AACI1_T52);
 PSR(0x0, MASK_ALL, AACISL12RX,AACI1_T53);
 PSR(0x0, MASK_ALL, AACISLISTAT,AACI1_T54);
 PSR(0x0, MASK_ALL, AACISLIEN,AACI1_T55);

 /* Check Reset Value of All DATA Reg */

 C("CHECKING RESET VALUES OF DATA REGISTERS");
 PSR(0x0, MASK_ALL, AACIDR1,AACI1_T56);
 PSR(0x0, MASK_ALL, AACIDR2,AACI1_T57);
 PSR(0x0, MASK_ALL, AACIDR3,AACI1_T58);
 PSR(0x0, MASK_ALL, AACIDR4,AACI1_T59);

 /* Check Reset Value of All Remaining  Reg */

 C("CHECKING RESET VALUES OF OTHER REGISTERS");
 PSR(0x0, MASK_ALL, AACIINTCLR,AACI1_T60);
 PSR(0x0, MASK_ALL, AACIMAINFR,AACI1_T61);
 PSR(0x0, MASK_ALL, AACIMAINCR,AACI1_T62);
 PSR(0x0, MASK_ALL, AACISYNC,AACI1_T63);
 PSR(0x0, MASK_ALL, AACIALLINTS,AACI1_T64);

 /* Check Reset value of INTEGRATION Test Registers */

 C("CHECKING RESET VALUES OF TEST CONTROL REGISTERS");
 PSR(0x0, MASK_ALL, AACITCR,AACI1_T65);
 PSR(RESET_AACIITOP0, MASK_ALL, AACIITOP0,AACI1_T67);
 PSR(0x0, MASK_ALL, AACIITOP1,AACI1_T68);

 /* Check read value of IDENTIFICATION Registers */

 C("CHECKING VALUES OF IDENTIFICATION REGISTERS");
 PSR(EXP_AACIPID0, MASK_AACIPID0, AACIPERIPHID0,PId0_Read);
 PSR(EXP_AACIPID1, MASK_AACIPID1, AACIPERIPHID1,PId1_Read);
 PSR(EXP_AACIPID2, MASK_AACIPID2, AACIPERIPHID2,PId2_Read);
 PSR(EXP_AACIPID3, MASK_AACIPID3, AACIPERIPHID3,PId3_Read);

 C("CHECKING VALUES OF PRIMECELL ID REGISTERS");
 PSR(EXP_AACIPCID0, MASK_AACIPCID0, AACIPCELLID0,PCId0_Read);
 PSR(EXP_AACIPCID1, MASK_AACIPCID1, AACIPCELLID1,PCId1_Read);
 PSR(EXP_AACIPCID2, MASK_AACIPCID2, AACIPCELLID2,PCId2_Read);
 PSR(EXP_AACIPCID3, MASK_AACIPCID3, AACIPCELLID3,PCId3_Read);
 C("RESET VALUE TESTS COMPLETED");
}

/**********************************************************************/
/********************* Register Read-Write Test ***********************/
/**********************************************************************/
void RegisterRdWrTest(void)
{
 /*
   Summary : RegisterRdWrTest
   ==========================
   Read/Write Test
   ---------------
   Read-only registers are checked by writing a value
   other than their reset values and reading back to check whether they
   return the reset values.

   Read-write registers are checked by writing data patterns of
   0x00000000, 0xAAAAAAAA, 0x55555555 and 0xFFFFFFFF and reading back to
   verify that the data that was written is returned.

   Read/Write Test for hardware masked registers :
   Read/Write-ability of registers which are in the AACIBITCLK domain
   and have the hardware masking is tested with RegTest bit set in the
   AACITCR register

   The following registers in the AACI use a two-buffer synchronisation
   technique to synchonise the register contents to the AACIBITCLK
   domain:
     AACITXCR1
     AACITXCR2
     AACITXCR3
     AACITXCR4
   When synchronisation is in progress, any writes to the AACITXCRx
   (x=1-4) are ignored by the AACI i.e. these writes do not update the
   AACITXCRx (x=1-4) registers. This harware masking is verified by
   writing different values on successive APB accesses to each of these
   registers and by reading back the register contents. The register
   read is expected to return the value that was written first to the
   register.

   For the hardware masking test, the RegTest bit is cleared.

 */

 /* Read Only Register */
 /* ================== */

 /* Write 0xAAAAAAAA in Read only Register and Check register should 
    retain reset value  by Reading */  

 C("----------------------------------------------------------------");
 C("THE READ-ONLY REGISTERS TEST ");
 PSW(DATA_As, AACIISR1,AACIISR1T1W);
 PSR(0x0, MASK_ALL, AACIISR1,AACI1_T69);
 PSW(DATA_As, AACIISR2,AACIISR2T1W);
 PSR(0x0, MASK_ALL, AACIISR2,AACI1_T70);
 PSW(DATA_As, AACIISR3, AACIISR1T3W);
 PSR(0x0, MASK_ALL, AACIISR3,AACI1_T71);
 PSW(DATA_As, AACIISR4, AACIISR4T1W);
 PSR(0x0, MASK_ALL, AACIISR4,AACI1_T72);

 PSW(DATA_As, AACISL1RX, AACISL1RXT1W);
 PSR(0x0, MASK_ALL, AACISL1RX,AACI1_T73);
 PSW(DATA_As, AACISL2RX, AACISL2RXT1W);
 PSR(0x0, MASK_ALL, AACISL2RX,AACI1_T74);
 PSW(DATA_As, AACISL12RX,AACISL12RXT1W);
 PSR(0x0, MASK_ALL, AACISL12RX,AACI1_T75);
 PSW(DATA_As, AACISLISTAT,AACISLISTATT1W);
 PSR(0x0, MASK_ALL, AACISLISTAT,AACI1_T76);

 PSW(DATA_As, AACIALLINTS,AACIALLINTST1W);
 PSR(0x0, MASK_ALL, AACIALLINTS,AACI1_T77);

 PSW(DATA_As, AACIMAINFR,AACIMAINFRT1W);
 PSR(0x00, MASK_ALL, AACIMAINFR,AACI1_T78);

 PSW(DATA_As, AACISLFR,AACISLFRT1W);
 PSR(RESET_AACISLFR, MASK_ALL, AACISLFR,AACI1_T79);

 /* Write 0x55555555  in Read only Register and Check register should
    retain reset value,ie 0x00, by Reading */

 PSW(DATA_5s, AACIISR1,AACIISR1T2W);
 PSR(0x0, MASK_ALL, AACIISR1,AACI1_T80);
 PSW(DATA_5s, AACIISR2, AACIISR2T2W);
 PSR(0x0, MASK_ALL, AACIISR2,AACI1_T81);
 PSW(DATA_5s, AACIISR3,AACIISR1T3W);
 PSR(0x0, MASK_ALL, AACIISR3,AACI1_T82);
 PSW(DATA_5s, AACIISR4,AACIISR4T2W);
 PSR(0x0, MASK_ALL, AACIISR4,AACI1_T83);

 PSW(DATA_5s, AACISL1RX,AACISL1RXT2W);
 PSR(0x00,MASK_ALL, AACISL1RX,AACI1_T84);
 PSW(DATA_5s, AACISL2RX,AACISL2RXT2W);
 PSR(0x0, MASK_ALL, AACISL2RX,AACI1_T85);
 PSW(DATA_5s, AACISL12RX,AACISL12RXT2W);
 PSR(0x0, MASK_ALL, AACISL12RX,AACI1_T86);

 PSW(DATA_5s, AACISLISTAT,AACISLISTATT2W);
 PSR(0x0, MASK_ALL, AACISLISTAT,AACI1_T87);

 PSW(DATA_5s, AACIALLINTS,AACIALLINTST2W);
 PSR(0x0, MASK_ALL, AACIALLINTS,AACI1_T88);

 PSW(DATA_5s, AACIMAINFR,AACIMAINFRT2W);
 PSR(0x00, MASK_ALL, AACIMAINFR,AACI1_T89);

 PSW(DATA_5s, AACISLFR,AACISLFRT2W);
 PSR(RESET_AACISLFR, MASK_ALL, AACISLFR,AACI1_T90);

 /* Write 0xFFFFFFFF  in Read only Register and Check register should
    retain reset value,ie 0x00, by Reading */

 PSW(DATA_Fs, AACIISR1,AACIISR1T3W);
 PSR(0x0, MASK_ALL, AACIISR1,AACI1_T91);
 PSW(DATA_Fs, AACIISR2,AACIISR2T3W);
 PSR(0x0, MASK_ALL, AACIISR2,AACI1_T92);
 PSW(DATA_Fs, AACIISR3,AACIISR3T3W);
 PSR(0x0, MASK_ALL, AACIISR3,AACI1_T93);
 PSW(DATA_Fs, AACIISR4,AACIISR4T3W);
 PSR(0x0, MASK_ALL, AACIISR4,AACI1_T94);

 PSW(DATA_Fs, AACISL1RX,AACISL1RXT3W);
 PSR(0x0, MASK_ALL, AACISL1RX,AACI1_T95);
 PSW(DATA_Fs, AACISL2RX,AACISL2RXT3W);
 PSR(0x0, MASK_ALL, AACISL2RX,AACI1_T96);
 PSW(DATA_Fs, AACISL12RX,AACISL12RXT3W);
 PSR(0x0, MASK_ALL, AACISL12RX,AACI1_T97);

 PSW(DATA_Fs, AACISLISTAT,AACISLISTATT3W);
 PSR(0x00, MASK_ALL, AACISLISTAT,AACI1_T98);

 PSW(DATA_Fs, AACIALLINTS,AACIALLINTST3W);
 PSR(0x0, MASK_ALL, AACIALLINTS,AACI1_T99);

 PSW(DATA_Fs, AACIMAINFR,AACIMAINFRT3W);
 PSR(0x00, MASK_ALL, AACIMAINFR,AACI1_T100);

 PSW(DATA_Fs, AACISLFR,AACISLFRT3W);
 PSR(RESET_AACISLFR, MASK_ALL, AACISLFR,AACI1_T101);

 /* Write Only Register */
 /* =================== */
  
 /*  Write Various Data Patterns in WINTCLEAR Reg and read
     should return zero  */

 C("THE WRITE-ONLY REGISTERS TEST ");
 PSW(DATA_As, AACIINTCLR,AACIINTCLR);
 PSR(0x0, MASK_ALL, AACIINTCLR,AACI1_T102);
 PSW(DATA_5s, AACIINTCLR,AACIINTCLR);
 PSR(0x0, MASK_ALL, AACIINTCLR,AACI1_T103);
 PSW(DATA_Fs, AACIINTCLR,AACIINTCLRT4W);
 PSR(0x0, MASK_ALL, AACIINTCLR,AACI1_T105);
 PSW(DATA_0s, AACIINTCLR,AACIINTCLRT3W);
 PSR(0x0, MASK_ALL, AACIINTCLR,AACI1_T104);

 /* Read Write Register */
 /* =================== */

 /* Write Various Data Patterns in Rx Control Reg1 and reading back 
    for expected value */
 /* Reg test mode so as to remove warning messeges */
 PSW(REGTESTMODE, AACITCR);
 C("THE READ-WRITE REGISTERS TEST ");
 PSW(DATA_As, AACIRXCR1,AACIRXCR1T1W);
 PSR(DATA_As & MASK_AACIRXCR, MASK_ALL, AACIRXCR1,AACI1_T106);
 PSW(DATA_5s, AACIRXCR1,AACIRXCR1T2W);
 PSR(DATA_5s & MASK_AACIRXCR, MASK_ALL, AACIRXCR1,AACI1_T107);
 PSW(DATA_Fs, AACIRXCR1,AACIRXCR1T4W);
 PSR(DATA_Fs & MASK_AACIRXCR, MASK_ALL, AACIRXCR1,AACI1_T109);
 PSW(DATA_0s, AACIRXCR1,AACIRXCR1T3W);
 PSR(DATA_0s & MASK_AACIRXCR, MASK_ALL, AACIRXCR1,AACI1_T108);

 /*  Writing Various Data Patterns in Rx Control Reg2 and reading back
     for expected value */

 PSW(DATA_As, AACIRXCR2,AACIRXCR2T1W);
 PSR(DATA_As & MASK_AACIRXCR, MASK_ALL, AACIRXCR2,AACI1_T110);
 PSW(DATA_5s, AACIRXCR2,AACIRXCR2T2W);
 PSR(DATA_5s & MASK_AACIRXCR, MASK_ALL, AACIRXCR2,AACI1_T111);
 PSW(DATA_Fs, AACIRXCR2,AACIRXCR2T4W);
 PSR(DATA_Fs & MASK_AACIRXCR, MASK_ALL, AACIRXCR2,AACI1_T113);
 PSW(DATA_0s, AACIRXCR2,AACIRXCR2T3W);
 PSR(DATA_0s & MASK_AACIRXCR, MASK_ALL, AACIRXCR2,AACI1_T112);

 /*  Writing Various Data Patterns in Rx Control Reg3 and reading back
     for expected value */

 PSW(DATA_As, AACIRXCR3,AACIRXCR3T1W);
 PSR(DATA_As & MASK_AACIRXCR, MASK_ALL, AACIRXCR3,AACI1_T114);
 PSW(DATA_5s, AACIRXCR3,AACIRXCR3T2W);
 PSR(DATA_5s & MASK_AACIRXCR, MASK_ALL, AACIRXCR3,AACI1_T115);
 PSW(DATA_Fs, AACIRXCR3,AACIRXCR3T4W);
 PSR(DATA_Fs & MASK_AACIRXCR, MASK_ALL, AACIRXCR3,AACI1_T117);
 PSW(DATA_0s, AACIRXCR3,AACIRXCR3T3W);
 PSR(DATA_0s & MASK_AACIRXCR, MASK_ALL, AACIRXCR3,AACI1_T116);

 /*  Writing Various Data Patterns in Rx Control Reg4 and reading back
    for expected value */

 PSW(DATA_As, AACIRXCR4,AACIRXCR4T1W);
 PSR(DATA_As & MASK_AACIRXCR, MASK_ALL, AACIRXCR4,AACI1_T118;
 PSW(DATA_5s, AACIRXCR4,AACIRXCR4T2W);
 PSR(DATA_5s & MASK_AACIRXCR, MASK_ALL, AACIRXCR4,AACI1_T119);
 PSW(DATA_Fs, AACIRXCR4,AACIRXCR4T4W);
 PSR(DATA_Fs & MASK_AACIRXCR, MASK_ALL, AACIRXCR4,AACI1_T121);
 PSW(DATA_0s, AACIRXCR4,AACIRXCR4T3W);
 PSR(DATA_0s & MASK_AACIRXCR, MASK_ALL, AACIRXCR4,AACI1_T120);

 /*  Writing Various Data Patterns in Tx Control Reg1 and reading back
     for expected value */

 /* The testing the registers in the test mode */
 PSW(REGTESTMODE, AACITCR);
 C(" TESTING READ WRITE IN THE REGISTER TEST MODE ");
 PSW(DATA_As, AACITXCR1,AACITXCR1T1W);
 PSR(DATA_As & MASK_AACITXCR, MASK_ALL, AACITXCR1,AACI1_T122);
 PSW(DATA_5s, AACITXCR1,AACITXCR1T2W);
 PSR(DATA_5s & MASK_AACITXCR, MASK_ALL, AACITXCR1,AACI1_T123);
 PSW(DATA_Fs, AACITXCR1,AACITXCR1T4W);
 PSR(DATA_Fs & MASK_AACITXCR, MASK_ALL, AACITXCR1,AACI1_T125);
 PSW(DATA_0s, AACITXCR1,AACITXCR1T3W);
 PSR(DATA_0s & MASK_AACITXCR, MASK_ALL, AACITXCR1,AACI1_T124);

 /*  Writing Various Data Patterns in Tx Control Reg2 and reading back
    for expected value */

 PSW(DATA_As, AACITXCR2,AACITXCR2T1W);
 PSR(DATA_As & MASK_AACITXCR, MASK_ALL, AACITXCR2,AACI1_T126);
 PSW(DATA_5s, AACITXCR2,AACITXCR2T2W);
 PSR(DATA_5s & MASK_AACITXCR, MASK_ALL, AACITXCR2,AACI1_T127);
 PSW(DATA_Fs, AACITXCR2,AACITXCR2T4W);
 PSR(DATA_Fs & MASK_AACITXCR, MASK_ALL, AACITXCR2,AACI1_T129);
 PSW(DATA_0s, AACITXCR2,AACITXCR2T3W);
 PSR(DATA_0s & MASK_AACITXCR, MASK_ALL, AACITXCR2,AACI1_T128);


 /*  Writing Various Data Patterns in Tx Control Reg3 and reading back
     for expected value */

 PSW(DATA_As, AACITXCR3,AACITXCR3T1W);
 PSR(DATA_As & MASK_AACITXCR, MASK_ALL, AACITXCR3,AACI1_T130);
 PSW(DATA_5s, AACITXCR3,AACITXCR3T2W);
 PSR(DATA_5s & MASK_AACITXCR, MASK_ALL, AACITXCR3,AACI1_T131);
 PSW(DATA_Fs, AACITXCR3,AACITXCR3T4W);
 PSR(DATA_Fs & MASK_AACITXCR, MASK_ALL, AACITXCR3,AACI1_T133);
 PSW(DATA_0s, AACITXCR3,AACITXCR3T3W);
 PSR(DATA_0s & MASK_AACITXCR, MASK_ALL, AACITXCR3,AACI1_T132);

 /*  Writing Various Data Patterns in Tx Control Reg4 and reading back
     for expected value */

 PSW(DATA_As, AACITXCR4,AACITXCR4T1W);
 PSR(DATA_As & MASK_AACITXCR, MASK_ALL, AACITXCR4,AACI1_T134);
 PSW(DATA_5s, AACITXCR4,AACITXCR4T2W);
 PSR(DATA_5s & MASK_AACITXCR, MASK_ALL, AACITXCR4,AACI1_T135);
 PSW(DATA_Fs, AACITXCR4,AACITXCR4T4W);
 PSR(DATA_Fs & MASK_AACITXCR, MASK_ALL, AACITXCR4,AACI1_T137);
 PSW(DATA_0s, AACITXCR4,AACITXCR4T3W);
 PSR(DATA_0s & MASK_AACITXCR, MASK_ALL, AACITXCR4,AACI1_T136);

 /*  Writing Various Data Patterns in Status  Reg1 and reading back for
     expected value */

 PSW(DATA_As, AACISR1,AACISR1T1W);
 PSR(RESET_AACISR, MASK_ALL, AACISR1,AACI1_T138);
 PSW(DATA_5s, AACISR1,AACISR1T2W);
 PSR(RESET_AACISR, MASK_ALL, AACISR1,AACI1_T139);
 PSW(DATA_0s, AACISR1,AACISR1T3W);
 PSR(RESET_AACISR, MASK_ALL, AACISR1,AACI1_T140);
 PSW(DATA_Fs, AACISR1,AACISR1T4W);
 PSR(RESET_AACISR, MASK_ALL, AACISR1,AACI1_T141);

 /*  Writing Various Data Patterns in Status  Reg2 and reading back for
     expected value */

 PSW(DATA_As, AACISR2,AACISR2T1W);
 PSR(RESET_AACISR, MASK_ALL, AACISR2,AACI1_T142);
 PSW(DATA_5s, AACISR2,AACISR2T2W);
 PSR(RESET_AACISR, MASK_ALL, AACISR2,AACI1_T143);
 PSW(DATA_0s, AACISR2, AACISR2T3W);
 PSR(RESET_AACISR, MASK_ALL, AACISR2,AACI1_T144);
 PSW(DATA_Fs, AACISR2,AACISR2T4W);
 PSR(RESET_AACISR, MASK_ALL, AACISR2,AACI1_T145);

 /* Writing Various Data Patterns in Status  Reg3 and reading back for
     expected value */

 PSW(DATA_As, AACISR3,AACISR3T1W);
 PSR(RESET_AACISR, MASK_ALL, AACISR3,AACI1_T146);
 PSW(DATA_5s, AACISR3,AACISR3T2W);
 PSR(RESET_AACISR, MASK_ALL, AACISR3,AACI1_T147);
 PSW(DATA_0s, AACISR3,AACISR3T3W);
 PSR(RESET_AACISR, MASK_ALL, AACISR3,AACI1_T148);
 PSW(DATA_Fs, AACISR3,AACISR3T4W);
 PSR(RESET_AACISR, MASK_ALL, AACISR3,AACI1_T149);

 /*  Writing Various Data Patterns in Status  Reg4 and reading back for
     expected value */

 PSW(DATA_As, AACISR4,AACISR4T1W);
 PSR(RESET_AACISR, MASK_ALL, AACISR4,AACI1_T150);
 PSW(DATA_5s, AACISR4,AACISR4T2W);
 PSR(RESET_AACISR, MASK_ALL, AACISR4,AACI1_T151);
 PSW(DATA_0s, AACISR4,AACISR4T3W);
 PSR(RESET_AACISR, MASK_ALL, AACISR4,AACI1_T152);
 PSW(DATA_Fs, AACISR4,AACISR4T4W);
 PSR(RESET_AACISR, MASK_ALL, AACISR4,AACI1_T153);

 /* Writing Various Data Patterns in Interrupt Enable  Reg1 and 
    reading back for expected value */

 PSW(DATA_As, AACIIE1,AACIIE1T1W);
 PSR(DATA_As & MASK_AACIIE, MASK_ALL, AACIIE1,AACI1_T154);
 PSW(DATA_5s, AACIIE1,AACIIE1T2W);
 PSR(DATA_5s & MASK_AACIIE, MASK_ALL, AACIIE1,AACI1_T155);
 PSW(DATA_Fs, AACIIE1,AACIIE1T4W);
 PSR(DATA_Fs & MASK_AACIIE, MASK_ALL, AACIIE1,AACI1_T157);
 PSW(DATA_0s, AACIIE1,AACIIE1T3W);
 PSR(DATA_0s & MASK_AACIIE, MASK_ALL, AACIIE1,AACI1_T156);

 /*  Writing Various Data Patterns in Interrupt Enable  Reg2 and 
    reading back for expected value */

 PSW(DATA_As, AACIIE2,AACIIE2T1W);
 PSR(DATA_As & MASK_AACIIE, MASK_ALL, AACIIE2,AACI1_T158);
 PSW(DATA_5s, AACIIE2,AACIIE2T2W);
 PSR(DATA_5s & MASK_AACIIE, MASK_ALL, AACIIE2,AACI1_T159);
 PSW(DATA_Fs, AACIIE2,AACIIE2T4W);
 PSR(DATA_Fs & MASK_AACIIE, MASK_ALL, AACIIE2,AACI1_T161);
 PSW(DATA_0s, AACIIE2,AACIIE2T3W);
 PSR(DATA_0s & MASK_AACIIE, MASK_ALL, AACIIE2,AACI1_T160);

 /*  Writing Various Data Patterns in Interrupt Enable  Reg3 and 
     reading back for expected value */

 PSW(DATA_As, AACIIE3,AACIIE3T1W);
 PSR(DATA_As & MASK_AACIIE, MASK_ALL, AACIIE3,AACI1_T162);
 PSW(DATA_5s, AACIIE3,AACIIE3T2W);
 PSR(DATA_5s & MASK_AACIIE, MASK_ALL, AACIIE3,AACI1_T163);
 PSW(DATA_Fs, AACIIE3,AACIIE3T4W);
 PSR(DATA_Fs & MASK_AACIIE, MASK_ALL, AACIIE3,AACI1_T165);
 PSW(DATA_0s, AACIIE3,AACIIE3T3W);
 PSR(DATA_0s & MASK_AACIIE, MASK_ALL, AACIIE3,AACI1_T164);

 /* Writing Various Data Patterns in Interrupt Enable  Reg4 and
    reading back for expected value */

 PSW(DATA_As, AACIIE4,AACIIE4T1W);
 PSR(DATA_As & MASK_AACIIE, MASK_ALL, AACIIE4,AACI1_T166);
 PSW(DATA_5s, AACIIE4,AACIIE4T2W);
 PSR(DATA_5s & MASK_AACIIE, MASK_ALL, AACIIE4,AACI1_T167);
 PSW(DATA_Fs, AACIIE4,AACIIE4T4W);
 PSR(DATA_Fs & MASK_AACIIE, MASK_ALL, AACIIE4,AACI1_T169);
 PSW(DATA_0s, AACIIE4,AACIIE4T3W);
 PSR(DATA_0s & MASK_AACIIE, MASK_ALL, AACIIE4,AACI1_T168);

 /*  Writing Various Data Patterns in Slot1 Tx  Reg and reading back
     for expected value */

 PSW(REGTESTMODE, AACITCR);
 PSW(DATA_As, AACISL1TX,AACISL1TXT1W);
 PSR(DATA_As & MASK_AACISL1TX, MASK_ALL, AACISL1TX,AACI1_T170);
 PSW(DATA_5s, AACISL1TX,AACISL1TXT2W);
 PSR(DATA_5s & MASK_AACISL1TX, MASK_ALL, AACISL1TX,AACI1_T171);
 PSW(DATA_Fs, AACISL1TX,AACISL1TXT4W);
 PSR(DATA_Fs & MASK_AACISL1TX, MASK_ALL, AACISL1TX,AACI1_T173);
 PSW(DATA_0s, AACISL1TX,AACISL1TXT3W);
 PSR(DATA_0s & MASK_AACISL1TX, MASK_ALL, AACISL1TX,AACI1_T172);

 /*  Writing Various Data Patterns in Slot2 Tx  Reg and reading back
     for expected value */

 PSW(DATA_As, AACISL2TX,AACISL2TXT1W);
 PSR(DATA_As & MASK_AACISL1TX, MASK_ALL, AACISL2TX,AACI1_T174);
 PSW(DATA_5s, AACISL2TX,AACISL2TXT2W);
 PSR(DATA_5s & MASK_AACISL1TX, MASK_ALL, AACISL2TX,AACI1_T175);
 PSW(DATA_Fs, AACISL2TX,AACISL2TXT4W);
 PSR(DATA_Fs & MASK_AACISL1TX, MASK_ALL, AACISL2TX,AACI1_T177);
 PSW(DATA_0s, AACISL2TX,AACISL2TXT3W);
 PSR(DATA_0s & MASK_AACISL1TX, MASK_ALL, AACISL2TX,AACI1_T176);

 /*  Writing Various Data Patterns in Slot12 Tx  Reg and reading back
     for expected value */

 PSW(DATA_As, AACISL12TX,AACISL12TXT1W);
 PSR(DATA_As & MASK_AACISL1TX, MASK_ALL, AACISL12TX,AACI1_T178);
 PSW(DATA_5s, AACISL12TX,AACISL12TXT2W);
 PSR(DATA_5s & MASK_AACISL1TX, MASK_ALL, AACISL12TX,AACI1_T179);
 PSW(DATA_Fs, AACISL12TX,AACISL12TXT4W);
 PSR(DATA_Fs & MASK_AACISL1TX, MASK_ALL, AACISL12TX,AACI1_T181);
 PSW(DATA_0s, AACISL12TX,AACISL12TXT3W);
 PSR(DATA_0s & MASK_AACISL1TX, MASK_ALL, AACISL12TX,AACI1_T180);
 PSW(NORMALMODE, AACITCR);

 /*  Writing Various Data Patterns in Slot Interrupt Enable Reg and 
     reading back for expected value */

 PSW(DATA_As, AACISLIEN,AACISLIENT1W);
 PSR(DATA_As & MASK_AACISLIEN, MASK_ALL, AACISLIEN,AACI1_T182);
 PSW(DATA_5s, AACISLIEN,AACISLIENT2W);
 PSR(DATA_5s & MASK_AACISLIEN, MASK_ALL, AACISLIEN,AACI1_T183);
 PSW(DATA_Fs, AACISLIEN,AACISLIENT4W);
 PSR(DATA_Fs & MASK_AACISLIEN, MASK_ALL, AACISLIEN,AACI1_T185);
 PSW(DATA_0s, AACISLIEN,AACISLIENT3W);
 PSR(DATA_0s & MASK_AACISLIEN, MASK_ALL, AACISLIEN,AACI1_T184);

 /*  Writing Various Data Patterns in AACMAINCR  Reg and reading back
     for expected value */

 PSW(DATA_As, AACIMAINCR,AACIMAINCRT1W);
 PSR(DATA_As & MASK_AACIMAINCR, MASK_ALL, AACIMAINCR,AACI1_T186);
 PSW(DATA_5s, AACIMAINCR,AACIMAINCRT2W);
 PSR(DATA_5s & MASK_AACIMAINCR, MASK_ALL, AACIMAINCR,AACI1_T187);

 /*  Writing Various Data Patterns in AACIRESET  Reg and reading back
     for expected value */

 PSW(DATA_As, AACIRESET,AACIRESETT1W);
 PSR(DATA_As & MASK_AACIRESET, MASK_ALL, AACIRESET,AACI1_T190);
 PSW(DATA_5s, AACIRESET,AACIRESETT2W);
 PSR(DATA_5s & MASK_AACIRESET, MASK_ALL, AACIRESET,AACI1_T191);
 PSW(DATA_Fs, AACIRESET,AACIRESETT4W);
 PSR(DATA_Fs & MASK_AACIRESET, MASK_ALL, AACIRESET,AACI1_T193);
 PSW(DATA_0s, AACIRESET,AACIRESETT3W);
 PSR(DATA_0s & MASK_AACIRESET, MASK_ALL, AACIRESET,AACI1_T192);

 /*  Writing Various Data Patterns in AACISYNC  Reg and reading back
     for expected value */

 PSW(DATA_As, AACISYNC,AACISYNCT1W);
 PSR(DATA_As & MASK_AACISYNC, MASK_ALL, AACISYNC,AACI1_T194);
 PSW(DATA_5s, AACISYNC,AACISYNCT2W);
 PSR(DATA_5s & MASK_AACISYNC, MASK_ALL, AACISYNC,AACI1_T195);
 PSW(DATA_Fs, AACISYNC,AACISYNCT4W);
 PSR(DATA_Fs & MASK_AACISYNC, MASK_ALL, AACISYNC,AACI1_T197);
 PSW(DATA_0s, AACISYNC,AACISYNCT3W);
 PSR(DATA_0s & MASK_AACISYNC, MASK_ALL, AACISYNC,AACI1_T196);


 /* AACI INTREGRATION Register Check */
 /* ================================ */

 /*  Writing Various Data Patterns in AACITCR  Reg and reading back
     for expected value */

 C("INTEGRATION TEST CONTROL REGISTER READ-WRITE TESTS ");
 PSW(DATA_As, AACITCR,AACITCRT1W);
 PSR(DATA_As & MASK_AACITCR, MASK_ALL, AACITCR,AACI1_T198);
 PSW(DATA_5s, AACITCR,AACITCRT2W);
 PSR(DATA_5s & MASK_AACITCR, MASK_ALL, AACITCR,AACI1_T199);
 PSW(DATA_Fs, AACITCR,AACITCRT4W);
 PSR(DATA_Fs & MASK_AACITCR, MASK_ALL, AACITCR,AACI1_T201);
 PSW(DATA_0s, AACITCR,AACITCRT3W);
 PSR(DATA_0s & MASK_AACITCR, MASK_ALL, AACITCR,AACI1_T200);

 /*  Writing Various Data Patterns in AACIITOP0  Reg and reading back
     for expected value */

 PSW(0x01, AACITCR);
 C("INTEGRATION TEST OUTPUT REGISTER 0 READ-WRITE TEST ");
 PSW(DATA_As, AACIITOP0,AACIITOP0T1W);
 PSR(DATA_As & MASK_AACIITOP0, MASK_ALL, AACIITOP0,AACI1_T206);
 PSW(DATA_5s, AACIITOP0,AACIITOP0T2W);
 PSR(DATA_5s & MASK_AACIITOP0, MASK_ALL, AACIITOP0,AACI1_T207);
 PSW(DATA_Fs, AACIITOP0,AACIITOP0T4W);
 PSR(DATA_Fs & MASK_AACIITOP0, MASK_ALL, AACIITOP0,AACI1_T209);
 PSW(DATA_0s, AACIITOP0,AACIITOP0T3W);
 PSR(DATA_0s & MASK_AACIITOP0, MASK_ALL, AACIITOP0,AACI1_T208);

 /*  Writing Various Data Patterns in AACIITOP1  Reg and reading back
     for expected value */

 C("INTEGRATION TEST OUTPUT REGISTER 1 READ-WRITE TEST ");
 PSW(DATA_As, AACIITOP1,AACIITOP1T1W);
 PSR(DATA_As & MASK_AACIITOP1, MASK_ALL, AACIITOP1,AACI1_T210);
 PSW(DATA_5s, AACIITOP1,AACIITOP1T2W);
 PSR(DATA_5s & MASK_AACIITOP1, MASK_ALL, AACIITOP1,AACI1_T211);
 PSW(DATA_Fs, AACIITOP1,AACIITOP1T4W);
 PSR(DATA_Fs & MASK_AACIITOP1, MASK_ALL, AACIITOP1,AACI1_T213);
 PSW(DATA_0s, AACIITOP1,AACIITOP1T3W);
 PSR(DATA_0s & MASK_AACIITOP1, MASK_ALL, AACIITOP1,AACI1_T212);

 C("WRITING '1' TO AACIRESET AND '0' TO AACISYNC REG");
 PSW(0x0, AACISYNC);
 PSW(RESET_AACIRESET, AACIRESET);

 /* Disbabling all the channels  for all the slots */
 PSW(0x0, AACITXCR1,AACITXCR1T1W);
 PSW(0x0, AACITXCR2,AACITXCR2T2W);
 PSW(0x0, AACITXCR3,AACITXCR2T3W);
 PSW(0x0, AACITXCR4,AACITXCR2T4W);

 C("----------------------------------------------------------------");
}
