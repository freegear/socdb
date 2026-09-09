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
-- File Name              : PriConsistency.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests the nesting of the interrupts. 
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/
 
char Str[120];

void PriConsistency()
{
  /*
    Summary: Priority Consistency Test
    ===============================================
    This function performs the following:

    o  Initialises all registers.

    o  Enable interrupts one by one starting from lowest priority every clock.

    o  Acknowledge the interrupt once it is stable on address lines.

    o  Perform a write on VICVectAddr register
  */

  int i;
  int32 ADD_ADDR, ADD_PRIO;
 
  D_VICTrTCR           = 0x05F;
  init_addr            = 0x0000A000;
  D_VICIntEnable       = 0xFFFFFFFF;
  D_VICSoftInt         = 0x00000000;
  D_VICIntSelect       = 0x00000000;
  D_VICSWPriorityMask  = 0xFFFF;

  C("Program Address registers 0 to 31");

  /** Program all address registers using burst transfers. IDLE and **/
  /** BUSY transfers are introduced during the burst.               **/
  ADD_ADDR = VICVectAddr_BASE;
  HSA(ADD_ADDR, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  D_VICVectAddr[0] = init_addr;
  init_addr += 0x4;
  ADD_ADDR += 0x4;
  HSA(ADD_ADDR, IDLE, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  HSA(ADD_ADDR, IDLE, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  HSA(ADD_ADDR, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  D_VICVectAddr[1] = init_addr;
  init_addr += 0x4;
  for (i = 2; i < 8; i++)
  {
    HSW( , init_addr);
    D_VICVectAddr[i] = init_addr;
    init_addr += 0x4;
  }
  ADD_ADDR += 0x1C;
  HSA(ADD_ADDR, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  D_VICVectAddr[8] = init_addr;
  init_addr += 0x4;
  ADD_ADDR += 0x4;
  HSA(ADD_ADDR, BUSY, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  HSA(ADD_ADDR, BUSY, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  HSA(ADD_ADDR, SEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  D_VICVectAddr[9] = init_addr;
  init_addr += 0x4;
  for (i = 10; i < INT_COUNT; i++)
  {
    HSW( , init_addr);
    D_VICVectAddr[i] = init_addr;
    init_addr += 0x4;
  }

  C("Program Priority registers 8 to 0");

  ADD_PRIO = VICVectPriority_BASE;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x0);
  ADD_PRIO = ADD_PRIO + 4;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x1);
  ADD_PRIO = ADD_PRIO + 4;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x2);
  ADD_PRIO = ADD_PRIO + 4;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x3);
  ADD_PRIO = ADD_PRIO + 4;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x4);
  ADD_PRIO = ADD_PRIO + 4;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x5);
  ADD_PRIO = ADD_PRIO + 4;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x6);
  ADD_PRIO = ADD_PRIO + 4;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x7);
  ADD_PRIO = ADD_PRIO + 4;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , 0x8);
  ADD_PRIO = ADD_PRIO + 4;

  /** Clear all IntEnable and SoftInt bits to clear any pending **/
  /** Interrupts.                                               **/
  HSA(VICIntEnClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , DataF);
  HSA(VICSoftIntClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , DataF);

  /** Set the IntEnable **/
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICIntEnable);

  /** Enable Protocol Checker**/
  HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICTrTCR);

  C("Interrupts - applied via VICINTSOURCE every Clock");

  /** Raise the selected Interrupts via VICINTSOURCE. **/ 
  D_TrIntSource  = 0x00000080;
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , D_TrIntSource, ,TrIntSource_write);
 
  /** Raise the selected Interrupts via VICINTSOURCE. **/ 
  D_TrIntSource  = 0x00000040;
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , D_TrIntSource, ,TrIntSource_write);
  
  /** Raise the selected Interrupts via VICINTSOURCE. **/ 
  D_TrIntSource  = 0x00000020;
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , D_TrIntSource, ,TrIntSource_write);
  
  /** Raise the selected Interrupts via VICINTSOURCE. **/ 
  D_TrIntSource  = 0x00000010;
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , D_TrIntSource, ,TrIntSource_write);
  
  /** Raise the selected Interrupts via VICINTSOURCE. **/ 
  D_TrIntSource  = 0x00000008;
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , D_TrIntSource, ,TrIntSource_write);
  
  C("Read VICVectAddr register");

  /** Service all active interrupts in order of priority. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot)
  HSR( , 0xA01C, , NoMask, ,Stack33Test_1);
  
  /** Raise the selected Interrupts via VICINTSOURCE. **/ 
  D_TrIntSource  = 0x00000004;
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , D_TrIntSource, ,TrIntSource_write);
  
  /** Raise the selected Interrupts via VICINTSOURCE. **/ 
  D_TrIntSource  = 0x00000002;
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , D_TrIntSource, ,TrIntSource_write);

  /** Write on VICVectAddr register **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  C("Clear all Interrupts");
  /** Clear interrupt source **/  
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , Data0, ,TrIntSource_write);

}
 
/************************************ End *************************************/
