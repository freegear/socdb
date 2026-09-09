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
--  File Name              : Cornercase12.c.rca
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
/*******************************  Corner Case 12 ******************************/
/******************************************************************************/
#define UseTrickMem
#undef issue_nonwaiten_waiten

void Cornercase12()
{
  /*
     Summary: Cornercase 12 
     ======================
     A write is done to a non waitenabled bank followed by write to a 
     wait enabled bank.
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

  sprintf(PrntStr, "ISSUE non Wait Enable write followed by Wait Enabled Write");
  C(PrntStr);

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x5, 0x16, 0x19, 0x07, 0x0F, 0x00000087, 0x000004,
               0x000002);
  #ifdef UseTrickMem
  ConfigureMemory(0, 0x5, 0x16, 0x19, 0x342, SMCTrMEMBData[0], 0x07,
                  0x0F, 0x000000);
  #endif

  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x00, 0x19, 0x02, 0x07, 0x02, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(2, 0x00, 0x02, 0x02, 0x02, SMCTrMEMBData[2], 0x07,
                  0x02, 0x000000);
  #endif

  HSA(SMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x2000003);

  HSA(SMCTrCEWTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xC);

  Address = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x55555555);

  Address = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + 0x4;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x66666666);

  WaitLoop(0x10);


  Address = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x11111111);

  Address = SMCMEM_0 + (SMCTrMEMBData[2] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x22222222);
}
