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
--  File Name              : Cornercase6.c.rca
--  File Revision          : 1.6
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
/********************************  Corner Case 6 ******************************/
/******************************************************************************/
#define issue_bmrd_idlewr 
#define issue29
#define issue_dataoutbls
#define issue_csbls
#define issue_burstwrap
#define issue_bmrd_wr_rd
#define issue_bmrd_bmrd
#define issue_mcbusreq
#define issue_busdegnt
#define issue_smwait
#define issue30
#define UseTrickMem

void Cornercase6()
{
  /*
     Summary: Cornercase 6
     =====================

     Depending on if issue29 or issu30 is defined this test case tests different
     scenarios for burst ROM testing.
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

  C("Configuring the SMC and the Memory banks.");
  /** Set Bank 0 Memory Type as SRAM (8 bits width) **/
  /** ExtWait Enabled = 0x05, disabled = 0x01 WaitPol = 0 **/
  /** BM enable = 0x21                                    **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x0, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
#ifdef UseTrickMem
  ConfigureMemory(0, 0x02, 0x0, 0x0, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
#endif
  /** Set Bank 1 Memory Type as SRAM (32 bits width)      **/
  /** ExtWait Enabled = 0x85, disabled = 0x81 WaitPol = 0 **/
  /** BM enable = 0xA1                                    **/
     ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x00000081, 0x000000,
                  0x000000);
#ifdef UseTrickMem
  ConfigureMemory(1, 0x01, 0x5, 0x5, 0x42, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);
#endif

  /** Set Bank 2 Memory Type as ROM (32 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x03, 0x07, 0x00, 0x01, 0x00, 0x00000090, 0x000000,
               0x000000);
#ifdef UseTrickMem
  ConfigureMemory(2, 0x03, 0x07, 0x00, 0x06, SMCTrMEMBData[2], 0x01,
                  0x00, 0x000000);
#endif

  /** Set Bank 3 Memory Type as SRAM (8 bits width) **/
  /** ExtWait Enabled = 0x05, disabled = 0x01 WaitPol = 0 **/
  /** BM enable = 0x21                                    **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x0, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
#ifdef UseTrickMem
  ConfigureMemory(3, 0x02, 0x0, 0x0, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
#endif

  AHBWriteMem(2, 0, 16, RomData);

#ifdef issue_bmrd_idlewr
  sprintf(PrntStr, "ISSUE 6: IDLE Write after burst read");
  C(PrntStr);
  /* In this case, an idle write initiated after a read. This should
     not result in a write to the memory device */
     
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

  /* Make the Memory as burst ROM */
  HSA(SMBCR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x61);
  #ifdef UseTrickMem
  HSA(SMCTrMEMT_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x49);
  #endif

  Address = SMCMEM_0 + 0x00;
  HSA(Address, NSEQ, INCR, OK, HWRD);
  HSR( , 0x00002211, , 0x0000FFFF, ,Cornercase6_30);
  HSR( , 0x44330000, , 0xFFFF0000, ,Cornercase6_31);
  
  Address = SMCMEM_1 + 0x14;
  HSA(Address, IDLE, INCR, OK, WRD);
  HSW( , 0xEFCDAB89);

  Address = SMCMEM_1 + 0x10;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0x12345678, , NoMask, ,Cornercase6_34);
  HSR( , 0x9ABCDEF0, , NoMask, ,Cornercase6_35);
  HSR( , 0xF1E2D3C4, , NoMask, ,Cornercase6_36);
  HSR( , 0xB5A69788, , NoMask, ,Cornercase6_37);

  WaitLoop(10);
  
#endif /* Issue_bmrd_idlewr */

