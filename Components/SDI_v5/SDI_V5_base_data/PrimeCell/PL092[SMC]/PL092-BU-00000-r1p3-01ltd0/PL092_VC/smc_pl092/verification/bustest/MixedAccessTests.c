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
--  File Name              : MixedAccessTests.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Chip Select to Output Enable assertion and
--           Chip Select to Write Enable assertion Tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/****************** CS to OEN and CS to WEN assertion Tests *******************/
/******************************************************************************/

void MixedAccessTests()
{
  /*
     Summary: CS to OEN and CS to WEN assertion Tests
     ================================================
     This function performs the following:

     o  Programs CS2OEN and CS2WEN registers of Memory banks with different
        values
     o  Does all combinations of BURST reads, Non-BURST reads and writes as
        mentioned below:
        - Read followed by BURST reads to same and different banks
        - Read followed by writes to same and different banks
        - BURST read followed by reads to same and different banks
        - BURST read followed by writes to same and different banks
        - Write followed by reads to same and different banks
        - Write followed by BURST reads to same and different banks
  */

  int i, j, k;
  int32 TestCS2OEN[6] = {0x00, 0x01, 0x0E, 0x00, 0x0F, 0x0};
  int32 TestWST1[6]  = {0x00,0x02, 0x0F, 0x0F, 0x1F, 0x0};
  int32 TestWST2[6] = {0x00, 0x01, 0x0F, 0x09, 0x10, 0x1};
  int32 StartData[6] = {0xA5A5A5A5, 0x00005555, 0x000000CC, 0x5A5A5A5A,
                        0x0000AAAA, 0x00000099};
  int32 TestRead, TestWrite, MemAddr, TestData, ExpDataROM, ExpDataBROM, ExpDataSRAM;
  int32 BurstAddr[8] = {0x00000053, 0x00000039, 0x000001CC, 0x00000056,
                        0x0000003E, 0x0000001F, 0x0000007F, 0x00000108};
  int32 HSizeMask[3] = {0xFFFFFFFF, 0xFFFFFFFE, 0xFFFFFFFC};
  int32 SramData[8]  = {0x11111111, 0x22222222, 0x33333333, 0x44444444,
                        0x55555555, 0x77777777, 0x99999999, 0xAAAAAAAA};
  int32 ROMAddr, BROMAddr, SRAMAddr;
  int burst, hsize, romburst, bromburst, sramburst, romhsize, bromhsize,
      sramhsize;

  int byteno[3] = {1, 2, 4};

  ApplyReset();

  C("Configuring the Memory Banks and the SMC");
  /** Set Bank 0 Memory Type as ROM (32 bits width) **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x00, 0x0F, 0x0E, 0x02, 0x00, 0x00000090, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x00, 0x0F, 0x0E, 0x006, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as ROM (16 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x01, 0x0D, 0x0C, 0x02, 0x00, 0x00000050, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x01, 0x0D, 0x0C, 0x005, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as ROM (8 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x02, 0x0B, 0x0A, 0x02, 0x00, 0x00000010, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x02, 0x0B, 0x0A, 0x004, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as BROM (32 bits width) **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x03, 0x09, 0x08, 0x02, 0x00, 0x000000B0, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x03, 0x09, 0x08, 0x00A, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as BROM (16 bits width) **/
  SMCTrMEMBData[4] = 0x00000000;
  ConfigureUUT(4, 0x04, 0x07, 0x06, 0x02, 0x00, 0x00000070, 0x000000,
               0x000000);
  ConfigureMemory(4, 0x04, 0x07, 0x06, 0x009, SMCTrMEMBData[4], 0x02,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as BROM (8 bits width) **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x05, 0x05, 0x04, 0x02, 0x00, 0x00000030, 0x000000,
               0x000000);
  ConfigureMemory(5, 0x05, 0x05, 0x04, 0x008, SMCTrMEMBData[5], 0x02,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) , RBLE enabled **/
  SMCTrMEMBData[6] = 0x00000000;
  ConfigureUUT(6, 0x06, 0x09, 0x08, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x06, 0x09, 0x08, 0x042, SMCTrMEMBData[6], 0x02,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x07, 0x0A, 0x09, 0x02, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x07, 0x0A, 0x09, 0x000, SMCTrMEMBData[7], 0x02,
                  0x00, 0x000000);
 
 for (i=0; i<6; i++)
 {
  AHBWriteTrickMem(i, 0x00000000, 0x100, StartData[i]);
 }
     
  TestRead = 0x00111111;
  TestWrite = 0x00222222;
  for (i=0; i<5; i++)
  {
    C("Reconfiguring the CS2OEN Register");
    HSA(SMBWSTOENR0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[i]);
    HSA(SMCTrCS2OEN_0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[i]);
    HSA(SMBWST1R0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[i]);
    HSA(SMBWST2R0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[i]);
    HSA(SMCTrWST1_0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[i]);
    HSA(SMCTrWST2_0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[i]);

    k = (i+1)%6;
    HSA(SMBWSTOENR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMCTrCS2OEN_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMBWST1R1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMBWST2R1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);
    HSA(SMCTrWST1_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMCTrWST2_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);
  

    k = (i+2)%6;
    HSA(SMBWSTOENR2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMCTrCS2OEN_2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMBWST1R2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMBWST2R2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);
    HSA(SMCTrWST1_2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMCTrWST2_2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);


    k = (i+3)%6;
    HSA(SMBWSTOENR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMCTrCS2OEN_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMBWST1R3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMBWST2R3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);
    HSA(SMCTrWST1_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMCTrWST2_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);
  
    k = (i+4)%6;
    HSA(SMBWSTOENR4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMCTrCS2OEN_4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMBWST1R4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMBWST2R4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);
    HSA(SMCTrWST1_4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMCTrWST2_4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);

    k = (i+5)%6;
    HSA(SMBWSTOENR5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMCTrCS2OEN_5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMBWST1R5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMBWST2R5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);
    HSA(SMCTrWST1_5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[k]);
    HSA(SMCTrWST2_5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[k]);

    for (burst = 7; burst >=0; burst--)
    {
      for (hsize = 0; hsize < 3; hsize++)
      {
        romhsize = hsize;
        bromhsize = (hsize+1)%3;
        sramhsize = (hsize + 1)%3;
        romburst = burst;
        bromburst = (burst+3)%8;
        sramburst = (burst+5)%8;
        C("Read followed by burst read followed by SRAM write");
        ExpDataROM = StartData[0] +
                     (BurstAddr[romburst]/4) ;
        ROMAddr     = BurstAddr[romburst] & HSizeMask[romhsize];
        BROMAddr    = (BurstAddr[burst]) & (HSizeMask[bromhsize]); 
        ExpDataBROM = StartData[4] +
                      (BROMAddr/2);
        SRAMAddr    = BurstAddr[burst] & HSizeMask[sramhsize];
        C("First ROM Read started");
        ROMReadTrick(0, romburst, ROMAddr, romhsize, 2, 0, ExpDataROM);   
        C("First ROM Read Done");
        C("First BROM Read started");
        ROMReadTrick(4, bromburst, BROMAddr, bromhsize, 1, 0, ExpDataBROM);
        BurstWrite(6, sramburst, SRAMAddr, sramhsize, 2, 0, SramData[burst]);

        C("Read followed by burst read followed by SRAM read");
        romburst = (romburst + 1)%8;
        bromburst = (bromburst + 1)%8;
        romhsize = (romhsize++ )%8;
        bromhsize = (bromhsize++)%8;
        ROMAddr     = BurstAddr[romburst] & HSizeMask[romhsize];
        BROMAddr    = (BurstAddr[bromburst]) & (HSizeMask[bromhsize]);
        ExpDataROM = StartData[1] + (ROMAddr/2);
        ExpDataBROM = StartData[3] + (BROMAddr/4);
        C("Second ROM Read started");
        ROMReadTrick(1, romburst, ROMAddr, romhsize, 1, 0, ExpDataROM);
        ROMReadTrick(3, bromburst, BROMAddr, bromhsize, 2, 0, ExpDataBROM);
        C("Second ROM Read Done");
        C("Second BROM Read started");
        C("SRAM Read");
        BurstRead(6, sramburst, SRAMAddr, sramhsize, 2, 0, SramData[burst]);
      }
    }
  }
}

/************************************ End *************************************/
