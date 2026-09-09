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
--  File Name              : Cornercase14.c.rca
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
/*******************************  Corner Case 14 ******************************/
/******************************************************************************/
#define UseTrickMem

void Cornercase14()
{
  /*
     Summary: Cornercase 14 
     =====================
     During a burst mode read, MCBUSREQ is given due to which SMBUSGNT will
     be removed after the current transfer.
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


  sprintf(PrntStr, "ISSUE Sequence of Burst Mode read, MCBUSREQ comes during the read");
  C(PrntStr);
  /* Case where a burst-mode read with HSIZE < MEMORYWIDTH is followed by a
     memory write access and then followed by an AHB burst of non-burst mode
     reads. The non-burst mode reads should not use burst mode read timings.
     Trickmemory violations are flagged if the timings are not followed
     properly. */
  /* Configuring the SMC and the Memory banks */
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x10, 0x8, 0x0, 0x03, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(0, 0x10, 0x8, 0x0, 0x41, SMCTrMEMBData[0], 0x03,
                  0x00, 0x000000);
  #endif

  ConfigureUUT(1, 0x01, 0x05, 0x00, 0x00, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(1, 0x01, 0x5, 0x0, 0x02, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);
  #endif

  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x03, 0x07, 0x00, 0x01, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(2, 0x03, 0x07, 0x00, 0x02, SMCTrMEMBData[2], 0x01,
                  0x00, 0x000000);
  #endif

  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x0, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(3, 0x02, 0x0, 0x0, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
  #endif

  Address = SMCMEM_0 + 0x00;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0x44332211);
  HSW( , 0x88776655);
  HSW( , 0xCCBBAA99);
  HSW( , 0x00FFEEDD);

  Address = SMCMEM_1 + 0x10;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0x12345678);
  HSW( , 0x9ABCDEF0);
  HSW( , 0xF1E2D3C4);
  HSW( , 0xB5A69788);

  Address = SMCMEM_2 + 0x18;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0x76543210);
  HSW( , 0xFEDCBA98);
  HSW( , 0x0F1E2D3C);
  HSW( , 0x4B5A6978);

  /* Make the Memory as burst ROM */
  HSA(SMBCR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x61);
  #ifdef UseTrickMem
  HSA(SMCTrMEMT_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x49);
  #endif
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x11);

  HSA(SMCTrGNT2RMREQ, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x6);

  RomData = 0x3;
  HSA(SMCTrMCBUSR, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);
  WaitLoop(10);
  /* Burst mode read  -- CS0 */
  Address = SMCMEM_0 + 0x00;
  HSA(Address, NSEQ, INCR, OK, HWRD);
  HSR( , 0x00002211, , 0x0000FFFF, ,Cornercase6_30);
  HSR( , 0x44330000, , 0xFFFF0000, ,Cornercase6_31);
  HSR( , 0x00006655, , 0x0000FFFF, ,Cornercase6_30);
  HSR( , 0x88770000, , 0xFFFF0000, ,Cornercase6_31);

  WaitLoop(10);
}