#ifdef issue30

  C("Configuring the SMC and the Memory banks.");
  /** Set Bank 0 Memory Type as SRAM (8 bits width) **/
  /** ExtWait Enabled = 0x05, disabled = 0x01 WaitPol = 0 **/
  /** BM enable = 0x21                                    **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x0, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
#ifdef UseTrickMem
  ConfigureMemory(0, 0x02, 0x0, 0x0, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
#endif
  /** Set Bank 1 Memory Type as SRAM (32 bits width)      **/
  /** ExtWait Enabled = 0x85, disabled = 0x81 WaitPol = 0 **/
  /** BM enable = 0xA1                                    **/
     ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x00000081, 0x000000,
                  0x000000);
#ifdef UseTrickMem
  ConfigureMemory(1, 0x01, 0x5, 0x5, 0x42, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);
#endif

  /** Set Bank 2 Memory Type as ROM (32 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x03, 0x07, 0x00, 0x01, 0x00, 0x00000090, 0x000000,
               0x000000);
#ifdef UseTrickMem
  ConfigureMemory(2, 0x03, 0x07, 0x00, 0x06, SMCTrMEMBData[2], 0x01,
                  0x00, 0x000000);
#endif

  /** Set Bank 3 Memory Type as SRAM (8 bits width) **/
  /** ExtWait Enabled = 0x05, disabled = 0x01 WaitPol = 0 **/
  /** BM enable = 0x21                                    **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x0, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
#ifdef UseTrickMem
  ConfigureMemory(3, 0x02, 0x0, 0x0, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
#endif

  AHBWriteMem(2, 0, 16, RomData);

  sprintf(PrntStr, "ISSUE 30");
  C(PrntStr);
/* Write something to Bank 0 */
  Address = SMCMEM_0 + 0x30;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0x00FFEEDD);
  HSW( , 0xCCBBAA99);
  HSW( , 0x88776655);
  HSW( , 0x44332211);

/* Write something to Bank 1 */
  Address = SMCMEM_1 + 0x20;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0x44332211);
  HSW( , 0x88776655);
  HSW( , 0xCCBBAA99);
  HSW( , 0x00FFEEDD);

/* Make the Bank 1 as burst ROM */
  HSA(SMBCR1, NSEQ, SINGLE, OK, WRD);
  HSW(, 0xA1);
#ifdef UseTrickMem
  HSA(SMCTrMEMT_1, NSEQ, INCR, OK, WRD);
  HSW(, 0x4A);
#endif

/* 1 */

/* Burst reads with broken burst */
  Address = SMCMEM_1 + 0x24;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0x88776655, , NoMask, ,Cornercase6_5);
  HSR( , 0xCCBBAA99, , NoMask, ,Cornercase6_6);
/* Read from bank 0 (non BROM) */
  Address = SMCMEM_0 + 0x31;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0xEE00, , BUnMask1, ,Cornercase6_7);

/* 2 */
/* Burst reads with broken burst */
  Address = SMCMEM_1 + 0x21;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x00002200, , BUnMask1, ,Cornercase6_8);
  HSR( , 0x00330000, , BUnMask2, ,Cornercase6_9);
  HSR( , 0x44000000, , BUnMask3, ,Cornercase6_9);
  HSR( , 0x00000055, , BUnMask0, ,Cornercase6_9);
  HSR( , 0x00006600, , BUnMask1, ,Cornercase6_9);
  HSR( , 0x00770000, , BUnMask2, ,Cornercase6_9);
/* Write to SRAM */
  Address = SMCMEM_0 + 0x11;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSW( , 0x21);
  HSW( , 0x23);
  HSW( , 0x25);
/* Burst reads again */
  Address = SMCMEM_1 + 0x26;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x770000, , BUnMask2, ,Cornercase6_10);
  HSR( , 0x88000000, , BUnMask3, ,Cornercase6_11);
  HSR( , 0x99, , BUnMask0, ,Cornercase6_12);
/* Reads from a ROM */
  Address = SMCMEM_2;
  HSA(Address, NSEQ, INCR4, OK, WRD);
  HSR( , RomData++, , NoMask, ,Cornercase6_13);
  HSR( , RomData++, , NoMask, ,Cornercase6_14);
  HSR( , RomData++, , NoMask, ,Cornercase6_15);
  HSR( , RomData++, , NoMask, ,Cornercase6_16); 
