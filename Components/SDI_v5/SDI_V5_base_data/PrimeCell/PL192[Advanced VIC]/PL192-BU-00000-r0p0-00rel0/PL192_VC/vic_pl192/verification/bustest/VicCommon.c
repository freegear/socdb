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
-- File Name              : VicCommon.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           This file contains global variables and common functions 
--           used by other tests.
-- 
-- --=========================================================================*/

/** Note:                                                            **/
/** Some set_false_path are being done for the test mode paths in    **/
/** the VIC. These paths get exercised during ITIP/ITOP register     **/
/** reads in netlist simulations leading to the buswatcher flagging  **/
/** timing violations on the HRDATA BUS. Hence, to bypass ITIP/ITOP  **/
/** register accesses during netlist simulations, a                  **/
/** "#define VICrtl_sim " directive is used in the Vic.h file. For   **/
/** only RTL simulations, the ITIP/ITOP registers are checked.       **/
/** For netlist simulations, the directive is "#define VICrtl_sim 0" **/
/** For RTL simulations, the directive is "#define VICrtl_sim 1"     **/

/******************************************************************************/
/***************************** Global Variables *******************************/
/******************************************************************************/

int prot = 0;
int32 CSR;
int32 D_VICTrSync;
int32 SWPrio[32];
int32 D_TrIntSource;
int32 D_VICSoftInt;
int32 D_VICIntSelect;
int32 D_VICIntEnable;
int32 D_TrIntIn;
int32 D_VICVectPriorityDaisy;
int32 ProtectionOff;
int32 D_TrVectAddrIn;
int32 servreg;
int32 addrout;
int32 D_VICVectAddr[32];
int32 D_VICVectPriority[32];
int32 init_swprio;
int32 init_addr;
int32 D_VICTrTCR;
int32 D_VICTrAckCnt;
int32 D_VICSWPriorityMask;

/******************************************************************************/
/***************************** Common Functions *******************************/
/******************************************************************************/

/******************************************************************************/
/********************************* Wait Loop **********************************/
/******************************************************************************/

void WaitLoop(int cyc)
{
  /* 
     Summary: Inserts Wait Loops
     ===========================
     This function performs the following:

     o  Inserts programmed number of idle cycles. 
  */

  int i;

  for (i = 0; i < cyc; i++)
  {
    HSA(ZERO, IDLE, INCR, , WRD);
    HSR( , ZERO, , MaskAll);
  }
}

/******************************************************************************/
/******************************** Write-Read Tests ****************************/
/******************************************************************************/
 
