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
-- File Name              : FIFOPointersTest.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This part of the code checks the read and write happening
--           correctly to/from the FIFO when the FIFO is full and the
--           FIFO read and write pointers are at 7.
--
-- --=================================================================*/

/**********************************************************************/
/*********************** FIFO Critical test ***************************/
/**********************************************************************/
void FIFOPointersTest(void)
{
 /*
   Summary : FIFOPointersTest
   ==========================
   The test sequence for the FIFO pointers tests is as follows

   TxFIFO
   ------
   1. Fill the FIFO with 7 entries in normal mode.
      This brings the write pointer to "111"(binary)
   2. Read the FIFO for 7 entries in test mode [FIFOTEST = 01]
      This brings the read pointer to "111"(binary). The FIFO is now
      empty
   3. Fill the FIFO with 8 entries in normal mode.
      The write pointer wraps around and comes to "111". The FIFO is
      now full.
   4. Read the FIFO last data in test mode [FIFOTEST = 11].
      This initiates a simultaneous write and read to the FIFO.
      The write initiated is with a default data of 0x55555.
   5. Read out 7 data from the FIFO in the test mode [FIFOTEST = 01]
   6. Confirm the last data written to be 0x55555 by reading data
      from the FIFO in the test mode [FIFOTEST = 01].
 
   RxFIFO
   ------
   1. Fill the FIFO with 7 entries in test mode [FIFOTEST = 01].
      This brings the write pointer to "111"(binary)
   2. Read the FIFO for 7 entries in normal mode.
      This brings the read pointer to "111"(binary). The FIFO is now
      empty
   3. Fill the FIFO with 8 entries in test mode [FIFOTEST = 01].
      The write pointer wraps around and comes to "111". The FIFO is
      now full.
   4. Read the FIFO last data in test mode [FIFOTEST = 10].
      This initiates a simultaneous write and read to the FIFO.
      The write initiated is with a default data of 0x55555.
   5. Read out 7 data from the FIFO in the test mode [FIFOTEST = 01]
   6. Confirm the last data written to be 0x55555 by reading data
      from the FIFO in the test mode [FIFOTEST = 01].

  The test is done for all the channels.

  The following bits in the AACITCR register are used in this test:

  Bit [2:1] - FIFOTEST 

  FIFOTEST = 00 [default] [normal mode]

  FIFOTEST = 01 [test mode]
  Reads return Read Port of Tx FIFO.
  Writes will write data into the Write Port of the Rx FIFO.

  FIFOTEST = 10 [test mode]  for RxFIFO test
  Reads will return data from the Read port of the Rx FIFO
  Additionally, read access automatically generate a Write Access to
  the Write port of the Rx FIFO.

  FIFOTEST = 11 [test mode] for TxFIFO test
  Reads will return data from the Read port of the Tx FIFO
  Additionally, read access automatically generate a Write Access to
  the Write port of the Tx FIFO.
  
 */

 int32 LoopCount, Data;
 int   One_BitClk_Period = AACIBITCLK_PERIOD/PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   {
    One_BitClk_Period = 1;
   }

 /* Disable AACI to flush the FIFOs of any left-over data and to
    restore the read pointer and write pointer to "000" */
 PSW(0x0, AACIMAINCR);
 PI(One_BitClk_Period * 4);

 /* Enable the AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);
 PI(One_BitClk_Period * 4);

 /* Enable AACIBITCLK from the trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Configure the AACIRXCRn and AACITXCRn [n = 1 to 4] registers to
    enable FIFO mode and to set TSIZE/RSIZE to 20 bits */
 PSW(AACI_RSIZE20 | AACI_FEN, AACIRXCR1);
 PSW(AACI_RSIZE20 | AACI_FEN, AACIRXCR2);
 PSW(AACI_RSIZE20 | AACI_FEN, AACIRXCR3);
 PSW(AACI_RSIZE20 | AACI_FEN, AACIRXCR4);

 PSW(AACI_TSIZE20 | AACI_FEN, AACITXCR1);
 PSW(AACI_TSIZE20 | AACI_FEN, AACITXCR2);
 PSW(AACI_TSIZE20 | AACI_FEN, AACITXCR3);
 PSW(AACI_TSIZE20 | AACI_FEN, AACITXCR4);

 /* Waiting for the synchronisation to occur for write to complete */
 PI(One_BitClk_Period * 4);

 /* For Channel 1 */
 C("FIFO POINTERS CROSS-OVER TEST FOR CHANNEL 1");

 /* For Tx FIFO */
 C("FIFO POINTERS CROSS-OVER TEST FOR Tx FIFO OF CHANNEL 1");

 /* Enabling the FIFO */
 ConfigTxCR(Channel_1, AACI_RSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 /* Writing 7 data into the AACI's Tx FIFO in normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount & 0xFFFFF;
    PSW(Data, AACIDR1);
   }

 /* Reading 7 data from the Tx FIFO in Test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR1,CH1_EARLY_READS);
   }

 /* Writing 8 data into the FIFO in Normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR1);
   }

 /* Reading data from the FIFO in test mode */
 PSW(TESTMODE11, AACITCR);
 PSR(0x1234, MASK_ALL, AACIDR1, CH1_TxFIFO_TstMode_Read);

 /* Reading 7 data */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x1; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR1, CH1_TxFIFO_Last7);
   }

 /* Read out the last word of data and verify that it is 0x55555 */
 PSR(0x00055555, MASK_ALL, AACIDR1, CH1_TxFIFO_Last);

 C("END OF FIFO POINTERS CROSS-OVER TEST FOR Tx FIFO OF CHANNEL 1");

 /* For Rx FIFO */
  C("FIFO POINTERS CROSS-OVER TEST FOR Rx FIFO OF CHANNEL 1");

 /* Enabling the FIFO */
 ConfigRxCR(Channel_1, AACI_RSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 /* Writing 7 data into the FIFO in test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR1);
   }

 /* Reading 7 data from FIFO in Normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR1,CH1_EARLY_READS);
   }

 /* Writing 8 data into the FIFO in Test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR1);
   }

 PSW(TESTMODE10, AACITCR);
 PSR(0x1234, MASK_ALL, AACIDR1,CH1_Rx_TSTMode_Read);

 /* Reading all 8 data */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x1; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR1, CH1_RxFIFO_Last7);
   }
 PSR(0x00055555, MASK_ALL, AACIDR1, CH1_RxFIFO_Last);

 C("END OF FIFO POINTERS CROSS-OVER TEST FOR Rx FIFO OF CHANNEL 1");

 /* For Channel 2 */
 C("FIFO POINTERS CROSS-OVER TEST FOR CHANNEL 2");

 /* For Tx FIFO */
 C("FIFO POINTERS CROSS-OVER TEST FOR Tx FIFO OF CHANNEL 2");

 /* Enabling the FIFO */
 ConfigTxCR(Channel_2, AACI_RSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 PSW(NORMALMODE, AACITCR);
 /* Writing 7 data into FIFO in normal mode */
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR2);
   }

 /* Reading 7 data from FIFO in Test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR2,CH2_EARLY_READS);
   }

 /* Writing 8 data into FIFO in Normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR2);
   }

 /* Reading the data from FIFO in test mode */
 PSW(TESTMODE11, AACITCR);
 PSR(0x1234, MASK_ALL, AACIDR2, CH2_TxFIFO_TstMode_Read);

 /* Reading all 8 data */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x1; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR2, CH2_TxFIFO_Last7);
   }

 PSR(0x00055555, MASK_ALL, AACIDR2, CH2_TxFIFO_Last);
 C("END OF FIFO POINTERS CROSS-OVER TEST FOR Tx FIFO OF CHANNEL 2");

 /* For Rx FIFO */
  C("FIFO POINTERS CROSS OVER TEST FOR Rx FIFO OF CHANNEL 2");

 /* Enabling the FIFO */
 ConfigRxCR(Channel_2, AACI_RSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 /* Writing 7 data into FIFO in test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR2);
   }

 /* Reading 7 data from FIFO in Normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    PSR(Data, MASK_ALL, AACIDR2,CH2_EARLY_READS);
   }

 /* Writing 8 data into FIFO in Test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR2);
   }

 PSW(TESTMODE10, AACITCR);
 PSR(0x1234, MASK_ALL, AACIDR2,CH2_Rx_TSTMode_Read);

 /* Reading all 8 data */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x1; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR2, CH2_RxFIFO_Last7);
   }
 PSR(0x00055555, MASK_ALL, AACIDR2, CH2_RxFIFO_Last);
 C("END OF FIFO POINTERS CROSS-OVER TEST FOR Rx FIFO OF CHANNEL 2 ")

 /* For Channel 3 */
 C("FIFO POINTERS CROSS-OVER TEST FOR CHANNEL 3");

 /* For Tx FIFO */
 C("FIFO POINTERS CROSS-OVER TEST FOR Tx FIFO OF CHANNEL 3");

 /* Enabling the FIFO */
 ConfigTxCR(Channel_3, AACI_RSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 PSW(NORMALMODE, AACITCR);
 /* Writing 7 data in FIFO in normal mode */
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR3);
   }

 /* Reading 7 data from FIFO in Test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR3,CH3_EARLY_READS);
   }

 /* Writing 8 data into FIFO in Normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR3);
   }

 /* Reading data from FIFO in test mode */
 PSW(TESTMODE11, AACITCR);
 PSR(0x1234, MASK_ALL, AACIDR3, CH3_TxFIFO_TstMode_Read);

 /* Reading all 8 data */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x1; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR3, CH3_TxFIFO_Last7);
   }

 PSR(0x00055555, MASK_ALL, AACIDR3, CH3_TxFIFO_Last);
 C("END OF FIFO POINTERS CROSS-OVER TEST FOR Tx FIFO OF CHANNEL 3");

 /* For Rx FIFO */
 C("FIFO POINTERS CROSS-OVER TEST FOR Rx FIFO OF CHANNEL 3");

 /* Enabling the FIFO */
 ConfigRxCR(Channel_3, AACI_RSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 /* Writing 7 data in FIFO in test mode 01 */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR3);
   }

 /* Reading 7 datas from FIFO in Normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR3,CH3_EARLY_READS);
   }

 /* Writing 8 data in FIFO in Test mode 01 */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR3);
   }

 PSW(TESTMODE10, AACITCR);
 PSR(0x1234, MASK_ALL, AACIDR3,CH3_Rx_TSTMode_Read);

 /* Reading all 8 data */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x1; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR3, CH3_RxFIFO_Last7);
   }
 PSR(0x00055555, MASK_ALL, AACIDR3, CH3_RxFIFO_Last);
 C("END OF FIFO POINTERS CROSS-OVER TEST FOR Rx FIFO OF CHANNEL 3");

 /* For Channel 4 */
 C("FIFO POINTERS CROSS-OVER TEST FOR CHANNEL 4");

 /* For Tx FIFO */
 C("FIFO POINTERS CROSS-OVER TEST FOR Tx FIFO OF CHANNEL 4");  

 /* Enabling the FIFO */
 ConfigTxCR(Channel_4, AACI_RSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 PSW(NORMALMODE, AACITCR);
 /* Writing 7 data into FIFO in normal mode */
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR4);
   }

 /* Reading 7 data from FIFO in Test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR4,CH4_EARLY_READS);
   }

 /* Writing 8 data into FIFO in Normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR4);
   }

 /* Reading data from FIFO in test mode */
 PSW(TESTMODE11, AACITCR);
 PSR(0x1234, MASK_ALL, AACIDR4, CH4_TxFIFO_TstMode_Read);

 /* Reading all 8 data */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x1; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR4, CH4_TxFIFO_Last7);
   }
 PSR(0x00055555, MASK_ALL, AACIDR4, CH4_TxFIFO_Last);

 C("END OF FIFO POINTERS CROSS-OVER TEST FOR Tx FIFO OF CHANNEL 4");

 /* For Rx FIFO */
 C("FIFO POINTERS CROSS-OVER TEST FOR Rx FIFO OF CHANNEL 4");

 /* Enabling the FIFO */
 ConfigRxCR(Channel_4, AACI_RSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 /* Writing 7 data into FIFO in test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR4);
   }

 /* Reading 7 data from FIFO in Normal mode */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x7; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR4,CH4_EARLY_READS);
   }

 /* Writing 8 data into FIFO in Test mode */
 PSW(TESTMODE01, AACITCR);
 for (LoopCount = 0x0; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSW(Data, AACIDR4);
   }

 PSW(TESTMODE10, AACITCR);
 PSR(0x1234, MASK_ALL, AACIDR4,CH4_Rx_TSTMode_Read);

 /* Reading all 8 data */
 PSW(NORMALMODE, AACITCR);
 for (LoopCount = 0x1; LoopCount < 0x8; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    Data = Data & 0xFFFFF;
    PSR(Data, MASK_ALL, AACIDR4, CH4_RxFIFO_Last7);
   }
 PSR(0x00055555, MASK_ALL, AACIDR4, CH4_RxFIFO_Last);

 C("END OF FIFO POINTERS CROSS-OVER TEST FOR Rx FIFO OF CHANNEL 4");

}

/********************** End of FIFOPointersTest.c *********************/
