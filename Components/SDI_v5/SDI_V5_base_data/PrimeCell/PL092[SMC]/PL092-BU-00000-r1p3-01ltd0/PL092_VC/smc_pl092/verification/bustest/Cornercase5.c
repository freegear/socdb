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
--  File Name              : Cornercase5.c.rca
--  File Revision          : 1.4
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
/********************************  Corner Case 5 ******************************/
/******************************************************************************/

#undef issue24
#define issue26 1
#undef issue28

void Cornercase5()
{
  /*
     Summary: Cornercase 5
     =====================
     This function performs the following:

     First write HSIZE = MSIZE. Second write HSIZE < MEMSIZE (say 8 and 32) and 
     a) address is such that it is the first byte in the 32-bits. Follow this 
        sequence with SEQ writes
     b) address is last access in the 32 bits. Follow the second write with a read. 

  */

  int i, j, BankNo, n;
  int Address;

  C("Configuring the SMC and the Memory banks.");
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled = 0x85, disabled = 0x81 WaitPol = 0 **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0xF, 0xF, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0xF, 0xF, 0x142, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

#ifdef issue24
  Address = SMCMEM_0 + 0x20;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x54819036);

  Address = SMCMEM_0 + 0x20;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSW( , 0x99);
  HSW( , 0xAA);
  HSW( , 0xBB);
  HSW( , 0xCC);

  Address = SMCMEM_0 + 0x20;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0xCCBBAA99, , NoMask);

  Address = SMCMEM_0 + 0x20;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x54819036);

  Address = SMCMEM_0 + 0x23;
  HSA(Address, NSEQ, SINGLE, OK, BYTE);
  HSW( , 0xbb);

  Address = SMCMEM_0 + 0x20;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0xbb819036, , NoMask);
#endif /* Issue24 */

#ifdef issue26
  C("Issue 26");
/* General write */
  Address = SMCMEM_0 + 0x20;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x54819036);

/* Byte write with burst of 4 */
  Address = SMCMEM_0 + 0x21;
  HSA(Address, NSEQ, INCR8, OK, BYTE);
  HSW( , 0x11);
  HSA(Address + 0x1, BUSY, INCR8, OK, BYTE);
  HSW( , 0x22);
  HSA(Address + 0x1, BUSY, INCR8, OK, BYTE);
  HSW( , 0x22);
  HSA(Address + 0x1, BUSY, INCR8, OK, BYTE);
  HSW( , 0x22);

/* Write to some other address and read */
  Address = SMCMEM_0 + 0x40;
  HSA(Address, NSEQ, INCR8, OK, HWRD);
  HSW( , 0x12345678);
  HSW( , 0x12345678);
/*  Address = SMCMEM_0 + 0x40;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x56785678, , NoMask); */

/* General write */
  Address = SMCMEM_0 + 0x30;
  HSA(Address + 0x4, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x22071973);
/* Read from the broken burst address */
  Address = SMCMEM_0 + 0x20;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x54811136, , NoMask);

/* General write */
  Address = SMCMEM_0 + 0x30;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x07081975);

/* Byte write with burst of 4 */
  Address = SMCMEM_0 + 0x31;
  HSA(Address, NSEQ, INCR8, OK, BYTE);
  HSW( , 0x11);
  HSA(Address + 0x1, BUSY, INCR8, OK, BYTE);
  HSW( , 0x22);
  HSA(Address + 0x1, BUSY, INCR8, OK, BYTE);
  HSW( , 0x22);
  HSA(Address + 0x1, SEQ, INCR8, OK, BYTE);
  HSW( , 0x22);
  HSW( , 0x33);
  HSW( , 0x44);
  HSA(Address + 0x4, BUSY, INCR8, OK, BYTE);
  HSW( , 0x45);
  HSA(Address + 0x4, NSEQ, INCR8, OK, BYTE);
  HSW( , 0x55);
  HSA(Address + 0x5, BUSY, INCR8, OK, BYTE);
  HSW( , 0x45);
  HSA(Address + 0x5, SEQ, INCR8, OK, BYTE);
  HSW( , 0x66);
  HSA(Address + 0x6, BUSY, INCR8, OK, BYTE);
  HSW( , 0x77);
/* Break the burst at non aligned place. */

/* Write to some other address and read */
  Address = SMCMEM_0 + 0x50;
  HSA(Address, NSEQ, INCR8, OK, HWRD);
  HSW( , 0x87654321);
  HSW( , 0x87654321);
