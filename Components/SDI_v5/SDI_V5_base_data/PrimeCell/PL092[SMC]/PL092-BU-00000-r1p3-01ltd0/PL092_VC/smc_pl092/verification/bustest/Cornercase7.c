/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Cornercase7.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests on external wait functionality of the
--           SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/********************************  Corner Case 7 ******************************/
/******************************************************************************/
#define UseTrickMem

void Cornercase7()
{
  /*
     Summary: Cornercase 7
     =====================
     -- SMWAIT is made active before turnaround of one access and
     -- after its wait state counters have expired.
  */

  int i, j, BankNo, n;
  int Address;
  int RomData = 0x87654321;
  char PrntStr[120];
  int trans4[5] = {2,1,1,1,5};
  int trans5[9] = {2,1,0,0,2,3,1,3,5}; 
  int trans6[5] = {2,3,3,3,5};
  char* SizeStr[7] = {"WRD","HWRD", "BYTE","HWRD", "WRD","HWRD","HWRD"};

  ApplyReset();

  sprintf(PrntStr, "ISSUE -- Smc hangs if SMWAIT is active during Turnaround");
  C(PrntStr);
  /** Set Bank 1 Memory Type as SRAM (32 bits width)      **/
  /** ExtWait Enabled = 0x85, disabled = 0x81 WaitPol = 0 **/
  /** BM enable = 0xA1                                    **/
  ConfigureUUT(1, 0x05, 0x03, 0x01, 0x00, 0x00, 0x00000065, 0x000000,
                  0x000000);
#ifdef UseTrickMem
  ConfigureMemory(1, 0x05, 0x3, 0x1, 0x141, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);
#endif

  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x05, 0x19, 0x02, 0x07, 0x02, 0x00000086, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(2, 0x05, 0x19, 0x02, 0x102, SMCTrMEMBData[2], 0x07,
                  0x02, 0x000000);
  #endif


  HSA(SMCTrCEWTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x3);

  HSA(SMCTrCS2WTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x2000003);

  Address = SMCMEM_1 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0x00000000, , MaskAll, ,Cornercase6_55);


  HSA(SMCTrCEWTR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x5);

  HSA(SMCTrCS2WTR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x3000005);

  Address = SMCMEM_2 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0x00000000, , MaskAll, ,Cornercase6_55);
}
