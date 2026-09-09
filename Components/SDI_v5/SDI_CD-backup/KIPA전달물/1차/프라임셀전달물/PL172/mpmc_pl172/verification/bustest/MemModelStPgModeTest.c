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
-- File Name              : MemModelStPgModeTest.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests async page mode access with the page mode
--           flash device
--
--           TEST ID : MPMC_MemModelStPgModeTest_1
--
-- --=======================================================================--*/
/******************************************************************************/
/************************** MemModelStPgModeTest ******************************/
/******************************************************************************/
MemModelStPgModeTest()
{
  /*
    Summary: MemModelStPgModeTest
    =============================
    This test performs the following functionalities:
      
        o This test does the async page mode read from the page mode read 
          supported flash models.

  */
  int i;
  int trans[128];
  int trans0[7] = {2,3,3,3,3,3,5};
  int trans1[2] = {2,5};
  int trans4[5] = {2,3,3,3,5};
  int trans8[9] = {2,3,3,3,3,3,3,3,5};
  int trans16[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans10[400];
  int Addr, Data;
  /* int WrdProgramSetUp = 0x40; */
  int WrdProgramSetUp = 0x40;
  int RdStatusReg = 0x70;
  int ClrStatusReg = 0x50;
  C("TEST ID : MPMC_MemModelStPgModeTest_1");
  /* Disable Address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  /* Set Bank 0 Memory Type as Pg mode flash (16 bits width) */
  StInitProc(0,1,1,0,1,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);
  /* Set Bank 1 Memory Type as Pg mode flash (32 bits width) */
  StInitProc(1,2,1,0,1,0,0,0,0,0x1,0x1,0x7,0x5,0x8,0x5,0x8);

  /* Set Bank 2 Memory Type as Pg mode flash (16 bits width) */
  StInitProc(2,1,1,0,1,0,0,0,0,0x1,0x1,0x8,0x5,0x8,0x5,0x8);

  /* Set Bank 3 Memory Type as Pg mode flash (32 bits width) */
  StInitProc(3,2,1,0,1,0,0,0,0,0x1,0x1,0x7,0x5,0x8,0x5,0x8);

  C("Write data to the memory after writing the command data");
  
  /* During the first cycle, write 0x40 to the address where data supposed to
     be written. In the second cycle write the actual data to be written. Read
     the status register bit (SR 7) to know whether the program is complete or
     not. If it is '0', it means that the memory is "busy" in programming the
     memory. If it is '1' then the memory programming is complete.
     SR7 bits needs to be made 0 before programming another location.       */

   Addr = 0x00400000;
   Data = 0x44444444;
   
   Sequence('w',Addr,trans1,"sin",2,0x00D00060,0);
   for(i = 0; i < 100; i++)
   {
     C("Write WordProgram SetUp value");
     Sequence('w',Addr,trans1,"sin",1,WrdProgramSetUp,0);
     C("Write actual value to be programmed");
     Sequence('w',Addr,trans1,"sin",1,Data,0); 
     C("Write RdStatusReg to put the memory in status register read mode");
     Sequence('w',Addr,trans1,"sin",1,RdStatusReg,0); 
     WaitLoop(0x200);
     Sequence('r',Addr,trans1,"sin",1,0x80,0);
     C("Wait till memory is ready to take command");
     WaitLoop(0x25);
     C("Clear status register by writing 0x50h");
     Sequence('w',Addr,trans1,"sin",1,ClrStatusReg,0);
     Addr = Addr + 2;  
     Data++;
   }
    
   Addr = 0x00400000;
   Data = 0x44444444;
   InitTransRnd(trans10,100); 
   Sequence('w',Addr,trans1,"sin",1,0xFF,0);
   Sequence('r',Addr,trans10,"inc",1,Data,0); 
   
   C("Enable the buffers to perform read operation");
   MPMCDisable();
   StInitProc(0,1,1,0,1,0,1,1,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1); 
   MPMCEnable();
   C("Perform buffered read");
   Sequence('r',Addr,trans10,"inc",1,Data,0);
   C("Disable the buffers to perform write operation");
   MPMCDisable();
   StInitProc(0,1,1,0,1,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);
   MPMCEnable();

   Addr = 0x00700000;
   Data = 0x55555555;

   Sequence('w',Addr,trans1,"sin",2,0x00D00060,0);
   for(i = 0; i < 100; i++)
   {
     C("Write WordProgram SetUp value");
     Sequence('w',Addr,trans1,"sin",1,WrdProgramSetUp,0);
     C("Write actual value to be programmed");
     Sequence('w',Addr,trans1,"sin",1,Data,0);
     C("Write RdStatusReg to put the memory in status register read mode");
     Sequence('w',Addr,trans1,"sin",1,RdStatusReg,0);
     WaitLoop(0x200);
     Sequence('r',Addr,trans1,"sin",1,0x80,0);
     C("Wait till memory is ready to take command");
     WaitLoop(0x25);
     C("Clear status register by writing 0x50h");
     Sequence('w',Addr,trans1,"sin",1,ClrStatusReg,0);
     Addr = Addr + 2;
     Data++;
   }

   C("Read data back with buffers disabled");
   Addr = 0x00700000;
   Data = 0x55555555;
   InitTransRnd(trans10,100);
   Sequence('w',Addr,trans1,"sin",1,0xFF,0);
   Sequence('r',Addr,trans10,"inc",1,Data,0);

   C("Enable the buffers to perform read operation");
   MPMCDisable();
   StInitProc(0,1,1,0,1,0,1,1,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);
   MPMCEnable();
   C("Perform buffered read");
   Sequence('r',Addr,trans10,"inc",1,Data,0);
}
