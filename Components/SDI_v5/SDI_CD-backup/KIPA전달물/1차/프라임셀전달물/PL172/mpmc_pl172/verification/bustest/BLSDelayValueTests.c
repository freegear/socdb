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
--  File Name              : BLSDelayValueTests.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Chip Select to Output Enable assertion and
--           Chip Select to Write Enable assertion Tests on the MPMC.
--
--           TEST ID : MPMC_ByteLane_1
--
-- --=========================================================================*/

/******************************************************************************/
/****************** CS to OEN and CS to WEN assertion Tests *******************/
/******************************************************************************/

void BLSDelayValueTests()
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

  int i, j, k;
  int32 TestCS2OEN[4] = {0x3, 0x05, 0x06, 0x08};
  int32 TestCS2WEN[4] = {0x4, 0x02, 0x03, 0x07};
  int32 TestCS2Rd[4] = {0x9,0xA,0xD,0xE};
  int32 TestCS2Wr[4] = {0x8,0x9,0xA,0xB};
  int32 TestRead, TestWrite, MemAddr, TestData,MemNxAddr;
  int trans1[7] = {2,3,3,3,3,3,5};
  int trans2[5]  = {2,3,3,3,5};
  int trans3[9]  = {2,3,3,3,3,3,3,3,5};
  int trans4[17]  = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  
  int WtTurn,CS2OEN,CS2WEN,CS2Rd,CS2Wr;
  char debugstr[100];
  C("TEST ID : MPMC_ByteLane_1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WriteData(MPMCControl, 0x00000001, "WRD");
  C("Configuring the Memory Banks and the MPMC");

  WriteData(MPMCTrExBkOff, 0x0000000B, "WRD");
  MPMCTrMEMBData[0] = 0x00000000;
  /* Set Bank 0 Memory Type as SRAM (32 bits width)with 8 bit memory */
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x9,0x4);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x9,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width)with 8 bit memory */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0xB,0x4);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0xB,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (32 bits width)with 16 bit memory */
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0xD,0x4);
  TrickMemInit(2,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0xD,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) with 16 bit meory width 
     and buffers disabled */
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0xF,0x4);
  TrickMemInit(3,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0xF,MPMCTrMEMBData[0],
               0x0);

  TestRead = 0x00111111;
  TestWrite = 0x00222222;
  for (i=0; i<4; i++)
  {
    MPMCDisable(); 

    C("Reconfiguring the CS2OEN Register");
    debug_info("Configuration of MPMCStWtOen0");
    WriteData(MPMCStWtOen0, TestCS2OEN[i], "WRD");
    WriteData(MPMCTrCS2Oen_0, TestCS2OEN[i], "WRD");

    k = rand() % 4;
    debug_info("Configuration of MPMCStWtOen1");
    WriteData(MPMCStWtOen1, TestCS2OEN[k], "WRD");
    WriteData(MPMCTrCS2Oen_1, TestCS2OEN[k], "WRD");
    
    k = rand() % 4;
    debug_info("Configuration of MPMCStWtOen2");   
    WriteData(MPMCStWtOen2, TestCS2OEN[k], "WRD");
    WriteData(MPMCTrCS2Oen_2, TestCS2OEN[k], "WRD");

    k = rand() % 4;
    debug_info("Configuration of MPMCStWtOen3");
    WriteData(MPMCStWtOen3, TestCS2OEN[k], "WRD");
    WriteData(MPMCTrCS2Oen_3, TestCS2OEN[k], "WRD");

    C("Reconfiguring the CS2WEN Register");

    k = rand() % 4;  
    debug_info("Configuration of MPMCStWtWen0");
    WriteData(MPMCStWtWen0, TestCS2WEN[k], "WRD");
    WriteData(MPMCTrCS2Wen_0, TestCS2WEN[k], "WRD");

    k = rand() % 4; 
    debug_info("Configuration of MPMCStWtWen1"); 
    WriteData(MPMCStWtWen1, TestCS2WEN[k], "WRD");
    WriteData(MPMCTrCS2Wen_1, TestCS2WEN[k], "WRD");

    k = rand() % 4; 
    debug_info("Configuration of MPMCStWtWen2");
    WriteData(MPMCStWtWen2, TestCS2WEN[k], "WRD");
    WriteData(MPMCTrCS2Wen_2, TestCS2WEN[k], "WRD");

    k = rand() % 4; 
    debug_info("Configuration of MPMCStWtWen3");
    WriteData(MPMCStWtWen3, TestCS2WEN[k], "WRD");
    WriteData(MPMCTrCS2Wen_3, TestCS2WEN[k], "WRD");
    MPMCEnable(); 
    for (j=0; j<4; j++)
    {
      MPMCDisable(); 

      C("Reconfiguring the CS2Rd Register");

      k =rand() % 4;
      debug_info("Configuration of MPMCStWtRd0");
      WriteData(MPMCStWtRd0, TestCS2Rd[k], "WRD");
      WriteData(MPMCTrCS2Rd_0, TestCS2Rd[k], "WRD");

      k =rand() % 4;
      debug_info("Configuration of MPMCStWtRd1");
      WriteData(MPMCStWtRd1, TestCS2Rd[k], "WRD");
      WriteData(MPMCTrCS2Rd_1, TestCS2Rd[k], "WRD");

      k =rand() % 4;
      debug_info("Configuration of MPMCStWtRd2");
      WriteData(MPMCStWtRd2, TestCS2Rd[k], "WRD");
      WriteData(MPMCTrCS2Rd_2, TestCS2Rd[k], "WRD");

      k =rand() % 4;
      debug_info("Configuration of MPMCStWtRd3");
      WriteData(MPMCStWtRd3, TestCS2Rd[k], "WRD");
      WriteData(MPMCTrCS2Rd_3, TestCS2Rd[k], "WRD");

      C("Reconfiguring the CS2Wr Register");

      k =rand() % 4;
      debug_info("Configuration of MPMCStWtWr0");
      WriteData(MPMCStWtWr0, TestCS2Wr[k], "WRD");
      WriteData(MPMCTrCS2Wr_0, TestCS2Wr[k], "WRD");

      debug_info("Configuration of MPMCStWtWr1");
      k =  rand()%4;
      WriteData(MPMCStWtWr1, TestCS2Wr[k], "WRD");
      WriteData(MPMCTrCS2Wr_1, TestCS2Wr[k], "WRD");

      debug_info("Configuration of MPMCStWtWr2");
      k =  rand()%4;
      WriteData(MPMCStWtWr2, TestCS2Wr[k], "WRD");
      WriteData(MPMCTrCS2Wr_2, TestCS2Wr[k], "WRD");

      debug_info("Configuration of MPMCStWtWr3");
      k = rand()%4;
      WriteData(MPMCStWtWr3, TestCS2Wr[k], "WRD");
      WriteData(MPMCTrCS2Wr_3, TestCS2Wr[k], "WRD");

      C("Reconfiguring the WaitTurn Register");

      WtTurn = rand() % 15;
      debug_info("Configuration of MPMCStWtTurn0");
      WriteData(MPMCStWtTurn0, WtTurn, "WRD");
      WriteData(MPMCTrIDCY_0, WtTurn, "WRD");

      debug_info("Configuration of MPMCStWtTurn1");
      WtTurn = rand() % 15;
      WriteData(MPMCStWtTurn1, WtTurn, "WRD");
      WriteData(MPMCTrIDCY_1, WtTurn, "WRD");

      debug_info("Configuration of MPMCStWtTurn2");
      WtTurn = rand() % 15;
      WriteData(MPMCStWtTurn2, WtTurn, "WRD");
      WriteData(MPMCTrIDCY_2, WtTurn, "WRD");

      debug_info("Configuration of MPMCStWtTurn3");
      WtTurn = rand() % 15;
      WriteData(MPMCStWtTurn3, WtTurn, "WRD");
      WriteData(MPMCTrIDCY_3, WtTurn, "WRD");

      MPMCEnable(); 
      /* Does BURST Transfers */

      C("BURST Writes followed by BURST reads to the same bank");

      AHBWriteMem(0, 0x1E0, 8, TestRead);
      TestData = TestWrite;
      MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x1C0;
      sprintf(debugstr,"Burst write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr,"Data written is %X",TestData);
      debug_info(debugstr);
      
      Sequence('w', 0x0000012D,trans3,"in8",0,0x44444444,0);

      sprintf(debugstr,"Burst read starts from %X",MemAddr+32);
      debug_info(debugstr);
      sprintf(debugstr,"Data read is %X",TestData);
      debug_info(debugstr);

      TestData = TestRead;
      Sequence('r', 0x1E0,trans3,"in8",2,TestData,0);

      C("BURST Reads followed by BURST Writes to the same bank");

      sprintf(debugstr,"Burst read starts from %X",MemAddr);
      debug_info(debugstr);

      TestData = TestRead;
      sprintf(debugstr,"Read data is %X",TestData);
      debug_info(debugstr);
      HSA(MemAddr+32, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , MaskALL, ,DelayValueTests_3);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Read data is %X",TestData);
        debug_info(debugstr);
        HSR( , TestData++, , MaskALL, ,DelayValueTests_4);
      }
      TestWrite+= 0x00111111;
      TestData = TestWrite;
      MemAddr+= 32;
      sprintf(debugstr,"Burst write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr,"Data written is %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Data written is %X",TestData);
        debug_info(debugstr);
        HSW( , TestData++);
      }
      C("BURST Reads followed by BURST Writes to different banks");

      TestData = TestWrite;
      sprintf(debugstr,"Burst read starts from %X",MemAddr);
      debug_info(debugstr);

      sprintf(debugstr,"Data read is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , MaskALL, ,DelayValueTests_5);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Data read is  %X",TestData);
        debug_info(debugstr);
        HSR( , TestData++, , MaskALL, ,DelayValueTests_6);
      }
      TestWrite+= 0x00111111;
      TestData = TestWrite;
      MemNxAddr = MEM1_BASE + 0x1C0;
      sprintf(debugstr,"Burst write starts from %X",MemNxAddr);
      debug_info(debugstr);

      sprintf(debugstr,"Data written is  %X",TestData);
      debug_info(debugstr);

      HSA(MemNxAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Data written is  %X",TestData);
        debug_info(debugstr);
        HSW( , TestData++);
      }
  
      C("BURST Writes followed by BURST Reads to different banks");

      TestData = TestWrite;
      sprintf(debugstr,"Burst write starts from %X",MemAddr);
      debug_info(debugstr);

      sprintf(debugstr,"Data written is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Data written is  %X",TestData);
        debug_info(debugstr);

        HSW( , TestData++);
      }

      TestData = TestWrite;
      sprintf(debugstr,"Burst read starts from %X",MemNxAddr);
      debug_info(debugstr);
      sprintf(debugstr,"Data read is  %X",TestData);
      debug_info(debugstr);

      HSA(MemNxAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , MaskALL, ,DelayValueTests_7);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Data read is  %X",TestData);
        debug_info(debugstr);
        HSR( , TestData++, , MaskALL, ,DelayValueTests_8);
      }
      /** Verify the previously written data **/
      C("Verify the previously written data");
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , MaskALL, ,DelayValueTests_9);
      for (k=0; k<7; k++)
        HSR( , TestData++, , MaskALL, ,DelayValueTests_10);

      C("BURST Writes followed by BURST Writes to the same bank");

      MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
      sprintf(debugstr,"Burst write starts from %X",MemAddr);
      debug_info(debugstr);
      TestWrite+= 0x00111111;
      TestData = TestWrite;
      sprintf(debugstr,"Written data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Written data is  %X",TestData);
        debug_info(debugstr);

        HSW( , TestData++);
      }
      sprintf(debugstr,"Another burst write starts from %X",MemAddr+32);
      debug_info(debugstr);
      sprintf(debugstr,"Written data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr+32, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Written data is  %X",TestData);
        debug_info(debugstr);

        HSW( , TestData++);
      }
      C("BURST Reads followed by BURST Reads to the same bank");

      TestData = TestWrite;
      sprintf(debugstr,"Burst read starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr,"read data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , MaskALL, ,DelayValueTests_11);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"read data is  %X",TestData);
        debug_info(debugstr);
      
        HSR( , TestData++, , MaskALL, ,DelayValueTests_12);
      }
      sprintf(debugstr,"Another burst read starts from %X",MemAddr+32);
      debug_info(debugstr);
      sprintf(debugstr,"read data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr+32, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , MaskALL, ,DelayValueTests_13);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"read data is  %X",TestData);
        debug_info(debugstr);

        HSR( , TestData++, , MaskALL, ,DelayValueTests_14);
      }
      C("BURST Writes followed by BURST Writes to different banks");
      MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7E0;
      TestWrite+= 0x00111111;
      TestData = TestWrite;
      sprintf(debugstr,"Burst write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr,"Written data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Written data is  %X",TestData);
        debug_info(debugstr);

        HSW( , TestData++);
      }
      MemNxAddr = MEM1_BASE + 0x0;
      HSA(MemNxAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      sprintf(debugstr,"Another Burst write starts from %X",MemAddr + 32);
      debug_info(debugstr);
      sprintf(debugstr,"Written data is  %X",TestData);
      debug_info(debugstr);
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"Written data is  %X",TestData);
        debug_info(debugstr);

        HSW( , TestData++);
      }
      C("BURST Reads followed by BURST Reads to different banks");
      TestData = TestWrite;
      sprintf(debugstr,"Burst read starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr,"Read data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , MaskALL, ,DelayValueTests_15);
     
      for (k=0; k<7; k++)
      {       
        sprintf(debugstr,"Read data is  %X",TestData);
        debug_info(debugstr);
        HSR( , TestData++, , MaskALL, ,DelayValueTests_16);
      }
      sprintf(debugstr,"Another Burst read starts from %X",MemAddr + 32);
      debug_info(debugstr);
      sprintf(debugstr,"read data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemNxAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , MaskALL, ,DelayValueTests_17);
            
      for (k=0; k<7; k++)
      {
        sprintf(debugstr,"read data is  %X",TestData);
        debug_info(debugstr);
        HSR( , TestData++, , MaskALL, ,DelayValueTests_18);
      } 
      /* Does Non-BURST Transfers */
      C("Write followed by Read to the same bank");

      AHBWriteMem(2, 16, 4, TestRead);
      MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);
      sprintf(debugstr," write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," write data is  %X",TestData);
      debug_info(debugstr);
      sprintf(debugstr," read  starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," read data is  %X",TestData);
      debug_info(debugstr);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , MaskALL, ,DelayValueTests_19);

      C("Read followed by Write to the same bank");
      sprintf(debugstr," read  starts from %X",MemAddr+4);
      debug_info(debugstr);
      sprintf(debugstr," read data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , MaskALL, ,DelayValueTests_20);

      TestWrite+= 0x00111111;
      MemAddr+= 4;
      sprintf(debugstr," write  starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," write data is  %X",TestData);
      debug_info(debugstr);
      
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);

      C("Read followed by Write to different banks");

      sprintf(debugstr," read  starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," read data is  %X",TestData);
      debug_info(debugstr);

      TestData = ~TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , MaskALL, ,DelayValueTests_21);

      MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData);

      C("Write followed by Read to different banks");
      TestData = TestWrite;
      MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
      sprintf(debugstr," write  starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," write data is  %X",TestData);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData);
      TestData = ~TestWrite;
      MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
      sprintf(debugstr," read starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," read data is  %X",TestData);
      debug_info(debugstr);      
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData, , MaskALL, ,DelayValueTests_22);

      /** Verify the previously written data **/
      MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , MaskALL, ,DelayValueTests_24);
   
      C("Write followed by Write to the same bank");

      MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
      TestWrite+= 0x00111111;
      sprintf(debugstr," write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," write data is  %X",TestWrite);
      debug_info(debugstr);
   
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);
      debug_info("Write complement of previous value");
      HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , ~TestWrite);

      C("Read followed by Read to the same bank");

      sprintf(debugstr," read starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," read data is  %X",TestWrite);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , MaskALL, ,DelayValueTests_25);
      sprintf(debugstr," Another read starts from %X",MemAddr+4);
      debug_info(debugstr);
      sprintf(debugstr," read data is  %X",~TestWrite);
      debug_info(debugstr);

      HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , ~TestWrite, , MaskALL, ,DelayValueTests_26);

      C("Write followed by Write to different banks");

      MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
      TestWrite+= 0x00111111;
      sprintf(debugstr," write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," write data is  %X",TestWrite);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);

      MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
      sprintf(debugstr," write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," write data is  %X",~TestWrite);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , ~TestWrite);

      C("Read followed by Read to different banks");
      
      MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
      sprintf(debugstr," write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," write data is  %X",TestWrite);
      debug_info(debugstr);
     
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , MaskALL, ,DelayValueTests_27);

      MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
      sprintf(debugstr," write starts from %X",MemAddr);
      debug_info(debugstr);
      sprintf(debugstr," write data is  %X",~TestWrite);
      debug_info(debugstr);

      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , ~TestWrite, , MaskALL, ,DelayValueTests_28);
    }
  } 
  TestRead = 0x00111111;
  TestWrite = 0x00222222;
  C("Reprogram the MPMCSTCS1PB pin as 1  and MPMCSTCS1MW as 16 bit");
  WaitLoop(0x50);
  WriteData(MPMCTrStaticCS, 0x50,"WRD");
  C("Apply nPOR");
  CSPOReset();
  WaitLoop(0x10);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x0,0x0,0x1F,0x1F,0x1F,0xF,MPMCTrMEMBData[0],
               0xF);
  Sequence('w', 0x10000024,trans1,"inc",2,0x44444444,0);
  Sequence('r', 0x10000024,trans1,"inc",2,0x44444444,0);

  C("Reprogram the MPMCSTCS1PB pin as 0  and MPMCSTCS1MW as 8 bit");
  WaitLoop(0xA0);
  WriteData(MPMCTrStaticCS, 0x00,"WRD");
  WriteData(MPMCTrMEMT_1, 0x0, "WRD");
  C("Apply nPOR");
  CSPOReset();
  WaitLoop(0x10);
  TrickMemInit(1,0,0,0,0,0,0,0,0,0x0,0x0,0x1F,0x1F,0x1F,0xF,MPMCTrMEMBData[0],
               0xF);
  Sequence('w', 0x10000184,trans1,"inc",2,0x44444444,0);
  Sequence('r', 0x10000184,trans1,"inc",2,0x44444444,0);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x00000008);
}
/************************************ End *************************************/