/* Read from SRAM */
  Address = SMCMEM_0 + 0x11;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x00002100, , BUnMask1);
  HSR( , 0x00230000, , BUnMask2);
  HSR( , 0x25000000, , BUnMask3);
  
/* 3 */
/* Burst reads */
  Address = SMCMEM_1 + 0x20;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x00000011, , BUnMask0, ,Cornercase6_17);
  HSR( , 0x00002200, , BUnMask1, ,Cornercase6_18);
  HSR( , 0x00330000, , BUnMask2, ,Cornercase6_19);
  HSR( , 0x44000000, , BUnMask3, ,Cornercase6_20);
  HSR( , 0x00000055, , BUnMask0, ,Cornercase6_21);
  HSR( , 0x00006600, , BUnMask1, ,Cornercase6_22);
/* Read from bank 0 (non BROM) */
  Address = SMCMEM_0 + 0x31;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x0000EE00, , BUnMask1, ,Cornercase6_23);
  HSR( , 0x00FF0000, , BUnMask2, ,Cornercase6_24);
  HSR( , 0x00000000, , BUnMask3, ,Cornercase6_25);
  HSR( , 0x00000099, , BUnMask0, ,Cornercase6_26);

#endif
#ifdef issue_csbls
  sprintf(PrntStr, "ISSUE 7: CS & BLS");
  C(PrntStr);
  /* Case where write to a different chip select initiated on the same
     clock as the previous write results in no turnarounds. The first
     write is to a device RBLE low and the second to a device with RBLE
     high. This was resulting in just half a clock between deassertion of BLS
     and re-assertion */

  /* Configuring the SMC and the Memory banks */
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x5, 0x5, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(0, 0x02, 0x5, 0x5, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
  #endif
  ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(1, 0x01, 0x5, 0x5, 0x02, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);
  #endif

  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x03, 0x07, 0x00, 0x01, 0x00, 0x00000090, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(2, 0x03, 0x07, 0x00, 0x06, SMCTrMEMBData[2], 0x01,
                  0x00, 0x000000);
  #endif

  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x0, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(3, 0x02, 0x0, 0x0, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
  #endif

  Address = SMCMEM_1 + 0x02;
  HSA(Address, NSEQ, INCR, OK, HWRD);
  HSW( , 0x44332211);

  WaitLoop(7);

  Address = SMCMEM_0 + 0x10;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0x12345678);
  
  Address = SMCMEM_1 + 0x00;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0x22110000, , 0xFFFF0000, ,Cornercase6_38);
  Address = SMCMEM_0 + 0x10;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0x12345678, , NoMask, ,Cornercase6_38);

#endif /* Issue_csbls */

