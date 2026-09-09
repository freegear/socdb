/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001-2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : DelayValueTests.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Chip Select to Output Enable assertion and
--           Chip Select to Write Enable assertion Tests on the MPMC.
--
--           TEST ID : MPMC_DelVal_1
--
-- --=======================================================================--*/

/******************************************************************************/
/****************** CS to OEN and CS to WEN assertion Tests *******************/
/******************************************************************************/

void DelayValueTests()
{
  /*
     Summary: CS to OEN and CS to WEN assertion Tests
     ================================================
     This function performs the following:

     o  Programs CS2OEN and CS2WEN registers of Memory banks with different
        values
 
     o  Programs MPMCStWtRd registers of different banks with different values
 
     o  Programs MPMCStWtWr registers of different banks with different values

     o  Does all combinations of BURST reads, Non-BURST reads and writes as
        mentioned below:
        - Read followed by BURST reads to same and different banks
        - Read followed by writes to same and different banks
        - BURST read followed by reads to same and different banks
        - BURST read followed by writes to same and different banks
        - Write followed by reads to same and different banks
        - Write followed by BURST reads to same and different banks
  */

  int i, j, k,BteMaskIndx,HIndx;
  int trans0[2] = {2,5};
  int trans10[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans12[4] = {2,3,3,5};
  int trans11[28] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans1[12] = {2,3,3,3,3,3,3,3,3,3,3,5};
  int trans2[5] = {2,3,3,3,5};
  int trans3[9] = {2,3,3,3,3,3,3,3,5};
  int trans4[17]= {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int32 TestCS2OEN[4] = {0x1, 0x05, 0x09, 0x0B};
  int32 TestCS2WEN[4] = {0x1, 0x05, 0x09, 0x0B};
  int32 TestCS2Rd[4] = {0xC,0xD,0x15,0x1F};
  int32 TestCS2Wr[4] = {0xC,0xD,0x17,0x1F};
  int32 TestExdWt[4] = {0x1F, 0x14, 0x8,0xA};
  int32 ByteMask[]   = {0x000000FF, 0x0000FF00, 0x00FF0000,0xFF000000};
  int32 HMask[]      = {0x0000FFFF,0xFFFF0000};
  int32 TestRead, TestWrite, MemAddr,MemAddrNxCS, TestData,TestReadBte;
  int32 TestRdHw;
  char message[100];
  C("TEST ID : MPMC_DelVal_1");
  /* Disable address mirror bit */
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrExBkOff, 0x00000007, "WRD");
  C("Configuring the Memory Banks and the MPMC");

  MPMCTrMEMBData[0] = 0x00000000;
  C("Set Bank 0 Memory Type as SRAM (32 bits width)");
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  C("Set Bank 1 Memory Type as SRAM (16 bits width)"); 
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  C("Set Bank 2 Memory Type as SRAM (8 bits width)");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  C("Set Bank 3 Memory Type as SRAM (32 bits width)"); 
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  TestRead = 0x00111111;
  TestWrite = 0x00222222;
  for (i=0; i<4; i++)
  {
    MPMCDisable(); 

    C("Reconfiguring the CS2OEN Register");

    WriteData(MPMCStWtOen0, TestCS2OEN[i], "WRD");
    WriteData(MPMCTrCS2Oen_0, TestCS2OEN[i], "WRD");

    k = (i+1)%4;
    WriteData(MPMCStWtOen1, TestCS2OEN[k], "WRD");
    WriteData(MPMCTrCS2Oen_1, TestCS2OEN[k], "WRD");

    k = (i+2)%4;
    WriteData(MPMCStWtOen2, TestCS2OEN[k], "WRD");
    WriteData(MPMCTrCS2Oen_2, TestCS2OEN[k], "WRD");

    k = (i+3)%4;
    WriteData(MPMCStWtOen3, TestCS2OEN[k], "WRD");
    WriteData(MPMCTrCS2Oen_3, TestCS2OEN[k], "WRD");
    MPMCEnable(); 
    for (j=0; j<4; j++)
    {
       MPMCDisable(); 

       C("Reconfiguring the CS2WEN Register");

       WriteData(MPMCStWtWen0, TestCS2WEN[j], "WRD");
       WriteData(MPMCTrCS2Wen_0, TestCS2WEN[j], "WRD");
  
       k = (j+1)%4;
       WriteData(MPMCStWtWen1, TestCS2WEN[k], "WRD");
       WriteData(MPMCTrCS2Wen_1, TestCS2WEN[k], "WRD");
  
       k = (j+2)%4;
       WriteData(MPMCStWtWen2, TestCS2WEN[k], "WRD");
       WriteData(MPMCTrCS2Wen_2, TestCS2WEN[k], "WRD");
  
       k = (j+3)%4;
       WriteData(MPMCStWtWen3, TestCS2WEN[k], "WRD");
       WriteData(MPMCTrCS2Wen_3, TestCS2WEN[k], "WRD");

       C("Reconfiguring the CS2Rd Register");

       WriteData(MPMCStWtRd0, TestCS2Rd[k], "WRD");
       WriteData(MPMCTrCS2Rd_0, TestCS2Rd[k], "WRD");

       k = (j+1)%4;
       WriteData(MPMCStWtRd1, TestCS2Rd[k], "WRD");
       WriteData(MPMCTrCS2Rd_1, TestCS2Rd[k], "WRD");

       k = (j+2)%4;
       WriteData(MPMCStWtRd2, TestCS2Rd[k], "WRD");
       WriteData(MPMCTrCS2Rd_2, TestCS2Rd[k], "WRD");
 
       k = (j+3)%4;
       WriteData(MPMCStWtRd3, TestCS2Rd[k], "WRD");
       WriteData(MPMCTrCS2Rd_3, TestCS2Rd[k], "WRD");

       C("Reconfiguring the CS2Wr Register");

       WriteData(MPMCStWtWr0, TestCS2Wr[j], "WRD");
       WriteData(MPMCTrCS2Wr_0, TestCS2Wr[j], "WRD");

       k = (j+1)%4;
       WriteData(MPMCStWtWr1, TestCS2Wr[k], "WRD");
       WriteData(MPMCTrCS2Wr_1, TestCS2Wr[k], "WRD");

       k = (j+2)%4;
       WriteData(MPMCStWtWr2, TestCS2Wr[j], "WRD");
       WriteData(MPMCTrCS2Wr_2, TestCS2Wr[j], "WRD");

       k = (j+3)%4;
       WriteData(MPMCStWtWr3, TestCS2Wr[j], "WRD");
       WriteData(MPMCTrCS2Wr_3, TestCS2Wr[j], "WRD");

       MPMCEnable(); 
       /* Does BURST Transfers */

       C("BURST Writes followed by BURST reads to the same bank");

       AHBWriteMem(0, 0x1E0, 8, TestRead);
       TestData = TestWrite;
       MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x104;
       sprintf(message,"Write data %X to memory location %X",TestData,MemAddr);
       C(message);
       Sequence('w', MemAddr,trans3,"in8",2,TestData,0);
       TestData = TestRead;
       sprintf(message,"Read data %X from memory location %X",
               TestData,MemAddr+32);
       C(message);
       Sequence('r', 0x1E0,trans12,"in4",2,TestData,0);

       C("BURST Reads followed by BURST Writes to the same bank");

       TestData = TestWrite;
       sprintf(message,"Read data %X from memory location %X",
               TestData,MemAddr);
       debug_info(message);

       Sequence('r', MemAddr,trans3,"in8",2,TestData,0);

       TestWrite = TestWrite + 0x00111111;
       TestData = TestWrite;
       MemAddr= MemAddr + 32;
       sprintf(message,"Write data %X to memory location %X",
               TestData,MemAddr+32);
       debug_info(message);
       Sequence('w', MemAddr,trans3,"in8",1,TestData,0);

       C("BURST Reads followed by BURST Writes to different banks");
       /* Write to trickmem from AHB side */
       TestData = 0x11111111;
       AHBWriteMem(0, 0x0, 16, TestData);
       MemAddr = MEM0_BASE + 0x0;
       sprintf(message,"Read data %X from memory location %X",
                TestData,MemAddr);
       debug_info(message);
       Sequence('r', MemAddr,trans4,"i16",2,TestData,0);

       MemAddrNxCS = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x2C5;
       TestWrite+= 0x00111111;
       TestData = TestWrite;
       sprintf(message,"Write data %X to memory location %X",
               TestData,MemAddrNxCS);
       debug_info(message);
       Sequence('w', MemAddrNxCS,trans1,"inc",0,TestData,0);
  
       C("BURST Writes followed by BURST Reads to different banks");
       TestRead = 0x11111111;
       AHBWriteMem(1, 0x0, 8, TestRead);
       TestData = TestWrite;
       sprintf(message,"Write data %X to memory location %X",
               TestData,MemAddr);
       debug_info(message);
       Sequence('w', MemAddr,trans2,"inc",2,TestData,0);

       MemAddrNxCS = MEM1_BASE + 0x2C5;
       TestData = TestWrite;
       sprintf(message,"Read data %X from memory location %X",
               TestData,MemAddrNxCS);
       debug_info(message);
       Sequence('r', MemAddrNxCS,trans3,"in8",0,TestData,0);
       /*  Verify the previously written data */
       TestData = TestWrite;
       sprintf(message,"Read data %X from memory location %X",
               TestData,MemAddr);
       debug_info(message);
       Sequence('r', MemAddr,trans2,"inc",2,TestData,0);
       C("BURST Writes followed by BURST Writes to the same bank");

       MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x1C0;
       TestWrite+= 0x00111111;
       TestData = TestWrite;
       sprintf(message,"Write data %X to memory location %X",
                TestData,MemAddr);
       debug_info(message);
       Sequence('w', MemAddr,trans2,"in4",1,TestData,0);
       sprintf(message,"Write data %X to memory location %X",
                TestData,MemAddr + 32);
       debug_info(message);

       Sequence('w', MemAddr+32,trans2,"in4",0,TestData,0);
       C("BURST Reads followed by BURST Reads to the same bank");
       
       TestData = TestWrite;
       sprintf(message,"Read data %X from location %X",TestData,MemAddr);
       debug_info(message);
       Sequence('r', MemAddr,trans2,"in4",1,TestData,0);
       sprintf(message,"Read data %X from location %X",TestData,MemAddr + 32);
       debug_info(message);
       Sequence('r', MemAddr+32,trans2,"in4",0,TestData,0);
       C("BURST Writes followed by BURST Writes to different banks");

       MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x4;
       TestWrite+= 0x00111111;
       TestData = TestWrite;
       sprintf(message,"Write data %X to location %X",TestData,MemAddr);
       debug_info(message);
       Sequence('w', MemAddr,trans4,"w16",2,TestData,0);
       MemAddrNxCS = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x1C0;
       sprintf(message,"Write data %X to location %X",TestData,MemAddrNxCS);
       debug_info(message);
       Sequence('w', MemAddrNxCS,trans4,"i16",1,TestData,0);
       C("BURST Reads followed by BURST Reads to different banks");
       Sequence('r', MemAddr,trans4,"w16",2,TestData,0);
       
       sprintf(message,"Read data %X from location %X",TestData,MemAddrNxCS);
       debug_info(message);
       Sequence('r', MemAddrNxCS,trans4,"i16",1,TestData,0);
       /* Does Non-BURST Transfers */

       C("Write followed by Read to the same bank");
       MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + 0x8;
       sprintf(message,"Write data %X to location %X",TestData,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSW( , TestWrite);
       sprintf(message,"Write data %X to location %X",TestData,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
       HSR( , TestWrite, , MaskALL, ,DelayValueTests_19);

       C("Read followed by Write to the same bank");
       sprintf(message,"Read data %X from location %X",TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSR( , TestWrite, , MaskALL, ,DelayValueTests_20);

       TestWrite+= 0x00111111;
       MemAddr+= 4;
       sprintf(message,"Read data %X from location %X",TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSW( , TestWrite);

       C("Read followed by Write to different banks");
       
       TestData = TestWrite;
       sprintf(message,"Read data %X from location %X",TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSR( , TestWrite, , MaskALL, ,DelayValueTests_21);

       MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
       sprintf(message,"Write data %X to location %X",~TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSW( , ~TestWrite);

       C("Write followed by Read to different banks");

       MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
       sprintf(message,"Write data %X to location %X",TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSW( , TestWrite);
       
       MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
       sprintf(message,"Read data %X from location %X",~TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSR( , ~TestWrite, , MaskALL, ,DelayValueTests_22);

       /* Verify the previously written data */
       debug_info("Verify the previously written data");
       MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSR( , TestWrite, , MaskALL, ,DelayValueTests_23);

       C("Write followed by Write to the same bank");
       MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
       TestWrite+= 0x00111111;
       sprintf(message,"Write data %X to location %X",TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSW( , TestWrite);

       sprintf(message,"Write data %X to location %X",~TestWrite,MemAddr+4);
       debug_info(message);
       HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSW( , ~TestWrite);
 
       C("Read followed by Read to the same bank");
       sprintf(message,"Read data %X from location %X",~TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSR( , TestWrite, , MaskALL, ,DelayValueTests_24);
       sprintf(message,"Read data %X from location %X",~TestWrite,MemAddr + 4);
       debug_info(message);
       HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSR( , ~TestWrite, , MaskALL, ,DelayValueTests_25);

       C("Write followed by Write to different banks");

       MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
       TestWrite+= 0x00111111;
       sprintf(message,"Write data %X to location %X",TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSW( , TestWrite);

       MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
       sprintf(message,"Write data %X to location %X",~TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSW( , ~TestWrite);

       C("Read followed by Read to different banks");

       MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
       sprintf(message,"Read data %X from location %X",TestWrite,MemAddr);
       debug_info(message);

       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSR( , TestWrite, , MaskALL, ,DelayValueTests_26);

       MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
       sprintf(message,"Read data %X from location %X",~TestWrite,MemAddr);
       debug_info(message);
       HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1,0x1, , , ,);
       HSR( , ~TestWrite, , MaskALL, ,DelayValueTests_27);
     }
  }
  
  Sequence('w', 0x00000020,trans10,"i16",2,0x11111111,0);
  Sequence('r', 0x00000020,trans10,"i16",2,0x11111111,0);
  
  Sequence('w', 0x00000120,trans11,"inc",2,0x33333333,0);
  Sequence('r', 0x00000120,trans11,"inc",2,0x33333333,0); 

  Sequence('w', 0x00000021,trans0,"inc",0,0x55,0); 
  Sequence('w', 0x00000020,trans0,"inc",0,0x56,0); 
  Sequence('w', 0x00000023,trans0,"inc",0,0x57,0); 
  Sequence('w', 0x00000022,trans0,"inc",0,0x58,0); 
  Sequence('w', 0x00000027,trans0,"inc",0,0x59,0); 
  Sequence('w', 0x0000002A,trans0,"inc",0,0x5A,0); 
  Sequence('w', 0x0000002C,trans0,"inc",0,0x6B,0);
  Sequence('w', 0x0000002D,trans0,"inc",0,0x6C,0);
  
  Sequence('w', 0x00000150,trans11,"inc",2,0x33333333,0);
  Sequence('r', 0x00000150,trans11,"inc",2,0x33333333,0);

  Sequence('r', 0x00000021,trans0,"inc",0,0x55,0);
  Sequence('r', 0x00000020,trans0,"inc",0,0x56,0);
  Sequence('r', 0x00000023,trans0,"inc",0,0x57,0);
  Sequence('r', 0x00000022,trans0,"inc",0,0x58,0);
  Sequence('r', 0x00000027,trans0,"inc",0,0x59,0);
  Sequence('r', 0x0000002A,trans0,"inc",0,0x5A,0);
  Sequence('r', 0x0000002C,trans0,"inc",0,0x6B,0);
  Sequence('r', 0x0000002D,trans0,"inc",0,0x6C,0);

  Sequence('r', 0x00000024,trans0,"inc",2,0x59111112,0); 
 
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x00000008);
}
/************************************ End *************************************/
