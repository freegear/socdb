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
--  File Name              : Cornercase9.c.rca
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
/********************************  Corner Case 9 ******************************/
/******************************************************************************/
#define UseTrickMem

void Cornercase9()
{
  /*
     Summary: Cornercase 9
     =====================
     During a Memory read CANCELSMWAIT is given and furthu accesses are
     initiated on the AHB side with SMWAIT still asserted.
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

  sprintf(PrntStr, "ISSUE -- After CANCELSMWAIT comes all the accesses are initiated on the memory side even though SMWAIT is still active");
  C(PrntStr);

  ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(1, 0x01, 0x5, 0x5, 0x02, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);
  #endif

  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x05, 0x19, 0x02, 0x07, 0x02, 0x000000A4, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(2, 0x05, 0x19, 0x02, 0x104, SMCTrMEMBData[2], 0x07,
                  0x02, 0x000000);
  #endif

  HSA(SMCTrCEWTR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x7);

  HSA(SMCTrCS2WTR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x2000003);


  HSA(SMCTrCNCLWAIT, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x21);

  Address = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
  HSA(Address, NSEQ, INCR, ERROR, HWRD);
  HSR( , 0x00000000, , MaskAll, ,Cornercase6_55);

  Address = SMCMEM_1 + (SMCTrMEMBData[2] << 11);
  HSA(Address, NSEQ, INCR, ERROR, HWRD);
  HSR( , 0x00000000, , MaskAll, ,Cornercase6_55);

  WaitLoop(0x3);
  Address = SMCMEM_1 + (SMCTrMEMBData[2] << 11) + 0x4;
  HSA(Address, NSEQ, INCR, OK, HWRD);
  HSW( , 0x1);

  HSA(SMCTrCNCLWAIT, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x1);
  WaitLoop(0x10);
}
