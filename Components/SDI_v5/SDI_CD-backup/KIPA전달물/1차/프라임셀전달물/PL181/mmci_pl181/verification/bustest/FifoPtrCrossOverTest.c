/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : FifoPtrCrossOverTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to verify FIFO operation in the boundary condition
--           where the FIFO is full, the pointers are "1111" and there
--           is a simultaneous read and write. The write data is
--           expected to be taken into the FIFO
--
-- --=========================================================================*/

/******************************************************************************/
/************************* FIFO Pointer CrossOver Test ************************/
/******************************************************************************/
void FifoPtrCrossOverTest(void)
{
 /* Summary : FifoPtrCrossOverTest
    ==============================
    The test sequence is as follows
  1. Fill the FIFO with 15 entries in normal mode.
     This brings the write pointer to "1111"(binary)
  2. Read the FIFO for 15 entries in test mode [FIFOTEST = 01]
     This brings the read pointer to "1111"(binary). The FIFO is now
     empty
  3. Fill the FIFO with 16 entries in normal mode.
     The write pointer wraps around and comes to "1111". The FIFO is
     now full.
  4. Read the FIFO last data in test mode [FIFOTEST = 11].
     This initiates a simultaneous write and read to the FIFO.
     The write initiated is with a default data of 0x55555555.
  5. Confirm the last data written to be 0x55555555 by reading data
     from the FIFO in the test mode [FIFOTEST = 01].

  The bits used in the test control register

  Bit [2:1] - FIFOTEST

  FIFOTEST = 00 [default] [normal mode]

  FIFOTEST = 01 [test mode]
  Reads return data from the Read Port of FIFO irrespective of the
  setting of the direction bit and irrespective of whether the MMCI is
  data enabled.
  Writes will write data into the Write Port of the FIFO irrespective
  of the setting of the direction bit and irrespective of whether the
  MMCI is data enabled.


  FIFOTEST = 11 [test mode]
  Reads return data from the Read Port of FIFO irrespective of the
  setting of the direction bit and irrespective of whether the MMCI is
  data enabled.
  Additionally, read access automatically generate a Write Access to
  the Write port of the FIFO.
  Writes will write data into the Write Port of the FIFO irrespective
  of the setting of the direction bit and irrespective of whether the
  MMCI is data enabled.
 */

 int32 LoopCount, Data;

 PSW(0x00000002, MMCITCR);
 /* Writing 15 data in FIFO in normal mode */
 for (LoopCount = 0x0; LoopCount < 0xF; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    PSW(Data, MMCIFIFO);
   }

 /* Reading 15 datas from FIFO in Test mode 01 */
 PSW(0x00000002, MMCITCR);
 for (LoopCount = 0x0; LoopCount < 0xF; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount;
    PSR(Data, MASK_MMCIFIFO, MMCIFIFO);
   }

 /* Writing 16 data in FIFO in Normal mode */
 PSW(0x00000002, MMCITCR);
 for (LoopCount = 0x0; LoopCount < 0x10; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    PSW(Data, MMCIFIFO);
   }
 /* Reading the data from FIFO in test mode */
 PSW(0x00000006, MMCITCR);
 PSR(0x1234, MASK_MMCIFIFO, MMCIFIFO);

 /* reading all the 16 datas */
 PSW(0x00000002, MMCITCR);
 for (LoopCount = 0x1; LoopCount < 0x10; LoopCount = LoopCount + 0x1)
   {
    Data = LoopCount + 0x1234;
    PSR(Data, MASK_MMCIFIFO, MMCIFIFO);
   }
 PSR(0x55555555, MASK_MMCIFIFO, MMCIFIFO);

 /* Reseting the MMCIITCR register for normal operations */
 PSW(0x00000000, MMCITCR);
}

/*******************************  End  ****************************************/
