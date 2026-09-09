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
-- File Name              : CSRTests.c.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Routines to perform Current Service Register tests.
--
-- --=================================================================*/
 
/**********************************************************************/
/***************** Current Service Register Tests *********************/
/**********************************************************************/

void CSRTests(int src1, int src2, int src3)
{
  /*
     Summary: Protection mode Interrupt Tests
     ========================================
     This function performs the following: 
 
     o  Applies three Interrupts in the order of increasing priority

     o  Reads the Vector Address register after the application of the
        third interrupt

     o  Verifies that the bit set in the CSR corresponds to the
        Vector Address returned
  */
 
  int32 data;
 
  C("Configure Vector Bank");
  data = Data1;
  HSA(VICVectAddr_BASE + 0x4*src1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data *= 2);
  HSA(VICVectAddr_BASE + 0x4*src2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data *= 2);
  HSA(VICVectAddr_BASE + 0x4*src3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data *= 2);
 
  data = 0x20;
  HSA(VICVectCntl_BASE + 0x4*src1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data ++);
  HSA(VICVectCntl_BASE + 0x4*src2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data ++);
  HSA(VICVectCntl_BASE + 0x4*src3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data ++);
 
  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , D_VICDefVectAddr);
 
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , DataF);
 
  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ZERO);
 
  /** Enable Trickbox compare logic. **/
  HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , D_VICTrTCR);
 
  C("Apply INTR 2");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x4);
 
  C("Apply higher priority INTR 1");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x6);
 
  C("Apply highest priority INTR 0");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x7);
 
  C("Read VICVectAddr Register");
  C("This will set the CSR bit of NonVectIRQ");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , D_VICDefVectAddr, , , ,ProtModeIntTests_2);
 
  C("Read VICVectAddr Register");
  C("This will set the CSR bit of VectIRQ 2");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSR( , Data4, , , ,ProtModeIntTests_1);

  C("Read VICVectAddr Register");
  C("This will set the CSR bit of VectIRQ 1");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSR( , Data2, , , ,ProtModeIntTests_1);
 
  C("Read VICVectAddr Register");
  C("This will set the CSR bit of VectIRQ 0");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSR( , Data1, , , ,ProtModeIntTests_2);
 
  WaitLoop(3);

  /** Writing to the Vector Address register is expected to clear   **/
  /** the CSR bit of the current highest priority VectIRQ. A        **/
  /** subsequent read to the Vector Address Register is expected to **/
  /** return the Vector of the the VectIRQ that is next lower down  **/
  /** the priority stack.                                           **/

  C("Write VICVectAddr");
  C("This will clear the CSR bit of VectIRQ 0");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , ZERO);
 
  WaitLoop(3);

  /** Since the interrupt is not cleared at the Source, a           **/ 
  /** subsequent read to the Vector Address Register is expected to **/
  /** return the Vector of VectIRQ 0.                               **/ 
  C("Read VICVectAddr Register");
  C("This will set the CSR bit of VectIRQ 0 again");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSR( , Data1, , , ,ProtModeIntTests_2);
 
  C("Clear the INTR Sources");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x0);
 
  WaitLoop(3);

  C("Write VICVectAddr Register");
  C("This will clear the CSR bit of VectIRQ 0");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , ZERO);
 
  C("Write VICVectAddr Register");
  C("This will clear the CSR bit of VectIRQ 1");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , ZERO);
 
  C("Write VICVectAddr Register");
  C("This will clear the CSR bit of VectIRQ 2");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , ZERO);

  C("Write VICVectAddr Register");
  C("This will clear the CSR bit of NonVectIRQ");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , ZERO);
}
 
/******************************** End *********************************/
