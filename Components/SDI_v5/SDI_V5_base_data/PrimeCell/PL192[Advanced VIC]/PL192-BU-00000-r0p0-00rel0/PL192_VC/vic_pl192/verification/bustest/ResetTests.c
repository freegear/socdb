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
-- File Name              : ResetTests.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Reset Tests on the Vic.  
--
-- --=========================================================================*/
 
/******************************************************************************/
/********************************* Reset Tests ********************************/
/******************************************************************************/

void ResetTests()
{
  /*
     Summary: Reset Tests
     ====================
     This function performs the following: 

     o  All the Registers are read and their reset values are checked. 
  */ 
 
  int i;
  int32 addr;

  HSA(VICIRQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICIRQStatus, , NoMask, ,ResetTests_1);

  HSA(VICFIQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICFIQStatus, , NoMask, ,ResetTests_2);

  /** Note that the VICRawIntr is the logical OR of the VICINTSOURCE **/
  /** and the VICSoftInt bits. The value reflected in the VICRawIntr **/
  /** register will depend on the values driven on the external      **/
  /** VICINTSOURCE pins since the VICSoftInt register is reset to    **/
  /** 0x0. The reset value tests assume that the source of           **/
  /** VICINTSOURCE [the trickbox in the functional verification      **/
  /** world] drives these pins to 0x0 after reset. If the source of  **/
  /** the VICINTSOURCE drives these to a value other than 0x0, the   **/
  /** test code will have to be modified accordingly.                **/
  HSA(VICRawIntr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICRawIntr, , NoMask, ,ResetTests_3);

  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICIntSelect, , NoMask, ,ResetTests_4);

  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICIntEnable, , NoMask, ,ResetTests_5);

  /** Perform a Write to the Wait State Register of the TrickBox. **/
  HSA(VICTrWaitStReg, NSEQ, INCR, , WRD, , 0x1);
  HSW( , Data5);

  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICSoftInt, , NoMask, ,ResetTests_6);

  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICProtection, , NoMask, ,ResetTests_7);

  /** Note that the VICVectAddr is derived from the internally       **/
  /** generated Vector Address and the external Daisy Chained Vector **/
  /** Address [VICVectAddrIn]. The value reflected in the            **/
  /** VICVectAddr register will depend on the values driven on the   **/
  /** external VICVectAddrIn pins since the internally generated     **/
  /** Vector Address will be reset to 0x0. The reset value tests     **/
  /** assume that the source of VICVectAddrIn [the trickbox in the   **/
  /** functional verification world] drives these pins to 0x0 after  **/
  /** reset. If the source of the VICVectAddrIn drives these to a    **/
  /** value other than 0x0, the test code will have to be modified   **/
  /** accordingly.                                                   **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICVectAddr, , NoMask, ,ResetTests_8);

  HSA(VICSWPriorityMask, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICSWPriorityMask, , NoMask, ,ResetTests_9);

  HSA(VICVectPriorityDaisy, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICVectPriorityDaisy, , NoMask, ,ResetTests_9A);

/** Some set_false_path are being done for the test mode paths in    **/
/** the VIC. These paths get exercised during ITIP/ITOP register     **/
/** reads in netlist simulations leading to the buswatcher flagging  **/
/** timing violations on the HRDATA BUS. Hence, to bypass ITIP/ITOP  **/
/** register accesses during netlist simulations, a                  **/
/** "#define VICrtl_sim " directive is used in the Vic.h file. For   **/
/** only RTL simulations, the ITIP/ITOP registers are checked.       **/
/** For netlist simulations, the directive is "#define VICrtl_sim 0" **/
/** For RTL simulations, the directive is "#define VICrtl_sim 1"     **/
if (VICrtl_sim == 1)
{
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICITCR, , NoMask, ,ResetTests_10);

  /** Note that the VICITIP1 is derived from the internally          **/
  /** generated Interrupts and the external Daisy Chained nVICIRQIn  **/
  /** and nVICFIQIn interrupts. The value reflected in the VICITIP1  **/
  /** register will depend on the values driven on the external      **/
  /** nVICIRQIn and nVICFIQIn pins since the internally generated    **/
  /** Interrupts will be reset to 0x0. The reset value tests assume  **/
  /** that the source of nVICIRQIn and nVICFIQIn [the trickbox in    **/
  /** the functional verification world] drives these pins inactive  **/
  /** after reset. If the source of the nVICIRQIn and nVICFIQIn      **/
  /** drives these to their active values after reset, the test code **/
  /** will have to be modified accordingly.                         **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICITIP1, , NoMask, ,ResetTests_11);

  /** Note that the VICITIP2 is derived from the internally          **/
  /** generated Vector Address and the external Daisy Chained Vector **/
  /** Address [VICVectAddrIn]. The value reflected in the VICITIP2   **/
  /** register will depend on the values driven on the external      **/
  /** VICVectAddrIn pins since the internally generated Vector       **/
  /** Address will be reset to 0x0. The reset value tests assume     **/
  /** that the source of VICVectAddrIn [the trickbox in the          **/
  /** functional verification world] drives these pins to 0x0 after  **/
  /** reset. If the source of the VICVectAddrIn drives these to a    **/
  /** value other than 0x0, the test code will have to be modified   **/
  /** accordingly.                                                  **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICITIP2, , NoMask, ,ResetTests_12);
 
  /** Note that the VICITOP1 is derived from the internally          **/
  /** generated Interrupts and the external Daisy Chained nVICIRQIn  **/
  /** and nVICFIQIn interrupts. The value reflected in the VICITOP1  **/
  /** register will depend on the values driven on the external      **/
  /** nVICIRQIn and nVICFIQIn pins since the internally generated    **/
  /** Interrupts will be reset to 0x0. The reset value tests assume  **/
  /** that the source of nVICIRQIn and nVICFIQIn [the trickbox in    **/
  /** the functional verification world] drives these pins inactive  **/
  /** after reset. If the source of the nVICIRQIn and nVICFIQIn      **/
  /** drives these to their active values after reset, the test code **/
  /** will have to be modified accordingly.                          **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICITOP1, , NoMask, ,ResetTests_13);

  /** Note that the VICITOP2 is derived from the internally          **/
  /** generated Vector Address and the external Daisy Chained Vector **/
  /** Address [VICVectAddrIn]. The value reflected in the VICITOP2   **/
  /** register will depend on the values driven on the external      **/
  /** VICVectAddrIn pins since the internally generated Vector       **/
  /** Address will be reset to 0x0. The reset value tests assume     **/
  /** that the source of VICVectAddrIn [the trickbox in the          **/
  /** functional verification world] drives these pins to 0x0 after  **/
  /** reset. If the source of the VICVectAddrIn drives these to a    **/
  /** value other than 0x0, the test code will have to be modified   **/
  /** accordingly.                                                  **/
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICITOP2, , NoMask, ,ResetTests_14);
}

  /** The following 'for' loop is used to read the Reset Values of **/
  /** the VectorAddr[0-15] registers.                               **/
  addr = VICVectAddr_BASE;
  for (i = 0; i < INT_COUNT; i++, addr += 0x4)
  {
    HSA(addr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , RST_VICVectBankAddr, , NoMask, ,ResetTests_15);
  }

  /** The following 'for' loop is used to read the Reset Values of **/
  /** the VICVectCntl[0-15] registers.                             **/
  addr = VICVectPriority_BASE;
  for (i = 0; i < INT_COUNT; i++, addr += 0x4)
  { 
    HSA(addr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , RST_VICVectBankSWPrio, , NoMask, ,ResetTests_16);
  }
 
  /** Read the Reset Values of the Peripheral ID registers. **/
  HSA(VICPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID0, , NoMask, ,ResetTests_17);
  HSA(VICPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID1, , NoMask, ,ResetTests_18);
  HSA(VICPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID2, , NoMask, ,ResetTests_19);
  HSA(VICPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID3, , NoMask, ,ResetTests_20);

  /** Performs a Read from the Wait State Register of the TrickBox. **/
  HSA(VICTrWaitStReg, NSEQ, INCR, , WRD, , 0x1);
  HSR( , Data5, , NoMask, ,ResetTests_21);

  /** Read the Reset Values of the PrimeCell ID registers. **/
  HSA(VICPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID0, , NoMask, ,ResetTests_22);
  HSA(VICPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID1, , NoMask, ,ResetTests_23);
  HSA(VICPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID2, , NoMask, ,ResetTests_24);
  HSA(VICPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID3, , NoMask, ,ResetTests_25);
}

/************************************ End *************************************/