void WriteReadTests(int32 testdata, int32 mask)
{
  /*
     Summary: Write-Read Test
     ========================
     This performs performs the following: 
 
     o  Writes and expects the same data in case of the R/W registers.
 
     o  Writes and expects the default data in case of the Read-only
        registers.
  */
 
  int32 addr1, addr2, reqdata;
  int i, saveprot;
 
  /** Pattern Write-Read Tests for VICIntSelect. **/
  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , testdata & mask, , NoMask, ,VicCommon_1);

  /** Pattern Write-Read Tests for VICSWPriorityMask. **/
  HSA(VICSWPriorityMask, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICSWPriorityMask, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , testdata & 0xFFFF & mask, , NoMask, ,VicCommon_2);

  /** Pattern Write-Read Tests for VICVectPriorityDaisy. **/
  HSA(VICVectPriorityDaisy, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICVectPriorityDaisy, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , testdata & 0xF & mask, , NoMask, ,VicCommon_2);

  /** Pattern Write-Read Tests for VICVectAddr0-31 and **/
  /** VICVectCntl0-15.                                 **/
  addr1 = VICVectAddr_BASE;
  addr2 = VICVectPriority_BASE;
  reqdata = testdata & mask;
  for (i = 0; i < INT_COUNT; i++, addr1 += 0x4, addr2 += 0x4)
  {
    HSA(addr1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , testdata);
    HSA(addr1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , reqdata, , NoMask, ,VicCommon_3);
    HSA(addr2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , testdata);
    HSA(addr2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , reqdata & LSB4, , NoMask, ,VicCommon_4);
  }

  /** Pattern Write-Read Tests for VICITCR. **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , testdata & mask & VICITCR_MASK, , NoMask, ,VicCommon_5);

  C("VICVectAddr Write-Read Tests");
  
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  if(prot == 2)
  {
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , ZERO, , MaskAll, ,VicCommon_6);
  }
  else
  {
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , ZERO, , NoMask, ,VicCommon_6);
  }
 
  C("VICProtection Write-Read Tests");
  reqdata = testdata & 0x00000001 & mask;
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , reqdata, , NoMask, ,VicCommon_7);

  if (prot == 0)
  {
    saveprot = prot;
    prot = 0x2;
    HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ZERO);
    HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , ZERO, , NoMask, ,VicCommon_8);
    prot = saveprot;
  }

  /** Since, the registers are just Reset, the data in the Read-only **/
  /** registers should be their reset values.                        **/
 
  C("Read-Only Register Tests");

  /** VICRawIntr is the logical OR of the contents of TrIntSource  **/
  /** and the VICSoftInt register. Since, the reset value of these **/
  /** registers are ZERO, the content of the VICRawIntr should be  **/
  /** its reset value.                                             **/
  HSA(VICRawIntr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICIRQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICRawIntr, , NoMask, ,VicCommon_9);

  HSA(VICIRQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICIRQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICIRQStatus, , NoMask, ,VicCommon_10);

  HSA(VICFIQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICFIQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICFIQStatus, , NoMask, ,VicCommon_11);
 
  /** Clear the Integration Test Enable bit in the VICITCR. **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);

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
  /* Add two wait states. */
  WaitLoop(2);
  if(prot == 2)
  {
    HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , RST_VICITOP1, , MaskAll, ,VicCommon_12);
  }
  else
  {
    HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , RST_VICITOP1, , NoMask, ,VicCommon_12);
  }
}

  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);

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
  if(prot == 2)
  {
    HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , RST_VICITOP2, , MaskAll, ,VicCommon_12);
  }
  else
  {
    HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , RST_VICITOP2, , NoMask, ,VicCommon_12);
  }
}
 
  HSA(VICPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID0 & mask, , NoMask, ,VicCommon_14);
  HSA(VICPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID1 & mask, , NoMask, ,VicCommon_15);
  HSA(VICPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID2 & mask, , NoMask, ,VicCommon_16);
  HSA(VICPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID3 & mask, , NoMask, ,VicCommon_17);
 
  HSA(VICPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID0 & mask, , NoMask, ,VicCommon_18);
  HSA(VICPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID1 & mask, , NoMask, ,VicCommon_19);
  HSA(VICPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID2 & mask, , NoMask, ,VicCommon_20);
  HSA(VICPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);
  HSA(VICPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID3 & mask, , NoMask, ,VicCommon_21);
 
  C("VICITIP Register Tests");

  /** Set the Integration Test Enable bit in the VICITCR. The value **/
  /** written into the VICITIP1 register should be returned during  **/
  /** reads.                                                        **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , LSB1);
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);


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
  /* Add two wait states. */
  WaitLoop(2);
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , (FIQnIRQ | ADDRV) & testdata & mask, , NoMask, ,VicCommon_22);
}

  /** Clear all bits in the VICITIP1. **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  /** The value written into the VICITIP2 register should be **/
  /** returned during reads.                                 **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);

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
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , testdata & mask, , NoMask, ,VicCommon_23);
}

  /** Clear all bits in the VICITIP2. **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
 
  /** Clear the Integration Test Enable bit in the VICITCR. **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  /** Force the VICVectAddrIn to 0x0. **/
  HSA(VICTrVectAddrIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  /** Force the nVICIRQIn and nVICFIQIn inactive. **/
  HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , NoExtInt);

  /** The VICITIP1 should always contain '1' in the positions      **/
  /** corresponding to FIQ and IRQ independent of the data pattern **/
  /** written to VICITIP1.                                         **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);

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
  /* Add two wait states. */
  WaitLoop(2);
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , (FIQnIRQ | ADDRV) & mask, , NoMask, ,VicCommon_24);
}

  /** Change ITIP1 register back to Reset Value                      **/
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , RST_VICITIP1);

  /** The VICITIP2 should always contain 0x0 independent of the data **/
  /** pattern written to VICITIP2.                                   **/
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);

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
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , NoMask, ,VicCommon_25);
}

  /** The VICITIP1 should always reflect the value written in the **/
  /** VICTrIntIn.                                                 **/
  HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);

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
  HSA(VICITIP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , (testdata << 6) & mask, ,FIQnIRQ | ADDRV, ,VicCommon_26);
}

  /** The VICITIP2 should always reflect the value written in the **/
  /** VICTrVectAddrIn.                                            **/
  HSA(VICTrVectAddrIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);

  WaitLoop(0x1);
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
  HSA(VICITIP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , testdata & mask, , NoMask, ,VicCommon_27);
}

  HSA(VICTrVectAddrIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
  HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , NoExtInt);
 
  C("VICITOP Register Tests");

  /** Set the Integration Test Enable bit in the VICITCR. The value **/
  /** written into the VICITIP1 register should be returned during  **/
  /** reads.                                                        **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , LSB1);
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);


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
  /* Add two wait states. */
  WaitLoop(2);
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , testdata & mask & VICITOP1_MASK, , NoMask, ,VicCommon_28);
}

  /** Clear all bits in the VICITOP1. **/
  HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  /** The value written into the VICITOP2 register should be **/
  /** returned during reads.                                 **/
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , testdata);

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
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , testdata & mask, , NoMask, ,VicCommon_29);
}

  /** Clear all bits in the VICITOP2. **/
  HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
 
  /** Clear the Integration Test Enable bit in the VICITCR. **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);

}
 
/******************************************************************************/
/********************************* Burst Transfer *****************************/
/******************************************************************************/

