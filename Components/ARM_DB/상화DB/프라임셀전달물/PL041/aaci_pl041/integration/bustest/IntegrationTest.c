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
-- File Name              : IntegrationTest.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
--  Purpose : 
--            Function to verify that the AACI has been wired into the
--            system correctly. SCAN-related ports are not tested
--            for connectivity.
--
-- --=================================================================*/
 
/**********************************************************************/
/************************* Function declarations **********************/
/**********************************************************************/
void ValidTransferTest(void);
void Idle(unsigned long time);

/**********************************************************************/
/************************** Integration Test **************************/
/**********************************************************************/
void IntegrationTest(void)
{
 /*
   Summary : IntegrationTest
   =========================

   When the AACI is used in an AMBA system, it must be ensured that
   all of its pins are correctly connected. Integration vectors
   allow the user to verify that the AACI has been wired into the
   system correctly. SCAN-related ports are not tested for connectivity.

   Integration testing of primary inputs and outputs 
   -------------------------------------------------
   The connectivity of primary outputs and inputs are checked by looping
   the primary outputs back onto primary inputs through the Integration
   test trickbox. '1's and '0's are driven on the primary outputs 
   through the AACIITOP registers and read via the AACIITIP register.

   The Integration trickbox ORs the all primary outputs of the AACI 
   (AACISYNC, AACIRESET and AACISDATAOUT) and feeds back to the primary
   input (AACISDATAIN) of the AACI.

   Clock inputs signals: 
   The connectivity of the AACIBITCLK input signal is tested indirectly
   by initiating data transfers in the loopback mode.

   Integration testing of Intra-Chip output and input signals
   ----------------------------------------------------------
   The test sequence to test intra-chip outputs is as follows:
     - Write a 1 to the ITEN bit in the AACIITCR Control register. This
       selects the test path from the AACIITOP[1:0] register bits.
     - Write a 1 and then a 0 to the AACIITOP[1:0] register bits and
       read the same register bit to ensure that the value written is
       read out.

   NOTE : When the tests are run in an integrated system, the user is
          expected to replace the read commands from the AACIITOP 
          registers with suitable commands to read the values on 
          respective lines through the destination peripherals 
          (e.g.DMA Controller/ Interrupt Controller)
          Code sections requiring such user modifications have
          been marked with the string 'NOTE'.

   The test sequence to test intra-chip inputs is as follows:
     - Write a 1 to the ITEN bit in the AACIITCR Control register. This
       selects the test path from the AACIITIP[1:0] register bits.
     - Write a 1 and then a 0 to the AACIITIP[1:0] register bits and 
       read the same register bit to ensure that the value written is 
       read out.

   NOTE : When the tests are run in an integrated system, the user is
          expected to replace the write commands to the AACIITIP 
          register with suitable commands to write the values on the 
          respective lines through the source peripherals (e.g.DMA 
          Controller).
          ** When the intra-chip inputs are tested in an integrated
          system, the ITEN bit in the AACITCR register has to be 
          cleared.
          Code sections requiring such user modifications have
          been marked with the string 'NOTE'.

 */
 int One_BitClk_Period;

 One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   One_BitClk_Period = 1;

 RES(LOW,0x1,0x2);
 PI(0x03);
 PI(One_BitClk_Period * 2);
 
 /* Disabling the the AACI */
 PSW(0x0, AACIMAINCR);

 /* Switch to Integration test mode */
 PSW(ITEN, AACITCR,TestMode_Enable);

/**********************************************************************/
/*** Integration testing of Primary inputs and outputs              ***/
/**********************************************************************/

 /* Ensure that the other inputs to the OR gate in the trickbox are 
    zero */
 PSW(AACI_FORCEDRESET0,AACIRESET,FORCEDRESET);
 PSW(AACI_FORCEDSYNC0, AACISYNC);
 PI(One_BitClk_Period * 2);

 C("TESTING CONNECTIVITY OF PRIMARY I/P AND O/P PORTS ");
 C("TESTING CONNECTIVITY OF 'AACISDATAOUT'");

 /* Writing '1' to AACISDATAOUT */
 PSW(AACI_ITOSDATAOUT, AACIITOP0, Sdataout_write_1);

 /* Reading AACISDATAIN value */
 PSR(AACI_ITISDATAIN, AACI_ITISDATAIN, AACIITIP,Sdataout_Rd_1);

 /* Writing '0' to AACISDATAOUT */
 PSW(0x0, AACIITOP0, Sdataout_write_1);

 /* Reading AACISDATAIN value */
 PSR(0x0, AACI_ITISDATAIN, AACIITIP,Sdataout_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRESET'");

 /* Writing the  FORCEDRESET bit with value 1 */
 PSW(AACI_FORCEDRESET1,AACIRESET,FORCEDRESET);

 /* Reading AACISDATAIN value */
 PSR(AACI_ITISDATAIN, AACI_ITISDATAIN, AACIITIP,Reset_Rd_1);

 /* Writing the  FORCEDSYNC bit with value 0 */
 PSW(AACI_FORCEDRESET0,AACIRESET,FORCEDRESET);

 /* Reading AACISDATAIN value */
 PSR(0x0, AACI_ITISDATAIN, AACIITIP,Reset_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACISYNC'");

 /* Writing the  FORCEDSYNC bit with value 1 */
 PSW(AACI_FORCEDSYNC1, AACISYNC);

 /* Reading AACISDATAIN value */
 PSR(AACI_ITISDATAIN, AACI_ITISDATAIN, AACIITIP,SyncRd_1);

 /* Writing the  FORCEDSYNC bit with value 0 */
 PSW(0x0, AACISYNC);

 /* Reading AACISDATAIN value */
 PSR(0x0, AACI_ITISDATAIN, AACIITIP,SyncRd_0);

 C("END OF INTEGRATION TEST FOR PRIMARY INPUTS AND OUTPUTS ");

 /* Verify connectivity of AACIBITCLK primary input through 
    data transfers in the loopback mode */
 ValidTransferTest();

/**********************************************************************/
/*** Integration testing of Intra-Chip output signals               ***/
/**********************************************************************/

 C("TESTING CONNECTIVITY OF INTRA-CHIP OUTPUTS ");

 /* Switch to Integration test mode */
 PSW(ITEN, AACITCR,TestMode_Enable);

 /* Write '1's and '0's into the AACIITOP register and read back to
    verify connectivity */
 /* NOTE : When the tests are run in an integrated system, the user is
           expected to replace the read commands from the AACIITOP 
           registers with suitable commands to read the values on 
           respective lines through the destination peripherals 
           (e.g.DMA Controller/ Interrupt Controller)
 */

 C("TESTING CONNECTIVITY OF 'AACIDMABREQTX'");
 PSW(AACI_ITODMBRQTX, AACIITOP0, DmaReqTx_write_1);
 PSR(AACI_ITODMBRQTX, MASK_ALL, AACIITOP0,DmaReqTx_Rd_1);
 PSW(0x0, AACIITOP0, DmaReqTx_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,DmaReqTx_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIDMASREQRX'");
 PSW(AACI_ITODMSRQRX, AACIITOP0, DmaSReqRx_write_1);
 PSR(AACI_ITODMSRQRX, MASK_ALL, AACIITOP0,DmaSReqRx_Rd_1);
 PSW(0x0, AACIITOP0, DmaSReqRx_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,DmaSReqRx_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIDMABREQRX'");
 PSW(AACI_ITODMBRQRX, AACIITOP0, DmaBReqRx_write_1);
 PSR(AACI_ITODMBRQRX, MASK_ALL, AACIITOP0,DmaBReqRx_Rd_1);
 PSW(0x0, AACIITOP0, DmaLSReqRx_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,DmaLSReqRx_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIDMALSREQRX'");
 PSW(AACI_ITODMLSRQ, AACIITOP0, DmaLSReqRx_write_1);
 PSR(AACI_ITODMLSRQ, MASK_ALL, AACIITOP0,DmaLSReqRx_Rd_1);
 PSW(0x0, AACIITOP0, DmaLBReqRx_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,DmaLBReqRx_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIDMALBREQRX'");
 PSW(AACI_ITODMLBRQ, AACIITOP0, DmaLBReqRx_write_1);
 PSR(AACI_ITODMLBRQ, MASK_ALL, AACIITOP0,DmaLBReqRx_Rd_1);
 PSW(0x0, AACIITOP0, DmaLBReqRx_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,DmaLBReqRx_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXINTR1'");
 PSW(AACI_ITORXINTR1, AACIITOP0, RxIntr1_write_1);
 PSR(AACI_ITORXINTR1, MASK_ALL, AACIITOP0,RxIntr1_Rd_1);
 PSW(0x0, AACIITOP0, RxIntr1_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,RxIntr1_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXINTR2'");
 PSW(AACI_ITORXINTR2, AACIITOP0, RxIntr2_write_1);
 PSR(AACI_ITORXINTR2, MASK_ALL, AACIITOP0,RxIntr2_Rd_1);
 PSW(0x0, AACIITOP0, RxIntr2_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,RxIntr2_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXINTR3'");
 PSW(AACI_ITORXINTR3, AACIITOP0, RxIntr3_write_1);
 PSR(AACI_ITORXINTR3, MASK_ALL, AACIITOP0,RxIntr3_Rd_1);
 PSW(0x0, AACIITOP0, RxIntr3_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,RxIntr3_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXINTR4'");
 PSW(AACI_ITORXINTR4, AACIITOP0, RxIntr4_write_1);
 PSR(AACI_ITORXINTR4, MASK_ALL, AACIITOP0,RxIntr4_Rd_1);
 PSW(0x0, AACIITOP0, RxIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,RxIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACITXINTR1'");
 PSW(AACI_ITOTXINTR1, AACIITOP0, TxIntr1_write_1);
 PSR(AACI_ITOTXINTR1, MASK_ALL, AACIITOP0,TxIntr1_Rd_1);
 PSW(0x0, AACIITOP0, TxIntr1_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TxIntr1_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACITXINTR2'");
 PSW(AACI_ITOTXINTR2, AACIITOP0, TxIntr2_write_1);
 PSR(AACI_ITOTXINTR2, MASK_ALL, AACIITOP0,TxIntr2_Rd_1);
 PSW(0x0, AACIITOP0, TxIntr2_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TxIntr2_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACITXINTR3'");
 PSW(AACI_ITOTXINTR3, AACIITOP0, TxIntr3_write_1);
 PSR(AACI_ITOTXINTR3, MASK_ALL, AACIITOP0,TxIntr3_Rd_1);
 PSW(0x0, AACIITOP0, TxIntr3_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TxIntr3_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACITXINTR4'");
 PSW(AACI_ITOTXINTR4, AACIITOP0, TxIntr4_write_1);
 PSR(AACI_ITOTXINTR4, MASK_ALL, AACIITOP0,TxIntr4_Rd_1);
 PSW(0x0, AACIITOP0, TxIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TxIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIORINTR1'");
 PSW(AACI_ITOORINTR1, AACIITOP0, ORIntr1_write_1);
 PSR(AACI_ITOORINTR1, MASK_ALL, AACIITOP0,ORIntr1_Rd_1);
 PSW(0x0, AACIITOP0, ORIntr1_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,ORIntr1_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIORINTR2'");
 PSW(AACI_ITOORINTR2, AACIITOP0, ORIntr2_write_1);
 PSR(AACI_ITOORINTR2, MASK_ALL, AACIITOP0,ORIntr2_Rd_1);
 PSW(0x0, AACIITOP0, ORIntr2_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,ORIntr2_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIORINTR3'");
 PSW(AACI_ITOORINTR3, AACIITOP0, ORIntr3_write_1);
 PSR(AACI_ITOORINTR3, MASK_ALL, AACIITOP0,ORIntr3_Rd_1);
 PSW(0x0, AACIITOP0, ORIntr3_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,ORIntr3_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIORINTR4'");
 PSW(AACI_ITOORINTR4, AACIITOP0, ORIntr4_write_1);
 PSR(AACI_ITOORINTR4, MASK_ALL, AACIITOP0,ORIntr4_Rd_1);
 PSW(0x0, AACIITOP0, ORIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,ORIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIURINTR1'");
 PSW(AACI_ITOURINTR1, AACIITOP0, URIntr1_write_1);
 PSR(AACI_ITOURINTR1, MASK_ALL, AACIITOP0,URIntr1_Rd_1);
 PSW(0x0, AACIITOP0, URIntr1_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,URIntr1_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIURINTR2'");
 PSW(AACI_ITOURINTR2, AACIITOP0, URIntr2_write_1);
 PSR(AACI_ITOURINTR2, MASK_ALL, AACIITOP0,URIntr2_Rd_1);
 PSW(0x0, AACIITOP0, URIntr2_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,URIntr2_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIURINTR3'");
 PSW(AACI_ITOURINTR3, AACIITOP0, URIntr3_write_1);
 PSR(AACI_ITOURINTR3, MASK_ALL, AACIITOP0,URIntr3_Rd_1);
 PSW(0x0, AACIITOP0, URIntr3_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,URIntr3_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIURINTR4'");
 PSW(AACI_ITOURINTR4, AACIITOP0, URIntr4_write_1);
 PSR(AACI_ITOURINTR4, MASK_ALL, AACIITOP0,URIntr4_Rd_1);
 PSW(0x0, AACIITOP0, URIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,URIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXTOINTR1'");
 PSW(AACI_ITOTOINTR1, AACIITOP0, TOIntr1_write_1);
 PSR(AACI_ITOTOINTR1, MASK_ALL, AACIITOP0,TOIntr1_Rd_1);
 PSW(0x0, AACIITOP0, TOIntr1_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TOIntr1_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXTOINTR2'");
 PSW(AACI_ITOTOINTR2, AACIITOP0, TOIntr2_write_1);
 PSR(AACI_ITOTOINTR2, MASK_ALL, AACIITOP0,TOIntr2_Rd_1);
 PSW(0x0, AACIITOP0, TOIntr2_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TOIntr2_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXTOINTR3'");
 PSW(AACI_ITOTOINTR3, AACIITOP0, TOIntr3_write_1);
 PSR(AACI_ITOTOINTR3, MASK_ALL, AACIITOP0,TOIntr3_Rd_1);
 PSW(0x0, AACIITOP0, TOIntr3_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TOIntr3_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXTOINTR4'");
 PSW(AACI_ITOTOINTR4, AACIITOP0, TOIntr4_write_1);
 PSR(AACI_ITOTOINTR4, MASK_ALL, AACIITOP0,TOIntr4_Rd_1);
 PSW(0x0, AACIITOP0, TOIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TOIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACITXCINTR1'");
 PSW(AACI_ITOTCINTR1, AACIITOP0, TCIntr1_write_1);
 PSR(AACI_ITOTCINTR1, MASK_ALL, AACIITOP0,TCIntr1_Rd_1);
 PSW(0x0, AACIITOP0, TCIntr1_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TOIntr1_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACITXCINTR2'");
 PSW(AACI_ITOTCINTR2, AACIITOP0, TCIntr2_write_1);
 PSR(AACI_ITOTCINTR2, MASK_ALL, AACIITOP0,TCIntr2_Rd_1);
 PSW(0x0, AACIITOP0, TCIntr2_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TCIntr2_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACITXCINTR3'");
 PSW(AACI_ITOTCINTR3, AACIITOP0, TCIntr3_write_1);
 PSR(AACI_ITOTCINTR3, MASK_ALL, AACIITOP0,TCIntr3_Rd_1);
 PSW(0x0, AACIITOP0, TCIntr3_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TCIntr3_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACITXCINTR4'");
 PSW(AACI_ITOTCINTR4, AACIITOP0, TCIntr4_write_1);
 PSR(AACI_ITOTCINTR4, MASK_ALL, AACIITOP0,TCIntr4_Rd_1);
 PSW(0x0, AACIITOP0, TCIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP0,TCIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXTOFEINTR1'");
 PSW(AACI_ITOTOFEINT1, AACIITOP1, TOFEIntr1_write_1);
 PSR(AACI_ITOTOFEINT1, MASK_ALL, AACIITOP1,TOFEIntr1_Rd_1);
 PSW(0x0, AACIITOP1, TOFEIntr1_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,TOFEIntr1_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXTOFEINTR2'");
 PSW(AACI_ITOTOFEINT2, AACIITOP1, TOFEIntr2_write_1);
 PSR(AACI_ITOTOFEINT2, MASK_ALL, AACIITOP1,TOFEIntr2_Rd_1);
 PSW(0x0, AACIITOP1, TOFEIntr2_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,TOFEIntr2_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXTOFEINTR3'");
 PSW(AACI_ITOTOFEINT3, AACIITOP1, TOFEIntr3_write_1);
 PSR(AACI_ITOTOFEINT3, MASK_ALL, AACIITOP1,TOFEIntr3_Rd_1);
 PSW(0x0, AACIITOP1, TOFEIntr3_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,TOFEIntr3_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIRXTOFEINTR4'");
 PSW(AACI_ITOTOFEINT4, AACIITOP1, TOFEIntr4_write_1);
 PSR(AACI_ITOTOFEINT4, MASK_ALL, AACIITOP1,TOFEIntr4_Rd_1);
 PSW(0x0, AACIITOP1, TOFEIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,TOFEIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIWINTR'");
 PSW(AACI_ITOWINTR, AACIITOP1, WIntr4_write_1);
 PSR(AACI_ITOWINTR, MASK_ALL, AACIITOP1,WIntr4_Rd_1);
 PSW(0x0, AACIITOP1, WIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,WIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIGPIOINTR'");
 PSW(AACI_ITOGPIOINTR, AACIITOP1, GPIOIntr4_write_1);
 PSR(AACI_ITOGPIOINTR, MASK_ALL, AACIITOP1,GPIOIntr4_Rd_1);
 PSW(0x0, AACIITOP1, GPIOIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,GPIOIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIS12RXINTR'");
 PSW(AACI_ITOS12RXINT, AACIITOP1, Slot12RxIntr4_write_1);
 PSR(AACI_ITOS12RXINT, MASK_ALL, AACIITOP1,Slot12RxIntr4_Rd_1);
 PSW(0x0, AACIITOP1, Slot12RxIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,Slot12RxIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIS12TXINTR'");
 PSW(AACI_ITOS12TXINT, AACIITOP1, Slot12TxIntr4_write_1);
 PSR(AACI_ITOS12TXINT, MASK_ALL, AACIITOP1,Slot12TxIntr4_Rd_1);
 PSW(0x0, AACIITOP1, Slot12TxIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,Slot12TxIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIS2RXINTR'");
 PSW(AACI_ITOS2RXINT, AACIITOP1, Slot2RxIntr4_write_1);
 PSR(AACI_ITOS2RXINT, MASK_ALL, AACIITOP1,Slot2RxIntr4_Rd_1);
 PSW(0x0, AACIITOP1, Slot2RxIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,Slot2RxIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIS2TXINTR'");
 PSW(AACI_ITOS2TXINT, AACIITOP1, Slot2TxIntr4_write_1);
 PSR(AACI_ITOS2TXINT, MASK_ALL, AACIITOP1,Slot2TxIntr4_Rd_1);
 PSW(0x0, AACIITOP1, Slot2TxIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,Slot2TxIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIS1RXINTR'");
 PSW(AACI_ITOS1RXINT, AACIITOP1, Slot1RxIntr4_write_1);
 PSR(AACI_ITOS1RXINT, MASK_ALL, AACIITOP1,Slot1RxIntr4_Rd_1);
 PSW(0x0, AACIITOP1, Slot1RxIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,Slot1RxIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIS1TXINTR'");
 PSW(AACI_ITOS1TXINT, AACIITOP1, Slot1TxIntr4_write_1);
 PSR(AACI_ITOS1TXINT, MASK_ALL, AACIITOP1,Slot1TxIntr4_Rd_1);
 PSW(0x0, AACIITOP1, Slot1TxIntr4_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,Slot1TxIntr4_Rd_0);

 C("TESTING CONNECTIVITY OF 'AACIINTR'");
 PSW(AACI_ITOINTR, AACIITOP1, AaciIntr_write_1);
 PSR(AACI_ITOINTR, MASK_ALL, AACIITOP1,AaciIntr_Rd_1);
 PSW(0x0, AACIITOP1, AaciIntr_write_0);
 PSR(0x0, MASK_ALL, AACIITOP1,AaciIntr_Rd_0);

/**********************************************************************/
/*** Integration testing of Intra-Chip input signals                ***/
/**********************************************************************/
 /* NOTE : When the tests are run in an integrated system, the user is
           expected to replace the write commands to the AACIITIP
           register with suitable commands to write the values on the
           respective lines through the source peripherals (e.g.DMA
           Controller).
           ** When the intra-chip inputs are tested in an integrated
           system, the ITEN bit in the AACITCR register has to be
           cleared.
 */

 /* Switch to Integration test mode */
 PSW(ITEN, AACITCR,TestMode_Enable);
 /* NOTE : When the intra-chip inputs are tested in an integrated
           system, the PSW command above should be replaced with the
           one below:
 PSW(0x0, AACITCR,NormalMode_Enable);
*/
 
 C("TESTING CONNECTIVITY OF INTRA-CHIP INPUTS");
 PSW(0x0, AACIITOP0, SdataOut_write_1);

 C("TESTING CONNECTIVITY OF AACIDMACLRTX SIGNAL");
 PSW(AACI_ITIDMCLRTX, AACIITIP, DmaClrTx_write_1);
 PSR(AACI_ITIDMCLRTX, AACI_ITIDMCLRTX, AACIITIP,DmaClrTx_Rd_1);
 PSW(0x0, AACIITIP, DmaClrTx_write_1);
 PSR(0x0, AACI_ITIDMCLRTX, AACIITIP,DmaClrTx_Rd_0);

 C("TESTING CONNECTIVITY OF AACIDMACLRRX SIGNAL");
 PSW(AACI_ITIDMCLRRX, AACIITIP, DmaClrRx_write_1);
 PSR(AACI_ITIDMCLRRX, AACI_ITIDMCLRRX, AACIITIP,DmaClrRx_Rd_1);
 PSW(0x0, AACIITIP, DmaClrRx_write_1);
 PSR(0x0, AACI_ITIDMCLRRX, AACIITIP,DmaClrRx_Rd_0);

 C("END OF INTEGRATION TESTS");

}

/**********************************************************************/
/****************** Valid Transfer in Loop Back Mode ******************/
/**********************************************************************/
void ValidTransferTest(void)
{
 /* 
    Summary : ValidTransferTest
    ===========================
    This test verifies the connectivity of AACIBITCLK primary input
    indirectly by performing a data transfer in the loopback mode.

    The channel 1 is programmed for transmitting data for 8 slots
    in the frame. All four channels are programmed for reception.
    The loop back mode is programmed by writing into the AACIMAINCR
    register so that the AACISDATAOUT is routed back to AACISDATAIN.
    After the completion of data transfer, the received data in the
    receive FIFO of the channels is read to verify data transfer.
 */

 int   i, One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int32 WaitPeriod;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 C("TESTING FOR AACIBITCLK PORT CONNECTIVITY ");

 /* Switch to normal mode */
 PSW(NORMALMODE, AACITCR,NormalMode_Enable);

 C("Enable AACI in the loop back mode ");
 PSW(AACI_LOOP | AACI_AACIIFE, AACIMAINCR);

 /* Disabling channels 2, 3 and 4 for transmission */
 PSW(0x0, AACITXCR2);
 PSW(0x0, AACITXCR3);
 PSW(0x0, AACITXCR4);
 PI(One_BitClk_Period * 4);

 /* Enabling channel 1 for 4 slots of transmission */
 PSW(AACI_TX3 | AACI_TX5 | AACI_TX8 | AACI_TX9 | AACI_RSIZE20 | AACI_FEN, AACITXCR1);
 PI(One_BitClk_Period * 4);

 /* Fill the Tx FIFO of channel 1 with transmit data */
 C("Filling the datas in to the FIFO of channel 1 ");
 PSW(0x55555, AACIDR1,Channel1Write);
 PSW(0xEAAAA, AACIDR1,Channel1Write);
 PSW(0x00000, AACIDR1,Channel1Write);
 PSW(0xFFFFF, AACIDR1,Channel1Write);

 /* Enabling the reception */
 C("Enabling reception ");
 PSW(AACI_RX3 | AACI_RX5 | AACI_RSIZE16 | AACI_REN | AACI_CM | AACI_FEN, AACIRXCR1);
 PSW(0x0, AACIRXCR2);
 PSW(AACI_RX8 | AACI_RX9 | AACI_RSIZE16 | AACI_REN | AACI_CM | AACI_FEN, AACIRXCR3);
 PSW(0x0, AACIRXCR4);

 /* Enabling the channel 1 for transmission */
 C("Enabling transmission ");
 PSW(AACI_TX3 | AACI_TX5 | AACI_TX8 | AACI_TX9 | AACI_TSIZE20 | AACI_FEN | AACI_TEN, AACITXCR1);

 /* Waiting for a duration corresponding to 2 frame periods so that
    the data transfer completes */
 C("Waiting for data transfer to complete");
 WaitPeriod = One_BitClk_Period * 514;
 Idle(WaitPeriod);

 C("Data transfer is complete");
 /* Reading all the data from the channel FIFOs */
 C("Reading all the data from the channel FIFOs ");
 PSR(0xEAAA5555, 0xFFFFFFFF, AACIDR1);
 PSR(0xFFFF0000, 0xFFFFFFFF, AACIDR3);

 C("END OF THE AACIBITCLK PORT CONNECTIVITY TEST");

}

/**********************************************************************/
/********************************  Idle  ******************************/
/**********************************************************************/
void Idle(unsigned long time)
{
  /*
    Summary: Idle
    =============
    This function inserts idle cycle:

    o It inserts the number of the idle cycles given by the parameter
      value.

  */

  unsigned long i;
  int Count, Remainder;

  Count     = time/255;
  Remainder = time % 255;

  if (time <= 2)
  {
    PI(0x02);
  }
  else
  {
    while (Count > 0)
      {
       if (Remainder == 1)
         {
          PI(0xFE);
          PI(0x2);
          Remainder = 0;
         }
       else
         {
          PI(0xFF);
         }
       Count = Count - 1;
      }
    if (Remainder != 0)
      {
       PI(Remainder);
      }
  }
}

/*********************** End of IntegrationTest.c *********************/