/*  Address = SMCMEM_0 + 0x50;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x43214321, , NoMask); */

/* Read from the broken burst address */
  Address = SMCMEM_0 + 0x30;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0x33221175, , NoMask);
  HSR( , 0x22665544, , NoMask);

/* General write */
  Address = SMCMEM_0 + 0x60;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x6491A046);

/* Byte write with burst of 4 */
  Address = SMCMEM_0 + 0x5F;
  HSA(Address, NSEQ, INCR4, OK, BYTE);
  HSW( , 0xAA);
  HSW( , 0xBB);
/* Break the burst at non aligned place. */

/* Write to the WST1 Reg of the memory */ 
  HSA(SMBWST1R0, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x07);

  Address = SMCMEM_0 + 0x70;
  HSA(Address + 0x4, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x22071973);
/* Read from the broken burst address and test that the new WST1 value has taken
 * effect */
  Address = SMCMEM_0 + 0x60;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x6491A0BB, , NoMask);

/* General write */
  Address = SMCMEM_0 + 0x70;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x07081975);

/* Byte write with burst of 4 */
  Address = SMCMEM_0 + 0x71;
  HSA(Address, NSEQ, INCR8, OK, BYTE);
  HSW( , 0x11);
  HSA(Address + 0x1, BUSY, INCR8, OK, BYTE);
  HSW( , 0x22);
  HSA(Address + 0x1, BUSY, INCR8, OK, BYTE);
  HSW( , 0x22);
  HSA(Address + 0x1, SEQ, INCR8, OK, BYTE);
  HSW( , 0x22);
  HSW( , 0x33);
  HSW( , 0x44);
  HSA(Address + 0x4, BUSY, INCR8, OK, BYTE);
  HSW( , 0x45);
  HSA(Address + 0x4, NSEQ, INCR8, OK, BYTE);
  HSW( , 0x55);
  HSA(Address + 0x5, BUSY, INCR8, OK, BYTE);
  HSW( , 0x45);
  HSA(Address + 0x5, SEQ, INCR8, OK, BYTE);
  HSW( , 0x66);
  HSA(Address + 0x6, BUSY, INCR8, OK, BYTE);
  HSW( , 0x77);
/* Break the burst at non aligned place. */

/* Write to some other address and read */
  Address = SMCMEM_0 + 0x80;
  HSA(Address, NSEQ, INCR8, OK, WRD);
  HSW( , 0x87654321);
/*  Address = SMCMEM_0 + 0x80;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x87654321, , NoMask); */

/* Read from the broken burst address */
  Address = SMCMEM_0 + 0x70;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR( , 0x33221175, , NoMask);
  HSR( , 0x22665544, , NoMask);

#endif

#ifdef issue28
  C("Issue 28");
/* a */
/* General write */
  Address = SMCMEM_0 + 0x30;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x6592A147);
/* Write to the SMBWSTOEN Reg of the memory */ 
  HSA(SMBWSTOENR0, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x09);
/* Read from the SMBWSTOEN Reg of the memory */ 
  HSA(SMBWSTOENR0, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x09, , NoMask);

  WaitLoop(20);

/* b */
/* Write to the trickmem register SMCTrCS2OEN_0 with the value that is to be
 * written in WSTOEN */
  HSA(SMCTrCS2OEN_0, NSEQ, INCR, OK, WRD);
  HSW( , 0x0D);
/* Write to the first byte in the word */
  Address = SMCMEM_0 + 0x30;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSW( , 0xEE);
/* Write to the SMBWSTOEN Reg of the memory */ 
  HSA(SMBWSTOENR0, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x0D);
/* Read from the memory to check if the register value change has taken effect.
 * */
  Address = SMCMEM_0 + 0x30;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x6592A1EE);

/* c */
/* Write to the trickmem register SMCTrCS2OEN_0 with the value that is to be
 * written in WSTOEN */
  HSA(SMCTrCS2OEN_0, NSEQ, INCR, OK, WRD);
  HSW( , 0x07);
/* General write */
  Address = SMCMEM_0 + 0x30;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x6592A147);
/* Wait for 13 clocks to align the register access with MemWrOver */
  WaitLoop(0x12);
/* Write to the SMBWSTWEN Reg of the memory */ 
  HSA(SMBWSTOENR0, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x07);
/* Read from memory to check if the change in value of SMBWSTOENR0 has taken
 * effect. */
  Address = SMCMEM_0 + 0x30;
  HSA(Address, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x6592A147);

  WaitLoop(30);

#endif
}

/************************************ End *************************************/