void BurstTransfer(int prot, int32 mask)
{
  /*
     Summary: Burst-Transfer Tests
     =============================
     This function performs the following:
 
     o  Performs Burst transfers to the control and address registers.
  */

  int i;
  int32 initialaddr, initialprio, initialdata;

  initialaddr = VICVectAddr_BASE;
  initialdata = 0x0000A000;

  /** Burst Writes to the VICVectAddr0-31 registers. **/
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialdata += 0x4;
  for (i = 1; i < INT_COUNT; i++)
  {
    HSW( , initialdata);
    initialdata += 0x4;
  }
 
  /** Burst Reads to the VICVectAddr0-31 registers. **/
  initialaddr = VICVectAddr_BASE;
  initialdata = 0x0000A000;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_28);
  initialdata += 0x4;
  for (i = 1; i < INT_COUNT; i++)
  {
    HSR( , initialdata, , mask, ,VicCommon_29);
    initialdata += 0x4;
  }
 
  /** Burst Writes to the VICVectPriority0-31 registers. **/
  initialprio = VICVectPriority_BASE;
  initialdata = 0x1;
  HSA(initialprio, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialdata++;
  for (i = 1; i < INT_COUNT; i++)
  {
    HSW( , initialdata);
    initialdata++;
  }
 
  /** Burst Reads to the VICVectPriority0-31 registers. **/
  initialprio = VICVectPriority_BASE;
  initialdata = 0x1;
  HSA(initialprio, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata & 0xF, , mask, ,VicCommon_30);
  initialdata++;
  for (i = 1; i < INT_COUNT; i++)
  {
    HSR( , initialdata & 0xF, , mask, ,VicCommon_31);
    initialdata++;
  }
}
 
/******************************************************************************/
/********************************* Busy Transfer ******************************/
/******************************************************************************/