#ifdef issue_dataoutbls
  C(" Configure the memory");

  /** Set Bank 5 Memory Type as SRAM (16 bits width) **/
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x1F, 0x00, 0x00, 0x00, 0x00000041, 0x000005,
               0x000005);
  ConfigureMemory(5, 0x03, 0x1F, 0x00, 0x041, SMCTrMEMBData[5], 0x00,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case disabled **/
  ConfigureUUT(6, 0x04, 0x1F, 0x00, 0x00, 0x00, 0x00000004, 0x000005,
               0x000005);
  ConfigureMemory(6, 0x04, 0x1F, 0x00, 0x100, SMCTrMEMBData[6], 0x00,
                  0x00, 0x000000);

  C("Write without busy");
  Address = SMCMEM_5 + 0x420 * 0x00;
  Sequence('w',Address, trans6,"wr4",2,0x55555555,0);
   
  C("Insert Busy for 32 bit Memory device");

  Sequence('w',Address, trans5,"wr4",2,0x46222246,0);
  Address = SMCMEM_6 + 0x520 * 0x00;
  Sequence('w',Address, trans5,"wr4",2,0x46222246,0);
  Address = SMCMEM_5 + 0x420 * 0x00;
  Sequence('r',Address, trans4,"wr4",2,0x46222246,0);
  Address = SMCMEM_6 + 0x520 * 0x00;
  Sequence('r',Address, trans4,"wr4",2,0x46222246,0);
#endif

#ifdef issue_burstwrap
  sprintf(PrntStr, "ISSUE 10: Burst end indicator generation for WRAP transfers");
  C(PrntStr);
  /* Test case for a WRAP4 read with HSIZE Word from a Halfword memory size
     devivce. This read results in 8 reads to the memory. The first read should
     take WST1 access time followed by three reads with WST2 access time and
     then a read with WST1 and so on. PL092 was taking WST1 access time for
     the first read while all other reads were taking WST2 access time.*/ 

  Address = SMCMEM_0 + 0x00;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0x44332211);
  HSW( , 0x88776655);
  HSW( , 0xCCBBAA99);
  HSW( , 0x00FFEEDD);

  /* Make the Memory as burst ROM */
  HSA(SMBCR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x61);
  HSA(SMBWST1R0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x4);
  HSA(SMBWST2R0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x0);
  HSA(SMBWSTWENR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x0);
  HSA(SMBWSTOENR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x0);
  #ifdef UseTrickMem
  HSA(SMCTrMEMT_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x49);
  HSA(SMCTrWST1_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x4);
  HSA(SMCTrWST2_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x0);
  HSA(SMCTrCS2OEN_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x0);
  HSA(SMCTrCS2WEN_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x0);
  #endif

  Address = SMCMEM_0 + 0x00;
  HSA(Address, NSEQ, WRAP4, OK, WRD);
  HSR( , 0x44332211, , NoMask, ,Cornercase6_30);
  HSR( , 0x88776655, , NoMask, ,Cornercase6_31);
  HSR( , 0xCCBBAA99, , NoMask, ,Cornercase6_30);
  HSR( , 0x00FFEEDD, , NoMask, ,Cornercase6_31);
  
  WaitLoop(10);
  
#endif /* Issue_burstwrap */

#ifdef issue_bmrd_wr_rd

  sprintf(PrntStr, "ISSUE 12: Sequence of Burst Mode read, normal write and normal read");
  C(PrntStr);
  /* Case where a burst-mode read with HSIZE < MEMORYWIDTH is followed by a
     memory write access and then followed by an AHB burst of non-burst mode
     reads. The non-burst mode reads should not use burst mode read timings.
     Trickmemory violations are flagged if the timings are not followed
     properly. */
  /* Configuring the SMC and the Memory banks */
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x5, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(0, 0x02, 0x5, 0x0, 0x41, SMCTrMEMBData[0], 0x00,
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

  /* Burst mode read  -- CS0 */
  Address = SMCMEM_0 + 0x00;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x00002211, , 0x000000FF, ,Cornercase6_30);
  HSR( , 0x00002211, , 0x0000FF00, ,Cornercase6_30);
  HSR( , 0x44330000, , 0x00FF0000, ,Cornercase6_31);
  
  /* Normal write -- CS1 */ 
  Address = SMCMEM_1 + 0x14;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0xEFCDAB89);

  /* Normal read -- CS2 */
  Address = SMCMEM_2 + 0x1C;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0xFEDCBA98, , NoMask, ,Cornercase6_34);
  HSR( , 0x0F1E2D3C, , NoMask, ,Cornercase6_35);

  /* Check if the normal write (CS1) has happened. */
  Address = SMCMEM_1 + 0x14;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0xEFCDAB89, , NoMask, ,Cornercase6_36);

  WaitLoop(10);

#endif /* issue_bmrd_wr_rd */

