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
-- File Name              : IntegrationTest.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : Function to verify that the MMCI has been wired into the
--           system correctly.
--
-- --=========================================================================*/

void IntegrationTest()
{
  /* Summary : IntegrationTest
     =========================
     When the MMCI is used in an AMBA system, it must be ensured that
     all of its pins are correctly connected. Integration vectors
     allow the usr to verify that the MMCI has been wired into the
     system correctly.
  */

  /* Testing of Intra-Chip input (MMCIDMACLR) :
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register. This selects
       the test path from the MMCIITIP[0] register bit to the internal
       MMCIDMACLR signal.
     - Write a 1 and then a 0 to the MMCIITIP[0] register bit and read
       the same register bit to ensure that the value written is read
       out.

     When integration tests are run in an integrated system '1' and '0'
     are actually written into internal registers of DMA controller and
     the connection is verified by reading out from MMCIITIP[0] register
     bit.
  */

  C("Integration Tests for the MMCI");

  C("Testing Intra Chip Input connection");

  /* Enable Integration testing of the MMCI by setting the ITEN
     bit in the MMCITCR register 

     NOTE : When the tests are run in an integrated system, the user is
            expected to comment out the following PSW command. This is
            to ensure that the path from the MMCIDMACLR input of the MMCI
            to the MMCIITIP register is selected.
  */
     
  PSW(0x00000031, MMCITCR);

  /* Set the MMCIDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to
            set the MMCIDMACLR output signal from the DMA controller */
  PSW(0x00000001, MMCIITIP);

  /* Read the value on the MMCIDMACLR input */
  PSR(0x00000001, 0x00000001, MMCIITIP);

  /* Clear the MMCIDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to
            clear the MMCIDMACLR output signal from the DMA controller */
  PSW(0x00000000, MMCIITIP);

  /* Read the value on the MMCIDMACLR input */
  PSR(0x00000000, 0x00000001, MMCIITIP);

  /* Testing primary inputs (MMCIDATAIN, MMCICMDIN, MMCIFBCLK) :

    MMCIDATAIN is tested using the Integration vector trickbox by
    looping back the MMCICMDOUT line. '1's and '0's are driven on to
    the MMCICMDOUT line via the MMCIITOP register bit[10] and read back
    via the MMCIITIP register bit[1].

  */

  C("Testing Primary Input connections");

/* Set nMMCICMDEN = '1' and nMMCIDATEN = '0' */ 
  PSW(0x00000011,MMCITCR);

/* Set MMCIROD = '0' */
PSW(0x00000003, MMCIPower);

  /* Write to MMCIITOP register to set bit in MMCIDATOUT */
  PSW(0x00000040, MMCIITOP);

  /* Read from the MMCIITIP register to verify that 
     and MMCICMDIN reflect the looped back value */
  PSR(0x00000020, 0x00000020, MMCIITIP);

  /* Write to MMCIITOP register to clear bit in MMCIDATOUT
     and MMCICMDOUT */
  PSW(0x00000000, MMCIITOP);

  /* Read from the MMCIITIP register to verify that MMCIDATIN
     and MMCICMDIN reflect the looped back value */
  PSR(0x00000000, 0x00000002, MMCIITIP);

  PSW(0x00000000, MMCITCR);

  /* Testing of Intra-Chip Outputs (MMCIINTR0, MMCIINTR1, MMCIDMASREQ,
     MMCIDMABREQ, MMCIDMALSREQ, MMCIDMALBREQ) :
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register. This selects
       the test path from the MMCIITOP[5:0] register bits.
     - Write a 1 and then a 0 to the MMCIITOP[5:0] register bit and read
       the same register bit to ensure that the value written is read
       out.

     When integration tests are run in an integrated system '1' and '0'
     are written to the MMCIITOP[5:0] register bits so as to toggle the
     signal connections between the MMCI and the DMA Controller/
     Interrupt controller. Read from the DMA Controller/ Interrupt
     controller's internal registers to verify that the value written
     into the MMCIITOP[5:0] register bits is read out through the
     DMA controller/ Interrupt Controller.
  */

  C("Testing Intra Chip Output connections");
  PSW(0x00000031, MMCITCR);
  /* Set the Intra-chip outputs from the MMCI */
  PSW(0x0000003F, MMCIITOP);

  /* Read the value on the intra-chip outputs of the MMCI */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this read with suitable commands to
            read the values on these lines through the destination
            peripherals (DMA Controller/Interrupt Controller) */
  PSR(0x0000003F, 0x0000003F, MMCIITOP);

  /* Reset the Intra-chip outputs from the MMCI */
  PSW(0x00000000, MMCIITOP);
  /* Read the value on the intra-chip outputs of the MMCI */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this read with suitable commands to
            read the values on these lines through the destination
            peripherals (DMA Controller/Interrupt Controller) */
  PSR(0x00000000, 0x0000003F, MMCIITOP);

  /* Testing primary Outputs (MMCICMDOUT, MMCIDATAOUT, MMCICLKOUT,
     MMCIPWR, MMCIROD, MMCIVDD[3:0]) :

    MMCICMDOUT is directly connected to the primary input pin
    MMCIDATIN. Enable the MMCICLK through the MMCIPOWER register.
    Enable the CPSM in transmit mode and the DPSM in receive mode. The
    command transmitted by the CPSM should be looped back from
    MMCICMDOUT pin to MMCIDATAIN and stored in the FIFO. If the data
    read from the FIFO matches the transmitted command, the
    connectivity of MMCICLKOUT, MMCIFBCLK, MMCICMDOUT and MMCIDATAIN are
    proven.
   
    MMCIVDD, MMCIPWR pin connections are verified as follows.
    Set nMMCICMDEN='1' and nMMCIDATEN='1' and MMCIROD='1' through test
    register.Force '1' and '0' to MMCIVDD and MMCIPWR lines through MMCIITOP
    register.Verify the data by reading the MMCIDATIN(or MMCICMDIN) line
    through the MMCIITIP register.
  */

  C("Testing Primary Outputs connection");

  /* Clear the test control register - switch to normal mode */
  PSW(0x00000000, MMCITCR);

 /* Set nMMCICMDEN ='0' and nMMCIDATEN = '1'*/
  PSW(0x00000020,MMCITCR);

/* Initialising the MMCI */
  PSW(0x00000003, MMCIPower);

  /* Wait for internal synchronisation to complete */
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03); 

  PSW(0x00000100, MMCIClock);

  /* Wait for internal synchronisation to complete */
   Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03); 

  /* Program the DPSM to receive 5 bytes of data in stream mode */
  PSW(0x00000005, MMCIDataLength);
  PSW(0x00000F00, MMCIDataTimer);
 
  /* Ensure that the receiver is inactive */
  PSR(0x00000000, 0x00002000, MMCIStatus);

  /* Enable the DPSM for data reception */
  PSW(0x00000007, MMCIDataCtrl);

  /* Program the CPSM to transmit data in no-response mode */

  PSW(0xFFFFFFFF, MMCIArgument);
  PSR(0x00000000, 0x00000800, MMCIStatus);
  PSW(0x0000043F, MMCICommand);
  PSR(0x00000800, 0x00000800, MMCIStatus);

  /* Wait for data transfer to complete. Data transmitted by the CPSM is
     expected to be looped back to the DPSM, which in turn stores the
     received data in the FIFO */
   Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x50); 

  /* After one word is written to the FIFO, verify the received data */