void BusyTransfer(int prot, int32 mask)
{
  /*
     Summary: Busy-Transfer Tests
     =============================
     This function performs the following: 
 
     o  Performs Busy transfers to the control and address registers.
 
  */
 
  int i;
  int32 initialaddr, initialprio, initialdata;

  initialaddr = VICVectAddr_BASE;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
  for (i = 1; i < INT_COUNT; i++)
  {
    HSW( , ZERO);
  } 

  /** Perform a Burst Write transfer to the VICVectAddr0-31 **/
  /** registers with BUSY cycles introduced in between.     **/
  initialaddr = VICVectAddr_BASE;
  initialdata = 0x0000A000;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
 
  /** Perform a Burst Read transfer to the VICVectAddr0-31 registers **/
  /** with BUSY cycles introduced in between.                        **/
  initialaddr = VICVectAddr_BASE;
  initialdata = 0x0000A000;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_32);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_33);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_34);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_35);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_36);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_37);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_38);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_39);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_40);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_41);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_42);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_43);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_44);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_45);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_46);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_47);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_48);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_49);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_50);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_51);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_52);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_53);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_54);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_55);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_56);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_57);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_58);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_59);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_60);
 
  initialaddr = VICVectPriority_BASE;
  for (i = 0; i < INT_COUNT; i++, initialaddr += 0x4)
  {
    HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ZERO);
  } 

  /** Perform a Burst Write transfer to the VICVectCntl0-15 **/
  /** registers with BUSY cycles introduced in between.     **/
  initialaddr = VICVectPriority_BASE;
  initialdata = 0x0;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);

  /** Perform a Burst Read transfer to the VICVectCntl0-15 registers **/
  /** with BUSY cycles introduced in between.                        **/
  initialaddr = VICVectPriority_BASE;
  initialdata = 0x0;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_61);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_62);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_63);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_64);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_65);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_66);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_67);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_68);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_69);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_70);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_71);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_72);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_73);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_74);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_75);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_76);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_77);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_78);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_79);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_80);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_81);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_82);
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_83);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_84);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_85);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_86);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_87);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, BUSY, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_88);
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_89);
} 
  
/******************************************************************************/
/********************************* Idle Transfer ******************************/
/******************************************************************************/

void IdleTransfer(int prot, int32 mask)
{
  /*
     Summary: Idle-Transfer Tests
     =============================
     This functions performs the following:
 
     o  Performs Idle transfers to the control and address registers.
 
     o  Arguments are used to use this function in the protection mode
        tests also.
  */
 
  int i;
  int32 initialaddr, initialprio, initialdata;

  initialaddr = VICVectAddr_BASE;
  for (i = 0; i < INT_COUNT; i++, initialaddr += 0x4)
  {
    HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ZERO);
  } 

  /** Perform a Burst Write transfer to the VICVectAddr0-31 **/
  /** registers with IDLE cycles introduced in between.     **/
  initialaddr = VICVectAddr_BASE;
  initialdata = 0x0000A000;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
 
  /** Perform a Write to the Wait State Register of the TrickBox. **/
  HSA(VICTrWaitStReg, NSEQ, INCR, , WRD, , 0x1);
  HSW( , Data5);

  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
 
  /** Performs a Read from the Wait State Register of the TrickBox. **/
  HSA(VICTrWaitStReg, NSEQ, INCR, , WRD, , 0x1);
  HSR( , Data5, , NoMask, ,VicCommon_90);
 
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
 
  /** Perform a Burst Read transfer to the VICVectAddr0-31 registers **/
  /** with IDLE cycles introduced in between.                        **/
  initialaddr = VICVectAddr_BASE;
  initialdata = 0x0000A000;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_91);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_92);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_93);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_94);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_95);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_96);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_97);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_98);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_99);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_100);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_101);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_102);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_103);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_104);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_105);
  initialaddr += 0x4;
  initialdata += 0x4;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_106);
 
  initialaddr = VICVectPriority_BASE;
  for (i = 0; i < INT_COUNT; i++, initialaddr += 0x4)
  {
    HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ZERO);
  } 

  /** Perform a Burst Write transfer to the VICVectCntl0-15 **/
  /** registers with IDLE cycles introduced in between.     **/
  initialaddr = VICVectPriority_BASE;
  initialdata = 0x0;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , initialdata);

  /** Perform a Burst Read transfer to the VICVectCntl0-15 registers **/
  /** with IDLE cycles introduced in between.                        **/
  initialaddr = VICVectPriority_BASE;
  initialdata = 0x0;
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_107);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_108);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_109);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_110);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_111);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_112);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_113);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_114);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_115);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_116);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_117);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_118);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_119);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_120);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , mask, ,VicCommon_121);
  initialaddr += 0x4;
  initialdata++;     
  HSA(initialaddr, SEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , initialdata, , mask, ,VicCommon_122);
}

/************************************ End *************************************/
