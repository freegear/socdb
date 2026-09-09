/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : IntegrationTest.c.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------
--  Purpose : 
--            Function to verify that the DMAC has been wired into the
--            system correctly. SCAN-related ports are not tested
--            for connectivity.
--
-- --=========================================================================*/
 
/******************************************************************************/
/***************************** Function declarations **************************/
/******************************************************************************/

/******************************************************************************/
/***************************** Globle variables *******************************/
/******************************************************************************/
int32 IdleCount;

/******************************************************************************/
/****************************** Integration Test ******************************/
/******************************************************************************/
void IntegrationTest(void)
{
 /*
   Summary : IntegrationTest
   =========================

   When the DMAC is used in an AMBA system, it must be ensured that all of its
   pins are correctly connected. Integration vectors allow the user to verify
   that the DMAC has been wired into the system correctly. SCAN-related ports
   are not tested for connectivity.

   Integration testing of Intra-Chip output signals
   ------------------------------------------------
   The test sequence to test intra-chip outputs is as follows:
     - Write a 1 to the ITEN bit in the DMACITCR Control register. This selects
       the test path from the DMACITOP[15:0] register bits.
     - Write a 1 and then a 0 to the DMACITOP register bits and read the
       same register bit to ensure that the value written is read out.

   NOTE1 : When the tests are run in an integrated system, the user is expected
           to replace the read commands from the DMACITOP registers with
           suitable commands to read the values on respective lines through the
           destination peripherals (e.g.AACI/ MCI/ Interrupt Controller)
           Code sections requiring such user modifications have been marked with
           the string 'NOTE1'.

   Integration testing of Intra-Chip input signals
   -----------------------------------------------
     The intrachip inputs are all the DMA requests
       i.e.  DMACBREQ, DMACLBREQ, DMACSREQ, DMACLSREQ
     In this test these hardware inputs are simulated through correponding
     corresponding SOFTREQ registers

   The test sequence to test intra-chip Inputs is as follows:
     - Write a 1 to the ITEN bit in the DMACITCR Control register. This allows
       the DMACSOFTREQ registers to be written with any value in its bits.
       (In non-test mode these bits can not be cleared through software.
        Hardware only can clear these bits
     - Write a 1 and then a 0 to the DMACSOFTREQ[15:0] register bits and read
       the same register bit to ensure that the value written is read out.

   NOTE2: When the tests are run in an integrated system, the user is expected
          to replace the write commands to the DMACSOFTREQ register with
          suitable commands to write the values on the respective lines through
          the source peripherals (e.g. AACI/MCI).


   Integration testing of Intra-Chip AHB Master signals
   ---------------------------------------------
   The DMA Controller is master device on the bus. So the connectivity of the
   different AHB Master input and output ports is done via some valid transfers
   from the master interface in M2M transfer mode.
   for this the memory module is instantiated in the integration trickbox.
   This test is done in M2MTests() function in the DmacM2MTests.c file.

 */
 int32 BitNum;
 int32 Data, Expected_Data;

 RES(LOW,0x1,0x2);
 for (IdleCount = 0; IdleCount < 0x3; IdleCount++)
   {
    HSA(0x0, IDLE, SINGLE,, WRD,, 0x1,,);
    HSR(, 0x0,, 0x0);
   }

 /* Programming for Integration test mode */
 HSA(DMACTCR, NSEQ, INCR,, WRD,, 0x1,,);
 HSW(, 0x1);

 C("TESTING CONNECTIVITY OF INTRA-CHIP OUTPUTS ");

 /* Write '1's and '0's into the DMACITOP register and read back to
    verify connectivity */
 /* NOTE1 : When the tests are run in an integrated system, the user is expected
            to replace the read commands from the DMACITOP registers with
            suitable commands to read the values on respective lines through the
            destination peripherals (e.g.AACI/MCI/ Interrupt Controller)
 */

 C("TESTING CONNECTIVITY OF 'DMACCLR'");
 for (BitNum = 0; BitNum < 16; BitNum++)
   {
    /* Only the bit corresponding to the port has been writen with
       the value 1 and read back for the same value */
    Data = 0x1 << BitNum;
    HSA(DMACITOP1, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACITOP1;
    HSA(DMACITOP1, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACITOP1);
    /* Only the bit corresponding to the port has been writen with
       the value 0 and read back for the same value */
    Data = ~Data;
    HSA(DMACITOP1, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACITOP1;
    HSA(DMACITOP1, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACITOP1);

   }

 C("TESTING CONNECTIVITY OF 'DMACTC'");
 for (BitNum = 0; BitNum < 16; BitNum++)
   {
    /* Only the bit corresponding to the port has been writen with
       the value 1 and read back for the same value */
    Data = 0x1 << BitNum;
    HSA(DMACITOP2, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACITOP2;
    HSA(DMACITOP2, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACITOP2);

    /* Only the bit corresponding to the port has been writen with
       the value 0 and read back for the same value */
    Data = ~Data;
    HSA(DMACITOP2, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACITOP2;
    HSA(DMACITOP2, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACITOP2);
   }

 C("TESTING CONNECTIVITY OF 'INTERRUPTS' ");
 for (BitNum = 0; BitNum < 2; BitNum++)
   {
    /* In this test the bits corresponding to the interrupts are written in the
       DMACITOP register and the register is read back to confirm the same
       values for those bits. 
       In real systems these read back should be replaced by suitable commands
       to read the values on respective lines through the destination peripheral
       (i.e. Interrupt Controller)
       The every read should be replaced by read from corresponding interrupt
       line in the destination peripheral and the DMACINTR line(i.e. Combined
       interrupt)

    /* Only the bit corresponding to the port has been writen with
       the value 1 and read back for the same value */
    Data = 0x1 << BitNum;
    HSA(DMACITOP3, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACITOP3;
    HSA(DMACITOP3, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACITOP3);

    /* Only the bit corresponding to the port has been writen with
       the value 0 and read back for the same value */
    Data = ~Data;
    HSA(DMACITOP3, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACITOP3;
    HSA(DMACITOP3, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACITOP3);
   }

 C("TESTING CONNECTIVITY OF INTRA-CHIP INPUTS ");

 C("TESTING CONNECTIVITY OF 'DMACSREQ INPUTS' ");
 for (BitNum = 0; BitNum < 16; BitNum++)
   {
    /* Only the bit corresponding to the port has been writen with
       the value 1 and read back for the same value */
    Data = 0x1 << BitNum;
    HSA(DMACSoftSReq, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACSoftSReq;
    HSA(DMACSoftSReq, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACSoftSReq);

    /* Only the bit corresponding to the port has been writen with
       the value 0 and read back for the same value */
    Data = ~Data;
    HSA(DMACSoftSReq, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACSoftSReq;
    HSA(DMACSoftSReq, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACSoftSReq);
   }

 C("TESTING CONNECTIVITY OF 'DMACBREQ INPUTS' ");
 for (BitNum = 0; BitNum < 16; BitNum++)
   {
    /* Only the bit corresponding to the port has been writen with
       the value 1 and read back for the same value */
    Data = 0x1 << BitNum;
    HSA(DMACSoftBReq, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACSoftBReq;
    HSA(DMACSoftBReq, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACSoftBReq);

    /* Only the bit corresponding to the port has been writen with
       the value 0 and read back for the same value */
    Data = ~Data;
    HSA(DMACSoftBReq, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACSoftBReq;
    HSA(DMACSoftBReq, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACSoftBReq);
   }

 C("TESTING CONNECTIVITY OF 'DMACLSREQ INPUTS' ");
 for (BitNum = 0; BitNum < 16; BitNum++)
   {
    /* Only the bit corresponding to the port has been writen with
       the value 1 and read back for the same value */
    Data = 0x1 << BitNum;
    HSA(DMACSoftLSReq, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACSoftLSReq;
    HSA(DMACSoftLSReq, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACSoftLSReq);

    /* Only the bit corresponding to the port has been writen with
       the value 0 and read back for the same value */
    Data = ~Data;
    HSA(DMACSoftLSReq, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACSoftLSReq;
    HSA(DMACSoftLSReq, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACSoftLSReq);
   }

 C("TESTING CONNECTIVITY OF 'DMACLBREQ INPUTS' ");
 for (BitNum = 0; BitNum < 16; BitNum++)
   {
    /* Only the bit corresponding to the port has been writen with
       the value 1 and read back for the same value */
    Data = 0x1 << BitNum;
    HSA(DMACSoftLBReq, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACSoftLBReq;
    HSA(DMACSoftLBReq, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACSoftLBReq);

    /* Only the bit corresponding to the port has been writen with
       the value 0 and read back for the same value */
    Data = ~Data;
    HSA(DMACSoftLBReq, NSEQ, INCR,, WRD,, 0x1,,);
    HSW(, Data);
    Expected_Data = Data & MASK_DMACSoftLBReq;
    HSA(DMACSoftLBReq, NSEQ, INCR, , WRD, , 0x1, , );
    HSR( , Expected_Data, , MASK_DMACSoftLBReq);
   }
}

/*************************** End of IntegrationTest.c *************************/