/* The first bit transmiited by the CPSM is the start bit which is not taken 
as data bit and not written to FIFO. */ 
  PSR(0xFFFFFFFF, 0xFFFFFFFF, MMCIFIFO);

  /* Wait for the second word (containing the last byte) to be written 
     to the FIFO by the DPSM */
   Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x50); 

  /* Verify received data. Only the data bits in the transmit stream of
     the CPSM are verified - the CRC bits are not verified */
  PSR(0x000000FE, 0x000000FE, MMCIFIFO);

/* Set nMMCICMDEN ='1', nMMCIDATEN ='1' and MMCIROD ='1' */
  /* Switch to Integration test mode */
  PSW(0x00000031, MMCITCR);
  PSW(0x00000080, MMCIPower);

  /* Checking connectivity of MCIVDD output */

  /* Ensure other inputs to the OR gate in the trickbox are zero */
  PSR(0x00000000, 0x00000020, MMCIITIP);

 /* Drive MMCIPOWER to zero */
  PSW(0x00000000, MMCIITOP);

 /* Drive each bit in the MMCIVDD[3:0] to different values and
     verify connectivity */

  PSW(0x00000083, MMCIPower);
  PSR(0x00000000, 0x00000020, MMCIITIP);

  /* Wait for synchronisation delay to elapse to avoid writing to
     the register when the internal mask is in effect */
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSW(0x00000087, MMCIPower);
  PSR(0x00000020, 0x00000020, MMCIITIP);

  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSW(0x0000008B, MMCIPower);
  PSR(0x00000020, 0x00000020, MMCIITIP);

  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSW(0x00000093, MMCIPower);
  PSR(0x00000020, 0x00000020, MMCIITIP);

  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSW(0x000000A3, MMCIPower);
  PSR(0x00000020, 0x00000020, MMCIITIP);

  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);

/* Drive MMCIPOWER to logic high and make MMCIVDD[3:0]=0000 */

  PSW(0x00000800, MMCIITOP);
  PSW(0x00000083, MMCIPower);
  PSR(0x00000020, 0x00000020, MMCIITIP);

  C("End of Integration Test");

}

/* --================================= End ===================================*/
