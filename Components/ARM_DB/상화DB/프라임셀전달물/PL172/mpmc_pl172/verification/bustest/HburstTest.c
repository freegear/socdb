/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : HburstTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the HBURST operation
--
--           TEST ID : MPMC_HBURST_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* HburstTest ***********************************/
/******************************************************************************/
void HburstTest(void)
{
  /*
    Summary: HburstTest
    ===================
    This test performs the following functionalities:
   
    o This test performs single data write with different types of size 
      and read the data back to check the data integrity.
 
    o It also does the multiple data write with different size depending on the 
       the burst type and reads the data back.
  */
  int i,size,csel,chip,burst,msize;
  char debugstr[100];
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;
 
  int trans0[6] = {2,2,2,2,2,5};
  int trans1[10] = {2,3,3,3,3,3,3,3,3,5};
  int trans2[5] = {2,3,3,3,5};
  int trans3[9] = {2,3,3,3,3,3,3,3,5};
  int trans4[17]= {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans5[2] = {2,5};
  int trans[500];
  C("TEST ID : MPMC_HBURST_1");
  /* Disable Address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WriteData(MPMCTrExBkOff, 0x00000002, "WRD");
  /* Write from Port0 to all memory chips with diff sizes and read it back */

  C("Initialize Bank0 registers");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,1,1,0,0x3,0x3,0x4,0x7,0x5,0x5,0x3);
  TrickMemInit(0,0,0,0,0,0,1,1,0,0x3,0x3,0x4,0x7,0x5,0x5,MPMCTrMEMBData[0],
               0x0);
  C("Initialize Bank1 registers");
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0); 

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Initialize Bank2 registers");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Initialize Bank3 registers");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

    Addr = 0x00000006;
    InitTransRnd(trans,100);
    Sequence('w',Addr,trans,"inc",0,0xBBBBBBBB,0);
    
    Addr = 0x10000070;
    InitTransRnd(trans,100);
    Sequence('w',Addr,trans,"inc",2,0x11111111,0);

    Addr = 0x200000EA;
    InitTransRnd(trans,100);
    Sequence('w',Addr,trans,"inc",1,0x22222222,0);

    Addr = 0x3000005C;
    InitTransRnd(trans,100);
    Sequence('w',Addr,trans,"inc",2,0xAAAAAAAA,0);

    C("Perform read operation");
    Addr = 0x00000007;
    InitTransRnd(trans,8); 
    Sequence('r',Addr,trans,"in8",0,0xBBBBBBBC,0);

    Addr = 0x10000070;
    InitTransRnd(trans,100);
    Sequence('r',Addr,trans,"inc",2,0x11111111,0);

    Addr = 0x200000EA;
    InitTransRnd(trans,100);
    Sequence('r',Addr,trans,"inc",1,0x22222222,0);

    Addr = 0x3000005C;
    InitTransRnd(trans,100);
    Sequence('r',Addr,trans,"inc",2,0xAAAAAAAA,0);

    /* indicates type of burst */ 
    for (burst = 0; burst < 8; burst++)   
    {
      /* selection of chip */ 
      for(csel = 0; csel < 4; csel++)  
      {
        /* selection of size */
        for(size = 0;size < 3; size++)
        {
          chip = csel;
          Data = 0x11111111;
          if(burst == 0)
          {
            if(size == 0)
              Addr = rand() & 0x37F; 
            else if(size == 1)
              Addr = rand() & 0x37E;
            else if(size == 2)
              Addr = rand() & 0x37C;
            Addr = Addr | (chip << 28);
            Sequence('w', Addr,trans0,"sin",size,0x11111111,0);
            Sequence('r', Addr,trans0,"sin",size,0x11111111,0);
         }
         else if(burst == 1)
         {
           if(size == 0)
           {
            Addr = rand() & 0x37F;
            WaitLoop(0x3);
            HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
            HPO(,0x00000000, ,0x00000003);
            WaitLoop(0x3);
            WriteData(MPMCTrMEMT_1, 0x51, "WRD");
           }
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans1,"inc",size,0x11111111,0);
           Sequence('r', Addr,trans1,"inc",size,0x11111111,0);
           WaitLoop(0x3);
           HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
           HPO(,0x00000000, ,0x00000003);
           WaitLoop(0x3);
           WriteData(MPMCTrMEMT_1, 0x41, "WRD"); 
         }
         else if(burst == 2)
         {
           if(size == 0)
            Addr = rand() & 0x37F;
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans2,"wr4",size,0x11111111,0);
           Sequence('r', Addr,trans2,"wr4",size,0x11111111,0);
         }
         else if(burst == 3)
         {
           if(size == 0)
            Addr = rand() & 0x37F;
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans2,"in4",size,0x11111111,0);
           Sequence('r', Addr,trans2,"in4",size,0x11111111,0);
         }
         else if(burst == 4)
         {
           if(size == 0)
            Addr = rand() & 0x37F;
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans3,"wr8",size,0x11111111,0);
           Sequence('r', Addr,trans3,"wr8",size,0x11111111,0);
         }
         else if(burst == 5)
         {
           if(size == 0)
            Addr = rand() & 0x37F;
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans3,"in8",size,0x11111111,0);
           Sequence('r', Addr,trans3,"in8",size,0x11111111,0);
         }
         else if(burst == 6)
         {
           if(size == 0)
            Addr = rand() & 0x37F;
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans4,"w16",size,0x11111111,0);
           Sequence('r', Addr,trans4,"w16",size,0x11111111,0);
         }
         else if(burst == 7)
         {
           if(size == 0)
            Addr = rand() & 0x37F;
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans4,"i16",size,0x11111111,0);
           Sequence('r', Addr,trans4,"i16",size,0x11111111,0);
         }  
      } /* end of size */
    } /* end of csel */
  }/*end of burst */
  C("Perform memory access to 16 bit mem width with hsize as BYTE");
  Addr = MEM1_BASE + 0x1C5;
  HSA(Addr, NSEQ, INCR, OK, BYTE);
  HSW(,0x11111111);
  HSA(Addr+1, SEQ, INCR, OK, BYTE);
  HSW(,0x11111112);
  HSA(Addr+2, SEQ, INCR, OK, BYTE);
  HSW(,0x11111113);
  HSA(Addr+3, SEQ, INCR, OK, BYTE);
  HSW(,0x11111114);

  HSA(Addr, NSEQ, INCR, OK, BYTE);
  HSR(,0x11111111, ,0x0000FF00);
  HSA(Addr+1, SEQ, INCR, OK, BYTE);
  HSR(,0x11121111, ,0x00FF0000);
  HSA(Addr+2, SEQ, INCR, OK, BYTE);
  HSR(,0x13111111, ,0xFF000000);
  HSA(Addr+3, SEQ, INCR, OK, BYTE);
  HSR(,0x11111114, ,0x000000FF);

  C("Perform memory access to 32 bit mem width with hsize as BYTE");
  Addr = MEM2_BASE + 0x1E1;
  HSA(Addr, NSEQ, INCR, OK, BYTE);
  HSW(,0x11111111);
  HSA(Addr+1, SEQ, INCR, OK, BYTE);
  HSW(,0x11111112);
  HSA(Addr+2, SEQ, INCR, OK, BYTE);
  HSW(,0x11111113);
  HSA(Addr+3, SEQ, INCR, OK, BYTE);
  HSW(,0x11111114);

  HSA(Addr, NSEQ, INCR, OK, BYTE);
  HSR(,0x11111111, ,0x0000FF00);
  HSA(Addr+1, SEQ, INCR, OK, BYTE);
  HSR(,0x11121111, ,0x00FF0000);
  HSA(Addr+2, SEQ, INCR, OK, BYTE);
  HSR(,0x13111111, ,0xFF000000);
  HSA(Addr+3, SEQ, INCR, OK, BYTE);
  HSR(,0x11111114, ,0x000000FF);

  C("Perform memory access to 32 bit mem width with hsize as BYTE");
  Addr = MEM2_BASE + 0x1E2;
  HSA(Addr, NSEQ, INCR, OK, BYTE);
  HSW(,0x11111111);
  HSA(Addr+1, SEQ, INCR, OK, BYTE);
  HSW(,0x11111112);
  HSA(Addr+2, SEQ, INCR, OK, BYTE);
  HSW(,0x11111113);
  HSA(Addr+3, SEQ, INCR, OK, BYTE);
  HSW(,0x11111114);

  HSA(Addr, NSEQ, INCR, OK, BYTE);
  HSR(,0x11111111, ,0x00FF0000);
  HSA(Addr+1, SEQ, INCR, OK, BYTE);
  HSR(,0x12111111, ,0xFF000000);
  HSA(Addr+2, SEQ, INCR, OK, BYTE);
  HSR(,0x11111113, ,0x000000FF);
  HSA(Addr+3, SEQ, INCR, OK, BYTE);
  HSR(,0x11111411, ,0x0000FF00);

  C("Perform memory access to 32 bit mem width with hsize as BYTE");
  Addr = MEM2_BASE + 0x1E3;
  HSA(Addr, NSEQ, INCR, OK, BYTE);
  HSW(,0x11111111);
  HSA(Addr+1, SEQ, INCR, OK, BYTE);
  HSW(,0x11111112);
  HSA(Addr+2, SEQ, INCR, OK, BYTE);
  HSW(,0x11111113);
  HSA(Addr+3, SEQ, INCR, OK, BYTE);
  HSW(,0x11111114);

  HSA(Addr, NSEQ, INCR, OK, BYTE);
  HSR(,0x11111111, ,0xFF000000);
  HSA(Addr+1, SEQ, INCR, OK, BYTE);
  HSR(,0x11111112, ,0x000000FF);
  HSA(Addr+2, SEQ, INCR, OK, BYTE);
  HSR(,0x11111311, ,0x0000FF00);
  HSA(Addr+3, SEQ, INCR, OK, BYTE);
  HSR(,0x11141111, ,0x00FF0000);

  C("Perform memory access to 32 bit mem width with hsize as HWRD");
  Addr = MEM2_BASE + 0x1E2;
  HSA(Addr, NSEQ, INCR4, OK, HWRD);
  HSW(,0x11111111);
  HSA(Addr+2, SEQ, INCR4, OK, HWRD);
  HSW(,0x11111112);
  HSA(Addr+4, SEQ, INCR4, OK, HWRD);
  HSW(,0x11111113);
  HSA(Addr+6, SEQ, INCR4, OK, HWRD);
  HSW(,0x11111114);

  HSA(Addr, NSEQ, INCR4, OK, HWRD);
  HSR(,0x11111111, ,0xFFFF0000);
  HSA(Addr+2, SEQ, INCR4, OK, HWRD);
  HSR(,0x11111112, ,0x0000FFFF);
  HSA(Addr+4, SEQ, INCR4, OK, HWRD);
  HSR(,0x11131111, ,0xFFFF0000);
  HSA(Addr+6, SEQ, INCR4, OK, HWRD);
  HSR(,0x11111114, ,0x0000FFFF);
  
  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  WaitLoop(0x4);
  /* Poll for buffer empty */
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000000, ,0x00000002);
  WaitLoop(0x4);

  C("Perform memory access with hsize as BYTE and MW as 16 bits");
  HSA(0x10000000, NSEQ, INCR, OK, BYTE);
  HSW(, 0x11111111);
  
  HSA(0x10000002,NSEQ, INCR, OK, BYTE);
  HSW(, 0x11111112);
  HSW(, 0x11111113);

  HSA(0x10000005,NSEQ, INCR, OK, BYTE);
  HSW(, 0x11111114);
  HSW(, 0x11111115);

  HSA(0x10000009,NSEQ, INCR, OK, BYTE);
  HSW(, 0x11111116);
  HSW(, 0x11111117);
  WaitLoop(0x5);
  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  WaitLoop(0x10);
  
  WriteData(MPMCTrMEMT_1,0x51, "WRD");  
  WaitLoop(0x10);
  C("Read data back");
  HSA(0x10000000, NSEQ, INCR, OK, BYTE);
  HSR(, 0x11111111, ,0x000000FF);

  HSA(0x10000002,NSEQ, INCR, OK, BYTE);
  HSR(, 0x11121111, ,0x00FF0000); 
  HSR(, 0x13121111, ,0xFF000000);

  HSA(0x10000005,NSEQ, INCR, OK, BYTE);
  HSR(, 0x11111411, ,0x0000FF00);
  HSR(, 0x11151111, ,0x00FF0000);

  HSA(0x10000009,NSEQ, INCR, OK, BYTE);
  HSR(, 0x11111611, ,0x0000FF00);
  HSR(, 0x11171111, ,0x00FF0000);

  WaitLoop(0x10);
  C("Perform memory access with hsize as BYTE and MW as 16 bits");
  /*WriteData(MPMCTrMEMT_1, 0x41, "WRD"); */
  WaitLoop(0x10);
  HSA(0x30000000, NSEQ, INCR, OK, BYTE);
  HSW(,0x00000022);
  
  HSA(0x30000007, NSEQ, INCR, OK, BYTE);
  HSW(,0x00000023);
  
  HSA(0x3000000B, NSEQ, INCR, OK, BYTE);
  HSW(,0x00000024);

  HSA(0x3000000D, NSEQ, INCR, OK, BYTE);
  HSW(,0x00000025);
  
  HSA(0x3000000F, NSEQ, INCR, OK, BYTE);
  HSW(,0x00000026);
  
  WaitLoop(0x5);
  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  WaitLoop(0x10);
  
  WriteData(MPMCTrMEMT_1, 0x51, "WRD"); 
  WaitLoop(0x10);
  C("Read data back");
  HSA(0x30000000, NSEQ, INCR, OK, BYTE);
  HSR(,0x00000022, , 0x000000FF);

  HSA(0x30000007, NSEQ, INCR, OK, BYTE);
  HSR(,0x23000000, , 0xFF000000);

  HSA(0x3000000B, NSEQ, INCR, OK, BYTE);
  HSR(,0x24000000, , 0xFF000000);

  HSA(0x3000000D, NSEQ, INCR, OK, BYTE);
  HSR(,0x00002500, , 0x0000FF00);

  HSA(0x3000000F, NSEQ, INCR, OK, BYTE);
  HSR(,0x26000000, , 0xFF000000);

  C("Perform write operation to 32 MW with BYTE");
  WaitLoop(0x10);
  WriteData(MPMCTrMEMT_1, 0x41, "WRD"); 
  WaitLoop(0x10);
  HSA(0x20000000, NSEQ, INCR8, OK, BYTE);
  HSW(,0x00000033);
  Data = 0x00000034;
  for(i = 0; i < 7; i++)
   HSW(,Data++);

  C("Read data back with INCR");
  HSA(0x20000000, NSEQ, INCR, OK, BYTE);
  HSR(, 0x00000033, ,0x000000FF);
  HSR(, 0x00003400, ,0x0000FF00);
  HSR(, 0x00350000, ,0x00FF0000);
  HSR(, 0x36000000, ,0xFF000000);
  C("Read rest of the data with INCR4");
  HSA(0x20000004, NSEQ, INCR4, OK, BYTE);
  HSR(, 0x00000037, ,0x000000FF);
  HSR(, 0x00003800, ,0x0000FF00);
  HSR(, 0x00390000, ,0x00FF0000);
  HSR(, 0x3A000000, ,0xFF000000);

  Sequence('w', 0x20000020,trans4,"i16",2,0x11111111,0);
  Sequence('r', 0x20000020,trans4,"i16",2,0x11111111,0);

  Sequence('w', 0x20000120,trans3,"inc",2,0x33333333,0);
  Sequence('r', 0x20000120,trans3,"inc",2,0x33333333,0);

  Sequence('w', 0x20000021,trans5,"inc",0,0x55,0);
  Sequence('w', 0x20000020,trans5,"inc",0,0x56,0);
  Sequence('w', 0x20000023,trans5,"inc",0,0x57,0);
  Sequence('w', 0x20000022,trans5,"inc",0,0x58,0);
  Sequence('w', 0x20000027,trans5,"inc",0,0x59,0);
  Sequence('w', 0x2000002A,trans5,"inc",0,0x5A,0);
  Sequence('w', 0x2000002C,trans5,"inc",0,0x6B,0);
  Sequence('w', 0x2000002D,trans5,"inc",0,0x6C,0);

  Sequence('w', 0x20000150,trans3,"inc",2,0x33333333,0);
  Sequence('r', 0x20000150,trans3,"inc",2,0x33333333,0);

  Sequence('r', 0x20000021,trans5,"inc",0,0x55,0);
  Sequence('r', 0x20000020,trans5,"inc",0,0x56,0);
  Sequence('r', 0x20000023,trans5,"inc",0,0x57,0);
  Sequence('r', 0x20000022,trans5,"inc",0,0x58,0);
  Sequence('r', 0x20000027,trans5,"inc",0,0x59,0);
  Sequence('r', 0x2000002A,trans5,"inc",0,0x5A,0);
  Sequence('r', 0x2000002C,trans5,"inc",0,0x6B,0);
  Sequence('r', 0x2000002D,trans5,"inc",0,0x6C,0);

  Sequence('r', 0x20000024,trans5,"inc",2,0x59111112,0);

  WriteData(MPMCTrTES, 0x00000008, "WRD");
} /* end of main */
/*-- --================================ End ================================--*/
