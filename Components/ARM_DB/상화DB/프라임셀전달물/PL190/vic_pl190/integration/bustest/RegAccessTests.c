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
-- File Name              : RegAccessTests.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           Routines to perform Integration Tests on the AHB signals. 
--
-- --=================================================================*/

void RegAccessTests(void)
{
  /*
    Summary: Register Access Tests
    ==============================

    This test performs the Integration testing of the following AHB
    signals:
    - HCLK      : Verification of the following tests implicitly prove
                  the connectivity of HCLK.
    - HRESETn   : Verification of the following tests implicitly prove
                  the connectivity of HRESETn.
    - HADDR     : 1's and 0's are made to appear on these lines by
                  accessing all the internal registers of the VIC.
    - HTRANS[1] : A '1' and a '0' is made to appear on this line by
                  making NSEQ and IDLE transfer accesses to the VIC.
    - HWRITE    : Read and Write accesses causes this line to toggle.
    - HSIZE     : 1's and 0's are made to appear on these lines by
                  making WORD and HWRD accesses.
    - HPROT[1]  : A '1' and a '0' is made to appear on this line by
                  making 'User' and 'Supervisor' accesses.
    - HWDATA    : 1's and 0's are made to appear on these lines by
                  writing different data patterns (eg. 0x55555555 and
                  0xAAAAAAAA) into internal registers of the VIC.
    - HSELVIC   : This line is toggled by accessing a location
                  with HADDR[11:2] same as the offset address of a VIC
                  register (say VICIntSelect) and with a base address
                  different from that of the VIC. The connectivity is
                  verified by checking for the unmodified data in the
                  above register.
    - HRDATA    : 1's and 0's are made to appear on these lines by
                  writing and then reading different data patterns
                  (eg. 0x55555555 and 0xAAAAAAAA) into internal
                  registers of the VIC.
  */

  int i;

  /** Access all registers to toggle and test the HADDR lines. **/ 
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , RST_VICITCR, , NoMask);
  HSR( , RST_VICITIP1, , FIQnIRQ);
  HSR( , RST_VICITIP2, , NoMask);
  HSR( , RST_VICITOP1, , NoMask);
  HSR( , RST_VICITOP2, , NoMask);

  /** Set the VICITCR to ensure that the status registers contain   **/
  /** Zeroes. This will mask values present on the external inputs. **/ 
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , LSB1);

  HSA(VICIRQStatus, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , RST_VICIRQStatus, , NoMask);
  HSR( , RST_VICFIQStatus, , NoMask);
  HSR( , RST_VICRawIntr, , NoMask);
  HSR( , RST_VICIntSelect, , NoMask);
  HSR( , RST_VICIntEnable, , NoMask);

  HSR( , Data0, , NoMask);
  HSR( , RST_VICSoftInt, , NoMask);
  HSR( , Data0, , NoMask);
  HSR( , RST_VICProtection, , NoMask);

  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , RST_VICVectAddr, , NoMask);
  HSR( , RST_VICDefVectAddr, , NoMask);

  HSA(VICVectAddr_BASE, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , RST_VICVectBankAddr, , NoMask);
  for (i = 1; i < VEC_COUNT; i++)
    HSR( , RST_VICVectBankAddr, , NoMask);

  HSA(VICVectCntl_BASE, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , RST_VICVectBankCntl, , NoMask);
  for (i = 1; i < VEC_COUNT; i++)
    HSR( , RST_VICVectBankCntl, , NoMask);

  HSA(VICPeriphID0, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , RST_VICPeriphID0, , NoMask);
  HSR( , RST_VICPeriphID1, , NoMask);
  HSR( , RST_VICPeriphID2, , NoMask);
  HSR( , RST_VICPeriphID3, , NoMask);
  HSR( , RST_VICPCellID0, , NoMask);
  HSR( , RST_VICPCellID1, , NoMask);
  HSR( , RST_VICPCellID2, , NoMask);
  HSR( , RST_VICPCellID3, , NoMask);

  /** HPROT :                                                  **/
  /** Configure the VIC in 'PROTECTED' mode                    **/
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x1);
  /** Change the Control Vector Configuration for toggling the **/
  /** HPROT[1] input.                                          **/
  TCV(0x40000000, WRD, 1, 0, 0x2);
  /** Write Data5 into VICDefVectAddr in 'PROTECTED' mode      **/
  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , Data5);
  /** Write into VICDefVectAddr in 'USER' mode                 **/
  TCV(0x40000000, WRD, 1, 0, 0x0);
  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , DataA);
  /** Check for the unmodified data in VICDefVectAddr and then **/
  /** re-configure the VIC in 'USER' mode                      **/
  TCV(0x40000000, WRD, 1, 0, 0x2);
  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , Data5, , NoMask);
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , 0x0);
  TCV(0x40000000, WRD, 1, 0, 0x0);

  /** HSIZE:                                                        **/
  /** Write DataA to VICDefVectAddr and verify it by reading the    **/
  /** register. Both these accesses are done with HSIZE = WRD (i.e. **/
  /** HSIZE = 2).                                                   **/
  /** Change the HSIZE to HWRD using the TCV command.               **/
  /** Write Data5 to VICDefVectAddr with HSIZE = HWRD (i.e.         **/
  /** HSIZE = 1) Change the HSIZE back to WRD. Then a NSEQ read     **/
  /** access is made to read the unmodified data (DataA).           **/

  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , DataA);

  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , DataA, , NoMask);

  TCV(0x40000000, HWRD, 1, 0, 0x0);
  HSA(VICDefVectAddr, NSEQ, INCR, , HWRD, , 0x1, , );
  HSW( , Data5);

  TCV(0x40000000, WRD, 1, 0, 0x0);
  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , DataA, , NoMask);

  /** HTRANS[1]:                                                    **/
  /** Write 0xFFFFFFFF to VICDefVectAddr and verify it by reading   **/
  /** the register. Both these accesses are made with HTRANS = NSEQ **/
  /** (i.e. HTRANS[1] = 1).                                         **/
  /** Write 0x00000000 to VICDefVectAddr with HTRANS = IDLE (i.e.   **/
  /** HTRANS[1] = 0). Then an NSEQ read is made for the unmodified  **/
  /** data.                                                         **/
  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , DataF);

  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , DataF, , NoMask);

  HSA(VICDefVectAddr, IDLE, INCR, , WRD, , 0x1, , );
  HSW( , Data0);

  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , DataF, , NoMask);

  /** HSELVIC:                                                      **/
  /** Write DataF into a location with HADDR[11:2] same as the      **/
  /** VICIntSelect and base address different from that of the VIC  **/
  /** Read VICIntSelect for Data0 to verify the toggling of HSELVIC **/
  /** under the assumption that the connectivity for HTRANS[1] has  **/
  /** been proved.                                                  **/
  
  HSA(ALT_BASE, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , DataF);

  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , );
  HSR( , Data0, , NoMask);

  /** Clear the VICITCR register. **/
  HSA(VICITCR, NSEQ, INCR, , WRD, , 0x1, , );
  HSW( , Data0);
}

/******************************** End *********************************/
