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
--  File Name              : Arb2DyWrRd.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It performs the Multiple port access. 
--           
--           TEST ID : MPMC_Arb2DyWrRd_1
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* Arb2DyWrRd *********************************/
/******************************************************************************/
void Arb2DyWrRd()
{ 
  /*
     Summary: Arb2DyWrRd
     ===================
     This function tests the following functionality
 
     o  This test cases access the dynamic memory from different ports but at
        the same time and tests the functionality of buffer, arbiter
        and mem controller.

     o This test performs single data write with different types of size
       and read the data back to check the data integrity from Port3 and Port1.

     o It also does the multiple data write with different size depending on the
       the burst type and reads the data back from Port3 and Port1.
  */
  int i,k, csel;
  int Data,size,chip,msize;
  int Bound,burst,LoBits;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  int trans0[6] = {2,2,2,2,2,5};
  int trans1[10] = {2,3,3,3,3,3,3,3,3,5};
  int trans2[5] = {2,3,3,3,5};
  int trans3[9] = {2,3,3,3,3,3,3,3,5};
  int trans4[17]= {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  unsigned long Addr;
  char debugstr[100];

  #if (INFILE== 3)
  C("TEST ID : MPMC_Arb2DyWrRd_1");
  /* Disable address mirror */
  WriteData(MPMCControl,0x00000001,"WRD");

  C("initialize sdrams and registers");
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
  SyncInitializeProc(
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     0,1,0,0,1,1,1,0,2,0,0,
                     0,0,0,0,0,1,1,0,3,0,0,
                     0,0,1,0,0,1,1,0,3,1,1,
                     0,0,2,0,1,1,1,0,4,1,1,
                     11,11,12,14,
                     0,
                     0
                    ); 
  WriteData(MPMCTrExBkOff, 0x00000005, "WRD");

  /*  Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank0");
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of bank1");
  StInitProc(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Initialize registers of bank2");
  StInitProc(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  C("Initialize registers of bank3");
  StInitProc(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  WriteData(MPMCTrTES, 0x00000008, "WRD");
  WriteData(MPMCTrCR, 0x00000020, "WRD");
  Data = 0xAAAAAAAA; 
  for(i = 0; i < 200; i++)
  {
    chip = 5;
    msize = 1;
    Addr = rand() & 0x0FFFFFFC;
    LoBits = Addr & 0x03FF;
    Bound  = LoBits + 400;
    if (Bound > 1024)
      Addr = Addr - 400;
    chip = chip << 28;
    Addr = Addr | chip;
    burst = rand() % 8;
    size = rand() % 3;
    if(sizetype[size] == "BYTE")
    {
      debug_info(" Byte Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
    else if(sizetype[size] == "HWRD")
    {
      debug_info(" Halfword Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
    else if(sizetype[size] == "WRD")
    {
      debug_info(" Word Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
  }

   /* indicates type of burst */
  for (burst = 0; burst < 8; burst++)
  {
    /* selection of chip */
    for(csel = 4; csel < 6; csel++)
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
          Sequence('w', Addr,trans0,"sin",size,0xAAAAAAAA,0);
          Sequence('r', Addr,trans0,"sin",size,0xAAAAAAAA,0);
         }
         else if(burst == 1)
         {
           if(size == 0)
            Addr = rand() & 0x37F;
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans1,"inc",size,0xBBBBBBBB,0);
           Sequence('r', Addr,trans1,"inc",size,0xBBBBBBBB,0);
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
           Sequence('w', Addr,trans2,"wr4",size,0xCCCCCCCC,0);
           Sequence('r', Addr,trans2,"wr4",size,0xCCCCCCCC,0);
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
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  #elif (INFILE == 0)
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  Data = 0x22222222;
  for(i = 0; i < 200; i++)
  {
    chip = 7 ;
    sprintf(debugstr,"Memory access from Port1 to Bank: %X", chip);
    C(debugstr);
    msize = 2;
    Addr = rand() & 0x0FFFFFFC;
    LoBits = Addr & 0x03FF;
    Bound  = LoBits + 400;
    if (Bound > 1024)
      Addr = Addr - 400;
    chip = chip << 28;
    Addr = Addr | chip;
    burst = rand() % 8;
    size = rand() % 3;
    if(sizetype[size] == "BYTE")
    {
      debug_info(" Byte Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
    else if(sizetype[size] == "HWRD")
    {
      debug_info(" Halfword Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
    else if(sizetype[size] == "WRD")
    {
      debug_info(" Word Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
  }
  
  /* indicates type of burst */
  for (burst = 0; burst < 8; burst++)
  {
    /* selection of chip */
    for(csel = 6; csel < 8; csel++)
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
          Sequence('w', Addr,trans2,"wr4",size,0x22222222,0);
          Sequence('r', Addr,trans2,"wr4",size,0x22222222,0);
         }
         else if(burst == 1)
         {
           if(size == 0)
            Addr = rand() & 0x37F;
           else if(size == 1)
            Addr = rand() & 0x37E;
           else if(size == 2)
            Addr = rand() & 0x37C;
           Addr = Addr | (chip << 28);
           Sequence('w', Addr,trans1,"inc",size,0x33333333,0);
           Sequence('r', Addr,trans1,"inc",size,0x33333333,0);
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
           Sequence('w', Addr,trans0,"sin",size,0x44444444,0);
           Sequence('r', Addr,trans0,"sin",size,0x44444444,0);
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
           Sequence('w', Addr,trans3,"in8",size,0x55555555,0);
           Sequence('r', Addr,trans3,"in8",size,0x55555555,0);
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
           Sequence('w', Addr,trans3,"wr8",size,0x66666666,0);
           Sequence('r', Addr,trans3,"wr8",size,0x66666666,0);
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
           Sequence('w', Addr,trans2,"in4",size,0x77777777,0);
           Sequence('r', Addr,trans2,"in4",size,0x77777777,0);
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
           Sequence('w', Addr,trans4,"w16",size,0x88888888,0);
           Sequence('r', Addr,trans4,"w16",size,0x88888888,0);
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
           Sequence('w', Addr,trans4,"i16",size,0x99999999,0);
           Sequence('r', Addr,trans4,"i16",size,0x99999999,0);
         }
      } /* end of size */
    } /* end of csel */
  }/*end of burst */
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000000, ,0x00000008);
  #endif;
}
/*-- --=============================== End =================================--*/