#ifdef issue_bmrd_bmrd

  sprintf(PrntStr, "ISSUE 13: Sequence of Burst Mode read followed by burst mode read burst");
  C(PrntStr);
  /* Burst mode read with HSIZE = MSIZE followed by a Burst mode read burst.
     The second burst should follow burst mode timings. Otherwise, the
     trickmemory will flag warnings */

  /* Configuring the SMC and the Memory banks. */
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x5, 0x5, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(0, 0x02, 0x5, 0x5, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
  #endif

  ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(1, 0x01, 0x5, 0x5, 0x02, SMCTrMEMBData[1], 0x00,
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

  /* Make the Memory as burst ROM */
  HSA(SMBCR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x61);
  #ifdef UseTrickMem
  HSA(SMCTrMEMT_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x49);
  #endif

  /* Burst mode read  -- CS0 */
  Address = SMCMEM_0 + 0x00;
  HSA(Address, NSEQ, INCR, OK, HWRD);
  HSR( , 0x00002211, , 0x0000FFFF, ,Cornercase6_30);
  HSR( , 0x44330000, , 0xFFFF0000, ,Cornercase6_31);
  
  /* Burst mode read  -- CS0 */
  HSA(Address, NSEQ, INCR, OK, HWRD);
  HSR( , 0x00002211, , 0x0000FFFF, ,Cornercase6_30);
  HSR( , 0x44330000, , 0xFFFF0000, ,Cornercase6_30);

  WaitLoop(10);

#endif /* Issue bmrd_bmrd */

#ifdef issue_mcbusreq

  sprintf(PrntStr, "ISSUE 14: MCBUSREQ and SMBUSREQ getting asserted on same clock");
  C(PrntStr);
  /* Case where MCBUSREQ is asserted on the same clock as SMBUSREQ. SMBUSREQ
     is asserted for a memory write. MCBUSGNT should get asserted and SMC
     should not drive the memory bus. Otherwise, the write to memory gets
     masked and a read error is flagged on read-back */

  /* Configuring the SMC and the Memory banks. */
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x5, 0x5, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(0, 0x02, 0x5, 0x5, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
  #endif

  ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(1, 0x01, 0x5, 0x5, 0x02, SMCTrMEMBData[1], 0x00,
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

  /* Initialise trickbox for MC busreq */
  RomData = 0x5;
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);

  /* Program the time between getting grant and deasserting busreq */
  RomData = 0x3;
  HSA(SMCTrGNT2RMREQ, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);

  /* Program MC Address (to be used by SMC as SMADDR when the gnt is given */
  RomData = random();
  HSA(SMCTrMCADDR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);
  
  /* MCBUSREQ assertion */
  RomData = 0x3;
  HSA(SMCTrMCBUSR, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);

  WaitLoop(3);

  /* Normal write access */
  Address = SMCMEM_2 + 0x18;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0xAAAAAAAA);

  /* Read-back to check whether data is written into memory */
  Address = SMCMEM_2 + 0x18;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0xAAAAAAAA, , NoMask, ,Cornercase6_37);

#endif /* Issue mcbusreq */

#ifdef issue_busdegnt

  sprintf(PrntStr, "ISSUE 15: SMBUSREQ degranting");
  C(PrntStr);

  /* Configuring the SMC and the Memory banks. */
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x5, 0x5, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(0, 0x02, 0x5, 0x5, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
  #endif

  ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(1, 0x01, 0x5, 0x5, 0x02, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);
  #endif

  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x03, 0x07, 0x02, 0x01, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(2, 0x03, 0x07, 0x02, 0x02, SMCTrMEMBData[2], 0x01,
                  0x00, 0x000000);
  #endif

  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x0, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(3, 0x02, 0x0, 0x0, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);
  #endif

  /* Initialise trickbox for MC busreq */
  RomData = 0x5;
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);

  /* Program the time between getting grant and deasserting busreq */
  RomData = 0x3;
  HSA(SMCTrGNT2RMREQ, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);

  /* Program MC Address (to be used by SMC as SMADDR when the gnt is given */
  RomData = random();
  HSA(SMCTrMCADDR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);
  
  /* MCBUSREQ assertion */
  RomData = 0x4;
  HSA(SMCTrMCBUSR, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( , RomData);

  /* Normal write access */
  Address = SMCMEM_2 + 0x18;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0xAAAAAAAA);

  Address = SMCMEM_0 + 0x18;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0xBBBBBBBB);

  /* Read-back to check whether data is written into memory */
  Address = SMCMEM_2 + 0x18;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0xAAAAAAAA, , NoMask, ,Cornercase6_37);
  Address = SMCMEM_0 + 0x18;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0xBBBBBBBB, , NoMask, ,Cornercase6_37);

