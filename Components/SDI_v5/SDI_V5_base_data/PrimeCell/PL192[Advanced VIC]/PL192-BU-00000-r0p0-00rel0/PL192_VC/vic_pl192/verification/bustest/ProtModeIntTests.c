/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ProtModeIntTests.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Protection mode Interrupt tests.
--
-- --=========================================================================*/
 
/******************************************************************************/
/***************** Protection Mode Interrupt Tests ****************************/
/******************************************************************************/

void ProtModeIntTests(int src1, int src2, int src3)
{
  /*
     Summary: Protection mode Interrupt Tests
     ========================================
     This function performs the following: 
 
     o  Interrupts are applied in 'PROTECTED' mode.

     o  Verifies that 'USER' mode accesses to the Vector Address
        Register does not modify the Current Service Register or
        the internal interrupt priority.
  */
 
  int32 data;

  /** Disable Trickbox compare logic. **/
  HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , 0x040);
 
  C("Configure Vector Addresses");
  data = Data1;
  HSA(VICVectAddr_BASE + 0x4*src1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data *= 2);
  HSA(VICVectAddr_BASE + 0x4*src2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data *= 2);
  HSA(VICVectAddr_BASE + 0x4*src3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data *= 2);
 
  data = 0x01;
  HSA(VICVectPriority_BASE + 0x4*src1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data ++);
  HSA(VICVectPriority_BASE + 0x4*src2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data ++);
  HSA(VICVectPriority_BASE + 0x4*src3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , data ++);
 
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , DataF);
 
  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
 
  C("Configure the VIC in 'PROTECTED' mode");
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , 0x1);
  prot = 0x2;
 
  C("Apply INTR 2");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x4);
 
  WaitLoop(2);

  C("Read VICVectAddr in 'USER' mode");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , 0x0);
  HSR( , ZERO, , , ,ProtModeIntTests_1);
 
  C("Read VICVectAddr in 'PROTECTED' mode");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data4, , , ,ProtModeIntTests_2);
 
  C("Applying a higher priority interrupt (INTR 1)");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x2);
 
  WaitLoop(3);

  C("Read VICVectAddr in 'PROTECTED' mode");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data2, , , ,ProtModeIntTests_3);
 
  C("Applying a lower priority interrupt");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x8);
 
  C("Write VICVectAddr in 'PROTECTED' mode");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
 
  WaitLoop(1);

  C("Write VICVectAddr in 'USER' mode");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , 0x0);
  HSW( , ZERO);
 
  C("Write VICVectAddr in 'PROTECTED' mode");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
 
  C("Configure the VIC in 'USER' mode");
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , 0x0);
  prot = 0x0;
 
  WaitLoop(1);

  C("Read VICVectAddr in 'USER' mode");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , 0x0);
  HSR( , Data8, , , ,ProtModeIntTests_6);
 
  C("Clear Interrupts");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , ZERO);
 
  WaitLoop(1);

  C("Write VICVectAddr in 'USER' mode");
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , 0x0);
  HSW( , ZERO);
 
  WaitLoop(1);

  /** Enable Trickbox compare logic. **/
  HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICTrTCR);
 
}
 
/******************************** End *****************************************/