#endif /* Issue busdegnt */

#ifdef issue_smwait

  sprintf(PrntStr, "ISSUE 8: External Wait Enable");
  C(PrntStr);

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0xF, 0x00, 0x04, 0x00, 0x01, 0x00000087, 0x000004,
               0x000002);
  #ifdef UseTrickMem
  ConfigureMemory(0, 0xF, 0x00, 0x04, 0x342, SMCTrMEMBData[0], 0x00,
                  0x01, 0x000000);
  #endif

  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x01, 0x07, 0x02, 0x01, 0x00, 0x00000080, 0x000000,
               0x000000);
  #ifdef UseTrickMem
  ConfigureMemory(2, 0x01, 0x07, 0x02, 0x02, SMCTrMEMBData[2], 0x01,
                  0x00, 0x000000);
  #endif

  HSA(SMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x3000005);

  HSA(SMCTrCEWTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x9);

  /** Write into the Memory through the SMC **/
  Address = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x55555555);

  /** Write into the Memory through the SMC **/
  Address = SMCMEM_2 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xAAAAAAAA);

  /** Write into the Memory through the SMC **/
  Address = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x55555555);

  /** Write into the Memory through the SMC **/
  Address = SMCMEM_2 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xAAAAAAAA);

  /** Write into the Memory through the SMC **/
  Address = SMCMEM_2 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xAAAAAAAA);

  /** Write into the Memory through the SMC **/
  Address = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x55555555);

  /** Read from the Memory through the SMC **/
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x55555555, , NoMask, ,SMWAIT_Cornercase);

  WaitLoop(0x5);

  /** Write into the Memory through the SMC **/
  Address = SMCMEM_2 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xAAAAAAAA);

  /** Read from the Memory through the SMC **/
  Address = SMCMEM_2 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xAAAAAAAA, , NoMask, ,SMWAIT_Cornercase);

#endif /* Issue smwait */

#ifdef issue29
  sprintf(PrntStr, "ISSUE 29");
  C(PrntStr);
  Address = SMCMEM_0 + 0x20;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW( , 0x44332211);
  HSW( , 0x88776655);
  HSW( , 0xCCBBAA99);
  HSW( , 0x00FFEEDD);

/* Make the Memory as burst ROM */
  HSA(SMBCR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x21);
#ifdef UseTrickMem
  HSA(SMCTrMEMT_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x48);
#endif

  Address = SMCMEM_0 + 0x24;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x55, , BUnMask0, ,Cornercase6_0);
  Address = SMCMEM_0 + 0x25;
  HSA(Address, BUSY, INCR, OK, BYTE);
  HSR( , 0x55, , BUnMask0, ,Cornercase6_1);

  Address = SMCMEM_0 + 0x21;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x2200, , BUnMask1, ,Cornercase6_2);
  Address = SMCMEM_0 + 0x22;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0x330000, , BUnMask2, ,Cornercase6_3);
  Address = SMCMEM_0 + 0x23;
  HSA(Address, BUSY, INCR, OK, BYTE);
  HSR( , 0x44, , BUnMask0, ,Cornercase6_4);

#endif /* Issue29 */

}
